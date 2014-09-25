local Rotation = loadClass("Rotation")
local StringBuilder = loadClass("StringBuilder")

return class("Rot13", {
	new = function(self, rotation)
		rotation = rotation or 13
		self.rotation = rotation % 26
	end,
	encrypt = function(self, data)
		local rot = self.rotation
		local b = StringBuilder()
		for c in data:chars() do
			if c >= "A" and c <= "Z" then
				b:add(string.char(65 + (c:byte() - 65 + rot) % 26))
			elseif c >= "a" and c <= "z" then
				b:add(string.char(97 + (c:byte() - 97 + rot) % 26))
			else
				b:add(c)
			end
		end
		return b:get()
	end
}, nil, Rotation)