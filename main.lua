do --simple compatibilty layer
	bit = bit or bit32
end

local function getCurrentScriptFolder(level)
	return debug.getinfo(level + 1, "S").source:gsub("^@", ""):gsub("[%w_%.]-%.lua", "")
end

includePath = getCurrentScriptFolder(1)

local function injectRequireLoader()
	package.path = package.path .. ";" .. includePath .. "?.lua"
end

local function canLoadFile(path)
	return not not(loadfile(path))
end

function loadClass(class)
	local folderPath = getCurrentScriptFolder(2)
	local path = folderPath .. class:gsub("%.", "\\") .. ".lua"
	if canLoadFile(path) then
		local s, e = folderPath:find(includePath, 1, true)
		return require("classes." .. folderPath:sub(e+1):gsub("classes\\", ""):gsub("\\", ".") .. class)
	end
	return require(class)
end

class = require "class"