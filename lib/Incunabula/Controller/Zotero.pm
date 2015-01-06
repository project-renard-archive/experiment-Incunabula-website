package Incunabula::Controller::Zotero;
use Mojo::Base 'Mojolicious::Controller';
use strict;

use utf8::all;
use feature 'fc'; # make sure we can foldcase
use Graph::D3;
use List::UtilsBy qw(sort_by);

sub root_node {

}

sub category_node {

}

sub category_node_children {

}

sub node_children {

}

sub zotero_graph {
	my $self = shift;
	my $g = $self->zotero->build_collection_graph;
	my $force_data = $self->as_d3_force_directed_graph( $g );
	#my $cytoscape_data = $self->as_cytoscapejs_graph( $g );
	$self->render( json => $force_data );
}

sub as_cytoscapejs_graph {
	my ($self, $graph) = @_;
	my @data;
	my @v = $graph->vertices;
	for my $vertex (@v) {
		push @data, { data => {
				id => "n$vertex",
				%{ $graph->get_vertex_attributes($vertex) },
			}, group => 'nodes' };
	}

	my @e = $graph->edges;
	my $edge_id = 0;
	for my $edge (@e) {
		push @data, { data => { id => "e$edge_id",
				source => "n$edge->[0]",
				target => "n$edge->[1]",},
			group => 'edges' };
		$edge_id++;
	}

	\@data;
}

sub as_d3_force_directed_graph {
	my ($self, $graph) = @_;
	my $d3 = Graph::D3->new( graph => $graph );
	my $force_data = $d3->force_directed_graph();
	for my $node (@{$force_data->{nodes}}) {
		my $id = $node->{name};
		$node = {
			%$node,
			%{ $graph->get_vertex_attributes($id) }
		};
	}
	$force_data;
}

1;
