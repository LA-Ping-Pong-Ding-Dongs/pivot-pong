describe('PlayerTilesBinder', function() {
    function setupContainer() {
        var $el = $('<div>');
        $el.addClass('testbed');
        $('body').append($el);
        return $el[0];
    }

    beforeEach(function() {
        var data,
            hexbin,
            mesh,
            svg;

        this.el = setupContainer();

        data = [
            { name: 'Nom', location: 'near', i: 1, j: 1 },
            { name: 'Nomynom', location: 'far', i: 2, j: 2 }
         ];

        svg = d3.select(this.el).append('svg');

        hexbin = d3.hexbin();
        hexbin.size([window.innerWidth, window.innerHeight]).radius(100);

        mesh = svg.selectAll('.mesh');
        mesh.attr('d', hexbin.mesh);

        this.subjectAction = function(data) {
            pong.PlayerTilesBinder.setupD3Strategies(data,
                svg,
                hexbin);
        };

        this.anchors = function(cssClass) {
            return svg.selectAll('a.'+cssClass)[0];
        };

        this.subjectAction(data);
    });

    afterEach(function() {
        $(this.el).remove();
    });

    it('does the initial setup', function() {
        expect(this.anchors('name').length).toEqual(2);
        expect(this.anchors('name').map(function(item) {
            return item.attributes['title'].value;
        })).toEqual(['Nom', 'Nomynom']);
    });

    it('adds a new tile for new users', function() {
        var data = [
            { name: 'Nom', location: 'near', i: 1, j: 1 },
            { name: 'Nomynom', location: 'far', i: 2, j: 2 },
            { name: 'Bazqux', location: 'baz', i:3, j: 3 },
        ];
        this.subjectAction(data);
        expect(this.anchors('name').map(function(item) {
            return item.attributes['title'].value;
        })).toEqual(['Nom', 'Nomynom', 'Bazqux']);
    });

    it('updates when a users name changes', function() {
        var data = [
            { name: 'Nom', location: 'near', i: 1, j: 1 },
            { name: 'Foobar', location: 'far', i: 2, j: 2 },
        ];
        this.subjectAction(data);
        expect(this.anchors('name').map(function(item) {
            return item.attributes['title'].value;
        })).toEqual(['Nom', 'Foobar']);
    });

    it('removes when a user is removed from the dataset', function() {
        var data = [
            { name: 'Nom', location: 'near', i: 1, j: 1 },
        ];
        this.subjectAction(data);
        expect(this.anchors('name').map(function(item) {
            return item.attributes['title'].value;
        })).toEqual(['Nom']);
    });

    it('does not add duplicate anchors', function() {
        var data = [
            { name: 'Nom', location: 'near', i: 1, j: 1 },
            { name: 'Foobar', location: 'far', i: 2, j: 2 },
        ];
        this.subjectAction(data);
        expect(this.anchors('name').length).toEqual(data.length);
        expect(this.anchors('score').length).toEqual(data.length);
        expect(this.anchors('tile').length).toEqual(data.length);
    });
});
