describe('PlayerSearch', function () {
    beforeEach(function () {
        this.collection = new pong.PlayerSearch();
    });

    describe('playerNameSearch', function () {
        it('fetches players with a matching name', function () {
            spyOn(this.collection, 'fetch');

            this.collection.playerNameSearch('b');
            expect(this.collection.fetch).toHaveBeenCalled();
        });

        it('returns a list of players', function () {
            jasmine.Ajax.stubRequest('/players_search.json?search=b').andReturn(ajaxResponses.PlayersSearch.index.success);
            this.collection.playerNameSearch('b');
            jasmine.clock().tick(1);

            expect(this.collection.length).toEqual(2);
            var firstPlayer = JSON.parse(ajaxResponses.PlayersSearch.index.success.responseText)[0];
            expect(firstPlayer).toBeDefined();
            expect(this.collection.models[0].get('name')).toEqual(firstPlayer.name);
        });
    });

    describe('playerNames', function () {
        it('returns player names from the collection', function () {
            var bob = new Backbone.Model({ name: 'Bob' });
            var sally = new Backbone.Model({ name: 'Sally' });
            this.collection.set([bob, sally], { silent: true });

            expect(this.collection.playerNames()).toEqual(['Bob', 'Sally']);
        });
    });
});
