local component = require("component")
local event = require("event")
local robot = require("robot")
local modem = component.modem
local inventory = component.inventory_controller
local tb = component.tractor_beam
local gpu = component.gpu
local port = 512
local moveSpeed = 1.0
local suckSide = 0
local x = 0
local z = nil
local t = 0
local slices = 0
local blocksCount = 0
local size = 6
local keynumber = 0
modem.open(port)
		function  choptree()
	robot.swing()
	robot.forward()
		for x = 0, 20 do
	tb.suck()
		end
	end
function checkkey()
print("Please push a key")
local keynumber = {event.pull()}
	repeat
 	 
 	
 	 	if keynumber == "key_down" then
modem.broadcast(port, keynumber)
		break
		end
	end
end

while true do
local _, _, from, port, _, message = event.pull("modem_message")
local e = {event.pull()}
	if e[1] == "modem_message" then
		if e[4] == port then
			if e[6] == "ESCrobot" then
				--robot.setStatusText("KOMANDA: " .. e[7])
				if e[7] == "moveUp" then
						robot.up()
					elseif e[7] == "moveDown" then
						robot.down()
					elseif e[7] == "moveForward" then
						robot.forward()
					elseif e[7] == "moveBack" then
						robot.back()
					elseif e[7] == "moveLeft" then
						robot.turnLeft()
					elseif e[7] == "moveRight" then
						robot.turnRight()
					elseif e[7] == "chopTree" then
						choptree()
					elseif e[7] == "checkKey" then
						checkkey()
					else if e[7] == "activate" then
						robot.use()
					elseif e[7] == "plaseTree" then
					 blocksCount = 0 or nil
					 slices = 0 or nil
					 
						while true do

							
						
						robot.up()
						robot.place()
						robot.forward()
						robot.down()
						
						
						blocksCount = blocksCount + 1
						
					--end
						if (blocksCount == 6) then

						 robot.turnLeft()
						robot.forward()
						robot.turnLeft()
						
						
						blocksCount = 0
						slices = slices + 1
					else
						print("sloi:" .. slices .. "\n" .. "county:" .. blocksCount .. "\n")
						if (slices == 6) then
							break
					end
					end
				end




					--elseif e[7] == "changeColor" then
						--robot.setLightColor(math.random(0x0, 0xFFFFFF))
					elseif e[7] == "OT" then
						for i = 1, (inventory.getInventorySize(0) or 1) do
							inventory.suckFromSlot(0, 1)
end
						for i = 1, (inventory.getInventorySize(1) or 1) do
							inventory.suckFromSlot(1, 1)
end
					elseif e[7] == "VIBROSI" then
						for i = 1, robot.inventorySize() do
							robot.select(1)
							robot.drop(64)
						end
					elseif e[7] == "moveSpeedUp" then
						moveSpeed = moveSpeed + 0.1
						print("SKOROST + NA 0.1")
					elseif e[7] == "moveSpeedDown" then
						moveSpeed = moveSpeed - 0.1
					if moveSpeed < 0.1 then moveSpeed = 0.1 end
					print("SKOROST - NA 0.1")
				end
			end
		end
	end
end
end
