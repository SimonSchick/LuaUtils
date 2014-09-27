require("meta_extensions.string")
local StringBuilder = loadClass("StringBuilder")

local Encryption = loadClass("Cryptography.Encryption")

return class("Rotation", {
	new = function(self, rotation)
		self.rotation = rotation
	end,
	encrypt = function(self, data)
		local rot = self.rotation
		local b = StringBuilder()
		for c in data:chars() do
			b:add(string.char((c:byte() + rot) % 255))
		end
		return b:get()
	end,
	decrypt = function(self, data)
		self.rotation = -self.rotation
		local ret = self:encrypt(data)
		self.rotation = -self.rotation
		return ret
	end
}, nil, Encryption)