local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Roact = require(ReplicatedStorage.Packages.Roact)

local Components = script.Parent.Parent.components

local Greeting = require(Components.greeting)

local UiController = Knit.CreateController({
	Name = "UiController",
})

function UiController:KnitInit()
	local app = Roact.createElement("ScreenGui", {}, {
		HelloWorld = Roact.createElement(Greeting, {
			Name = "Roact!",
		}),
	})

	Roact.mount(app, Players.LocalPlayer.PlayerGui)
end

return UiController
