(function() {
  'use strict';

  describe('Metrics', function() {
    describe('.ratio()', function() {
      it('handles a 1:1 ratio', function() {
        expect( Metrics.ratio(5, 5) ).toBe(1);
      });
      it('handles a 1:2 ratio', function() {
        expect( Metrics.ratio(3, 6) ).toBe(0.5);
      });
      it('handles a 3:2 ratio', function() {
        expect( Metrics.ratio(9, 6) ).toBe(1.5);
      });
    });
  });

})();
