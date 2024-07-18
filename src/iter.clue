global Iter = {}

method Iter::new(object) {

    local obj = ObjectDescriptor::new()
    local util = Util::new()
    local nextIndex = nil

    method obj::init(o) {

        if util::isTable(o) {
            obj.tbl = o

            local byKeys = {}
            for key, _ of o { table.insert(byKeys, key) }
            table.sort(byKeys)
            obj.sortedKeys = byKeys
        }
    }
    obj::init(object)

    method obj::next() {
        local key, value = next(obj.sortedKeys, obj.nextIndex)
        obj.nextIndex = key
        return value, obj.tbl[value]
    }

    method obj::hasNext() {
        local _, value = next(obj.sortedKeys, obj.nextIndex)
        return (value != nil)
    }

    return obj
}

return Iter
