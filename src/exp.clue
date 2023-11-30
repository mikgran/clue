global Exp = {}

method Exp::of(expChart) {
    local obj = ObjectDescriptor::new()

    method obj::init() {
        local util = Util::new()
        obj.expChart = nil
        obj.isEmptyStr = util.isEmptyStr
        obj.name = "Exp"
        obj.skills = Opt::of()
        obj.weaponSkills = Consts.weaponSkills
        obj.rangedSkills = Consts.rangedSkills
        obj.otherSkills = Consts.otherSkills
    }

    method obj::dump() {
        obj.skills::dump()
    }

    method obj::parseSkill(line, name) {
        Opt
            ::of(line)
            ::flatMap(fn(k, v) { return splitByChunk(split(v, "|")[2], 3) })
            ::map(fn(k, v) { return trim(v) })
            ::with(fn(table) { obj.skills::set(name, table) })
    }

    method obj::parseSkills(chart) {

        obj.expChart = chart

        local lines = Opt
            ::of(chart)
            ::flatMap(fn(_, all) {
                local withoutLine1 = string.sub(all, 98)
                local withoutLines1and2 = string.sub(withoutLine1, 101)
                return splitByChunk(withoutLines1and2, 101)
            })

        Opt
            ::of(obj.otherSkills)
            ::addAll(obj.rangedSkills)
            ::addAll(obj.weaponSkills)
            ::forEach(fn(k, skillName) {
                lines::
                    filter(fn(_, line) { return string.find(line, skillName) })::
                    forEach(fn(_, line) { obj::parseSkill(line, skillName) })
            })
    }

    obj::init()
    obj::parseSkills(expChart)

    method obj::get(skillName) {
        return obj.skills::get()[skillName]
    }

    method obj::getExpChart() {
        return obj.expChart
    }

    return obj
}

return Exp