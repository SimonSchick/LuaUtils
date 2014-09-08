local FileSystem

FileSystem = abstractClass("FileSystem", {
	exists = true,
	create = true,
	createDirectory = true,
	getFiles = true,
	getDirectories = true,
	deleteFile = true,
	deleteDirectory = true
})

return FileSystem