global ExpTest = {}

method ExpTest::new() {
    local obj = ObjectDescriptor::new()
    local assert = Assert::new()
    local expChart = "
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
  local exp = Exp::of(expChart)

    method obj::init() {
        obj.name = "ExpTest"
    }
    obj::init()

    method obj::testParsingEM() {

        local expected =
        { [1] =  "3",
          [2] =  "",
          [3] =  "4",
          [4] =  "5",
          [5] =  "",
          [6] =  "7",
          [7] =  "8",
          [8] =  "",
          [9] =  "9",
          [10] = "12",
          [11] = "",
          [12] = "13",
          [13] = "15",
          [14] = "17",
          [15] = "19",
          [16] = "20",
          [17] = "22",
          [18] = "24",
          [19] = "25",
          [20] = "",
          [21] = "",
          [22] = "26",
          [23] = "27",
          [24] = "",
          [25] = "",
          [26] = "",
          [27] = ""}

        local candidate = exp::get("Earth Magic")

        return assert::equals(expected, candidate)
    }

    method obj::testParsingSC() {
        local expected =
        { [1] =  "",
          [2] =  "",
          [3] =  "",
          [4] =  "",
          [5] =  "",
          [6] =  "",
          [7] =  "4",
          [8] =  "6",
          [9] =  "",
          [10] = "",
          [11] = "",
          [12] = "",
          [13] = "10",
          [14] = "12",
          [15] = "",
          [16] = "",
          [17] = "",
          [18] = "14",
          [19] = "15",
          [20] = "",
          [21] = "19",
          [22] = "20",
          [23] = "",
          [24] = "",
          [25] = "",
          [26] = "",
          [27] = ""}

        local candidate = exp::get("Spellcasting")

        return assert::equals(expected, candidate)
    }

    method obj::testParsingCJ() {
        local expected =
        { [1] =  "",
          [2] =  "",
          [3] =  "",
          [4] =  "",
          [5] =  "",
          [6] =  "",
          [7] =  "",
          [8] =  "5",
          [9] =  "6",
          [10] = "",
          [11] = "",
          [12] = "",
          [13] = "",
          [14] = "",
          [15] = "",
          [16] = "",
          [17] = "",
          [18] = "",
          [19] = "",
          [20] = "",
          [21] = "",
          [22] = "",
          [23] = "",
          [24] = "",
          [25] = "",
          [26] = "",
          [27] = ""}

        local candidate = exp::get("Conjurations")

        return assert::equals(expected, candidate)
    }

    // method obj::testCalculateSkillAdvancement() {
    //     local expected = 0.5
    //     local candidate = exp::advancementFor("Earth Magic", 1)
    //     return assert::equals(expected, candidate)
    // }

    method obj::testCalculateSkillAdvancement2() {

      local expected = 8 / 13
      local candidate = exp::advancementFor("Fighting", 11)
      return assert::equals(expected, candidate)
  }

    return obj
}

return ExpTest
