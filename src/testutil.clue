global TestUtil = {}

method TestUtil::new() {
    local obj = ObjectDescriptor::new()

    method obj::init() {
        obj.name = "TestUtil"
    }
    obj::init()

    method obj::newResult(tstName, message, candidate, expected, state) {
        return TestResult::new(tstName, message, candidate, expected, state)
    }

    return obj
}

return TestUtil