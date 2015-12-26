class App.Repo
  # @param repo_spec should be a string like "facebook/react" or a GitHub
  # project URL.
  constructor: (repo_spec, @repoCallback, @issuesCallback, network = true) ->
    [@acct, @name] = App.Github.parseRepoInput(repo_spec)
    @rawdata = {}
    @fetchData() if network


  fetchData: =>
    App.octo.repos(@acct, @name).fetch (err, repodata) =>
      if err
        console.log(err)
      else
        @rawdata.repo = repodata
        @repoCallback(this)
        @fetchIssues(@rawdata.repo)


  fetchIssues: (repo) =>
    # https://developer.github.com/v3/issues/#list-issues-for-a-repository
    # https://developer.github.com/guides/traversing-with-pagination/#basics-of-pagination
    options = {per_page: 100, state: 'all', since: App.Github.oneMonthAgo()}
    octoFetchAll(repo.issues.fetch, options).then (issues) =>
      @rawdata.issues = issues
      @issuesCallback(this)


  openPullRequestCount: =>
    @pullRequests().filter((pr) -> pr.state is 'open').length


  closedPullRequestCount: =>
    @pullRequests().filter((pr) -> pr.state is 'closed').length


  openIssueCount: =>
    @issues().filter((i) -> i.state is 'open').length


  closedIssueCount: =>
    @issues().filter((i) -> i.state is 'closed').length


  pullRequests: =>
    @rawdata.issues.filter (x) ->
      typeof(x.pullRequest) is 'object'


  issues: =>
    @rawdata.issues.filter (x) ->
      typeof(x.pullRequest) is 'undefined'
