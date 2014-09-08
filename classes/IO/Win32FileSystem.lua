local FileSystem = require("classes.IO.FileSystem")

local function runAndGetOutput(cmd)
	local proc = io.popen(cmd)
	local out = proc:read("*a")
	proc:close()
	return out
end

local function run(cmd)
	io.popen(cmd):close()
end

local function dir(params)
	local proc = io.popen("dir /B " .. params .. " 2>nul")
	local ret = {}
	for line in proc:lines() do
		table.insert(ret, line)
	end
	proc:close()
	return ret
end

local WinFileSystem
WinFileSystem = class("WinFileSystem", {
	exists = function(self, path)
		return runAndGetOutput(("IF EXIST %q ( echo true ) else ( echo false )"):format(path)):find("true", 1, true) ~= nil
	end,
	create = function(self, path)
		run(("copy NUL \"%s\""):format(path))
	end,
	createDirectory = function(self, path)
		run(("mkdir \"%s\""):format(path))
	end,
	getFiles = function(self, path)
		return dir(("/A-H-D \"%s\""):format(path))
	end,
	getDirectories = function(self, path)
		return dir(("/A-HD \"%s\""):format(path))
	end,
	deleteFile = function(self, path)
		run(("DEL /Q /F \"%s\""):format(path))
	end,
	deleteDirectory = function(self, path)
		run(("RMDIR /S /Q \"%s\""):format(path))
	end
}, nil, FileSystem)

return WinFileSystem