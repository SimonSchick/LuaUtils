local function set(obj, val)
	store[obj] = val
	return obj
end

local function get(obj)
	return store[obj]
end

local function getKey(obj, key)
	return store[obj][key]
end

local function find(key, value)
	local ret = {}
	for obj, annotations in next, store do
		if annotations[key] == value then
			table.insert(ret, obj)
		end
	end
	return ret
end

return {
	set = set,
	get = get,
	getKey = getKey,
	find
}