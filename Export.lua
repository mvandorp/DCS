local ExportThrottleBacklight = require("ExportThrottleBacklight.lua")

-- Works once just before mission start.
-- Make initializations of your files or connections here.
function LuaExportStart()
	if ExportThrottleBacklight.LuaExportStart then
		ExportThrottleBacklight.LuaExportStart()
	end
end

-- Works just before every simulation frame.
function LuaExportBeforeNextFrame()
	if ExportThrottleBacklight.LuaExportBeforeNextFrame then
		ExportThrottleBacklight.LuaExportBeforeNextFrame()
	end
end

-- Works just after every simulation frame.
function LuaExportAfterNextFrame()
	if ExportThrottleBacklight.LuaExportAfterNextFrame then
		ExportThrottleBacklight.LuaExportAfterNextFrame()
	end
end

-- Works once just after mission stop.
-- Close files and/or connections here.
function LuaExportStop()
	if ExportThrottleBacklight.LuaExportStop then
		ExportThrottleBacklight.LuaExportStop()
	end
end

-- Put your event code here and increase tNext for the next event
-- so this function will be called automatically at your custom model times. 
function LuaExportActivityNextEvent(t)
	local tNext = t

	if ExportThrottleBacklight.LuaExportActivityNextEvent then
		tNext = math.max(tNext, ExportThrottleBacklight.LuaExportActivityNextEvent(t))
	end

	-- If tNext == t then the activity will be terminated.
	return tNext
end
