global Iter = {}

method Iter::new(object) {

    local obj = ObjectDescriptor::new()
    local util = Util::new()
    local nextIndex = nil

    method obj::init(o) {

        if util::isTable(o) {
            obj.tbl = o

            local byKeys = {}
            for k, _ of o { table.insert(byKeys, k) }
            table.sort(byKeys)
            obj.sortedKeys = byKeys
        }
    }
    obj::init(object)

    method obj::next() {
        local k, v = next(obj.sortedKeys, obj.nextIndex)
        obj.nextIndex = k
        return v, obj.tbl[v]
    }

    method obj::hasNext() {
        local k, v = next(obj.sortedKeys, obj.nextIndex)
        return (v != nil)
    }

    return obj
}

return Iter
