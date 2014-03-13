window.pong = window.pong || {};

pong.PlayerStandings = Backbone.Collection.extend({
  url: '/tournament',

  parse: function (response) {
    return response.results;
  },
});
