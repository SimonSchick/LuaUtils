local meta = {}
meta.__index = meta

debug.setmetatable(function() end, meta)