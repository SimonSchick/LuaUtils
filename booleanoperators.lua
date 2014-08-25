local booleanMeta = {}
booleanMeta.__index = booleanMeta

local function implication(lhs, rhs)
	return not rhs or lhs
end

booleanMeta.__lt = implication
booleanMeta.__le = implication

booleanMeta.__pow = function(lhs, rhs)
	return (lhs and not rhs) or (not lhs and rhs)
end

booleanMeta.__unm = function(subject) return not subject end