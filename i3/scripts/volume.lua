T = dofile("/home/maddy/.config/scripts/maddy_tools.lua")

-- audio symbols
AUDIO_HIGH_SYMBOL = ""
AUDIO_MED_SYMBOL = ""
AUDIO_LOW_SYMBOL = ""

AUDIO_MUTE_SYMBOL = ""

-- audio thresholds
AUDIO_MED_THRESHOLD = 50
AUDIO_LOW_THRESHOLD = 0

DEFAULT_COLOR = "#FEC0CE"
MUTED_COLOR = "A0A0A0"

-- functions
function GetSinks()
	local statusStr = T.Run("wpctl status -n | grep '_output.' |grep 'vol'")
	local statusTable = T.Split(statusStr, "\n")

	local cleanTable = {}

	for i, t in pairs(statusTable) do
		local valueDirty = T.Split(T.Split(t, ".")[1], " ")
		local value = valueDirty[#valueDirty]
		cleanTable[i] = value
	end

	return cleanTable
end

function GetDefaultSink()
	local dirty = T.Split(T.Split(T.Run("wpctl status -n | grep '_output.' |grep '*'"), ".")[1], " ")
	return dirty[#dirty]
end

function SwitchToNextAudioDevice()
	local sinks = GetSinks()
	if #sinks <= 1 then
		return
	end
	local defaultSink = GetDefaultSink()
	local defaultSinkIndex = T.TableInvert(sinks)[defaultSink]
	defaultSinkIndex = (math.fmod((defaultSinkIndex + #sinks), #sinks) + 1)
	defaultSink = sinks[defaultSinkIndex]
	T.Run("wpctl set-default " .. defaultSink)
end

function GetVol()
	local vol = T.Split(T.Run(string.format("wpctl get-volume @DEFAULT_SINK@")), ": ")[2]
	return vol
end

function GetMute()
	local result = T.Split(T.Run("pactl get-sink-mute @DEFAULT_SINK@"), " ")[2]
	if result == "yes\n" then
		return true
	elseif result == "no\n" then
		return false
	end
end

-- handeler
if arg[1] == "1" then
	SwitchToNextAudioDevice()
	T.Run("pkill -RTMIN+1 i3blocks")
end

local vol = tonumber(GetVol())

if arg[1] == "up" and vol <= 2 then
	vol = vol + 0.05
	T.Run(string.format("wpctl set-volume @DEFAULT_SINK@ %s%%", tostring(vol * 100)))
elseif arg[1] == "down" and vol >= 0 then
	vol = vol - 0.05
	T.Run(string.format("wpctl set-volume @DEFAULT_SINK@ %s%%", tostring(vol * 100)))
elseif arg[1] == "mute" or arg[1] == "3" then
	T.Run(string.format("wpctl set-mute @DEFAULT_SINK@ toggle"))
end

local symbol
if GetMute() then
	symbol = AUDIO_MUTE_SYMBOL
elseif vol > 0.5 then
	symbol = AUDIO_HIGH_SYMBOL
elseif vol > 0.1 then
	symbol = AUDIO_MED_SYMBOL
else
	symbol = AUDIO_LOW_SYMBOL
end

local message = symbol .. "  " .. tostring(math.floor(vol * 100)) .. "%"

print(message)

--\124cffFF0000This text is red\124r
