local System

System =  class("System", {
}, {
	getUserName = function()
		return System.run("whoami")
	end,
	run = function(cmd)
		local proc = io.popen(cmd)
		local out = proc:read("*a"):gsub("%s+$", "")
		proc:close()
		return out
	end,
	getenv = function(var)
		return os.getenv(var)
	end,
	exit = function(code)
		os.exit(code)
	end,
})
return System