require 'lib.global'
require 'lib.types'

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
	if not types.check({
		[{ 'string', }] = path or types.null,
	}) then
		return false, 'ERR_NO_PATH'
	end
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
		if result then
			io.close(handle)
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

--- Get directory listening.
--- Returns table with following fields:
--- ```lua
--- { name = string, type = number, size = number }
--- ```
--- @param path string
--- @return thread
function os.getDirAsync(path)
	local function handler(path)
		if os.isDir(path) then
			local pipe = io.popen(
				string.format(
					'dir %s %q',
					os.isWin32()
						and '/B /A'
						or '-bA1',
					path
				),
				'r'
			)
			for object in pipe:lines() do
				if not (object == '.' or object == '..') then
					local objectPath = path .. '/' .. object
					local size = os.filesize(objectPath)

					coroutine.yield({
						name = object,
						size = size,
						type = size ~= -1
							and 0
							or 1,
					})
				end
			end

			pipe:close()
		end
		return
	end
	return coroutine.create(handler)
end

--- Get directory listening.
--- Returns table with subtables with following format:
--- ```lua
--- { name = string, type = number, size = number }
--- ```
--- @param path string
--- @return table
function os.getDirSync(path)
	local handler = os.getDirAsync(path)
	local dir = {}
	while coroutine.status(handler) ~= 'dead' do
		local status, entry = coroutine.resume(handler, path)
		table.insert(dir, entry)
	end
	return dir
end
