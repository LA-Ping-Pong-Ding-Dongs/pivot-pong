window.pong = window.pong || {};

pong.PlayerTiles = Backbone.View.extend({
    events: {
        'click a.js': '_routeLinks',
    },

    render: function () {
        var mesh = this.renderMesh();
        this.renderTiles(mesh);
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
        this.distributePlayersAroundMesh(this.excludeCells, this.PERCENT_BLANK_TILES);
        pong.PlayerTilesBinder.setupD3Strategies(this.data, this.svg, this.hexbin);
        return this;
    },

    distributePlayersAroundMesh: function (excludeCells, percentBlankCells) {
        excludeCells = excludeCells || function () {
            return false
        };
        var centers = _(availableTileCenters(this.hexbin.centers()))
            .chain()
            .shuffle()
            .value();

        this.data = this.savedData;

        if (percentBlankCells) {
            centers = _.initial(centers, parseInt(centers.length * percentBlankCells));
        }
        centers = _.take(centers, this.data.length);

        this.data = _(_.take(this.data, centers.length)).map(function (player, index) {
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

            var notEdgeRowOrColumn = function(center) {
                return center.i != 0 && center.i != maxI &&
                    center.j != 0 && center.j != maxJ
            };

            _.each(centers, function (center) {

                if (notEdgeRowOrColumn(center) && !excludeCells(center[0], center[1])) {
                    available.push(center);
                }
            });

            return available;
        }
    },

    renderTilesOnResize: function () {
        var timeout = false;

        $(window).resize(_.bind(function () {
            if (timeout !== false)
                clearTimeout(timeout);
            timeout = setTimeout(_.bind(this.renderTiles, this), 200);
        }, this));
    },

    initialize: function (options) {
        $('.nojs-players').hide();
        this.data = this.collection.toJSON();
        this.savedData = this.data;
        this.svg = d3.select(this.el).append('svg');
        this.excludeCells = options.excludeCells;
        this.PERCENT_BLANK_TILES = 0.33;

        this.collection.on('sync', _.bind(this.render, this));
        $(window).resize(_.bind(this.renderMesh, this));
        this.renderTilesOnResize();
    },

    _routeLinks: function (e) {
        pong.navigator(e);
    },
});
