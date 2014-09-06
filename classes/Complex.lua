local sformat = string.format
local schar = string.char

local atan = math.atan
local pi = math.pi
local pi2 = math.pi/2

local sign = require("libraries.math.extended").sign

local Complex

Complex = class("Complex", {
	methods = {
		new = function(self, real, imag)
			self.r = real or 0
			self.i = imag or 0
		end,
		__add = function(self, rhs)
			return Complex(
				self.r + rhs.r,
				self.i + rhs.i
			)
		end,
		__sub = function(self, rhs)
			return Complex(
				self.r - rhs.r,
				self.i - rhs.i
			)
		end,
		__mul = function(self, rhs)
			if type(rhs) == "number" then
				return Complex(
					self.r * rhs,
					self.i * rhs
				)
			elseif instanceof(rhs, Complex) then
				return Complex(
					self.r * rhs.r - self.i * rhs.i,
					self.r * rhs.i + self.i * rhs.r
				)
			end
		end,
		__div = function(self, rhs)
			if type(rhs) == "number" then
				return Complex(
					self.r / rhs,
					self.i / rhs
				)
			elseif instanceof(rhs, Complex) then
				local conjR = rhs.r
				local conjI = -rhs.i
				
				local lowerR = rhs.r * conjR - (rhs.i * conjI)
				
				return Complex(
					(self.r * conjR - self.i * conjI) / lowerR,
					(self.i * conjR + self.r * conjI) / lowerR
				)
			end
		end,
		__tostring = function(self)
			if self.r ~= 0 and self.i ~= 0 then
				return sformat("%f + %fi", self.r, self.i)
			elseif self.r ~= 0 then
				return sformat("%f", self.r)
			else
				return sformat("%fi", self.i)
			end
		end,
		sqrt = function(self)
			if self.i == 0 then
				return self.r
			end
			return Complex(
				msqrt(self.r + msqrt(self.r ^ 2+self.i ^ 2) / 2),
				sign(self.i) * msqrt(-self.r + msqrt(self.r ^ 2+self.i ^ 2) / 2)
			)
		end,
		abs = function(self)
			return msqrt(self.r ^ 2 + self.i ^ 2)
		end,
		conjugate = function(self)
			return Complex(
				self.r,
				-self.i
			)
		end,
		argument = function(self)
			if self.r > 0 then
				return atan(self.i/self.r)
			elseif x < 0 and y >= 0 then
				return atan(self.i/self.r)+pi
			elseif x < 0 and y < 0 then
				return atan(self.i/self.r)-pi
			elseif x == 0 and y > 0 then
				return pi2
			elseif x == 0 and y < 0 then
				return -pi2
			end
			return nil
		end
	}
})

return Complex
