local function identifyOS()
	return package.config:sub(1, 1) == "\\" and "WIN32" or "UNIX"
end

local includePath = debug.getinfo(1).source:gsub("^@", ""):gsub("\\syntaxcheck%.lua$", "")

local osName = identifyOS()

local tforeach = table.foreach or function(tbl, func)
	for k, v in next, tbl do
		func(k, v)
	end
end

if osName == "WIN32" then

	local function dir(params)
		local proc = io.popen("dir /B " .. params .. " 2>nul")
		local ret = {}
		for line in proc:lines() do
			table.insert(ret, line)
		end
		proc:close()
		return ret
	end

	local function getFiles(path)
		return dir("/A-H-D " .. path)
	end
	
	local function getFolders(path)
		return dir("/A-HD " .. path)
	end
	
	local function findAllFiles(path, extension, ret)
		ret = ret or {}
		for _, folder in next, getFolders(path) do
			findAllFiles(path .. "\\" .. folder, extension, ret)
		end
		
		for _, file in next, getFiles(path) do
			if file:match("%." .. extension .. "$") then
				table.insert(ret, path .. "\\" .. file)
			end
		end
		return ret
	end
	
	tforeach(findAllFiles(includePath, "lua"), function(k, file)
		print("Checking", file)
		local res, err = loadfile(file)
		if not res then
			print(err)
		end
	end)
end

os.exit(0)