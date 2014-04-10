window.pong = window.pong || {};

pong.PlayerInfoView = Backbone.View.extend({
    template: JST['templates/playerInfoView'],

    initialize: function () {
        pong.EventBus.on('match:created', this._fetchUpdatedModel, this);
        this.listenTo(this.model, 'sync', this.render);
    },

    render: function () {
        this.$el.html(this.template({
            player: this.model.attributes,
            overallType: this.overallRecordClass(),
            streakDirectionClass: this.streakDirectionClass(),
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

    streakDirectionClass: function () {
        var streak = this.model.get('current_streak_type');

        if (streak === 'W') {
            return 'hot-streak';
        } else if (streak === 'L') {
            return 'cold-streak';
        } else {
            return '';
        }
    },

    _fetchUpdatedModel: function() {
        this.model.fetch({silent: true});
    }
});
