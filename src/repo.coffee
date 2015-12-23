class App.Repo
  # @param repo_spec should be a string like "facebook/react"
  constructor: (repo_spec, accessNetwork = true) ->
    [@acct, @name] = repo_spec.split('/')
    @rawdata = {}
    @fetchData() if accessNetwork


  fetchData: =>
    App.octo.repos(@acct, @name).fetch (err, repodata) =>
      if err
        alert(err)
      else
        @rawdata.repo = repodata
        @fetchIssues(@rawdata.repo)


  fetchIssues: (repo) =>
    options = {state: 'open', since: App.Github.oneMonthAgo()}
    fetchAll(repo.issues.fetch, options).then (issues) =>
      @rawdata.openIssues = issues

    options.state = 'closed'
    fetchAll(repo.issues.fetch, options).then (issues) =>
      @rawdata.closedIssues = issues
