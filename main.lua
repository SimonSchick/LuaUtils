local includePath = debug.getinfo(1).source:gsub("^@", ""):gsub("main%.lua$", "")

table.insert(package.loaders, function(moduleName)
	return loadfile(includePath .. moduleName:gsub("%.", "\\") .. ".lua")
end)

class = require "class"