local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Input = require(ReplicatedStorage.Packages.Input)
local Knit = require(ReplicatedStorage.Packages.Knit)

local Utils = require(ReplicatedStorage.Shared.utils)

local Keyboard = Input.Keyboard.new()
local Mouse = Input.Mouse.new()

local player = game:GetService("Players").LocalPlayer

local TeamController = Knit.CreateController({
	Name = "TeamController",
})

function TeamController:KnitInit()
	local TeamService = Knit.GetService("TeamService")
	self.team = "Spectators"

	self.rayParams = RaycastParams.new()
	self.rayParams.FilterType = Enum.RaycastFilterType.Exclude

	TeamService.TeamChanged:Connect(function(newTeam)
		TeamController:TeamChanged(newTeam)
	end)

	RunService.PreRender:Connect(function(dt)
		if Keyboard:IsKeyDown(Enum.KeyCode.LeftShift) then
			self.rayParams.FilterDescendantsInstances = { player.Character }
			if self.team == "Murderrers" or self.team == "Sheriffs" then
				local ray = Mouse:Raycast(self.rayParams, 75)
				if ray and ray.Instance then
					self:AimAt(ray)
				end
			else
				print("Player is running!")
			end
		end
	end)
end

function TeamController:TeamChanged(newTeam)
	self.team = newTeam
	print("Now part of " .. newTeam .. " team!")
end

function TeamController:AimAt(raycastResult: RaycastResult)
	local rootPart: BasePart = Utils.GetRootPart(player)
	if not rootPart or not raycastResult or not raycastResult.Position then
		return
	end

	rootPart.CFrame = rootPart.CFrame:Lerp(
		CFrame.new(
			rootPart.Position,
			Vector3.new(raycastResult.Position.X, rootPart.Position.Y, raycastResult.Position.Z)
		),
		0.5
	)
end

return TeamController
