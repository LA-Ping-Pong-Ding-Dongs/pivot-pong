window.pong = window.pong || {};

pong.RecentMatches = Backbone.Collection.extend({
    url: '/matches/recent',

    parse: function (response) {
      return response.results;
    },
});
