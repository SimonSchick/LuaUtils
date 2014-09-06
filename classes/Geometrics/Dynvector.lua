local sformat = string.format
local srep = string.rep
local error = error

local IsDynVector

local function getLength(obj)
	local len = 0
	for i = 1, obj.size do
		len = obj[i]^2
	end
	return msqrt(len)
end

local function sizeCheck(self, other)
	if self.size ~= other.size then
		error(
			("Attempted to perform arithmetic between 2 DynVectors of incompatible size (%u, %u)"):format(self.size, other.size),
			3
		)
	end
end

local function compatCheck(self, other)
	sizeCheck(self, other)
end

local DynVector

DynVector = class("DynVector", {
	new = function(self, ...)
		if(IsDynVector(...)) then
			local b = select(...)
			for i = 1, b do
				self[i] = b[i]
			end
			self.size = b.size
		end
		local dat = {...}
		for i = 1, #dat do
			self[i] = dat[i]
		end
		self.size = #dat
	end,
	clone = function(self)
		local new = {size = self.size}
		for i = 1, self.size do
			new[i] = self[i]
		end
		return DynVector.__manualCreate(new)
	end,
	__add = function(self, rhs)
		compatCheck(self, rhs)
		
		local new = {size = self.size}
		for i = 1, self.size do
			new[i] = self[i] + rhs[i]
		end
		return DynVector.__manualCreate(new)
	end,
	__mul = function(self, rhs)
		local new = {size = self.size}
		if instanceof(rhs, DynVector) then
			for i = 1, self.size do
				new[i] = self[i] * rhs[i]
			end
		elseif type(rhs) == "number" then
			for i = 1, self.size do
				new[i] = self[i] * rhs
			end
		end
		return DynVector.__manualCreate(new)
	end,
	__sub = function(self, rhs)
		compatCheck(self, rhs)
		
		local new = {size = self.size}
		for i = 1, self.size do
			new[i] = self[i] - rhs[i]
		end
		return DynVector.__manualCreate(new)
	end,
	__div = function(self, rhs)
		local new = {size = self.size}
		if instanceof(rhs, DynVector) then
			for i = 1, self.size do
				new[i] = self[i] / rhs[i]
			end
		elseif type(rhs) == "number" then
			for i = 1, self.size do
				new[i] = self[i] / rhs
			end
		end
		return DynVector.__manualCreate(new)
	end,
	__pow = function(self, rhs)
		local new = {size = self.size}
		if instanceof(rhs, DynVector) then
			for i = 1, self.size do
				new[i] = self[i] ^ rhs[i]
			end
		elseif type(rhs) == "number" then
			for i = 1, self.size do
				new[i] = self[i] ^ rhs
			end
		end
		return DynVector.__manualCreate(new)
	end,
	__unm = function(self)
		local new = {size = self.size}
		for i = 1, self.size do
			new[i] = -self[i]
		end
		return DynVector.__manualCreate(new)
	end,
	__len = function(self)
		return getLength(self)
	end,
	__eq = function(self, rhs)
		if(not instanceof(rhs, DynVector) or self.size ~= rhs.size) then
			return false
		end
		for i = 1, self.size do
			if(self[i] ~= rhs[i]) then
				return false
			end
		end
		return true
	end,
	__tostring = function(self, rhs)
		return sformat("DynVector<%u>: ("..srep("%f, ", self.size):sub(1, -2)..")", self.size, unpack(self))
	end,
	length = function(self)
		return getLength(self)
	end,
	getNormal = function(self)
		local len = getLength(self)
		
		local new = {}
		for i = 1, self.size do
			new[i] = self[i]/len
		end
		return DynVector.call(new)
	end,
	normalize = function(self)
		local len = getLength(self)
		for i = 1, self.size do
			self[i] = self[i]/len
		end
	end,
	getDot = function(self, rhs)
		compatCheck(self, rhs)
		
		local divident = 0
		for i = 1, self.size do
			divident = divident + (self[i]*rhs[i])
		end
		return divident/(getLength(self)*getLength(rhs))
	end,
	getCross = function(self, rhs)
		error("Not implemented")
	end,
	set = function(self, vec)
		compatCheck(self, rhs)
		
		for i = 1, self.size do
			self[i] = vec[i]
		end
	end,
	getValues = function(self)
		return unpack(self)
	end,
	addInto = function(self, vec)
		compatCheck(self, rhs)
		
		for i = 1, self.size do
			self[i] = self[i] + vec[i]
		end
	end,
	mulInto = function(self, vec)
		if instanceof(vec, DynVector) then
			for i = 1, self.size do
				self[i] = self[i] * vec[i]
			end
		elseif type(vec) == "number" then
			for i = 1, self.size do
				self[i] = self[i] * vec
			end
		end
	end,
	subInto = function(self, vec)
		compatCheck(self, rhs)
		
		for i = 1, self.size do
			self[i] = self[i] - vec[i]
		end
	end,
	divInto = function(self, vec)
		if instanceof(vec, DynVector) then
			for i = 1, self.size do
				self[i] = self[i] / vec[i]
			end
		elseif type(vec) == "number" then
			for i = 1, self.size do
				self[i] = self[i] / vec
			end
		end
	end,
	dist = function(self, b)
		compatCheck(self, rhs)
		local len = 0
		for i = 1, self.size do
			len = (b[i] - self[i])^2
		end
		return msqrt(len)
	end,
	inAABB = function(self, boxA, boxB)
		compatCheck(self, boxA)
		compatCheck(self, boxB)
		for i = 1, self.size do
			if not (boxA[i] <= self[i]) and (boxB[i] >= self[i]) then
				return false
			end
		end
		return true
	end,
	lerp = function(self, dest, fact)
		local ret = {}
		for i = 1, self.size do
			ret[i] = self[i] + (dest[i] - self[i]) * t
		end
		return DynVector.__manualCreate(new)
	end,
	lerpInto = function(self, dest, fact)
		for i = 1, self.size do
			self[i] = self[i] + (dest[i] - self[i]) * t
		end
	end,
	isZero = function(self)
		for i = 1, self.size do
			if(self[i] ~= 0) then
				return false
			end
		end
		return true
	end
})

return DynVector