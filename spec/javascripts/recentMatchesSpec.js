describe('RecentMatches', function () {

    describe('match:created event', function () {

        it('adds the model to the collection and renders', function () {
            var renderSpy = spyOn(pong.RecentMatches.prototype, 'render');
            var matches = new Backbone.Collection();
            var newMatch = new Backbone.Model();
            new pong.RecentMatches({ collection: matches });

            pong.EventBus.trigger('match:created', newMatch);

            expect(renderSpy).toHaveBeenCalled();
            expect(matches.first()).toBe(newMatch);
        });

    });

});