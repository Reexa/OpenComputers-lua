local component = require("component")
local robot = require("robot")
local size = 9

function harvest()
  robot.forward()
  for y=1, size do
     
    robot.placeDown()
    for x=1, (size-1) do
      robot.forward()
       
      robot.placeDown()
    end
    if y%2 == 1 then
	  robot.turnLeft()
	  robot.forward()
	  robot.turnLeft()
	else
	  robot.turnRight()
	  robot.forward()
	  robot.turnRight()
	end
  end
  for y=1, (size-1) do
    robot.forward()
  end
  robot.turnLeft()
  for y=1, (size-1) do
    robot.forward()
  end
  robot.turnRight()
  robot.forward()
  robot.forward()
  robot.turnAround()
end
function unload()
  robot.turnAround()
  for c = 3, 16 do
    robot.select(c)
    if robot.count() > 0 then
      robot.drop()
    else
      robot.select(1)
      break
    end
  end
  robot.turnAround()
  
end
function equip()
 
  u = robot.compareTo(2)
   if u == true then
robot.select(2)
  robot.transferTo(1)
  robot.select(1)
else
  robot.select(1)
end
end

while true do
  for i=1, 10 do
    os.sleep(3)
    print((10*i)..'%')
  end
  harvest()
  if robot.count(3) > 0 then
    unload()
    equip()
  end
end