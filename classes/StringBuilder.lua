return class("StringBuilder", {
	new = function(self)
	end,
	add = function(self, str)
		self[#self + 1] = str
	end,
	get = function(self)
		return table.concat(self)
	end,
	clear = function(self)
		for k in ipairs(self) do
			self[k] = nil
		end
	end
})