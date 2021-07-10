local component = require("component")
local gpu = component.gpu
local thread  = require ("thread")
local Container = require("/poPAD_OS/Container")
--local expl = loadfile("expl.lua")
------------------------------CONSTANTS------------------------------
local BACKGROUNDCOLOR = 0x787878
ScreenSize = {gpu.getResolution()}
---------------------------------------------------------------------
graphicsID = {}
GUI = {}
localscreenSizeX, screenSizeY = gpu.getResolution()


local gsF, gsB, gF, gS = gpu.setForeground,gpu.setBackground, gpu.fill, gpu.set

GUI.button = {}
GUI.button.size = {5,7}
GUI.button.backend = { }
GUI.button.position = { }
GUI.button.callbacks = { }
--GUI.button.buttonContainer = {buttonContainerX = x-GUI.button.size[1]/2,buttonContainerY=y-GUI.button.size[2]/2}
--GUI.button.shadowLayer = {beginX =x-GUI.button.size[1]/2,beginY = y-GUI.button.size[2]/2,
--endX = GUI.button.size[1], endY = GUI.button.size[2] }
GUI.button.control = { }
GUI.button.control.operation = {directionVector ={x = 0, y = 0}}
GUI.currentContaier = { }

--Object 'Context'
GUI.Context = {Draw = nil}
GUI.ScreenSize = {gpu.getResolution()}
Console = {}
Button = {

    size = {width, height},
    position = {x, y},
    title = { position = {x, y}, size = {width, height} },
    message_position = {x,y},
    dialogue_button = {

        position = {x,y},
        size = {x,y},
        interactable = {

            x1,y1,x2,y2,

        },

    }
}

GUI.button.fillBackend = function(color)
	--[[backendId = math.random()
	backInf = {id = backendId,name = "backend",backendPos = {x1 = x1, y1 = y1, x2 = x2, y2 = y2},color = 0x3c3c3c}
	table.insert(GUI.button.backend,backInf)
	table.insert(graphicsID, backendId)]]

	gpu.setBackground(color)
	gpu.fill(GUI.button.position[1], GUI.button.position[2], GUI.button.position[1] + GUI.button.size[1], GUI.button.position[2] + GUI.button.size[2], " ")

end

GUI.button.fillFrontend = function(backColor, frontColor)

	--[[table.insert()]]
	gpu.setBackground(backColor)
	gpu.setForeground(frontColor)
	gpu.fill(GUI.button.position[1], GUI.button.position[2], GUI.button.position[1] + GUI.button.size[1]-2,GUI.button.position[2] + GUI.button.size[2]-1, "+")
	 
end

GUI.button.makeInteractable = function()

	--gpu.setBackground(0x3c3c3c)
	--gpu.fill(x1,y1,x2,y2,  " ")
	--in progress

end


--[[getByID= function(ID)
for k , v in graphicsID do
	print(v ..'\t'..k)
end
end]]


EXPL = {}
EXPL.mouseEvent = {x = 1, y = 1, touchX = 0, touchY = 0,
    onTouch = function(x,y)
        if x > screenSizeX or x <0 then
            x = 0
        end
        if y >screenSizeY or y<0 then
            y = 0
        end
end}

function GUI.button:addCallback(buttonPos, reference)
--buttonPos - позиция на элементе для обработки кб
--reference - функция, вызываемая кб
    GUI.button.callbacks.insert({buttonPos, reference})
end

 main_thread = thread.create(function ()
	while true do
   id, _,
  EXPL.mouseEvent.x,
  EXPL.mouseEvent.y = event.pullMultiple("touch", "interrupted")
    
     if id == "touch" then

     	EXPL.mouseEvent.touchX = EXPL.mouseEvent.x
     	EXPL.mouseEvent.touchY = EXPL.mouseEvent.y
     	EXPL.mouseEvent.onTouch(EXPL.mouseEvent.x,EXPL.mouseEvent.y)
     	  
  end

end
end
	):detach()
--[[ GUI.button.control.operation ={dragandmove = function()
local _,x, y = event.pull("drag")
	if x == 
		GUI.button.shadowLayer.buttonContainerX = EXPL.mouseEvent.touchX
		GUI.button.shadowLayer.buttonContainerY = EXPL.mouseEvent.touchY
	end
		--сюда пихнуть начальный слой
end}]]
--обертка функций для взаимодействия с внешними программами
GUI.api = {}
GUI.api.makeButton = function(x1,y1,x2,y2,backColor,frontColor)

	GUI.button.position[1] = x1
	GUI.button.position[2] = y1
	GUI.button.size[1] = x2-x1
	GUI.button.size[2] = y2-y1
	GUI.button.fillBackend(backColor)
	GUI.button.fillFrontend(frontColor, frontColor)


end
--API:
--
--GUI.api.makeButton(1,1, 20, 10, 0x3c3c3c,0xffffff)


local function makeSeparator(foregroundColor, backgroundColor, character)

    for y = 0, ScreenSize[2] do
        gpu.setBackground(backgroundColor)
        gpu.setForeground(foregroundColor)
        gpu.set((ScreenSize[1]/2 - ((ScreenSize[1]/2)/2)), y, character)

    end

end

--[[--простая функция создания элемента "кнопка"
function Button:make(title, message, buttonMessage)
    Button.size.width = ((Screen[1]/2)/2)+1
     Button.size.height = 8+1
    Button.position.x = Screen[1]/2 - ((Screen[1]/2)/2) +1
     Button.position.y = 1--(Screen[2]/2) - Button.size.height/2

    Button.title.position.x = Button.position.x
     Button.title.position.y = Button.position.y
      Button.title.size.width = #title
       Button.title.size.height = 2 --размер 2 патушто само сообщение + разделитель

    Button.dialogue_button.position.x = Button.position.x + (Button.size.width/2)- (#buttonMessage/2)
    Button.dialogue_button.position.y = Button.position.y + (Button.size.height)
   -- message_position.x = 
   
--создание тени
    gsB(0x696969);gsF(0x000000)
    gF(Button.position.x+1,Button.position.y+1,Button.size.width, Button.size.height, " ")
   
--основа, верхний слой
    gsF(0xFFFFFF);gsB(0xFFDB00)
    gF(Button.position.x,Button.position.y, Button.size.width, Button.size.height, " ")
    gsF(0x000000)
    gpu.fill(Button.position.x, Button.position.y+1, Button.size.width, 1, "-")

--заголовок
    gsF(0x000000); gsB(0xB4B4B4)
    gpu.set(Button.title.position.x, Button.title.position.y, title)

--место для информации
    gsB(0xFFDB00)
    gpu.set(Button.position.x, Button.title.position.y+Button.title.size.height, message)

--кнопка управления
    gsB(0x6692FF)
    gpu.set(Button.dialogue_button.position.x , Button.dialogue_button.position.y-2, buttonMessage)
end

function Button:setPosition(posX, posY)
    Button.position.x = posX
    Button.position.y = posY
end]]

function Button:setSize(sizeWidth, sizeHeight)
    if sizeHeight == nil or sizeWidth == nil or sizeHeight < 0 or sizeWidth < 0 then
        print("bad arguments. cannot set size")
    end
    Button.size.width = sizeWidth
    Button.size.height = sizeHeight
end

function Button:make(title, message, buttonMessage, posX, posY, sizeWidth, sizeHeight)

    Button.size.width = sizeWidth
     Button.size.height = sizeHeight
    Button.position.x = posX
     Button.position.y = posY

    Button.title.position.x = Button.position.x
     Button.title.position.y = Button.position.y
      Button.title.size.width = #title
       Button.title.size.height = 2 --размер 2 патушто само сообщение + разделитель

    Button.dialogue_button.position.x = Button.position.x + (Button.size.width/2)- (#buttonMessage/2)
    Button.dialogue_button.position.y = Button.position.y + (Button.size.height)
   -- message_position.x = 
   
--создание тени
    gsB(0x696969);gsF(0x000000)
    gF(Button.position.x+1,Button.position.y+1,Button.size.width, Button.size.height, " ")
   
--основа, верхний слой
    gsF(0xFFFFFF);gsB(0xFFDB00)
    gF(Button.position.x,Button.position.y, Button.size.width, Button.size.height, " ")
    gsF(0x000000)
    gpu.fill(Button.position.x, Button.position.y+1, Button.size.width, 1, "-")

--заголовок
    gsF(0x000000); gsB(0xB4B4B4)
    gpu.set(Button.title.position.x, Button.title.position.y, title)

--место для информации
    gsB(0xFFDB00)
    gpu.set(Button.position.x, Button.title.position.y+Button.title.size.height, message)

--кнопка управления
    gsB(0x6692FF)
    gpu.set(Button.dialogue_button.position.x , Button.dialogue_button.position.y-2, buttonMessage)

end


Console.log = function(message, ...)
    local x = ...
    local lastColor = nil
    if #message < 40 then
        if x ~= nil then
            lastColor = gpu.setForeground(x)
        end
        print(message)
    else
        message[#message/2] = '\n'
        print(message)
    end
    if lastColor then
        gpu.setForeground(lastColor)
    end
end

function GUI:clearScreen()
    local lastColor = gsB(BACKGROUNDCOLOR)
    gF(0,0,localscreenSizeX, screenSizeY, ' ')
    gsB(lastColor)
end


function GUI:logError(message)

    local previous = {gsF(0xFF0000), gsB(0x000000)}
    GUI.Button:make(" ERROR ", (" " .. tostring(message) .. " "), " OK ")
    gsF(previous[1])
    gsB(previous[2])
end


function GUI.button:RedrawPosition(tNewPosition, tContent)
    local prev1 = gsF(BACKGROUNDCOLOR)
    local prev2 = gsB(BACKGROUNDCOLOR)
    gpu.fill(Button.position.x, Button.position.y, Button.size.width, Button.size.height, " ")
    Button.position.x = tNewPosition.x
    Button.position.y = tNewPosition.y
    Button.size.width = tNewPosition.width
    Button.size.height = tNewPosition.height
    Button:make(tostring(tContent[1]), tostring(tContent[2]), tostring(tContent[3]), Button.position.x, Button.position.y, Button.size.width, Button.size.height)
    gsF(prev1)
    gsB(prev2)
end


local function getLongestStringLength(tStrings)
    local longest = #tStrings[1]
    for k, v in pairs(tStrings) do
        if #v > longest then
            longest = #v
        end
    end
    return longest
end


function GUI.Context:Draw(posX, posY, contextNames, contextCallbacks)
    local prev1 = gsF(0xFFFFFF)
    local prev2 = gsB(0x000000)
    gpu.fill(posX, posY, getLongestStringLength(contextNames) + 2, #contextNames, " ")
    local tmpY = posY
    for k, v in pairs(contextNames) do
        gpu.set(posX, tmpY, " -" .. v .. "")
        tmpY = tmpY + 1

        local element = {}
        element["Xpos"] = posX
        element["Ypos"] = tmpY
        element["Width"] = #v
        element["Height"] = 1
        element["isVisible"] = true

        Container:addElement(element, contextCallbacks[k])
    end
    gsF(prev1)
    gsB(prev2)
end


return GUI

--TODO:
--добавлять кликабельные зоны