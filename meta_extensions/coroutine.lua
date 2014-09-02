local coroutinecreate = coroutine.create
local coroutineyield = coroutine.yield
local coroutineresume = 
local coroutinestatus = coroutine.status
local coroutinerunning = coroutine.running

local meta = {}
meta.__index = meta

meta.resume = coroutine.resume
meta.running = coroutine.running
meta.status = coroutine.status
