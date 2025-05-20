T = dofile("/home/maddy/.config/scripts/maddy_tools.lua")

local symbols = { "  ", "  ", "  ", "  ", "  ", "  ", "  " }

local weather = T.Split(T.Run("curl -Ss 'v1.wttr.in?m&format=%C\\n%t'"), "\n")

local message

if weather[1] == "Cloudy" then
	message = symbols[4] .. weather[2]
elseif weather[1] == "Sunny" then
	message = symbols[3] .. weather[2]
elseif weather[1] == "Partly cloudy" then
	message = symbols[2] .. weather[2]
elseif weather[1] == "Rain" or weather[1] == "Patchy rain" then
	message = symbols[5] .. weather[2]
elseif weather[1] == "Snow" then
	message = symbols[6] .. weather[2]
elseif weather[1] == "Hail" then
	message = symbols[7] .. weather[2]
elseif weather[1] == "Fog" or weather[1] == "Mist" then
	message = symbols[1] .. weather[2]
else
	message = weather[1] .. " " .. weather[#weather]
end

if arg[1] == "1" then
	T.Run(
		'kitty --hold curl -Ss "v1.wttr.in?m&format=%l\\n%c%t/%f+%h+%w\\nRain:+%p\\nUV:+%u\\nSun+Set:+%s\\nMoon:+%m+day+%M\\n" "v1.wttr.in?m&1&F&Q"'
	)
end

print(message)
