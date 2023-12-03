global AssertTest = {}

method AssertTest::new() {

    local obj = ObjectDescriptor::new()
    local assert = Assert::new()

    method obj::init() {
        obj.name = "AssertTest"
    }
    obj::init()

    method obj::testEquals() {

        local expected = "t111"
        local candidate = "t111"

        return assert::equals(expected, candidate)
    }

    method obj::testEqualsWithNilCandidate() {

        local expected = "t111"
        local candidate = nil

        return assert::notEquals(expected, candidate)
    }

    method obj::testNotEquals() {

        local expected = "t222"
        local candidate = "t111"

        return assert::notEquals(expected, candidate)
    }

    method obj::testAssertLists() {

        local expected = { "abc" }
        local candidate = { "abc" }

        return assert::equals(expected, candidate)
    }

    method obj::testAssertListsEqualsNot() {

        local expected = { "abc" }
        local candidate = { "def" }

        return assert::notEquals(expected, candidate)
    }

    method obj::testAssertListsNotEqualsWithNils() {

        local expected = {}
        expected.a = "abc"
        expected.b = nil

        local candidate = {}
        candidate.a = "abc"
        candidate.b = "def"

        return assert::notEquals(expected, candidate)
    }

    return obj
}
