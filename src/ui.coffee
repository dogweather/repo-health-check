class App.UI

  @anonymousMode: ->
    $('#api-mode').text('anonymous')
    $('#github-username').val('')
    $('#github-password').val('')
    $('button#sign-out').hide()
    $('button#sign-in').show()


  @signedInMode: (username) ->
    $('#api-mode').text('authenticated')
    $('button#sign-in').hide()
    $('button#sign-out').show()



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
