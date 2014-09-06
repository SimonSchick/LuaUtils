local Route = require("classes.Web.Route")

return class("PatternRoute", {
	new = function(self, pattern, action)
		self.pattern = "^" .. pattern .. "$"
		self.action = action
	end,
	test = function(self, uri)
		return uri:match(self.pattern)
	end,
	route = function(self, uri)
		local matches = {uri:match(self.pattern)}
		if matches[1] == uri then
			self:action()
		else
			self:action(unpack(matches))
		end
	end
	
}, nil, Route)