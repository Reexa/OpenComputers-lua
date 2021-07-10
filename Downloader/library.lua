
LibraryOptions = {}
Control = {}
local component = require "component"
local modem = component.modem
local serialization = require"serialization"
local thread = require"thread"
local computer = require"computer"
local filesystem = require"filesystem"
local event = require "event"
function sendFileToServer(dataString, pathToSave)
 local filePath,dataString = read(file)
modem.send(variableCurrentAddress, port, "receiveFile")--begin
modem.send(variableCurrentAddress, port, pathToSave) --path
os.sleep(0.5)
modem.send(variableCurrentAddress, port, dataString) --data
end

function connect()
	addresses = {}
	local addressesCount = 1
	modem.broadcast(port, "connect")
	for i = 0, 10,1 do 
		local _, _, from, _, _, _ = event.pull(1, "modem_message") --pull with timeout of 1 second(listen for 10 times)
	
	if from ~= nil then
	print(from)

	addresses[addressesCount] = from
	print(addressesCount)
	addressesCount = addressesCount+1
	return addresses[1]
else 
	break
	print("nil address")
end end end

function currentAddress()
	local counter = 1
		for addressesCount = 0, 10, 1 do
			if addresses[addressesCount] ~=nil then
	print(counter..'.'..addresses[addressesCount])
	counter = counter +1
 			else
 	break end end
 	print ("choose address")
 	while true do
	 local e = {event.pull()}
 	 if e[1] == "key_down" then
			local currentPosition = tonumber((e[4]-1))
		 CA = addresses[currentPosition]
		print(currentPosition)
	if (CA ~= nil) then
	print("your chose: "..currentPosition..'.'..CA)
	break
	else print("wrong position")
    end end
end 
 	return CA
end 

function LibraryOptions.communicateWithServer()

	modem.send(variableCurrentAddress, port, (io.read()))
	repeat
	local _, _, from, port, _, message = event.pull("modem_message")
	print("Got a message from " .. from .. " on port " .. port .. ": " .. tostring(message))
until message == "end" 
print ("end of cicle")
end 

function chose(key)
if key ~= nil then
return Control[key]

end
	end

function LibraryOptions.sendData(addr,port, data, opt, path,fileName)
	if(not opt) then
		modem.send(addr, port, data)
	elseif(opt == "command") then
		modem.send(addr, port, data)
	elseif(opt == "file") then
		modem.send(addr, port, path)
		os.sleep(0.5)
		modem.send(addr, port, fileName)
		os.sleep(0.5)
		modem.send(addr, port, data)
	end
end

function sendCommand(comname)

	modem.send(variableCurrentAddress, port, comname)

end