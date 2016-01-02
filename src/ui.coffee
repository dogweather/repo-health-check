# Functions for interacting with the HTML page, changing visibility and content.
#
# The intention is for this file to be the only place where HTML elements and
# CSS classes are referenced. And so, when the HTML structure changes, this is
# the only code that should need to be modified. A CoffeeScript `class` is a
# nice vehicle for easily creating namespaced functions.
class App.UI

  @anonymousMode = ->
    $('#api-mode').text 'anonymous'
    $('#github-username').val('')
    $('#github-password').val('')
    $('button#sign-out').hide()
    $('button#sign-in').show()
    $('#github-username').prop 'disabled', false
    $('#github-password').prop 'disabled', false
    $('button#sign-in').prop 'disabled', true
    $('#github-repo').focus()


  @signedInMode = (username) ->
    $('#api-mode').text 'authenticated'
    $('button#sign-in').hide()
    $('button#sign-out').show()
    $('#github-username').prop 'disabled', true
    $('#github-password').prop 'disabled', true
    $('#github-repo').focus()


  @showRateInfo = (rateData) ->
    $('#rate-limit').text rateData.limit
    $('#rate-remaining').text rateData.remaining


  @progress = (percent) ->
    if percent > 0
      @_changeProgress percent
      @showProgressBar()
    else
      @hideProgressBar()
      @_changeProgress percent


  @refreshLog = (repos) ->
    tbody = "<tbody>#{@logRows(repos)}</tbody>"
    $('table#log tbody').replaceWith(tbody)
    $('#avg-effectiveness').text @average(repos, ((r) -> r.effectiveness()))


  @logRows = (repos) ->
    rows = repos.reduce (acc, r) =>
      acc + @tr(@td(@linkedRepoName(r)),
      @td(sprintf '%.1f',
      r.effectiveness()),
      @td('(tbd)', ''))
    , ''


  @linkedRepoName = (repo) ->
    "<a href=#{repo.url()} target=_blank>" +
    "#{repo.name}<img class=external-link-icon src=external_link_icon.png></a>"


  @average = (items, f) ->
    sum = items.reduce ((acc, i) -> acc + f(i)), 0
    sprintf '%.1f', sum / items.length


  @td = (text, htmlClass='data') -> "<td class='#{htmlClass}'>#{text}</td>"

  @tr = (cells...) -> "<tr>#{cells.join ''}</tr>"


  @showError = (message) ->
    $('#error-text').text message
    $('#error-alert').show()

  @hideError = ->
    $('#error-alert').hide()


  @showProgressBar = -> $('#progress-display').show()
  @hideProgressBar = -> $('#progress-display').hide()

  @showResultsDisplay = -> $('.results-display').show()
  @hideResultsDisplay = -> $('.results-display, #trend-chart').hide()

  @showResults = -> $('#results').show()
  @hideResults = -> $('#results').hide()


  @_changeProgress = (percent) ->
    $('.progress-bar').attr 'style', "width: #{percent}%"
