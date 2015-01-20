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

sub get_json_for_pdf {
	my $data = {
		sections => [],
		pages => $num_of_pages,
		id => $id,
		title => $title,
		description => $abstract,
		resources => {
			"page" => {
				"image" => "http://s3.amazonaws.com/nytdocs/docs/322/pages/322-p{page}-{size}.gif",
				"text" => "http://documents.nytimes.com/goldman-sachs-internal-emails/pages/p{page}.txt"
			},
			"related_story" => "http://www.nytimes.com/2010/04/25/business/25goldman.html",
			"pdf" => "http://s3.amazonaws.com/nytdocs/docs/322/322.pdf",
			"search" => "http://documents.nytimes.com/goldman-sachs-internal-emails/search.json?q={query}"
		},
	};
}

1;

