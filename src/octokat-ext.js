'use strict';


// The following is ES6 but should just require changing the anonymous functions
// syntax
function fetchAll(fn, args) {
  let acc = []; // Accumulated results
  let p = new Promise((resolve, reject) => {
    fn(args).then((val) => {
      console.log(val.lastPageUrl);
      acc = acc.concat(val);
      if (val.nextPage) {
        return fetchAll(val.nextPage).then((val2) => {
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
