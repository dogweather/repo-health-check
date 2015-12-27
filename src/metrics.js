var Metrics = Metrics || {};

(function() {
  'use strict';


  Metrics.repoEffectivenessIcon = function(repo) {
    var rating = Metrics.repoEffectiveness(repo);
    if (rating >= 0 && rating < 3) {
      return 'fa-frown-o';
    }
    if (rating >= 3 && rating < 4.5) {
      return 'fa-meh-o';
    }
    if (rating >= 4.5 && rating < 7) {
      return 'fa-smile-o';
    }
    if (rating >= 7 && rating <= 10) {
      return 'fa-smile-o green-glow';
    }
    throw new RangeError('Rating must be between 0 and 11');
  };


  Metrics.repoEffectivenessDesc = function(repo) {
    return Metrics.effectivenessDesc(Metrics.repoEffectiveness(repo));
  };

  Metrics.repoEffectiveness = function(repo) {
    return Metrics.effectiveness(
      repo.closedPullRequestCount(),
      repo.openPullRequestCount(),
      repo.closedIssueCount(),
      repo.openIssueCount()
    );
  };

  Metrics.effectiveness = function(
    merged_prs, proposed_prs, closed_issues, new_issues) {
    var inputs = [merged_prs, proposed_prs, closed_issues, new_issues].join(', ');
    var prs = Metrics.pr_effectiveness(merged_prs, proposed_prs);
    var issues = Metrics.issue_effectiveness(closed_issues, new_issues);
    return Math.round((0.66 * prs) + (0.34 * issues));
  };

  Metrics.pr_effectiveness = function(merged_prs, proposed_prs) {
    return Metrics.scaled(Metrics.ratio(merged_prs, proposed_prs));
  };

  Metrics.issue_effectiveness = function(closed_issues, new_issues) {
    return Metrics.scaled(Metrics.ratio(closed_issues, new_issues));
  };

  Metrics.effectivenessDesc = function(rating) {
    if (rating >= 0 && rating <= 3) {
      return 'In the weeds';
    }
    if (rating >= 4 && rating <= 6) {
      return 'Doing fine';
    }
    if (rating >= 7 && rating <= 10) {
      return 'Super effective!';
    }
    throw new RangeError('Rating must be between 0 and 11');
  };

  Metrics.ratio = function(x, y) {
    if (x === 0 && y === 0) {
      return 1;
    } else {
      return x / y;
    }
  };

  // Scale a ratio to the range 0–10.
  // See http://math.stackexchange.com/questions/1582722/how-to-scale-a-ratio-to-a-limited-range
  Metrics.scaled = function(ratio) {
    if (ratio === Infinity) return 10;
    return 10 * (ratio / (1 + ratio));
  };

}());
