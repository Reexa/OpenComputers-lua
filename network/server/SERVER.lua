local serialization = require("serialization")
local filesystem 	= require("filesystem")
local component 	= require("component")
local thread 		= require("thread")
local modem 		= component.modem
local event 		= require("event")
local port 			= 512

local Daemon = {}

if(modem.isOpen(512))==true then
	print("Port " .. port .. " already used")
	port = ( math.ramdom(0,1) and math.random(513, 1024) ) or math.random(1, 511)
	modem.open(port)
else 
	modem.open(port)
end
--[[TODO:--server slushaet prikaz|
		 1. zaprosit' file_______|
		 2. prinyat' file________|(*IN_PROGRESS*)
		 3. otdat' infu o failah_|
thread.create(function()receiving|
]]--

function listen()
modem.broadcast(port, "address" )
	end

function ReseiveData()
	--Path
	--Data
	local _, _, from, port, _, path = event.pull(1, "modem_message")
	if path == nil then
		path = "/received/files"
	end
	local _, _, from, port, _, fileData = event.pull("modem_message")
	print(fileData .. '\n')
	--local fileRead = {[Path] = "path", [data] = "data"}
	--fileRead[path] = io.open(fileReadName, "rb")
	--fileRead[data] = fileRead[path]:read("*a")
	--print(fileRead[data])
	--local fileString = serialization.serialize(fileRead[data])
	local fileWrite = io.open(path, "w")
	fileWrite:write(fileData)
	fileWrite:close()
end

function send()
	local question = "enter a path to send the file: "
	if (modem.send(from, port,question)) == true then
		modem.send(from, port,"end")
		local path
	local _, _, from, port, _, path = event.pull("modem_message")
local Path = ""
local data = ""
local fileRead = {[Path] = "path", [data] = "data"}
fileRead[path] = io.open(path, "rb")
fileRead[data] = fileRead[path]:read("*a")
print(fileRead[data])
local fileString = serialization.serialize(fileRead[data])	 	
		if (modem.send(from, port,fileString)) ==true then
print("file has been successfully sended")
modem.send(from, port,"end")
		else 
print("error in sending")
		end
	end
end


function fileList()
local isDirectory = filesystem.isDirectory("../")
if (isDirectory) == true then
	local INFO, fileInfo = filesystem.list("../")
	repeat
	k , v = INFO()
	 modem.send(from, port,k)
 until k == nil
modem.send(from, port, "end")
end end

AvailableMessages = {
	"ReseiveData",
	"receiveFile",
	"sendFile",
	"connect",
	"address",
	"quit",
	["callbacks"] = {
		ReseiveData,
		send,
		fileList,
		{[1] = modem.send, [2] = {from, port, "end"}},
		listen,
		{[1] = print, [2] = {"something listening"}},
		{[1] = modem.send, [2] = {from, port, errorstring}}
	}
}

local function main()
	while true do
		_, _, from, port, _, message = event.pull("modem_message")
		print("Got a message from " .. from .. " on port " .. port .. ": " .. tostring(message))
		print('\n')
		if message == "receiveFile"then
			ReseiveData()
			modem.send(from, port, "function in progress")
		else if message == "sendFile" then
			send()
		else if message == "fileList" then 
			fileList()
		else if message == "quit" then
			modem.send(from, port, "end")
		else if message == "connect" then
			listen()
		else if message == "address" then
			print("something listening")
		else 
			local errorstring = "invalid request. invalid author. try again"
			modem.send(from, port, errorstring)
		end
		end
	end end
end
end
end
end

--filesystem.path(path: string): string Возвращает компонент пути к файлу, т. Е. Все до последней косой черты в канонической форме указанного пути. (IN_PROGRESS iopta)