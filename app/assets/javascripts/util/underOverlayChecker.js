window.pong = window.pong || {};

pong.underOverlayChecker = {
    pointUnderElement: function (x, y, el) {
        var MARGIN = 100;
        bb = el.getBoundingClientRect();
        return x > (bb.left - MARGIN) && x < (bb.right + MARGIN) && y > (bb.top - MARGIN) && y < (bb.bottom + MARGIN);
    },

    overlays: function () {
        return $('.overlay');
    },

    underOverlays: function (x, y) {
        return _.some(pong.underOverlayChecker.overlays(), function (overlay) {
            return pong.underOverlayChecker.pointUnderElement(x, y, overlay)
        });
    },
}