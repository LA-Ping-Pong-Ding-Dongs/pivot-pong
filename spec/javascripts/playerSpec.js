describe('Player', function () {
    beforeEach(function () {
        this.model = new pong.Player({ key: 'testkey' });
    });

    it('defines a url', function () {
        expect(this.model.url()).toEqual('/players/testkey');
    });

    it('parses the results', function () {
        jasmine.Ajax.stubRequest('/players/testkey').andReturn(ajaxResponses.Players.show.success);
        this.model.fetch();
        jasmine.clock().tick(1);

        expect(this.model.get('name')).toEqual('Tommy Wiseau');
    });

});
