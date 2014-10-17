local function forEach(tbl, func)
	for k, v in next, tbl do
		func(k, v)
	end
end

local function fill(tbl, val, startIndex, endIndex)
	if startIndex then
	
		if startIndex < 0 then
			startIndex = len - startIndex
		end
		
		if endIndex and endIndex < 0 then
			endIndex = len - endIndex
		end
	
		for i = startIndex, endIndex or #tbl do
			tbl[i] = val
		end
		return
	end
	for k, v in next, tbl do
		tbl[k] = val
	end
end

local function isSequential(tbl)
	local numericKeys = 0
	local tblLen = #tbl
	for k, v in next, tbl do
		numericKeys = numericKeys + 1
		if numericKeys > tblLen then
			return false
		end
	end
	return true
end

local function filter(tbl, func--[[
, createNew]])
	--local target = createNew and {} or tbl
	if isSequential(tbl) then
		local i = 1
		while i <= len do
			if not func(i, tbl[i]) then
				table.remove(tbl, i)
			else
				i = i + 1
			end
		end
		return
	end
	for k, v in next, tbl do
		if not func(k, v) then
			tbl[k] = nil
		end
	end
end

local function find(tbl, func)
	if isSequential(tbl) then
		for i = 1, #tbl do
			if func(i, tbl[i]) then
				return i, tbl[i]
			end
		end
		return
	end
	for k, v in next, tbl do
		if func(k, v) then
			return k, v
		end
	end
end

local function indexOf(tbl, val)
	return (find(tbl, function(k, v)
		if v == val then
			return k
		end
	end))
end

local function keys(tbl)
	local ret = {}
	for k in next, tbl do
		table.insert(ret, k)
	end
	return ret
end

local function values(tbl)
	local ret = {}
	for k, v in next, tbl do
		table.insert(ret, v)
	end
	return ret
end

local function map(tbl, func)
	for k, v in next, tbl do
		local val = func(k, v)
		if val then
			tbl[k] = v
		end
	end
end

local function reduce(tbl, func, init)
	local curr = init
	if isSequential(tbl) then
		for i = 1, #tbl do
			curr = func(i, tbl[i], curr)
		end
		return curr
	end
	for k, v in next, tbl do
		curr = func(k, v, curr)
	end
end

local function reduceRight(tbl, func, init)
	if not isSequential(tbl) then
		error("Table is not sequential")
	end
	for i = #tbl, 1, -1 do
		curr = func(i, tbl[i], curr)
	end
end

local function reverse(tbl)
	if not isSequential(tbl) then
		error("Table is not sequential")
	end
	local len = #tbl
	for i = 1, len/2 do
		tbl[i] = tbl[len - i + 1]
	end
end

local function shift(tbl)
	return table.remove(tbl, 1)
end

local function slice(tbl, startIndex, endIndex)
	if not isSequential(tbl) then
		error("Table is not sequential")
	end
	local len = #tbl
	
	startIndex = startIndex or 1
	endIndex = endIndex or len
	
	if startIndex < 0 then
		startIndex = len - startIndex
	end
	
	if endIndex < 0 then
		endIndex = len - endIndex
	end
	
	local ret = {}
	for i = startIndex or 1, endIndex or len do
		table.insert(ret, tbl[i])
	end
end

local function any(tbl, func)
	local k, v = find(tbl, func)
	if k then
		return true, k, v
	end
	return false
end

local function test(tbl, func)
	local k, v = find(tbl, function(k, v)
		if not func(k, v) then
			return k, v
		end
	end)
	if k then
		return false, k, v
	end
	return true
end

local function unshift(tbl)
	table.insert(tbl, 1)
end

local function removeKeysByValue(tbl, key)
	if isSequential(tbl) then
		local len = #tbl
		local i = 1
		while i <= len do
			if tbl[i] == key then
				table.remove(tbl, key)
			else
				i = i + 1
			end
		end
		return
	end
	for k, v in next, tbl do
		if k == key then
			tbl[k] = nil
		end
	end
end

local function count(tbl)
	local c = 0
	for k, v in next, tbl do
		c = c + 1
	end
	return c
end

local function copy(dest, source)
	if not source then
		source = dest
		dest = {}
	end
	for k, v in next, source do
		dest[k] = v
	end
	return dest
end

local function copyNoOverride(dest, source)
	for k, v in next, source do
		if not dest[k] then
			dest[k] = v
		end
	end
end

local function isEmpty(tbl)
	return not next(tbl)
end

local weakKeyMT = {__mode = "k"}
local weakValueMT = {__mode = "v"}
local weakKeyValueMT = {__mode = "kv"}

local function weakKeyTable()
	return setmetatable({}, weakKeyMT)
end

local function weakValueTable()
	return setmetatable({}, weakValueMT)
end

local function weakKeyValueTable()
	return setmetatable({}, weakKeyValueMT)
end

local function swap(tbl)
	local ret = {}
	for k, v in next, tbl do
		ret[v] = k
	end
	return ret
end

local function sorted(tbl, descending, sortByValue, secondarySort)
	local data = sortByValue and values(tbl) or keys(tbl)
	local lookupMap = sortByValue and swap(tbl) or tbl
	if secondarySort then
		table.sort(data, descending and function(a, b) return lookupMap[a] > lookupMap[b] end or function(a, b) return lookupMap[a] < lookupMap[b] end)
	end
	table.sort(data, descending and function(a, b) return a > b end or nil)

	local i = 1
	if sortByValue then
		return function()
			local v = data[i]
			i = i + 1
			return lookupMap[v], v
		end
	else
		return function()
			local k = data[i]
			i = i + 1
			return k, lookupMap[k]
		end
	end
end

local function compare(tbl1, tbl2)
	for k, v in next, tbl1 do
		if v ~= tbl2[k] then
			return false
		end
	end
	for k, v in next, tbl2 do
		if v ~= tbl1[k] then
			return false
		end
	end
	return true
end

local function diff(tbl1, tbl2)
	local added, missing, changed = {}, {}, {}
	for k, v in next, tbl1 do
		if not tbl2[k] then
			missing[k] = v
		end
		if v ~= tbl2[k] then
			changed[k] = v
		end
	end
	for k, v in next, tbl2 do
		if not tbl1[k] then
			added[k] = v
		end
	end
	return added, missing, changed
end
	

return {
	forEach = forEach,
	test = test,
	fill = fill,
	isSequential = isSequential,
	filter = filter,
	find = find,
	indexOf = indexOf,
	keys = keys,
	values = values,
	map = map,
	reduce = reduce,
	reduceRight = reduceRight,
	reverse = reverse,
	shift = shift,
	slice = slice,
	any = any,
	unshift = unshift,
	removeKeysByValue = removeKeysByValue,
	count = count,
	copy = copy,
	copyNoOverride = copyNoOverride,
	isEmpty = isEmpty,
	weakKeyTable = weakKeyTable,
	weakValueTable = weakValueTable,
	weakKeyValueTable = weakKeyValueTable,
	swap = swap,
	sorted = sorted,
	compare = compare,
	diff = diff
}