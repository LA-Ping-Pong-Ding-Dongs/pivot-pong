window.pong = window.pong || {};

pong.PlayerInfoView = Backbone.View.extend({
    template: JST['templates/playerInfoView'],

    initialize: function () {
        this.listenTo(this.model, 'sync', this.render);
    },

    render: function () {
        this.$el.html(this.template({
            player: this.model.attributes,
            overallType: this.overallRecordClass(),
        }));
    },

    overallRecordClass: function () {
        var wins = this.model.get('overall_wins');
        var losses = this.model.get('overall_losses');

        if (wins > losses) {
            return 'winning';
        } else if (wins < losses) {
            return 'losing';
        } else {
            return 'even';
        }
    },
});
