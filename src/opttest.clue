global OptTest = {}

method OptTest::new() {
    local obj = ObjectDescriptor::new()
    local assert = Assert::new()

    method obj::init() {
        obj.name = "OptTest"
    }
    obj::init()


    method obj::testMap() {
        local str = "111222"
        local expected = str .. str
        local candidate = nil
        Opt::
            of(str)::
            map(fn (k, v) { return v .. v })::
            apply(fn (v) { candidate = v[1] })

        return assert::equals(expected, candidate)
    }

    method obj::testMapValueapplyNilfn() {
        local str = "111222"
        local expected = str
        local candidate = nil

        Opt::
            of(str)::
            map()::
            apply(fn (tbl) {
                candidate = tbl[1]
            })

        return assert::equals(expected, candidate)
    }

    method obj::testMapValueapplyNotAfn() {
        local str = "111222"
        local expected = str
        local candidate = nil

        Opt::
            of(str)::
            map("ssss")::
            apply(fn (v) { candidate = v[1] })

        return assert::equals(expected, candidate)
    }

    method obj::testMapNilValue() {
        local str = nil
        local expected = nil
        local candidate = nil

        Opt::
            of(str)::
            map(fn (k, v) { return v .. v })::
            apply(fn (v) { candidate = v[1] })

        return assert::equals(tostring(expected), tostring(candidate))
    }


    method obj::testMapc() {
        local str = "abc"
        local expected = str .. str
        local candidate = nil

        Opt::
            of(str)::
            mapc("return v..v")::
            apply(fn (v) { candidate = v[1] })

        return assert::equals(expected, candidate)
    }


    method obj::testMapcapplyNilfn() {
        local str = "abc"
        local expected = str
        local candidate = nil

        Opt::
            of(str)::
            mapc()::
            apply(fn (v) { candidate = v[1] })

        return assert::equals(expected, candidate)
    }

    method obj::testMapcapplyNilValue() {
        local str = nil
        local expected = nil
        local candidate = nil

        Opt::
            of(str)::
            mapc("return it")::
            apply(fn (v) { candidate = v[1] })

        return assert::equals(expected, candidate)
    }

    method obj::testUse() {
        local str = "abc"
        local expected = "cde"
        local candidate = nil

        Opt::
            of(str)::
            use("cde")::
            apply(fn (v) {candidate = v[1]})

        return assert::equals(expected, candidate)
    }

    method obj::testUseapplyNil() {
        local str = "abc"
        local expected = nil
        local candidate = nil

        Opt::
            of(str)::
            use(nil)::
            apply(fn (v) {candidate = v[1]})

        return assert::equals(expected, candidate)
    }


    method obj::testUse2() {
        local expected = "abc"
        local candidate = nil

        Opt::
            of(nil)::
            use("abc")::
            apply(fn (v) {candidate = v[1] })

        return assert::equals(expected, candidate)
    }


    method obj::testFilter() {
        local str = "abc"
        local expected = str
        local candidate = nil

        Opt::
            of(str)::
            filter(fn (k, v) {return type(v) == "string"})::
            apply(fn (v) {candidate = v[1]})

        return assert::equals(expected, candidate)
    }

    method obj::testFilter2() {
        local str = "abc"
        local expected = nil
        local candidate = nil

        Opt::
            of(str)::
            filter(fn (k, v) {return (type(v) == "fn")})::
            apply(fn (v) {candidate = v[1]})

        return assert::equals(expected, candidate)
    }

    method obj::testFilter3() {
        local str = nil
        local expected = nil
        local candidate = nil

        Opt::
            of(str)::
            filter(fn(k, v) { return type(v) == "fn" })::
            apply(fn(v) { candidate = v[1] })

        return assert::equals(expected, candidate)
    }

    method obj::testFilterapplyNilPredicate() {
        local str = "abc"
        local expected = "abc"
        local candidate = nil

        Opt::
            of(str)::
            filter()::
            apply(fn(v) { candidate = v[1] })

        return assert::equals(expected, candidate)
    }

    method obj::testForEachapplySimpleValue() {
        local str = "abc"
        local expected = "abc"
        local candidate = ""

        Opt::
            of(str)::
            forEach(fn(k, v) { candidate = candidate .. v })

        return assert::equals(expected, candidate)
    }


    method obj::testForEachapplyTable() {
        local strs = { "1", "2", "3" }
        local expected = { "1", "2", "3" }
        local candidate = Opt::of()

        Opt::
            of(strs)::
            forEach(fn(k, v) { candidate::add(v) })

        return assert::equals(expected, candidate::get())
    }

    method obj::testCat() {

        local strs = { "1" }
        local expected = { "1", "2", "a" }
        local catTable = { "2", "a" }
        local candidate = {}

        Opt
            ::of(strs)
            ::cat(catTable)
            ::apply(fn(table) {
                candidate = table
            })

        return assert::equals(expected, candidate)
    }

    method obj::testPut() {

        local strs = {}
        strs.a = "1"
        strs.b = "b"

        local catTable = {}
        catTable.a = "c"
        catTable.c = "d"

        local expected = {}
        expected.a = catTable.a
        expected.b = "b"
        expected.c = "d"

        local candidate = {}

        Opt
            ::of(strs)
            ::put(catTable)
            ::apply(fn (table) {
                candidate = table
            })

        return assert::equals(expected, candidate)
    }

    method obj::testapply() {
        local strs = { "1", "2", "3" }
        local expected = { "1", "2", "3" }
        local candidate = {}

        Opt::
            of(strs)::
            apply(fn(table) { candidate = table })

        return assert::equals(expected, candidate)
    }

    method obj::testFlatMap() {
        local strs = { "1,2,3" }
        local expected = { "1", "2", "3" }
        local candidate = {}

        Opt::
            of(strs)::
            flatMap(fn(k, v) { return split(v, ",") })::
            forEach(fn(k, v) { candidate[#candidate + 1] = v })

        return assert::equals(expected, candidate)
    }

    method obj::testAddAll() {
        local strs = { "1", "2", "3" }
        local expected = { "1", "2", "3", "1", "2", "3" }
        local candidate = nil

        Opt::
            of(strs)::
            addAll({ "1", "2", "3" })::
            apply(fn (table) {
                candidate = table
            })

        return assert::equals(expected, candidate)
    }

    method obj::testFlatMapapplyIdent() {
        local str1 = { "a,b,c" }
        local str2 = { "t,u,v" }
        local strs = { str1, str2 };
        local expected = { "a", "b", "c", "t", "u", "v" };
        local candidate = {}

        Opt::
            of(strs)::
            flatMap(fn(_, v) { return v })::
            flatMap(fn(_, v) { return split(v, ",") })::
            forEach(fn(_, v) { candidate[#candidate + 1] = v })

        return assert::equals(expected, candidate)
    }

    method obj::testReduce() {

        local strs = { 5, 5, 10, 20, 20 }
        local candidate = nil
        local expected = 60

        Opt::
            of(strs)::
            reduce(fn (k, v, a) { return a + v  }, 0)::
            apply(fn (t) { candidate = t[1] })

        return assert::equals(expected, candidate)
    }

    method obj::testSlice1() {

        local candidate
        local expected = { 5, 10, 15 }
        Opt
            ::of({ 5, 10, 15, 20, 25 })
            ::slice(1, 3)
            ::apply(fn (table) {
                candidate = table
            })

        return assert::equals(expected, candidate)
    }

    method obj::testSlice2() {

        local candidate
        local expected = { 5, 10, 15, 20, 25 }
        Opt
            ::of({ 5, 10, 15, 20, 25 })
            ::slice(1, 5)
            ::apply(fn (table) {
                candidate = table
            })

        return assert::equals(expected, candidate)
    }

    method obj::testSliceLowerBoundary1() {

        local candidate
        local expected = { 5 }
        Opt
            ::of({ 5, 10, 15, 20, 25 })
            ::slice(0, 0)
            ::apply(fn (table) {
                candidate = table
            })

        return assert::equals(expected, candidate)
    }

    method obj::testSliceLowerBoundary2() {

        local candidate
        local expected = { 5 }
        Opt
            ::of({ 5, 10, 15, 20, 25 })
            ::slice(4, 0)
            ::apply(fn (table) {
                candidate = table
            })

        return assert::equals(expected, candidate)
    }

    method obj::testSliceUpperBoundary3() {

        local candidate
        local expected = { 25 }
        Opt
            ::of({ 5, 10, 15, 20, 25 })
            ::slice(6, 6)
            ::apply(fn (table) {
                candidate = table
            })

        return assert::equals(expected, candidate)
    }

    method obj::testSliceUpperBoundary4() {

        local candidate
        local expected = { 5, 10, 15, 20 }
        Opt
            ::of({ 5, 10, 15, 20, 25 })
            ::slice(0, 4)
            ::apply(fn (table) {
                candidate = table
            })

        return assert::equals(expected, candidate)
    }

    method obj::testSlice3() {

        local candidate
        local expected = { 10, 15, 20 }
        Opt
            ::of({ 5, 10, 15, 20, 25 })
            ::slice(2, 4)
            ::apply(fn (table) {
                candidate = table
            })

        return assert::equals(expected, candidate)
    }

    method obj::testSlice4() {

        local candidate
        local expected = { 20, 25 }
        Opt
            ::of({ 5, 10, 15, 20, 25 })
            ::slice(4, 5)
            ::apply(fn (table) {
                candidate = table
            })

        return assert::equals(expected, candidate)
    }

    method obj::testSliceULInvalidBoundary() {

        local candidate
        local expected = { 5 }
        Opt
            ::of({ 5, 10, 15, 20, 25 })
            ::slice(6, 0)
            ::apply(fn (table) {
                candidate = table
            })

        return assert::equals(expected, candidate)
    }

    method obj::testSliceULInvalidBoundary2() {

        local candidate
        local expected = { 5, 10, 15, 20, 25 }
        Opt
            ::of({ 5, 10, 15, 20, 25 })
            ::slice(0, 6)
            ::apply(fn (table) {
                candidate = table
            })

        return assert::equals(expected, candidate)
    }

    method obj::testSome() {

        local candidate
        local expected = { 5, 10, 15, 20, 25 }
        Opt
            ::of({ 5, 10, 15, 20, 25 })
            ::some(fn (table) {
                candidate = table
            })

        return assert::equals(expected, candidate)
    }

    method obj::testSome2() {

        local candidate = nil
        local expected = nil
        Opt
            ::of()
            ::some(fn (table) {
                candidate = table
            })

        return assert::equals(expected, candidate)
    }

    method obj::testNone() {

        local candidate
        local expected = { 1 }
        Opt
            ::of( { 1 } )
            ::none(fn (table) {
                candidate = { 1, 2, 3 }
            })
            ::apply(fn (table) {
                candidate = table
            })

        return assert::equals(expected, candidate)
    }

    method obj::testNone2() {

        local candidate
        local expected = { 1, 2, 3 }
        Opt
            ::of()
            ::none(fn (table) {
                candidate = { 1, 2, 3 }
            })

        return assert::equals(expected, candidate)
    }

    method obj::testTake() {

        local candidate
        local expected = { 1, 2 }
        Opt
            ::of( { 1, 2, 3, 4, 5, 6, 7, 8 } )
            ::take(2)
            ::apply(fn (table) {
                candidate = table
            })

        return assert::equals(expected, candidate)
    }

    method obj::testTakeWithNil() {

        local candidate
        local expected = { 1, 2, 3, 4, 5, 6, 7, 8 }
        Opt
            ::of( { 1, 2, 3, 4, 5, 6, 7, 8 } )
            ::take()
            ::apply(fn (table) {
                candidate = table
            })

        return assert::equals(expected, candidate)
    }

    method obj::testTakeWithZero() {

        local candidate
        local expected = { 1 }
        Opt
            ::of( { 1, 2, 3, 4, 5, 6, 7, 8 } )
            ::take(0)
            ::apply(fn (table) {
                candidate = table
            })

        return assert::equals(expected, candidate)
    }

    method obj::testTakeWithNumberHigherThanCapacity() {

        local candidate
        local expected = { 1, 2, 3, 4, 5, 6, 7, 8 }
        Opt
            ::of( { 1, 2, 3, 4, 5, 6, 7, 8 } )
            ::take(100)
            ::apply(fn (table) {
                candidate = table
            })

        return assert::equals(expected, candidate)
    }

    method obj::testIter() {

        local candidate
        local expected = 2

        local iter = Opt
            ::of( { 1, 2, 3 } )
            ::iter()

        iter::next()
        local k, v = iter::next()
        candidate = v

        return assert::equals(expected, candidate)
    }

    method obj::testIterWithConsumer() {

        local candidate
        local expected = 2

        Opt
            ::of( { 1, 2, 3 } )
            ::forIter(fn (iter) {
                iter::next()
                local _, v = iter::next()
                candidate = v
            })

        return assert::equals(expected, candidate)
    }

    method obj::testKeysOrdered() {

        local candidate = Opt::of()
        local expected = Opt::of({ "13", "21", "35" })

        Opt
            ::of( { [3] = 5, [1] = 3, [2] = 1 } )
            ::keysOrdered(fn (k, v) {
                candidate::add((tostring(k) .. tostring(v)))
            })

        return assert::equals(expected::get(), candidate::get())
    }

    method obj::testSortByKeys() {

        local candidate = nil
        local expected = Opt::of({ { [1] = 3, [2] = 1, [3] = 5 } })

        candidate = Opt
            ::of( { [3] = 5, [1] = 3, [2] = 1 } )
            ::sortByKeys()

        return assert::equals(expected::get(), candidate::get())
    }

    return obj
}

return OptTest
