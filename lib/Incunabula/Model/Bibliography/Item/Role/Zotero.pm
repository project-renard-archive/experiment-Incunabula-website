package Incunabula::Model::Bibliography::Item::Role::Zotero;

use strict;
use warnings;

use Moo::Role;

use constant MIMETYPE_PDF => 'application/pdf';

has media => ( is => 'lazy' );

has title => ( is => 'lazy' );

sub _build_title {
	my ($self) = @_;
	$self->fields->{title} // undef;
}

sub _build_media {
	my ($self) = @_;
	my @attachments;

	if ( $self->is_attachment ) {
		my $item_attachment = $self->item_attachments_itemid;
		@attachments = ( $item_attachment ) if $item_attachment->mimetype eq MIMETYPE_PDF;
	} else {
		@attachments = $self->stored_item_attachments_sourceitemids
			->search( { mimetype => MIMETYPE_PDF } )->all ;
	}

	Moo::Role->apply_roles_to_object( $_, qw(Incunabula::Model::Document::Role::Zotero Incunabula::Model::Document::Role::PDF ) ) for @attachments;

	\@attachments;
}

1;
