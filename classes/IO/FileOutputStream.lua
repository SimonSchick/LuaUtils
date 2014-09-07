local FileOutputStream

FileOutputStream = class("FileOutputStream", {
	new = function(self, file, appendMode)
		if type(file) == "*FILE" or (type(file) == "userdata" and file.write) then
			self.fileHandle = file
			return
		end
		self.file = file
		self.fileHandle = io.open(self.file:getPath(), "r" .. appendMode and "a" or "")
	end,
	writeString = function(self, str)
		self.fileHandle:write(str)
	end,
	close = function(self)
		self.fileHandle:close()
		self.fileHandle = nil
	end,
	flush = function(self)
		self.fileHandle:flush()
	end
}, {
	FromLuaFile = function(luaFileHandle)
		return FileOutputStream(luaFileHandle)
	end
})

return FileOutputStream