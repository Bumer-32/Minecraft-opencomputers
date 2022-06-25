local tunnel = component.proxy(component.list("tunnel")())
local drone = component.proxy(component.list("drone")())
local leash = component.proxy(component.list("leash")())

drone.setLightColor(0xFF0000)
drone.setStatusText("No connect")

computer.beep(900, .1)
computer.beep(800, .1)
computer.beep(700, .1)
computer.beep(1100, .1)
computer.beep(1000, .1)

while true do
  local name, _, _, _, _, message = computer.pullSignal()
  local facing = 2
  
  if name == "modem_message" then
    drone.setLightColor(0x00FFFF)
    drone.setStatusText("Ready")
    if message == "w" then
      drone.move(0, 0, -1)
    elseif message == "s" then
      drone.move(0, 0, 1)
    elseif message == "d" then
      drone.move(1, 0, 0)
    elseif message == "a" then
      drone.move(-1, 0, 0)
    elseif message == "z" then
      drone.move(0, -1, 0)
    elseif message == "x" then
      drone.move(0, 1, 0)
    elseif message == "q" then
      drone.drop(0)
    elseif message == "e" then
      for i=1, drone.inventorySize() do for i=0, 5 do drone.suck(i) end end
    elseif message == "r" then
      drone.swing(facing)
    elseif message == "f" then
      drone.place(facing)
    elseif message == "g" then
      leash.leash(0)
    elseif message == "t" then
      leash.unleash()
    elseif message == "forward" then
      facing = 2
    elseif message == "Right" then
      facing = 3
    elseif message == "Back" then
      facing = 4
    elseif message == "Left" then
      facing = 5
    end
  end
end
