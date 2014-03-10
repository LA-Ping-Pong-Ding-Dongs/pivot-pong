describe('initializeDashboard', function () {
    it('creates/renders MatchForm, PlayerTiles and RecentMatches', function () {
        pong.players = {};
        expect(pong.activeViews.MatchForm).toBeUndefined();
        expect(pong.activeViews.PlayerTiles).toBeUndefined();
        expect(pong.activeViews.RecentMatches).toBeUndefined();

        pong.initializeDashboard();

        var request = jasmine.Ajax.requests.mostRecent();
        expect(request.url).toBe('/matches?processed=false');
        expect(pong.activeViews.MatchForm instanceof pong.MatchForm).toBeTruthy();
        expect(pong.activeViews.PlayerTiles instanceof pong.PlayerTiles).toBeTruthy();
        expect(pong.activeViews.RecentMatchesView instanceof pong.RecentMatchesView).toBeTruthy();
        expect(pong.activeViews.RecentMatchesView.collection instanceof pong.RecentMatches).toBeTruthy();
    });

});