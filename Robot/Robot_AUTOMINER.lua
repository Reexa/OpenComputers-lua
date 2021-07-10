local robot = require"robot"
local thread = require "thread"
local component = require "component"
local event = require("event")
local serialization = require("serialization")
local filesystem = require "filesystem"
local eeprom = component.eeprom
local inventory = component.inventory_controller
local gpu = component.gpu

local minesize = 20
mining = {}
local territory = {}
 mining.turnSide = false
	 mining.minedistance =200
	 mining.sides = 4
	 mining.distanceToPlaceTorch = 16
robotItem = {}
robotItem.sword = 15
robotItem.torch = 16
robotItem.pickaxe = 14

function mineForward()
		mining.distanceToPlaceTorch = mining.distanceToPlaceTorch- 1 
		print(mining.distanceToPlaceTorch)
		if  not robot.swing()then
			print("сука хуйни понаставили Ълятт")
			robot.swingUp()
			robot.up()
		end
		robot.swingUp()
		robot.swingDown()
		if not robot.forward() then
			print("застрял сука!!!!")
			robot.swing()
		end
		if mining.distanceToPlaceTorch ==0then
			robot.turnRight()
			robot.swing()
			robot.select(robotItem.torch)
			robot.place(_,true)
			robot.turnLeft()
			mining.distanceToPlaceTorch = 16
		end
			mining.minedistance = mining.minedistance-1
	end

function mining.robotcolumn()
robot.swingUp()
robot.swingDown()
robot.swing()
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
	for i =0 ,mining.sides do
		for j = 0, mining.minedistance do

			if robot.detect() then
				mineForward()
			else 
			 if robot.forward() then
			 print("астарожна воздух")
			 else 
			 	print("что это?")
			 	for i =0, 10, 1 do
			 		robot.swing()
			 	end
			 end
		end
		robot.turnLeft()
	end
end
--1 заход
-- туду епта: запилить выгрузку лута в сундуки при необходимости