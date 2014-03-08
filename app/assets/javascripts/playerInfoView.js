window.pong = window.pong || {};

pong.PlayerInfoView = Backbone.View.extend({
    template: JST['templates/playerInfoView'],

    initialize: function() {
        this.listenTo(this.model, 'sync', this.render);
    },

    render: function () {
        this.$el.html(this.template({
            name: this.model.get('name'),
        }));
    }
});
