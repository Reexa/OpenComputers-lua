local component = require("component")
local event = require("event")
local modem = require component.modem
local port = 512
local image = require("Image")
local text = require("Text")
local number = require("Number")
local screenSize = 0, maxResolution()
local filesystem = require("filesystem")

local screen = require("Screen")
screen.setGPUProxy(GPUProxy)

local GUI = require("GUI")
local system = require("System")
local paths = require("Paths")

local bit32 = {}

function Startup()
	modem.open(port)

return Startup.status
end

local function screenPrepairing()
currentScreen =	gpu.getScreen()
gpu.set(screenSize, 0x000080)
return screenStatus 
end


function save()

save = file.save("Source.lua")
end
function load()

load = file.Load("Source.lua")
end

function runSystem()

--start compiling



screenStatus.save()









