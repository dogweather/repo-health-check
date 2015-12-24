(function() {
  'use strict';

  var REPO_INPUT    = '#github-repo';
  var RESULTS_DIV   = '#results';


  $(function() {
    setupEvents();
  });


  function setupEvents() {
    $(REPO_INPUT).keyup(function(e) {
      if (enterWasHit(e)) {
        checkRateLimit();
      }
    });

    $('button').click(function() {
      checkRateLimit();
    });
  }


  function checkRateLimit() {
    App.Github.rateLimit(function(rateData) {
      // showRateInfo(rateData);
      if (rateData.hasRemaining()) {
        startAnalysis();
      }
    });
  }


  function showRateInfo(rateData) {
    $('#rate-info').show();
    $('#rate-limit').text(rateData.limit);
    $('#rate-remaining').text(rateData.remaining);
  }


  function startAnalysis() {
    var repoSpec = $(REPO_INPUT).val();
    var analyze  = function(repo) { console.log("analyze()"); };
    App.repo = new App.Repo( repoSpec, showRepo, analyze );
  }


  function enterWasHit(event) {
    return event.keyCode == 13;
  }


  function showRepo(repo) {
    $(RESULTS_DIV).show();
    $('#results .panel-title').text(repo.name);
  }

}());
