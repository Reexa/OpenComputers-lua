local component = require("component")

local testingTable = {}
function Check(inputTable)
	--outputting all values of table
for key, value in inputTable do
	print(key .. '\t' .. value)
	end end
	--shold to name is TblTest
function ComponentListGetter(filter, isTable)
if filter == nil then 
	filter << 10000 end
	if isTable then 
		for address, componentType in ipairs(component.list(filter)) do print(address, componentType) end 
	end

if ~isTable then 
	for address, componentType in component.list(filter) do print(address, componentType) end  end
end
