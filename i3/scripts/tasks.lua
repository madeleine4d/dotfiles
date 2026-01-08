T = dofile("/home/maddy/.config/scripts/maddy_tools.lua")
JSON = require("cjson")

function GetPastDates(int)
	local dates = {}
	local i = 0
	while i < int do
		dates[i] = os.date("%Y-%m-%d", os.time() - i * 60 * 60 * 24)
		i = i + 1
	end
	return dates
end

function IsPast(date)
	local elements = T.Split(date, "-")
	if elements[1] < os.date("%Y") then
		return true
	elseif elements[1] == os.date("%Y") and elements[2] < os.date("%m") then
		return true
	elseif elements[1] == os.date("%Y") and elements[2] == os.date("%m") and elements[3] < os.date("%d") then
		return true
	end
	return false
end

local file = io.open("/home/maddy/.config/todui/tasks.json", "r")

local tests = JSON.decode(file:read("*a"))
file:close()

local dates = GetPastDates(10)
local count = 0
local color = "#FEC0CE"

for _, v in pairs(tests) do
	if T.Includes(v["date"]:sub(1, 10), dates) and not v["complete"] then
		count = count + 1
	end

	if IsPast(v["date"]:sub(1, 10)) and not v["complete"] then
		color = "#ff393d"
	end
end

print('<span foreground="' .. color .. '"> ' .. tostring(count) .. "</span>")
