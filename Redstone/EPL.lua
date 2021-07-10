--Extended Peripherial Library(EPL)

local component = require ("component")
local event = require ("event")
local thread = require("thread")
local gpu = component.gpu
local Screen = {}

Screen[1], Screen[2] = gpu.getResolution()
local gsF, gsB, gF, gS = gpu.setForeground,gpu.setBackground, gpu.fill, gpu.set

Event = {

	toListen = {1,1,4,4}
}



--выполняет провер0чку на корректность данных и сажает их в таблицу для просмотра ивентором
Event.addToListen = function(listenArea)
	--пример контента на добавление
	--x1 , y1 , x2 , y2
	--проверка на выход за пределы экрана
	--if ((listenArea[3] < Screen[1] and listenArea[4] < Screen[2])) then

	table.insert(Event.toListen, listenArea)
end

function Event.GetAllInteractables()

	for i, d in Event.toListen do
		print(Event.toListen[i])
	end

end
