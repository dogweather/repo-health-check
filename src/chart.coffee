App.UI.drawChart = ->
  # First show the element so that it's correctly sized.
  id = 'trend-chart'
  $("##{id}").show()

  dataTable = new google.visualization.DataTable()
  dataTable.addColumn 'string', 'Week'
  dataTable.addColumn 'number', 'Effectiveness'

  dataTable.addRows [
    [
      '12/1'
      4.3
    ]
    [
      '12/8'
      4.9
    ]
    [
      '12/15'
      6.7
    ]
    [
      '12/22'
      2.3
    ]
  ]

  options =
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

  chart = new (google.visualization.LineChart)(document.getElementById(id))
  chart.draw dataTable, options
