
local imports = {
    "consts", 
    "objectdescriptor",
    "util",
    "envsetup",
    "testrunner"
}

for _, name in imports { 
    import(name)
}

local util = Util::new()
local envsetup = EnvSetup::run()

mpr(envsetup::tostring())

mpr("HW!")
