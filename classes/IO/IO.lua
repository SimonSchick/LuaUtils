local IO

local PrintStream = require("classes.IO.PrintStream")
local FileOutputStream = require("classes.IO.FileOutputStream")
local FileInputStream = require("classes.IO.FileInputStream")

IO = class("IO", {
}, {
	output = PrintStream(FileOutputStream.FromLuaFile(io.stdout)),
	error = PrintStream(FileOutputStream.FromLuaFile(io.stderr)),
	input = FileInputStream.FromLuaFile(io.stdin)
})

return IO