package Incunabula::Model::Document::PDF;

use strict;
use warnings;

has number_of_pages => ( is => 'ro' );

has filename => ( is => 'lazy' );

sub get_page_as_png {

}


1;
