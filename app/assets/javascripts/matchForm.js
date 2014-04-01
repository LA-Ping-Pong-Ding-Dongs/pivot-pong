window.pong = window.pong || {};

pong.MatchForm = Backbone.View.extend({
    template: JST['templates/matchForm'],

    events: {
        submit: 'commit',
        'keyup .winner-field': '_winnerSearch',
        'keyup .loser-field': '_loserSearch',
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

        pong.activeViews.winnerPlayerSearchView = new pong.PlayerSearchView({
            el: '#winner_suggestions',
            onClickCallback: _.bind(function (name) {
                this.$el.find('.winner-field input').val(name);
            }, this)
        });

        pong.activeViews.loserPlayerSearchView = new pong.PlayerSearchView({
            el: '#loser_suggestions',
            onClickCallback: _.bind(function (name) {
                this.$el.find('.loser-field input').val(name);
            }, this)
        });

        return this;
    },

    _winnerSearch: function (e) {
        this._collectionSearch(e, pong.activeViews.winnerPlayerSearchView.collection);
    },

    _loserSearch: function (e) {
        this._collectionSearch(e, pong.activeViews.loserPlayerSearchView.collection);
    },

    _collectionSearch: function (e, collection) {
        var val = e.target.value;
        if (val.match(/^ *$/) == null) {
            collection.playerNameSearch(val);
        } else {
            collection.reset();
        }
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