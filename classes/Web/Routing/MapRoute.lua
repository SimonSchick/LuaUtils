local Route = require("classes.Web.Route")

return class("MapRoute", {
	new = function(self, path)
		self.path = path
	end
}, nil, Route)