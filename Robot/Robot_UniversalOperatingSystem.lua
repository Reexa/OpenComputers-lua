---@diagnostic disable: lowercase-global, undefined-global, undefined-field
-- Edited in 11.06.2021
local robot = require"robot"
local thread = require "thread"
local component = require "component"
local event = require"event"
local serialization = require"serialization"
local filesystem = require "filesystem"
local serialization = require"serialization"
local computer = require"computer"
local modem = component.modem
local port = 512
local robotPort = 1024
local eeprom = component.eeprom
--local navigation = component.navigation
local inventory = component.inventory_controller
local gpu = component.gpu

local library = require"library"

local dig  	= loadfile("\\home\\dig.lua")
local farm	= loadfile("\\home\\farmscript.lua")
local parser= loadfile("\\home\\Parser\\parser.lua")


modem.open(port)
modem.open(robotPort)
waypointParam = {}
Control = {}
Algorithms = {}
RobotInventory = {}
mining = {}
local territory = {}
robotItem = {}
--config values

local minesize = 20
mining.turnSide = false
mining.minedistance =20
mining.sides = 4
mining.distanceToPlaceTorch = 16
robotItem.sword = 15
robotItem.torch = 16
robotItem.pickaxe = 14

local isServerConnecting = false

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

else
	break
	print("nil address")
end end end


function receiveSignal()
	local _, _, from, _, _, message = event.pull("modem_message")
	return message
end


function sendToServer(dataString, pathToSave, fileOptions)
	--local filePath,dataString = read(file)
	if (pathToSave == nil or pathToSave == _) then
		pathToSave = "temp"
		fileOptions = "add"
	end
	if (fileOptions == "add") then
		dataString = dataString.."$ "
	end
	modem.send(variableCurrentAddress, port, "receiveFile")--begin
	modem.send(variableCurrentAddress, port, pathToSave) --path
	modem.send(variableCurrentAddress, port, fileOptions) --opt
	os.sleep(0.5)
	modem.send(variableCurrentAddress, port, dataString) --data
end


function inventoryCount()
local INVENTORY = {}
for i =1, 16, 1 do
table.insert(INVENTORY,(robot.count(i)))
return INVENTORY
end end

function toolDurability()
	local TOOL = {[1] = robot.durability()}
	return TOOL[cur]

end

function sendLogToServer()
local toLog = {computer.energy(),
computer.maxEnergy(),
computer.freeMemory(),
toolDurability(),
inventoryCount(),
}

local fileString = serialization.serialize(toLog)
print("pick the path to send file to server")
sendFileToServer(fileString, io.read())
end

function detectLeft()
robot.turnLeft()
bobot.detect()
robot.turnRight()
end
function detectRight()
robot.turnRight()
bobot.detect()
robot.turnLeft()
end

function oreAnalyze()
local currentOre = nil
local analyzeSide = nil
local analyzedOreCoordinatres = {
	  [1] = {analyzedOreCoordinatreX},
	  [2] = {analyzedOreCoordinatreY},
	  [3] = {analyzedOreCoordinatreZ}
	}
local availableAnalyze = {
	[1] = robot.detect(),
	[2] = robot.detectUp(),
	[3] = robot.detectDown(),
	[4] = detectLeft(),
	[5] = detectRight(),
}
local isBlockOnSide = nil
local availableSides = 5 -- front up down left right
for counter = 0, availableSides do
--check have a block the front of robot
isBlockOnSide, currentOre = analyzedOreCoordinatres[counter]
sendToServer(isBlockOnSide, "analyzedBlocks", "add")
sendToServer(currentOre, "analyzedBlock", "add")
end end
function mining.robotcolumn()
robot.swingUp()
robot.swingDown()
robot.swing()
	end

function dequipItems()



end

function mineForward()
		mining.distanceToPlaceTorch = mining.distanceToPlaceTorch- 1
		if  not robot.swing()then
			print("???????? ?????????? ?????????????????????? ??????????")
			robot.swingUp()
			robot.up()
		end
		robot.swingUp()
		robot.swingDown()
		if not robot.forward() then
			print("?????????????? ????????!!!!")
			robot.swing()
		end
		if mining.distanceToPlaceTorch == 0 then
			robot.turnRight()
			robot.swing()
			robot.select(robotItem.torch)
			robot.place(_,true)
			robot.turnLeft()
			mining.distanceToPlaceTorch = 16
		end
			mining.minedistance = mining.minedistance-1
	end

function mining.turn(turnside)
	if not turnside then
		mining.turnSide = true
		robot.turnRight()
	elseif turnside then
		mining.turnSide = false
		robot.turnLeft()
	end
end
--main
function maketunnel()
	for i =0 ,mining.sides do

		for j = 0, mining.minedistance do
			if robot.detect() then
				print("?????????? ??????????")
				mineForward()
			else
			 if robot.forward() then
			 print("?????????????????? ????????????")
			 else
			 	print("?????? ???????")
			 	for i =0, 10, 1 do
			 		robot.swing()
			 	end
			 end
		end
		--mining.minedistance = mining.minedistance-1

	end
	robot.turnLeft()
end
end

function territoryBURNER()
local x, y, z = 0
size = {10, 10, 10}
for h = 0, size[3] do
for j =0 ,size[2] do
for i=0, size[1] do
	robot.swing()
	robot.forward()
	size[1] = size[1] -1
end
 if size[1]%2 ~= 0 then
 	robot.turnLeft()
 else  robot.turnRight()
 end
 size[2] = size[2]+1
 if size[2] == 0 then
 	size[3] = size[3] +1
 	robot.swingDown()
 	robot.down()
 end
end
end
end

local function agressiveMove(side)

	if(side == "forward") then
		if(~(robot.forward()))then
			robot.swing()
			robot.forward()
		end
	end
	if (side == "back") then
		if(~robot.back()) then
			local i =0
			for i=0,i~=2,1 do
				robot.turnRight()
			end
			robot.swing()
			robot.forward()
			for i=0, i~=2, 1 do
				robot.turnRight()
			end
		end
	end
end
local function remoteControl()
	while true do
	os.sleep()
--	local _, _, from, _, _, message = event.pull("modem_message")
	local e = {event.pull()}
	print("receivedMessage")
	if e[1] == "modem_message" then
		if e[4] == robotPort then
				if e[6] then print(e[6])
				if e[6] == "moveUp" then
						robot.up()
					elseif e[6] == "moveDown" then
						robot.down()
					elseif e[6] == "moveForward" then
						if  not robot.forward() then
						while robot.detect() do
						 robot.swing()
						end
						robot.forward()
						end
					elseif e[6] == "moveBack" then
						robot.back()
					elseif e[6] == "moveLeft" then
						robot.turnLeft()
					elseif e[6] == "moveRight" then
						robot.turnRight()
					elseif e[6] == "analyze" then
						isPassing, detectedBlock = robot.detect()
						modem.broadcast(robotPort, detectedBlock)
					elseif e[6] == "checkKey" then
						checkkey()
					elseif e[6] == "activate" then
						robot.use()
					elseif e[6] == "OTSOS" then
						for i = 1, (inventory.getInventorySize(0) or 1) do
							inventory.suckFromSlot(0, 1)
						end
						for i = 1, (inventory.getInventorySize(1) or 1) do
							inventory.suckFromSlot(1, 1)
						end
					elseif e[6] == "swing" then
						robot.swing()
					elseif e[6] == "use" then
						robot.use()
					elseif e[6] == "VIBROSI" then
						for i = 1, robot.inventorySize() do
							robot.select(1)
							robot.drop(64)
						end
					elseif e[6] == "analyze" then
						oreAnalyze()
					elseif e[6] == "maketunnel" then
						maketunnel()
					elseif e[6] == "end" then
						return "end"
					elseif e[6] == "moveSpeedUp" then
						moveSpeed = moveSpeed + 0.1
						print("SKOROST + NA 0.1")
					elseif e[6] == "moveSpeedDown" then
						moveSpeed = moveSpeed - 0.1
						if moveSpeed < 0.1 then moveSpeed = 0.1 end
						print("SKOROST - NA 0.1")
				end
			end
		end
	end
end end

function algorithmControl()

--get signal
local _, _, _, _, _, message = event.pull("modem_message")
if (message == "mine")then
	Algorithms.mine()
else if (message == "end") then
	return
end end end

local function getAlgorithms()
	local serializedTable = serialization.serialize(Algorithms)
for i = 0, #Algorithms, 1 do
print(i .. ".".. " ".. Algorithms[i])
end end

--???????????????? ????????????????????
--10 ???????????? ????????????????  = 32 ???????????? ??????????????

local function SignalListener()

	local msg = "say my name" 
	local prev_msg = ""
	local signals =
	{
		"remoteControl",
		"algorithmControl",
		"dig",
		"farm",
	}
	while true do
		os.sleep(0.5)

		if prev_msg ~= msg then
			print(msg)
			prev_msg = msg
		end
		
		local signal = receiveSignal()

		if signal == signals[1] then
			msg = "start controlling"
			remoteControl()
		elseif signal == signals[2] then
			msg = "let alghorithms control"
			algorithmControl()
		elseif signal == signals[3] then
			msg = "start making a big tunnel"
			digLayer(9)
		elseif signal == signals[4] then
			msg = "start farming eat"
			api.farmStart()
		else msg = "no command or parameter find" end
	end

end


----------------------------------------------------------------------------------------------------|
--	execute	begin																					--
----------------------------------------------------------------------------------------------------|
if isServerConnecting then
	connect()
	variableCurrentAddress = currentAddress()
end

thread.create(SignalListener):detach() -- listen for control signal from remote device

----------------------------------------------------------------------------------------------------|
--	execute end																						--
----------------------------------------------------------------------------------------------------|
