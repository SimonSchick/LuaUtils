require("meta_extensions.string")

local Encryption = loadClass("Cryptography.Encryption")

return class("XOR", {
	new = function(self, key)
		self.key = key
	end,
	encrypt = function(self, data)
		return data:xor(self.key)
	end,
	decrypt = function(self, data)
		return self:encrypt(self, data)
	end
}, nil, Encryption)