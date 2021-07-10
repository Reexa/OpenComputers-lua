local component = require "component"
local serialization = require"serialization"
local thread = require"thread"
local computer = require"computer"
local filesystem = require"filesystem"
local modem = component.modem
local gpu = component.gpu
local port = 512
local event = require "event"
local modemAddress = component.modem.address
local eeprom = component.eeprom
local w, h = gpu.getResolution()

local function prepairing()
gpu.setBackground(0x0000FF)
	gpu.setForeground(0xFF0000)
	
	 if (gpu.fill(1, 1, w, h, " ")) == true then
	 	isPrepareFinished = true
	return isPrepareFinished
else 
	isPrepareFinished = false
	return isPrepareFinished
end
	end

	local function LoadScreen(prepareFinished)
		if prepareFinished == true then 
			gpu.setBackground(0x787878) -- gray
			gpu.set( (w), (h), " ")
			gpu.setForeground(0xFFFFFF) -- white
			gpu.set( (w/2-2), (h/2-2), "Play")
		end
	end

	function touch()
		 eventName, screenAddress, coordX, coordY = event.pull("touch")
		return {eventName = eventName, screenAddress = screenAddress, coordX = coordX,  coordY = coordY}
	end
	--------------------------------------------------------------------------------------------|
	LoadScreen(prepairing())
	print(touch()["eventName"])
	--------------------------------------------------------------------------------------------|
