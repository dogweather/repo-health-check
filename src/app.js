(function() {
  'use strict';

  var REPO_INPUT = '#github-repo';


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
    $('button#sign-in').click(signIn);
    $('button#sign-out').click(signOut);

    $('#github-repo').keyup(function(e) {
      $('button#analyze').prop('disabled', (e.target.value === ''));
    });
    $('#github-username').keyup(function(e) {
      $('button#sign-in').prop('disabled', (e.target.value === ''));
    });
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
    App.UI.hideResults();
    App.UI.hideResultsDisplay();
    App.UI.progress(5);
    App.repo = new App.Repo($(REPO_INPUT).val(), showRepo, analyze, showError);
  }


  function showRepo(repo) {
    App.UI.hideError();
    refreshRateInfo();
    App.UI.showProgressBar();
    $('#results').show();
    $('#results h2').text(repo.name);
  }


  function analyze(repo) {
    App.UI.hideError();
    refreshRateInfo();
    $('#effectiveness-icon').attr('class', 'icon fa ' + Metrics.repoEffectivenessIcon(repo));
    $('#effectiveness-desc').text(Metrics.repoEffectivenessDesc(repo));
    window.setTimeout(App.UI.hideProgressBar, 500);
    window.setTimeout(App.UI.showResultsDisplay, 500);
  }


  function showError(message) {
    App.UI.showError(message);
  }


  function refreshRateInfo() {
    App.Github.rateLimit(function(rateData) {
      App.UI.showRateInfo(rateData);
    });
  }


  function enterWasHit(event) {
    return event.keyCode == 13;
  }

}());
