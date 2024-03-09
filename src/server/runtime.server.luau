local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Settings = require(ReplicatedStorage.Shared.settings)

Knit.AddServices(script.Parent.services)

function StartGame()
	local TeamService = Knit.GetService("TeamService")
	while true do
		while #Players:GetPlayers() >= Settings.MinPlayers and not TeamService:ShouldGameEnd() do
			print("Started with " .. #Players:GetPlayers() .. " players")
			TeamService:StartGame()
		end
		task.wait(1)
	end
end

function InitChar(character)
	assert(character, "Character is nil")
	character.Humanoid.WalkSpeed = Settings.WalkSpeed
	character.Humanoid.JumpPower = 0
	local c --death connection
	c = character.Humanoid.Died:Connect(function()
		local TeamService = Knit.GetService("TeamService")
		TeamService:SetPlayerTeam(Players:GetPlayerFromCharacter(character), 3) --after player dies set his team to spectator
		c:Disconnect()
	end)
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
