global Util = {}
method Util::new() {

    local obj = {}
    method obj::setOptions() {

        crawl.setopt("pickup_mode = multi")
        crawl.setopt("message_colour += mute:Okay")
        crawl.setopt("message_colour += mute:Read which item")
        crawl.setopt("message_colour += mute:Search for what")
        crawl.setopt("message_colour += mute:Can't find anything")
        crawl.setopt("message_colour += mute:Drop what")
        crawl.setopt("message_colour += mute:Use which ability")
        crawl.setopt("message_colour += mute:Read which item")
        crawl.setopt("message_colour += mute:Drink which item")
        crawl.setopt("message_colour += mute:not good enough")
        crawl.setopt("message_colour += mute:Attack whom")
        crawl.setopt("message_colour += mute:move target cursor")
        crawl.setopt("message_colour += mute:Aim:")
        crawl.setopt("message_colour += mute:You reach to attack")
        crawl.setopt("message_colour += mute:No target in view!")
    }

    method obj::unsetOptions() {
        crawl.setopt("pickup_mode = auto")
        crawl.setopt("message_colour -= mute:Okay")
        crawl.setopt("message_colour -= mute:Search for what")
        crawl.setopt("message_colour -= mute:Can't find anything")
        crawl.setopt("message_colour -= mute:Drop what")
        crawl.setopt("message_colour -= mute:Use which ability")
        crawl.setopt("message_colour -= mute:Read which item")
        crawl.setopt("message_colour -= mute:Drink which item")
        crawl.setopt("message_colour -= mute:not good enough")
        crawl.setopt("message_colour -= mute:Attack whom")
        crawl.setopt("message_colour -= mute:move target cursor")
        crawl.setopt("message_colour -= mute:Aim:")
        crawl.setopt("message_colour -= mute:You reach to attack")
        crawl.setopt("message_colour -= mute:No target in view!")
    }

    method obj::isAll(fn1, ...) {

        local allDef = true
        for i = 1, select('#', ...) {

            if !fn1(select(i, ...)) {
                allDef = false
                break
            }
        }
        return allDef
    }

    method obj::isAllDef(...) {
        return obj::isAll(fn(o) { return o != nil }, ...)
    }

    method obj::isAllTables(...) {
        return obj::isAll(fn(o) { return obj::isTable(o) }, ...)
    }

    method obj::isUnDef(o) { return (o == nil) }
    method obj::isDef(o) { return (o != nil) }
    method obj::isEmptyStr(o) { return (o == nil || o == "") }


    method obj::eq(a, b) {
        local isEqual = false
        if obj::isDef(a) && obj::isDef(b) && a == b {
            isEqual = true
        }
    }

    method obj::eq(a, b) {
        local isEqual = false
        if obj::isDef(a) && obj::isDef(b) && a == b {
            isEqual = true
        }
        return isEqual
    }

    method obj::isFunction(o) { return (o != nil && type(o) == "function") }
    method obj::isTable(o) { return (o != nil && type(o) == "table") }
    method obj::isString(o) { return (o != nil && type(o) == "string") }
    method obj::isNumber(o) { return (o != nil && type(o) == "number") }

    // unrecursive shallow testing: no table compares
    // every key in t1 must be found in t2 and they must return same the value
    method obj::tablesEqual(t1, t2) {
        local isTablesEqual = false
        if obj::isAllTables(t1, t2) && #t1 == #t2 {
            isTablesEqual = true
            for k, v of t1 {
                if t1[i] != t2[i] {             // every key found in both tables and they return same values
                    isTablesEqual = false
                    break
                }
            }
        }
        return isTablesEqual
    }

    method obj::identV(v) { return v }

    method obj::table1ContainsTable2(t1, t2) {
        local foundAll = false
        if obj::isAllTables(t1, t2) && #t2 <= #t1 {
            foundAll = true
            for i2, v2 of t2 {
                if t1[i2] != t2[i2] { // found all keys in table2 pointing to same values in both tables
                    foundAll = false
                    break
                }
            }
        }
        return foundAll
    }

    // unrecursive shallow testing: no table compares
    // t2 keys must be a subset of t1 keys, both unordered
    // no value comparison
    method obj::tableKeys1ContainsTableKeys2(t1, t2) {
        local foundAll = false
        if obj::isAllTables(t1, t2) && #t2 <= #t1 {
            foundAll = true
            for i2, _ of t2 {
                local found = false
                for i1, _ of t1 {
                    if i2 == i1 {
                        found = true
                        break
                    }
                }
                foundAll = foundAll && found
                if !foundAll {
                    break
                }
            }
        }
        return foundAll
    }

    return obj
}

if !dump {
    global dump = fn (o) {
        if type(o) == 'table' {
            local s = '{ '
            for k, v of o {
                if type(k) != 'number' { k = '"' .. k .. '"' }
                s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
            }
            return s .. '} '
        }
        else {
            return tostring(o)
        }
    }
}

if !mpr {
    mpr = fn (msg, color) {
        if !color {
            color = "white"
        }
        crawl.mpr("<" .. color .. ">" .. msg .. "</" .. color .. ">")
    }
}

if !split {
    global split = fn (str, sep) {
        local r = {}
        if str != nil && type(str) == "string" && sep != nil && type(sep) == "string" {
            local regex = ("([^%s]+)")::format(sep)
            for o with str::gmatch(regex) {
                r[#r + 1] = o
            }
        }
        return r
    }
}

return Util
