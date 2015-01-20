package Incunabula::Model::Bibliography::Database::Zotero;

use strict;
use warnings;

use Moo;
use Graph::Directed;

BEGIN {
	require Moo::Role;
	Moo::Role->apply_roles_to_package( 'Biblio::Zotero::DB::Schema::Result::Item' , qw(Incunabula::Model::Bibliography::Item::Role::Zotero) );
	Moo::Role->apply_roles_to_package( 'Biblio::Zotero::DB::Schema::Result::ItemAttachment', qw(Incunabula::Model::Document::Role::Zotero) );
}

has zotero => ( is => 'rw', required => 1 );;

#has graph_name => ( is => 'rw', required => 1 );


sub documents {
	my ($self) = @_;

	$self->zotero->schema->resultset('StoredItem')
		->with_item_attachment_resultset('StoredItemAttachment')
		->items_with_pdf_attachments
		->search({},
			{ prefetch => [
					'item_datas',
					'fulltext_item',
					{ 'item_attachments_itemid'
						=> { 'itemid' => 'fulltext_item' } },
					{ 'item_attachments_sourceitemids'
						=> { 'itemid' => 'fulltext_item' } },
				] }
		);
}


sub build_collection_graph {
	my $self = shift;
	my $g = Graph::Directed->new;
	my $add_vertex = sub {
		my ($vertex, $parent_id) = @_;
		my $id = $vertex->{zotero_id};
		$g->add_vertex( $id );
		$g->set_vertex_attributes( $id, $vertex );
		$g->add_edge($id, $parent_id) if defined $parent_id;
	};

	# root node: id 0 is not in the DB
	$add_vertex->(
		my $root = { name => 'Zotero Library',
			type => 'db-root',
			zotero_id => 0 },
		undef );

	# unfiled items: id -1 is not from the DB
	$add_vertex->(
		{ name => 'Unfiled',
			type => 'category-unfiled',
			zotero_id => '-1' },
		$root->{zotero_id} );

	# get all collections in our library (as opposed to a shared library)
	my $collections_rs = $self->zotero
		->library->collections
		->search( { libraryid => undef } );

	while (my $coll = $collections_rs->next) {
		my $collection_data = {
			name => $coll->get_column('collectionname'),
			type => 'category',
			zotero_id => $coll->get_column('collectionid'),
		};

		# if undef, then the parent is the root node
		my $parent_id = $coll->get_column('parentcollectionid')
			// $root->{zotero_id};

		$add_vertex->( $collection_data, $parent_id );
	}
	$g;
}

1;
