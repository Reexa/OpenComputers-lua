--Extended Peripherial Library(EPL)

local component = require ("component")
local event = require ("event")
local thread = require("thread")
local gpu = component.gpu
local Screen = {}

Screen[1], Screen[2] = gpu.getResolution()

Event = {

	toListen = {}
}


Event.mouseListener = thread.create(function ()
		while true do
			print("listen")
			os.sleep()
			local id, _, x, y = event.pullMultiple("touch", "interrupted")
			if id == "interrupted" then
				print("soft interrupt, closing")
			break
			elseif id == "touch" then
				if x >= Event.toListen[1][1] and x <= Event.toListen[1][3] and y >= Event.toListen[1][2] and y <= Event.toListen[1][4] then
					print("\n clicked on interactable zone")
				end
				print(id..'\t' ..x, y)
			end
		end
	end
	):detach()
--выполняет провер0чку на корректность данных и сажает их в таблицу для просмотра ивентором
Event.addToListen = function(listenArea)

	for i = 1, #listenArea, 1 do
		if (not (listenArea[i] ~= nil and listenArea[i] < Screen[1] and listenArea[4] < Screen[2] and listenArea[i] >0)) then
			print("wrong interact position")
			return nil
		end
	end
	table.insert(Event.toListen, listenArea)

end


return Event