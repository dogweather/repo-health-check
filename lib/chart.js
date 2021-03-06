// Generated by CoffeeScript 1.10.0
(function() {
  var dataTable, options;

  App.UI.drawChart = function() {
    var chart, id, repo;
    repo = App.repo;
    id = 'trend-chart';
    $("#" + id).show();
    chart = new google.visualization.LineChart(document.getElementById(id));
    return chart.draw(dataTable(repo), options());
  };

  dataTable = function(repo) {
    var dt;
    dt = new google.visualization.DataTable();
    dt.addColumn('string', 'Week');
    dt.addColumn('number', 'Effectiveness');
    dt.addRows(repo.trendData());
    return dt;
  };

  options = function() {
    return {
      vAxis: {
        viewWindow: {
          min: 0,
          max: 10
        }
      },
      lineWidth: 3,
      title: 'Trend',
      curveType: 'function',
      theme: 'material',
      legend: {
        position: 'bottom'
      },
      colors: ['#b9c246', '#e7711b', '#e49307', '#e2431e', '#d3362d']
    };
  };

}).call(this);
