App = exports? and exports or @App = {}


class App.Repo
  # @param repo_spec should be a string like "facebook/react"
  constructor: (repo_spec) ->
    [@acct, @name] = repo_spec.split('/')
    @rawdata = {}
    @octo = new Octokat()
    @fetchData()

  fetchData: =>
    @octo.repos(@acct, @name).fetch (err, repodata) =>
      if err
        alert(err)
      else
        @rawdata.repo = repodata
        @fetchIssues()

  fetchIssues: =>
    fetchAll(@octo.repos(@acct, @name).issues.fetch, {state: 'open'}).then (openIssues) =>
      @rawdata.openIssues = openIssues
    fetchAll(@octo.repos(@acct, @name).issues.fetch, {state: 'closed'}).then (closedIssues) =>
      @rawdata.closedIssues = closedIssues
