local meta = string

function meta:left(len)
	return self:sub(1, len)
end

function meta:right(len)
	return self:sub(-len)
end

function meta:startsWith(str)
	return self:sub(1, #str) == str
end

function meta:endsWith(str)
	return self:sub(-#str) == str
end

function string:emplace(at, str)
	return self:sub(1, at - 1) .. str .. self:sub(at + #str)
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
	for i = 1, #self, splitSize do
		table.insert(ret, self:sub(i, i + splitSize - 1))
	end
	return ret
end

function meta:escapePattern()
	return self:gsub("([()%.%%%+%-%*%?%[%]%^%$])", "%%%1")
end

function meta:toChars()
	local ret = {}
	for i = 1, #self do
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
	
	local len = #self
	
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

function meta:capitalize()
	return self:sub(1, 1):upper() .. self:sub(2)
end

function meta:chars(startPos, endPos)
	startPos = startPos or 1
	endPos = endPos or #self
	
	local i = startPos - 1
	
	return function()
		i = i + 1
		if i > endPos then
			return
		end
		return self:sub(i, i), i
	end
end

function meta:bytes(startPos, endPos)
	startPos = startPos or 1
	endPos = endPos or #self
	
	local i = startPos - 1
	
	return function()
		i = i + 1
		if i > endPos then
			return
		end
		return self:sub(i, i):byte(), i
	end
end

function meta:trimWhitespaces()
	return self:gsub("^%s+(.-)%s+$", "%1")
end

function meta:isEmpty()
	return self == ""
end

local bxor = bit.bxor

function meta:xor(other)
	local ret = {}
	local otherLen = #other
	for byte, idx in self:bytes() do
		ret[idx] = string.char(bxor(byte, other:byte(idx > otherLen and idx % otherLen + 1 or idx)))
	end
	return table.concat(ret)
end

function meta:findSequence(callback, startPos, endPos)
	local length = 0
	local sequenceStart = 0
	local sequence = {}
	for char, idx in self:chars(startPos, endPos) do
		local ok, finish = callback(char, idx, length, sequence)
		if finish then
			return idx - length + 1, length, table.concat(sequence)
		end
		if ok then
			length = length + 1
			table.insert(sequence, char)
		else
			length = 0
			sequence = {}
		end
	end
	return nil, nil, {}
end

function meta:count(what, usePattern)
	local count = 0
	local startPos, endPos = 0, 0
	while true do
		startPos, endPos = self:find(what, startPos, not usePattern)
		if not startPos then
			return count
		else
			count = count + 1
		end
	end
	return count
end