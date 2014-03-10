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
        var randomPlayer = _.sample(pong.players);
        if (randomPlayer) {
            this.playerShow(randomPlayer.key);
        }
    },

});
