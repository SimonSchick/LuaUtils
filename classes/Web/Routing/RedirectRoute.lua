local Route = require("classes.Web.Route")

return class("RedirectRoute", {
	new = function(self, from, to)
		self.from = from
		self.to = to
	end,
	test = function(self, uri)
		return self.from == uri
	end,
	route = function(self)
		return {
			redirect = self.to
		}
	end
})