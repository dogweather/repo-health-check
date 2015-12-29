# Repo Health Check
Analyze a project and its management

![screenshot](https://raw.githubusercontent.com/dogweather/repo-health-check/master/docs/screenshot.jpg)

[Live app →](http://repocheck.com/)

This is a fully client-side GitHub/BitBucket repo analyzer. It finds out: Is a
project well managed? Does it _accept_ help? How does it compare to other
options? And then: what should you do to take your repo from **in the weeds** to
**_super effective_**?

It performs the hard work entirely in the browser so that each user's own API
rate limits are in effect. This avoids [problems similar projects](https://github.com/hstove/issue_stats/issues/10#issuecomment-58444422) have had, and means faster and more varied results.


## Use Cases

* **A developer looking for a library** wants to compare management styles of a few alternatives.
* **A developer thinking about contributing** to a project wants to know if it's worth it.
* **A job candidate wants to know** how a prospective employer manages their projects.
* **A company** wants to see if all its projects are being managed similarly.


## Objectives

This will be a library which will be able to;

* Determine: does Project _want_ help?
* Determine: does Project _accept_ help?
* Rate a project:
  * Is it well managed?
    * (What exactly will this mean?)


## Automated Signals

Quantitative measurements which can determine _qualitative_ assessments.

* Num. of active branches
  * merged
  * un-merged
* Num. of stale branches
  * merged
  * un-merged
* Num. of open pull requests
  * proportion open:closed pull requests
  * aging of pull requests
* Num. of open issues
  * proportion open:closed issues
* Num. of stars
* Num. of forks
* Num. of subscribers
* ratio of # of tags to # of tags in use


### Intermediate Metrics

By using the raw signals listed above, we can calculate useful metrics. These metrics, then, will be the pieces that can form a judgement for the big questions.

E.g.:
* How are the maintainers keeping up with the queue of incoming PR's?


### Other sources

* Code Climate score
* Travis CI passing


### See Also

* https://www.quora.com/If-a-GitHub-project-has-a-lot-of-forks-what-are-some-guidelines-for-choosing-the-right-one


### Useful Tech

* [Hello.js OAuth](http://adodson.com/hello.js/)


## Similar Projects

* https://github.com/gorillamania/repo-health
* https://github.com/cfjedimaster/githubhealth
* https://github.com/github/pages-health-check
* https://github.com/hstove/issue_stats
