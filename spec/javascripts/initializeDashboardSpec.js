describe('initializeDashboard', function () {
    beforeEach(function() {
        this.players = new Backbone.Collection();
        this.recentMatches = new Backbone.Collection();
        this.playerStandings = new Backbone.Collection();
        this.collectionDoubles = {
            collections: {
                players: this.players,
                recentMatches: this.recentMatches,
                playerStandings: this.playerStandings,
            }
        }
    });

    it('creates/renders MatchForm, PlayerTiles, PlayerSearchViews and RecentMatches', function () {
        expect(pong.activeViews.MatchForm).toBeUndefined();
        expect(pong.activeViews.PlayerTiles).toBeUndefined();
        expect(pong.activeViews.RecentMatchesView).toBeUndefined();
        expect(pong.activeViews.PlayerStandingsView).toBeUndefined();
        expect(pong.activeViews.winnerPlayerSearchView).toBeUndefined();
        expect(pong.activeViews.loserPlayerSearchView).toBeUndefined();

        pong.initializeDashboard(this.collectionDoubles);

        expect(pong.activeViews.MatchForm instanceof pong.MatchForm).toBeTruthy();
        expect(pong.activeViews.PlayerTiles instanceof pong.PlayerTiles).toBeTruthy();

        expect(pong.activeViews.RecentMatchesView instanceof pong.RecentMatchesView).toBeTruthy();
        expect(pong.activeViews.RecentMatchesView.collection).toBe(this.recentMatches);

        expect(pong.activeViews.PlayerStandingsView instanceof pong.PlayerStandingsView).toBeTruthy();
        expect(pong.activeViews.PlayerStandingsView.collection).toBe(this.playerStandings);

        expect(pong.activeViews.winnerPlayerSearchView instanceof pong.PlayerSearchView).toBeTruthy();
        expect(pong.activeViews.loserPlayerSearchView instanceof pong.PlayerSearchView).toBeTruthy();
    });

    it('closes views if they have already been opened', function () {
        var matchFormClose = spyOn(pong.MatchForm.prototype, 'close');
        var tilesClose = spyOn(pong.PlayerTiles.prototype, 'close');
        var matchesClose = spyOn(pong.RecentMatchesView.prototype, 'close');
        var standingsClose = spyOn(pong.PlayerStandingsView.prototype, 'close');

        expect(pong.activeViews.MatchForm).toBeUndefined();
        expect(pong.activeViews.PlayerTiles).toBeUndefined();
        expect(pong.activeViews.RecentMatchesView).toBeUndefined();
        expect(pong.activeViews.PlayerStandingsView).toBeUndefined();

        pong.initializeDashboard(this.collectionDoubles);

        expect(matchFormClose).not.toHaveBeenCalled();
        expect(tilesClose).not.toHaveBeenCalled();
        expect(matchesClose).not.toHaveBeenCalled();
        expect(standingsClose).not.toHaveBeenCalled();

        pong.initializeDashboard(this.collectionDoubles);

        expect(matchFormClose).toHaveBeenCalled();
        expect(tilesClose).toHaveBeenCalled();
        expect(matchesClose).toHaveBeenCalled();
        expect(standingsClose).toHaveBeenCalled();
    });
});
