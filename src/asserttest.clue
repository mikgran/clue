global AssertTest = {}

function AssertTest:new()

    local obj = ObjectDescriptor:new()

    function obj:init()
        obj.name = "AssertTest"
    end
    obj:init()

    function obj:testEquals()

        local Assert = Assert:new()
        local expected = "t111"
        local candidate = "t111"

        return Assert:equals(expected, candidate)
    end

    function obj:testEqualsWithNilCandidate()

        local Assert = Assert:new()
        local expected = "t111"
        local candidate = nil

        return Assert:notEquals(expected, candidate)
    end

    function obj:testNotEquals()

        local Assert = Assert:new()
        local expected = "t222"
        local candidate = "t111"

        return Assert:notEquals(expected, candidate)
    end

    function obj:testAssertLists()

        local Assert = Assert:new()
        local expected = { "abc" }
        local candidate = { "abc" }

        return Assert:equals(expected, candidate)
    end

    return obj
end
