console.log "Let's get started!"

# Make some functions on sets
cprod = (as, bs = as) -> _.flatten([a,b] for a in as for b in bs, true)
pairs = (n) -> ([a,b] for [a,b] in cprod _.range(n) when a < b)
disj  = (a,b) -> _.union(a,b).length == 4


# Describe the vertices and edges of the Petersen graph
vs = pairs 5
es = ({source: v1, target: v2} \
        for [v1, v2] in cprod _.range(vs.length) \
        when v1 < v2 and disj(vs[v1], vs[v2]))

# Start describing the d3 force layout

w = 800
h = 500

svg = d3.select("#chart").append("svg")
        .attr("width", w)
        .attr("height", h)

force = d3.layout.force()
        .charge(-1000)
        .linkDistance(30)
        .size([w, h])
        .nodes(vs)
        .links(es)
        .start()

link = svg.selectAll("line.link")
        .data(es)
        .enter().append("line")
        .attr("class", "link")
        .style("stroke-width", 3)
        .style("stroke", "red")

node = svg.selectAll("circle.node")
        .data(vs)
        .enter().append("circle")
        .attr("class", "node")
        .attr("r", 5)
        .call(force.drag)

force.on "tick", ->
        link.attr("x1", (d) -> d.source.x)
            .attr("y1", (d) -> d.source.y)
            .attr("x2", (d) -> d.target.x)
            .attr("y2", (d) -> d.target.y)

        node.attr("cx", (d) -> d.x).attr("cy", (d) -> d.y)
