window.pong = window.pong || {};
pong.activeViews = pong.activeViews || {};

pong.AppRouter = Backbone.Router.extend({

    routes: {
        '': 'dashboardShow',
        'players/:key': 'playerShow',
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
        pong.activeViews.MatchForm = new pong.MatchForm({
            el: '#match_form_container',
        });
        pong.activeViews.PlayerTiles = new pong.PlayerTiles({
            el: '#player_tiles_container',
            data: pong.players,
        });
        pong.activeViews.PlayerTiles.render();
        var recentMatches = new pong.RecentMatches();
        pong.activeViews.RecentMatchesView = new pong.RecentMatchesView({
            el: '#recent_matches_container',
            collection: recentMatches,
        });
        recentMatches.fetch();

        var randomPlayer = _.sample(pong.players);
        this.playerShow(randomPlayer.key);
    },

});
