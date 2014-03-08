describe('PlayerInfoView', function () {

    beforeEach(function () {
        this.model = new pong.Player();
        this.view = new pong.PlayerInfoView({ model: this.model });
    });

    it('has a template', function () {
        expect(this.view.template).toBeDefined();
        expect(this.view.template).toEqual(JST['templates/playerInfoView'])
    });

});
