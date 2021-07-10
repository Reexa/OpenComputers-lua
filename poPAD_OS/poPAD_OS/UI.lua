local gpu = require("gpu")

UI = {	}

function UI:setMainWorkspace(screenSizeX, screenSizeY)
	gpu.fill(0,0,screenSizeY, screenSizeX, screenSizeY, " ")
end

screenSizeX, screenSizeY = gpu.getResolution()
