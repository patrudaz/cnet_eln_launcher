--[[
Opencomputers Static screensaver, relive the days of CRT televisions and fill your screens with static!
This program generates nostalgic CRT static using randomly placed white and black dots.
Causes high power usage when using tier 3 screens, so plan accordingly
Press a key to cleanly end the program.
--]]


local term = require("term")
local component = require("component")
local gpu = component.gpu
local event = require("event")
local math = require("math")
running = true --should the program keep running


local reverse, maxX, maxY = false, gpu.maxResolution()

--fills a single dot to the screen in a random place
local function fillDot()
        if reverse then
         gpu.setForeground(0xFFFFFF) --set the text colour to white
       else
         gpu.setForeground(0x000000) --set text colour to black
       end
       randomx, randomy = math.random(maxX),math.random(maxY) --get a random position inside the screen.
       gpu.fill(randomx,randomy,1,1,"█") --fill a single dot
       reverse = not reverse --switch to blck from whte, vice versa
end

--exits the program cleanly, by returning gpu settings to default.
local function exitProgram()
  running = false
  gpu.setBackground(0x000000) --default
  gpu.setForeground(0xFFFFFF) --default
  term.clear()
  os.execute("clear")
  event.ignore("key_up",exitProgram) --remove the event listen
  print("Successfully ended Static.")
  os.sleep(1)
  os.exit() --kill program.
end


print("To exit cleanly once the program starts, press a key.")
os.sleep(3)
event.listen("key_up",exitProgram) --register the event listener for a key press

gpu.setForeground(0xFFFFFF)
gpu.setBackground(0xFFFFFF) --set the background colour to white
gpu.fill(1,1,maxX,maxY," ") --fill screen with white

--keep the program running
while running do
  for i = 0,6 do --run fillDot multiple times quickly, to speed up dot creation
    fillDot()
  end
        os.sleep(0.01) --prevent fail yield
end
--eof
