window.pong = window.pong || {};

pong.RecentMatches = Backbone.Collection.extend({
    url: '/matches?processed=false',

    parse: function (response) {
      return response.results;
    },
});