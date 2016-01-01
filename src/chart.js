google.setOnLoadCallback(drawChart);

function drawChart() {
  var data = google.visualization.arrayToDataTable([
    ['Week', 'Effectiveness', 'Activity'],
    ['12/1', 4.3, 5],
    ['12/8', 4.9, 6],
    ['12/15', 6.7, 3],
    ['12/22', 2.3, 8]
  ]);

  var options = {
    title: 'Trends',
    curveType: 'function',
    lineWidth: 3,
    theme: 'material',
    legend: {
      position: 'bottom'
    },
    colors: [
      '#b9c246',
      '#e7711b',
      '#e49307',
      '#e2431e',
      '#d3362d',
    ],
  };

  var chart = new google.visualization.LineChart(document.getElementById('trend_chart'));

  chart.draw(data, options);
}
