local component = require("component")
local colors = require("colors")
local gpu = component.gpu 
local w, h = gpu.getResolution()

phase = 0.0
for i=1,10 do
  gpu.setForeground(0xFFFFFF)
  gpu.setBackground(0x000000)
  gpu.fill(1, 1, w, h, " ") -- clears the screen
  gpu.setBackground(0x0000FF)
  for i=1,w  do
    gpu.set(i, math.sin(phase + i/10)*h/3+h/2, ' ')
  end

  gpu.setBackground(0x00FF00)
  for i=1,w  do
    gpu.set(i, math.sin(phase + i/10+ 2.0933333333333333333333333333333)*h/3+h/2, ' ')
  end

  gpu.setBackground(0xFF0000)
  for i=1,w  do
    gpu.set(i, math.sin(phase + i/10-2.0933333333333333333333333333333)*h/3+h/2, ' ')
  end
  phase = phase + 3.14/2/20
  os.sleep(0.1)
end