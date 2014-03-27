describe('Player Search View', function () {
    describe('collectionSearch', function () {
        it('fetches a collection of players with names matching the substring argument', function () {
            var players = new Backbone.Collection();
            var fetchSpy = spyOn(players, 'fetch');

            var searchView = new pong.PlayerSearchView({collection: players});

            searchView.collectionSearch('b');

            expect(fetchSpy).toHaveBeenCalled();

            expect(players.url).toEqual('/players?search=b')
        });
    });

    it('renders when the collection is synced', function () {
        var renderSpy = spyOn(pong.PlayerSearchView.prototype, 'render');
        var players = new Backbone.Collection();
        new pong.PlayerSearchView({ collection: players });

        players.trigger('sync');

        expect(renderSpy).toHaveBeenCalled();
    });
});
