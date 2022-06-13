local event = require('event')
local stem = require('stem')
local robot = require("robot")

local server = stem.connect('stem.fomalhaut.me')

print('Введите адресс Stem')
local StemCode = io.read()

server:subscribe(StemCode)

while true do
  local name, channel_id, message = event.pull('stem_message')
  if name ~= nil then
    print(channel_id, message)
    
    if(message == 'w') then
      robot.forward()

    elseif(message == 'a') then
      robot.turnLeft()

    elseif(message == 's') then
      robot.back()

    elseif(message == 'd') then
      robot.turnRight()

    elseif(message == 'x') then
      robot.up()

    elseif(message == 'z') then
      robot.down()

    elseif(message == 'g') then
    robot.place()

    elseif(message == 't') then
    robot.drop()
    end

  end
end
