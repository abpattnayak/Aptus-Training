<%@ page import="javax.servlet.http.HttpServlet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script charset="utf-8" type="text/javascript" src="res/d3/d3.js"></script>
<style>
#graph {
    width: 900px;
    height: 500px;
}
.tick line {
    stroke-dasharray: 2 2 ;
    stroke: #ccc;
}
</style>
<title>D3</title>
</head>
<body>
	<div id="graph"></div>
	<script>
		
	!(function(){
	    "use strict"
	    
	    var width,height
	    var chartWidth, chartHeight
	    var margin
	    var svg = d3.select("#graph").append("svg")
	    var axisLayer = svg.append("g").classed("axisLayer", true)
	    var chartLayer = svg.append("g").classed("chartLayer", true)
	    
	    var xScale = d3.scaleBand()
	    var yScale = d3.scaleLinear()
	    
	    d3.csv("data.csv", cast,  main)
	    
	    function cast(d) {
	        d.id = +d.id
	        d.score = +d.score
	        return d 
	    }
	    
	    function main(data) {
	        setSize(data)
	        drawAxis()
	        drawChart(data)    
	    }
	    
	    function setSize(data) {
	        width = document.querySelector("#graph").clientWidth
	        height = document.querySelector("#graph").clientHeight
	    
	        margin = {top:0, left:100, bottom:40, right:0 }
	        
	        
	        chartWidth = width - (margin.left+margin.right)
	        chartHeight = height - (margin.top+margin.bottom)
	        
	        svg.attr("width", width).attr("height", height)
	        
	        axisLayer.attr("width", width).attr("height", height)
	        
	        chartLayer
	            .attr("width", chartWidth)
	            .attr("height", chartHeight)
	            .attr("transform", "translate("+[margin.left, margin.top]+")")
	            
	            
	        xScale.domain(data.map(function(d){ return d.id })).range([0, chartWidth])
	            .paddingInner(0.1)
	            .paddingOuter(0.5)
	            
	        yScale.domain([0, d3.max(data, function(d){ return d.score})]).range([chartHeight, 0])
	            
	    }
	    
	    function drawChart(data) {
	        var t = d3.transition()
	            .duration(1000)
	            .ease(d3.easeLinear)
	            .on("start", function(d){ console.log("transiton start") })
	            .on("end", function(d){ console.log("transiton end") })
	        
	        var bar = chartLayer.selectAll(".bar").data(data)
	        
	        bar.exit().remove()
	        
	        bar.enter().append("rect").classed("bar", true)
	            .merge(bar)
	            .attr("fill", "blue")
	            .attr("width", xScale.bandwidth())
	            .attr("height", 0)
	            .attr("transform", function(d){ return "translate("+[xScale(d.id), chartHeight]+")"})
	            
	        chartLayer.selectAll(".bar").transition(t)
	            .attr("height", function(d){ return chartHeight - yScale(d.score) })
	            .attr("transform", function(d){ return "translate("+[xScale(d.id), yScale(d.score)]+")"})
	    }
	    
	    function drawAxis(){
	        var yAxis = d3.axisLeft(yScale)
	            .tickSizeInner(-chartWidth)
	        
	        axisLayer.append("g")
	            .attr("transform", "translate("+[margin.left, margin.top]+")")
	            .attr("class", "axis y")
	            .call(yAxis);
	            
	        var xAxis = d3.axisBottom(xScale)
	    
	        axisLayer.append("g")
	            .attr("class", "axis x")
	            .attr("transform", "translate("+[margin.left, chartHeight]+")")
	            .call(xAxis);
	        
	    }    
	    
	}());	
	</script>
</body>
</html>