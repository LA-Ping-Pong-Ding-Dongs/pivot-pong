window.pong = window.pong || {};

pong.reloadDashboard = function () {
    pong.appRouter.navigate('', { trigger: true });
};
