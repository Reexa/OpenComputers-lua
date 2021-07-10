local component = require("component")
--local modem = component.modem
local event = require("event")
local gpu = component.gpu
local thread = require("thread")

--локальные библиотеки
local epl = require("epl")

Screen = {gpu.getResolution()}
Console = {}
Button = {

    size =      {width, height},
    position =  {x, y},
    title =     {position = {x,y},
    size =      {width, height},},
    message_position =  {x,y,},
    dialogue_button  =  {position = {x,y,},
                         size = {x,y},
                         interactable = {x1,y1,x2,y2,}}
                         
}
local gsF, gsB, gF, gS = gpu.setForeground,gpu.setBackground, gpu.fill, gpu.set



function makeButton(title, message, buttonMessage)
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
    Button.dialogue_button.size.x = Button.dialogue_button.position.x + #buttonMessage
    Button.dialogue_button.size.y = Button.dialogue_button.position.y
   -- message_position.x = 
   
--создание тени
    gsB(0x2D2D2D);gsF(0x000000)
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

--описание зоны взаимодействия
    Button.dialogue_button.interactable.x1 = Button.dialogue_button.position.x
    Button.dialogue_button.interactable.y1 = Button.dialogue_button.position.y
    Button.dialogue_button.interactable.x2 = Button.dialogue_button.position.x + Button.dialogue_button.size.x
    Button.dialogue_button.interactable.y2 = Button.dialogue_button.position.y + Button.dialogue_button.size.y

--добавление в таблицу для обработки ивентором
    Event.addToListen({Button.dialogue_button.interactable.x1, Button.dialogue_button.interactable.y1, Button.dialogue_button.interactable.x2, Button.dialogue_button.interactable.y2})
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

function CheckClickableArea(MouseClickedPixel, ClickableArea)
    if MouseClickedPixel[1] >= ClickableArea[1] then
        if MouseClickedPixel[2] >= ClickableArea[2] then
            if MouseClickedPixel[1] <= ClickableArea[3] then
                if MouseClickedPixel[2] <= ClickableArea[4] then
                    return true
                end
            end
        end
    end

    return false
end

function GraphByte(value)
    local i = 1
    local bitCounter = 0
    local bits = {0,0,0,0, 0,0,0,0}
    --LittleEndian

    while i < 128 do
        bitCounter = bitCounter + 1
        if value and i then
            bits[bitCounter] = 1
        end
        i = i * 2
    end
    return bits
end

--start detached thread
local t = thread.create(function()
    while true do
        local id, x, y = event.pull("touch")
            --if x >= Event.toListen[1][1] and x <= Event.toListen[1][3] and y >= Event.toListen[1][2] and y <= Event.toListen[1][4] then
            if CheckClickableArea({x,y},Button.dialogue_button.interactable) then
                --print("\n clicked on interactable zone")
                gsB(0x000000)
                gS(Screen[1]/2, Screen[2], "jija")
                --gF(Button.position.x, Button.position.y, Button.size.width, Button.size.height, ' ')
            end
            print(id..'\t' ..x, y)
    end
end
):detach()


local function makeSeparator(foregroundColor, backgroundColor, character)

    for y = 0, Screen[2] do
        gpu.setBackground(backgroundColor)
        gpu.setForeground(foregroundColor)
        gpu.set((Screen[1]/2 - ((Screen[1]/2)/2)), y, character)

    end

end

function renderInterface()

	gsF(0x000000)
	local temp = gpu.setBackground(0xFFFFFF)
	gpu.fill(0,0, Screen[1], Screen[2], " ")
	gpu.setBackground(temp)
	makeSeparator(0x000000, 0xFFFFFF, "|")
	makeButton(" Сообщение ", " C твоим компом опять хуйня! ", " Блядь! ")
	gsB(0xFFFFFF)
	Console.log("test log\n".."X1: " .. Button.position.x.." Y1: " .. Button.position.y.. "\nX2: "..Button.position.x+Button.size.width.. " Y2: "..Button.position.y+Button.size.height)
	print("testing function...")
	local clicked = {6, 2}
	local testingArea = {1,1,4,4}
	print(CheckClickableArea(clicked, testingArea))

end
--main
local toRender = true
while true do
    os.sleep()

    if(toRender) then
        toRender = false
        renderInterface()
    end
   -- if(CheckClickableArea(, Button.dialogue_button.interactable))then
    --    gsF(0x000000)

   -- end
        --Event:addToListen(Button.dialogue_button.interactable)

end

