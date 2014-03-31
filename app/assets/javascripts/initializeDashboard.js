window.pong = window.pong || {};

pong.initializeDashboard = function (options) {
    this.options = options;
    setupPlayerSearchViews();

    pong.activeViews.MatchForm = new pong.MatchForm({
        el: '#match_form_container',
    });
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

    function setupPlayerSearchViews() {
        pong.activeViews.winnerPlayerSearchView = new pong.PlayerSearchView({
            el: '#winner_suggestions',
            onClickCallback: function (name) {
                $('.winner-field input').val(name);
            }
        });

        $('.winner-field input').on('keyup', function (e) {
            var val = e.target.value;
            pong.activeViews.winnerPlayerSearchView.collectionSearch(val);
        });

        pong.activeViews.loserPlayerSearchView = new pong.PlayerSearchView({
            el: '#loser_suggestions',
            onClickCallback: function (name) {
                $('.loser-field input').val(name);
            }
        });

        $('.loser-field input').on('keyup', function (e) {
            var val = e.target.value;
            pong.activeViews.loserPlayerSearchView.collectionSearch(val);
        });
    }
};
