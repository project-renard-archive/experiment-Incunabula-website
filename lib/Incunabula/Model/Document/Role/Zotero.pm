package Incunabula::Model::Document::Role::Zotero;

use strict;
use warnings;
use Moo::Role;
use Path::Class::URI ();

# TODO: only if it is a PDF (metarole)
with qw(Incunabula::Model::Document::Role::PDF::pdfinfo);

sub is_local {
	my ($self) = @_;
	$self->uri->scheme eq 'file';
}

around _build_number_of_pages => sub {
	my $orig = shift;
	my $self = shift;
	my $ft_info = $self->itemid->fulltext_item;
	if( $ft_info ) {
		# TODO check the date: datemodified?
		return $ft_info->totalpages;
	}

	# otherwise, use the usual metadata
	return $orig->($self, @_);
};

sub filepath {
	my ($self) = @_;
	my $uri = $self->uri;
	return Path::Class::URI::file_from_uri( $uri );
}

1;
