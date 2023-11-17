global TestResult = {}

method TestResult::new(tstName, message, expected, candidate, state) {

    local obj = ObjectDescriptor::new()

    method obj::init(tn, m, e, c, s) {
        obj.name = "TestResult"
        obj.testName = tn || ""
        obj.message = m
        obj.expected = e
        obj.candidate = c
        obj.state = s || false
    }
    obj::init(tstName, message, expected, candidate, state)

    method obj::setTestName(newTestName) {
        obj.testName = newTestName || ""
    }

    method obj::toStr(o) {
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

    method obj::tostring() {
        local toString = string.format("%5s: %s", (obj.state ? "OK" : "Fail"), obj.testName)
        if obj.state {
            return toString
        }
        else {
            return toString ..
                string.format("\n       expected:\n       %s\n       got:\n       %s",
                    obj::toStr(obj.expected),
                    obj::toStr(obj.candidate))
        }
    }

    return obj
}

return TestResult
