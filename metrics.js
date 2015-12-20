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

  Metrics.effectiveness = function(
    merged_pull_requests,
    proposed_pull_requests,
    closed_issues,
    new_issues) {
    return average(
      Metrics.scaled(Metrics.ratio(merged_pull_requests, proposed_pull_requests)),
      Metrics.scaled(Metrics.ratio(closed_issues, new_issues))
    );
  };

  // Scale a ratio to the range 0–10.
  // See http://math.stackexchange.com/questions/1582722/how-to-scale-a-ratio-to-a-limited-range
  Metrics.scaled = function(ratio) {
    if (ratio === Infinity) return 10;
    return 10 * (ratio / (1 + ratio));
  };


  function average(a, b) {
    return (a + b) / 2;
  }

}());
