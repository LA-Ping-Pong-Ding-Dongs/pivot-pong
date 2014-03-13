describe('PlayerStandingsView', function () {

  describe('match:created event', function () {
    it('fetches the collection and re-renders', function () {
      var collection = new Backbone.Collection();
      var fetchSpy = spyOn(collection, 'fetch');
      new pong.PlayerStandingsView({ collection: collection });

      pong.EventBus.trigger('match:created');

      expect(fetchSpy).toHaveBeenCalled();
    });
  });

  it('renders when the collection is synced', function () {
    var renderSpy = spyOn(pong.PlayerStandingsView.prototype, 'render');
    var collection = new Backbone.Collection();
    new pong.PlayerStandingsView({ collection: collection });

    collection.trigger('sync');

    expect(renderSpy).toHaveBeenCalled();
  });
});
