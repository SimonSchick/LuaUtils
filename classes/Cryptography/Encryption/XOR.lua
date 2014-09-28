require("meta_extensions.string")

local Encryption = loadClass("Cryptography.Encryption")

return class("XOR", {
	new = function(self, key)
		self.key = key
	end,
	encrypt = function(self, data)
		return b:get()
	end,
	decrypt = function(self, data)
		self.rotation = -self.rotation
		local ret = self:encrypt(data)
		self.rotation = -self.rotation
		return ret
	end
}, nil, Encryption)