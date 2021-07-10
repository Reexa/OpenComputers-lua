local robot = require("robot")
local component = require("component")
local shell = require("shell")

api = {}
field = {}
robotcontrol = {}
robotcontrol.movesCounter = 0
debugtools = {}
robotcontrol.side = "left"
field.Coords = { Xbegin = 0, Ybegin = 0,Xend = 0, Yend = 0 }

arg1, arg2 = shell.parse(...)

if arg1 == nil and arg2 == nil then
	print("\nargs are not defined. harvesting default field size\n")
end

debugtools.increaseMoves = function()

	robotcontrol.movesCounter = robotcontrol.movesCounter+1

end

debugtools.printMoves = function()

	print("\nblocks that a robot move:	")
	print(debugtools.movesCounter)

end

robotcontrol.getblock = function()

	robot.useDown()
	robot.forward()

end

robotcontrol.turnLeft = function()

	robot.forward()
	robot.turnLeft()
	robot.forward()
	robot.turnLeft()

end

robotcontrol.switchSide = function()

	if robotcontrol.side == "left" then
		robotcontrol.side = "right"

	else if robotcontrol.side == "right" then
		robotcontrol.side = "left"

end
end end

field.harvest = function(Sizex, Sizey)
	if arg1 then
		local Sizex = arg1
	end
	if arg2 then
		local Sizey = arg2
	end

	local sy = 0
	local sx = 0
	local i = 1

	local turnSide = false
			for sx = 0, Sizex, 1 do
				for sy = 0, Sizey, 1 do
					robotcontrol.getBlock()
			 	end
		 			if robotcontrol.side == "left" then
		 			robotcontrol.turnLeft()
					--robot.forward()
				else
					robot.forward()
					robot.turnRight()
					robot.forward()
					robot.turnRight()
					--robot.forward()
				end
			robotcontrol.switchSide()
			end

		--robot.turnLeft()
		--for i = 1, Sizex, 1 do
		--	robot.forward()
		--end
		--robot.turnAround()
end

field.cleanInventory = function()

	robot.turnAround()
	for i = 1,16, 1 do
		if (i<=3 and robot.count(i)== 0) then
			print("do not have plants")

		if i>3 and robot.count(i) ~= 0 then
			robot.drop()
			end 
		end
	end
	robot.turnAround()

end
--------------------------MAIN--------------------------
field.farm = function(sizex, sizey)
	while true do
		field.harvest(sizex, sizey)
		field.cleanInventory()
		os.sleep(60)
	end
end


return function api.farmStart(sizex, sizey)

	field.farm(sizex, sizey)

end