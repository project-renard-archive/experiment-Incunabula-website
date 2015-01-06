package Incunabula;
use Mojo::Base 'Mojolicious';
use Mojolicious::Plugin::RenderFile;

use Incunabula::Model::Bibliography::Database::Zotero;

# This method will run once at server start
sub startup {
  my $self = shift;

  $self->plugin('RenderFile');

  my $config = $self->plugin('Config');
  my $zotero_model = Incunabula::Model::Bibliography::Database::Zotero
	  ->new( zotero => $self->config->{zotero_db} );
  $self->helper(zotero => sub {
	$zotero_model;
  });

  $self->helper(cache => sub {
	  $self->config->{chi};
  });

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->namespaces(['Incunabula::Controller']);
  $r->get('/')->to('root#index');
  $r->get('/api/bib/db/zotero')->to('zotero#zotero_graph');
}

1;
