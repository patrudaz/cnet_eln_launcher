component = require("component")
keyboard = require("keyboard")
computer = require("computer")
debug = component.debug

print("hi")
local periode, speedup = ...
print(tostring(periode))
print(tostring(add))

print("timeWarp start")
local oldRealTime = computer.uptime()
while not keyboard.isAltDown() or not keyboard.isKeyDown(keyboard.keys.w) do
  os.sleep(tonumber(periode))
  local newRealTime = computer.uptime()
  local dt = newRealTime - oldRealTime
  oldRealTime = newRealTime
  debug.runCommand("/time add " .. math.floor((speedup-1)*20*dt))
end

print("timeWarp shutdown")