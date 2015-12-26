class App.UI

  @anonymousMode: ->
    $('#api-mode').text('anonymous')
    $('#github-username').val('')
    $('#github-password').val('')
    $('button#sign-out').hide()
    $('button#sign-in').show()
    $('#github-username').prop('disabled', false)
    $('#github-password').prop('disabled', false)
    $('button#sign-in').prop('disabled', true)
    $('#github-repo').focus()


  @signedInMode: (username) ->
    $('#api-mode').text('authenticated')
    $('button#sign-in').hide()
    $('button#sign-out').show()
    $('#github-username').prop('disabled', true)
    $('#github-password').prop('disabled', true)
    $('#github-repo').focus()


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
