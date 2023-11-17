global Assert = {}

method Assert::new() {

    local obj = TestUtil::new() // tostring, newResult

    method obj::init(ctx) {
        obj.name = "Assert"
        obj.equalMsg = "were equal"
        obj.notEqualMsg = "not equal"
        local util = Util::new()
        obj.isAllTables = util.isAllTables
        obj.tablesEqual = util.tablesEqual
    }
    obj::init(context)

    method obj::equals(expected, candidate) {
        if obj::isAllTables(expected, candidate) {
            return obj::assertTablesEqual(expected, candidate)
        }
        local state = false
        if expected == candidate {
            state = true
        }
        return obj::newResult("", (state ? obj.equalMsg : obj.notEqualMsg), expected, candidate, state)
    }

    // CONSIDER: removal
    method obj::assertTablesEqual(expected, candidate) {
        local state = true
        if #expected != #candidate || !obj::tablesEqual(expected, candidate) {
            state = false
        }
        return obj::newResult("", (state ? obj.equalMsg : obj.notEqualMsg), expected, candidate, state)
    }

    method obj::notEquals(expected, candidate) {
        if obj::isAllTables(expected, candidate) {
            return !obj::tablesEqual(expected, candidate)
        }
        local state = false
        if expected != candidate {
            state = true
        }
        return obj::newResult("", (state ? obj.notEqualMsg : obj.equalMsg), expected, candidate, state)
    }

    return obj
}

return Assert
