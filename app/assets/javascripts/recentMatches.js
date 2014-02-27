window.pong = window.pong || {};

pong.RecentMatches = Backbone.View.extend({
    template: JST['templates/recentMatches'],

    initialize: function () {
        pong.EventBus.on('match:created', this._updateCollection, this);
    },

    render: function () {
        this.$el.html(this.template({ matches: this.collection }));
        return this;
    },

    _updateCollection: function(model) {
        this.collection.add(model);
        this.render();
    },
});