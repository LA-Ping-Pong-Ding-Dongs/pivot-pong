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