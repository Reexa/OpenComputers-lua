local event = require("event")
local Container = require("/poPAD_OS/Container")
local gui = require("/poPAD_OS/GUIlibrary")
local component = require("component")
local gpu = component.gpu
Events = {}

local times = 1


function Events:checkClickableArea(cursirPos, checkableArea)
    --return ((cursirPos[1] >= checkableArea[1] and cursirPos[2] >= checkableArea[2] and cursirPos[2] <= checkableArea[3] and cursirPos[1] <= checkableArea[4]))
    if cursirPos[1] >= checkableArea[1] and cursirPos[2] >= checkableArea[2] and cursirPos[2] <= checkableArea[3] and cursirPos[1] <= checkableArea[4] then
        return true
    end
    return false
end


function Events:onMouseClick(...)
    --проверять каждый раз тык на прикосновение к элементу
    --если по элементу -определить по какой его части
    --выполнить функцию, которая обрабатывает прикосновение к этому элемент
    local TESTCLICKABLEAREA = {(ScreenSize[1]/2) - 10, (ScreenSize[2]/2) - 10, (ScreenSize[1]/2) + 10, (ScreenSize[2]/2) + 10}
    local prev = gpu.setForeground(0x000000)
    gpu.fill(TESTCLICKABLEAREA[1],TESTCLICKABLEAREA[2], 10, 10, " ")
    gpu.setForeground(prev)
    local eventInfo = {...}
    print("X: " .. eventInfo[2])
    print("Y: " .. eventInfo[3])
    local clickPos = {eventInfo[2], eventInfo[3]}
    for k,v in pairs(eventInfo)do
        print("click info(Event.lua, 23): " .. v)
    end
    for k, v in pairs(Container) do
        print(tostring(k) .. "\t" .. tostring(v))
        print(Container["id"])
    end
    if Events:checkClickableArea(clickPos, TESTCLICKABLEAREA) == true then
        print("clicked")
    else
        print("not clicked")
    end
end
--[[
    local function onMouseClick(...)
    --проверять каждый раз тык на прикосновение к элементу
    --если по элементу -определить по какой его части
    --выполнить функцию, которая обрабатывает прикосновение к этому элементу
    eventInfo = {...}
    print("X: " .. eventInfo[3])
    print("Y: " .. eventInfo[4])
    for k,v in pairs(eventInfo)do
        print("info about click event: " .. v)
    end
end

]]

--создает ивент нажатия на экран и вызывает функцию каждый раз, когда получает ивент нажатия.
--при перезагрузке просмотр ивента спадает.
local mouseEventTouchHandle = event.listen("touch", Events.onMouseClick)
return Events
--FIXME не показывает id  ивента еслли использовать как метод класса, а не локальную функцию(фикс 18 строка)