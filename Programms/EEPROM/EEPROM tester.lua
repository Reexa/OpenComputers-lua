
local component = require "component"
local event = require("event")
local eeprom = component.eeprom
local gpu = component.gpu
local serialization = require"serialization"
local modem = component.modem
local port = 512
dataBuffer = {}

eepromSize = nil
isPrepareFinished = false
function prepare()

	w,h = gpu.getResolution()
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
    
modem.open(port)
fileString = serialization.serialize(EEPROMdata)
if (modem.broadcast(port,fileString)) ==true then
	print("file has been successfully sended"..fileString)
	else 
	print("error in sending")
	end
	local _, _, from, port, _, message = event.pull("modem_message")
	print(message)
	d = io.read()
	modem.broadcast(port,d)
	local _, _, from, port, _, result = event.pull("modem_message")
	print(result)
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
return fileString
end
	function writeInEEPROM(byteArray)
		eeprom.set(byteArray)
end
------------------------------------------------------------------------------------------------------------
	prepare()
print("-=EEPROM tester=-")
print("what need to do?")
	local chose = io.read()
	if chose == "test" then
	test(isPrepareFinished)
else if chose == "write" then
print("choose file to write data in EEPROM(full path)")
fileToRead = io.read()
local byteArray = read(fileToRead)
writeInEEPROM(byteArray)
print("data successfully writed")
end end