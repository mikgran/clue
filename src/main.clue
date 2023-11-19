
local imports = {
    "consts",
    "objectdescriptor",
    "util",
    "envsetup",
    "assert",
    "testresult",
    "testutil",
    "opt",
    "opttest",
    "testrunner"
}

for _, name in imports {
    import(name)
}

local util = Util::new()
local envsetup = EnvSetup::run()
util::setOptions()



