App = exports? and exports or @App = {}


App.octo = new Octokat()


class App.Github

  @rateLimit: (callback) ->
    App.octo.rateLimit.fetch (err, data) ->
      callback(
        limit: data.rate.limit,
        remaining: data.rate.remaining,
        hasRemaining: ->
          data.rate.remaining > 0
      )
