console.log "Let's get started!"

# Make some functions on sets
cprod = (as, bs = as) -> _.flatten([a,b] for a in as for b in bs, true)
pairs = (n) -> ([a,b] for [a,b] in cprod _.range(n) when a < b)
disj  = (a,b) -> _.union(a,b).length == 4

divides = (a,b) -> (Math.floor a/b) is (a/b)
mod2 = (a,b) -> a%b is 2
symmetrize = (f) -> (a,b) -> (f a, b) or (f b, a)
flip = (f) -> (b,a) -> f a, b

# Graph making functions
mkEdges = (vs, connp) ->
        edges = []
        for [i1, i2] in cprod _.range(vs.length) when i1 < i2 and connp(vs[i1], vs[i2])
                edges.push(source : i1, target: i2)
        edges

# Describe the vertices and edges of the Petersen graph
vs = _.map _.range(3, 30), (x) -> [x]
console.log vs
es = mkEdges vs, flip mod2

# Start describing the d3 force layout
w = 800
h = 700

svg = d3.select("#chart").append("svg")
        .attr("width", w)
        .attr("height", h)

force = d3.layout.force()
        .charge(-500)
        .linkDistance(120)
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

node = svg.selectAll("text.node")
        .data(vs)
        .enter().append("svg:text")
        .attr("class", "node")
        .attr("text-anchor", "middle")
        .attr("r", 5)
        .text((d) -> d[0])
        .call(force.drag)

force.on "tick", ->
        link.attr("x1", (d) -> d.source.x)
            .attr("y1", (d) -> d.source.y)
            .attr("x2", (d) -> d.target.x)
            .attr("y2", (d) -> d.target.y)
        node.attr("x", (d) -> d.x).attr("y", (d) -> d.y)
