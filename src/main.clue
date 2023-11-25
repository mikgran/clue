
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
    "characterdefaults"
}

for _, name in imports {
    import(name)
}

EnvSetup::run()
Util::new()::setOptions()

local charDef = CharacterDefaults::new()
global saveCharDefaults = charDef.saveCharDefaults
global loadCharDefaults = charDef.loadCharDefaults
charDef::setDefaults()



