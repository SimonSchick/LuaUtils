local meta = string

function meta:left(len)
	return self:sub(1, len)
end

function meta:right(len)
	return self:sub(-len)
end

function meta:startsWith(str)
	return self:sub(1, str:len()) == str
end

function meta:endsWith(str)
	return self:sub(-str:len()) == str
end

function string:emplace(at, str)
	return self:sub(1, at - 1) .. str .. self:sub(at + str:len())
end

function meta:insert(at, str)
	return self:sub(1, at - 1) .. str .. self:sub(at)
end

function meta:contains(str)
	return self:find(str, 1, true) ~= nil
end

function meta:explode(delimeter, usePattern)
	if delimeter == "" then 
		return self:toChars()
	end
	 
	local ret = {}
	local index, lastPosition = 1, 1
	 
	if not usePattern then 
		delimeter = delimeter:escapePattern()
	end

	for startPosition, endPosition in self:gmatch("()" .. delimeter .. "()") do
		ret[index] = self:sub(lastPosition, startPosition - 1)
		index = index + 1

		lastPosition = endPosition
	end

	ret[index] = self:sub(lastPosition)
	return ret
end

function meta:split(splitSize)
	local ret = {}
	for i = 1, self:len(), splitSize do
		table.insert(ret, self:sub(i, i + splitSize - 1))
	end
	return ret
end

function meta:escapePattern()
	return self:gsub("([()%.%%%+%-%*%?%[%]%^%$])", "%%%1")
end

function meta:toChars()
	local ret = {}
	for i = 1, self:len() do
		ret[i] = self:sub(i, i)
	end
	return ret
end

function meta:concat(...)
	return table.concat({self, ...})
end

function meta:charAt(i)
	return self:sub(i, i)
end

function meta:findLast(what, startIndex)
	--todo, fix patterns
	
	local findStartIdx, findEndIdx = self:reverse():find(what:reverse(), startIndex or 1, true)
	
	local len = self:len()
	
	return len - findEndIdx + 1, len - findStartIdx + 1
end

function meta:matchAll(pattern)
	local ret = {}
	local iter = self:gmatch(pattern)
	while true do
		local matches = {iter()}
		if #matches == 0 then
			return ret
		end
		table.insert(ret, matches)
	end
end
	
	