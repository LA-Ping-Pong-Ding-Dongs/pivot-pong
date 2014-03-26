window.pong = window.pong || {};

pong.initializeDashboard = function (options) {
    this.options = options;

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
        data: pong.players,
    });
    pong.activeViews.PlayerTiles.render();

    paneViewDisplay();

    function paneViewDisplay() {
        $('.leaderboard-link').click(function () {
            $('.recent-matches-link').removeClass('active');
            $('#recent_matches_container').removeClass('active');
            $('.leaderboard-link').addClass('active');
            $('#leaderboard_container').addClass('active');
        });

        $('.recent-matches-link').click(function () {
            $('.leaderboard-link').removeClass('active');
            $('#leaderboard_container').removeClass('active');
            $('.recent-matches-link').addClass('active');
            $('#recent_matches_container').addClass('active');
        });
    }
};
