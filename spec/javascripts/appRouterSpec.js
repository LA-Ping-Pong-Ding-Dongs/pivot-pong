describe('AppRouter', function () {
    beforeEach(function () {
        this.router = new pong.AppRouter();
    });

    describe('playerShow', function () {
        it('wires up the route', function () {
            expect(this.router.routes['players/:key']).toBe('playerShow');
        });

        it('creates and renders a PlayerInfoView with a Player model', function () {
            expect(pong.activeViews.PlayerInfoView).toBeUndefined();

            this.router.playerShow('key');

            var request = jasmine.Ajax.requests.mostRecent();
            expect(request.url).toBe('/players/key');
            expect(pong.activeViews.PlayerInfoView instanceof pong.PlayerInfoView).toBeTruthy();
            expect(pong.activeViews.PlayerInfoView.model instanceof pong.Player).toBeTruthy();
        });
    });

    describe('root', function () {
        it('wires up the route', function () {
            expect(this.router.routes['']).toBe('dashboardShow');
        });

        it('creates/renders MatchForm, PlayerTiles and RecentMatches', function () {
            pong.players = {};
            expect(pong.activeViews.MatchForm).toBeUndefined();
            expect(pong.activeViews.PlayerTiles).toBeUndefined();
            expect(pong.activeViews.RecentMatches).toBeUndefined();

            this.router.dashboardShow();

            var request = jasmine.Ajax.requests.mostRecent();
            expect(request.url).toBe('/matches?processed=false');
            expect(pong.activeViews.MatchForm instanceof pong.MatchForm).toBeTruthy();
            expect(pong.activeViews.PlayerTiles instanceof pong.PlayerTiles).toBeTruthy();
            expect(pong.activeViews.RecentMatchesView instanceof pong.RecentMatchesView).toBeTruthy();
            expect(pong.activeViews.RecentMatchesView.collection instanceof pong.RecentMatches).toBeTruthy();
        });

    });
});
