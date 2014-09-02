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

function util.tableCopy(dest, src)
	for k, v in next, src do
		dest[k] = v
	end
end

function util.tableCopyNoOverride(dest, src)
	for k, v in next, src do
		if not curr[k] then
			dest[k] = v
		end
	end
end

function util.tableCount(tbl)
	local i = 0
	for _ in next, tbl do
		i = i + 1
	end
	return i
end

function util.substractTable(curr, rem)
	for k, v in next, rem do
		curr[k] = nil
	end
end

function util.removeKeyByValue(tbl, val)
	for k, v in next, tbl do
		if val == v then
			tremove(tbl, k)
			return true
		end
	end
	return false
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

return util