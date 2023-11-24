global AssertTest = {}

method AssertTest::new() {

    local obj = ObjectDescriptor::new()

    method obj::init() {
        obj.name = "AssertTest"
    }
    obj::init()

    method obj::testEquals() {

        local Assert = Assert::new()
        local expected = "t111"
        local candidate = "t111"

        return Assert::equals(expected, candidate)
    }

    method obj::testEqualsWithNilCandidate() {

        local Assert = Assert::new()
        local expected = "t111"
        local candidate = nil

        return Assert::notEquals(expected, candidate)
    }

    method obj::testNotEquals() {

        local Assert = Assert::new()
        local expected = "t222"
        local candidate = "t111"

        return Assert::notEquals(expected, candidate)
    }

    method obj::testAssertLists() {

        local Assert = Assert::new()
        local expected = { "abc" }
        local candidate = { "abc" }

        return Assert::equals(expected, candidate)
    }

    return obj
}
