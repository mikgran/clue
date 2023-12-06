
local imports = {
    "consts",
    "objectdescriptor",
    "util",
    "envsetup",
    "assert",
    "asserttest"
    "testresult",
    "testutil",
    "testrunner",
    "opt",
    "opttest",
    "utiltest",
    "objectdescriptortest",
    "exp",
    "exptest",
    "characterdefaults",
    "iter",
    "itertest",
}

for _, name in imports {
    import(name)
}

EnvSetup::run()
Util::new()::setOptions()

method runAllAddonTestSuites() {

    local tests =
    {
        OptTest::new(),
        AssertTest::new(),
        UtilTest::new(),
        ObjectDescriptorTest::new(),
        ExpTest::new(),
        IterTest::new(),
    }

    local testFilter = nil
    // testFilter = "testIter"
    // testFilter = "testCalc"
    TestRunner::run(tests, testFilter)
}
runAllAddonTestSuites()

local charDef = CharacterDefaults::new()
global saveCharDefaults = charDef.saveCharDefaults
global loadCharDefaults = charDef.loadCharDefaults
charDef::setDefaults()






