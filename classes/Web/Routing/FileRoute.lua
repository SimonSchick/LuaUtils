local Route = require("classes.Web.Route")

return class("FileRoute", {
	new = function(self, pathFrom, pathTo)
		self.pathFrom = pathFrom
		self.pathTo = pathTo
	end,
	route = function(self, pathFrom)
		local file = io.open(pathFrom:gsub(self.pathFrom, self.pathTo))
		ngx.say(file:read("*a"))
		file:close()
		ngx.eof()
	end
})