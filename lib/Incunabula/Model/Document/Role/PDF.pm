package Incunabula::Model::Document::Role::PDF;

use strict;
use warnings;

use Moo::Role;

with qw(Incunabula::Model::Document::Role::PagedDocument);

sub get_page_as_png {
	...
}

1;
