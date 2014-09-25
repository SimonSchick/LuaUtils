return class("UnitTest", {
	new = function(self)
	end,
	error = function(self, msg, ...)
		error(string.format(msg, ...))
	end,
	compErr = function(self, what, a, b)
		self:error("Test '%s' failed for %s %s", what, a, b)
	end,
	singleErr = function(self, what, a)
		self:error("Test '%s' failed for %s", what, a)
	end,
	equal = function(self, a, b)
		if a ~= b then
			self:compErr("equal", a, b)
		end
	end,
	greater = function(self, a, b)
		if a <= b then
			self:compErr("greater", a, b)
		end
	end,
	less = function(self, a, b)
		if a > b then
			self:compErr("less", a, b)
		end
	end,
	greaterEqual = function(self, a, b)
		if a < b then
			self:compErr("greaterEqual", a, b)
		end
	end,
	lessEqual = function(self, a, b)
		if a > b then
			self:compErr("less", a, b)
		end
	end,
	trueish = function(self, a)
		if not a then
			self:singleErr("trueish", a)
		end
	end,
	instanceOf = function(self, a, t)
		local aType = type(a)
		if aType == "table" then
			if a.uid and not instanceof(a, t) then
				self:error("value is not of type %s but is %s", t:getName(), a:getClass():getName())
			elseif not a.uid then
				self:error("value is not  of type %s but is native type %s", t:getName(), aType)
			end
		end
	end
})