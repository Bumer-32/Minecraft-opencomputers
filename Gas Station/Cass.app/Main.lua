local component = require("Component")
local system = require("System")
local filesystem = require("Filesystem")
local event = require("Event")
local gui = require("GUI")
local image = require("Image")

local modem = component.modem
---------------------------------------------------------------------------------------------------

local resouces = filesystem.path(system.getCurrentScript())

local prices = {}
local selected
---------------------------------------------------------------------------------------------------
--треба зробити робочу зону та вікно
local workspace, window = system.addWindow(gui.titledWindow(1, 1, 80, 30, "Cass", true))
--також зону вікна
local layout = window:addChild(gui.layout(1, 2, window.width, window.height - 1, 1, 1))
layout:setGridSize(2, 1)

--зміна розміру
window.onResize = function(newWidth, newHeight)
  
  window.backgroundPanel.width, window.backgroundPanel.height = newWidth, newHeight
  layout.width, layout.height = newWidth, newHeight
  window.titlePanel.width = newWidth
  window.titleLabel.width = newWidth
end


--загрузка, поля для цін і кнопка відпраки туди же
local progressIndicator = layout:setPosition(1, 1, layout:addChild(gui.progressIndicator(1, 1, 0xdbdbdb, 0x00b640, 0x99FF80)))
local gas92 = layout:setPosition(1, 1, layout:addChild(gui.input(1, 1, 17, 3, 0xdbdbdb, 0x353535, 0x999999, 0xAAAAAA, 0x2D2D2D, "", "92-гий бензин"))) 
local gas98 = layout:setPosition(1, 1, layout:addChild(gui.input(1, 1, 17, 3, 0xdbdbdb, 0x353535, 0x999999, 0xAAAAAA, 0x2D2D2D, "", "98-мий бензин")))
local diesel = layout:setPosition(1, 1, layout:addChild(gui.input(1, 1, 17, 3, 0xdbdbdb, 0x353535, 0x999999, 0xAAAAAA, 0x2D2D2D, "", "Дизельне пальне")))
local send = layout:setPosition(1, 1, layout:addChild(gui.button(1, 1, 17, 3, 0xdbdbdb, 0x000000, 0xAAAAAA, 0x0, "Відобразити")))

text92 = layout:setPosition(1, 1, layout:addChild(gui.text(1, 1, 0x000000, "92-гий = ")))
text98 = layout:setPosition(1, 1, layout:addChild(gui.text(1, 1, 0x000000, "98-мий = ")))
textDiesel = layout:setPosition(1, 1, layout:addChild(gui.text(1, 1, 0x000000, "Дизельне пальне = ")))

  
local comboBox = layout:setPosition(2, 1, layout:addChild(gui.comboBox(1, 1, 22, 3, 0xdbdbdb, 0x000000, 0xAAAAAA, 0xdbdbdb)))
comboBox:addItem("92-гий бензин")
comboBox:addItem("98-мий бензин")
comboBox:addItem("Дизельне пальне")
local litres = layout:setPosition(2, 1, layout:addChild(gui.input(1, 1, 18, 3, 0xdbdbdb, 0x353535, 0x999999, 0xAAAAAA, 0x2D2D2D, "", "Введіть літраж")))
local PayField = layout:setPosition(2, 1, layout:addChild(gui.input(1, 1, 18, 3, 0xdbdbdb, 0x353535, 0x999999, 0xAAAAAA, 0x2D2D2D, "", "Скільки внесли?")))

local pay = layout:setPosition(2, 1, layout:addChild(gui.button(1, 1, 16, 3, 0xdbdbdb, 0x000000, 0xAAAAAA, 0x0, "Оплатити")))
local rest = layout:setPosition(2, 1, layout:addChild(gui.text(1, 1, 0x000000, "Решта = ")))

local function start()
  prices = filesystem.readTable(resouces .. "Config.cfg")

  if prices == nil then
    text92.text = "92-гий = 0" .. " " .. "грн"
    text98.text = "98-мий = 0" .. " " .. "грн"
    textDiesel.text = "Дизельне пальне = 0" .. " " .. "грн"
  else
    text92.text = "92-гий = " .. prices[1] .. " " .. "грн"
  end

  if prices[2] ~= nil then
    text98.text = "98-мий = " .. prices[2] .. " " .. "грн"
  end

  if prices[3] ~= nil then
    textDiesel.text = "Дизельне пальне = " .. prices[3] .. " " .. "грн"
  end
end

local function load()
  --треба вмикнути індикатор і відкрити порт для поточного трафіку перевірки
  progressIndicator.active = true
  modem.open(32)
  
    --перевірка палива
  while true do
    modem.broadcast(32, gas92.text, gas98.text, diesel.text)
    local name, _, _, _, _, sGas92, sGas98, sDiesel = event.pull()
    if name == "modem_message" then
      if sGas92 == gas92.text then
        if sGas98 == gas98.text then
          if sDiesel == diesel.text then
            break
          end
        end
      end
    end
  end
  
  prices[1] = gas92.text
  prices[2] = gas98.text
  prices[3] = diesel.text
  
  filesystem.writeTable(resouces .. "Config.cfg", prices)
  --крутимо індикатор
  for i = 0, 10 do
    progressIndicator:roll()
    workspace:draw()
    event.sleep(0.1)
  end
  --та вимикай його
  progressIndicator.active = false
  modem.close(32) --і порт закрий
  
  start()
end

send.onTouch = function()
    --перевірка на текст
  if gas92.text == "" then
    gui.alert("Ви не ввели сумму за 92-гий бензин!")
    return
  end
  
  if gas98.text == "" then
    gui.alert("Ви не ввели сумму за 98-мий бензин!")
    return
  end
  
  if diesel.text == "" then
    gui.alert("Ви не ввели сумму за Дизельне пальне!")
    return
  end
  
  load()
end

pay.onTouch = function()
  for i = 1, 3 do
    rest.text = "Рахую"
    workspace:draw()
    event.sleep(0.2)
    
    rest.text = "Рахую ┃"
    workspace:draw()
    event.sleep(0.2)
    
    rest.text = "Рахую ┃┃"
    workspace:draw()
    event.sleep(0.2)
    
    rest.text = "Рахую ┃┃┃"
    workspace:draw()
    event.sleep(0.2)
  end
  local cost = 0
  if comboBox.selectedItem == 1 then
    cost = prices[1]
  elseif comboBox.selectedItem == 2 then
    cost = prices[2]
  elseif comboBox.selectedItem == 3 then
    cost = prices[3]
  end
  
  cost = litres.text * cost
  if tonumber(cost) > tonumber(PayField.text) then
    rest.text = "Недостача!"
    workspace:draw()
    event.sleep(5)
    rest.text = "Решта = "
  else
    rest.text = "Решта = " .. PayField.text - cost
  end
end

---------------------------------------------------------------------------------------------------
--старт
start()
--промальовка
workspace:draw()
workspace:start()
