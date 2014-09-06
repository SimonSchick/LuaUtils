local Vector2

Vector2 = class("Vector2", {
	new = function(self, x, y)
		self.x = x or 0
		self.y = y or 0
	end,
	clone = function(self)
		return Vector2(
			self.x,
			self.y
		)
	end,
	__add = function(self, rhs)
		return Vector2(
			self.x + rhs.x,
			self.y + rhs.y
		)
	end,
	__mul = function(self, rhs)
		if instanceof(rhs, Vector2) then
			return Vector2(
				self.x * rhs.x,
				self.y * rhs.y
			)
		elseif type(rhs) == "number" then
			return Vector2(
				self.x * rhs,
				self.y * rhs
			)
		end
	end,
	__sub = function(self, rhs)
		return Vector2(
			self.x - rhs.x,
			self.y - rhs.y
		)
	end,
	__div = function(self, rhs)
		if instanceof(rhs, Vector2) then
			return Vector2(
				self.x / rhs.x,
				self.y / rhs.y
			)
		elseif type(rhs) == "number" then
			return Vector2(
				self.x / rhs,
				self.y / rhs
			)
		end
	end,
	__pow = function(self, rhs)
		if instanceof(rhs, Vector2) then
			return Vector2(
				self.x ^ rhs.x,
				self.y ^ rhs.y
			)
		elseif type(rhs) == "number" then
			return Vector2(
				self.x ^ rhs,
				self.y ^ rhs
			)
		end
	end,
	__umn = function(self)
		return Vector2(
			-self.x,
			-self.y
		)
	end,
	__len = function(self)
		return msqrt(self.x ^ 2 + self.y ^ 2)
	end,
	__eq = function(self, rhs)
		return self.x == rhs.x and self.y == rhs.y
	end,
	__lt = function(self, rhs)
		return msqrt(self.x ^ 2 + self.y ^ 2) < msqrt(rhs.x ^ 2 + rhs.y ^ 2)
	end,
	__le = function(self, rhs)
		return msqrt(self.x ^ 2 + self.y ^ 2) <= msqrt(rhs.x ^ 2 + rhs.y ^ 2)
	end,
	__tostring = function(self, rhs)
		return sformat("Vector2: (%f, %f)", self.x, self.y)
	end,
	length = function(self)
		return msqrt(self.x ^ 2 + self.y ^ 2)
	end,
	lengthSqr = function(self)
		return self.x ^ 2 + self.y ^ 2
	end,
	getNormal = function(self)
		local len = msqrt(self.x ^ 2 + self.y ^ 2)
		return Vector2(
			self.x / len,
			self.y / len
		)
	end,
	normalize = function(self)
		local len = msqrt(self.x ^ 2 + self.y ^ 2)
		self.x = self.x / len
		self.y = self.y / len
	end,
	getDot = function(self, rhs)
		return (self.x * rhs.x + self.y * rhs.y) / (msqrt(self.x ^ 2 + self.y ^ 2)*msqrt(rhs.x ^ 2 + rhs.y ^ 2))
	end,
	getCross = function(self, rhs)
		return self.x * rhs.y - self.y * rhs.x
	end,
	set = function(self, vec)
		self.x = vec.x
		self.y = vec.y
	end,
	getXY = function(self)
		return self.x, self.y
	end,
	addInto = function(self, vec)
		self.x = self.x + vec.x
		self.y = self.y + vec.y
	end,
	mulInto = function(self, b)
		if type == "number" then
			self.x = self.x * b
			self.y = self.y * b
		elseif instanceof(b, Vector2) then
			self.x = self.x * b.x
			self.y = self.y * b.y
		end
	end,
	subInto = function(self, vec)
		self.x = self.x - vec.x
		self.y = self.y - vec.y
	end,
	divInto = function(self, vec)
		if type == "number" then
			self.x = self.x / b
			self.y = self.y / b
		elseif instanceof(b, Vector2) then
			self.x = self.x / b.x
			self.y = self.y / b.y
		end
	end,
	
	distance = function(self, b)
		return msqrt((b.x - self.x) ^ 2 + (b.y - self.y) ^ 2)
	end,
	distanceSqr = function(self, b)
		return (b.x - self.x) ^ 2 + (b.y - self.y) ^ 2
	end,
	inAABB = function(self, boxA, boxB)
		return (boxA.x <= self.x) and (boxB.x >= self.x) and (boxA.y <= self.y) and (boxB.y >= self.y)
	end,
	lerp = function(self, dest, fact)
		return Vector2(
			self.x + (dest.x - self.x) * t,
			self.y + (dest.y - self.y) * t
		)
	end,
	lerpInto = function(self, dest, fact)
		self.x = self.x + (dest.x - self.x) * t
		self.y = self.y + (dest.y - self.y) * t
	end,
	isZero = function(self)
		return self.x == 0 and self.y == 0
	end,
	clone = function(self)
		return Vector2(
			self.x,
			self.y
		)
	end
})

Vector2.Up = Vector2(0, 1)
Vector2.Down = Vector2(0, -1)

Vector2.Right = Vector2(1, 0)
Vector2.Left = Vector2(-1, 0)

Vector2.Unit = Vector2(1, 1)

Vector2.Origin = Vector2()
Vector2.Zero = Vector2.Origin

return Vector2