describe "Metrics", ->
  describe ".ratio()", ->

    it "handles a 1:1 ratio", ->
      expect(Metrics.ratio(5, 5)).toBe 1

    it "treats 0/0 as 1:1", ->
      expect(Metrics.ratio(0, 0)).toBe 1

    it "handles a 1:2 ratio", ->
      expect(Metrics.ratio(3, 6)).toBe 0.5

    it "handles a 3:2 ratio", ->
      expect(Metrics.ratio(9, 6)).toBe 1.5


  describe ".effectiveness_desc()", ->

    it "handles a range from 0 to 10", ->
      expect(Metrics.effectiveness_desc(0)).toBe "In the weeds"
      expect(Metrics.effectiveness_desc(5)).toBe "Doing fine"
      expect(Metrics.effectiveness_desc(10)).toBe "Super effective"

    it "throws an error when outside 0 to 10", ->
      expect(->
        Metrics.effectiveness_desc 15
      ).toThrowError RangeError
      expect(->
        Metrics.effectiveness_desc -1
      ).toThrowError RangeError


  describe ".effectiveness()", ->

    it "accepts four parameters & returns a number", ->
      expect(Metrics.effectiveness(1, 2, 3, 4)).toEqual jasmine.any(Number)

    it "gives travel-project a 10", ->
      expect(Metrics.effectiveness(49, 0, 32, 0)).toBe 10


  describe ".scaled()", ->

    it "converts 0 to 0", ->
      expect(Metrics.scaled(0)).toBe 0

    it "converts 0.1 to ~1", ->
      expect(Metrics.scaled(0.1)).toBeCloseTo 0.9, 1

    it "converts 1 to 5", ->
      expect(Metrics.scaled(1)).toBe 5

    it "converts 10 to 9", ->
      expect(Metrics.scaled(10)).toBeCloseTo 9, 0

    it "converts infinity to 10", ->
      expect(Metrics.scaled(Infinity)).toBe 10


describe "App.Repo", ->
  describe "constructor", ->

    it "parses a repo spec in acct/name form", ->
      nop = ->
      repo = new App.Repo('dogweather/naturally', nop, nop, false)
      expect(repo.name).toBe 'naturally'
      expect(repo.acct).toBe 'dogweather'


describe "App.Github", ->
  describe ".dateFormat()", ->

    it "returns a date in GitHub's prefered format", ->
      date = new Date(90000000000) # Tue Nov 07 1972 08:00:00 GMT-0800 (PST)
      expect(App.Github.dateFormat(date)).toBe '1972-11-07'

  describe ".padWithZeroes()", ->

    it "prepends 0 to a single digit number", ->
      expect(App.Github.padWithZeroes(5, 2)).toBe '05'

    it "leaves a double-digit number unchanged", ->
      expect(App.Github.padWithZeroes(12, 2)).toBe '12'

  describe ".pageCount(apiResult)", ->

    it "works on the first page", ->
      result = {lastPageUrl: "https://api.github.com/repositories/771016/issues?per_page=100&state=all&since=2015-11-24&page=3"}
      expect(App.Github.pageCount(result)).toBe 3

    it "works on the last page", ->
      result = {prevPageUrl: "https://api.github.com/repositories/771016/issues?per_page=100&state=all&since=2015-11-24&page=2"}
      expect(App.Github.pageCount(result)).toBe 3

    it "works on the only page", ->
      result = {}
      expect(App.Github.pageCount(result)).toBe 1

  describe ".currentPage(apiResult)", ->

    it "works on the first page", ->
      result = {nextPageUrl: "https://api.github.com/repositories/771016/issues?per_page=100&state=all&since=2015-11-24&page=2"}
      expect(App.Github.currentPage(result)).toBe 1

    it "works on the last page", ->
      result = {prevPageUrl: "https://api.github.com/repositories/771016/issues?per_page=100&state=all&since=2015-11-24&page=2"}
      expect(App.Github.currentPage(result)).toBe 3

    it "works on the only page", ->
      result = {}
      expect(App.Github.currentPage(result)).toBe 1
