local meta = {}
meta.__index = meta

local function implication(lhs, rhs)
	return not rhs or lhs
end

meta.__lt = implication
meta.__le = implication

meta.__pow = function(lhs, rhs)
	return (lhs and not rhs) or (not lhs and rhs)
end

meta.__unm = function(subject) return not subject end

debug.setmetatable(true, meta)