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
    });
  });

})();
