local Matrix

Matrix = class("Matrix", {
	transpose = function(self)
		for row = 1, self.rows do
			for column = 1, row do
				self[row][column], self[column][row] = self[column][row], self[row][column]
			end
		end
	end,
	getTranspose = function(self)
		local new = self:clone()
		new:transpose()
		return new
	end,
	negate = function(self)
		for row = 1, self.rows do
			for column = 1, row do
				self[row][column] = -self[row][column]
			end
		end
	end,
	substract = function(self, b)
		for row = 1, self.rows do
			for column = 1, row do
				self[row][column] = self[row][column] - b[row][column]
			end
		end
	end,
	add = function(self, b)
		for row = 1, self.rows do
			for column = 1, row do
				self[row][column] = self[row][column] + b[row][column]
			end
		end
	end,
	divide = function(self, b)
		for row = 1, self.rows do
			for column = 1, row do
				self[row][column] = self[row][column] / b[row][column]
			end
		end
	end
})

return Matrix