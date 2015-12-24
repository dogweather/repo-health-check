class App.Repo
  # @param repo_spec should be a string like "facebook/react"
  constructor: (repo_spec, @repoCallback, @issuesCallback, network = true) ->
    [@acct, @name] = repo_spec.split('/')
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
    options = {state: 'all', since: App.Github.oneMonthAgo()}
    fetchAll(repo.issues.fetch, options).then (issues) =>
      @rawdata.issues = issues
      @issuesCallback(this)
