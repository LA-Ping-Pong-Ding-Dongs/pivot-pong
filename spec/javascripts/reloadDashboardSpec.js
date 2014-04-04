describe('reloadDashboard', function () {
    beforeEach(function () {
        pong.appRouter = new pong.AppRouter();
        pong.collections = {};
        pong.collections.playerStandings = new Backbone.Collection();
        pong.collections.recentMatches = new Backbone.Collection();

        spyOn(pong.collections.playerStandings, 'fetch');
        spyOn(pong.collections.recentMatches, 'fetch');
    });

    it('routes to the root path', function () {
        spyOn(pong.appRouter, 'navigate');
        pong.reloadDashboard();

        expect(pong.appRouter.navigate).toHaveBeenCalledWith('', { trigger: true });
    });

    it('calls fetch on the playerStandings collection', function () {
        pong.reloadDashboard();

        expect(pong.collections.playerStandings.fetch).toHaveBeenCalled();
    });

    it('calls fetch on the recentMatches collection', function () {
        pong.reloadDashboard();

        expect(pong.collections.recentMatches.fetch).toHaveBeenCalled();
    });
});