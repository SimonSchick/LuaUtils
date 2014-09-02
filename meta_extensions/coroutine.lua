local meta = {}
meta.__index = meta

meta.resume = coroutine.resume
meta.running = coroutine.running
meta.status = coroutine.status
