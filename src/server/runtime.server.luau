local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.AddServices(script.Parent.services)

Knit.Start()
	:andThen(function()
		print("knit started on server!")
	end)
	:catch(warn)

function InitPlayer(player: Player)
	local TeamService = Knit.GetService("TeamService")
	TeamService:InitPlayer(player)
end

function DeinitPlayer(player: Player)
	local TeamService = Knit.GetService("TeamService")
	TeamService:DeinitPlayer(player)
end

Players.PlayerAdded:Connect(InitPlayer)
Players.PlayerRemoving:Connect(DeinitPlayer)
