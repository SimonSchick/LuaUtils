local type = type

local mlog = math.log
local mfloor = math.floor
local mceil = math.ceil
local msqrt = math.sqrt

local tsort = table.sort
local tinsert = table.insert
local getfenv = getfenv

local dofile = dofile

local print = print

module("math.extended")

--dofile("utilfuncs.lua")

euler = 2.718281828459045

local env = getfenv()

for i = 1, 10 do
	env["sqrt"..i] = msqrt(i)
end

function isIntegral(v)
	return v%1 == 0
end

function getFraction(v)
	return v%1
end

function root(v, base)
	return v^ - base
end

--start = 0
--stop = 1
--step = 0.01
function eval(f, start, stop, step)
	local res = {}
	local idx = 1
	for v = start or 0, stop or 1, step or 0.01 do
		res[idx] = f(idx, v, res)
		idx = idx + 1
	end
	return res
end

--s must be of type number or table
--e must be either a number or a function

function sum(s, e, f)
	local res = 0
	if(type(s) == "table") then
		if(type(e) == "function") then
			for i = 1, #s do
				res = res + e(i, s[i]) 
			end
			return res
		else
			local temp = s
			f = function(i) return temp[i] end
		end
		e = #s
		s = 1
	end
	for i = s, e do
		res = res + f(i) 
	end
	return res
end

--s must be of type number or table
--e must be either a number or a function
function product(s, e, f) 
	local res = 0
	if(type(s) == "table") then
		if(type(e) == "function") then
			for i = 1, #s do
				res = res * e(i, s[i]) 
			end
			return res
		else
			local temp = s
			f = function(i) return temp[i] end
		end
		e = #s
		s = 1
	end
	for i = s, e do
		res = res * f(i) 
	end
	return res
end

function logb(val, base)
	base = base or e
	return mlog(val) / mlog(base)
end

function ld(val)
	return mlog(val) / mlog(2)
end

function faculty(n)
	local res = 1
	for i = 2, n do
		res = res * i
	end
	return res
end
local faculty = faculty

function binomial(n, k)
	return faculty(n) / (faculty(k) * faculty(n - k))
end

function binomial2(n, k)
	return (n ^ k) / faculty(k)
end

function binomial3(n, k)
	if k > n/2 then k = n - k end 
 
	local numer, denom = 1, 1
	for i = 1, k do
		numer = numer * ( n - i + 1 )
		denom = denom * i
	end
	return numer / denom
end

function round(val, decimals)
    local mult = 10 ^ (decimals or 0)
    return mfloor(val * mult + 0.5) / mult
end

function random(min, max)
	return min + (max - min) * random()
end

function lerp(from, to, delta)
	if (delta > 1) then return to end
	if (delta < 0) then return from end
	return from + (to - from) * delta
end

function approach(from, to, delta)
	if from < to then
		return mmin(from + delta, to)
	elseif from > to then
		return mmax(from - delta, to)
	end
	return to
end

function map(val, min, max, newMin, newMax)
	return (val - min) / (max - min) * (newMax - newMin) + newMin
end

function translate(curr, from, to)
	return (curr - from) / (to - from)
end

function clamp(val, min, max)
    if (val < min) then return low end
    if (val > max) then return high end
    return val
end

function ease(fProgress, fEaseIn, fEaseOut) 

	if (fEaseIn == nil) then fEaseIn = 0 end
	if (fEaseOut == nil) then fEaseOut = 1 end

	local fSumEase = fEaseIn + fEaseOut; 

	if( fProgress == 0.0 or fProgress == 1.0 ) then return fProgress end

	if( fSumEase == 0.0 ) then return fProgress end
	if( fSumEase > 1.0 ) then
		fEaseIn = fEaseIn / fSumEase; 
		fEaseOut = fEaseOut / fSumEase; 
	end

	local fProgressCalc = 1.0 / (2.0 - fEaseIn - fEaseOut); 

	if( fProgress < fEaseIn ) then
		return ((fProgressCalc / fEaseIn) * fProgress * fProgress); 
	elseif( fProgress < 1.0 - fEaseOut ) then
		return (fProgressCalc * (2.0 * fProgress - fEaseIn)); 
	else 
		fProgress = 1.0 - fProgress; 
		return (1.0 - (fProgressCalc / fEaseOut) * fProgress * fProgress); 
	end
end

function median(tbl)
	tsort(tbl)
	return tbl[#tbl / 2];
end

function medianB(a, s, e)
	local new={}

	for i = s, e do
		tinsert(new, a[i])
	end
	tsort(new)
	if #new %2 == 0 then return (new[#new / 2] + new[#new / 2+1]) / 2 end
	return new[mceil(#new / 2)]
end

function tableOperation(tbl, func, ...)
	local ret = {}
	for i = 1, #tbl do
		ret[i] = func(tbl[i], ...)
	end
	return ret
end