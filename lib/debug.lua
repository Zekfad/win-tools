
--- Dump table to console
--- @param table table
--- @param depth integer
function dumpTable(table, depth)
	if (not depth) then
		depth = 1
	end
	if (depth > 200) then
		print("Error: Depth > 200 in dumpTable()")
		return
	end
	for k,v in pairs(table) do
		if (type(v) == "table") then
			print(string.rep(" ", depth)..k..":")
			dumpTable(v, depth+1)
		else
			print(string.rep(" ", depth)..k..": ",v)
		end
	end
end

--- Sleep n seconds.
--- @param n number
--- @return boolean
function sleep(n)
	local startTime = os.clock()
	while os.clock() - startTime <= n do end
	return true
end
