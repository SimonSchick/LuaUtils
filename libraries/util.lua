local tconcat = table.concat
local tremove = table.remove
local sformat = string.format

local next = next
local type = type
local error = error

local dgetlocal = debug.getlocal

local dgetinfo = debug.getinfo

local util = {}

function util.fassert(cond, lvl, format, ...)
	if not cond then
		if not format then
			error("assertion failed!")
		end
		error(sformat(format, ...), lvl+1)
	end
	return cond
end

function util.assertArg(arg, t, ind)
	local t2 = type(arg)
	util.fassert(t == t2, 3, "bad argument #%i to '?' (%s expected, got %s)", ind, t, t2)
end

function util.assertArgLevel(arg, t, lvl, ind)
	local t2 = type(arg)
	util.fassert(t == t2, lvl+1, "bad argument #%i to '?' (%s expected, got %s)", ind, t, t2)
end

function util.assertMultiArgLevel(arg, lvl, ind, ...)
	local t2 = type(arg)
	util.fassert(t == t2, lvl+1, "bad argument #%i to '?' (%s expected, got %s)", ind, tconcat({...}, " or "), t2)
end

function util.ferror(str, level, ...)
	error(sformat(str, ...), level+1)
end

function util.testArguments(func)
	local ret = {}
	local info = debug.getinfo(func)
	if info.isvararg then
		return {"..."}
	elseif info.source == "[C]" then
		return {}
	end
	for i = 1, 200 do
		local k = dgetlocal(2, i)
		if not k then
			return ret
		end
		if k ~= "(*temporary)" then
			ret[#ret+1] = k
		end
	end
	return ret
end

function util.fetchLocals(levelOffset)
	local level = levelOffset or 2
	repeat
		for localIdx = 1, 0x255 do
			local k, v = debug.getlocal(level, localIdx)
			if not k then
				break
			end
		end
		level = level + 1
	until not debug.getinfo(level)
end

return util