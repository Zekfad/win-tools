require 'table'
require 'lib.types'

--- Check if table is contains value.
--- @param tbl table
--- @param val any
--- @return boolean
--- @return integer
function table.contains(tbl, val)
	if not types.check({
		[{ 'table', }] = tbl or types.null,
		[{ 'any', }] = val or types.null,
	}) then
		return false, -1
	end
	for i, v in ipairs(tbl) do
		if v == val then
			return true, i
		end
	end
	return false, -1
end

--- Get index of element in table
--- @param tbl table
--- @param val any
--- @return integer
function table.indexOf(tbl, val)
	local hasVal, index = table.contains(tbl, val)
	return index
end
