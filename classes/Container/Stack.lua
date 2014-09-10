local Stack

Stack = class("Stack", {
	push = function(self, val)
		table.insert(self, val)
	end,
	pop = function(self)
		return table.remove(self)
	end,
	peek = function(self)
		return self[#self]
	end,
	isEmpty = function(self)
		return #self == 0
	end,
	clear = function(self)
		for i = 1, #self do
			self[i] = nil
		end
	end
})

return Stack