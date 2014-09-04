includePath = debug.getinfo(1).source:gsub("^@", ""):gsub("main%.lua$", "")

table.insert(package.loaders, function(moduleName)
	--TODO: allow relative includes
	local succ, err = loadfile(includePath .. moduleName:gsub("%.", "\\") .. ".lua")
	if not succ then
		error(err, 2)
	end
	return succ
end)

class = require "class"

local importMeta = {}

local searchPath
local searchSegments

function importMeta:__index(index)
	if not searchPath then
		searchPath = includePath
		searchSegments = ""
	end
	
	searchPath = searchPath .. (searchPath ~= includePath and "\\" or "") .. index
	searchSegments = searchSegments .. (searchSegments ~= "" and "." or "") .. index
	if loadfile(searchPath .. ".lua") then
		local tempSearchSegments = searchSegments
		
		searchSegments = ""
		searchPath = includePath
		return require(tempSearchSegments)
	end
	return self
end
	
import = setmetatable({}, importMeta)