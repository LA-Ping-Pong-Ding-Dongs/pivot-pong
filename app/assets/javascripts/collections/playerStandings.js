window.pong = window.pong || {};

pong.PlayerStandings = Backbone.Collection.extend({
  url: '/tournament.json',

  parse: function (response) {
    return response.results;
  },
});
