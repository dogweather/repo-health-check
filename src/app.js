(function() {
  'use strict';

  var REPO_INPUT = '#github-repo';
  var RESULTS_DIV = '#results';


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
      checkRateLimit();
    }
  }


  function signOut() {
    App.octo = new Octokat();
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
    var analyze = function(repo) {
      console.log("analyze()");
      checkRateLimit();
    };
    App.repo = new App.Repo(repoSpec, showRepo, analyze);
  }


  function enterWasHit(event) {
    return event.keyCode == 13;
  }


  function showRepo(repo) {
    $(RESULTS_DIV).show();
    $('#results .panel-title').text(repo.name);
  }

}());
