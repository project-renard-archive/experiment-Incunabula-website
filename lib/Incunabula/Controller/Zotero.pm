package Incunabula::Controller::Zotero;
use Mojo::Base 'Mojolicious::Controller';
use strict;

use utf8::all;
use feature 'fc'; # make sure we can foldcase
use Graph::Directed;
use Graph::D3;
use List::UtilsBy qw(sort_by);

sub zotero_graph {
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
		my $parent_id = $coll->get_column('parentcollectionid') // 0;

		$add_vertex->( $collection_data, $parent_id );
	}

	my $d3 = Graph::D3->new( graph => $g );
	my $force_data = $d3->force_directed_graph();
	for my $node (@{$force_data->{nodes}}) {
		my $id = $node->{name};
		$node = {
			%$node,
			%{ $g->get_vertex_attributes($id) }
		};
	}
	$self->render( json => $force_data );
}

1;
