global OptTest = {}

method OptTest::new() {
    local obj = ObjectDescriptor::new()

    method obj::init() {
        obj.name = "OptTest"
        obj.assert = Assert::new()
    }
    obj::init()


    method obj::testMap() {
        local str = "111222"
        local expected = str .. str
        Opt::
            of(str)::
            map(fn (k, v) {
                return v .. v
            })::
            with(fn (v) {
                candidate = v[1]
            })

        return obj.assert::equals(expected, candidate)
    }

    method obj::testMapValueWithNilfn() {
        local str = "111222"
        local expected = str
        local candidate = nil

        Opt::
            of(str)::
            map()::
            with(fn (tbl) {
                candidate = tbl[1]
            })

        return obj.assert::equals(expected, candidate)
    }

    method obj::testMapValueWithNotAfn() {
        local str = "111222"
        local expected = str
        local candidate = nil

        Opt::
            of(str)::
            map("ssss")::
            with(fn (v) { candidate = v[1] })

        return obj.assert::equals(expected, candidate)
    }

    method obj::testMapNilValue() {
        local str = nil
        local expected = nil
        local candidate = nil

        Opt::
            of(str)::
            map(fn (k, v) { return v .. v })::
            with(fn (v) { candidate = v[1] })

        return obj.assert::equals(tostring(expected), tostring(candidate))
    }


    method obj::testMapc() {
        local str = "abc"
        local expected = str .. str
        local candidate = nil

        Opt::
            of(str)::
            mapc("return v..v")::
            with(fn (v) { candidate = v[1] })

        return obj.assert::equals(expected, candidate)
    }


    method obj::testMapcWithNilfn() {
        local str = "abc"
        local expected = str
        local candidate = nil

        Opt::
            of(str)::
            mapc()::
            with(fn (v) { candidate = v[1] })

        return obj.assert::equals(expected, candidate)
    }

    method obj::testMapcWithNilValue() {
        local str = nil
        local expected = nil
        local candidate = nil

        Opt::
            of(str)::
            mapc("return it")::
            with(fn (v) { candidate = v[1] })

        return obj.assert::equals(expected, candidate)
    }

    method obj::testUse() {
        local str = "abc"
        local expected = "cde"
        local candidate = nil

        Opt::
            of(str)::
            use("cde")::
            with(fn (v) {candidate = v[1]})

        return obj.assert::equals(expected, candidate)
    }

    method obj::testUseWithNil() {
        local str = "abc"
        local expected = nil
        local candidate = nil

        Opt::
            of(str)::
            use(nil)::
            with(fn (v) {candidate = v[1]})

        return obj.assert::equals(expected, candidate)
    }


    method obj::testUse2() {
        local expected = "abc"
        local candidate = nil

        Opt::
            of(nil)::
            use("abc")::
            with(fn (v) {candidate = v[1] })

        return obj.assert::equals(expected, candidate)
    }


    method obj::testFilter() {
        local str = "abc"
        local expected = str
        local candidate = nil

        Opt::
            of(str)::
            filter(fn (k, v) {return type(v) == "string"})::
            with(fn (v) {candidate = v[1]})

        return obj.assert::equals(expected, candidate)
    }

    method obj::testFilter2() {
        local str = "abc"
        local expected = nil
        local candidate = nil

        Opt::
            of(str)::
            filter(fn (k, v) {return (type(v) == "fn")})::
            with(fn (v) {candidate = v[1]})

        return obj.assert::equals(expected, candidate)
    }

    method obj::testFilter3() {
        local str = nil
        local expected = nil
        local candidate = nil

        Opt::
            of(str)::
            filter(fn(k, v) { return type(v) == "fn" })::
            with(fn(v) { candidate = v[1] })

        return obj.assert::equals(expected, candidate)
    }

    method obj::testFilterWithNilPredicate() {
        local str = "abc"
        local expected = "abc"
        local candidate = nil

        Opt::
            of(str)::
            filter()::
            with(fn(v) { candidate = v[1] })

        return obj.assert::equals(expected, candidate)
    }

    method obj::testForEachWithSimpleValue() {
        local str = "abc"
        local expected = "abc"
        local candidate = ""

        Opt::
            of(str)::
            forEach(fn(k, v) { candidate = candidate .. v })

        return obj.assert::equals(expected, candidate)
    }


    method obj::testForEachWithTable() {
        local strs = { "1", "2", "3" }
        local expected = { "1", "2", "3" }
        local candidate = Opt::of()

        Opt::
            of(strs)::
            forEach(fn(k, v) {
                candidate::add(v)
            })

        return obj.assert::equals(expected, candidate::get())
    }

    method obj::testWith() {
        local strs = { "1", "2", "3" }
        local expected = { "1", "2", "3" }
        local candidate = {}

        Opt::
            of(strs)::
            with(fn(table) {
                candidate = table
            })

        return obj.assert::equals(expected, candidate)
    }

    method obj::testFlatMap() {
        local strs = { "1,2,3" }
        local expected = { "1", "2", "3" }
        local candidate = {}

        Opt::
            of(strs)::
            flatMap(fn(k, v) {
                return split(v, ",")
            })::
            forEach(fn(k, v) {
                candidate[#candidate + 1] = v
            })

        return obj.assert::equals(expected, candidate)
    }

    method obj::testAddAll() {
        local strs = { "1", "2", "3" }
        local expected = { "1", "2", "3", "1", "2", "3" }
        local candidate = nil

        Opt::
            of(strs)::
            addAll({ "1", "2", "3" })::
            with(fn (table) {
                candidate = table
            })

        return obj.assert::equals(expected, candidate)
    }

    method obj::testFlatMapWithIdent() {
        local strs = { { "a,b,c" }, { "t,u,v" } }
        local expected = { "a", "b", "c", "t", "u", "v" }
        local candidate = {}

        Opt::
            of(strs)::
            flatMap(fn(_, v) { return v })::
            flatMap(fn(_, v) { return split(v, ",") })::
            forEach(fn(_, v) { candidate[#candidate + 1] = v })

        return obj.assert::equals(expected, candidate)
    }

    return obj
}

return OptTest
