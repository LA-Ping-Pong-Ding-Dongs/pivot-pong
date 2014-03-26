describe('initializeDashboard', function() {
    beforeEach(function () {
        this.recentMatches = new Backbone.Collection();
        this.playerStandings = new Backbone.Collection();
        this.collectionDoubles = {
            collections: {
                recentMatches: this.recentMatches,
                playerStandings: this.playerStandings,
            }
        }
    });

  it('creates/renders MatchForm, PlayerTiles and RecentMatches', function() {
    pong.players = {};

    expect(pong.activeViews.MatchForm).toBeUndefined();
    expect(pong.activeViews.PlayerTiles).toBeUndefined();
    expect(pong.activeViews.RecentMatchesView).toBeUndefined();
    expect(pong.activeViews.PlayerStandingsView).toBeUndefined();

    pong.initializeDashboard(this.collectionDoubles);

    expect(pong.activeViews.MatchForm instanceof pong.MatchForm).toBeTruthy();
    expect(pong.activeViews.PlayerTiles instanceof pong.PlayerTiles).toBeTruthy();

    expect(pong.activeViews.RecentMatchesView instanceof pong.RecentMatchesView).toBeTruthy();
    expect(pong.activeViews.RecentMatchesView.collection).toBe(this.recentMatches);

    expect(pong.activeViews.PlayerStandingsView instanceof pong.PlayerStandingsView).toBeTruthy();
    expect(pong.activeViews.PlayerStandingsView.collection).toBe(this.playerStandings);
  });

});
