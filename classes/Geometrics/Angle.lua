local sformat = string.format
local error = error

local Vector3 = require("classes.Geometrics.Vector3")

local Angle
local function norm(ang)
	ang.p = ((ang.p + 180) % 360) - 180
	ang.y = ((ang.y + 180) % 360) - 180
	ang.r = ((ang.r + 180) % 360) - 180
	return ang
end

local function normr(ang)
	norm(ang)
	return ang
end

local msin = math.sin
local mcos = math.cos
local mdeg = math.deg

Angle = class("Angle", {
	new = function(self, p, y, r)
		self.p = p or 0
		self.y = y or 0
		self.r = r or 0
		norm(self)
	end,
	clone = function(self)
		return Angle(
			self.p,
			self.y,
			self.r
		)
	end,
	__add = function(self, rhs)
		return Angle(
			self.p + rhs.p,
			self.y + rhs.y,
			self.r + rhs.r
		)
	end,
	__mul = function(self, rhs)
		if type(rhs) == "number" then
			return Angle(
				self.p * rhs,
				self.y * rhs,
				self.r * rhs
			)
		end
	end,
	__sub = function(self, rhs)
		return Angle(
			self.p - rhs.p,
			self.y - rhs.y,
			self.r - rhs.r
		)
	end,
	__div = function(self, rhs)
		if type(rhs) == "number" then
			return Angle(
				self.p / rhs,
				self.y / rhs,
				self.r / rhs
			)
		end
	end,
	__pow = function(self, rhs)
		if type(rhs) == "number" then
			return Angle(
				self.p ^ rhs,
				self.y ^ rhs,
				self.r ^ rhs
			)
		end
	end,
	__umn = function(self)
		return Angle(
			-self.p,
			-self.y,
			-self.r
		)
	end,
	__eq = function(self, rhs)
		return self.p == rhs.p and self.y == rhs.y and self.r == rhs.r
	end,
	__tostring = function(self, rhs)
		return sformat("Angle: (%f, %f, %d)", self.p, self.y, self.r)
	end,
	set = function(self, b)
		self.p = b.p
		self.y = b.y
		self.r = b.r
	end,
	getPYR = function(self)
		return self.p, self.y, self.r
	end,
	addInto = function(self, b)
		self.p = self.p + b.p
		self.y = self.y + b.y
		self.r = self.r + b.r
		norm(self)
	end,
	mulInto = function(self, b)
		self.p = self.p * b.p
		self.y = self.y * b.y
		self.r = self.r * b.r
		norm(self)
	end,
	subInto = function(self, b)
		self.p = self.p - b.p
		self.y = self.y - b.y
		self.r = self.r - b.r
		norm(self)
	end,
	divInto = function(self, b)
		self.p = self.p / b.p
		self.y = self.y / b.y
		self.r = self.r / b.r
		norm(self)
	end,
	getVector = function(self)
		local cp = mcos(mrad(a.p))
		return Vector3(cp*mcos(mrad(a.y)), cp*msin(mrad(a.y)), -msin(mrad(a.p)))
	end
})

return Angle