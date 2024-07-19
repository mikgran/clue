global Exp = {}

method Exp::of(expChart) {
    local obj = ObjectDescriptor::new()

    method obj::init(chart) {
        local util = Util::new()
        obj.name = "Exp"
        obj.isEmptyStr = util.isEmptyStr
        obj.skills = Opt::of()
        if !chart { chart = {} }
        obj.expChart = chart
    }

    method obj::dump() {
        obj.skills::dump()
    }

    method obj::parseSkill(line, name) {
        Opt::of(line)
            ::flatMap(fn(k, v) { return splitByChunk(split(v, "|")[2], 3) })
            ::map(fn(k, v) { return trim(v) })
            ::apply(fn(table) { obj.skills::set(name, table) })
    }

    method obj::parseSkillChart(chart) {

        local lines = Opt::of(chart)
            ::flatMap(fn(_, all) {
                // change to split by \n?
                local withoutLine1 = string.sub(all, 98)
                local withoutLines1and2 = string.sub(withoutLine1, 101)
                return splitByChunk(withoutLines1and2, 101)
            })

        Opt::of(Consts.otherSkills)
            ::addAll(Consts.rangedSkills)
            ::addAll(Consts.weaponSkills)
            ::forEach(fn(_, skillName) {
                lines::
                    filter(fn(_, line) { return string.find(line, skillName) })::
                    forEach(fn(_, line) { obj::parseSkill(line, skillName) })
            })
    }

    obj::init(expChart)
    obj::parseSkillChart(expChart)

    method obj::get(skillName) {
        return obj.skills::get()[skillName]
    }

    method obj::getExpChart() {
        return obj.expChart
    }

    method obj::advancementFor(skillName, currentLevel) {
        local skillTable = obj::get(skillName)
        local advancementPerLevel = 0

        Opt::of(skillTable)
            ::sortByKeys()
            ::filter(fn(k, v) { return (v && "" != v) && (k >= currentLevel) })
            ::forIter(fn (iter) {
                local k1, v1 = iter::next()
                local k2, v2 = iter::next()
                local levelDiff = k2 - k1
                local skillDiff = v2 - v1
                print("level diff: " .. levelDiff)
                print("skill diff: " .. skillDiff)
                advancementPerLevel = skillDiff / levelDiff
            })
        return advancementPerLevel
    }

    return obj
}

return Exp