var GitHubRepo = GitHubRepo || {};

(function() {
  'use strict';
  var Xray = require("x-ray");
  var xray = Xray();

  GitHubRepo.proposed_pull_requests = function(repo) {
    var url = "https://github.com/" + repo + "/pulse";
    xray(url, "#proposed-pull-requests .text-emphasized")(function(err, num) {
      console.log("error: " + err);
      console.log("num:   " + num);
    })
  }

}());
