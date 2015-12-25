class App.UI

  @setProgress: (percent) ->
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
