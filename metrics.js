var Metrics = Metrics || {};

(function() {
  'use strict';

  Metrics.effectiveness = function(merged_prs, proposed_prs, closed_issues, new_issues) {
    return (0.66 * Metrics.pr_effectiveness(merged_prs, proposed_prs)) +
           (0.34 * Metrics.issue_effectiveness(closed_issues, new_issues));
  };

  Metrics.pr_effectiveness = function(merged_prs, proposed_prs) {
    return Metrics.scaled(Metrics.ratio(merged_prs, proposed_prs));
  };

  Metrics.issue_effectiveness = function(closed_issues, new_issues) {
    return Metrics.scaled(Metrics.ratio(closed_issues, new_issues));
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

  Metrics.ratio = function(x, y) {
    return x / y;
  };

  // Scale a ratio to the range 0–10.
  // See http://math.stackexchange.com/questions/1582722/how-to-scale-a-ratio-to-a-limited-range
  Metrics.scaled = function(ratio) {
    if (ratio === Infinity) return 10;
    return 10 * (ratio / (1 + ratio));
  };

}());
