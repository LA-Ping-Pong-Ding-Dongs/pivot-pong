window.pong = window.pong || {};

pong.initializeDashboard = function() {
  pong.activeViews.MatchForm = new pong.MatchForm({
    el: '#match_form_container',
  });
  setupPlayerTiles();
  setupRecentMatches();
  setupPlayerStandings();
  paneViewDisplay();


  function setupPlayerTiles() {
    pong.activeViews.PlayerTiles = new pong.PlayerTiles({
      el: '#player_tiles_container',
      data: pong.players,
    });
    pong.activeViews.PlayerTiles.render();
  }

  function setupRecentMatches() {
    var recentMatches = new pong.RecentMatches();
    pong.activeViews.RecentMatchesView = new pong.RecentMatchesView({
      el: '#recent_matches_container',
      collection: recentMatches,
    });
    recentMatches.fetch();
  }

  function setupPlayerStandings() {
    var playerStandings = new pong.PlayerStandings();
    pong.activeViews.PlayerStandingsView = new pong.PlayerStandingsView({
      el: '#leaderboard_container',
      collection: playerStandings,
    });
    playerStandings.fetch();
  }

  function paneViewDisplay() {
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
  }
};
