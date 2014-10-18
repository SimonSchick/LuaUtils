local function nest(func, n)
	if n == 1 then
		return func
	end
	return nest(function(...)
		return func(func(...))
	end, n - 1)
end

local function nestList(func, n, list)
	list = list or {}
	table.insert(list, func)
	if n == 1 then
		return func
	end
	nestList(function(...)
		return func(func(...))
	end, n - 1, list)
	return list
end

return {
	nest = nest
}

