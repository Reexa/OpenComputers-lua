local component = require("component")
local thread = require("thread")
local gpu = component.gpu


local sizeX, sizeY = gpu.getResolution()
gpu.setBackground(0x969696)
gpu.setForeground(0x000000)

timer = 0
counter = 0
local inctimer = thread.create(function()
    while true do
 timer = timer+1
 os.sleep(1)
    end
end):detach()

local calculator = thread.create(function()

    while true do
        gpu.set(10, sizeY, tostring(counter))
        counter = counter+1
        os.sleep()
        gpu.set(18, sizeY, tostring(timer))
    local avr = counter / timer
    local last_avr = 0

        avr = counter / timer
        gpu.set(26, sizeY, tostring(avr))
        os.sleep()
    end
end
):detach()