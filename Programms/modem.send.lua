local thread = require("thread")
local component = require("component")
local gpu = component.gpu
local event = require("event")
--local tunnel = component.tunnel
local modem = component.modem
modem.open(512)
modem.broadcast(512, "1+1")
