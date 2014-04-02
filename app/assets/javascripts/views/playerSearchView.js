window.pong = window.pong || {};

pong.PlayerSearchView = Backbone.View.extend({
  template: JST['templates/playerSearch'],

  initialize: function (options) {
    this.collection = new pong.PlayerSearch();
    this.collection.on('sync', this.render, this);
    this.collection.on('reset', this.render, this);
    this.onClickCallback = options.onClickCallback;
  },

  render: function () {
    this.$el.off('click');

    this.$el.html(this.template({
      names: this.collection.playerNames(),
    }));
    this.$el.on('click', _.bind(this.clickHandler, this));
  },

  clickHandler: function (e) {
    // Selection click can fire a click event on the parent ul
    if (e.target.localName === 'li') {
      this.onClickCallback(e.target.textContent);
      this.collection.reset();
    }
  },
});