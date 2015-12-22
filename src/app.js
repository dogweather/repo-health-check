(function() {
  'use strict';

  var REPO_INPUT = '#github-repo';
  var RESULTS_DIV = '#results';

  $(function() {
    setup_events();
  });

  function setup_events() {
    $(REPO_INPUT).keyup(function(e) {
      if (e.keyCode == 13) {
        run_checks();
      }
    });
  }

  function run_checks() {
    console.log("run_checks()");
    
    var repo = $(REPO_INPUT).val();
    var acct = repo.split('/')[0];
    var name = repo.split('/')[1];

    var octo = new Octokat();
    octo.repos(acct, name).fetch(function(err, repo) {
      if (err) {
        return alert(err);
      }
      alert(repo.url);
    });
  }

}());
