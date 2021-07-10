local component = require "component"
local serialization = require"serialization"
local thread = require"thread"
local computer = require"computer"
local filesystem = require"filesystem"
local modem = component.modem
local gpu = component.gpu
local event = require "event"
local modemAddress = component.modem.address
local eeprom = component.eeprom
local w, h = gpu.getResolution()
local eepromSize = nil
local isPrepareFinished = false

port = 512
robotPort = 1024

if (filesystem.exists("library.lua")) then
	local libraryExist = true
	library = loadfile "library.lua"
end
if (filesystem.exists("gui.lua")) then
	local guiExist = true
 	gui = loadfile("gui.lua")
end
--local farm = require("farm")
--config values
local connectingToServer = false
local keys = {
	[17] = "moveForward", 	--W
	[31] = "moveBack",		--S
	[30] = "moveLeft",		--A
	[32] = "moveRight",		--D
	[42] = "moveDown",		--SHIFT
	[57] = "moveUp",		--SPACE
	[18] = "OTSOS",			--E
	[33] = "VIBROSI",		--F
	[16] = "analyze",		--Q
	[19] = "checkKey",		--R
	[20] = "activate",		--T
	[51] = "end",			--,
	[52] = "analyze",		--.
	[53] = "maketunnel"		--/
}
Colors = {Black = 0x000000, White = 0xFFFFFF, Red = 0xFF0000, Green = 0x00FF00, Blue = 0x0000FF, Yellow = 0xFFDB00}
local addresses = {}
local Options = {Server = {}}
local Figures = {}


	modem.open(port)
	modem.open(robotPort)

function Options.communicateWithServer()

	modem.send(variableCurrentAddress, port, (io.read()))
	repeat
	local _, _, from, port, _, message = event.pull("modem_message")
	print("message from " .. from .. " port " .. port .. ": " .. tostring(message))
until message == "end"
print ("close server connection")
end

function countMemory()
	print(computer.freeMemory() .. '/' .. computer.totalMemory())
end

function Options.ShowDEBUGInfo()
	gpu.setBackground(Colors.Yellow)
gpu.fill(140, 0, w, h, " ")
	gpu.setForeground(Colors.Black)
gpu.set(140, 4,tostring(computer.freeMemory() .. '/' .. computer.totalMemory()))
end

function prepare()

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

function test(isPrepareFinished)
		local eepromLabel = "eepromLabel"
		local  eepromByteArray = "eepromByteArray"
		local eepromSize = "eepromSize"
		local eepromDataSize = "eepromDataSize"
		local eepromChecksum = "eepromChecksum"
		EEPROMdata = {
		[eepromLabel] = eeprom.getLabel(),
		[eepromByteArray] = eeprom.get(),
		[eepromSize] = eeprom.getSize(),
		[eepromDataSize] = eeprom.getDataSize(),
		--[eepromChecksum] = eeprom.getChecksum()
	}
		local fileWriteName = "/home/eepromInfo"
		print("label of the eeprom: "..EEPROMdata[eepromLabel])
		print("size the eeprom: "..EEPROMdata[eepromSize])
		print("dataSize the eeprom: "..EEPROMdata[eepromDataSize])
		--print("checksum the eeprom: "..EEPROMdata[eepromChecksum])
		print("send the log on server?[Y\\N]")
		if ((io.read() or "n").."y"):match("^%s*[Yy]") then
    print("\nSending!\n") 
    print("enter a name of file to send")
local fileString = serialization.serialize(EEPROMdata)
--if (modem.send(variableCurrentAddress, port, fileString)) ==true then
	sendToServer(fileString, io.read())
	print("file has been successfully sended"..fileString)

end
	end

	function read(filePath)
local fileRead = {"data"}
local Path = ""
local data = ""
table.insert(fileRead,(io.open(filePath, "rb")))
--fileRead[Path] = io.open(filePath, "rb")
fileRead[data] = fileRead[2]:read("*a")
print(fileRead[data])
local fileString = serialization.serialize(fileRead[data])	
return {filePath,fileString}
end

	function writeInEEPROM(byteArray)
		eeprom.set(byteArray)
end

function Options.cleanup()
	local previosBackground = gpu.setBackground(0x000000) 
	 gpu.fill(1, 1, w, h, " ")
	 print(previosBackground)
end

function sendToServer(file, pathToSave)
	modem.send(variableCurrentAddress, port, "receiveFile")--begin
	modem.send(variableCurrentAddress, port, pathToSave) --path
	os.sleep(0.5)
	modem.send(variableCurrentAddress, port, file) --data
end
--[[function options()
while true do
	 local e = {event.pull()}
 	 if e[1] == "key_down" then
			local currentOption = tonumber((e[4] -1))
end]]--

local function robotControl()
	--modem.open(robotPort)
	modem.broadcast(robotPort, "remoteControl")
while true do
 	 local e = {event.pull()}
 	if e[1] == "key_down" then
 		if keys[e[4]] ~= nil then
			if keys[e[4]] ~= "end" then
		print(keys[e[4]])
		modem.broadcast(robotPort, keys[e[4]])
			else modem.broadcast(robotPort, "end") break
			end
		end
	else if e[1] == "touch" then
		local _, _, x, y, button, playerName = event.pull()
		if button == 0 then
		modem.broadcast(robotPort, "swing")
	else if button == 1 then
		modem.broadcast(robotPort, "use")
	end end end end
end
end

local function robotOSControl()
	while true do
	local OsControlSignal = io.read()
	if OsControlSignal == "end" then 
	break
else
	modem.broadcast(robotPort, OsControlSignal)
end end end

local function robotAlgorithm()
	modem.broadcast(robotPort, "algorithmControl")
while true do
	local OsAlgorithmSignal = io.read()
	if OsAlgorithmSignal == "end" then 
	break
else
	modem.broadcast(robotPort, OsAlgorithmSignal)
end end end

local function maketunnel()
	modem.broadcast(robotPort, "maketunnel")
end
local function senddig()
	modem.broadcast(robotPort, "dig")
	end
local function mRecord()
	local endRec = false
	while not endRec do
		local e = {event.pull()}
	 	if e[1] == "key_down" then
	 		if e[3] ~= nil then
	 			print(e[3] .. "->key pressed\t" .. e[4] .."->is code")
				if e[3] ~= keyboard.keys.numpad0 then
					print("\n do you want to associadethis button with some robot operation?[Y\\N]")
					if ((io.read() or "n").."y"):match("^%s*[Yy]") then
						print("\nwhat operation must robot on this button?")
						local strRobOp = io.read()
							if strRobOp ~= nil then 
								for k, v in keys do
									if keys[k] == strRobOp then
										--перезапись таблицы по ключу
										keys[k] = nil
										keys[e[3]] = strRobOp
								end
							end
						else
							print("\nyou don't enter the string. returning...")
							return
						end
					end
				else
				print("\n record interrupted. exiting")
				return
				end
			end
		end
	end
end

Colors = {}
Colors.blue = 0x3349FF
Colors.yellow = 0xFF00DB
local function makeButton(x1, y1, x2, y2)
--button 2x and 1 y make rectangle button are равносторонний блять
--мине пихуй я з донбассу
	while true do
		local lastColor = gpu.setBackground(0x5a5a5a)
		gpu.fill(x1,y1,x2,y2," ")
		gpu.setBackground(lastColor)
		local _, _, X, Y, button, playerName = event.pull()
		if(button == 0 and X>=x1 and X<=x2 and Y>=y1 and Y<=y2) then
			--action
		end
	end

end
local JJ = thread.create(function()
	while true do
	local _,_,x,y,button = event.pull()
	if (button == 0) then
		makeButton(x,y, x+4, y+2)
	end
end
end):detach()

function makeContext(x1,y1)

	gpu.setBackground(0x787878)
	gpu.fill()

end

function colorprint(text, color)
	local lastColor = gpu.setForeground(tonumber(color))
	print(text)
	gpu.setForeground(lastColor)
end

-----------------------------------------------------------------------------------------------|
-----------------------------------------------------------------------------------------------|
Tools = {
	words = {
	[1] = "communicate",
	[2] = "show",
	[3] = "ram",
	[4] = "test",
	[5] = "write",
	[6] = "clean",
	[7] = "rctrl",
	[8] = "oscontrol",
	[9] = "robotalgorithm",
	[10] = "maketunnel",
	[11] = "dig",
	[12] = "mrec",
	[13] = "farm",
	[14] = "exit",},

	funcs = {

	}
}

if connectingToServer and libraryExist == true then
	connect()
	local variableCurrentAddress = currentAddress() end
while true do
colorprint("pick the option", 0x3340B6)
local chose = io.read()
	if chose == "communicate" then
	Options.communicateWithServer() 
else if chose == "show" then
	Options.ShowDEBUGInfo()
else if chose == "ram" then
	countMemory()
else if chose == "test" then
	prepare()
	test(isPrepareFinished)
else if chose == "write" then
	print("choose file to write data in EEPROM(full path)")
	local fileToRead = io.read()
	local byteArray = read(fileToRead)
	writeInEEPROM(byteArray)
	print("data successfully writed")
else if chose == "clean" then
	Options.cleanup()
else if chose == "rctrl" then
	print ("connecting to the robot")
	robotControl()
else if chose == "oscontrol" then
	robotOSControl()
else if chose == "robotalgorithm" then
	robotAlgorithm()
else if chose == "maketunnel" then
	maketunnel()
else if chose == "dig" then
	senddig()
else if chose == "mrec" then
 	print("\nnow trying record macross for robot")
 	mRecord()
else if chose == "farm" then
	print("\nstart farming")
	modem.broadcast(robotPort, "farm")
else if chose == "exit" then
	print("gb :)")
	return
end end end end end end end end end end end end end end end
-----------------------------------------------------------------------------------------------|
-----------------------------------------------------------------------------------------------|