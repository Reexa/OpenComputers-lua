local component = require("component")
local shell = require("shell")
local camera = component.camera
local gpu = component.gpu

local _MODE = "standalone" or "emdedded"

local resol = {gpu.getResolution()}

local arg1, arg2 = shell.parse()
if arg1 ~= nil and arg2 ~= nil then
    _MODE = "emdedded"
else
    _MODE = "standalone"
end
local previousColor = gpu.setBackground(0x000000)
gpu.fill(1,1,resol[1],resol[2]," ")
gpu.setBackground(previousColor)