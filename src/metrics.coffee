class App.Metrics

  @repoEffectivenessIcon = (repo) ->
    rating = @repoEffectiveness(repo)
    return "fa-frown-o"  if rating >= 0 and rating < 3
    return "fa-meh-o"  if rating >= 3 and rating < 4.5
    return "fa-smile-o"  if rating >= 4.5 and rating < 7
    return "fa-smile-o green-glow"  if rating >= 7 and rating <= 10
    throw new RangeError "Rating was #{rating}, but must be between 0 and 10"


  @repoEffectivenessDesc = (repo) ->
    @effectivenessDesc @repoEffectiveness(repo)


  @repoEffectiveness = (repo) ->
    @effectiveness(
      repo.closedPullRequestCount(),
      repo.openPullRequestCount(),
      repo.closedIssueCount(),
      repo.openIssueCount())


  @effectivenessForIssues = (weekOfIssues) ->
    repo = new App.Repo 'none/none', null, null, null, false
    repo.rawdata.issues = weekOfIssues
    @repoEffectiveness repo


  @effectiveness = (merged_prs, proposed_prs, closed_issues, new_issues) ->
    inputs = [ merged_prs, proposed_prs, closed_issues, new_issues ].join ", "
    prs = @pr_effectiveness merged_prs, proposed_prs
    issues = @issue_effectiveness closed_issues, new_issues
    (0.66 * prs) + (0.34 * issues)


  @prEffectiveness = (repo) ->
    @pr_effectiveness repo.closedPullRequestCount(), repo.openPullRequestCount()


  @issueEffectiveness = (repo) ->
    @issue_effectiveness repo.closedIssueCount(), repo.openIssueCount()


  @pr_effectiveness = (merged_prs, proposed_prs) ->
    @scaled @ratio merged_prs, proposed_prs


  @issue_effectiveness = (closed_issues, new_issues) ->
    @scaled @ratio closed_issues, new_issues


  @effectivenessDesc = (rating) ->
    return "In the weeds"  if rating >= 0 and rating < 4
    return "Doing fine"  if rating >= 4 and rating < 7
    return "Super effective!"  if rating >= 7 and rating <= 10
    throw new RangeError "Rating was #{rating}, but must be between 0 and 10"


  # Convert a ratio of two Reals into a floating point.
  @ratio = (x, y) ->
    if x is 0 and y is 0
      1
    else
      x / y


  # Scale a ratio (a real number between 0 and infinity) to the range 0–10.
  # This will be used heavily by the algorithms for normalizing data such as "a
  # ratio of 6 merged PR's in the past month to 4 new ones" to a scale of 0–10.
  # This is a component of the app's first metric: Effectiveness.
  #
  # The function below is a curve which pretty much passes through these
  # points:
  #
  # f(0)   ->  0
  # f(0.1) ->  1.0  # a 1:10 ratio
  # f(1)   ->  5.0  # a 1:1  ratio
  # f(10)  ->  9.0  # a 10:1 ratio
  # f(inf) -> 10.0
  #
  # So in the example above, the 6:4 ratio would become 6 on the scale of 1-10.
  # And then this 6 would be translated to a textual description like, "doing
  # fine".
  #
  # See http://math.stackexchange.com/questions/...
  #            1582722/how-to-scale-a-ratio-to-a-limited-range
  @scaled = (ratio) ->
    return 10  if ratio is Infinity
    10 * (ratio / (1 + ratio))


  @groupByWeek = (anArray, attribute) ->
    if not attribute?
      throw new RangeError "required param \"attribute\" not supplied"
    return [] if _.isEmpty anArray

    items = _.sortBy(anArray, attribute)
    weekEndingDate = _.last(items)[attribute]
    weekStartingDate = sixDaysBefore(weekEndingDate)
    [thisWeek, previousDays] = _.partition(items, (i) -> i[attribute] >= weekStartingDate)
    @groupByWeek(previousDays, attribute).concat [ thisWeek ]

  @randomIntFromInterval = (min, max) ->
    Math.floor Math.random() * (max - min + 1 ) + min


sixDaysBefore = (aDate) ->
  new Date aDate.getFullYear(), aDate.getMonth(), aDate.getDate() - 6
