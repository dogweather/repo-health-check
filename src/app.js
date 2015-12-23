var repo = {
  rawdata: {}
};


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

    var userinput = $(REPO_INPUT).val().split('/');
    var acct = userinput[0];
    var name = userinput[1];

    var octo = new Octokat();

    octo.repos(acct, name).fetch(function(err, repodata) {
      if (err) {
        return alert(err);
      } else {
        repo.rawdata.repo = repodata;

        fetchAll(octo.repos(acct, name).issues.fetch).then((allIssues) => {
          repo.rawdata.open_issues = allIssues;
          console.log(repo);
        });

      }
    });
  }

}());
