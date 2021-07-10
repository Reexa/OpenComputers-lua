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
Event.setInteractableArea = function(interactable_area)
--interactable area = {X, Y, WIDTH, HEIGHT}
	for k, v in pairs(interactable_area) do
		if k == 1 and interactable_area[k] == nil then
			
		end
	end

	for i = 1, #interactable_area, 1 do
		if (not (interactable_area[i] ~= nil and interactable_area[i] < Screen[1] and interactable_area[4] < Screen[2] and interactable_area[i] >0)) then
			print("wrong interact position")
			return nil
		end
	end
	table.insert(Event.toListen, interactable_area)

end


return Event