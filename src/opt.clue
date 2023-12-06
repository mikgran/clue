global Opt = {}

method Opt::of(val) {

    local obj = ObjectDescriptor::new()
    local util = Util::new()

    method obj::init(o) {
        obj.name = "Opt"
    }
    obj::init(val)

    method obj::use(objectOrTable) {

        if !util::isNumber(objectOrTable) && objectOrTable?.get && objectOrTable?.name == "Opt" {
            obj::use(objectOrTable::get())
        }
        elseif util::isTable(objectOrTable) {
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
        if table && util::isTable(table) {
            local size = obj::size()
            for _, v of table {
                size += 1
                obj.tbl[size] = v
            }
        }
        return self
    }

    method obj::put(table) {
        if table && util::isTable(table) {
            for k, v of table {
                obj.tbl[k] = v
            }
        }
        return self
    }

    method obj::map(mapFn) {
        local allResults = {}
        local isResults = false
        if util::isFunction(mapFn) {
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
        if util::isFunction(forEachFn) {
            for key, value of obj.tbl {
                forEachFn(key, value)
            }
        }
        return self
    }

    method obj::filter(predicate) {
        local results = {}

        if predicate == nil || !util::isFunction(predicate) { // no op in malformed call
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

        if ( !util::isEmptyStr(code)) {
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

    method obj::apply(applyFn) {
        if util::isFunction(applyFn) {
            applyFn(obj.tbl)
        }
        return self
    }

    method obj::some(someFn) {
        if obj::size() > 0 && util::isFunction(someFn) {
            someFn(obj.tbl)
        }
        return self
    }

    method obj::none(noneFn) {
        if obj::size() == 0 && util::isFunction(noneFn) {
            noneFn(obj.tbl)
        }
        return self
    }

    method obj::take(numberOfElements) {

        if util::isNumber(numberOfElements) {

            local i = 0
            local newList = Opt::of()
            for k, v of obj.tbl {

                newList::set(k, v)
                i += 1
                if i >= numberOfElements {
                    break
                }
            }
            obj::use(newList)
        }
        return self
    }

    method obj::flatMap(flatMapFn) {
        local results = {}
        local isResults = false
        if util::isFunction(flatMapFn) {
            for k, v of obj.tbl {
                local mapped = flatMapFn(k, v)
                if util::isTable(mapped) {
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
            return self
        }
    }

    method obj::dump() {
        mpr(dump(obj.tbl))
        return self
    }

    // keeps existing keys
    method obj::addAll(table) {
        if util::isTable(table) {
            for key, value of table {
                obj.tbl[#obj.tbl + 1] = value
            }
        }
        return self
    }

    method obj::reduce(reduceFn, acc) {
        local a = acc
        if util::isFunction(reduceFn) && acc {
            for k, v of obj.tbl {
                a = reduceFn(k, v, a)
            }
        } else {
            return self
        }
        return Opt::of(a)
    }

    method obj::slice(fromIndex, toIndex) {

        if util::isNumber(fromIndex) && util::isNumber(toIndex) && obj::size() > 0 {

            local upperBoundary = obj::size()
            if fromIndex > toIndex { fromIndex = toIndex }
            if fromIndex > upperBoundary { fromIndex = upperBoundary }
            if fromIndex < 1 { fromIndex = 1 }

            if toIndex < fromIndex { toIndex = fromIndex }
            if toIndex > upperBoundary { toIndex = upperBoundary }
            if toIndex < 1 { toIndex = 1 }

            local newList = Opt::of()
            local i = fromIndex
            loop {
                newList::add(obj.tbl[i])
                i += 1
            } until i > toIndex
            obj::use(newList)
        }
        return self
    }

    method obj::iter() {
        return Iter::new(obj.tbl)
    }

    method obj::forIter(iteratorConsumerFn) {
        if util::isFunction(iteratorConsumerFn) {

            iteratorConsumerFn(Iter::new(obj.tbl))
        }
        return self
    }

    method obj::keysOrdered(orderedKeysConsumerFn) {
        local byKeys = {}
        for k, _ of obj.tbl { table.insert(byKeys, k) }
        table.sort(byKeys)
        for _, v of byKeys {
            orderedKeysConsumerFn(v, obj.tbl[v])
        }
        return self
    }

    return obj
}

return Opt
