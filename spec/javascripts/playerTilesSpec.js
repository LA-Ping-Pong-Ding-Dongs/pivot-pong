describe('PlayerTiles', function () {
    beforeEach(function () {
        this.playerData = [
            { name: 'Johnny', mean: 1200, url: '/players/johnny' },
            { name: 'Mark', mean: 1580, url: '/players/mark' },
        ];
        this.renderMeshSpy = spyOn(pong.PlayerTiles.prototype, 'renderMesh');
        this.renderTilesSpy = spyOn(pong.PlayerTiles.prototype, 'renderTiles');
        this.renderTilesOnResizeSpy = spyOn(pong.PlayerTiles.prototype, 'renderTilesOnResize');

        this.view = new pong.PlayerTiles({ collection: new Backbone.Collection(this.playerData) });
    });

    describe('initialize', function () {
        it('saves data options', function () {
            expect(this.view.data).toEqual(this.playerData);
        });

        it('calls render functions for resize', function () {
            $(window).trigger('resize');

            expect(this.renderMeshSpy).toHaveBeenCalled();
            expect(this.renderTilesOnResizeSpy).toHaveBeenCalled();
        });
    });

    describe('renderTilesOnResize', function () {
        it('calls renderTiles after a delayed resize detection', function () {
            jasmine.clock().install();
            $(window).trigger('resize');
            jasmine.clock().tick(201);
            expect(this.renderTilesSpy).toHaveBeenCalled();
            jasmine.clock().uninstall();
        });
    });

    describe('render', function () {
        it('renders the mesh and player tiles', function () {
            this.view.render();

            expect(this.renderMeshSpy).toHaveBeenCalled();
            expect(this.renderTilesSpy).toHaveBeenCalled();
        });
    });

    describe('distributePlayersAroundMesh', function () {
        beforeEach(function () {
            var centerValues = [
                [5,5], [15,5], [25,5], [35,5],
                [5,15], [15,15], [25,15], [35,15],
                [5,25], [15,25], [25,25], [35,25],
                [5,35], [15,35], [25,35], [35,35],
            ];
            _.each(centerValues, function(center, index) {
                center['i'] = index % 4;
                center['j'] = Math.floor(index / 4);
            });

            var hexbin = jasmine.createSpyObj('hexbin', ['centers']);
            hexbin.centers = function() { return centerValues; };
            this.view.hexbin = hexbin;

            //need to override underscore's shuffling
            spyOn(_.prototype, 'shuffle').and.callFake(function(obj) { return _.chain(this._wrapped); });
        });

        it('maps player data to non-edge centers', function () {
            this.view.distributePlayersAroundMesh();

            expect(this.view.data).toEqual([
                { name: 'Johnny', mean: 1200, url: '/players/johnny', i: 15, j: 15, location: '15,15' },
                { name: 'Mark', mean: 1580, url: '/players/mark', i: 25, j: 15, location: '25,15' },
            ]);
        });

        it('avoids centers that should be excluded', function () {
            this.view.distributePlayersAroundMesh(function (x, y) {return y == 15});
            expect(this.view.data).toEqual([
                { name: 'Johnny', mean: 1200, url: '/players/johnny', i: 15, j: 25, location: '15,25' },
                { name: 'Mark', mean: 1580, url: '/players/mark', i: 25, j: 25, location: '25,25' },
            ]);
        });

        it('stops distributing hexbins before all available bins are full', function () {
            this.view.distributePlayersAroundMesh(function (x, y) {return false}, 0.75);
            expect(this.view.data).toEqual([
                { name: 'Johnny', mean: 1200, url: '/players/johnny', i: jasmine.any(Number), j: jasmine.any(Number), location: jasmine.any(String) },
            ]);
        });
    });

    describe('colorize', function () {
        it('picks a color based on the tiles location', function () {
            var colorSelectors = [
                { val: 0, color: 'color1' },
                { val: 1, color: 'color2' },
                { val: 2, color: 'color3' },
                { val: 3, color: 'color4' },
                { val: 4, color: 'color5' },
            ];

            _.each(colorSelectors, _.bind(function(colorSelector) {
                expect(this.view.colorize({ i: 0, j: colorSelector.val })).toEqual(colorSelector.color);
            }, this));
        });
    });
});