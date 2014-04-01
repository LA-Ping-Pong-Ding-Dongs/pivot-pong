window.ajaxResponses = window.ajaxResponses || {};

ajaxResponses.Matches = {
    create: {
        success: {
            status: '200',
            responseText: JSON.stringify({ monkies: 'bananas' }),
        },
        failure: {
            status: '400',
            responseText: JSON.stringify({ error: 'bananas' }),
        },
    },
    index: {
        success: {
            status: '200',
            responseText: JSON.stringify({ results: [{ id: 43 }, { id: 21 }] }),
        },
        failure: {
            status: '400',
            responseText: JSON.stringify({ error: 'blowin up' }),
        },
    },
};

ajaxResponses.Players = {
    show: {
        success: {
            status: '200',
            responseText: JSON.stringify({ results: { name: 'Tommy Wiseau' } }),
        },
        failure: {
            status: '400',
            rresponseText: JSON.stringify({ error: 'blowin up' }),
        },
    },
};

ajaxResponses.PlayersSearch = {
    index: {
        success: {
            status: '200',
            responseText: JSON.stringify([{ name: 'Tommy Wiseau' }, { name: 'Denny' }]),
        },
        failure: {
            status: '400',
            rresponseText: JSON.stringify({ error: 'blowin up' }),
        },
    },
};

ajaxResponses.Tournament = {
  show: {
    success: {
      status: '200',
      responseText: JSON.stringify({ results: [{ key: 'one' }, { key: 'two' }] }),
    },
    failure: {
      status: '400',
      rresponseText: JSON.stringify({ error: 'blowin up' }),
    },
  },
};
