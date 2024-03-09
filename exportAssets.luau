local fs = require("@lune/fs")
local roblox = require("@lune/roblox")

local file = fs.readFile("Chaos.rbxlx")
local game = roblox.deserializePlace(file)
local workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

--MAPS--
for _, child in workspace:GetChildren() do
	file = roblox.serializeModel({ child })
	fs.writeFile("maps/workspace/" .. child.Name, file)
end

for _, child in ServerStorage.Maps:GetChildren() do
	file = roblox.serializeModel({ child })
	fs.writeFile("maps/serverStorage/" .. child.Name, file)
end

--ASSETS --
for _, child in ReplicatedStorage.Assets:GetChildren() do
	file = roblox.serializeModel({ child })
	fs.writeFile("assets/shared/" .. child.Name, file)
end
