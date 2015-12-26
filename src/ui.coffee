class App.UI

  @anonymousMode: ->
    $('#api-mode').text('anonymous')
    $('#github-username').val('')
    $('#github-password').val('')


  @signedInMode: (username) ->
    $('#api-mode').text('authenticated')


  @progress: (percent) ->
    if percent > 0
      @_changeProgress()
      @showProgressBar()
    else
      @hideProgressBar()
      @_changeProgress()


  @hideProgressBar: ->
    $('div.progress').hide('fast')


  @showProgressBar: ->
    $('div.progress').show('fast')



  @_changeProgress: (percent) ->
    $('.progress-bar').attr('style', 'width: ' + percent + '%')
