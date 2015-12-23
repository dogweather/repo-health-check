App = exports? and exports or @App = {}


App.octo = new Octokat()


class App.Github

  @rateLimit: (callback) ->
    App.octo.rateLimit.fetch (err, data) ->
      callback(
        limit: data.rate.limit,
        remaining: data.rate.remaining,
        hasRemaining: -> data.rate.remaining > 0
      )


  @oneMonthAgo: ->
    result = new Date
    result.setMonth(result.getMonth() - 1)
    return @dateFormat(result)


  @dateFormat: (d) ->
    d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate()
