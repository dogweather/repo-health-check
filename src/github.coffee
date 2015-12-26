# Utility functions for working with the GitHub API
class App.Github

  @parseRepoInput: (text) ->
    if @isRepoSpec(text)
      text.split('/')
    else if @isUrl(text)
      matches = text.match(/^https:\/\/github.com\/([^/]+)\/([^/]+)/)
      [matches[1], matches[2]]
    else
      null


  @isUrl: (text) ->
    /^https:\/\/github.com\/[^/]+\/[^/]+/.test(text)


  @isRepoSpec: (text) ->
    /^[^/]+\/[^/]+$/.test(text)


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


  @pageCount: (apiResult) ->
    url = apiResult.lastPageUrl
    if typeof(url) is 'undefined'
      url = apiResult.prevPageUrl
      return 1 if typeof(url) is 'undefined'
      parseInt(url.match(/\d+$/)[0]) + 1
    else
      parseInt(url.match(/\d+$/)[0])


  @currentPage: (apiResult) ->
    url = apiResult.nextPageUrl
    if typeof(url) is 'undefined'
      url = apiResult.prevPageUrl
      return 1 if typeof(url) is 'undefined'
      parseInt(url.match(/\d+$/)[0]) + 1
    else
      parseInt(url.match(/\d+$/)[0]) - 1


  @percentComplete: (apiResult) ->
    parseInt(@currentPage(apiResult) / @pageCount(apiResult) * 100)
