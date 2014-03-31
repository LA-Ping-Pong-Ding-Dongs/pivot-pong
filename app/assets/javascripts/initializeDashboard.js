window.pong = window.pong || {};

pong.initializeDashboard = function (options) {
    this.options = options;

    pong.activeViews.MatchForm = new pong.MatchForm({
        el: '#match_form_container',
    });
    pong.activeViews.MatchForm.render();

    pong.activeViews.RecentMatchesView = new pong.RecentMatchesView({
        el: '#recent_matches_container',
        collection: this.options.collections.recentMatches,
    });
    pong.activeViews.PlayerStandingsView = new pong.PlayerStandingsView({
        el: '#leaderboard_container',
        collection: this.options.collections.playerStandings,
    });
    pong.activeViews.PlayerTiles = new pong.PlayerTiles({
        el: '#player_tiles_container',
        collection: this.options.collections.players,
        excludeCells: pong.underOverlayChecker.underOverlays,
    });
    pong.activeViews.PlayerTiles.render();
};
