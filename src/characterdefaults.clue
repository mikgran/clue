global CharacterDefaults = {}

method CharacterDefaults::new() {


    local obj = {}

    method obj::init() {
        obj.weaponSkills = Consts.weaponSkills
        obj.rangedSkills = Consts.rangedSkills
        obj.otherSkills = Consts.otherSkills
        obj.skillGlyphs = { [1] = "+", [2] = "*" }
        obj.chdat = nil
        obj.loadAttempted = false
    }
    obj::init()


    method obj::skillMessage(prefix, skill, skillType, value) {
        local msg = ""

        if prefix {
            msg = prefix .. ";"
        }

        if skillType {
            msg = msg .. skillType .. "(" .. skill .. ")::" .. value
        }
        else {
            msg = msg .. skill .. "::" .. value
        }

        return msg
    }

    
    method obj::saveSkills(skills) {

        for _, sk in skills {

            if you.train_skill(sk) > 0 {
                obj.chdat["" .. sk] = you.train_skill(sk)
                obj.chdat["" .. sk .. "target"] = you.get_training_target("" .. sk)
            }
        }
    }

    method obj::loadSkills(weapons) {

        for _, sk in weapons {

            if obj.chdat[sk] {
                you.train_skill(sk, obj.chdat["" .. sk])
                you.set_training_target(sk, obj.chdat["" .. sk .. "target"])
            }
            else {
                you.train_skill(sk, 0)
            }
        }
    }

    method obj::saveCharDefaults(quiet) {

        obj::updateCharCombo()
        if you.class() == "Wanderer" {
            return
        }

        if !c_persist.charDefaults {
            c_persist.charDefaults = {}
        }
        c_persist.charDefaults[obj.charCombo] = {}
        obj.chdat = c_persist.charDefaults[obj.charCombo]

        obj::saveSkills(obj.weaponSkills)
        obj::saveSkills(obj.rangedSkills)
        obj::saveSkills(obj.otherSkills)

        tprint(obj.chdat)

        if !quiet {
            mpr("Saved default for " .. obj.charCombo)
        }
    }

    method obj::hasDefaults() {

        return you.class() != "Wanderer"
            && c_persist.charDefaults != nil
            && c_persist.charDefaults[obj.charCombo] != nil
    }

    method obj::updateCharCombo() {
        obj.charCombo = you.race() .. you.class()
    }

    method obj::loadCharDefaults(quiet) {

        obj::updateCharCombo()
        if !obj::hasDefaults() {
            return
        }

        obj.chdat = c_persist.charDefaults[obj.charCombo]

        obj::loadSkills(obj.weaponSkills)
        obj::loadSkills(obj.rangedSkills)
        obj::loadSkills(obj.otherSkills)

        if !quiet {
            mpr("Loaded defaults for " .. obj.charCombo)
        }
    }

    method obj::setDefaults(quiet) {

        obj::updateCharCombo()
        if you.turns() != 0 {
            return
        }

        if !obj.loadAttempted {
            obj::loadCharDefaults(quiet)
            obj.loadAttempted = true
        }
    }

    method obj::mydofile() {
        dofile("CharacterDefaults.lua")
    }

    return obj
}

return CharacterDefaults
