T = dofile("/home/maddy/.config/scripts/maddy_tools.lua")

Path = "/home/maddy/.config/i3/scripts/time_status"

function Repair()
	print("repairing")
	local new_status = io.open(Path, "w")

	new_status:write("format=long\ntimezone=America/Los_Angeles")
	new_status:close()
end

function Read_status()
	local status = io.open(Path, "r")

	if not status then
		Repair()
	end

	local raw_status = status:read("*all")
	local rules = T.Split(raw_status, "\n")
	local rules_table = {}

	for _, rule in ipairs(rules) do
		rule = T.Split(rule, "=")
		rules_table[rule[1]] = rule[2]
	end

	status:close()

	return rules_table
end

function Switch_format(rules)
	local new_status = io.open(Path, "w")

	if rules["format"] == "long" then
		rules["format"] = "short"
	elseif rules["format"] == "short" then
		rules["format"] = "long"
	end

	new_status:write("format=" .. rules["format"] .. "\ntimezone=" .. rules["timezone"])

	new_status:close()
end

function Update_timezone(rules)
	local IP_timezone = T.Run("curl https://ipapi.co/timezone")

	if #T.Split(IP_timezone, " ") > 1 or rules["format"] == IP_timezone then
		print("err")
		return
	end

	local new_status = io.open(Path, "w")
	new_status:write("format=" .. rules["format"] .. "\ntimezone=" .. IP_timezone)
	new_status:close()
end

local rules = Read_status()

if arg[1] == "1" then
	Switch_format(rules)
	rules = Read_status()
elseif arg[1] == "3" then
	Update_timezone(rules)
	rules = Read_status()
end

if rules["format"] == "long" then
	Time = T.Run("TZ=" .. rules["timezone"] .. " date '+%d %b %H:%M'")
elseif rules["format"] == "short" then
	Time = T.Run("TZ=" .. rules["timezone"] .. " date '+%H:%M:%S'")
end

print(Time)
