local camera = component.camera
local gpu = component.gpu
local array = " .,-=+xX#"
local yp = 1
local x, y = gpu.getResolution()
gpu.fill(1,1,x,y," ")

for j = -0.35,0.25,0.025 do
  for i = -1,1,0.036 do
    local d = camera.distance(i, 0-j)
    print(d)
    local a = 1
    if d > 0 then a = 2 + (8 - math.min(8, (d/1.2))) end
    print(string.sub(array, a, a))
  end
  yp=yp+1
end