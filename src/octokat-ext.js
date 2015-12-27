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
