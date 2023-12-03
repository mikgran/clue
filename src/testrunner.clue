global TestRunner = {}

method TestRunner::run(table, filter) {

    local obj = ObjectDescriptor::new()

    method obj::init(tbl, ftr) {
        obj.name = "TestRunner"
        match type(tbl) {
            "table" => { obj.tests = tbl }
            default => { obj.tests = { tbl } }
        }
        obj.filter = ftr
    }
    obj::init(table, filter)

    method obj::runSuite() {
        local results = Opt::of()
        local resultMessages = Opt::of()
        local successes = 0

        resultMessages::add("\nTest suites: " .. #obj.tests)
        if obj.filter {
            resultMessages::add("\nFilter: " .. obj.filter)
        }

        Opt::
            of(obj.tests)::
            forEach(fn (_, test) {
                resultMessages::add("\n\nSuite: " .. test::getName() .. "\n")

                Opt::
                    of(test)::
                    filter(fn (key, value) {
                        local keyFound = string.find(key, "test")
                        if obj.filter {
                            keyFound = keyFound && string.find(key, obj.filter)
                        }
                        return keyFound
                    })::
                    forEach(fn (fnName, testFn) {
                        local tr = testFn()
                        if !tr {
                            tr = TestResult::new("", "", "testFunction did not return: TestResult.", "n/a", false)
                        }
                        tr::setTestName(fnName || "")
                        results::add(tr)
                        resultMessages::add("\n" .. tr::tostring())
                        if tr.state { successes += 1 }
                    })
            })

        local message = ""
        resultMessages::forEach(fn (k, v) { message = message .. v })
        mpr(message)
        mpr(string.format("\n\nTotal tests run: %s, ok: %s, failed: %s",
            results::size(),
            successes,
            results::size() - successes))
    }

    obj::runSuite()

    return obj
}

return TestRunner
