require 'lib.class'
require 'lib.console'

Progress = Class:new()

function Progress:__new(opsCount)
	self:setOpsCount(opsCount)
	self:setCurrent(0)
end

function Progress:setOpsCount(newOpsCount)
	self.__opsCount = newOpsCount
	return true
end

function Progress:setCurrent(newCurrent)
	self.__current = newCurrent
	return true
end

function Progress:increase(increaseTo)
	if not increaseTo then increaseTo = 1 end
	self:setCurrent(self.__current + increaseTo)
	return true
end

function Progress:get(format)
	if not format then format = '%wp' end

	if ((format == '%') or
		(format == 'percentage')) then
		return string.format('%6.2f', self.__current / self.__opsCount * 100) .. '%'
	elseif ((format == "%wp") or
			(format == "percentage without padding")) then
		return string.format('%0.2f', self.__current / self.__opsCount * 100) .. '%'
	elseif ((format == "%f") or
			(format == "percentage float")) then
		return self.__current / self.__opsCount * 100
	elseif ((format == "as") or
			(format == "as string")) then
		return string.format('%6s/%-6s', self.__current, self.__opsCount)
	elseif ((format == "aswp") or
			(format == "as string without padding")) then
		return string.format('%s/%s', self.__current, self.__opsCount)
	else
		return self.__current / self.__opsCount
	end
end

function Progress:drawBars(bars)
	if not bars then bars = 50 end
	local barsShowed = math.floor(bars * (math.floor(self:get('%f')) / 100))
	if self.__lastBarsShowed ~= barsShowed then
		console.logRaw(
			self.__current ~= 0
				and '\x1b[1A' .. '\x1b[2K'
				or '',
			self:get('%'),
			' [',
			string.rep('#', barsShowed),
			string.rep('-', bars - barsShowed),
			']'
		)
	end
	self.__lastBarsShowed = barsShowed
end
