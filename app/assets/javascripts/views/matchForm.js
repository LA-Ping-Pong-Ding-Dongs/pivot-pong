window.pong = window.pong || {};

pong.MatchForm = Backbone.View.extend({
    template: JST['templates/matchForm'],

    events: {
        submit: 'commit',
        'keydown .winner-field': '_winnerSelect',
        'keydown .loser-field': '_loserSelect',
        'keyup .winner-field': '_winnerSearch',
        'focus .winner-field': '_winnerSearch',
        'keyup .loser-field': '_loserSearch',
        'focus .loser-field': '_loserSearch',
        'blur .winner-field': '_closeWinnerSearch',
        'blur .loser-field': '_closeLoserSearch',
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
            onMousedownCallback: _.bind(function (name) {
                this.$el.find('.winner-field input').val(name);
            }, this)
        });

        pong.activeViews.loserPlayerSearchView = new pong.PlayerSearchView({
            el: '#loser_suggestions',
            onMousedownCallback: _.bind(function (name) {
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

    _closeWinnerSearch: function (e) {
        pong.activeViews.winnerPlayerSearchView.collection.reset();
    },

    _closeLoserSearch: function () {
        pong.activeViews.loserPlayerSearchView.collection.reset();
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

    _winnerSelect: function(e) {
        this._inputKeyDown(pong.activeViews.winnerPlayerSearchView, e);
    },

    _loserSelect: function(e) {
        this._inputKeyDown(pong.activeViews.loserPlayerSearchView, e);
    },

    _inputKeyDown: function(searchView, e) {
        if (searchView.active && e.keyCode == 13) { // return
            e.preventDefault();
            searchView.enterSelected();
            return;
        }
        switch(e.keyCode) {
            case(38): { // arrow up
                e.preventDefault();
                searchView.selectPrev();
                break;
            }
            case(40): { // arrow down
                e.preventDefault();
                searchView.selectNext();
                break;
            }
        }
    },
});
