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

local function canLoadFile(path)
	return not not(loadfile(path))
end

local importMeta = {}

local searchPath
local searchSegments
local lastLine
local canLoad

function importMeta:__unm()
	if canLoad then
		local temp = require(searchSegments)
		searchSegments = ""
		searchPath = includePath
		canLoad = false
		return temp
	end
	error("Invalid import")
end

function importMeta:__call()
	return -self
end

function importMeta:__index(index)
	if not searchPath then
		searchPath = includePath
		searchSegments = ""
	end

	searchPath = searchPath .. (searchPath ~= includePath and "\\" or "") .. index
	searchSegments = searchSegments .. (searchSegments ~= "" and "." or "") .. index
	if canLoadFile(searchPath .. ".lua") then
		canLoad = true
	end
	return self
end
	
import = setmetatable({}, importMeta)