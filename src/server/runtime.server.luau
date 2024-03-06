local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Settings = require(ReplicatedStorage.Shared.settings)

Knit.AddServices(script.Parent.services)

Knit.Start()
	:andThen(function()
		print("knit started on server!")
	end)
	:catch(warn)

function InitChar(character)
	assert(character, "Character is nil")
	character.Humanoid.WalkSpeed = Settings.WalkSpeed
	character.Humanoid.JumpPower = 0
end

function InitPlayer(player: Player)
	local TeamService = Knit.GetService("TeamService")
	TeamService:InitPlayer(player)
	player.CharacterAdded:Connect(InitChar)
	task.wait(5)
	TeamService:SetPlayerTeam(player, 3)
end

function DeinitPlayer(player: Player)
	local TeamService = Knit.GetService("TeamService")
	TeamService:DeinitPlayer(player)
end

Players.PlayerAdded:Connect(InitPlayer)
Players.PlayerRemoving:Connect(DeinitPlayer)
