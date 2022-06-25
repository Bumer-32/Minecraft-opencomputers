local component = require("component")
local computer = require("computer")
local event = require("event")
local tunnel = component.tunnel
local stem = require("stem")

local server = stem.connect('stem.fomalhaut.me')

computer.beep(900, .1)
computer.beep(1000, .1)
computer.beep(1100, .1)

print("Введите адресс stem")
local StemCode = io.read()

computer.beep(1200, .1)
computer.beep(1200, .1)

server:subscribe(StemCode)

while true do
  local name, channel_id, message = event.pull('stem_message')
  if name ~= nil then
    print(channel_id, message)
    tunnel.send(message)
    
    if message == "quit" then
    break
    end
  end
end