local msqrt = math.sqrt

local Vector3

Vector3 = class("Vector3", {
	Vector3 = function(self, x, y, z)
		self.x = x or 0
		self.y = y or 0
		self.z = z or 0
	end,
	clone = function(self)
		return Vector3(
			self.x,
			self.y,
			self.z
		)
	end,
	__add = function(self, rhs)
		return Vector3(
			self.x + rhs.x,
			self.y + rhs.y,
			self.z + rhs.z
		)
	end,
	__mul = function(self, rhs)
		if instanceof(rhs, Vector3) then
			return Vector3(
				self.x * rhs.x,
				self.y * rhs.y,
				self.z * rhs.z
			)
		elseif type(rhs) == "number" then
			return Vector3(
				self.x * rhs,
				self.y * rhs,
				self.z * rhs
			)
		end
	end,
	__sub = function(self, rhs)
		return Vector3(
			self.x - rhs.x,
			self.y - rhs.y,
			self.z - rhs.z
		)
	end,
	__div = function(self, rhs)
		if instanceof(rhs, Vector3) then
			return Vector3(
				self.x / rhs.x,
				self.y / rhs.y,
				self.z / rhs.z
			)
		elseif type(rhs) == "number" then
			return Vector3(
				self.x / rhs,
				self.y / rhs,
				self.z / rhs
			)
		end
	end,
	__pow = function(self, rhs)
		if instanceof(rhs, Vector3) then
			return Vector3(
				self.x ^ rhs.x,
				self.y ^ rhs.y,
				self.z ^ rhs.z
			)
		elseif type(rhs) == "number" then
			return Vector3(
				self.x ^ rhs,
				self.y ^ rhs,
				self.z ^ rhs
			)
		end
	end,
	__umn = function(self)
		return Vector3(
			-self.x,
			-self.y,
			-self.z
		)
	end,
	__len = function(self)
		return msqrt(self.x ^ 2 + self.y ^ 2 + self.z ^ 2)
	end,
	__eq = function(self, rhs)
		return self.x == rhs.x and self.y == rhs.y and self.z == rhs.z
	end,
	__lt = function(self, rhs)
		return msqrt(self.x ^ 2 + self.y ^ 2 + self.z ^ 2) < msqrt(rhs.x ^ 2 + rhs.y ^ 2 + rhs.z ^ 2)
	end,
	__le = function(self, rhs)
		return msqrt(self.x ^ 2 + self.y ^ 2 + self.z ^ 2) <= msqrt(rhs.x ^ 2 + rhs.y ^ 2 + rhs.z ^ 2)
	end,
	__tostring = function(self, rhs)
		return ("Vector3: (%f, %f, %f)"):format(self.x, self.y, self.z)
	end,
	getLength = function(self)
		return msqrt(self.x ^ 2 + self.y ^ 2 + self.z ^ 2)
	end,
	getNormal = function(self)
		local len = msqrt(self.x ^ 2 + self.y ^ 2 + self.z ^ 2)
		return Vector3(
			self.x / len,
			self.y / len,
			self.z / len
		)
	end,
	normalize = function(self)
		local len = msqrt(self.x ^ 2 + self.y ^ 2 + self.z ^ 2)
		self.x = self.x / len
		self.y = self.y / len
		self.z = self.z / len
	end,
	getDot = function(self, rhs)
		return (self.x * rhs.x + self.y * rhs.y + self.z * rhs.z) / (msqrt(self.x ^ 2 + self.y ^ 2 + self.z ^ 2) * msqrt(rhs.x ^ 2 + rhs.y ^ 2 + rhs.z ^ 2))
	end,
	getCross = function(self, rhs)
		return Vector3(
			self.y * rhs.z - self.z * rhs.y,
			self.z * rhs.x - self.x * rhs.z,
			self.x * rhs.y - self.y * rhs.x
		)
	end,
	set = function(self, vec)
		self.x = vec.x
		self.y = vec.y
		self.z = vec.z
	end,
	getXYZ = function(self)
		return self.x, self.y, self.z
	end,
	addInto = function(self, vec)
		self.x = self.x + vec.x
		self.y = self.y + vec.y
		self.z = self.z + vec.z
	end,
	mulInto = function(self, vec)
		self.x = self.x * vec.x
		self.y = self.y * vec.y
		self.z = self.z * vec.z
	end,
	subInto = function(self, vec)
		self.x = self.x - vec.x
		self.y = self.y - vec.y
		self.z = self.z - vec.z
	end,
	divInto = function(self, vec)
		self.x = self.x / vec.x
		self.y = self.y / vec.y
		self.z = self.z / vec.z
	end,
	distance = function(self, b)
		return msqrt((b.x - self.x) ^ 2 + (b.y - self.y) ^ 2 + (b.z - self.z) ^ 2)
	end,
	inAABB = function(self, boxA, boxB)
		return (boxA.x <= self.x) and (boxB.x >= self.x) and (boxA.y <= self.y) and (boxB.y >= self.y)
	end,
	lerp = function(self, dest, fact)
		return Vector3(
			self.x + (dest.x - self.x) * t,
			self.y + (dest.y - self.y) * t,
			self.z + (dest.z - self.z) * t
		)
	end,
	lerpInto = function(self, dest, fact)
		self.x = self.x + (dest.x - self.x) * t
		self.y = self.y + (dest.y - self.y) * t
		self.z = self.z + (dest.z - self.z) * t
	end,
	isZero = function(self)
		return self.x == 0 and self.y == 0 and self.z == 0
	end
})

Vector3.Front = Vector3(0, 1, 0)
Vector3.Back = Vector3(0, -1, 0)

Vector3.Up = Vector3(0, 0, 1)
Vector3.Down = Vector3(0, 0, -1)

Vector3.Right = Vector3(1, 0, 0)
Vector3.Left = Vector3(-1, 0, 0)

Vector3.Origin = Vector()
Vector3.Zero = Vector3.Origin

Vector3.Unit = Vector3(1, 1, 1)

return Vector3