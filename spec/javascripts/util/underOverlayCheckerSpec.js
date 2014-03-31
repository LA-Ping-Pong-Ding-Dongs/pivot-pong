describe('pong.underOverlays', function() {
    var obscuredCoordinates = {x: 400, y: 500};
    var unobscuredCoordinates = {x: 200, y: 200};

    beforeEach(function(){
        var boundingClientRectStub = function() {
            return {
                left: 300,
                right: 500,
                top: 400,
                bottom: 600,
            }
        }

        spyOn(pong.underOverlayChecker, 'overlays').and.returnValue(
            [{
                getBoundingClientRect: boundingClientRectStub
            }]
        );
    });

    it('returns true when a coordinate pair is under a .overlay DOM object', function(){
        expect(pong.underOverlayChecker.underOverlays(obscuredCoordinates.x, obscuredCoordinates.y)).toBeTruthy();
    });

    it('returns false when a coordinate pair is not under a .overlay DOM object', function() {
        expect(pong.underOverlayChecker.underOverlays(unobscuredCoordinates.x, unobscuredCoordinates.y)).toBeFalsy();
    });
})