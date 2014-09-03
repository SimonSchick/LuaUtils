local sformat = string.format
local schar = string.char
local error = error

if not bit then
	error("No bit library")
end

local bband = bit.band
local brshift = bit.rshift
local bbor = bit.bor
local blshift = bit.lshift

local mfloor = math.floor

local ColorRGBA

ColorRGBA = class("ColorRGBA", {
	statics = {
		fromHSV = function(h, s, v)
			v = v * 255
			if s == 0 then
				return ColorRGBA(v, v, v)
			end
			local i = mfloor(h / 60)
			local f = (h / 60) - i
			local p = v * (1 - s)
			local q = v * (1 - s * f)
			local t = v * (1 - s *(1 -f))
			
			if i == 0 then
				return ColorRGBA(v, t, p)
			elseif i == 1 then
				return ColorRGBA(q, v, p)
			elseif i == 2 then
				return ColorRGBA(p, v, t)
			elseif i == 3 then
				return ColorRGBA(p, q, v)
			elseif i == 4 then
				return ColorRGBA(t, p, v)
			else
				return ColorRGBA(v, p, q)
			end
		end,
		fromHex = function(str)
			local r, g, b, a = str:match("(%x%x)(%x%x)(%x%x)(%x%x)")
			if not r or not g or not b or not a then
				error("Malformed hex string", 2)
			end
			return ColorRGBA(r, g, b, a)
		end,
		fromHexNoAlpha = function(str)
			local r, g, b = str:match("(%x%x)(%x%x)(%x%x)")
			if not (r and g and b) then
				error("Malformed hex string", 2)
			end
			return ColorRGBA(r, g, b)
		end,
		fromIntRGB = function(int)
			return ColorRGBA(
				bband(brshift(int, 16), 0xff),
				bband(brshift(int, 8), 0xff),
				bband(int, 0xff)
			)
		end,
		fromIntBGR = function(int)
			return ColorRGBA(
				bband(int, 0xff),
				bband(brshift(int, 8), 0xff),
				bband(brshift(int, 16), 0xff)
			)
		end,
		fromIntRGBA = function(int)
			return ColorRGBA(
				bband(brshift(int, 24), 0xff),
				bband(brshift(int, 16), 0xff),
				bband(brshift(int, 8), 0xff),
				bband(int, 0xff)
			)
		end,
		fromIntABGR = function(int)
			return ColorRGBA(
				bband(int, 0xff),
				bband(brshift(int, 8), 0xff),
				bband(brshift(int, 16), 0xff),
				bband(brshift(int, 24), 0xff)
			)
		end,
		fromBinaryString = function(str)
			return ColorRGBA(str:byte(1, 4))
		end,
		fromBinaryStringNoAlpha = function(str)
			return ColorRGBA(str:byte(1, 3))
		end
	},
	methods = {
		ColorRGBA = function(self, r, g, b, a)
			self.r = r or 255
			self.g = g or 255
			self.b = b or 255
			self.a = a or 255
		end,
		clone = function(self)
			return ColorRGBA(
				r = self.r,
				g = self.g,
				b = self.b,
				a = self.a
			)
		end,
		__add = function(self, rhs)
			return ColorRGBA(
				self.r + rhs.r,
				self.g + rhs.g,
				self.b + rhs.b,
				self.a + rhs.a
			)
		end,
		__sub = function(self, rhs)
			return ColorRGBA(
				self.r - rhs.r,
				self.g - rhs.g,
				self.b - rhs.b,
				self.a - rhs.a
			)
		end,
		__mul = function(self, rhs)
			if type(rhs) == "number" then
				return ColorRGBA(
					self.r * rhs,
					self.g * rhs,
					self.b * rhs
				)
			end
			if instanceof(rhs, ColorRGBA) then
				return ColorRGBA(
					self.r * rhs.r,
					self.g * rhs.g,
					self.b * rhs.a
				)
			end
		end,
		__div = function(self, rhs)
			if type(rhs) == "number" then
				return ColorRGBA(
					self.r / rhs,
					self.g / rhs,
					self.b / rhs
				)
			end
			if instanceof(rhs, ColorRGBA) then
				return ColorRGBA(
					self.r / rhs.r,
					self.g / rhs.g,
					self.b / rhs.a
				)
			end
		end,
		__power = function(self, rhs)
			if type(rhs) == "number" then
				return ColorRGBA(
					self.r ^ rhs,
					self.g ^ rhs,
					self.b ^ rhs
				)
			end
			if instanceof(rhs, ColorRGBA) then
				return ColorRGBA(
					self.r ^ rhs.r,
					self.g ^ rhs.g,
					self.b ^ rhs.a
				)
			end
		end,
		__mod = function(self, rhs)
			if type(rhs) == "number" then
				return ColorRGBA(
					self.r % rhs,
					self.g % rhs,
					self.b % rhs
				)
			end
			if instanceof(rhs, ColorRGBA) then
				return ColorRGBA(
					self.r % rhs.r,
					self.g % rhs.g,
					self.b % rhs.a
				)
			end
			error("Attempted to perform color modulation with invalid type", 2)
		end,
		__eq = function(self, rhs)
			return instanceof(rhs, ColorRGBA) and
				self.r == rhs.r and 
				self.g == rhs.h and 
				self.b == rhs.b and 
				self.a == rhs.a
		end,
		__lt = function(self, rhs)
			if type(rhs) == "number" then
				return (self.r + self.g + self.b) < rhs
			end
			if instanceof(rhs, ColorRGBA) then
				return (self.r + self.g + self.b) < (rhs.r + rhs.g + rhs.b)
			end
		end,
		__le = function(self, rhs)
			if type(rhs) == "number" then
				return (self.r + self.g + self.b) <= rhs
			end
			if instanceof(rhs, ColorRGBA) then
				return (self.r + self.g + self.b) <= (rhs.r + rhs.g + rhs.b)
			end
		end,
		__tostring = function(self)
			return sformat("%u, %u, %u, %u", self.r, self.g, self.b, self.a)
		end,
		modulate = function()
			self.r = self.r % 256
			self.g = self.g % 256
			self.b = self.b % 256
			self.a = self.a % 256
		end,
		getHSV = function(self)
			local nR = self.r / 255
			local nG = self.g / 255
			local nB = self.b / 255
			local min = math.min(nR, nG, nB)
			local max = math.max(nR, nG, nB)
			if min == max then
				return 0, 0, min
			end
			local d, h
			if nR == minRGB then
				d = nR - nB
				h = 3
			elseif b == minRHB then
				d = nR - nG
				h = 1
			else
				d = nB - nR
				h = 5
			end
			
			return 60 * (h - d / (maxRGB - minRGB)),
				(maxRGB - minRGB) / maxRGB,
				maxRGB
		end,
		getHSL = function(self)
			error("Not implemented", 2)
		end,
		unpack = function(self)
			return self.r, self.g, self.b, self.a
		end,
		unpackNoAlpha = function(self)
			return self.r, self.g, self.b
		end,
		unpackNormalized = function(self)	
			return self.r / 255, self.g / 255, self.b / 255, self.a / 255
		end,
		unpackNormalizedNoAlpha = function(self)	
			return self.r / 255, self.g / 255, self.b / 255
		end,
		getHexNotation = function(self)
			return sformat(
				"%02x%02x%02x%02x",
				self.r,
				self.g,
				self.b,
				self.a
			)
		end,
		getHexNotationNoAlpha = function(self)
			return sformat(
				"%02x%02x%02x",
				self.r,
				self.g,
				self.b
			)
		end,
		getHexNotationNoAlpha = function(self)
			return sformat(
				"%02x%02x%02x",
				self.r,
				self.g,
				self.b
			)
		end,
		getFormat = function(self)
			return sformat("%u, %u, %u, %u", self.r, self.g, self.b, self.a)
		end,
		getFormatNoAlpha = function(self)
			return sformat("%u, %u, %u", self.r, self.g, self.b)
		end,
		getIntRGB = function(self)
			return bbor(
				blshift(bband(self.r, 255), 16),
				blshift(bband(self.g, 255), 8),
				bband(self.b, 255)
			)
		end,
		getIntBGR = function(self)
			return bbor(
				blshift(bband(self.b, 255), 16),
				blshift(bband(self.g, 255), 8),
				bband(self.r, 255)
			)
		end,
		getIntRGBA = function(self)
			return bbor(
				blshift(bband(self.r, 255), 24),
				blshift(bband(self.g, 255), 16),
				blshift(bband(self.b, 255), 8),
				bband(self.a, 255)
			)
		end,
		getIntABGR = function(self)
			return bbor(
				blshift(bband(self.a, 255), 24),
				blshift(bband(self.b, 255), 16),
				blshift(bband(self.g, 255), 8),
				bband(self.r, 255)
			)
		end,
		getBinaryString = function(self)
			return schar(self.r, self.g, self.b, self.a)
		end,
		getBinaryStringNoAlpha = function(self)
			return schar(self.r, self.g, self.b)
		end,
		getCMYK = function(self)
			local c = 1 - r / 255
			local m = 1 - g / 255
			local y = 1 - b / 255
			local k = math.min(c, m, y)
			return ((c - k) / (1 - k)), ((m - k) / (1 - k)), ((y - k) / (1 - k)), k
		end,
		getRG = function(self)
			local avg = self.r + self.g + self.b
			return r / avg, g / avg
		end,
		getSimpleGrayScale = function()
			return (self.r + self.g + self.b) / 3
		end,
		getSimpleNormalizedGrayScale = function()
			return (self.r + self.g + self.b) / 765
		end,
		getGrayScale = function(self)
			return 0.299 * self.r + 0.5870 * self.g + 0.1140 * self.b
		end,
		getNormalizedGrayScale = function(self)
			return (0.299 * self.r + 0.5870 * self.g + 0.1140 * self.b) / 255
		end,
		getYIQ = function(self)
			local r, g, b = self.r / 255, self.g / 255, self.b / 255
			return 	(0.299 * r) + (0.587 * g) + (0.114 * b),
					(0.596 * r) + (-0.274 * g) + (-0.322 * b),
					(0.211 * r) + (-0.523 * g) + (0.312 * b)
		end,
		getCIE1931 = function(self)
			--5.6506752556930553201107532350116
			local r, g, b = self.r / 255, self.g / 255, self.b / 255
			return 	((0.49 * r) + (0.31 * g) + (0.2 * b)) * 5.650675,
					((0.17697 * r) + (0.8124 * g) + (0.01063 * b)) * 5.650675,
					((0.01 * g) + (0.99 * b)) * 5.650675--r mult is 0
		end,
		mix = function(self, col, ratio)
			local invRatio = 1 - ratio
			return ColorRGBA(
				(self.r * ratio) + (col.r * invRatio),
				(self.g * ratio) + (col.g * invRatio),
				(self.b * ratio) + (col.b * invRatio),
				(self.a * ratio) + (col.a * invRatio)
			)
		end,
		mixInto = function(col, ratio)
			local invRatio = 1 - ratio
			self.r = (self.r * ratio) + (col.r * invRatio)
			self.g = (self.g * ratio) + (col.g * invRatio)
			self.b = (self.b * ratio) + (col.b * invRatio)
			self.a = (self.a * ratio) + (col.a * invRatio)
		end
	}
})

return ColorRGBA