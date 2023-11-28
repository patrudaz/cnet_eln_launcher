local component = require("component")
local colors = require("colors")
local gpu = component.gpu 
local w, h = gpu.getResolution()
local keyboard = require("keyboard")

function newFramebuffer()
  local buffer = {}
  for y=1,h  do
    line = {}
    for x=1,w  do
      line[x] = 0
    end
    buffer[y] = line
  end
  return buffer
end


local screenBuffer = newFramebuffer()
local gpuBuffer = newFramebuffer()
gpu.setForeground(0xFFFFFF)
gpu.setBackground(0x000000)
gpu.fill(1, 1, w, h, " ") -- clears the screen

local palette = {0x0000FF, 0x00FF00, 0xFF0000}
palette[0] = 0x000000

function swap()
  for y=1,h  do
    local gpuLine = gpuBuffer[y]
    local screenLine = screenBuffer[y]
    for x=1,w  do
      if gpuLine[x] ~= screenLine[x] then
        gpu.setBackground(palette[gpuLine[x]])
        gpu.set(x, y, ' ')
      end
      screenLine[x] = 0
    end
  end
  
  tmp = screenBuffer
  screenBuffer = gpuBuffer
  gpuBuffer = tmp
end




phase = 0.0

while not keyboard.isAltDown() do
  for i=1,w  do
    gpuBuffer[math.floor(math.sin(phase + i/10)*h/3+h/2)][i] = 1
  end

  for i=1,w  do
    gpuBuffer[math.floor(math.sin(phase + i/10 + 2.0933333333333333333333333333333)*h/3+h/2)][i] = 2
   -- gpu.set(i, math.sin(phase + i/10+ 2.0933333333333333333333333333333)*h/3+h/2, ' ')
  end

  for i=1,w  do
    gpuBuffer[math.floor(math.sin(phase + i/10 - 2.0933333333333333333333333333333)*h/3+h/2)][i] = 3
  --  gpu.set(i, math.sin(phase + i/10-2.0933333333333333333333333333333)*h/3+h/2, ' ')
  end
  swap()
  phase = phase + 3.14/2/10
end