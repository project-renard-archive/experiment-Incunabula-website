use Test::More;

use strict;
use warnings;

use Incunabula::Model::Bibliography::Database::Zotero;
use Try::Tiny;
use utf8::all;

my $config = do 'incunabula.conf';

my $zotero_model = Incunabula::Model::Bibliography::Database::Zotero->new( zotero => $config->{zotero_db} );

my $items = $zotero_model->documents;
#$items->result_class('DBIx::Class::ResultClass::HashRefInflator');
#my @data = $items->all;
#die "test";
#use DDP; p @data;
my @missing_pdf;
while( my $i = $items->next ) {
	#use DDP; p $i->media->[0]->DOES('Incunabula::Model::Document::Role::Zotero');
	if ( $i->media->[0]->is_local ) {
		my $file = $i->media->[0]->filepath;

		my $data = {
			title => $i->title,
			filepath => $file->stringify,
		};

		my $success = try {
			$data->{pages} = $i->media->[0]->number_of_pages;
			1;
		} catch {
			warn $_;
			push @missing_pdf, $data;
			return; # undef on failure
		};
		next unless $success;

		use DDP; p $data;
	}
}
use DDP; p @missing_pdf;



