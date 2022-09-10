local internet = require("Internet")
local fs = require("Filesystem")

print("Creating a folder")
event.sleep(1)
fs.makeDirectory("/Applications/Cass.app")
print("Succes!")

print("Downloading Main.lua")
event.sleep(1)
internet.download("https://raw.githubusercontent.com/Bumer-32/Minecraft-opencomputers/main/Gas%20Station/Cass.app/Main.lua", "/Applications/Cass.app/Main.lua")
print("Succes!")

print("Downloading Config.cfg")
event.sleep(1)
internet.download("https://raw.githubusercontent.com/Bumer-32/Minecraft-opencomputers/main/Gas%20Station/Cass.app/Config.cfg", "/Applications/Cass.app/Config.cfg")
print("Succes!")

print("Downloading Icon.pic")
event.sleep(1)
internet.download("https://raw.githubusercontent.com/Bumer-32/Minecraft-opencomputers/main/Gas%20Station/Cass.app/Icon.pic", "/Applications/Cass.app/Icon.pic")
print("Succes!")

print("Downloading Logo.pic")
event.sleep(1)
internet.download("https://raw.githubusercontent.com/Bumer-32/Minecraft-opencomputers/main/Gas%20Station/Cass.app/Logo.pic", "/Applications/Cass.app/Logo.pic")
print("Succes!")

print("Creating shortcut")
event.sleep(1)
filesystem.write(
  "/MineOS/" .. system.getUser() .. "/Desktop/Cass",
  "/Applications/Cass.app/"
)
print("Succes!")
