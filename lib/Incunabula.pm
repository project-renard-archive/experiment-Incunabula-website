package Incunabula;
use Mojo::Base 'Mojolicious';
use Mojolicious::Plugin::RenderFile;

# This method will run once at server start
sub startup {
  my $self = shift;

  $self->plugin('RenderFile');

  my $config = $self->plugin('Config');
  $self->helper(zotero => sub {
	  $self->config->{zotero_db};
  });

  $self->helper(cache => sub {
	  $self->config->{chi};
  });

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->namespaces(['Incunabula::Controller']);
  $r->get('/')->to('root#index');
}

1;
