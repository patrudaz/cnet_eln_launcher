component = require("component")
keyboard = require("keyboard")
computer = require("computer")
eln = component.getPrimary("ElnProbe")
debug = component.debug

function wirelessSetBool(channel, value)
  eln.wirelessSet(channel, value and 1 or 0)
end

function wirelessSet(channel, value)
  eln.wirelessSet(channel, value)
end


function hourIn(t, start, stop)
  if start < stop then
    return t > start and t < stop
  else
    return t > start or t < stop
  end
end

function applyWeather()
  debug.runCommand("/weather " .. weatherToString[weatherCurrent] .. " " .. tostring(math.floor(weatherDuration + 100)))
end

print("townModel start")
math.randomseed(42)

weatherToString = {"clear","rain","thunder"}
weatherTimeScale = 10*60

weatherDuration = (0.8 + math.random() * 0.5) * weatherTimeScale  
weatherCurrent = 1
if math.random() < 2 then weatherForcast = 2 else weatherForcast = 3 end
applyWeather()

----------------------------------------------------------------------------------------
-- init coal variables
----------------------------------------------------------------------------------------

coal_signal_in  = {}
coal_signal_out = {}
temp_array      = {}

range_mean=3
delay=7

for i = 1,range_mean do
  coal_signal_in[i]  =0
  temp_array[i]      =0
end

i=1
if delay > 1 then
  
  for i = 1,delay do
    coal_signal_out[i] =0
  end
  
else
  coal_signal_out[1] =0
end

coal_real_signal=0

----------------------------------------------------------------------------------------
-- init cost variables
----------------------------------------------------------------------------------------
cost_fact = 0
cost_coal = 0

cost_grid_down = 0

cost_grid_complete = 0
limit_voltage_grid_down = 700 --Normal voltage in grid: 800V
limit_voltage_grid_up   = 950 --Normal voltage in grid: 800V
flag_fail_grid = 0

integral_cost = 10
t_s = 0
t_s_prev = 0

prev_day_cost=0
prev_day_fail=0

coal_amount_init=300000 -- amount not really in kg of coal but rather J(energy) avaiable
coal_amount=coal_amount_init -- amount not really in kg of coal but rather J(energy) avaiable

coal_bool=1 -- bool for the coal activation

day_prev=-1
day=-1
----------------------------------------------------------------------------------------

---

test_power_day=0
test_power_day_prev=test_power_day

test_sun_day=0
test_sun_day_prev=test_sun_day

----------------------------------------------------------------------------------------
-- timer
----------------------------------------------------------------------------------------

t_start=os.time()
local coalRc1 = 0
local coalRc2 = 0

t_all= 60*60*60
local oldRealTime = computer.uptime()

random_time_furnace1=100 -- random time for the furnace
end_score = 0
flag_end = false
startingDay = -1
while not keyboard.isAltDown() or not keyboard.isKeyDown(keyboard.keys.m) do
  os.sleep(0.5)
  t_s = os.time() --epoch time
  local newRealTime = computer.uptime()
  local dt = newRealTime - oldRealTime
  oldRealTime = newRealTime
  
  date = os.date("*t")
  t = date.hour + date.min/60.0
  wirelessSet("time_minecraft",t/24) 

  wirelessSet("real_time",newRealTime)
  day=date.day
  if day_prev==-1 then
    day_prev = day
	startingDay = day
  end

  
  wirelessSetBool("public_light1", hourIn(t, 19.0, 6.0))
  
  wirelessSetBool("house1_light0", hourIn(t, 20.0, 20.5) or hourIn(t,random_time_furnace1-0.5,random_time_furnace1+1.5))
  wirelessSetBool("house1_light1", hourIn(t, 18.0, 22.0) or hourIn(t, 6.5, 7.7) or hourIn(t,random_time_furnace1-0.5,random_time_furnace1+1.5))
  wirelessSetBool("house1_light2", hourIn(t, 21.0, 23.0) or hourIn(t, 6.0, 7.0) or hourIn(t,random_time_furnace1-0.5,random_time_furnace1+1.5))
  wirelessSetBool("house1_furnace", hourIn(t, 11.5, 12.5) or hourIn(t, 19.0, 20.0) or hourIn(t,random_time_furnace1-0.5,random_time_furnace1+1.5))
  
  wirelessSetBool("factory1_light1", hourIn(t, 7.0, 18.0))
  wirelessSetBool("factory1_light2", hourIn(t, 7.5, 17.5))
  eln.wirelessSet("factory1_setpoint_filtred", eln.wirelessGet("factory1_setpoint"))
  --wirelessSetBool("factory1_setpoint", hourIn(t, 8.0, 17.0))
  -- if hourIn(t, 8.0, 18.0) then
  --   eln.wirelessSet("factory1_setpoint_filtred", eln.wirelessGet("factory1_setpoint"))
  -- else
  --   eln.wirelessSet("factory1_setpoint_filtred", 0.0)
  -- end
  
  weatherDuration = weatherDuration - dt
  if weatherDuration <= 0 then
    if weatherForcast ~= 1 then
      weatherCurrent = weatherForcast
      weatherDuration = (0.25 + math.random() * 0.25) * weatherTimeScale
      weatherForcast = 1
    else
      weatherCurrent = weatherForcast
      weatherDuration = (1 + math.random() * 1) * weatherTimeScale  
      if math.random() < 2 then weatherForcast = 2 else weatherForcast = 3 end -- Only rain
    end
    applyWeather()
  end
  eln.wirelessSet("weather_forecast", (weatherForcast-1)/2)
  eln.wirelessSet("weather_forecast_countdown", math.min(1.0*weatherDuration/weatherTimeScale,1.0))

  ----------------------------------------------------------------------------------------
  -- -- Delay and low pass of the coal
  ----------------------------------------------------------------------------------------
  
  -- append/pop signal
  set_point=eln.wirelessGet("powerplant1_setpoint")
  table.insert(coal_signal_in, set_point)
  table.remove(coal_signal_in, 1)

  -- mean signal
  sum_signal=0
  for i=1,range_mean do
    sum_signal = sum_signal+coal_signal_in[i]
  end
  sum_signal = sum_signal/range_mean

  -- append/pop temp
  table.insert(temp_array, sum_signal)
  table.remove(temp_array, 1)  

  -- mean temp
  sum_signal=0
  for i=1,range_mean do
    sum_signal = sum_signal+temp_array[i]
  end
  sum_signal = sum_signal/range_mean

  
  -- append pop signal out (the delay)
  table.insert(coal_signal_out, sum_signal)
  table.remove(coal_signal_out, 1) 

  coal_out=coal_signal_out[1]

  ----------------------------------------------------------------------------------------
  -- -- Computation of the cost
  ----------------------------------------------------------------------------------------

  -- Take the different elements
  fact = 2000*eln.wirelessGet('factory1_consumption') 
  coal = 600*eln.wirelessGet('powerplant1_coal_power')
  grid = 1000*eln.wirelessGet("grid1_voltage")
  house = 1000*eln.wirelessGet("house1_consumption")
  sun = 1000*eln.wirelessGet("factory1_solar_power")
  soc = eln.wirelessGet("bunker1_battery_charge")
  bttr = (eln.wirelessGet("bunker1_battery_power")*2-1)*3000 

  -- Check if grid is still up
  if grid < limit_voltage_grid_down or grid > limit_voltage_grid_up then
    flag_fail_grid = 1
  else
    cost_grid_down = 0
  end

  -- Decrease coal amount
  coal_amount = coal_amount - coal*dt -- dt is about 1 anyway

  eln.wirelessSet("coal_amount",coal_amount/coal_amount_init)

  if coal_amount <=0 then
    coal_bool = 0 --if there's no coal anymore, switch off the factory
  end

  -- compute the energy comsumed

  power_all=house

  test_power_day = test_power_day + power_all*dt

  test_sun_day = test_sun_day + sun*dt

  -- -- Compute the cost

  -- 1
  -- cost_grid_complete = fact - (coal*coal) --coal is squared as to minimize it with greater way than maximizing the factory
  -- 2 take the energy in case dt is not exactly 1
  -- cost_grid_complete = fact*dt - coal*coal*dt*dt
  -- 3 Simple. Will have to optimize to use solar
  -- cost_grid_complete = fact - coal
  -- 4 Simple. Will have to optimize to use solar
  -- cost_grid_complete = fact*dt - coal*dt

  cost_fact = cost_fact + fact*dt
  cost_coal = cost_coal + coal*dt

  eln.wirelessSet("factory1_energy",cost_fact/3600000)
  eln.wirelessSet("end_score",end_score/3600000)

  if t == 0 or day ~= day_prev then -- reset at each start of the day/ log past day result
    -- prev_day_cost = integral_cost
    -- prev_day_fail = flag_fail_grid  
    -- integral_cost = 0
    -- flag_fail_grid = 0
    -- coal_bool = 1
    if (day-startingDay) % 3 == 0 then
      coal_amount = coal_amount_init
      integral_cost = 0
      cost_fact = 0
      cost_coal = 0
      flag_fail_grid = 0
      coal_bool = 1

      t_start = t_s
    end
    day_prev=day

    random_time_furnace1=math.random(1,22) 

    test_power_day_prev=test_power_day
    test_power_day=0

    test_sun_day_prev=test_sun_day
    test_sun_day=0
  end
  ----------------------------------------------------------------------------------------


  -- send coal signal
  coal_real_signal=coal_out
  coalRc2 = coalRc2 + (coalRc1-coalRc2)*0.05*dt
  coalRc1 = coalRc1 + (coal_real_signal-coalRc1)*0.05*dt

  coalRc2 = coalRc2 * coal_bool

  eln.wirelessSet("coal_real",coalRc2)

  -- Display

  os.execute("clear")  

  print(day)
  print('---------------------------------------------')

  print('Today\'s score')
  print('Time (game):',  date.hour,'h' ,date.min)

  if flag_fail_grid == 1 then
    print('XXXXXXXXXXXXXXXXXXXXXXXXXXXX')
    print('Grid Failure!')
    print('XXXXXXXXXXXXXXXXXXXXXXXXXXXX')
  else
    print('Factory:',cost_fact)
    print('Coal   :',cost_coal)
    print('Remaining coal:',math.floor(coal_amount)," J") 
  end


  --print(dt)
  --print(coal)
  -- print(day)

  if t_s - t_start > t_all or flag_end then
    print('END OF SIMULATION!')
    if flag_end==false then
      flag_end = true --Make this computation only once
      display_cost_fact=cost_fact
      display_cost_coal=cost_coal
      display_coal_amount=coal_amount
      display_soc=soc

      if soc >= 0.5 then
        end_score = cost_fact
      else
        end_score = cost_fact * (1-(0.5-soc))
      end
    end
    print('Score factory    : ', display_cost_fact)
    print('Score powerplant : ', display_cost_coal)
    print('Remaining coal   : ', display_coal_amount)
    print('Battery SoC      : ', display_soc)
    print('End Score        : ', end_score)
    print('Did the grid survive?')
    if flag_fail_grid == 1 then
      print('No...')
    else
      print('Yes !')
    end
  end

end

print("townModel shutdown")
