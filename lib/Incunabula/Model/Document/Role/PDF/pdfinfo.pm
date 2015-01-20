package Incunabula::Model::Document::Role::PDF::pdfinfo;

use strict;
use warnings;
use Moo::Role;
use Biblio::Document::Information::Extraction::Util::pdfinfo;

requires 'filepath';

sub _build_number_of_pages {
	my ($self) = @_;

	my $info = Biblio::Document::Information::Extraction::Util::pdfinfo->pdfinfo( file => $self->filepath );

	return $info->{Pages};
}

1;
