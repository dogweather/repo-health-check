App = exports? and exports or @App = {}


class App.Repo
  # @param repo_spec shoudl be a string like "facebook/react"
  constructor: (repo_spec) ->
    parts = repo_spec.split('/')
    @acct = parts[0]
    @name = parts[1]
    @rawdata = {}
