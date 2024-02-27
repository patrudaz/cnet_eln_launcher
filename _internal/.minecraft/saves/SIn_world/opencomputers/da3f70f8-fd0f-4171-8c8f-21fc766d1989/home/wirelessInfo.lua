component = require("component")
keyboard = require("keyboard")
eln = component.getPrimary("ElnProbe")


print("wirelessInfo start")
while true do
  date = os.date("*t")
  t = date.hour + date.min/60.0

  eln.wirelessSet("clock", t/24.0)

  os.sleep(1)
end

print("wirelessInfo shutdown")