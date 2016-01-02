App.octoFetchAll = function (fn, args) {
  var acc = []; // Accumulated results
  var p = new Promise(function(resolve, reject) {
    fn(args).then(function(val) {
      App.UI.progress(App.Github.percentComplete(val));
      acc = acc.concat(val);
      if (val.nextPage) {
        return App.octoFetchAll(val.nextPage).then(function(val2) {
          acc = acc.concat(val2);
          resolve(acc);
        }, reject);
      } else {
        resolve(acc);
      }
    }, reject);
  });
  return p;
};


// URL Query params
// http://stackoverflow.com/a/3855394/106906
// TODO: Move to a better location
App.query = {};
location.search.substr(1).split("&").forEach(function(item) {
    var s = item.split("="),
        k = s[0],
        v = s[1] && decodeURIComponent(s[1]);
    (k in App.query) ? App.query[k].push(v) : App.query[k] = [v];
});
