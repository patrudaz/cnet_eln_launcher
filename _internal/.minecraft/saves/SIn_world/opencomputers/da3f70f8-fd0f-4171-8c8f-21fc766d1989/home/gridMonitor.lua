component = require("component")
keyboard = require("keyboard")
eln = component.getPrimary("ElnProbe")
local gpu = component.gpu 
local w, h = gpu.getResolution()

function wirelessSetBool(channel, value)
  return 
  eln.wirelessSet(channel, value and 1 or 0)
end

VuMeter = {}
VuMeter.__index = VuMeter

function VuMeter:create(name, unit, posX, posY, width, height, left, right, colors)
  local self = {}
  setmetatable(self,VuMeter)  -- make Account handle lookup
  self.unit = unit
  self.posX   = posX   
  self.posY   = posY   
  self.width  = width  
  self.height = height 
  self.right  = right
  self.left    = left
  self.colors = colors 
  self.value  = nil
  self.maxEvent  = nil
  self.minEvent  = nil
  
  gpu.setBackground(0x404040)
  --gpu.fill(posX-1, posY-1, width+2, height+2, " ")
  for _, v in ipairs(self.colors) do 
    left = self:valueToPosY(v[1])
    right = self:valueToPosY(v[2])
    gpu.setBackground(v[3])
    gpu.fill(left, self.posY, right - left, self.height, " ")
  end
  

  gpu.setBackground(0x000000)
  gpu.set(posX + width + 1, posY, name)
  
  return self
end

function VuMeter:setValue(value)
  if self.value == nil then
    self.maxEvent = value
    self.minEvent = value
    self.value = value
  end
  gpu.set(self:valueToPosY(self.value),self.posY + self.height, " ")
  gpu.set(self:valueToPosY(self.maxEvent),self.posY + self.height, " ")
  gpu.set(self:valueToPosY(self.minEvent),self.posY + self.height, " ")
  self.value = value
  self.maxEvent = math.max(value, self.maxEvent)
  self.minEvent = math.min(value, self.minEvent)
  gpu.setForeground(0x505050)
  gpu.set(self:valueToPosY(self.maxEvent), self.posY + self.height, "▲") 
  gpu.set(self:valueToPosY(self.minEvent), self.posY + self.height, "▲") 
  gpu.setForeground(0xFFFFFF)
  gpu.set(self:valueToPosY(self.value), self.posY + self.height, "▲") 
  gpu.set(self.posX + self.width + 1, self.posY + 1, floatToStringEn(self.value) .. self.unit .. "    ")
end

function VuMeter:valueToPosY(value)
  return self.posX + (self:trunk(value) - self.left)/(self.right - self.left)*self.width
end

function VuMeter:clear()
  gpu.set(self:valueToPosY(self.maxEvent),self.posY + self.height, " ")
  gpu.set(self:valueToPosY(self.minEvent),self.posY + self.height, " ")
  local value = self.value
  self.value  = nil
  self.maxEvent  = nil
  self.minEvent  = nil
  self:setValue(value)
end

function VuMeter:trunk(value)
  if self.right > self.left then
    return math.min(self.right,math.max(self.left, value))
  else
    return math.min(self.left,math.max(self.right, value))
  end
end

function floatToStringEn(value)
  local mapBase = -1
  local map = {"m","","K","M"}
  local power = math.floor(math.min(mapBase + #map - 1, math.max(math.log(math.abs(value),1000), mapBase)))
  return string.format("%4.3g ",value/(math.pow(1000,power))) .. map[power - mapBase + 1]
end

gpu.setForeground(0xFFFFFF)
gpu.setBackground(0x000000)
gpu.fill(1, 1, w, h, " ") -- clears the screen

voltageVuMeter = VuMeter:create(
  "Grid voltage", "V",
  10,2,
  30, 1,
  600, 1000,
  {{600, 1000, 0xFF0000},
   {700, 900, 0xFFFF00},
   {750, 850, 0x00FF00}} 
)

factory1SolarPower = VuMeter:create(
  "Factory solar power", "W",
  10,5,
  30, 1,
  0, 1000,
  {{0, 1000, 0x00FF00}} 
)

bunker1BatteryPower = VuMeter:create(
  "Bunker battery power", "W",
  10,8,
  30, 1,
  -3000, 3000,
  {{-3000, 3000, 0xFF0000},
   {-2000, 2000, 0xFFFF00},
   {-1500, 1500, 0x00FF00}} 
)

bunker1BatteryCharge = VuMeter:create(
  "Bunker battery charge", "%",
  10,11,
  30, 1,
  0, 100,
  {{0, 100, 0xFF0000},
   {10, 100, 0xFFFF00},
   {20, 90, 0x00FF00}} 
)


phase = 0
while not keyboard.isAltDown() do
  date = os.date("*t")
  t = date.hour + date.min/60.0
  
  gpu.set(10,1,os.date())


  voltageVuMeter:setValue(eln.wirelessGet("grid1_voltage")*1000)
  factory1SolarPower:setValue(eln.wirelessGet("factory1_solar_power")*1000)
  bunker1BatteryPower:setValue((eln.wirelessGet("bunker1_battery_power")*2-1)*3000)
  bunker1BatteryCharge:setValue(eln.wirelessGet("bunker1_battery_charge")*100)
    
  if keyboard.isKeyDown(keyboard.keys.c) then
    voltageVuMeter:clear()
    factory1SolarPower:clear()
    bunker1BatteryPower:clear()
    bunker1BatteryCharge:clear()    
  end
  
  phase = phase + 0.05
  if phase > 1.0 then
    phase = phase - 1.0
  end
  os.sleep(0.05)
end