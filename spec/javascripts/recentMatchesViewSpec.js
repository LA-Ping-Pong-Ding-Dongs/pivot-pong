describe('RecentMatchesView', function () {

    describe('match:created event', function () {

        it('adds the model to the collection and renders', function () {
            var renderSpy = spyOn(pong.RecentMatchesView.prototype, 'render');
            var matches = new Backbone.Collection();
            var newMatch = new Backbone.Model();
            new pong.RecentMatchesView({ collection: matches });

            pong.EventBus.trigger('match:created', newMatch);

            expect(renderSpy).toHaveBeenCalled();
            expect(matches.first()).toBe(newMatch);
        });

    });

    it('renders when the collection is synced', function () {
        var renderSpy = spyOn(pong.RecentMatchesView.prototype, 'render');
        var matches = new Backbone.Collection();
        new pong.RecentMatchesView({ collection: matches });

        matches.trigger('sync');

        expect(renderSpy).toHaveBeenCalled();
    });
});