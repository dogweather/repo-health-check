'use strict';


// The following is ES6 but should just require changing the anonymous functions
// syntax
function octoFetchAll(fn, args) {
  let acc = []; // Accumulated results
  let p = new Promise((resolve, reject) => {
    fn(args).then((val) => {
      setProgress(App.Github.percentComplete(val));
      acc = acc.concat(val);
      if (val.nextPage) {
        return octoFetchAll(val.nextPage).then((val2) => {
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
