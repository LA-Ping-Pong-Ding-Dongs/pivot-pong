window.pong = window.pong || {};

pong.PlayerTiles = Backbone.View.extend({

    render: function () {
        this.svg = d3.select(this.el).append('svg');
        this.appendHexMeshToDOMElement(this.svg);
        this.distributePlayersAroundMesh();
        this.appendPlayerAnchorsToDOMElement(this.svg);
    },

    appendHexMeshToDOMElement: function (element) {
        element.append('path')
            .attr('class', 'mesh')
            .attr('d', this.hexbin().mesh);
    },

    distributePlayersAroundMesh: function () {
        var centers = _(this.hexbin().centers())
            .chain()
            .rest(10)
            .shuffle()
            .take(this.data.length)
            .value();

        _(this.data).each(function (player, index) {
            player.i = centers[index][0];
            player.j = centers[index][1];
        }, this);
    },

    appendPlayerAnchorsToDOMElement: function (element) {
        // bind data to anchors and select any already in the page
        var anchorGroups = element.append('g')
            .selectAll('g.player-ranking')
            .data(this.data, function (d) {
                return d.name;
            });

        // add any anchors that we don't already have
        anchorGroups.enter().append('g').attr('class', 'player-ranking');
        this.appendPlayerHexAnchorToDOMElement(anchorGroups);
        this.appendPlayerNameAnchorToDOMElement(anchorGroups);

        // remove extraneous anchors
        anchorGroups.exit().remove();
    },

    appendPlayerHexAnchorToDOMElement: function (element) {
        element
            // add svg anchor element
            .append('a')
//            .attr('class', 'hex-o-link')
            .attr('class', function (d) {
                var colorClasses = ['color1', 'color2', 'color3', 'color4', 'color5'];
                var index = Math.floor((d.i + d.j)%5);
                return colorClasses[index] + ' hex-o-link';
            })
            .attr('xlink:href', function (d) {
                return d.url;
            })
            .attr('xlink:title', function (d) {
                return d.name;
            })
            // append path that defines the anchor shape
            .append('path')
            .attr('d', this.hexbin().hexagon())
            .attr('transform', function (d) {
                return 'translate(' + d.i + ',' + d.j + ')';
            });
    },

    appendPlayerNameAnchorToDOMElement: function (element) {
        var anchor = element
            // add svg anchor element
            .append('a')
            .attr('class', 'hex-o-text')
            .attr('xlink:href', function (d) {
                return d.url;
            })
            .attr('xlink:title', function (d) {
                return d.name;
            });
            // append text of Player's name
        var name = anchor.append('text')
            .attr('x', function (d) {
                return d.i
            })
            .attr('y', function (d) {
                return d.j
            })
            .attr('dy', '-20')
            .attr('text-anchor', 'middle')
            .text(function (d) {
                return d.name;
            });
        var mean = anchor.append('text')
            .attr('x', function (d) {
                return d.i
            })
            .attr('y', function (d) {
                return d.j
            })
            .attr('dy', '20')
            .attr('text-anchor', 'middle')
            .text(function (d) {
                return d.mean;
            });
    },

    initialize: function (options) {
        this.data = options.data;


        this.hexbin();
        this.render();
    },

    hexbin: function () {
        if (typeof this._hexbin === 'undefined') {
            this._hexbin = d3.hexbin();
            this._hexbin.size([window.innerWidth, window.innerHeight * 0.8]).radius(100);
        }
        return this._hexbin;
    },

});
