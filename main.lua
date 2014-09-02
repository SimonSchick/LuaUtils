local includePath = debug.getinfo(1).source:gsub("^@", ""):gsub("main%.lua$", "")

table.insert(package.loaders, function(moduleName)
	local succ, err = loadfile(includePath .. moduleName:gsub("%.", "\\") .. ".lua")
	if not succ then
		error(err, 2)
	end
	return succ
end)

class = require "class"

