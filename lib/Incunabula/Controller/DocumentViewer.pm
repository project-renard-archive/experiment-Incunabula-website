package Incunabula::Controller::DocumentViewer;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw(decode_json);

sub index {
  my $self = shift;

  # an JSON document URL from NYTimes
  my $json_url = 'http://documents.nytimes.com/goldman-sachs-internal-emails.json';

  my $ua = Mojo::UserAgent->new;
  my $j = $ua->get( $json_url );
  my $json_data = decode_json($j->res->body);

  # need to match the ID with the JSON document URL basename
  $json_data->{id} = "document-test";

  $self->render(json => $json_data );
}

1;

