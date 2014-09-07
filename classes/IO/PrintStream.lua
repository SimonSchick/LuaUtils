local PrintStream

PrintStream = class("PrintStream", {
	new = function(self, stream)
		self.stream = stream
	end,
	writeToStream = function(self, str)
		self.stream:writeString(str)
	end,
	print = function(self, ...)
		self:writeToStream(table.concat({...}, "\t"))
	end,
	println = function(self, str)
		self:writeToStream(str .. "\n")
	end,
	printFormat = function(self, format, ...)
		self:writeToStream(format:format(...))
	end
})

return PrintStream