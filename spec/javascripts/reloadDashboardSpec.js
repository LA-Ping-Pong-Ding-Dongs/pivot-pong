describe('reloadDashboard', function () {
    beforeEach(function () {
        pong.appRouter = new pong.AppRouter({
            collections: []
        });
    });

    it('routes to the root path', function () {
        spyOn(pong.appRouter, 'navigate');

        pong.reloadDashboard();
        expect(pong.appRouter.navigate).toHaveBeenCalledWith('', { trigger: true });
    });
});