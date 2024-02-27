local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Utils = require(ReplicatedStorage.Shared.utils)

local TeamService = Knit.CreateService({
	Name = "TeamService",
	Client = {
		TeamChanged = Knit.CreateSignal(),
	},
})

function TeamService:KnitInit()
	self.teams = {
		[0] = "Murderrers",
		[1] = "Sheriffs",
		[2] = "Survivors",
		[3] = "Spectators",
	}

	self.players = {}
end

function TeamService:InitPlayer(player: Player)
	table.insert(self.players, { [player] = { Team = self.teams[3] } })
end

function TeamService:DeinitPlayer(player: Player)
	table.remove(self.players, Utils.findPlayerInTable(player, self.players))
end

function TeamService:GetPlayerTeam(player: Player)
	local playerTable = Utils.findPlayerInTable(player, self.players)
	assert(playerTable, "Player not found in player teams registry!")

	return playerTable["Team"]
end

function TeamService:SetPlayerTeam(player: Player, newTeam)
	local index = Utils.findPlayerInTable(player, self.players)
	if type(newTeam) == "string" then
		self.players[index] = { [player] = { Team = newTeam } }
		self.Client.TeamChanged:Fire(player, newTeam)
	else
		self.players[index] = { [player] = { Team = self.teams[newTeam] } }
		self.Client.TeamChanged:Fire(player, self.teams[newTeam])
	end
end

--#region Client methods

function TeamService.Client:GetTeam(player: Player)
	return TeamService:GetPlayerTeam(player)
end

return TeamService
