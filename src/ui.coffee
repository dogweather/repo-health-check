class App.UI

  @hideProgressBar: ->
    $('div.progress').hide('fast')


  @showProgressBar: ->
    $('div.progress').show('fast')


  @setProgress: (percent) ->
    $('.progress-bar').attr('style', 'width: ' + percent + '%')
