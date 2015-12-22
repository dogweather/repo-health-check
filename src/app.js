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

    var acct = $(REPO_INPUT).val().split('/')[0];
    var name = $(REPO_INPUT).val().split('/')[1];

    var octo = new Octokat();
    var repo;

    octo.repos(acct, name).fetch(function(err, repodata) {
      if (err) {
        return alert(err);
      }
      repo = repodata;
      console.log(repo);
    });
  }

}());
