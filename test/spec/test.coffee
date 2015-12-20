describe "Metrics", ->
    describe ".ratio()", ->
        it "handles a 1:1 ratio", ->
            expect(Metrics.ratio(5, 5)).toBe 1

        it "handles a 1:2 ratio", ->
            expect(Metrics.ratio(3, 6)).toBe 0.5

        it "handles a 3:2 ratio", ->
            expect(Metrics.ratio(9, 6)).toBe 1.5


    describe ".effectiveness_desc()", ->
        it "handles a range from 0 to 10", ->
            expect(Metrics.effectiveness_desc(0)).toBe "in the weeds"
            expect(Metrics.effectiveness_desc(5)).toBe "treading water"
            expect(Metrics.effectiveness_desc(10)).toBe "on top of it"

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
