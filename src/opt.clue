global Opt = {}

method Opt::of(val) {

    local obj = ObjectDescriptor::new()

    method obj::init(o) {
        obj.name = "Opt"
        local util = Util::new()
        obj.isEmptyStr = util.isEmptyStr
        obj.isFunction = util.isFunction
        obj.isDef = util.isDef
        obj.isTable = util.isTable
        obj.isAllDef = util.isAllDef
        obj.isNumber = util.isNumber
    }
    obj::init(val)

    method obj::use(o) {

        if !obj::isNumber(o) && o?.get && o?.name == "Opt" {
            obj::use(o::get())
        }
        elseif obj::isTable(o) {
            obj.tbl = o
        }
        elseif o {
            obj.tbl = { o }
        }
        else {
            obj.tbl = {}
        }
        return self
    }
    obj::use(val)

    method obj::size() {
        local size = 0
        for k, v of obj.tbl { size += 1 }
        return size
    }

    method obj::set(k, v) {
        if k && v {
            obj.tbl[k] = v
        }
        return self
    }

    method obj::add(o) {
        if o {
            obj.tbl[#obj.tbl + 1] = o
        }
        return self
    }

    method obj::cat(t) {
        if t && obj::isTable(t) {
            local size = obj::size()
            for _, v of t {
                size += 1
                obj.tbl[size] = v
            }
        }
        return self
    }

    method obj::put(t) {
        if t && obj::isTable(t) {
            for k, v of t {
                obj.tbl[k] = v
            }
        }
        return self
    }

    method obj::map(fn1) {
        local allResults = {}
        local isResults = false
        if obj::isFunction(fn1) {
            for k, v of obj.tbl {
                local result = fn1(k, v)
                if result {
                    allResults[#allResults + 1] = result
                    isResults = true
                }
            }
        }
        if isResults {
            return Opt::of(allResults)
        }
        else {
            return Opt::of(obj::get())
        }
    }

    method obj::forEach(fn1) {
        if obj::isFunction(fn1) {
            for key, value of obj.tbl {
                fn1(key, value)
            }
        }
        return self
    }

    method obj::filter(pr) {
        local results = {}

        if pr == nil || !obj::isFunction(pr) { // no op in malformed call
            results = obj::get()
        }
        else {
            for k, v of obj.tbl {
                if pr(k, v) {
                    results[k] = v
                }
            }
        }
        return Opt::of(results)
    }

    // cost of malformed "code" is an unintelligent error message
    method obj::mapc(code) {
        local mapped = {}
        local isResults = false

        if ( !obj::isEmptyStr(code)) {
            // two return calls
            // function() return function() return %s end end
            local codeString = string.format("return function(k, v) %s end", code)
            local fn1 = loadstring(codeString)()
            setfenv(fn1, getfenv())
            mapped = obj::map(fn1)
            isResults = true
        }
        if isResults {
            return Opt::of(mapped)
        }
        else {
            return Opt::of(obj::get())
        }
    }

    method obj::get() {
        local size = 0
        local firstKey = nil

        for key, val of obj.tbl {
            size = size + 1
            if size == 1 {
                firstKey = key
            }
            if size >= 2 {
                break
            }
        }
        if size >= 2 {
            return obj.tbl
        }
        else {
            return obj.tbl[firstKey]
        }
    }

    method obj::with(fn1) {
        if obj::isFunction(fn1) {
            fn1(obj.tbl)
        }
        return self
    }

    method obj::flatMap(fn1) {
        local results = {}
        local isResults = false
        if obj::isFunction(fn1) {
            for k, v of obj.tbl {
                local mapped = fn1(k, v)
                if obj::isTable(mapped) {
                    for _, v2 of mapped {
                        results[#results + 1] = v2
                        isResults = true
                    }
                }
                else {
                    results[#results + 1] = mapped
                    isResults = true
                }
            }
        }
        if isResults {
            return Opt::of(results)
        }
        else {
            return Opt::of(obj::get())
        }
    }

    method obj::dump() {
        mpr(dump(obj.tbl))
        return self
    }

    // keeps existing keys
    method obj::addAll(table) {
        if obj::isTable(table) {
            for key, value of table {
                obj.tbl[#obj.tbl + 1] = value
            }
        }
        return self
    }

    method obj::reduce(fn1, acc) {
        local a = acc
        if obj::isFunction(fn1) && acc {
            for k, v of obj.tbl {
                a = fn1(k, v, a)
            }
        } else {
            return self
        }
        return Opt::of(a)
    }


    return obj
}

return Opt
