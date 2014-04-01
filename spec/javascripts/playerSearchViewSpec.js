describe('Player Search View', function () {
    beforeEach(function() {
        this.collectionNameSearchSpy = spyOn(pong.PlayerSearch.prototype, 'playerNameSearch');
        this.renderSpy = spyOn(pong.PlayerSearchView.prototype, 'render');
        this.view = new pong.PlayerSearchView({
            onClickCallback: function() { return null; },
        });
    });

    it('renders when the collection is synced', function () {
        this.view.collection.trigger('sync');

        expect(this.renderSpy).toHaveBeenCalled();
    });

    it('renders when the collection is reset', function () {
        this.view.collection.trigger('reset');

        expect(this.renderSpy).toHaveBeenCalled();
    });
});
