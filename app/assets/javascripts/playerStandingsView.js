window.pong = window.pong || {};

pong.PlayerStandingsView = Backbone.View.extend({
  template: JST['templates/playerStandings'],

  initialize: function () {
    pong.EventBus.on('match:created', this._updateCollection, this);
    this.collection.on('sync', this.render, this);
  },

  render: function () {
    this.$el.html(this.template({ standings: this.collection }));
    return this;
  },

  _updateCollection: function() {
    this.collection.fetch();
  },
});
