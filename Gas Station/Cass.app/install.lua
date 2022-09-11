local internet = require("Internet")
local system = require("System")
local fs = require("Filesystem")

print("Creating a folder")
fs.makeDirectory("/Applications/Cass.app")
print("Succes!")

print("Downloading Main.lua")
internet.download("https://raw.githubusercontent.com/Bumer-32/Minecraft-opencomputers/main/Gas%20Station/Cass.app/Main.lua", "/Applications/Cass.app/Main.lua")
print("Succes!")

print("Downloading Config.cfg")
internet.download("https://raw.githubusercontent.com/Bumer-32/Minecraft-opencomputers/main/Gas%20Station/Cass.app/Config.cfg", "/Applications/Cass.app/Config.cfg")
print("Succes!")

print("Downloading Icon.pic")
internet.download("https://raw.githubusercontent.com/Bumer-32/Minecraft-opencomputers/main/Gas%20Station/Cass.app/Icon.pic", "/Applications/Cass.app/Icon.pic")
print("Succes!")

print("Downloading Logo.pic")
internet.download("https://raw.githubusercontent.com/Bumer-32/Minecraft-opencomputers/main/Gas%20Station/Cass.app/Logo.pic", "/Applications/Cass.app/Logo.pic")
print("Succes!")