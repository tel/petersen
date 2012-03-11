(function() {
  var cprod, disj, divides, es, force, h, link, mkEdges, mod2, node, pairs, svg, vs, w;

  console.log("Let's get started!");

  cprod = function(as, bs) {
    var a, b;
    if (bs == null) bs = as;
    return _.flatten((function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = bs.length; _i < _len; _i++) {
        b = bs[_i];
        _results.push((function() {
          var _j, _len2, _results2;
          _results2 = [];
          for (_j = 0, _len2 = as.length; _j < _len2; _j++) {
            a = as[_j];
            _results2.push([a, b]);
          }
          return _results2;
        })());
      }
      return _results;
    })(), true);
  };

  pairs = function(n) {
    var a, b, _i, _len, _ref, _ref2, _results;
    _ref = cprod(_.range(n));
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      _ref2 = _ref[_i], a = _ref2[0], b = _ref2[1];
      if (a < b) _results.push([a, b]);
    }
    return _results;
  };

  disj = function(a, b) {
    return _.union(a, b).length === 4;
  };

  divides = function(a, b) {
    return (Math.floor(a / b)) === (a / b);
  };

  mod2 = function(a, b) {
    return b % a === 2;
  };

  mkEdges = function(vs, connp) {
    var edges, i1, i2, _i, _len, _ref, _ref2;
    edges = [];
    _ref = cprod(_.range(vs.length));
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      _ref2 = _ref[_i], i1 = _ref2[0], i2 = _ref2[1];
      if (i1 < i2 && connp(vs[i1], vs[i2])) {
        edges.push({
          source: i1,
          target: i2
        });
      }
    }
    return edges;
  };

  vs = _.map(_.range(3, 30), function(x) {
    return [x];
  });

  es = mkEdges(vs, mod2);

  w = 800;

  h = 700;

  svg = d3.select("#chart").append("svg").attr("width", w).attr("height", h);

  force = d3.layout.force().charge(-500).linkDistance(120).size([w, h]).nodes(vs).links(es).start();

  link = svg.selectAll("line.link").data(es).enter().append("line").attr("class", "link").style("stroke-width", 3).style("stroke", "red");

  node = svg.selectAll("text.node").data(vs).enter().append("text").attr("class", "node").attr("text-anchor", "middle").text(function(d) {
    return d[0];
  }).call(force.drag);

  force.on("tick", function() {
    link.attr("x1", function(d) {
      return d.source.x;
    }).attr("y1", function(d) {
      return d.source.y;
    }).attr("x2", function(d) {
      return d.target.x;
    }).attr("y2", function(d) {
      return d.target.y;
    });
    return node.attr("x", function(d) {
      return d.x;
    }).attr("y", function(d) {
      return d.y;
    });
  });

}).call(this);
