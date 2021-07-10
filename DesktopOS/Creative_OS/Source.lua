--this is a default pack of parameters


port = 512
sreenSize = 0, gpu.getScreen()
bit32 = {}
Username = "Axeer"

local robot = require 'robot'

local movebot = {}

function movebot.forward(x)
  x = x or 1
  for i = 1, x do
    robot.forward()
  end
end

function movebot.back(x)
  x = x or 1
  for i = 1, x do
    robot.back()
  end
end

function movebot.up(x)
  x = x or 1
  for i = 1, x do
    robot.up()
  end
end

function movebot.down(x)
  x = x or 1
  for i = 1, x do
    robot.down()
  end
end

return movebot