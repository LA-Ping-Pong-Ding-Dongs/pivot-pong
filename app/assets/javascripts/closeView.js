Backbone.View.prototype.close = function () {
    this.$el.empty();
    this.unbind();
};