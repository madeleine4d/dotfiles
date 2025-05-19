T = dofile("/home/maddy/.config/scripts/maddy_tools.lua")

function GetCurrentBrightnes()
	local b = T.Run("brightnessctl --device='tpacpi::kbd_backlight' get")
	return b
end

local currentBrightness = tonumber(GetCurrentBrightnes())

local newBrightness = math.fmod((currentBrightness + 1), 3)

T.Run(string.format("brightnessctl --device='tpacpi::kbd_backlight' set %d", newBrightness))
