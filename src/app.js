(function() {
  'use strict';

  var REPO_INPUT    = '#github-repo';
  var RESULTS_DIV   = '#results';


  $(function() {
    setupEvents();
    checkRateLimit();
  });


  function setupEvents() {
    $(REPO_INPUT).keyup(function(e) {
      if (enterWasHit(e)) {
        startAnalysis();
      }
    });

    $('button#analyze').click(startAnalysis);

    $('button#sign-in').click(function(e) {
      App.octo = new Octokat({
        username: $('#github-username').val(),
        password: $('#github-password').val()
      });
      console.log('sign in');
    });
  }


  function checkRateLimit() {
    App.Github.rateLimit(function(rateData) {
      showRateInfo(rateData);
    });
  }


  function showRateInfo(rateData) {
    $('#rate-info').show();
    $('#rate-limit').text(rateData.limit);
    $('#rate-remaining').text(rateData.remaining);
  }


  function startAnalysis() {
    var repoSpec = $(REPO_INPUT).val();
    var analyze  = function(repo) { console.log("analyze()"); checkRateLimit(); };
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
