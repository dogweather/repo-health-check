var Metrics = {};

(function() {
  'use strict';

  Metrics.ratio = function(x, y) {
    return x / y;
  };

  Metrics.effectiveness_desc = function(rating) {
    if (rating >= 0 && rating <= 3) {
      return 'in the weeds';
    }
    if (rating >= 4 && rating <= 6) {
      return 'treading water';
    }
    if (rating >= 7 && rating <= 10) {
      return 'on top of it';
    }
    throw new RangeError('Rating must be between 0 and 11');
  };

}());
