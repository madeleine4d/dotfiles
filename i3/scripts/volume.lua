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
function MoveSintksToNewDefault(defaultSink)
	local sinkInput = T.Run("pactl list sink-inputs | grep 'Sink Input #'")
	sinkInput = T.Split(sinkInput, "#")[2]
	sinkInput = T.Split(sinkInput, "\n")[1]
	T.Run(string.format("pactl move-sink-input %s %s", sinkInput, defaultSink))
end

function GetSinks()
	local sinksR = T.Split(T.Run("pactl list sinks |grep Name: "), "\n")
	local sinks = {}
	for i, sink in pairs(sinksR) do
		sink = T.Split(sink, " ")
		table.insert(sinks, sink[2])
	end
	return sinks
end

function GetDefaultSink()
	return T.Split(T.Run("pactl get-default-sink"), "\n")[1]
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
	T.Run("pactl set-default-sink " .. defaultSink)
	MoveSintksToNewDefault(defaultSink)
end

function GetVol()
	local vol = T.Split(T.Run(string.format("pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]\\+'")), "\n")[2]
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

local vol = tonumber(GetVol())

-- handeler
if arg[1] == "1" then
	SwitchToNextAudioDevice()
elseif arg[1] == "up" and vol <= 200 then
	vol = vol + 5
	T.Run(string.format("pactl set-sink-volume @DEFAULT_SINK@ %s%%", tostring(vol)))
elseif arg[1] == "down" and vol >= 0 then
	vol = vol - 5
	T.Run(string.format("pactl set-sink-volume @DEFAULT_SINK@ %s%%", tostring(vol)))
elseif arg[1] == "mute" or arg[1] == "3" then
	T.Run(string.format("pactl set-sink-mute @DEFAULT_SINK@ toggle"))
end

local symbol
if GetMute() then
	symbol = AUDIO_MUTE_SYMBOL
elseif vol > 50 then
	symbol = AUDIO_HIGH_SYMBOL
elseif vol > 10 then
	symbol = AUDIO_MED_SYMBOL
else
	symbol = AUDIO_LOW_SYMBOL
end

local message = symbol .. "  " .. GetVol() .. "%"

print(message)

--\124cffFF0000This text is red\124r
