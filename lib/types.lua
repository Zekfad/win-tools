--- Count table entries
--- @param T table Table
--- @return number Table entries count
local function tableCount(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

local null = {}

--- This is internal function, just leave it as is.
local function typeCheckSub(allowedTypes, object)
	if type(allowedTypes) ~= 'table' then
		if type(allowedTypes) == 'string' then
			allowedTypes = { allowedTypes, }
		else
			return false
		end
	else
		local isArray = true
		for key in pairs(allowedTypes) do
			if type(key) ~= 'number' then
				isArray = false
			end
		end
		if not isArray then
			local allowedTypesAsArray = {}
			for key,value in pairs(allowedTypes) do
				allowedTypesAsArray[#allowedTypesAsArray + 1] = { [key] = value }
			end
			allowedTypes = allowedTypesAsArray
		end
	end

	local passed = false

	for i, allowedType in ipairs(allowedTypes) do
		if type(allowedType) == 'table' then
			if tableCount(allowedType) == 1 and type(object) == 'table' then
				local subpassed = true
				for allowedKeys, allowedValues in pairs(allowedType) do
					if type(allowedKeys) == 'number' then
						for i, value in ipairs(object) do
							if not typeCheckSub(allowedValues, value) then
								subpassed = false
								break
							end
						end
					else
						for key, value in pairs(object) do
							if not typeCheckSub(allowedKeys, key) or not typeCheckSub(allowedValues, value) then
								subpassed = false
								break
							end
						end
					end
				end
				passed = subpassed
			end
		else
			if allowedType == 'any' then
				passed = true
				break
			end
			if allowedType == nil or allowedType == 'nil_' then
				allowedType = 'nil'
			end
			if object == null then
				object = nil
			end
			if type(object) == allowedType then
				passed = true
				break
			end
		end
	end
	return passed
end

--- Type name
-- @typedef {string} typeCheckTypeName

--- Type defenition
-- This is self-recursive keys and values table
-- @typedef {table.<key, value>} typeCheckTypeDef
-- @property {?typeCheckTypeDef[]|typeCheckTypeName[]} key   Type of table keys, if number or missing, array to check must be number indexed array
-- @property {typeCheckTypeDef[]|typeCheckTypeName[]}  value Type of table values.
-- @example { 'string', 'number' } -- Type for string or number.
-- @example { string = 'string' } -- Type for string-string array
-- @example { string = { { 'string' } } } -- Type for array with string key, and number-string array value.
-- @example { string = { number = 'string' } } -- Type for array with string key, and number-string array value.
-- @example { [{ string = 'number' }] = { 'number', 'string' } } -- Type for array with string-number array key and numbers or strings values.


--- Check types of objects.
-- @param {table.<typeCheckTypeDef[], objectToCheck>} objects Objects to check.
-- @returns {boolean} Whatever all checks are passed.
local function typeCheck(objects)
	if type(objects) ~= 'table' then
		return false
	end

	for allowedTypes, object in pairs(objects) do
		local passed = typeCheckSub(allowedTypes, object)

		if not passed then
			return false
		end
	end

	return true
end

types = {
	check = typeCheck,
	null  = null,
}
