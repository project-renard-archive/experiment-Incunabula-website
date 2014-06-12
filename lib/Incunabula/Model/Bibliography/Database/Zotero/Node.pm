package Incunabula::Model::Bibliography::Database::Zotero::Node;

use strict;
use Moo::Role;

# DBIx::Class::Core
requires 'table';

sub outgoing {

}

sub incoming {
  my ($self) = @_;
  if( $self->table eq 'collection' ) {
    # get all child collections and 
  }
}

1;
