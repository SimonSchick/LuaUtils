local Queue

Queue = class("Queuev", {
	add = function(self, val)
		table.insert(self, val)
	end,
	poll = function(self)
		return table.remove(self, 1)
	end,
	head = function(self)
		return self[1]
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

return Queue