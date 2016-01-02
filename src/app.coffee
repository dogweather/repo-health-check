REPO_INPUT = "#github-repo"


$ ->
  setupEvents()
  refreshRateInfo()
  checkForPermalink()


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


refreshRateInfo = ->
  App.Github.rateLimit (rateData) ->
    App.UI.showRateInfo rateData


checkForPermalink = ->
  if window.location.hash
    repoSpec = decodeURIComponent window.location.hash.slice 1
    $(REPO_INPUT).val(repoSpec)
    startAnalysis()


signIn = ->
  username = $("#github-username").val()
  password = $("#github-password").val()
  if username and password
    App.octo = new Octokat username: username, password: password
    App.UI.signedInMode()
    refreshRateInfo()


signOut = ->
  App.octo = new Octokat()
  App.UI.anonymousMode()
  refreshRateInfo()


startAnalysis = ->
  userInput = $(REPO_INPUT).val()
  setNewUrl(userInput)
  App.UI.hideResults()
  App.UI.hideResultsDisplay()
  App.UI.progress 5
  App.repo = new App.Repo userInput, showRepo, analyze, showError


setNewUrl = (userInput) ->
  try
    slug = '#' + encodeURIComponent(userInput)
    history.pushState(null, null, slug)
  catch error
    console.log error


showRepo = (repo) ->
  App.UI.hideError()
  refreshRateInfo()
  App.UI.showProgressBar()
  $("#results").show()
  $("#results h2").text repo.name


analyze = (repo) ->
  App.UI.hideError()
  refreshRateInfo()
  icon_class = "icon fa " + App.Metrics.repoEffectivenessIcon(repo)
  # Show effectiveness
  $("#effectiveness-icon").attr "class", icon_class
  $("#effectiveness-desc").text App.Metrics.repoEffectivenessDesc(repo)
  $(".effectiveness").text sprintf '%.1f', repo.effectiveness()
  $(".pr-effectiveness").text sprintf '%.1f', repo.prEffectiveness()
  $(".issue-effectiveness").text sprintf '%.1f', repo.issueEffectiveness()
  $('.open-prs').text repo.openPullRequestCount()
  $('.closed-prs').text repo.closedPullRequestCount()
  $('.open-issues').text repo.openIssueCount()
  $('.closed-issues').text repo.closedIssueCount()
  addRepoToLog repo
  window.setTimeout App.UI.hideProgressBar, 500
  window.setTimeout App.UI.showResultsDisplay, 500
  window.setTimeout App.UI.drawChart, 500


addRepoToLog = (repo) ->
  if not _repoInList(repo, App.log)
    App.log.push repo
    App.UI.refreshLog App.log


showError = (message) ->
  App.UI.showError message


enterWasHit = (event) ->
  event.keyCode is 13


_repoInList = (repo, repos) ->
  _.some repos, (r) -> r.equals(repo)
