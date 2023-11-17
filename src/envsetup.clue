global EnvSetup = {}

method EnvSetup::run() {

    local obj = ObjectDescriptor::new()
    obj.name = "EnvSetup"
    method obj::setDev() {
        if !crawl {
            obj.DCSS = false
        } else {
            obj.DCSS = true
        }
    }
    obj::setDev()

    method obj::isDev() { return !obj.DCSS }

    method obj::setGlobals() {

        if obj::isDev() {

            global crawl = {}
            method crawl::mpr(s) { print(s) }
            method crawl::setopt(s) {}

            global you = {}
            method you::turns() { return 0 }
            method you::race() { return "human" }
            method you::classa() { return "fighter" }

            global fn mpr(str) { print(str) }
            global c_persist = {}

            mpr("Using DEV env.")
        }    
    }
    obj::setGlobals()

    // TODO move this to the TestRunner
    method obj::runTests() {

        local tests =
        {
            // OptTest:new(),
            // AssertTest:new(),
            // UtilTest:new(),
            // ObjectDescriptorTest:new(),
            // ExpTest:new()
        }

        // local testFilter = nil
        // testFilter = "testMMM"
        // TestRunner:run(tests, testFilter)

        Util::new()::setOptions()

        // local charDef = CharacterDefaults:new()
        // global saveCharDefaults = charDef.saveCharDefaults
        // globall loadCharDefaults = charDef.loadCharDefaults
        // charDef:setDefaults()
    }
    obj::runTests()

    return obj
}

return EnvSetup

