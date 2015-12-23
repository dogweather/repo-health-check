App = exports? and exports or @App = {}


class App.Repo
  # @param repo_spec should be a string like "facebook/react"
  constructor: (repo_spec) ->
    parts = repo_spec.split('/')
    @acct = parts[0]
    @name = parts[1]
    @rawdata = {}
    @octo = new Octokat
    @fetchData()

  fetchData: ->
    @octo.repos(@acct, @name).fetch (err, repodata) ->
      if err
        alert(err)
      else
        @rawdata.repo = repodata
        fetchAll(@octo.repos(@acct, @name).issues.fetch).then (allIssues) ->
          @rawdata.open_issues = allIssues
          console.log repo
