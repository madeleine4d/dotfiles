T = dofile("/home/maddy/.config/scripts/maddy_tools.lua")

local bats = T.Split(T.Run("ls /sys/class/power_supply/ | grep -o BAT[0-9]"), "\n")

local stats = {}

local pers = {}

local bs0 = " "
local bs1 = " "
local bs2 = " "
local bs3 = " "
local bs4 = " "
local charging = " "
local discharging = " "
local symbols = {}
local persSum = 0

for i, bat in pairs(bats) do
	local stat = T.Split(T.Run(string.format("cat /sys/class/power_supply/%s/status", bat)), "\n")[1]
	local per = T.Split(T.Run(string.format("cat /sys/class/power_supply/%s/capacity", bat)), "\n")[1]
	table.insert(stats, stat)
	table.insert(pers, per)

	-- set symbols
	if tonumber(pers[i]) > 80 then
		symbols[i] = bs4
	elseif tonumber(pers[i]) > 60 then
		symbols[i] = bs3
	elseif tonumber(pers[i]) > 40 then
		symbols[i] = bs2
	elseif tonumber(pers[i]) > 20 then
		symbols[i] = bs1
	elseif tonumber(pers[i]) > 0 then
		symbols[i] = bs0
	end

	if stats[i] == "Charging" then
		symbols[i] = charging .. symbols[i]
	elseif stats[i] == "Discharging" then
		symbols[i] = discharging .. symbols[i]
	end

	persSum = persSum + tonumber(pers[i])
end

local message = ""
for i, symbol in pairs(symbols) do
	if arg[1] == "1" then
		message = message .. symbol .. " " .. pers[i] .. "% "
	else
		message = message .. " " .. symbol
	end
end

if persSum < 7 then
	T.Run("i3-nagbar -t warning -m 'Battery is critically low. Plug it in!'")
end

print(message)
