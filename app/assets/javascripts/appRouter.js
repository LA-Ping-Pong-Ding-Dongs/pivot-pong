window.pong = window.pong || {};
pong.activeViews = pong.activeViews || {};

pong.AppRouter = Backbone.Router.extend({

    routes: {
        '': 'dashboardShow',
        'players/:key': 'playerShow',
        'tournament': 'tournamentShow',
        'matches': 'matchesIndex',
    },

    initialize: function (options) {
        this.options = options;
    },

    playerShow: function (key) {
        var player = new pong.Player({ key: key });

        pong.activeViews.PlayerInfoView = new pong.PlayerInfoView({
            el: '#player_info',
            model: player,
        });
        player.fetch();
    },

    dashboardShow: function () {
        var randomPlayer = _.sample(pong.players);
        if (randomPlayer) {
            this.playerShow(randomPlayer.key);
        }
        pong.initializeDashboard(this.options);
    },

    tournamentShow: function () {
        $('.recent-matches-link').removeClass('active');
        $('#recent_matches_container').removeClass('active');
        $('.leaderboard-link').addClass('active');
        $('#leaderboard_container').addClass('active');
    },

    matchesIndex: function () {
        $('.leaderboard-link').removeClass('active');
        $('#leaderboard_container').removeClass('active');
        $('.recent-matches-link').addClass('active');
        $('#recent_matches_container').addClass('active');
    },
});
