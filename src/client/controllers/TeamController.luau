local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local TeamController = Knit.CreateController({
	Name = "TeamController",
})

function TeamController:KnitInit()
	print(TeamController.Name .. " initialized")
end

return TeamController
