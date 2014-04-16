window.pong = window.pong || {};

pong.PlayerTilesBinder = {
    setupD3Strategies: function(data, canvas, hexbin) {
        var tileContainerAttrs = {el: 'g', cssClass: 'player-ranking'};
        var datumGetters = this.datumGetters;
        var updateGroup = canvas
            .selectAll(tileContainerAttrs.el+'.'+tileContainerAttrs.cssClass)
            .data(data, this.datumGetters.location);

        var enterGroup = updateGroup.enter();
        var exitGroup = updateGroup.exit();

        this.bindEnterState(enterGroup, hexbin, tileContainerAttrs, datumGetters);
        this.bindUpdateState(updateGroup, hexbin, datumGetters);
        this.bindExitState(exitGroup);
    },

    bindEnterState: function(enterGroup, hexbin, tileContainerAttrs, datumGetters) {
        var tileContainers = createTileContainers(enterGroup,
            tileContainerAttrs.el,
            tileContainerAttrs.cssClass);

        fadeInTiles(tileContainers);
        appendTileAnchors(tileContainers, hexbin, datumGetters);
        appendNameAnchors(tileContainers, datumGetters);
        appendScoreAnchors(tileContainers, datumGetters);

        function createTileContainers(enterGroup, elementName, cssClass) {
            return enterGroup
                .append(elementName)
                .attr('class', cssClass);
        }

        function fadeInTiles(tileContainers) {
            tileContainers
                .style('opacity', 0)
                .transition()
                .duration(1000)
                .style('opacity', 1);
        }

        function appendTileAnchors(tileContainers, hexbin, datumGetters) {
            tileContainers
                .append('a')
                .classed('hex-o-link js tile', true)
                .classed('color1', function(d) { return datumGetters.color(d) === 'color1'; })
                .classed('color2', function(d) { return datumGetters.color(d) === 'color2'; })
                .classed('color3', function(d) { return datumGetters.color(d) === 'color3'; })
                .classed('color4', function(d) { return datumGetters.color(d) === 'color4'; })
                .classed('color5', function(d) { return datumGetters.color(d) === 'color5'; })
                .attr('xlink:href', datumGetters.url)
                .attr('xlink:title', datumGetters.name)
                .append('path')
                .attr('d', hexbin.hexagon())
                .attr('transform', datumGetters.translate);
        }

        function appendNameAnchors(tileContainers, datumGetters) {
            tileContainers
                .append('a')
                .classed('hex-o-text js name', true)
                .attr('xlink:href', datumGetters.url)
                .attr('xlink:title', datumGetters.name)
                .append('text')
                .attr('x', datumGetters.column)
                .attr('y', datumGetters.row)
                .attr('dy', '-20')
                .attr('text-anchor', 'middle')
                .text(datumGetters.name);
        }

        function appendScoreAnchors(tileContainers, datumGetters) {
            tileContainers
                .append('a')
                .classed('hex-o-text js score', true)
                .attr('xlink:href', datumGetters.url)
                .attr('xlink:title', datumGetters.mean)
                .append('text')
                .attr('x', datumGetters.column)
                .attr('y', datumGetters.row)
                .attr('dy', '20')
                .attr('text-anchor', 'middle')
                .text(datumGetters.mean);
        }
    },


    bindUpdateState: function(updateGroup, hexbin, datumGetters) {
        updateTileAnchors(updateGroup, hexbin, datumGetters);
        updateNameAnchors(updateGroup, datumGetters);
        updateScoreAnchors(updateGroup, datumGetters);

        function updateTileAnchors(updateGroup, hexbin, datumGetters) {
           updateGroup
                .select('a.tile')
                .classed('color1', function(d) { return datumGetters.color(d) === 'color1'; })
                .classed('color2', function(d) { return datumGetters.color(d) === 'color2'; })
                .classed('color3', function(d) { return datumGetters.color(d) === 'color3'; })
                .classed('color4', function(d) { return datumGetters.color(d) === 'color4'; })
                .classed('color5', function(d) { return datumGetters.color(d) === 'color5'; })
                .attr('xlink:href', datumGetters.url)
                .attr('xlink:title', datumGetters.name)
                .select('path')
                .attr('d', hexbin.hexagon())
                .attr('transform', datumGetters.translate);
        }

        function updateNameAnchors(updateGroup, datumGetters) {
            updateGroup
                .select('a.name')
                .attr('xlink:href', datumGetters.url)
                .attr('xlink:title', datumGetters.name)
                .select('text')
                .attr('x', datumGetters.column)
                .attr('y', datumGetters.row)
                .attr('dy', '-20')
                .attr('text-anchor', 'middle')
                .text(datumGetters.name);
        }

        function updateScoreAnchors(updateGroup, datumGetters) {
            updateGroup
                .select('a.score')
                .attr('xlink:href', datumGetters.url)
                .attr('xlink:title', datumGetters.mean)
                .select('text')
                .attr('x', datumGetters.column)
                .attr('y', datumGetters.row)
                .attr('dy', '20')
                .attr('text-anchor', 'middle')
                .text(datumGetters.mean);
        }
    },

    bindExitState: function(exitGroup) {
        fadeOutTiles(exitGroup);
        removeTiles(exitGroup);

        function fadeOutTiles(exitGroup) {
            exitGroup.transition()
                .duration(1000)
                .style('opacity', 0);
        }

        function removeTiles(exitGroup) {
            exitGroup.remove();
        }
    },

    datumGetters: {
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
            var colorClasses = ['color1', 'color2', 'color3', 'color4', 'color5'];
            var index = Math.floor((d.i + d.j) % 5);
            return colorClasses[index];
        }, this),
        translate: function (d) {
            return 'translate(' + d.i + ',' + d.j + ')';
        },
    },
}
