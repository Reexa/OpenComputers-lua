
local screen = require("Screen")
local filesystem = require("Filesystem")
local image = require("Image")
local color = require("Color")
local keyboard = require("Keyboard")
local event = require("Event")
local GUI = require("GUI")
local paths = require("Paths")
local text = require("Text")
local number = require("Number")
local system = require("System.lua")

local pass = userSettings.securityPassword
GUI.alert(pass)