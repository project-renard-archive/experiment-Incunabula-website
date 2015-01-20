package Incunabula::Model::Document::Role::PagedDocument;

use strict;
use warnings;

use Moo::Role;

has number_of_pages => ( is => 'lazy' );


1;
