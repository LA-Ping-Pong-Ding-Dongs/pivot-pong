window.pong = window.pong || {};

pong.RecentMatches = Backbone.Collection.extend({
    url: '/matches?recent=true',

    parse: function (response) {
      return response.results;
    },
});
