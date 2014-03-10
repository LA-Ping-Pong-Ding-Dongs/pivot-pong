describe('PlayerInfoView', function () {

    beforeEach(function () {
        this.model = new pong.Player();
        this.view = new pong.PlayerInfoView({ model: this.model });
    });

    it('has a template', function () {
        expect(this.view.template).toBeDefined();
        expect(this.view.template).toEqual(JST['templates/playerInfoView'])
    });

    describe('overallRecordClass', function () {
        it('returns winning when more wins than losses', function () {
            this.model.set({ overall_wins: 2, overall_losses: 1 }, { silent: true });
            expect(this.view.overallRecordClass()).toEqual('winning');
        });

        it('returns even when equal wins and losses', function () {
            this.model.set({ overall_wins: 1, overall_losses: 1 }, { silent: true });
            expect(this.view.overallRecordClass()).toEqual('even');
        });

        it('returns losing when more losses than wins', function () {
            this.model.set({ overall_wins: 1, overall_losses: 2 }, { silent: true });
            expect(this.view.overallRecordClass()).toEqual('losing');
        });
    });
});
