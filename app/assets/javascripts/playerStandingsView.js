window.pong = window.pong || {};

pong.PlayerStandingsView = Backbone.View.extend({
  template: JST['templates/playerStandings'],

  events: {
    'click #tooltip_link': '_toggleTooltip',
  },

  initialize: function () {
    pong.EventBus.on('match:created', this._updateCollection, this);
    this.collection.on('sync', this.render, this);
  },

  render: function () {
    this.$el.html(this.template({ standings: this.collection }));
    this.$el.find('#tooltip').hide();
    return this;
  },

  _toggleTooltip: function () {
    this.$el.find('#tooltip').toggle();
  },

  _updateCollection: function() {
    this.collection.fetch();
  },
});
