<!DOCTYPE html>
<meta charset="utf-8">
<style>

.line {
  fill: none;
  stroke: steelblue;
  stroke-width: 2px;
}
path { 
    stroke: steelblue;
    stroke-width: 2;
    fill: none;
}
</style>
<body>
<script src="res/d3/d3.js"></script>
<script>

var margin = {top: 20, right: 20, bottom: 30, left: 50},
    width = 960 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

var x = d3.scaleTime().range([0, width]);
var y = d3.scaleLinear().range([height, 0]);

var valueline = d3.line()
    .x(function(d) { return x(d.id); })
    .y(function(d) { return y(d.score); });

var svg = d3.select("body").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform",
          "translate(" + margin.left + "," + margin.top + ")");

d3.csv("data.csv", function(error, data) {
  if (error) throw error;

  data.forEach(function(d) {
      d.id = +d.id;
      d.score = +d.score;
  });

  x.domain(d3.extent(data, function(d) { return d.id; }));
  y.domain([0, d3.max(data, function(d) { return d.score; })]);
    
  svg.append("path")
      .attr("class", "line")
      .attr("d", valueline(data));

  svg.selectAll("dot")
      .data(data)
    .enter().append("circle")
      .attr("r", 1)
      .attr("cx", function(d) { return x(d.id); })
      .attr("cy", function(d) { return y(d.score); });

  // Axes
  svg.append("g")
      .attr("transform", "translate(0," + height + ")")
      .call(d3.axisBottom(x));

  svg.append("g")
      .call(d3.axisLeft(y));

});

</script>
</body>
