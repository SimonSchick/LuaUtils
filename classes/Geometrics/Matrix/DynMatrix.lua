local DynMatrix

DynMatrix = class("DynMatrix", {
	new = function(self, rows, columns)
		self.rows = rows
		self.columns = columns
	end
})

return DynMatrix