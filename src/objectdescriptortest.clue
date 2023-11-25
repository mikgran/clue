global ObjectDescriptorTest = {}

method ObjectDescriptorTest::new() {
    local obj = {}

    method obj::init() {
        obj.name = "ObjectDescriptorTest"
    }

    obj::init()

    method obj::getName() { // not provided since obj = {}, thus copy of it here
        return obj.name
    }

    method obj::testGetName() {
        local Assert = Assert::new()
        local sn = "str"
        local newoo = fn() {
            local oo = ObjectDescriptor::new()
            oo.name = sn
            return oo
        }
        local expected = sn
        local candidate = newoo()::getName()

        return Assert::equals(expected, candidate)
    }

    return obj
}
