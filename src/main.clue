
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

EnvSetup::run()
Util::new()::setOptions()



