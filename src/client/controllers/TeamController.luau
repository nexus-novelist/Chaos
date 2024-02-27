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

function TeamController:KnitStart()
	local TeamService = Knit.GetService("TeamService")
	self.team = "Spectators"

	self.rayParams = RaycastParams.new()
	self.rayParams.FilterType = Enum.RaycastFilterType.Exclude

	self.highlight = Instance.new("Highlight")

	TeamService.TeamChanged:Connect(function(newTeam)
		TeamController:TeamChanged(newTeam)
	end)

	Mouse.LeftDown:Connect(function()
		if self.highlight.Parent then
			TeamService:ShootCharacter(self.highlight.Parent)
		end
	end)

	RunService.PreRender:Connect(function()
		local hum = Utils.GetHumanoid(player)
		if Keyboard:IsKeyDown(Enum.KeyCode.LeftShift) then
			self.rayParams.FilterDescendantsInstances = { player.Character }
			if self.team == "Murderrers" or self.team == "Sheriffs" then
				if hum then
					hum.WalkSpeed = 14
				end
				local ray = Mouse:Raycast(self.rayParams, 75)
				if ray and ray.Instance then
					self:AimAt(ray)
					if ray.Instance.Parent:FindFirstChildWhichIsA("Humanoid") then
						self.highlight.Parent = ray.Instance.Parent
					else
						self.highlight.Parent = nil
					end
				else
					self.highlight.Parent = nil
				end
			else
				self.highlight.Parent = nil
				if hum then
					hum.WalkSpeed = 22
				end
			end
		else
			self.highlight.Parent = nil
			if hum then
				hum.WalkSpeed = 14
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
