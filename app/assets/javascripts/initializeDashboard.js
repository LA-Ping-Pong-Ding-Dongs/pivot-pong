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

  $('.leaderboard-link').click(function() {
    $('.recent-matches-link').removeClass('active');
    $('#recent_matches_container').removeClass('active');
    $('.leaderboard-link').addClass('active');
    $('#leaderboard_container').addClass('active');
  });

  $('.recent-matches-link').click(function() {
    $('.leaderboard-link').removeClass('active');
    $('#leaderboard_container').removeClass('active');
    $('.recent-matches-link').addClass('active');
    $('#recent_matches_container').addClass('active');
  });
};
