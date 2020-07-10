require 'lib.global'

--- Check if we're on Windows
--- @return boolean
function os.isWin32()
	return package.config:sub(1,1) == '\\'
end

--- Check if a file or directory exists.
--- @param path string Path to check.
--- @return boolean
--- @return string
function os.exists(path)
	local ok, err, code = os.rename(path, path)
	if not ok then
		if code == 13 then
			return true, ''
		end
	end
	return ok, err
end


--- Check if provided path is accesible directory.
--- @param path string
--- @return boolean
function os.isDir(path)
	if not os.exists(path) then
		return false
	end
	return toboolean(
		os.execute(
			string.format(
				'cd %s %q > %s 2>&1',
				os.isWin32() and '/D' or '',
				path,
				os.isWin32() and 'nul' or '/dev/null'
			)
		)
	)
end

--- Check if provided path is a file.
--- @param path string
--- @return boolean
function os.isFile(path)
	if not os.exists(path) then
		return false
	end
	return not os.isDir(path)
end

--- Check if requested path is a file and can be accessed.
--- @param path string Path to check.
--- @return boolean
function os.hasAccess(path)
	if os.exists(path) then
		local handle = io.open(path, 'r')
		local result = toboolean(handle)
		io.close(handle)
		if result then
			return true
		end
	end
	return false
end

--- Get filesize.
--- @param file string | any
--- @return number size
function os.filesize(file)
	local revertSeek = io.type(file) == 'file'
	local handle
	if revertSeek then
		handle = file
	elseif os.hasAccess(file) then
		handle = io.open(file, 'r')
	else
		return -1
	end

	local current = handle:seek()
	local size = handle:seek('end')

	if revertSeek then
		handle:seek('set', current)
	else
		io.close(handle)
	end

	return size
end
