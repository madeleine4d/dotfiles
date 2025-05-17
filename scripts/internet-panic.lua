function Run(command)
	local handel = io.popen(command)
	local result = handel:read("*a")
	handel:close()
	return result
end

local status = Run("nmcli radio wifi")
status = status:gsub("%s+", "")

if status == "enabled" then
	Run("nmcli radio all off")
	print(Run("nmcli radio wifi"))
elseif status == "disabled" then
	Run("nmcli radio all on")
	print(Run("nmcli radio wifi"))
end
