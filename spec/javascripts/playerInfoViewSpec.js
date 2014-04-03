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

    describe('streakDirectionClass', function () {
        it('returns hot-streak when on winning streak', function () {
            this.model.set({ current_streak_type: 'W' }, { silent: true });
            expect(this.view.streakDirectionClass()).toEqual('hot-streak');
        });

        it('returns cold-streak when on a losing streak', function () {
            this.model.set({ current_streak_type: 'L' }, { silent: true });
            expect(this.view.streakDirectionClass()).toEqual('cold-streak');
        });

        it('returns nothing when no streak', function () {
            this.model.set({ current_streak_type: null }, { silent: true });
            expect(this.view.streakDirectionClass()).toEqual('');
        });
    });
});
