(function() {
  'use strict';

  var REPO_INPUT = '#github-repo';
  var RESULTS_DIV = '#results';


  $(function() {
    setupEvents();
    refreshRateInfo();
  });


  function setupEvents() {
    $(REPO_INPUT).keyup(function(e) {
      if (enterWasHit(e)) {
        startAnalysis();
      }
    });
    $('#github-password').keyup(function(e) {
      if (enterWasHit(e)) {
        signIn();
      }
    });
    $('button#analyze').click(startAnalysis);
    $('#github-repo').keyup(function(e) {
      $('button#analyze').prop('disabled', (e.target.value === ''));
    });
    $('button#sign-in').click(signIn);
    $('button#sign-out').click(signOut);
  }


  function signIn() {
    var username = $('#github-username').val();
    var password = $('#github-password').val();

    if (username && password) {
      App.octo = new Octokat({
        username: username,
        password: password
      });
      App.UI.signedInMode();
      refreshRateInfo();
    }
  }


  function signOut() {
    App.octo = new Octokat();
    App.UI.anonymousMode();
    refreshRateInfo();
  }


  function startAnalysis() {
    $('#effectiveness-result').text(' ');
    App.UI.progress(5);
    var repoSpec = $(REPO_INPUT).val();
    App.repo = new App.Repo(repoSpec, showRepo, analyze);
  }


  function showRepo(repo) {
    $(RESULTS_DIV).show();
    $('#results .panel-title').text(repo.name);
    refreshRateInfo();
  }


  function analyze(repo) {
    refreshRateInfo();
    $('#effectiveness-result').text(Metrics.repoEffectiveness(repo));
    window.setTimeout(App.UI.hideProgressBar, 1000);
  }


  function refreshRateInfo() {
    App.Github.rateLimit(function(rateData) {
      showRateInfo(rateData);
    });
  }


  function showRateInfo(rateData) {
    $('#rate-limit').text(rateData.limit);
    $('#rate-remaining').text(rateData.remaining);
  }


  function enterWasHit(event) {
    return event.keyCode == 13;
  }

}());
