window.ajaxResponses = window.ajaxResponses || {};

ajaxResponses.Matches = {
    create: {
        success: {
            status: '200',
            responseText: '{"monkies":"bananas"}',
        },
        failure: {
            status: '400',
            responseText: '{"error":"bananas"}',
        },
    }
};