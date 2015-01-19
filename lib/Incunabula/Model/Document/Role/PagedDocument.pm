package Incunabula::Model::Document::Role::PagedDocument;

use strict;
use warnings;

use Moo::Role;

has pages => ( is => 'lazy' );


1;
