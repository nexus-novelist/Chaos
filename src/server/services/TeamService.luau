local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local TeamService = Knit.CreateService({
	Name = "TeamService",
	Client = {},
})

function TeamService:KnitInit()
	print(TeamService.Name .. " initialized!")
	self.teams = {
		[0] = "Murderrers",
		[1] = "Sheriffs",
		[2] = "Survivors",
		[3] = "Spectators",
	}

	self.players = {}
end

function TeamService:InitPlayer(player: Player)
	table.insert(self.players, { [player] = { self.teams[3] } })
end

function TeamService:DeinitPlayer(player: Player)
	table.remove(self.players, table.find(self.players, player))
end

return TeamService
