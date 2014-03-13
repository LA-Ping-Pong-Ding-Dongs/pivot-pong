beforeEach(function () {
    jasmine.clock().install();
    jasmine.Ajax.install();
});

afterEach(function () {
    jasmine.Ajax.uninstall();
    jasmine.clock().uninstall();
    pong.EventBus.off();
});
