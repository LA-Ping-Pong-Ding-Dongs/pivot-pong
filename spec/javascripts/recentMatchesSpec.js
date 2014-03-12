describe('RecentMatches', function () {
    beforeEach(function () {
        this.collection = new pong.RecentMatches();
    });

    it('specifies a url to fetch recent matches', function () {
        expect(this.collection.url).toEqual('/matches?recent=true')
    });

    it('parses the response', function () {
        jasmine.Ajax.stubRequest('/matches?recent=true').andReturn(ajaxResponses.Matches.index.success);
        this.collection.fetch();
        jasmine.clock().tick(1);

        expect(this.collection.length).toEqual(2);
        expect(this.collection.models[0].get('id')).toEqual(43);
    });

});
