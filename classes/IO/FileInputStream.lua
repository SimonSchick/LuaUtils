local FileInputStream

FileInputStream = class("FileInputStream", {
	new = function(self, file, appendMode)
		if type(file) == "*FILE" or (type(file) == "userdata" and file.write) then
			self.fileHandle = file
			return
		end
		self.file = file
		self.fileHandle = io.open(self.file:getPath(), "r" .. appendMode and "a" or "")
	end,
	read = function(self)
		return self.fileHandle:read("*a")
	end,
	readLine = function(self)
		return self.fileHandle:read("*l")
	end,
	readString = function(self, len)
		return self.fileHandle:read(len)
	end,
	close = function(self)
		self.fileHandle:close()
		self.fileHandle = nil
	end
}, {
	FromLuaFile = function(luaFileHandle)
		return FileInputStream(luaFileHandle)
	end
})

return FileInputStream