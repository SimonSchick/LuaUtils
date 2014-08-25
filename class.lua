local anonClassCounter = 0

local ids = {}

local function generateUID()
	local id
	repeat 
		id = math.random(0, 0xFFFFFFFF)
	until not ids[id]
	ids[id] = true
	return string.format("%x08", id)
end

function instanceof(instance, class)
	return instance[class.uid] ~= nil
end
	
function class(name, metaTable, statics, superClass, namespace, isSingleton)
	if not name then
		name = string.format("AnonymousClass%08x", anonClassCounter)
		anonClassCounter = anonClassCounter + 1
	end
	
	local uid = generateUID()
	
	local constructor = metaTable.new
 
	metaTable.__index = metaTable
	metaTable[uid] = true
	
	local classTable = setmetatable({}, {
		__call = function(classTbl, ...)
			local new = setmetatable({}, metaTable)
			constructor(new, ...)
			return new
		end
	})
	
	classTable.metaTable = metaTable
	
	classTable.uid = uid
	
	classTable.getName = function()
		return name
	end
	
	classTable.getMethods = function()
		return metaTable
	end
	
	if isSingleton then
		function classTable:getInstance()
			if not self.instance then
				self.instance = classTable()
			end
			return self.instance
		end
	end
	
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

	namespace = namespace or _G
	namespace[name] = classTable

	
	return classTable
end