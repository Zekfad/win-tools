--[[
	Fill file with zeroes.

	v1.0.0
	https://github.com/Zekfad/win-tools
	ISC Licensed
]]

require 'lib.os';
require 'lib.console';
require 'lib.progress'

local filename = arg[1];

if not filename then
	console.error 'Filename is missing.'
	os.exit(1)
end

if not os.exists(filename) then
	console.error 'File doesn\'t exist.'
	os.exit(1)
end

if not os.hasAccess(filename) then
	console.error 'File is inaccessible.'
	os.exit(1)
end

local file = io.open(filename, 'r+')
local size = os.filesize(file)

console.log('You\'re gonna zero file "' .. filename .. '"');
console.log('Size is ' .. size .. ' bytes')

if console.confirm('Are you sure?', { 'y', 'n', }, 2) ~= 1 then
	console.log 'Aborted'
	os.exit()
end

console.log 'Zeroing file...'

local progress = Progress:new(size)

for i = 0, size - 1 do
	file:seek('set', i)
	file:write('\0')

	progress:increase()
	progress:drawBars()
end

console.log 'Done.'
