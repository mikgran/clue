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
        Opt::
            of(line)::
            flatMap(fn(k, v) { return splitByChunk(split(v, "|")[2], 3) })::
            map(fn(k, v) { return trim(v) })::
            with(fn(v) { obj.skills::set(name, v) })
    }

    method obj::parseSkills(chart) {
        local lines = Opt::of()
        obj.expChart = chart

        Opt::
            of(chart)::
            flatMap(fn(_, all) { return split(all, "\n") })::
            with(fn(table) { lines::use(table) })

        Opt::
            of(obj.otherSkills)::
            forEach(fn(k, skillName) {
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