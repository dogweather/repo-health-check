// Generated by CoffeeScript 1.10.0
(function() {
  describe("Metrics", function() {
    var M;
    M = App.Metrics;
    describe(".ratio()", function() {
      it("handles a 1:1 ratio", function() {
        return expect(M.ratio(5, 5)).toBe(1);
      });
      it("treats 0/0 as 1:1", function() {
        return expect(M.ratio(0, 0)).toBe(1);
      });
      it("handles a 1:2 ratio", function() {
        return expect(M.ratio(3, 6)).toBe(0.5);
      });
      return it("handles a 3:2 ratio", function() {
        return expect(M.ratio(9, 6)).toBe(1.5);
      });
    });
    describe(".effectivenessDesc()", function() {
      it("handles a range from 0 to 10", function() {
        expect(M.effectivenessDesc(0)).toBe("In the weeds");
        expect(M.effectivenessDesc(3)).toBe("In the weeds");
        expect(M.effectivenessDesc(5)).toBe("Doing fine");
        return expect(M.effectivenessDesc(10)).toBe("Super effective!");
      });
      return it("throws an error when outside 0 to 10", function() {
        expect(function() {
          return M.effectivenessDesc(15);
        }).toThrowError(RangeError);
        return expect(function() {
          return M.effectivenessDesc(-1);
        }).toThrowError(RangeError);
      });
    });
    describe(".effectiveness()", function() {
      it("accepts four parameters & returns a number", function() {
        return expect(M.effectiveness(1, 2, 3, 4)).toEqual(jasmine.any(Number));
      });
      return it("gives travel-project a 10", function() {
        return expect(M.effectiveness(49, 0, 32, 0)).toBe(10);
      });
    });
    describe(".scaled()", function() {
      it("converts 0 to 0", function() {
        return expect(M.scaled(0)).toBe(0);
      });
      it("converts 0.1 to ~1", function() {
        return expect(M.scaled(0.1)).toBeCloseTo(0.9, 1);
      });
      it("converts 1 to 5", function() {
        return expect(M.scaled(1)).toBe(5);
      });
      it("converts 10 to 9", function() {
        return expect(M.scaled(10)).toBeCloseTo(9, 0);
      });
      return it("converts inf. to 10", function() {
        return expect(M.scaled(Infinity)).toBe(10);
      });
    });
    return describe(".groupByWeek()", function() {
      it('handles []', function() {
        return expect(M.groupByWeek([], 'updatedAt')).toEqual([]);
      });
      it('handles one item', function() {
        var oneItem;
        oneItem = {
          updatedAt: new Date
        };
        return expect(M.groupByWeek([oneItem], 'updatedAt')).toEqual([[oneItem]]);
      });
      it('handles two items in one week', function() {
        var item1, item2, today, yesterday;
        today = new Date;
        yesterday = new Date(today.getFullYear(), today.getMonth(), today.getDate() - 1);
        item1 = {
          updatedAt: yesterday
        };
        item2 = {
          updatedAt: today
        };
        return expect(M.groupByWeek([item1, item2], 'updatedAt')).toEqual([[item1, item2]]);
      });
      return it('handles two items in one week and one from the previous week', function() {
        var item1, item2, item3, lastWeek, today, yesterday;
        today = new Date;
        yesterday = new Date(today.getFullYear(), today.getMonth(), today.getDate() - 1);
        lastWeek = new Date(today.getFullYear(), today.getMonth(), today.getDate() - 10);
        item1 = {
          updatedAt: yesterday
        };
        item2 = {
          updatedAt: today
        };
        item3 = {
          updatedAt: lastWeek
        };
        return expect(M.groupByWeek([item1, item2, item3], 'updatedAt')).toEqual([[item3], [item1, item2]]);
      });
    });
  });

  describe("App.Repo", function() {
    beforeAll((function(_this) {
      return function() {
        var nop;
        nop = function() {};
        return _this.naturally = new App.Repo('dogweather/naturally', nop, nop, false);
      };
    })(this));
    describe("constructor", (function(_this) {
      return function() {
        return it("parses a repo spec in acct/name form", function() {
          expect(_this.naturally.name).toBe('naturally');
          return expect(_this.naturally.acct).toBe('dogweather');
        });
      };
    })(this));
    return describe('.url()', (function(_this) {
      return function() {
        return it("forms a standard https url", function() {
          return expect(_this.naturally.url()).toBe('https://github.com/dogweather/naturally');
        });
      };
    })(this));
  });

  describe("App.Github", function() {
    var G;
    G = App.Github;
    describe(".dateFormat()", function() {
      return it("returns a date in GitHub's prefered format", function() {
        var longAgo;
        longAgo = new Date(90000000000);
        return expect(G.dateFormat(longAgo)).toBe('1972-11-07');
      });
    });
    describe(".padWithZeroes()", function() {
      it("prepends 0 to a single digit number", function() {
        return expect(G.padWithZeroes(5, 2)).toBe('05');
      });
      return it("leaves a double-digit number unchanged", function() {
        return expect(G.padWithZeroes(12, 2)).toBe('12');
      });
    });
    describe(".pageCount(apiResult)", function() {
      it("works on the first page", function() {
        var result;
        result = {
          lastPageUrl: 'https://api.github.com/repositories/771016/' + 'issues?per_page=100&state=all&since=2015-11-24&page=3'
        };
        return expect(G.pageCount(result)).toBe(3);
      });
      it("works on the last page", function() {
        var result;
        result = {
          prevPageUrl: 'https://api.github.com/repositories/771016/' + 'issues?per_page=100&state=all&since=2015-11-24&page=2'
        };
        return expect(G.pageCount(result)).toBe(3);
      });
      return it("works on the only page", function() {
        var result;
        result = {};
        return expect(G.pageCount(result)).toBe(1);
      });
    });
    describe(".currentPage(apiResult)", function() {
      it("works on the first page", function() {
        var result;
        result = {
          nextPageUrl: 'https://api.github.com/repositories/771016/' + 'issues?per_page=100&state=all&since=2015-11-24&page=2'
        };
        return expect(G.currentPage(result)).toBe(1);
      });
      it('works on the last page', function() {
        var result;
        result = {
          prevPageUrl: 'https://api.github.com/repositories/771016/' + 'issues?per_page=100&state=all&since=2015-11-24&page=2'
        };
        return expect(G.currentPage(result)).toBe(3);
      });
      return it("works on the only page", function() {
        var result;
        result = {};
        return expect(G.currentPage(result)).toBe(1);
      });
    });
    describe(".isUrl()", function() {
      it("recognizes a GitHub project url", function() {
        var validUrl;
        validUrl = 'https://github.com/dogweather/repo-health-check';
        return expect(G.isUrl(validUrl)).toBe(true);
      });
      it("recognizes a GitHub project sub-page", function() {
        var prUrl;
        prUrl = 'https://github.com/dogweather/repo-health-check/pulls';
        return expect(G.isUrl(prUrl)).toBe(true);
      });
      return it("rejects a non-project url", function() {
        var statusUrl;
        statusUrl = 'https://status.github.com/';
        return expect(G.isUrl(statusUrl)).toBe(false);
      });
    });
    describe(".isRepoSpec()", function() {
      it("recognizes a valid spec", function() {
        var validSpec;
        validSpec = 'dogweather/repo-health-check';
        return expect(G.isRepoSpec(validSpec)).toBe(true);
      });
      return it("rejects a string with two /'s", function() {
        var inValidSpec;
        inValidSpec = '/dogweather/repo-health-check';
        return expect(G.isRepoSpec(inValidSpec)).toBe(false);
      });
    });
    return describe(".parseRepoInput()", function() {
      it("parses a project URL", function() {
        var acct, name, ref, validUrl;
        validUrl = 'https://github.com/dogweather/repo-health-check';
        ref = G.parseRepoInput(validUrl), acct = ref[0], name = ref[1];
        expect(acct).toEqual('dogweather');
        return expect(name).toEqual('repo-health-check');
      });
      it("parses a repo spec", function() {
        var acct, name, ref, validSpec;
        validSpec = 'dogweather/repo-health-check';
        ref = G.parseRepoInput(validSpec), acct = ref[0], name = ref[1];
        expect(acct).toEqual('dogweather');
        return expect(name).toEqual('repo-health-check');
      });
      return it("returns null if input is neither a URL or repo spec", function() {
        var inValidSpec;
        inValidSpec = '/dogweather/repo-health-check';
        return expect(G.parseRepoInput(inValidSpec)).toBeNull();
      });
    });
  });

}).call(this);
