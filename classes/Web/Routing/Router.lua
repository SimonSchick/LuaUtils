return class("Router", {
	new = function(self)
		self.routes = {}
	end,
	register = function(self, route)
		table.insert(self.routes, route)
	end,
	route = function(self, uri)
		for index, route in next, self.routes do
			if route:test(uri) then
				local res = route:route(uri)
				if res.redirect then
					return self:route(res.redirect)
				end
			end
		end
	end
}, nil, nil, nil, true)
	