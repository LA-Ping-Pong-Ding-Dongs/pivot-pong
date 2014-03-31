describe('AppRouter', function () {
    beforeEach(function () {
        this.router = new pong.AppRouter({ collections: {} });
        spyOn(pong, 'initializeDashboard');
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

        it('picks a random pong player and calls playerShow', function () {
            pong.players = [{key: 'test'}];
            spyOn(this.router, 'playerShow');
            this.router.dashboardShow();

            expect(this.router.playerShow).toHaveBeenCalledWith('test');
        });

        it('does not call playerShow when there are no players', function () {
            pong.players = [];
            spyOn(this.router, 'playerShow');
            this.router.dashboardShow();

            expect(this.router.playerShow).not.toHaveBeenCalled();
        });

    });

    describe('tournamentShow', function () {
        it('wires up the route', function () {
            expect(this.router.routes['tournament']).toBe('tournamentShow');
        });
    });

    describe('matchesIndex', function () {
        it('wires up the route', function () {
            expect(this.router.routes['matches']).toBe('matchesIndex');
        });
    });
});
