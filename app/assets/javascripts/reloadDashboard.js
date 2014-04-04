window.pong = window.pong || {};

pong.reloadDashboard = function () {
    pong.appRouter.navigate('', { trigger: true });
    pong.collections.playerStandings.fetch();
    pong.collections.recentMatches.fetch();
};
