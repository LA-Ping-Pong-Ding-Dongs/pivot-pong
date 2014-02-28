window.pong = window.pong || {};

pong.PlayerTiles = Backbone.View.extend({

    render: function() {
        this.hexbin = d3.hexbin();
        this.hexbin.size([window.innerWidth, window.innerHeight * 0.8]).radius(100);

        function color (length) {
            return length %3 == 0 ? 'red' : 'cornflowerblue';
        }
        this.svg = d3.select(this.el).append('svg');
        this.svg.append("path")
            .attr("class", "mesh")
            .attr("d", this.hexbin.mesh);

        this.centers = this.hexbin.centers();

        _(this.centers).each(function(center, index) {
            if (index < this.data.length) {
                center.player = this.data[index];
                center.class = 'hex-o-link';
            } else {
                center.player = { name: '', url: '' };
                center.class = 'hex-o'
            }
        }, this);

        this.anchor = this.svg.append("g")
            .attr("class", "example-anchor")
            .selectAll("a")
            .data(this.centers, function (d) { return d.i + "," + d.j; });

        this.anchor.exit().remove();
        this.anchor.enter()
            .append("a")
            .attr('class', function(d) { return d.class })
            .attr("xlink:href", function(d) { return d.player.url; })
            .attr("xlink:title", function(d) { return d.player.name; })
            .append("path")
            .attr("d", this.hexbin.hexagon())
            .attr("transform", function(d) { return "translate(" + d + ")"; });
        this.anchor.enter()
            .append("text")
            .text( function(d) {return d.player.name})

    },

    initialize: function(options) {
        this.data = options.data;

        this.data.forEach(function(d, i) {
            d.i = i % 10;
            d.j = i / 10 | 0;
        });
        this.render();
    },
});
