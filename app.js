(function() {
  'use strict';

  var REPO_INPUT  = '#github-repo';
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
  }

}());
