local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game
local Knit = require(ReplicatedStorage.Packages.Knit)

local TeamController = Knit.CreateController({
	Name = "TeamController",
})

function TeamController:KnitInit()
	local TeamService = Knit.GetService("TeamService")
	self.team = "Spectators"

	TeamService.TeamChanged:Connect(function(newTeam)
		TeamController:TeamChanged(newTeam)
	end)
end

function TeamController:TeamChanged(newTeam)
	self.team = newTeam
	print("Now part of " .. newTeam .. " team!")
end

return TeamController
