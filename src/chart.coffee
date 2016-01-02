App.UI.drawChart = ->
  # TODO: Refactor repo to a function parameter
  repo = App.repo

  # Must show the element first so that it's correctly sized.
  # TODO: Refactor id to a function parameter
  id = 'trend-chart'
  $("##{id}").show()

  chart = new (google.visualization.LineChart)(document.getElementById id)
  chart.draw dataTable(repo), options()


dataTable = (repo) ->
  dt = new google.visualization.DataTable()
  dt.addColumn 'string', 'Week'
  dt.addColumn 'number', 'Effectiveness'
  dt.addRows repo.trendData()
  dt


options = ->
  vAxis: {
    minValue: 0
    maxValue: 10
  }
  lineWidth: 4
  title: 'Trend'
  curveType: 'function'
  theme: 'material'
  legend: position: 'bottom'
  colors: [
    '#b9c246'
    '#e7711b'
    '#e49307'
    '#e2431e'
    '#d3362d'
  ]
