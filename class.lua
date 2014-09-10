local setmetatable = setmetatable

local anonClassCounter = 0

local ids = {}

local function generateUID()
	local id
	repeat 
		id = math.random(0, 0xFFFFFFF)
	until not ids[id]
	ids[id] = true
	return string.format("%x08", id)
end

function instanceof(instance, class)
	return instance[class.uid] ~= nil
end

local classMetaTable = {}
classMetaTable.__index = classMetaTable
classMetaTable.name = "INTERNAL CLASS META"

function classMetaTable:getName()
	return self.name
end

function classMetaTable:getMethods()
	local ret = {}
	for k, v in next, self.metaTable do
		if not (k == "__index" or k == "__tostring" or k == "getClass" or k:match("%x%x%x%x%x%x%x%x")) then
			ret[k] = v
		end
	end
	return ret
end

function classMetaTable:getSuper()
	return self.super
end

function classMetaTable:hasSuper()
	return not not self.super
end

function classMetaTable:getUID()
	return self.uid
end

function classMetaTable:__tostring()
	return ("Class: %s"):format(self:getName())
end

function classMetaTable:isAnonymous()
	return not not self.name:match("AnonymousClass%x+")
end

function classMetaTable:implements(otherClass, succ, ret)
	if succ == nil then
		succ = true
	end
	local methods = self:getMethods()
	ret = ret or {}
	for methodName, value in next, otherClass:getMethods() do
		if (methodName:sub(1, 2) ~= "__") and methodName:sub(1, 1):match("%a") and type(methods[methodName]) ~= "function" then
			local otherName = otherClass:getName()
			ret[otherName] = ret[otherName] or {}
			table.insert(ret[otherName], methodName)
			succ = false
		end
	end
	if otherClass:hasSuper() then
		succ = otherClass:implements(otherClass:getSuper(), succ, ret)
	end
	return succ, ret
end


local singletonClassMeta = setmetatable({}, classMetaTable)
singletonClassMeta.__index = singletonClassMeta
singletonClassMeta.name = "INTERNAL SINGLETON CLASS META"

function singletonClassMeta:getInstance()
	if not self.instance then
		self.instance = self()
	end
	return self.instance
end

local function defaultToString(self)
	return ("%s"):format(self:getClass():getName())
end

function abstractClass(name, metaTable, statics, superClass)
	if not name then
		name = string.format("AnonymousClass%08x", anonClassCounter)
		anonClassCounter = anonClassCounter + 1
	end
	
	local uid = generateUID()
	
	if metaTable.new then
		error("Abstract class cannot have constructor")
	end
	
	metaTable.__index = metaTable.__index or metaTable
	metaTable[uid] = true
	

	local internalClassMetaTable = {
		__tostring = classMetaTable.__tostring
	}
	
	internalClassMetaTable.__index = internalClassMetaTable
	
	local classTable = setmetatable({
		metaTable = metaTable,
		uid = uid,
		name = name
	}, setmetatable(internalClassMetaTable, classMetaTable))
	
	if statics then
		for k, v in next, statics do
			classTable[k] = v
		end
	end
	
	if superClass then
		classTable.super = superClass
		setmetatable(metaTable, superClass.metaTable)
	end
	
	return classTable
end
	
function class(name, metaTable, statics, superClass, isSingleton, isAbstract)
	if not name then
		name = string.format("AnonymousClass%08x", anonClassCounter)
		anonClassCounter = anonClassCounter + 1
	end
	
	local uid = generateUID()
	
	local constructor = metaTable.new
 
	metaTable.__index = metaTable.__index or metaTable
	metaTable.__tostring = metaTable.__tostring or defaultToString
	metaTable[uid] = true
	

	local internalClassMetaTable = {
		__call = function(classTbl, ...)
			local new = setmetatable({}, metaTable)
			if constructor then
				constructor(new, ...)
			end
			return new
		end,
		__tostring = classMetaTable.__tostring
	}
	
	internalClassMetaTable.__index = internalClassMetaTable
	
	local classTable = setmetatable({
		metaTable = metaTable,
		uid = uid,
		name = name
	}, setmetatable(internalClassMetaTable, isSingleton and singletonClassMeta or classMetaTable))
	
	if statics then
		for k, v in next, statics do
			classTable[k] = v
		end
	end
	
	if superClass then
		local succ, missing = classTable:implements(superClass)
		if not succ then
			print("ERROR LOADING CLASS")
			for className, missingList in next, missing do
				for idx, methodName in next, missingList do
				print(("Method %s missing as defined in %s"):format(methodName, className))
				end
			end
			error("Missing method")
		end
		setmetatable(metaTable, superClass.metaTable)
	end
	
	metaTable.getClass = function(self)
		return classTable
	end
	
	return classTable
end

return class