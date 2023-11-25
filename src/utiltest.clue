global UtilTest = {}

method UtilTest::new() {

    local obj = ObjectDescriptor::new()

    method obj::init() {
        obj.name = "UtilTest"
        local u = Util::new()
        obj.isFunction = u.isFunction
        obj.table1ContainsTable2 = u.table1ContainsTable2
    }
    obj::init()

    method obj::testisFunction() {

        local assert = Assert::new()
        local fn1 = fn() { return "abc" }
        local expected = true
        local candidate = obj::isFunction(fn1)

        return assert::equals(expected, candidate)
    }

    method obj::testisFunctionWithNoFn() {
        local assert = Assert::new()

        local expected = false
        local candidate = obj::isFunction(nil)

        return assert::equals(expected, candidate)
    }

    method obj::testTableContainsTable() {
        
        local assert = Assert::new()
        local t1 = { "ab", "cd", "ef" }
        local t2 = { "ab", "cd" }
        local expected = true

        local candidate = obj::table1ContainsTable2(t1, t2)

        return assert::equals(expected, candidate)
    }

    method obj::testTableContainsTableNot() {
        local assert = Assert::new()

        local t1 = { "ab", "cd", "ef" }
        local t2 = { "ab", "cd", "ef", "gh" }
        local expected = false

        local candidate = obj::table1ContainsTable2(t1, t2)

        return assert::equals(expected, candidate)
    }


    return obj
}

return UtilTest

    /*

 

    method obj::testTableContainsTableNot2()
        local assert = Assert::new()

        local t1 = { "abc", "cde", "efg" }
        local t2 = { "abc", "cde", "efg", "hij" }
        local expected = false

        local candidate = obj::table1ContainsTable2(t1, t2)

        return assert::equals(expected, candidate)
    }

    method obj::testTableKeys1ContainsTableKeys2()
        local assert = Assert::new()

        local t1 = { toString = "abc", getName = "def", setName = "gij" }
        local t2 = { toString = "abc", getName = "def", setName = "gij" }
        local expected = true
        local candidate = obj::tableKeys1ContainsTableKeys2(t1, t2)

        return assert::equals(expected, candidate)
    }

    method obj::testTableKeys1ContainsTableKeys2Not()
        local assert = Assert::new()

        local t1 = { toString = "abc", getName = "def", setName = "gij" }
        local t2 = { toString = "abc", getName = "def", setGame = "gij" }
        local expected = false
        local candidate = obj::tableKeys1ContainsTableKeys2(t1, t2)

        return assert::equals(expected, candidate)
    }

    method obj::testTableKeys1ContainsTableKeys2WithLessKeys()
        local assert = Assert::new()

        local t1 = { toString = "abc", getName = "def", setName = "gij" }
        local t2 = { toString = "abc", getName = "def" }
        local expected = true
        local candidate = obj::tableKeys1ContainsTableKeys2(t1, t2)

        return assert::equals(expected, candidate)
    }

    method obj::testTableKeys1ContainsTableKeys2NotWithMoreKeys()
        local assert = Assert::new()

        local t1 = { toString = "abc", getName = "def" }
        local t2 = { toString = "abc", getName = "def", setName = "gij" }
        local expected = false
        local candidate = obj::tableKeys1ContainsTableKeys2(t1, t2)

        return assert::equals(expected, candidate)
    }

    method obj::testIsAllDef()
        local assert = Assert::new()

        local expected = true
        local candidate = obj::isAllDef("", 1, method() return true })

        return assert::equals(expected, candidate)
    }

    method obj::testIsAllDefNot()
        local assert = Assert::new()

        local fn1 = nil
        local expected = false
        local candidate = obj::isAllDef("", fn1, method() return true })

        return assert::equals(expected, candidate)
    }

    method obj::testTablesEqual()
        local assert = Assert::new()

        local t1 = {}
        t1.a = "1"
        t1.b = "2"
        t1.c = "3"
        local t2 = {}
        t2.a = "1"
        t2.b = "2"
        t2.c = "3"
        local expected = true
        local candidate = obj::tablesEqual(t1, t2)

        return assert::equals(expected, candidate)
    }

    method obj::testTablesEqualNotWithDifferentKeys()
        local assert = Assert::new()

        local t1 = {}
        t1.a = "1"
        t1.b = "2"
        t1.c = "3"
        local t2 = {}
        t2.a = "1"
        t2.b = "2"
        t2.d = "3"
        local expected = false
        local candidate = obj::tablesEqual(t1, t2)

        return assert::equals(expected, candidate)
    }

    method obj::testTablesEqualNotWithDifferentValues()
        local assert = Assert::new()

        local t1 = {}
        t1.a = "1"
        t1.b = "2"
        t1.c = "3"
        local t2 = {}
        t2.a = "1"
        t2.b = "2"
        t2.c = "10"
        local expected = false
        local candidate = obj::tablesEqual(t1, t2)

        return assert::equals(expected, candidate)
    }

    return obj
}
*/

