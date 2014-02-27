window.pong = window.pong || {};

pong.MatchForm = Backbone.View.extend({
    template: JST['templates/matchForm'],

    events: {
        submit: 'commit',
    },

    commit: function (e) {
        e.preventDefault();
        this._serializeForm().save({}, {
            success: _.bind(this._saveSuccess, this),
            error: _.bind(this._saveFailure, this),
        });
    },

    render: function (data) {
        this.$el.html(this.template(data));
        return this;
    },

    _serializeForm: function () {
        return this._createModel().set(Backbone.Syphon.serialize(this));
    },

    _createModel: function () {
        return new pong.Match();
    },

    _saveSuccess: function (_, response) {
        this.render(response);
        pong.EventBus.trigger('match:created', response);
    },

    _saveFailure: function (_, response) {
        this.render(response.responseJSON);
    },
});