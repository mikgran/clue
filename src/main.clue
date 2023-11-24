
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


}

for _, name in imports {
    import(name)
}

EnvSetup::run()
Util::new()::setOptions()



