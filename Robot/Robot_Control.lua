local component = require ("component")
local modem = component.modem
local event = require ("event")
local port = 512
local keynumber = 0
modem.open(port)
local keys = {
	[17] = "moveForward", 	--W
	[31] = "moveBack",		--S
	[30] = "moveLeft",		--A
	[32] = "moveRight",		--D
	[42] = "moveDown",		--SHIFT
	[57] = "moveUp",		--SPACE
	[18] = "OTSOS",			--E
	[33] = "VIBROSI",		--F
	[16] = "chopTree",		--Q
	[19] = "checkKey",		--R
	[20] = "activate"		--T
}
function getSignal()
	local e = {event.pull()}
	local _, _, from, port, _, message = event.pull("modem_message")
 	 if keynumber == "modem_message" then
 	 	print("KNOPKA OT ROBOTA:" .. keynumber)
	end
end
	function analyzeSignal()
		if keynumber ~= 0 then
			print("W")
	end
end

 while true do
 	 local e = {event.pull()}
 	 if e[1] == "key_down" then
	if keys[e[4]] then
		print("KOMANDA robotu:" .. keys[e[4]])
		modem.broadcast(port, "ESCrobot" , keys[e[4]])
end
end
end