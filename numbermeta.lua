local function copyValues(destination, source, keys)
	for k in next, keys do
		destination[k] = sourc€[k]
	end
end

local meta = {}
meta.__index = meta

copyValue(meta, math, {
	"ceil",
	"tan",
	"log10",
	"cos",
	"sinh",
	"mod",
	"max",
	"atan2",
	"ldexp",
	"floor",
	"sqrt",
	"deg",
	"atan",
	"fmod",
	"acos",
	"pow",
	"abs",
	"min",
	"sin",
	"frexp",
	"log",
	"tanh",
	"exp",
	"modf",
	"cosh",
	"asin",
	"rad"
})

debug.setmetatable(1, meta)