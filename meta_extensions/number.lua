local function copyValues(destination, source, keys)
	for k, v in next, keys do
		destination[v] = source[v]
	end
end

local meta = {}
meta.__index = meta

copyValues(meta, math, {
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