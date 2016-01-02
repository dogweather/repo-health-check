describe "Metrics", ->
  M = Metrics

  describe ".ratio()", ->

    it "handles a 1:1 ratio", -> expect( M.ratio 5, 5 ).toBe 1
    it "treats 0/0 as 1:1",   -> expect( M.ratio 0, 0 ).toBe 1
    it "handles a 1:2 ratio", -> expect( M.ratio 3, 6 ).toBe 0.5
    it "handles a 3:2 ratio", -> expect( M.ratio 9, 6 ).toBe 1.5


  describe ".effectivenessDesc()", ->

    it "handles a range from 0 to 10", ->
      expect( M.effectivenessDesc 0 ).toBe "In the weeds"
      expect( M.effectivenessDesc 3 ).toBe "In the weeds"
      expect( M.effectivenessDesc 5 ).toBe "Doing fine"
      expect( M.effectivenessDesc 10 ).toBe "Super effective!"

    it "throws an error when outside 0 to 10", ->
      expect(->
        M.effectivenessDesc 15
      ).toThrowError RangeError
      expect(->
        M.effectivenessDesc -1
      ).toThrowError RangeError


  describe ".effectiveness()", ->

    it "accepts four parameters & returns a number", ->
      expect( M.effectiveness 1, 2, 3, 4 ).toEqual jasmine.any(Number)

    it "gives travel-project a 10", ->
      expect( M.effectiveness 49, 0, 32, 0 ).toBe 10


  describe ".scaled()", ->

    it "converts 0 to 0",     -> expect( M.scaled 0 ).toBe 0
    it "converts 0.1 to ~1",  -> expect( M.scaled 0.1 ).toBeCloseTo 0.9, 1
    it "converts 1 to 5",     -> expect( M.scaled 1 ).toBe 5
    it "converts 10 to 9",    -> expect( M.scaled 10 ).toBeCloseTo 9, 0
    it "converts inf. to 10", -> expect( M.scaled Infinity ).toBe 10


  describe ".groupByWeek()", ->

    it 'handles []', ->
      expect( M.groupByWeek [], 'updatedAt' ).toEqual []

    it 'handles one item', ->
      oneItem = { updatedAt: new Date }
      expect( M.groupByWeek [oneItem], 'updatedAt' ).toEqual [[oneItem]]

    it 'handles two items in one week', ->
      today = new Date
      yesterday = new Date(
        today.getFullYear(),
        today.getMonth(),
        today.getDate() - 1
      )
      item1 = { updatedAt: yesterday}
      item2 = { updatedAt: today }
      expect( M.groupByWeek [item1, item2], 'updatedAt' ).toEqual [[item1, item2]]

    it 'handles two items in one week and one from the previous week', ->
      today = new Date
      yesterday = new Date(
        today.getFullYear(),
        today.getMonth(),
        today.getDate() - 1
      )
      lastWeek = new Date(
        today.getFullYear(),
        today.getMonth(),
        today.getDate() - 10
      )
      item1 = { updatedAt: yesterday}
      item2 = { updatedAt: today }
      item3 = { updatedAt: lastWeek }
      expect( M.groupByWeek [item1, item2, item3], 'updatedAt' ).toEqual [[item3], [item1, item2]]


describe "App.Repo", ->
  beforeAll =>
    nop = ->
    @naturally = new App.Repo('dogweather/naturally', nop, nop, false)

  describe "constructor", =>

    it "parses a repo spec in acct/name form", =>
      expect( @naturally.name ).toBe 'naturally'
      expect( @naturally.acct ).toBe 'dogweather'

  describe '.url()', =>

    it "forms a standard https url", =>
      expect( @naturally.url() ).toBe 'https://github.com/dogweather/naturally'


describe "App.Github", ->
  G = App.Github

  describe ".dateFormat()", ->

    it "returns a date in GitHub's prefered format", ->
      longAgo = new Date(90000000000) # Tue Nov 07 1972 08:00:00 GMT-0800 (PST)
      expect( G.dateFormat longAgo ).toBe '1972-11-07'

  describe ".padWithZeroes()", ->

    it "prepends 0 to a single digit number", ->
      expect( G.padWithZeroes 5, 2 ).toBe '05'

    it "leaves a double-digit number unchanged", ->
      expect( G.padWithZeroes 12, 2 ).toBe '12'

  describe ".pageCount(apiResult)", ->

    it "works on the first page", ->
      result = {
        lastPageUrl: 'https://api.github.com/repositories/771016/' +
                     'issues?per_page=100&state=all&since=2015-11-24&page=3'
      }
      expect( G.pageCount result ).toBe 3

    it "works on the last page", ->
      result = {
        prevPageUrl: 'https://api.github.com/repositories/771016/' +
                     'issues?per_page=100&state=all&since=2015-11-24&page=2'
      }
      expect( G.pageCount result ).toBe 3

    it "works on the only page", ->
      result = {}
      expect( G.pageCount result ).toBe 1

  describe ".currentPage(apiResult)", ->

    it "works on the first page", ->
      result = {
        nextPageUrl: 'https://api.github.com/repositories/771016/' +
                     'issues?per_page=100&state=all&since=2015-11-24&page=2'
      }
      expect( G.currentPage result ).toBe 1

    it 'works on the last page', ->
      result = {
        prevPageUrl: 'https://api.github.com/repositories/771016/' +
                     'issues?per_page=100&state=all&since=2015-11-24&page=2'
      }
      expect( G.currentPage result ).toBe 3

    it "works on the only page", ->
      result = {}
      expect( G.currentPage result ).toBe 1

  describe ".isUrl()", ->

    it "recognizes a GitHub project url", ->
      validUrl = 'https://github.com/dogweather/repo-health-check'
      expect( G.isUrl validUrl  ).toBe true

    it "recognizes a GitHub project sub-page", ->
      prUrl = 'https://github.com/dogweather/repo-health-check/pulls'
      expect( G.isUrl prUrl  ).toBe true

    it "rejects a non-project url", ->
      statusUrl = 'https://status.github.com/'
      expect( G.isUrl statusUrl  ).toBe false

  describe ".isRepoSpec()", ->

    it "recognizes a valid spec", ->
      validSpec = 'dogweather/repo-health-check'
      expect( G.isRepoSpec validSpec ).toBe true

    it "rejects a string with two /'s", ->
      inValidSpec = '/dogweather/repo-health-check'
      expect( G.isRepoSpec inValidSpec ).toBe false

  describe ".parseRepoInput()", ->

    it "parses a project URL", ->
      validUrl = 'https://github.com/dogweather/repo-health-check'
      [acct, name] = G.parseRepoInput validUrl
      expect( acct ).toEqual 'dogweather'
      expect( name ).toEqual 'repo-health-check'

    it "parses a repo spec", ->
      validSpec = 'dogweather/repo-health-check'
      [acct, name] = G.parseRepoInput validSpec
      expect( acct ).toEqual 'dogweather'
      expect( name ).toEqual 'repo-health-check'

    it "returns null if input is neither a URL or repo spec", ->
      inValidSpec = '/dogweather/repo-health-check'
      expect( G.parseRepoInput inValidSpec ).toBeNull()
