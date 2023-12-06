global IterTest = {}

method IterTest::new() {
    local obj = ObjectDescriptor::new()
    local assert = Assert::new()

    method obj::init() {
        obj.name = "IterTest"
    }
    obj::init()

    method obj::testIter() {

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

    method obj::testIter2() {

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


    return obj
}

return OptTest
