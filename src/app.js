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
    $('#results').hide();
    $('#results-display').hide();
    App.UI.progress(5);
    App.repo = new App.Repo($(REPO_INPUT).val(), showRepo, analyze, showError);
  }


  function showRepo(repo) {
    refreshRateInfo();
    App.UI.showProgressBar();
    $('#results').show();
    $('#results .panel-title').text(repo.name);
  }


  function analyze(repo) {
    refreshRateInfo();
    $('#effectiveness-result').text(Metrics.repoEffectiveness(repo));
    $('#effectiveness-desc').text(Metrics.repoEffectivenessDesc(repo));
    $('#effectiveness-icon').attr('class', 'icon fa ' + Metrics.repoEffectivenessIcon(repo));
    window.setTimeout(App.UI.hideProgressBar, 700);
    window.setTimeout("$('#results-display').show();", 700);
  }


  function showError(message) {
    console.log("showError: "+message);
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
