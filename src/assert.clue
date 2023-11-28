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
        local equals = false
        if obj::isAllTables(expected, candidate) && obj::tablesEqual(expected, candidate) { 
            equals = true
        } elseif expected == candidate {
            equals = true
        }
        return obj::newResult("", (equals ? obj.equalMsg : obj.notEqualMsg), expected, candidate, equals)
    }

    method obj::notEquals(expected, candidate) {
        local notEquals = false
        if obj::isAllTables(expected, candidate) && !obj::tablesEqual(expected, candidate) {
            notEquals = true
        } elseif expected != candidate {
            notEquals = true
        }
        return obj::newResult("", (notEquals ? obj.notEqualMsg : obj.equalMsg), expected, candidate, notEquals)
    }

    return obj
}

return Assert
