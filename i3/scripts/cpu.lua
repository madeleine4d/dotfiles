T = dofile("/home/maddy/.config/scripts/maddy_tools.lua")

if arg[1] == "1" then
	T.Run("kitty -e btop")
end

local vmstat = T.Run("vmstat 1 2")
vmstat = T.Split(vmstat, "\n")[4]
vmstat = T.Split(vmstat, " ")[15]

print(tostring(100 - tonumber(vmstat)) .. "%")
