T = dofile("/home/maddy/.config/scripts/maddy_tools.lua")

local wallpaper = "~/Wallpapers/chihiro014.jpg"

local monitors = T.Split(T.Run('xrandr -q | grep " connected "'), "\n")
MONITORS = {}
for _, monitor in pairs(monitors) do
	table.insert(MONITORS, T.Split(monitor, " ")[1])
end

T.TableDump(MONITORS)

if #MONITORS == 1 then
	T.Run("xrandr --auto")
	T.Run(string.format("feh --bg-scale %s", wallpaper))
elseif #MONITORS == 2 then
	T.Run("xrandr --auto")
	T.Run(string.format("xrandr --output %s --right-of %s", MONITORS[2], MONITORS[1]))
	T.Run(string.format("feh --bg-scale %s", wallpaper))
end
-- xrandr --output eDP-1 --auto --output DP-2 --right-of eDP-1
