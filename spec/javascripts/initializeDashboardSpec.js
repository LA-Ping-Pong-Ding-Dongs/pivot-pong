describe('initializeDashboard', function() {
  it('creates/renders MatchForm, PlayerTiles and RecentMatches', function() {
    pong.players = {};
    expect(pong.activeViews.MatchForm).toBeUndefined();
    expect(pong.activeViews.PlayerTiles).toBeUndefined();
    expect(pong.activeViews.RecentMatchesView).toBeUndefined();
    expect(pong.activeViews.PlayerStandingsView).toBeUndefined();

    pong.initializeDashboard();

    var requests = jasmine.Ajax.requests;
    expect(requests.at(0).url).toBe('/matches?recent=true');
    expect(requests.at(1).url).toBe('/tournament');

    expect(pong.activeViews.MatchForm instanceof pong.MatchForm).toBeTruthy();
    expect(pong.activeViews.PlayerTiles instanceof pong.PlayerTiles).toBeTruthy();

    expect(pong.activeViews.RecentMatchesView instanceof pong.RecentMatchesView).toBeTruthy();
    expect(pong.activeViews.RecentMatchesView.collection instanceof pong.RecentMatches).toBeTruthy();

    expect(pong.activeViews.PlayerStandingsView instanceof pong.PlayerStandingsView).toBeTruthy();
    expect(pong.activeViews.PlayerStandingsView.collection instanceof pong.PlayerStandings).toBeTruthy();
  });

  it('sets an interval', function() {
    spyOn(window, 'setInterval');
    pong.initializeDashboard();

    expect(window.setInterval).toHaveBeenCalledWith(jasmine.any(Function), 15000);
  });

  it('fetches recent matches and tournament standings every 15 seconds', function() {
    pong.initializeDashboard();

    var requests = jasmine.Ajax.requests;
    expect(requests.count()).toEqual(2);
    jasmine.clock().tick(15001);

    expect(requests.count()).toEqual(4);
    expect(requests.at(2).url).toBe('/matches?recent=true');
    expect(requests.at(3).url).toBe('/tournament');
  });

});
