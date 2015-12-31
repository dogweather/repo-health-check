class App.Repo
  # @param repoSpec should be a string like "facebook/react" or a GitHub
  # project URL.
  constructor: (repoSpec,
                @repoCallback,
                @issuesCallback,
                @errorCallback,
                network = true) ->
    repoInfo = App.Github.parseRepoInput(repoSpec)
    if not repoInfo?
      @errorCallback("Couldn't parse #{repoSpec}")
      return
    [@acct, @name] = repoInfo
    @rawdata = {}
    @fetchData() if network


  url: =>
    "https://github.com/#{@acct}/#{@name}"


  fetchData: =>
    App.octo.repos(@acct, @name).fetch (err, repodata) =>
      if err
        @errorCallback(err.message)
      else
        @rawdata.repo = repodata
        @repoCallback(this)
        @fetchIssues(@rawdata.repo)


  fetchIssues: (repo) =>
    # https://developer.github.com/v3/issues/#list-issues-for-a-repository
    # https://developer.github.com/guides/traversing-with-pagination/#basics-of-pagination
    options = {per_page: 100, state: 'all', since: App.Github.oneMonthAgo()}
    App.octoFetchAll(repo.issues.fetch, options).then (issues) =>
      @rawdata.issues = issues
      @issuesCallback(this)


  openPullRequestCount: =>
    @pullRequests()
      .filter (pr) -> pr.state is 'open'
      .length


  closedPullRequestCount: =>
    @pullRequests()
      .filter (pr) -> pr.state is 'closed'
      .length


  openIssueCount: =>
    @issues()
      .filter (i) -> i.state is 'open'
      .length


  closedIssueCount: =>
    @issues()
      .filter (i) -> i.state is 'closed'
      .length


  pullRequests: =>
    @rawdata
      .issues
      .filter (x) -> typeof(x.pullRequest) is 'object'


  issues: =>
    @rawdata
      .issues
      .filter (x) -> typeof(x.pullRequest) is 'undefined'


  effectiveness: =>
    Metrics.repoEffectiveness this


  prEffectiveness: =>
    Metrics.prEffectiveness this


  issueEffectiveness: =>
    Metrics.issueEffectiveness this
