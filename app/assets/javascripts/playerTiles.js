window.pong = window.pong || {};

pong.PlayerTiles = Backbone.View.extend({

    render: function() {
        this.renderMesh();
        this.renderTiles();
    },

    renderMesh: function () {
        calculateNewHexbin.apply(this);
        appendHexMesh.apply(this);
        return this;

        function calculateNewHexbin() {
            this.hexbin = d3.hexbin();
            this.hexbin.size([window.innerWidth, window.innerHeight]).radius(100);
        }

        function appendHexMesh() {
            var mesh = this.svg.selectAll('.mesh');

            if (mesh.empty()) {
                this.svg.append('path')
                    .attr('class', 'mesh')
                    .attr('d', this.hexbin.mesh);
            } else {
                mesh.attr('d', this.hexbin.mesh);
            }
        }
    },

    renderTiles: function () {
        this.distributePlayersAroundMesh();
        joinPlayerDataToDom.apply(this);

        return this;

        function joinPlayerDataToDom() {
            var keyFunctions = {
                column: function (d) {
                    return d.i;
                },
                row: function (d) {
                    return d.j;
                },
                location: function (d) {
                    return  d.location;
                },
                name: function (d) {
                    if (d.name.length > 8) {
                        return $.trim(d.name).substring(0, 8).trim(this) + '...';
                    } else {
                        return d.name;
                    }
                },
                url: function (d) {
                    return d.url;
                },
                mean: function (d) {
                    return d.mean;
                },
                color: _.bind(function (d) {
                    return this.colorize(d);
                }, this),
                translate: function (d) {
                    return 'translate(' + d.i + ',' + d.j + ')';
                },
            };

            var anchorGroups = this.svg.selectAll('g.player-ranking')
                .data(this.data, keyFunctions.location);

            var newAnchorGroups = anchorGroups.enter()
                .append('g').attr('class', 'player-ranking');
            newAnchorGroups
                .style('opacity', 0)
                .transition()
                .duration(1000)
                .style('opacity', 1);
            newAnchorGroups
                .append('a')
                .classed('hex-o-link', true)
                .classed('color1', function(d) { return keyFunctions.color(d) === 'color1'; })
                .classed('color2', function(d) { return keyFunctions.color(d) === 'color2'; })
                .classed('color3', function(d) { return keyFunctions.color(d) === 'color3'; })
                .classed('color4', function(d) { return keyFunctions.color(d) === 'color4'; })
                .classed('color5', function(d) { return keyFunctions.color(d) === 'color5'; })
                .attr('xlink:href', keyFunctions.url)
                .attr('xlink:title', keyFunctions.name)
                .append('path')
                .attr('d', this.hexbin.hexagon())
                .attr('transform', keyFunctions.translate);
            newAnchorGroups
                .append('a')
                .classed('hex-o-text', true)
                .attr('xlink:href', keyFunctions.url)
                .attr('xlink:title', keyFunctions.name)
                .append('text')
                .attr('x', keyFunctions.column)
                .attr('y', keyFunctions.row)
                .attr('dy', '-20')
                .attr('text-anchor', 'middle')
                .text(keyFunctions.name);
            newAnchorGroups
                .append('a')
                .classed('hex-o-text', true)
                .attr('xlink:href', keyFunctions.url)
                .attr('xlink:title', keyFunctions.mean)
                .append('text')
                .attr('x', keyFunctions.column)
                .attr('y', keyFunctions.row)
                .attr('dy', '20')
                .attr('text-anchor', 'middle')
                .text(keyFunctions.mean);

            anchorGroups.exit()
                .transition()
                .duration(1000)
                .style('opacity', 0)
                .remove();
        }
    },

    distributePlayersAroundMesh: function () {
        var centers = _(availableTileCenters(this.hexbin.centers()))
            .chain()
            .shuffle()
            .take(this.data.length)
            .value();

        this.data = _(this.data).map(function (player, index) {
            var column = centers[index][0];
            var row = centers[index][1];
            player = _.clone(player);

            return _.extend(player, {
                i: column,
                j: row,
                location: '' + column + ',' + row,
            });
        });

        function availableTileCenters(centers) {
            var available = [];
            maxI = _.max(centers, function(center) { return center.i; }).i;
            maxJ = _.max(centers, function(center) { return center.j; }).j;

            _.each(centers, function (center) {
                if (center.i != 0 && center.i != maxI && center.j != 0 && center.j != maxJ) {
                    available.push(center);
                }
            });

            return available;
        }
    },

    colorize: function (d) {
        var colorClasses = ['color1', 'color2', 'color3', 'color4', 'color5'];
        var index = Math.floor((d.i + d.j) % 5);
        return colorClasses[index];
    },

    initialize: function (options) {
        this.data = this.collection.toJSON();
        this.svg = d3.select(this.el).append('svg');

        this.collection.on('sync', _.bind(this.render, this));
        $(window).resize(_.bind(this.renderMesh, this));
        $(window).resize(_.debounce(_.bind(this.renderTiles, this), 500, true));
    },

});
