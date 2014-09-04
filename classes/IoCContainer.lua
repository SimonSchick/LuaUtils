return class("IoCContainer", {
	__index = function(self, idx)
		return rawget(self, idx)()
	end
})