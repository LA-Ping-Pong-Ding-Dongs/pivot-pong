window.pong = window.pong || {};

pong.Player = Backbone.Model.extend({

    url: function () {
        return '/players/' + this.get('key');
    },

    parse: function(response) {
        return response.results;
    },
});
