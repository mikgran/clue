global Opt = {}

method Opt::of(val) {

    local obj = ObjectDescriptor::new()

    method obj::init(o) {
        obj.name = "Opt"
        local util = Util::new()
        obj.isEmptyStr = util.isEmptyStr
        obj.isFunction = util.isFunction
        obj.isDef = util.isDef
        obj.isTable = util.isTable
    }
    obj::init(val)

    method obj::use(o) {
        local s = obj
        if s::isTable(o) && s::isDef(o.name) && o.name == "Opt" {
            s::use(o::get())
        }
        elseif s::isTable(o) { 
            s.tbl = o 
        }   
        elseif s::isDef(o) {
            s.tbl = { o }
        }
        else {
            s.tbl = {}  
        }
        return self
    }



    // method obj::use(o) {}
    // method obj::use(o) {}
    // method obj::use(o) {}
    // method obj::use(o) {}
    // method obj::use(o) {}
    // method obj::use(o) {}
    // method obj::use(o) {}
    // method obj::use(o) {}
    // method obj::use(o) {}
    
    
    

    return obj
}

return Opt

/*

    function obj:use(o)
        local s = obj
        if s:isTable(o) and s:isDef(o.name) and o.name == "Opt" then
            s:use(o:get())
        elseif s:isTable(o) then
            s.tbl = o
        elseif s:isDef(o) then
            s.tbl = { o }
        else
            s.tbl = {}
        end

        return self
    end

    obj:use(val)

    function obj:size()
        return #obj.tbl
    end

    function obj:set(k, v)
        if k ~= nil and v ~= nil then
            obj.tbl[k] = v
        end
        return self
    end

    function obj:add(o)
        if o ~= nil then
            obj.tbl[#obj.tbl + 1] = o
        end
        return self
    end

    function obj:map(fn)
        local allResults = {}
        local isResults = false
        if fn ~= nil and obj:isFunction(fn) then
            for k, v in pairs(obj.tbl) do
                local result = fn(k, v)
                if result then
                    allResults[#allResults + 1] = result
                    isResults = true
                end
            end
        end
        if isResults then
            return Opt:of(allResults)
        else
            return Opt:of(obj:get())
        end
    end

    function obj:forEach(fn)
        if obj:isFunction(fn) then
            for key, value in pairs(obj.tbl) do
                fn(key, value)
            end
        end
        return self
    end

    function obj:filter(pr)
        local results = {}
        if pr == nil or type(pr) ~= "function" then -- no op in malformed call
            results = obj:get()
        else
            for k, v in pairs(obj.tbl) do
                if pr(k, v) then
                    results[k] = v
                end
            end
        end
        return Opt:of(results)
    end

    -- cost of malformed "code" is an unintelligent error message
    function obj:mapc(code)
        local returnValue = {}
        local isResults = false
        if (not obj:isEmptyStr(code)) then
            local codeString = string.format("return function(k, v) %s end", code) -- two return calls
            local function1 = loadstring(codeString)()                             -- function() return function() return %s end end
            setfenv(function1, getfenv())
            returnValue = obj:map(function1)
            isResults = true
        end
        if isResults then
            return Opt:of(returnValue)
        else
            return Opt:of(obj:get())
        end
    end

    function obj:get()
        local size = 0
        local firstKey = nil
        for key, value in pairs(obj.tbl) do
            size = size + 1
            if size == 1 then
                firstKey = key
            end
            if size >= 2 then
                break
            end
        end
        if size >= 2 then
            return obj.tbl
        else
            return obj.tbl[firstKey]
        end
    end

    function obj:with(fn)
        local results = nil
        if fn ~= nil and type(fn) == "function" then
            results = fn(obj.tbl)
        end
        return Opt:of(results)
    end

    function obj:flatMap(fn)
        local results = {}
        local isResults = false
        if fn ~= nil and type(fn) == "function" then
            for k, v in pairs(obj.tbl) do
                local c = fn(k, v)
                if c ~= nil and type(c) == "table" then
                    for _, v2 in pairs(c) do
                        results[#results + 1] = v2
                        isResults = true
                    end
                else
                    results[#results + 1] = v
                    isResults = true
                end
            end
        end
        if isResults then
            return Opt:of(results)
        else
            return Opt:of(obj:get())
        end
    end

    function obj:dump()
        mpr(dump(obj.tbl))
        return self
    end

    -- keeps existing keys
    function obj:addAll(t)
        if t ~= nil and type(t) then
            for key, value in pairs(t) do
                obj.tbl[#obj.tbl + 1] = value
            end
        end
        return self
    end

    return obj
end
*/