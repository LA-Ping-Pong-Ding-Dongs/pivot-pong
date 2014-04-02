window.pong = window.pong || {};

pong.PlayerSearch = Backbone.Collection.extend({
    playerNameSearch: function (searchString) {
        this.url = '/players_search?search=' + searchString;
        this.fetch();
    },

    playerNames: function () {
        return this.pluck('name');
    },

});
