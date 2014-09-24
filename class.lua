local setmetatable = setmetatable

local anonClassCounter = 0

local ids = {}

local function injectSuperUpValue(class)
	local superMethods = class.super.methods
	
	for name, method in next, class.methods do
		if type(method) == "function" then
			for i = 1, debug.getinfo(method, "u").nups do
				local name, value = debug.getupvalue(method, i)
				if name == "super" then
					debug.setupvalue(method, i, superMethods)
					break
				end
			end
		end
	end
end

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

local classmethods = {}
classmethods.__index = classmethods
classmethods.name = "INTERNAL CLASS META"

function classmethods:getName()
	return self.name
end

function classmethods:getMethods()
	local ret = {}
	for k, v in next, self.methods do
		if not (k == "__index" or k == "__tostring" or k == "getClass" or k:match("%x%x%x%x%x%x%x%x")) then
			ret[k] = v
		end
	end
	return ret
end

function classmethods:getSuper()
	return self.super
end

function classmethods:hasSuper()
	return not not self.super
end

function classmethods:getUID()
	return self.uid
end

function classmethods:__tostring()
	return ("Class: %s"):format(self:getName())
end

function classmethods:isAnonymous()
	return not not self.name:match("AnonymousClass%x+")
end

function classmethods:implements(otherClass, succ, ret)
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


local singletonClassMeta = setmetatable({}, classmethods)
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

function abstractClass(name, methods, statics, superClass)
	if not name then
		name = string.format("AnonymousClass%08x", anonClassCounter)
		anonClassCounter = anonClassCounter + 1
	end
	
	local uid = generateUID()
	
	if methods.new then
		error("Abstract class cannot have constructor")
	end
	
	methods.__index = methods.__index or methods
	methods[uid] = true
	

	local internalClassmethods = {
		__tostring = classmethods.__tostring
	}
	
	internalClassmethods.__index = internalClassmethods
	
	local classTable = setmetatable({
		methods = methods,
		uid = uid,
		name = name,
		new = constructor
	}, setmetatable(internalClassmethods, classmethods))
	
	if statics then
		for k, v in next, statics do
			classTable[k] = v
		end
	end
	
	if superClass then
		classTable.super = superClass
		setmetatable(methods, superClass.methods)
		classTable.super = superClass
		injectSuperUpValue(classTable)
	end
	
	return classTable
end
	
function class(name, methods, statics, superClass, isSingleton, isAbstract)
	if not name then
		name = string.format("AnonymousClass%08x", anonClassCounter)
		anonClassCounter = anonClassCounter + 1
	end
	
	local uid = generateUID()
	
	local constructor = methods.new
 
	methods.__index = methods.__index or methods
	methods.__tostring = methods.__tostring or defaultToString
	methods[uid] = true
	

	local internalClassmethods = {
		__call = function(classTbl, ...)
			local new = setmetatable({}, methods)
			if constructor then
				constructor(new, ...)
			end
			return new
		end,
		__tostring = classmethods.__tostring
	}
	
	internalClassmethods.__index = internalClassmethods
	
	local classTable = setmetatable({
		methods = methods,
		uid = uid,
		name = name,
		new = constructor
	}, setmetatable(internalClassmethods, isSingleton and singletonClassMeta or classmethods))
	
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
		setmetatable(methods, superClass.methods)
		classTable.super = superClass
		injectSuperUpValue(classTable)
	end
	
	methods.getClass = function()
		return superClass
	end
	
	return classTable
end

return class