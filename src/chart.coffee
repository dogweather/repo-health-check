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
  dataTable = new google.visualization.DataTable()
  dataTable.addColumn 'string', 'Week'
  dataTable.addColumn 'number', 'Effectiveness'
  dataTable.addRows repo.trendData()
  dataTable


options = ->
  vAxis: {
    minValue: 0
    maxValue: 10
  }
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
