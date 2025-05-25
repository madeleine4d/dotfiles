JSON = require("JSON")

function TableLength(table)
	local count = 0
	for _ in pairs(table) do
		count = count + 1
	end
	return count
end

function Run(command)
	local handel = io.popen(command)
	local result = handel:read("*a")
	handel:close()
	return result
end

function GetDriveList()
	local drivesJSON, _ = Run("lsblk --json")
	local drivesTable = JSON:decode(drivesJSON)
	local drives = {}

	for i = 1, TableLength(drivesTable["blockdevices"]), 1 do
		table.insert(drives, drivesTable["blockdevices"][i]["name"])
	end

	return drives
end

local drives = GetDriveList()

for i = 1, #drives, 1 do
	Run("udisksctl mount -p /dev/" .. drives[i] .. "p1")
	print(drives[i] .. "p1 mount attempted\n")
end
