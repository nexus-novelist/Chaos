local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Settings = require(ReplicatedStorage.Shared.settings)

Knit.AddServices(script.Parent.services)

function StartGame()
	while true do
		if #Players:GetPlayers() >= 3 then
			print("Starting in 10 seconds!")
			task.wait(10)
			print("Started with " .. #Players:GetPlayers() .. " players")
			local TeamService = Knit.GetService("TeamService")
			TeamService:StartGame()
			print("Starting new game in 20 seconds!")
			task.wait(20)
			print("new game starting soon!")
		end
		task.wait(1)
	end
end

function InitChar(character)
	assert(character, "Character is nil")
	character.Humanoid.WalkSpeed = Settings.WalkSpeed
	character.Humanoid.JumpPower = 0
end

function InitPlayer(player: Player)
	local TeamService = Knit.GetService("TeamService")
	TeamService:InitPlayer(player)
	player.CharacterAdded:Connect(InitChar)
end

function DeinitPlayer(player: Player)
	local TeamService = Knit.GetService("TeamService")
	TeamService:DeinitPlayer(player)
end

Players.PlayerAdded:Connect(InitPlayer)
Players.PlayerRemoving:Connect(DeinitPlayer)

Knit.Start()
	:andThen(function()
		print("knit started on server!")
		StartGame()
	end)
	:catch(warn)
