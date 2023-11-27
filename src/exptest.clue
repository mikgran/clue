global ExpTest = {}

method ExpTest::new() {
    local obj = ObjectDescriptor::new()

    method obj::init() {
        obj.assert = Assert::new()
        obj.name = "ExpTest"
        obj.expChart = "
Skill      XL: |  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 |
---------------+-------------------------------------------------------------------------------+-----
Earth Magic    |  3     4  5     7  8     9 12    13 15 17 19 20 22 24 25       26 27          | 27.0
Spellcasting   |                    4  6             10 12          14 15    19 20             | 20.0
Conjurations   |                       5  6                                                    |  6.0
Fighting       |                          6    10                                     18 20    | 20.0
Invocations    |                             5  6                                              |  6.0
Shields        |                                6 10                      15                   | 15.0
Ice Magic      |                                              10                               | 10.0
Armour         |                                                        6          11 12    14 | 14.4
Necromancy     |                                                              5           9    |  9.1
Ranged Weapons |                                                                          7  8 |  8.0
Dodging        |                                                                               |  1.7
Stealth        |                                                                               |  1.4
Transmutations |                                                                               |  0.8
"
    }
    obj::init()

    method obj::testCreating() {
        mpr("HW")
        local exp = Exp::of(obj.expChart)
        local expected = { "3", "", "4", "5", "", "7", "8", "", "9", "12", "", "13", "15", "17", "19", "20", "22", "24",
            "25", "", "", "26", "27", "", "", "", "" }

        local candidate = exp::get("Earth Magic")

        return obj.assert::equals(expected, candidate)
    }

    return obj
}

return ExpTest
