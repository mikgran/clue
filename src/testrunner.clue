TestRunner = {}

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
        /*
    function obj:runSuite()
        local results = Opt:of {}
        local resultMessages = Opt:of {}
        local successes = 0
        resultMessages:add("\nTest suites: " .. #obj.tests)
        if (obj.filter ~= nil) then
            resultMessages:add("\nFilter: " .. obj.filter)
        end

        Opt:of(obj.tests):
            forEach(function(_, testClass)
                resultMessages:add("\n\nSuite: " .. testClass:getName() .. "\n")

                Opt:of(testClass):
                    filter(function(key, value)
                        local keyFound = string.find(key, "test")
                        if (obj.filter) then
                            keyFound = keyFound and string.find(key, obj.filter)
                        end
                        return keyFound
                    end):
                    forEach(function(fnName, fn)
                        local r = fn()
                        r:setTestName(fnName or "")
                        results:add(r)
                        resultMessages:add("\n" .. r.tostring())
                        if r.state then successes = successes + 1 end
                    end)
            end)

        local message = ""
        resultMessages:forEach(function(k, v) message = message .. v end)
        mpr(message)
        mpr(string.format("\n\nTotal tests run: %s, ok: %s, failed: %s", results:size(), successes,
            results:size() - successes))
    end

    obj:runSuite()

    return obj
end

*/
    }


}


