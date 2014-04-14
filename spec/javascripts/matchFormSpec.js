describe('MatchForm', function () {
    beforeEach(function () {
        this.view = new pong.MatchForm();
        this.renderSpy = spyOn(this.view, 'render').and.callThrough();
        this.eventSpy = spyOn(pong.EventBus, 'trigger');
    });

    describe('selecting winner w/ arrow keys', function() {
        beforeEach(function() {
            this.event = jasmine.createSpyObj('event', ['preventDefault']);
            this.searchResultView = jasmine.createSpyObj('searchResultView', ['selectNext', 'selectPrev']);
        });

        it('selects the next search result on arrow key down', function() {
            this.event.keyCode = 40;
            this.view._inputKeyDown(this.searchResultView, this.event);
            expect(this.searchResultView.selectNext).toHaveBeenCalled();
        });

        it('selects the previous search result on arrow key up', function() {
            this.event.keyCode = 38;
            this.view._inputKeyDown(this.searchResultView, this.event);
            expect(this.searchResultView.selectPrev).toHaveBeenCalled();
        });

        it('doesnt submit the form on enter key while the search field is active', function() {
            this.event.keyCode = 13;
            spyOn(this.view, 'commit');
            this.view._inputKeyDown(this.searchResultView, this.event);
            expect(this.view.commit).not.toHaveBeenCalled();
        });
    });

    describe('saving match data', function () {
        beforeEach(function () {
            this.event = jasmine.createSpyObj('event', ['preventDefault']);
            this.data = { winner: 'Sally', loser: 'Bob' };
            spyOn(Backbone.Syphon, 'serialize').and.returnValue(this.data);
        });

        it('can send match data to the server', function () {
            this.view.commit(this.event);

            var request = jasmine.Ajax.requests.mostRecent();
            expect(request.url).toBe('/matches');
            expect(request.method).toBe('POST');
            expect(JSON.parse(request.params)).toEqual(this.data);
        });

        it('handles success by rendering/broadcasting', function () {
            jasmine.Ajax.stubRequest('/matches').andReturn(ajaxResponses.Matches.create.success);
            this.view.commit(this.event);
            jasmine.clock().tick(1);

            expect(this.renderSpy).toHaveBeenCalled();
            var expectedResponse = JSON.parse(ajaxResponses.Matches.create.success.responseText);
            expect(this.eventSpy).toHaveBeenCalledWith('match:created', expectedResponse);
        });

        it('handles failure by rendering with the returned data', function () {
            jasmine.Ajax.stubRequest('/matches').andReturn(ajaxResponses.Matches.create.failure);
            this.view.commit(this.event);
            jasmine.clock().tick(1);

            expect(this.renderSpy).toHaveBeenCalled();
            var expectedResponse = JSON.parse(ajaxResponses.Matches.create.failure.responseText);
            expect(this.renderSpy.calls.argsFor(0)[0]).toEqual(expectedResponse);
        });
    });

    describe('_collectionSearch', function () {
        beforeEach(function () {
            this.collection = new pong.PlayerSearch();
            this.nameSearchSpy = spyOn(this.collection, 'playerNameSearch');
            this.resetSpy = spyOn(this.collection, 'reset');
        });

        it('does a player name search if a value is present', function () {
            var fakeEvent = { target: { value: 'a' } };
            this.view._collectionSearch(fakeEvent, this.collection);

            expect(this.nameSearchSpy).toHaveBeenCalledWith('a');
            expect(this.resetSpy).not.toHaveBeenCalled();
        });

        it('resets the collection if winner field is blank', function () {
            var fakeEvent = { target: { value: '' } };
            this.view._collectionSearch(fakeEvent, this.collection);

            expect(this.nameSearchSpy).not.toHaveBeenCalled();
            expect(this.resetSpy).toHaveBeenCalled();
        });

        it('resets the collection if winner field is multiple blanks', function () {
            var fakeEvent = { target: { value: '   ' } };
            this.view._collectionSearch(fakeEvent, this.collection);

            expect(this.nameSearchSpy).not.toHaveBeenCalled();
            expect(this.resetSpy).toHaveBeenCalled();
        });
    });

    describe('_closeWinnerSearch', function () {
        beforeEach(function() {
            this.view.render();
        });

        it('resets the collection', function () {
            pong.activeViews.winnerPlayerSearchView.collection = new pong.PlayerSearch();
            var resetSpy = spyOn(pong.activeViews.winnerPlayerSearchView.collection, 'reset');
            this.view._closeWinnerSearch();

            expect(resetSpy).toHaveBeenCalled();
        });
    });

    describe('_closeLoserSearch', function () {
        beforeEach(function() {
            this.view.render();
        });

        it('resets the collection', function () {
            pong.activeViews.loserPlayerSearchView.collection = new pong.PlayerSearch();
            var resetSpy = spyOn(pong.activeViews.loserPlayerSearchView.collection, 'reset');
            this.view._closeLoserSearch();

            expect(resetSpy).toHaveBeenCalled();
        });
    });
});
