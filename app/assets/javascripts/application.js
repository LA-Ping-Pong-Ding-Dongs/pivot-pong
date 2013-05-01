//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready( function(){
  $('#new_match input[type=text]').autocomplete('/matches/players');
  $('.tab-bar').tabs();
});
