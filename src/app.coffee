REPO_INPUT = "#github-repo"


$ ->
  setupEvents()
  refreshRateInfo()


setupEvents = ->
  $(REPO_INPUT).keyup (e) ->
    startAnalysis()  if enterWasHit(e)

  $("#github-password").keyup (e) ->
    signIn() if enterWasHit(e)

  $("button#analyze").click startAnalysis
  $("button#sign-in").click signIn
  $("button#sign-out").click signOut
  $("#github-repo").keyup (e) ->
    $("button#analyze").prop "disabled", (e.target.value is "")

  $("#github-username").keyup (e) ->
    $("button#sign-in").prop "disabled", (e.target.value is "")


signIn = ->
  username = $("#github-username").val()
  password = $("#github-password").val()
  if username and password
    App.octo = new Octokat(
      username: username
      password: password
    )
    App.UI.signedInMode()
    refreshRateInfo()


signOut = ->
  App.octo = new Octokat()
  App.UI.anonymousMode()
  refreshRateInfo()


startAnalysis = ->
  App.UI.hideResults()
  App.UI.hideResultsDisplay()
  App.UI.progress 5
  App.repo = new App.Repo($(REPO_INPUT).val(), showRepo, analyze, showError)


showRepo = (repo) ->
  App.UI.hideError()
  refreshRateInfo()
  App.UI.showProgressBar()
  $("#results").show()
  $("#results h2").text repo.name


analyze = (repo) ->
  App.UI.hideError()
  refreshRateInfo()
  icon_class = "icon fa " + Metrics.repoEffectivenessIcon(repo)
  $("#effectiveness-icon").attr "class", icon_class
  $("#effectiveness-desc").text Metrics.repoEffectivenessDesc(repo)
  $(".effectiveness").text sprintf '%.1f', repo.effectiveness()
  $(".pr-effectiveness").text sprintf '%.1f', repo.prEffectiveness()
  $(".issue-effectiveness").text sprintf '%.1f', repo.issueEffectiveness()
  $('.open-prs').text repo.openPullRequestCount()
  $('.closed-prs').text repo.closedPullRequestCount()
  $('.open-issues').text repo.openIssueCount()
  $('.closed-issues').text repo.closedIssueCount()
  App.UI.drawChart()
  window.setTimeout App.UI.hideProgressBar, 500
  window.setTimeout App.UI.showResultsDisplay, 500
  addRepoToLog repo


addRepoToLog = (repo) ->
  App.log.push repo
  App.UI.refreshLog App.log


showError = (message) ->
  App.UI.showError message


refreshRateInfo = ->
  App.Github.rateLimit (rateData) ->
    App.UI.showRateInfo rateData


enterWasHit = (event) ->
  event.keyCode is 13
