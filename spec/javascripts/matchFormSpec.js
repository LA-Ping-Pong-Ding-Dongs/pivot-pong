describe('MatchForm', function () {
    beforeEach(function () {
        this.view = new pong.MatchForm();
        this.renderSpy = spyOn(this.view, 'render');
        this.eventSpy = spyOn(pong.EventBus, 'trigger');
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

});