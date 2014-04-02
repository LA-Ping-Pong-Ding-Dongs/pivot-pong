window.pong = window.pong || {};

pong.PlayerSearchView = Backbone.View.extend({
  template: JST['templates/playerSearch'],

  initialize: function (options) {
    this.collection = new pong.PlayerSearch();
    this.collection.on('sync', this.render, this);
    this.collection.on('reset', this.render, this);
    this.onMousedownCallback = options.onMousedownCallback;
  },

  render: function () {
    this.$el.off('click');

    this.$el.html(this.template({
      names: this.collection.playerNames(),
    }));
    this.$el.on('mousedown', _.bind(this.mousedownHandler, this));
  },

  mousedownHandler: function (e) {
    if (e.target.localName === 'li') {
      this.onMousedownCallback(e.target.textContent);
      this.collection.reset();
    }
  },
});