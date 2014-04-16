describe('Player Search View', function () {
    beforeEach(function() {
        this.collectionNameSearchSpy = spyOn(pong.PlayerSearch.prototype, 'playerNameSearch');
    });

    describe('rendering', function() {
        beforeEach(function() {
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

    describe('arrow navigation', function() {
        beforeEach(function() {
            this.view = new pong.PlayerSearchView({
                onClickCallback: function() { return null; },
            });
            this.view.collection.reset([
                new pong.Player({name: 'foobar'}),
                new pong.Player({name: 'foobaz'}),
            ]);
            expect(this.view.options().length).not.toEqual(0);
        });

        describe('selectNext', function() {
            it('highlights the next result', function() {
                expect(this.view.options().filter('.selected').length).toEqual(0);

                this.view.selectNext();
                expect(this.view.selectedIndex).toEqual(0);

                this.view.selectNext();
                expect(this.view.selectedIndex).toEqual(1);

                this.view.render();
                expect(this.view.options().index('.selected')).not.toEqual(0);
            });
        });

        describe('selectPrev', function() {
            beforeEach(function() {
                this.view.selectedIndex = 1;
            });

            it('highlights the previous result', function() {
                expect(this.view.options().filter('.selected').length).toEqual(0);

                this.view.selectPrev();
                expect(this.view.selectedIndex).toEqual(0);

                this.view.render();
                expect(this.view.options().index('.selected')).not.toEqual(0);
            });
        });
    });
});
