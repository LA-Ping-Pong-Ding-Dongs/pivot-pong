describe('PlayerStandings', function () {
  beforeEach(function () {
    this.collection = new pong.PlayerStandings();
  });

  it('specifies a url to fetch recent matches', function () {
    expect(this.collection.url).toEqual('/tournament')
  });

  it('parses the response', function () {
    jasmine.Ajax.stubRequest('/tournament').andReturn(ajaxResponses.Tournament.show.success);
    this.collection.fetch();
    jasmine.clock().tick(1);

    expect(this.collection.length).toEqual(2);
    expect(this.collection.models[0].get('key')).toEqual('one');
  });

});
