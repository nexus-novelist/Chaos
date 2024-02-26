local fs = require("@lune/fs")
local roblox = require("@lune/roblox")

local file = fs.readFile("Chaos.rbxlx")
local game = roblox.deserializePlace(file)
local workspace = game:GetService("Workspace")

fs.writeDir("maps/workspace")

for i, child in workspace:GetChildren() do
    file = roblox.serializeModel({child})
    fs.writeFile("maps/workspace/"..child.Name, file)
end