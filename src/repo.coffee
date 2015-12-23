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
    one_month_ago = '2015-12-22'
    fetchAll(repo.issues.fetch, {state: 'open', since: one_month_ago}).then (openIssues) =>
      @rawdata.openIssues = openIssues
    fetchAll(repo.issues.fetch, {state: 'closed', since: one_month_ago}).then (closedIssues) =>
      @rawdata.closedIssues = closedIssues
