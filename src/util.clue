global Util = {}

method Util::new() {

    local obj = {}
    method obj::setOptions() {

        crawl.setopt("pickup_mode = multi")
        crawl.setopt("message_colour += mute::Okay")
        crawl.setopt("message_colour += mute::Read which item")
        crawl.setopt("message_colour += mute::Search for what")
        crawl.setopt("message_colour += mute::Can't find anything")
        crawl.setopt("message_colour += mute::Drop what")
        crawl.setopt("message_colour += mute::Use which ability")
        crawl.setopt("message_colour += mute::Read which item")
        crawl.setopt("message_colour += mute::Drink which item")
        crawl.setopt("message_colour += mute::!good enough")
        crawl.setopt("message_colour += mute::Attack whom")
        crawl.setopt("message_colour += mute::move target cursor")
        crawl.setopt("message_colour += mute::Aim::")
        crawl.setopt("message_colour += mute::You reach to attack")
        crawl.setopt("message_colour += mute::No target in view!")
    }

    method obj::unsetOptions() {
        crawl.setopt("pickup_mode = auto")
        crawl.setopt("message_colour -= mute::Okay")
        crawl.setopt("message_colour -= mute::Search for what")
        crawl.setopt("message_colour -= mute::Can't find anything")
        crawl.setopt("message_colour -= mute::Drop what")
        crawl.setopt("message_colour -= mute::Use which ability")
        crawl.setopt("message_colour -= mute::Read which item")
        crawl.setopt("message_colour -= mute::Drink which item")
        crawl.setopt("message_colour -= mute::!good enough")
        crawl.setopt("message_colour -= mute::Attack whom")
        crawl.setopt("message_colour -= mute::move target cursor")
        crawl.setopt("message_colour -= mute::Aim::")
        crawl.setopt("message_colour -= mute::You reach to attack")
        crawl.setopt("message_colour -= mute::No target in view!")
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

    method obj::isFunction (o) { return (o != nil && type(o) == "function") }
    method obj::isTable(o) { return (o != nil && type(o) == "table") }
    method obj::isString(o) { return (o != nil && type(o) == "string") }
    method obj::isNumber(o) { return (o != nil && type(o) == "number") }
    method obj::tableSize(tbl) {
        local tblSize = 0
        for k, v of tbl { tblSize += 1 }
        return tblSize
    }

    // unrecursive shallow testing:: no sub table compares
    // every key in t1 must be found in t2 && they must return same the value
    method obj::tablesEqual(table1, table2) {
        local isTablesEqual = false
        if obj::isAllTables(table1, table2) {
            isTablesEqual = (obj::tableSize(table1) == obj::tableSize(table2))
            if isTablesEqual {
                for k, v of table1 {
                    local table1value = table1[k]
                    local table2value = table2[k]
                    // every key found in both tables && they return same values
                    if table1value != table2value || nil == table1value || nil == table2value {
                        isTablesEqual = false
                        break
                    }
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

    // unrecursive shallow testing:: no table compares
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

if !mpr {
    mpr = fn (msg, color) {
        if !color {
            color = "white"
        }
        crawl.mpr("<" .. color .. ">" .. msg .. "</" .. color .. ">")
    }
}

// shamelessly borrowed from the net
if !dump {
    dump = fn (o) {
        if type(o) == 'table' {
            local s = '{ '
            for k, v of o {
                if type(k) != 'number' { k = '"' .. k .. '"' }
                s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
            }
            return s .. '} '
        } else {
            return tostring(o)
        }
    }
}

// shamelessly borrowed from the net
if !tprint {
    tprint = fn (t, s) {
        for k, v of t {
            local kfmt = '["' .. tostring(k) .. '"]'
            if type(k) != 'string' {
                kfmt = '[' .. k .. ']'
            }

            local vfmt = '"' .. tostring(v) .. '"'
            if type(v) == 'table' {
                tprint(v, (s || '') .. kfmt)
            } else {
                if type(v) != 'string' {
                    vfmt = tostring(v)
                }
                mpr(type(t) .. (s || '') .. kfmt .. ' = ' .. vfmt)
            }
        }
    }
}

if !tableAdd {
    tableAdd = fn (t, o) {
        if t != nil && type(t) == "table" {
            t[#t + 1] = o
        }
    }
}
if !tableFilter {
    tableFilter = fn (t, p) {
        local results = {}
        if t != nil && type(t) == "table" && p != nil && type(p) == "function" {
            for k, v of t {
                if p(k, v) {
                    results[#results + 1] = v
                }
            }
        }
        return results
    }
}
if !tableForEach {
    tableForEach = fn (t, fn1) {
        if t != nil && type(t) == "table" && fn1 != nil && type(fn1) == "function" {
            for k, v of t {
                fn1(k, v)
            }
        }
    }
}

// shamelessly borrowed from the net
if !stripLetters {
    stripLetters = fn (str) {
        local result = ""
        if str != nil && type(str) == "string" {
            for i = 1, #str {
                local c = str::sub(i, i)
                if c::match("^%-?%d+$") {
                    result = result .. c
                }
            }
        }
        return result
    }
}

if !split {
    split = fn (str, pat) {
        local t = {}  // NOTE: use {n = 0} in Lua-5.0
        local fpat = "(.-)" .. pat
        local last_end = 1
        local s, e, cap = str::find(fpat, 1)
        while s {
            if s != 1 || cap != "" {
                t[#t + 1] = cap
            }
            last_end = e+1
            s, e, cap = str::find(fpat, last_end)
        }
        if last_end <= #str {
            cap = str::sub(last_end)
            t[#t + 1] = cap
        }
        return t
    }
}

if !splitByChunk {
    splitByChunk = fn (text, chunkSize) {
        local s = {}
        if text != nil && type(text) == "string" && chunkSize != nil && type(chunkSize) == "number" {
            for i = 1, #text, chunkSize {
                s[#s + 1] = text::sub(i, i + chunkSize - 1)
            }
        }
        return s
    }
}

if !trim {
    trim = fn (s) {
        if type(s) == "string" {
            return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
        } else {
            return s
        }
    }
}

return Util
