$.ajaxPrefilter(function (options) {
    if (options.type != 'GET') {
        options.data = JSON.parse(options.data) || {};
        options.data[$('meta[name=csrf-param]').attr("content")] = $('meta[name=csrf-token]').attr("content");
        options.data = JSON.stringify(options.data)
    }
});