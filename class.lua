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

function classMetaTable:getName()
	return self.name
end

function classMetaTable:getMethods()
	return self.metaTable
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

local singletonClassMeta = setmetatable({}, classMetaTable)
singletonClassMeta.__index = singletonClassMeta

function singletonClassMeta:getInstance()
	if not self.instance then
		self.instance = self()
	end
	return self.instance
end

local function defaultToString(self)
	return ("%s"):format(self:getClass():getName())
end
	
function class(name, metaTable, statics, superClass, isSingleton)
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
	
	local classTable = setmetatable({}, setmetatable(internalClassMetaTable, isSingleton and singletonClassMeta or classMetaTable))
	
	classTable.metaTable = metaTable
	classTable.uid = uid
	classTable.name = name
	
	if statics then
		for k, v in next, statics do
			classTable[k] = v
		end
	end
	
	if superClass then
		classTable.super = superClass
		setmetatable(metaTable, superClass.metaTable)
	end
	
	metaTable.getClass = function(self)
		return classTable
	end
	
	for k, v in next, metaTable do
		if k ~= "new" then
			metaTable[k] = v
		end
	end
	
	return classTable
end

return class