--STATICS
local import, _modules
do
	local cache = {}
	local nils = {}
	function import(modname)
		if nils[modname] then return end
		local cached = cache[modname]
		if cached ~= nil then return cached end
		cached = _modules[modname]
		if cached ~= nil then
			cached = cached(modname);
			if cached == nil then
				nils[modname] = true
			else
				cache[modname] = cached
			end
			return cached
		end
	end
end
_modules = {
	["consts"] = function(...)
		Consts = {		};
		Consts.weaponSkills = {
			"Unarmed Combat", 
			"Short Blades", 
			"Long Blades", 
			"Axes", 
			"Maces & Flails", 
			"Polearms", 
			"Staves"
		};
		Consts.rangedSkills = {
			"Throwing", 
			"Ranged Weapons", 
			"Crossbows", 
			"Slings"
		};
		Consts.otherSkills = {
			"Fighting", 
			"Armour", 
			"Dodging", 
			"Shapeshifting", 
			"Shields", 
			"Spellcasting", 
			"Conjurations", 
			"Hexes", 
			"Charms", 
			"Summonings", 
			"Necromancy", 
			"Translocations", 
			"Transmutations", 
			"Fire Magic", 
			"Ice Magic", 
			"Air Magic", 
			"Earth Magic", 
			"Poison Magic", 
			"Invocations", 
			"Evocations", 
			"Stealth"
		};
		return Consts;
	end,
	["envsetup"] = function(...)
		EnvSetup = {		};
		function EnvSetup:run()
			local obj = ObjectDescriptor:new();
			obj.name = "EnvSetup";
			function obj:setDev()
				if not crawl then
					obj.DCSS = false;
				else
					obj.DCSS = true;
				end
			end
			obj:setDev();
			function obj:isDev()
				return not obj.DCSS;
			end
			function obj:setGlobals()
				if obj:isDev() then
					crawl = {					};
					function crawl:mpr(s)
						print(s);
					end
					function crawl:setopt(s)
						
					end
					you = {					};
					function you:turns()
						return 0;
					end
					function you:race()
						return "human";
					end
					function you:classa()
						return "fighter";
					end
					function mpr(str)
						print(str);
					end
					c_persist = {					};
					mpr("Using DEV env.");
				end
			end
			obj:setGlobals();
			function obj:runTests()
				local tests = {				};
				Util:new():setOptions();
			end
			obj:runTests();
			return obj;
		end
		return EnvSetup;
	end,
	["testrunner"] = function(...)
		TestRunner = {		};
		function TestRunner:run(table, filter)
			local obj = ObjectDescriptor:new();
			function obj:init(tbl, ftr)
				obj.name = "TestRunner";
				local _internal0 = type(tbl);
				if (_internal0 == "table") then
					obj.tests = tbl;
				else
					obj.tests = {
						tbl
					};
				end
				obj.filter = ftr;
			end
			obj:init(table, filter);
			function obj:runSuite()
				
			end
		end
	end,
	["main"] = function(...)
		local imports = {
			"consts", 
			"objectdescriptor", 
			"util", 
			"envsetup", 
			"testrunner"
		};
		for _, name in ipairs(imports) do
			import(name);
		end
		local util = Util:new();
		local envsetup = EnvSetup:run();
		mpr(envsetup:tostring());
		mpr("HW!");
	end,
	["opt"] = function(...)
		Opt = {		};
		function Opt:of(val)
			local obj = ObjectDescriptor:new();
			function obj:init(o)
				obj.name = "Opt";
				local util = Util:new();
				obj.isEmptyStr = util.isEmptyStr;
				obj.isFunction = util.isFunction;
				obj.isDef = util.isDef;
				obj.isTable = util.isTable;
			end
			obj:init(val);
			function obj:use(o)
				local s = obj;
				if s:isTable(o) and s:isDef(o.name) and o.name=="Opt" then
					s:use(o:get());
				elseif s:isTable(o) then
					s.tbl = o;
				elseif s:isDef(o) then
					s.tbl = {
						o
					};
				else
					s.tbl = {					};
				end
				return self;
			end
			return obj;
		end
		return Opt;
	end,
	["objectdescriptor"] = function(...)
		ObjectDescriptor = {		};
		function ObjectDescriptor:new()
			local obj = {			};
			function obj:init()
				obj.name = "ObjectDescriptor";
			end
			obj:init();
			function obj:getName()
				return obj.name;
			end
			function obj:tostring()
				local addToTable = function(tbl, key, val)
					tbl[((#tbl+1))] = string.format("\n  %s: %s", tostring(key), val);
				end;
				local sbcat = function(sb, tbl)
					local s = sb;
					for _, v in ipairs(tbl) do
						s = s..v;
					end
					return s;
				end;
				local name = obj:getName() or "";
				local sb = name.."\n(";
				local kvProperties = {				};
				local kvFunctions = {				};
				local kvTables = {				};
				for key, value in pairs(self) do
					local _internal0 = type(value);
					if (_internal0 == "number") or (_internal0 == "string") then
						addToTable(kvProperties, key, "\""..tostring(value).."\"");
					else
						if (_internal0 == "function") then
							addToTable(kvFunctions, key, "fn");
						else
							if (_internal0 == "table") then
								addToTable(kvTables, key, "{ }");
							end
						end
					end
				end
				table.sort(kvProperties);
				table.sort(kvFunctions);
				table.sort(kvTables);
				sb = sbcat(sb, kvProperties);
				sb = sbcat(sb, kvFunctions);
				sb = sbcat(sb, kvTables);
				return sb.."\n)";
			end
			return obj;
		end
		return ObjectDescriptor;
	end,
	["util"] = function(...)
		Util = {		};
		function Util:new()
			local obj = {			};
			function obj:setOptions()
				crawl.setopt("pickup_mode = multi");
				crawl.setopt("message_colour += mute:Okay");
				crawl.setopt("message_colour += mute:Read which item");
				crawl.setopt("message_colour += mute:Search for what");
				crawl.setopt("message_colour += mute:Can't find anything");
				crawl.setopt("message_colour += mute:Drop what");
				crawl.setopt("message_colour += mute:Use which ability");
				crawl.setopt("message_colour += mute:Read which item");
				crawl.setopt("message_colour += mute:Drink which item");
				crawl.setopt("message_colour += mute:not good enough");
				crawl.setopt("message_colour += mute:Attack whom");
				crawl.setopt("message_colour += mute:move target cursor");
				crawl.setopt("message_colour += mute:Aim:");
				crawl.setopt("message_colour += mute:You reach to attack");
				crawl.setopt("message_colour += mute:No target in view!");
			end
			function obj:unsetOptions()
				crawl.setopt("pickup_mode = auto");
				crawl.setopt("message_colour -= mute:Okay");
				crawl.setopt("message_colour -= mute:Search for what");
				crawl.setopt("message_colour -= mute:Can't find anything");
				crawl.setopt("message_colour -= mute:Drop what");
				crawl.setopt("message_colour -= mute:Use which ability");
				crawl.setopt("message_colour -= mute:Read which item");
				crawl.setopt("message_colour -= mute:Drink which item");
				crawl.setopt("message_colour -= mute:not good enough");
				crawl.setopt("message_colour -= mute:Attack whom");
				crawl.setopt("message_colour -= mute:move target cursor");
				crawl.setopt("message_colour -= mute:Aim:");
				crawl.setopt("message_colour -= mute:You reach to attack");
				crawl.setopt("message_colour -= mute:No target in view!");
			end
			function obj:isAll(fn1, ...)
				local allDef = true;
				for i = 1, select('#', ...), 1 do
					if not fn1(select(i, ...)) then
						allDef = false;
						break;
					end
				end
				return allDef;
			end
			function obj:isAllDef(...)
				local isAll = obj.isAll;
				return isAll(function(o)
					return o~=nil;
				end, ...);
			end
			function obj:isAllTables(...)
				local isAll = obj.isAll;
				local isTable = obj.isTable;
				return isAll(function(o)
					return isTable(o);
				end, ...);
			end
			function obj:isUnDef(o)
				return (o==nil);
			end
			function obj:isDef(o)
				return (o~=nil);
			end
			function obj:isEmptyStr(o)
				return (o==nil or o=="");
			end
			function obj:eq(a, b)
				local isDef = obj.isDef;
				local isEqual = false;
				if isDef(a) and isDef(b) and a==b then
					isEqual = true;
				end
			end
			function obj:eq(a, b)
				local isDef = obj.isDef;
				local isEqual = false;
				if isDef(a) and isDef(b) and a==b then
					isEqual = true;
				end
				return isEqual;
			end
			function obj:isFunction(o)
				return (o~=nil and type(o)=="function");
			end
			function obj:isTable(o)
				return (o~=nil and type(o)=="table");
			end
			function obj:isString(o)
				return (o~=nil and type(o)=="string");
			end
			function obj:isNumber(o)
				return (o~=nil and type(o)=="number");
			end
			function obj:tablesEqual(t1, t2)
				local isAllTables = obj.isAllTables;
				local isTablesEqual = false;
				if isAllTables(t1, t2) and #t1==#t2 then
					isTablesEqual = true;
					for k, v in pairs(t1) do
						if t1[(i)]~=t2[(i)] then
							isTablesEqual = false;
							break;
						end
					end
				end
				return isTablesEqual;
			end
			function obj:identV(v)
				return v;
			end
			function obj:table1ContainsTable2(t1, t2)
				local foundAll = false;
				if obj:isAllTables(t1, t2) and #t2<=#t1 then
					foundAll = true;
					for i2, v2 in pairs(t2) do
						if t1[(i2)]~=t2[(i2)] then
							foundAll = false;
							break;
						end
					end
				end
				return foundAll;
			end
			function obj:tableKeys1ContainsTableKeys2(t1, t2)
				local foundAll = false;
				if obj:isAllTables(t1, t2) and #t2<=#t1 then
					foundAll = true;
					for i2, _ in pairs(t2) do
						local found = false;
						for i1, _ in pairs(t1) do
							if i2==i1 then
								found = true;
								break;
							end
						end
						foundAll = foundAll and found;
						if not foundAll then
							break;
						end
					end
				end
				return foundAll;
			end
			return obj;
		end
		if not dump then
			dump = function(o)
				if type(o)=='table' then
					local s = '{ ';
					for k, v in pairs(o) do
						if type(k)~='number' then
							k = '"'..k..'"';
						end
						s = s..'['..k..'] = '..dump(v)..',';
					end
					return s..'} ';
				else
					return tostring(o);
				end
			end;
		end
		if not mpr then
			mpr = function(msg, color)
				if not color then
					color = "white";
				end
				crawl.mpr("<"..color..">"..msg.."</"..color..">");
			end;
		end
		return Util;
	end,
}
if _modules["main"] then
	return import("main")
else
	error("File \"main.clue\" was not found!")
end