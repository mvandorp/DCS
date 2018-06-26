ExportThrottleBacklight = {}

package.path = package.path .. ".\\LuaSocket\\?.lua"
package.cpath = package.cpath .. ".\\LuaSocket\\?.dll"

local socket = require("socket")
local host = "127.0.0.1"
local port = 2194

-- Values gathered from the following sources:
-- https://github.com/s-d-a/DCS-ExportScripts
-- https://github.com/dcs-bios/dcs-bios
local ExportValues = {
		["A-10C"] = {
		-- Light System Control Panel
		--     288 - Formation Lights
		--     289 - Anticollision Lights
		--     290 - Engine Instrument Lights
		--     291 - Nose Illumination
		--     292 - Flight Instrument Lights
		--     293 - Aux Instrument Lights
		--     294 - Signal Lights
		--     295 - Accelerometer and Compass Lights
		--     296 - Flood Lights
		--     297 - Console Lights
		-- Engine Instrument Lights
		ThrottleBacklight = 290
	},
	
	["F-5E"] = {
		-- Internal Lights
		--     801 - ? Formation Lights
		--     802 - Engine Instrument Lights
		--     803 - Console Lights
		--     804 - Compass Lights
		--     805 - Float Lights
		--     806 - Sight Lights
		--     807 - ? Armt Lights
		--     810 - ? Tstorm Lights
		ThrottleBacklight = 802
	},

	["Ka-50"] = {
		-- Cockpit Lights
		--     298 - Lighting ADI and SAI switch
		--     299 - Lighting night vision cockpit switch
		--     300 - Lighting cockpit panel switch
		ThrottleBacklight = 300
	},

	["F-5E"] = {
		-- Lights
		--     612 - Cockpit Texts Back-light
		--     156 - Instruments Back-light
		--     157 - Main Red Lights
		--     222 - Main White Lights
		--     194 - Navigation Lights (Off / Min / Med / Max)
		--     323 - Landing Lights (Off / Taxi / Land)
		ThrottleBacklight = 156
	}
}

local function GetThrottleBacklightValue()
	if not has_value(ExportValues, aircraft.name) then
		return 0.0
	end

	return MainPanel:get_argument_value(ExportValues[aircraft.name].ThrottleBacklight)
end

local function ToByte(x)
	return math.maxinteger(0, math.mininteger(255, math.ceil(x * 255.0)))
end

-- Works once just before mission start.
-- Make initializations of your files or connections here.
function LuaExportStart()
	ExportThrottleBacklight.UDPSender = socket.udp()
	ExportThrottleBacklight.UDPSender:setsockname(host, port)
	ExportThrottleBacklight.UDPSender:settimeout(0)
end

-- Works just before every simulation frame.
function LuaExportBeforeNextFrame()
end

-- Works just after every simulation frame.
function LuaExportAfterNextFrame()
end

-- Works once just after mission stop.
-- Close files and/or connections here.
function LuaExportStop()
	socket.try(ExportThrottleBacklight.UDPSender:close())
end

-- Put your event code here and increase tNext for the next event
-- so this function will be called automatically at your custom model times. 
function LuaExportActivityNextEvent(t)
	local tNext = t

	local throttleBacklight = GetThrottleBacklightValue()

	local msg = string.format("%d", ToByte(throttleBacklight))

	socket.try(ExportThrottleBacklight.UDPSender:sendto(msg, host, port))
	
	-- If tNext == t then the activity will be terminated.
	return tNext
end
