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

    describe('.effectiveness_desc()', function() {
      it('handles a range from 0 to 10', function() {
        expect( Metrics.effectiveness_desc( 0) ).toBe('in the weeds');
        expect( Metrics.effectiveness_desc( 5) ).toBe('treading water');
        expect( Metrics.effectiveness_desc(10) ).toBe('on top of it');
      });
      it('throws an error when outside 0 to 10', function() {
        expect( function(){ Metrics.effectiveness_desc(15); } ).toThrowError(RangeError);
        expect( function(){ Metrics.effectiveness_desc(-1); } ).toThrowError(RangeError);
      });
    });
  });

})();
