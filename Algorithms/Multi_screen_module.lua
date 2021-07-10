local component = require("component")
local event = require ("event")

addresses = {}

function Check(inputTable)
	--outputting all values of table
	local testingTable = {}
for key, value in inputTable do
	print(key .. '\t' .. value)
	end end
	--shold to name is TblTest

function screenGetter()
local counter = 0
for  address, componentType in component.list("screen") do
table.insert(addresses, address)
print(counter ..'\t'..address.. '\r')
counter = counter + 1 

end
return counter end 

function screenSwitcher(counter)
	for address, componentType in component.getPrimary("screen") do print(address, componentType) end
--if (tupa == currentScreen) then --TODO currentScreen problem
--	print("jojo reference")
--	else component.setPrimary("screen", addresses[j])
 --end end
end
 


screenSwitcher(screenGetter())