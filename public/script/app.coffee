define ["module", "d3"], (module, d3) ->
  class app
    constructor: ->
      1
      # from <http://bl.ocks.org/mbostock/4062045>
      `
var width = 960,
    height = 500;

var color = d3.scale.category20();

var force = d3.layout.force()
    .charge(-240)
    .linkDistance(200)
    .size([width, height]);

var svg = d3.select("body").append("svg")
    .attr("width", width)
    .attr("height", height);

// d3.json("miserables.json", function(error, graph) {
d3.json("/api/bib/db/zotero", function(error, graph) {
  var total = graph.nodes.length || 1;
  force
      .nodes(graph.nodes)
      .links(graph.links)
      //.gravity(Math.atan(total / 50) / Math.PI * 0.4)
      .start();

  var link = svg.selectAll(".link")
      .data(graph.links)
    .enter().append("line")
      .attr("class", "link")
      .style("stroke-width", function(d) { return Math.sqrt(d.value); });

  var node = svg.selectAll(".node")
      .data(graph.nodes)
    .enter().append("circle")
      .attr("class", "node")
      .attr("class", function(d) { return d.type } )
      .attr("r", 5)
      .style("fill", function(d) { return color(d.type); })
      .call(force.drag);

  var texts = svg.selectAll("text.label")
                .data(graph.nodes)
                .enter().append("text")
                .attr("class", "label")
                .attr("fill", "black")
                .text(function(d) {  return d.name;  })

  node.append("title")
      .text(function(d) { return d.name; });

  force.on("tick", function() {
    link.attr("x1", function(d) { return d.source.x; })
        .attr("y1", function(d) { return d.source.y; })
        .attr("x2", function(d) { return d.target.x; })
        .attr("y2", function(d) { return d.target.y; });

    node.attr("cx", function(d) { return d.x; })
        .attr("cy", function(d) { return d.y; });

    texts.attr("transform", function(d) {
        return "translate(" + d.x + "," + d.y + ")";
    });
  });
});

`
