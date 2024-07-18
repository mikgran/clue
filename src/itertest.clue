global IterTest = {}

method IterTest::new() {
    local obj = ObjectDescriptor::new()
    local assert = Assert::new()

    method obj::init() {
        obj.name = "IterTest"
    }
    obj::init()

    method obj::testIterateFour() {

        local candidate = Opt::of()
        local expected = Opt::of({ 1, 2, 3, 4 })

        local iter = Opt
            ::of( { 1, 2, 3, 4, 5, 6, 7, 8 } )
            ::iter()

            for i=1, 4 {
                local k, v = iter::next()
                candidate::add(v)
            }

        return assert::equals(expected::get(), candidate::get())
    }

    method obj::testIterateAll() {

        local candidate = Opt::of()
        local expected = Opt::of({ 1, 2, 3 })

        local iter =
        Opt
            ::of( { 1, 2, 3 } )
            ::iter()

        for i = 1, 4 {
            local k, v = iter::next()
            candidate::add(v)
        }

        return assert::equals(expected::get(), candidate::get())
    }

    method obj::testIterHasNextSome() {

        local candidate = Opt::of()
        local expected = Opt::of({ })

        local iter =
        Opt
            ::of( { 1, 2, 3 } )
            ::iter()

        local candidate = iter::hasNext()

        return assert::equals(true, candidate)
    }

   method obj::testIterHasNextNone() {

        local candidate = Opt::of()
        local expected = Opt::of({ })

        local iter =
        Opt
            ::of( { 1, 2 } )
            ::iter()

        local one = iter::next()
        local two = iter::next()
        local candidate = iter::hasNext()

        return assert::equals(false, candidate)
    }

    return obj
}

return OptTest
