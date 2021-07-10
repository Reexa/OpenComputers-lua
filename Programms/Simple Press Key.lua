local component = require ("component")
local modem = component.modem
local event = require ("event")
local gpu = component.gpu


local keys = {
	[21] = "yes", 	--Y
	[49] = "no",	--N
	[50] = "menu", 	--M
}
while true do
local e = {event.pull()}
 	if e[1] == "key_down" then
		if e[4] ~= nil then
		print("knopka: ".. e[4])
			if keys[e[4]] == "yes" then
			print("yes"..e[4])
				else if keys[e[4]] == "no"then
				print("no"..e[4])
					else if keys[e[4]] == "menu"then
					print("\nreboot?[Y\\N]\n")
						if ((io.read() or "n").."y"):match("^%s*[Yy]") then
   						print("\nRebooting now!\n")
    
						end
					end
				end
			end
		end
	else if e[1] == "touch" then
		local _, _, x, y, button, playerName = event.pull()
		print(x..'\n'..y..'\n'.. button..'\n'.. playerName)
	end
	-- place for uslovie
	end
end
