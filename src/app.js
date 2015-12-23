var repo;
var octo = new Octokat();


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

    repo = new App.Repo($(REPO_INPUT).val());

    octo.repos(repo.acct, repo.name).fetch(function(err, repodata) {
      if (err) {
        return alert(err);
      } else {
        repo.rawdata.repo = repodata;

        fetchAll(octo.repos(repo.acct, repo.name).issues.fetch).then((allIssues) => {
          repo.rawdata.open_issues = allIssues;
          console.log(repo);
        });

      }
    });
  }

}());
