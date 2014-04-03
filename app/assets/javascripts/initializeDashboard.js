window.pong = window.pong || {};

pong.initializeDashboard = function(options) {
    this.options = options;

    setupMatchForm();
    setupRecentMatches(this.options);
    setupPlayerStandings(this.options);
    setupPlayerTiles(this.options);

    $('a.js').click(pong.navigator);

    return;

    function setupMatchForm () {
        if (pong.activeViews.MatchForm) {
            pong.activeViews.MatchForm.close();
        }
        pong.activeViews.MatchForm = new pong.MatchForm({
            el: '#match_form_container',
        });
        pong.activeViews.MatchForm.render();
    }

    function setupRecentMatches (options) {
        if (pong.activeViews.RecentMatchesView) {
            pong.activeViews.RecentMatchesView.close();
        }
        pong.activeViews.RecentMatchesView = new pong.RecentMatchesView({
            el: '#recent_matches_container',
            collection: options.collections.recentMatches,
        });
    }

    function setupPlayerStandings (options) {
        if (pong.activeViews.PlayerStandingsView) {
            pong.activeViews.PlayerStandingsView.close();
        }
        pong.activeViews.PlayerStandingsView = new pong.PlayerStandingsView({
            el: '#leaderboard_container',
            collection: options.collections.playerStandings,
        });
    }

    function setupPlayerTiles (options) {
        if (pong.activeViews.PlayerTiles) {
            pong.activeViews.PlayerTiles.close();
        }
        pong.activeViews.PlayerTiles = new pong.PlayerTiles({
            el: '#player_tiles_container',
            collection: options.collections.players,
            excludeCells: pong.underOverlayChecker.underOverlays,
        });
        pong.activeViews.PlayerTiles.render();
    }
};
