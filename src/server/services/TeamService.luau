local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Chance = require(ReplicatedStorage.Packages.Vendor.Chance)
local Utils = require(ReplicatedStorage.Shared.utils)
local Settings = require(ReplicatedStorage.Shared.settings)

local TeamService = Knit.CreateService({
	Name = "TeamService",
	Client = {
		TeamChanged = Knit.CreateSignal(),
		BlindPlayer = Knit.CreateSignal(),
	},
})

function TeamService:KnitInit()
	self.teams = {
		[0] = "Murderrers",
		[1] = "Sheriffs",
		[2] = "Hiders",
		[3] = "Spectators",
	}

	self.players = {}
end

function TeamService:InitPlayer(player: Player)
	self.players[player] = { Team = self.teams[3], ShotsLeft = 0 }
end

function TeamService:DeinitPlayer(player: Player)
	self.players[player] = nil
end

function TeamService:GetPlayerTeam(player: Player): string
	local playerTable = self.players[player]
	assert(playerTable, "Player not found in player teams registry!")

	return playerTable["Team"]
end

function TeamService:ShouldGameEnd(): boolean
	local isThereMurderer = false
	local isThereHider = false
	for player in self.players do
		if self.players[player].Team == self.teams[0] then
			isThereMurderer = true
		elseif self.players[player].Team == self.teams[2] then
			isThereHider = true
		end
	end

	return (isThereMurderer and isThereHider)
end

function TeamService:SetPlayerTeam(player: Player, newTeam)
	local shots = (newTeam == "Murderrers" or newTeam == 0) and 2 or 0
	if type(newTeam) == "string" then
		self.players[player] = { Team = newTeam, ShotsLeft = shots }
		self.Client.TeamChanged:Fire(player, newTeam)
	else
		self.players[player] = { Team = self.teams[newTeam], ShotsLeft = shots }
		self.Client.TeamChanged:Fire(player, self.teams[newTeam])
	end
end

function TeamService:ShootCharacter(player: Player, victim)
	local playerTeam = TeamService:GetPlayerTeam(player)
	local victimPlayer = Players:GetPlayerFromCharacter(victim)
	assert(player.Character, "Player's character is nil")
	assert(playerTeam == "Murderrers" or playerTeam == "Sheriffs", "Attempted shooting without gun!")
	assert(victim, "Victim is nil!")
	local victimHumanoid = victim:FindFirstChildWhichIsA("Humanoid")
	if victimHumanoid then
		victimHumanoid.Health = 0
		if not victimPlayer then
			if playerTeam == "Murderrers" then
				if self.players[player].ShotsLeft == 0 then
					player.Character.Humanoid.Health = 0
				else
					self.players[player].ShotsLeft -= 1
					self.Client.BlindPlayer:Fire(player)
					player.Character.Humanoid.WalkSpeed = 0
				end
			else
				player.Character.Humanoid.Health = 0
			end
		elseif self.players[victimPlayer].Team == self.teams[2] then
			player.Character.Humanoid.Health = 0
		end
	end
end

function TeamService:StartGame()
	assert(#Players:GetPlayers() >= Settings.MinPlayers, "Not enough players to start a game")
	local murdererAmount = #Players:GetPlayers() <= 5 and 1 or 3
	local sherrifAmount = 1
	local playerChances = {}
	for _, player in Players:GetPlayers() do
		playerChances[player] = 100 / #Players:GetPlayers()
	end

	local chance = Chance.new(playerChances)
	print(chance)
	for _ = 1, murdererAmount do
		local player = chance:Run()
		print(player.Name .. " is a murderer")
		playerChances[player] = nil
		self:SetPlayerTeam(player, 0)
	end

	chance = Chance.new(playerChances)
	print(chance)
	for _ = 1, sherrifAmount do
		local player = chance:Run()
		--FIXME: fix weird bug where the player is nil
		playerChances[player] = nil
		self:SetPlayerTeam(player, 1)
	end

	for player, _ in playerChances do
		print(player.Name .. " is a Hider")
		self:SetPlayerTeam(player, 2)
	end
end

--#region Client methods

function TeamService.Client:GetTeam(player: Player)
	return TeamService:GetPlayerTeam(player)
end

function TeamService.Client:ShootCharacter(player: Player, victim: Player)
	TeamService:ShootCharacter(player, victim)
end

return TeamService
