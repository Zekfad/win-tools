require 'lib.table'
require 'lib.types'

--- Console object.
console = {}

--- Print data into console.
--- @return boolean
function console.log(...)
	local args = {...}
	for i, v in ipairs(args) do
		io.write(tostring(v) .. ' ')
	end
	io.write('\n')
	return true
end

--- Print data into console without spaces.
--- @return boolean
function console.logRaw(...)
	local args = {...}
	for i, v in ipairs(args) do
		io.write(tostring(v))
	end
	io.write('\n')
	return true
end

--- Print warning into console.
--- @return boolean
function console.warn(...)
	return console.log('W:', ...)
end

--- Print error into console.
--- @return boolean
function console.error(...)
	return console.log('E:', ...)
end

--- Print confirm dialogue into console.
--- @param message string
--- @param variants table
--- @param default integer
function console.confirm(message, variants, default)
	if not types.check({
		[{ 'string', }] = message or types.null,
		[{ { 'string', }, }] = variants or types.null,
		[{ 'number', }] = default or types.null,
	}) then
		return default
	end
	local lowerVariants = {}

	io.write(message, ' [')
	for i, v in ipairs(variants) do
		local variant = tostring(v);
		lowerVariants[i] = string.lower(variant)
		io.write(
			i == default
				and string.upper(variant)
				or variant,
			next(variants, i) ~= nil
				and '/'
				or ''
		)
	end
	io.write('] ')

	local answer = string.lower(io.read())
	local answerIndex = table.indexOf(lowerVariants, answer)

	return answerIndex == -1
		and default
		or answerIndex
end
