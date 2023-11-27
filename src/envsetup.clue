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
            method crawl::mpr(str) { print(str) }
            method crawl::setopt(s) {}

            global you = {}
            method you::turns() { return 0 }
            method you::race() { return "human" }
            method you::class() { return "fighter" }

            global fn mpr(str) { print(str) }
            global c_persist = {}

            mpr("Using DEV env.")
        }
    }
    obj::setGlobals()

    return obj
}

return EnvSetup

