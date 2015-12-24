# Utility functions for working with the GitHub API
class App.Github

  @rateLimit: (callback) ->
    App.octo.rateLimit.fetch (err, data) ->
      if err
        console.log err
      else
        callback(
          limit: data.rate.limit,
          remaining: data.rate.remaining,
          hasRemaining: -> data.rate.remaining > 0
        )


  @oneMonthAgo: ->
    result = new Date
    result.setMonth(result.getMonth() - 1)
    return @dateFormat(result)


  # The date format specified in the API, e.g. 2015-12-23.
  @dateFormat: (aDate) ->
    year  = aDate.getFullYear()
    month = @padWithZeroes(aDate.getMonth() + 1, 2)
    day   = @padWithZeroes(aDate.getDate(), 2)
    [year, month, day].join('-')


  @padWithZeroes: (num, size) ->
    s = num + ""
    while (s.length < size)
      s = "0" + s
    s
