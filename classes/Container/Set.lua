return class("Set", {
	new = function(self)
		self.data = {}
	end,
	contains = function(self, val)
		return self.data[val]
	end,
	add = function(self, val)
		self.data[val] = true
	end,
	remove = function(self, val)
		self.data[val] = nil
	end
})