(function() {
  'use strict';

  describe('Give it some context', function() {
    describe('maybe a bit more context here', function() {
      it('should run here few assertions', function() {
        expect(true).toBe(true);
      });
    });
  });

  describe('MetricsMath', function() {
    describe('.ratio', function() {
      it('handles a 1:1 ratio', function() {
        expect( MetricsMath.ratio(5, 5) ).toBe(1);
      });
      it('handles a 1:2 ratio', function() {
        expect( MetricsMath.ratio(3, 6) ).toBe(0.5);
      });
      it('handles a 3:2 ratio', function() {
        expect( MetricsMath.ratio(9, 6) ).toBe(1.5);
      });
    });
  });

})();
