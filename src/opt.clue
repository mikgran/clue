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

    method obj::use(objectOrTable) {

        if !obj::isNumber(objectOrTable) && objectOrTable?.get && objectOrTable?.name == "Opt" {
            obj::use(objectOrTable::get())
        }
        elseif obj::isTable(objectOrTable) {
            obj.tbl = objectOrTable
        }
        elseif objectOrTable {
            obj.tbl = { objectOrTable }
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

    method obj::set(key, value) {
        if key && value {
            obj.tbl[key] = value
        }
        return self
    }

    method obj::add(object) {
        if object {
            obj.tbl[#obj.tbl + 1] = object
        }
        return self
    }

    method obj::cat(table) {
        if table && obj::isTable(table) {
            local size = obj::size()
            for _, v of table {
                size += 1
                obj.tbl[size] = v
            }
        }
        return self
    }

    method obj::put(table) {
        if table && obj::isTable(table) {
            for k, v of table {
                obj.tbl[k] = v
            }
        }
        return self
    }

    method obj::map(mapFn) {
        local allResults = {}
        local isResults = false
        if obj::isFunction(mapFn) {
            for k, v of obj.tbl {
                local result = mapFn(k, v)
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

    method obj::forEach(forEachFn) {
        if obj::isFunction(forEachFn) {
            for key, value of obj.tbl {
                forEachFn(key, value)
            }
        }
        return self
    }

    method obj::filter(predicate) {
        local results = {}

        if predicate == nil || !obj::isFunction(predicate) { // no op in malformed call
            results = obj::get()
        }
        else {
            for k, v of obj.tbl {
                if predicate(k, v) {
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

    method obj::with(withFn) {
        if obj::isFunction(withFn) {
            withFn(obj.tbl)
        }
        return self
    }

    method obj::flatMap(flatMapFn) {
        local results = {}
        local isResults = false
        if obj::isFunction(flatMapFn) {
            for k, v of obj.tbl {
                local mapped = flatMapFn(k, v)
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

    method obj::reduce(reduceFn, acc) {
        local a = acc
        if obj::isFunction(reduceFn) && acc {
            for k, v of obj.tbl {
                a = reduceFn(k, v, a)
            }
        } else {
            return self
        }
        return Opt::of(a)
    }


    return obj
}

return Opt
