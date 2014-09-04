local osDate = os.date

return class("Date", {
	new = function(self, time)
		self.date = time or os.time()
		self.dateData = osDate("*t", os.time)
	end,
	clone = function(self)
		return Date(self.date)
	end,
	setTime = function(self, time)
		self.dateData = osDate(" * t", time)
		self.date = time
	end,
	format = function(self, format)
		return osDate(format, self.date)
	end,
	getUnixTimeStamp = function(self)
		return self.date
	end,
	getSeconds = function(self)
		return self.dateData.sec
	end,
	getMinutes = function(self)
		return self.dateData.min
	end,
	getHours = function(self)
		return self.dateData.hour
	end,
	getDays = function(self)
		return self.dateData.yday
	end,
	getYearDay = function(self)
		return self.dateData.day
	end,
	getWeekDay = function(self)
		return self.dateData.wday
	end,
	getMonth = function(self)
		return self.dateData.month
	end,
	getYears = function(self)
		return self.dateData.year
	end,
	getDaylightSaving = function(self)
		return self.dateData.isdst
	end,
	getCentury = function(self)
		return self.dateData.year % 1000
	end,
	getAbbrWeekDayName = function(self)
		return osDate("%a", self.date)
	end,
	getWeekDayName = function(self)
		return osDate("%A", self.date)
	end,
	getAbbrMonthName = function(self)
		return osDate("%b", self.date)
	end,
	getMonthName = function(self)
		return osDate("%B", self.date)
	end,
	getTimeZoneName = function(self)
		return osDate("%Z", self.date)
	end,
	getGMT = function(self)
		return osDate("%a, %d %b %Y %X GMT")
	end,
	getISO8601 = function(self)
		return osDate("%Y-%m-%dT%XZ")
	end
})