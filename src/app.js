(function() {
  'use strict';

  var REPO_INPUT = '#github-repo';
  var RESULTS_DIV = '#results';


  $(function() {
    setupEvents();
    displayRateLimit();
  });


  function setupEvents() {
    $(REPO_INPUT).keyup(function(e) {
      if (enterWasHit(e)) {
        startAnalysis();
      }
    });

    $('button#analyze').click(startAnalysis);
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
      $('#user-display').show();
      $('#user-display .username').text(username);
      displayRateLimit();
    }
  }


  function signOut() {
    App.octo = new Octokat();
  }


  function displayRateLimit() {
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
    setProgress(0);
    showProgressBar();
    var repoSpec = $(REPO_INPUT).val();
    App.repo = new App.Repo(repoSpec, showRepo, analyze);
  }


  function showRepo(repo) {
    $(RESULTS_DIV).show();
    $('#results .panel-title').text(repo.name);
  }


  function analyze(repo) {
    displayRateLimit();
    $('#effectiveness-result').text(Metrics.repoEffectiveness(repo));
    window.setTimeout(hideProgressBar, 1000);
  }


  function hideProgressBar() {
    $('div.progress').hide('fast');
  }


  function showProgressBar() {
    $('div.progress').show('fast');
  }


  function setProgress(percent) {
    $('.progress-bar').attr('style', 'width: ' + percent + '%');
  }


  function enterWasHit(event) {
    return event.keyCode == 13;
  }

}());
