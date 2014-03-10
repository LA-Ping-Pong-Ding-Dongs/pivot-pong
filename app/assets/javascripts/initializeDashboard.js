window.pong = window.pong || {};

pong.initializeDashboard = function() {
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
};