local Route = require("classes.Web.Route")

return class("PlainRoute", {
	new = function(self, uri, action)
		self.uri = uri
		self.action = action
	end,
	test = function(self, uri)
		return self.uri == uri
	end,
	route = function(self, uri)
		if self.action then
			self:action(uri)
		end
	end
}, nil, Route)