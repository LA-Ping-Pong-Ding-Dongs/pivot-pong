window.pong = window.pong || {};
pong.navigator = function(e) {
    var $anchor = $(e.target);
    if (!$anchor.is('a')) $anchor = $anchor.parents('a');

    var href = $anchor.attr('href');
    var protocol = this.protocol + '//';
    var relativeLink = href && href.slice(0, protocol.length) !== protocol && href.indexOf('javascript:') !== 0;

    if (relativeLink) {
        e.preventDefault();
        Backbone.history.navigate(href, true);
    }
};