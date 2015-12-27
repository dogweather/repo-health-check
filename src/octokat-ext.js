'use strict';


// The following is ES6 but should just require changing the anonymous functions
// syntax
function octoFetchAll(fn, args) {
  var acc = []; // Accumulated results
  var p = new Promise(function(resolve, reject) {
    fn(args).then(function(val) {
      setProgress(App.Github.percentComplete(val));
      acc = acc.concat(val);
      if (val.nextPage) {
        return octoFetchAll(val.nextPage).then(function(val2) {
          acc = acc.concat(val2);
          resolve(acc);
        }, reject);
      } else {
        resolve(acc);
      }
    }, reject);
  });
  return p;
}

function setProgress(percent) {
  $('.progress-bar').attr('style', 'width: ' + percent + '%');
}
