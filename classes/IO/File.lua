local File

File = class("File", {
	new = function(self, path, fileName)
		if fileName then
			self.path = path .. fileName
			self.name = fileName
			return
		end
		local path, name = path:match("(.-)[/\\]([\w_%.]+)")
	end
})

return File