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
  if math.abs(value) < math.pow(1000,mapBase) then
    value = 0
  end 
  local map = {"m","","K","M"}
  local power = math.floor(math.min(mapBase + #map - 1, math.max(math.log(math.abs(value),1000), mapBase)))
  if(value == 0) then power = 0 end
  return string.format("%4.3g ",value/(math.pow(1000,power))) .. map[power - mapBase + 1]
end

gpu.setForeground(0xFFFFFF)
gpu.setBackground(0x000000)
gpu.fill(1, 1, w, h, " ") -- clears the screen

local posX = 10
local posY = 3
local vumeterDeltyY = 2


gpu.set(posX,posY, "Grid state") 
posY = posY + 1

voltageVuMeter = VuMeter:create(
  "Grid voltage", "V",
  posX,posY,
  30, 1,
  600, 1000,
  {{600, 1000, 0xFF0000},
   {700, 900, 0xFFFF00},
   {750, 850, 0x00FF00}} 
)
posY = posY + vumeterDeltyY

bunker1BatteryCharge = VuMeter:create(
  "Battery energy", "%",
  posX,posY,
  30, 1,
  0, 100,
  {{0, 100, 0xFF0000},
   {10, 100, 0xFFFF00},
   {20, 90, 0x00FF00}} 
)
posY = posY + vumeterDeltyY

bunker1BatteryPower = VuMeter:create(
  "Battery power", "W",
  posX,posY,
  30, 1,
  -1250, 1250,
  {{-1250, 1250, 0xFF0000},
   {-1000, 1000, 0xFFFF00},
   {-750, 0, 0x0000FF},
   {0, 750, 0x00FF00}} 
)
posY = posY + vumeterDeltyY


posY = posY + 1
gpu.set(posX,posY, "Producers") 
posY = posY + 1


factory1SolarPower = VuMeter:create(
  "Solar power", "W",
  posX,posY,
  30, 1,
  0, 1000,
  {{0, 1000, 0x00FF00}} 
)
posY = posY + vumeterDeltyY

windPower = VuMeter:create(
  "Wind power", "W",
  posX,posY,
  30, 1,
  0, 400,
  {{0, 400, 0x00FF00}} 
)
posY = posY + vumeterDeltyY

coalPower = VuMeter:create(
  "Coal power", "W",
  posX,posY,
  30, 1,
  0, 500,
  {{0, 500, 0x00FF00}} 
)
posY = posY + vumeterDeltyY

posY = posY + 1
gpu.set(posX,posY, "Consumers") 
posY = posY + 1


factoryPower = VuMeter:create(
  "Factory power", "W",
  posX,posY,
  30, 1,
  0, 1200,
  {{0, 1200, 0x00FF00}} 
)
posY = posY + vumeterDeltyY

domesticPower = VuMeter:create(
  "Domestic power", "W",
  posX,posY,
  30, 1,
  0, 1100,
  {{0, 1100, 0x00FF00}} 
)
posY = posY + vumeterDeltyY


bunkerPower = VuMeter:create(
  "Bunker power", "W",
  posX,posY,
  30, 1,
  0, 400,
  {{0, 400, 0x00FF00}} 
)
posY = posY + vumeterDeltyY


local statePosx = 58
gpu.setBackground(0x505050)
gpu.fill(statePosx-2, 1, 1, h, " ")
gpu.setBackground(0x000000)

gpu.set(statePosx, domesticPower.posY, "Public power") 
gpu.set(statePosx, bunker1BatteryCharge.posY, "Total consumption") 
gpu.set(statePosx, voltageVuMeter.posY, "Total production") 

phase = 0
while not keyboard.isAltDown() do
  date = os.date("*t")
  t = date.hour + date.min/60.0
  
  gpu.set(10,1,os.date())


  voltageVuMeter:setValue(eln.wirelessGet("grid1_voltage")*1000)
  factory1SolarPower:setValue(eln.wirelessGet("factory1_solar_power")*1500)
  bunker1BatteryPower:setValue((eln.wirelessGet("bunker1_battery_power")*2-1)*3000)
  bunker1BatteryCharge:setValue(eln.wirelessGet("bunker1_battery_charge")*100)
  windPower:setValue((eln.wirelessGet("mountain_windturbine_power"))*1000)
  coalPower:setValue(eln.wirelessGet("powerplant1_coal_power")*600)
  factoryPower:setValue(eln.wirelessGet("factory1_consumption")*2000)
  domesticPower:setValue(eln.wirelessGet("house1_consumption")*1000)
  bunkerPower:setValue(eln.wirelessGet("bunker1_consumption")*500)
    
  publicPower = eln.wirelessGet("public_power")*500
  gpu.set(statePosx, domesticPower.posY + 1, floatToStringEn(publicPower) .. "W" .. "    ")
  gpu.set(statePosx, bunker1BatteryCharge.posY + 1, floatToStringEn(bunkerPower.value + domesticPower.value + factoryPower.value + publicPower)  .. "W" .. "    ")
  gpu.set(statePosx, voltageVuMeter.posY + 1, floatToStringEn(windPower.value + factory1SolarPower.value + coalPower.value)  .. "W" .. "    ")
 
  gpu.set(statePosx, windPower.posY + 0, "Wind turbine")
  gpu.set(statePosx + 2, windPower.posY + 1, (eln.wirelessGet("mountain_windturbine_enable") > 0.5 and "ON " or "OFF"))
 
  gpu.set(statePosx, factory1SolarPower.posY + 0, "Solar pannels")
  gpu.set(statePosx + 2, factory1SolarPower.posY + 1, (eln.wirelessGet("factory1_solar_enable") > 0.5 and "ON " or "OFF"))
 
  gpu.set(statePosx, factoryPower.posY + 0, "Factory setpoint")
  gpu.set(statePosx, factoryPower.posY + 1, floatToStringEn(eln.wirelessGet("factory1_setpoint")*100)  .. "%" .. "    ")
  
  gpu.set(statePosx, coalPower.posY + 0, "Coal setpoint")
  gpu.set(statePosx, coalPower.posY + 1, floatToStringEn(eln.wirelessGet("powerplant1_setpoint")*100)  .. "%" .. "    ")
 
    
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
