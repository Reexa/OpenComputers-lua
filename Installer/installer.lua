-- хуита для закачивания на комп файлов с инета
-- на вход принимает файл в формате:
-- список файлов через запятую [main.lua, notmain.lua, lessthanmain.lua]
-- список url адресов, через которые можно достать эти файлы {https://pastebin.com/raw/CxK8TbMD, https://raw.githubusercontent.com/IgorTimofeev/MineOS/master/Installer/BIOS.lua, https://pastebin.com/raw/ABOBASOSI}


local component 	= require("component")
local computer  	= require("computer")
local shell     	= require("shell")
local filesystem 	= require("filesystem")

local isParserExist = false

if (filesystem.exists("home\\Parser\\parser.lua")) then
	isParserExist = true
	StrParser = require("Parser/parser")
else
	print("Parser file is not found. using own")
	isParserExist = false
	Parser = {}
	StrParser = Parser
end

Parser.getWordsInStringArray = function(string, separator, stop)
    local word          = ""
    local words_array   = {}
    for i in string:gmatch"." do

        if i ~= separator then
            if i ~= ' ' and i ~= '\t' and i ~= '\n' and i ~= '\r' then
                word = word..i
            end
        else
            table.insert(words_array, word)
            word = ""
        end

    end
    return words_array
end

Parser.getWordsInTable = function(array, separator)
    local word          = ""
    local words_array   = {}
    for _, ii in pairs(array) do
        for i in ii:gmatch"." do
            if i ~= separator then
                if i ~= ' ' and i ~= '\t' and i ~= '\n' and i ~= '\r' then
                    word = word..i
                end
            else
            end
        end
        if word ~= "" and word ~= nil then table.insert(words_array, word) end
        word = ""
    end
    return words_array
end

Parser.getStringArrayInBlock = function(arr, block_start, block_end)
    local str       = ""
    local to_read   = false
    local str_out   = {}
    if arr == nil then
        error("[!] Get nil string on parser input")
    end

    if block_start == nil or block_end == nil then
        error("[!] nil block symbol on parser input")
    end

    for i in arr:gmatch"." do   -- посимвольный перебор строки
        if i == block_end then
            to_read = false
        end
        if to_read and i ~= nil and i ~= '\t' and i ~= '\r' and i ~= '\n' and i ~= ' ' and i ~= ',' then
            str = str..i
        end
        if i == block_start then
            to_read = true
        end
        if i == ',' then
            table.insert(str_out, str)
            str = ""
        end
    end
    table.insert(str_out, str)
    return str_out
end

local args, ops = shell.parse(...)

local temporaryFilesystemProxy, selectedFilesystemProxy

local function filesystemPath(path)
	return path:match("^(.+%/).") or ""
end

local function filesystemName(path)
	return path:match("%/?([^%/]+%/?)$")
end

local function filesystemHideExtension(path)
	return path:match("(.+)%..+") or path
end

local function getComponentAddress(name)
	return component.list(name)() or error("Required " .. name .. " component is missing")
end

local function getComponentProxy(name)
	return component.proxy(getComponentAddress(name))
end

local EEPROMProxy, internetProxy, GPUProxy =
	getComponentProxy("eeprom"),
	getComponentProxy("internet"),
	getComponentProxy("gpu")


	local function readHandle(handle)
	local chunk = nil
	local data  = ""
		while true do
			chunk = handle.read(math.huge)
			if chunk then
				data = data .. chunk
			else
				break
			end
		end
	return data
end

local function rawRequest(url, chunkHandler)
	--local internetHandle, reason = internetProxy.request(repositoryURL or "" .. url:gsub("([^%w%-%_%.%~])", function(char)
	local internetHandle, reason = internetProxy.request(url)

	if internetHandle then
		local chunk, reason
		while true do
			chunk, reason = internetHandle.read(math.huge)
			if chunk then
				chunkHandler(chunk)
			else
				if reason then
					error("Internet request failed: " .. tostring(reason))
				end

				break
			end
		end

		internetHandle.close()
	else
		error("Connection failed: " .. url)
	end
end

local function request(url)
	local data = ""
	
	rawRequest(url, function(chunk)
		data = data .. chunk
	end)

	return data
end

local function download(url, path)
	selectedFilesystemProxy.makeDirectory(filesystemPath(path))

	local fileHandle, reason = selectedFilesystemProxy.open(path, "wb")

	if fileHandle then
		rawRequest(url,
			function(chunk)
				selectedFilesystemProxy.write(fileHandle, chunk)
			end)
		selectedFilesystemProxy.close(fileHandle)
	else
		error("File opening failed: " .. tostring(reason))
	end
end

local function deserialize(text)
	local result, reason = load("return " .. text, "=string")
	if result then
		return result()
	else
		error(reason)
	end
end

for address in component.list("filesystem") do
	local proxy = component.proxy(address)
	if proxy.spaceTotal() >= 1 * 1024 * 1024 then
		temporaryFilesystemProxy, selectedFilesystemProxy = proxy, proxy
		break
	end
end




if ops ~= nil then
	local filename = ""
	for _, arg in pairs(args) do filename = tostring(arg) break end
	FileData	= filesystem.open("home/"..filename,'r'):read(math.huge)
	local urls	= StrParser.getStringArrayInBlock(FileData, '{', '}')
	Url 		= StrParser.getWordsInTable(urls, ',')
	for index, value in ipairs(Url) do print(index .. '\t'.. " url " .. value) end
	if Url == nil then error("[!] File ".. filename.." are hasn't url or file doesn't exist" ) end
else
	Url = tostring(args)
end

if args == nil and ops == nil then error("[!] Required github url or github url file and -f option") end

local names = StrParser.getStringArrayInBlock(FileData, '[', ']')
names		= StrParser.getWordsInTable(names, ',')
for k, v in pairs(Url) do download(v, "home/download/"..names[k]) end


--if not component.isAvailable("eeprom") then
--	error("[!] EEPROM component is required for installation")
--end
--local result, reason = load(Data, "=installer")
--if result then
--    component.eeprom.set(Data)
--    computer.shutdown(true)
--else
--	error("[!] "..reason)
--end

--link example: https://raw.githubusercontent.com/IgorTimofeev/MineOS/master/Installer/BIOS.lua
--or just use command: wget -f https://raw.githubusercontent.com/IgorTimofeev/MineOS/master/Installer/BIOS.lua /tmp/bios.lua && flash -q /tmp/bios.lua && reboot