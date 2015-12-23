(function() {
  'use strict';

  var REPO_INPUT    = '#github-repo';
  var RESULTS_DIV   = '#results';


  $(function() {
    setupEvents();
  });


  function setupEvents() {
    $(REPO_INPUT).keyup(function(e) {
      if (e.keyCode == 13) {
        checkRateLimit();
      }
    });
  }


  function checkRateLimit() {
    console.log("checkRateLimit()");

    App.Github.rateLimit(function(rateData) {
      showRateInfo(rateData);
      if (rateData.hasRemaining()) {
        startAnalysis();
      }
    });
  }


  function showRateInfo(rateData) {
    console.log("showRateInfo()");

    $('#rate-limit').text(rateData.limit);
    $('#rate-remaining').text(rateData.remaining);
  }


  function startAnalysis() {
    App.repo = new App.Repo( $(REPO_INPUT).val() );
  }

}());
