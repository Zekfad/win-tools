
--- Check if a file or directory exists.
--- @param path string Path to check.
function os.exists(path)
	local ok, err, code = os.rename(path, path)
	if not ok then
		if code == 13 then
			return true
		end
	end
	return ok, err
end

--- Check if requested path is a file and can be accessed.
--- @param path string Path to check.
function os.hasAccess(path)
	if os.exists(path) then
		local handle = io.open(path, 'r')
		local result = handle and true or false
		if result then
			io.close(handle)
			return result
		end
	end

	return false
end

--- Get filesize.
--- @return number size
--- @return string handle
function os.filesize(obj)
	local handle

	if io.type(obj) == 'file' then
		handle = obj
	elseif os.hasAccess(obj) then
		handle = io.open(obj, 'r')
	else
		return -1
	end

	local current = handle:seek()
	local size = handle:seek('end')
	handle:seek('set', current)
	return size, handle
end
