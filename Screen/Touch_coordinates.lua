local component = require("component")
local gpu = component.gpu
local SurfacePos = {0,0}
ScreenCoord = {}
function placeSurface(Table)

if #Table == 0 then
    table.insert(Table, {0,0})
else
    table.insert(Table, {})

end
end
placeSurface(ScreenCoord)