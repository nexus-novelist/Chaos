local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local rParticle = require(ReplicatedStorage.Packages.Vendor.rParticle)
local Fusion = require(ReplicatedStorage.Packages.fusion)

local Components = script.Parent.Parent.components

local Frame = require(Components.frame)
local ScreenGui = require(Components.screenGui)
local SmoothText = require(Components.smoothText)

local Settings = require(ReplicatedStorage.Shared.settings)

local UiController = Knit.CreateController({
	Name = "UiController",
})

function UiController:KnitStart()
	local TeamService = Knit.GetService("TeamService")

	TeamService.TeamChanged:Connect(function(team: string)
		if team == "Spectators" then
			self:ShowHText(
				"Buddy you actually sold",
				true,
				Color3.fromRGB(255, 150, 136),
				Color3.fromRGB(253, 174, 154)
			)
		else
			self:ShowHText(
				"You are a " .. team:sub(1, -2),
				true,
				Color3.fromRGB(154, 163, 253),
				Color3.fromRGB(152, 175, 255)
			)
		end
	end)

	TeamService.BlindPlayer:Connect(function()
		local blindUI = self:Blind()
		task.wait(Settings.BlindTime)
		blindUI:Destroy()
	end)
end

function UiController:Blind()
	local blindUI = Fusion.New("Frame")({
		ZIndex = 100,
		Name = "Blind",
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundColor3 = Color3.new(),
	})

	blindUI.Parent = self.MainGui
	return blindUI
end

function UiController:ShowParticles(color1, color2)
	local ParticleEmitter = rParticle.new(self.Origin, game.ReplicatedStorage:WaitForChild("Particle"))
	ParticleEmitter.rate = 10

	ParticleEmitter.onSpawn = function(particle)
		particle.element.ImageColor3 = math.random(1, 2) == 1 and color1 or color2
		particle.element.Rotation = math.random(0, 360)
		particle.velocity = Vector2.new(math.random(-10000, 10000), math.random(0, 250))
		particle.maxAge = 10
	end

	local timePassed = 0

	ParticleEmitter.onUpdate = function(particle, deltaTime)
		timePassed += deltaTime
		particle.velocity = particle.velocity - Vector2.new(0, deltaTime * 100)
		particle.velocity = particle.velocity / Vector2.new(deltaTime * 70, 1)
		particle.element.Rotation += deltaTime * particle.velocity.Magnitude / 50
		particle.position = particle.position - (particle.velocity / 3 * deltaTime)
		if timePassed >= 60 * 1 then
			particle.velocity = particle.velocity - Vector2.new(0, deltaTime * 1000)
			ParticleEmitter.rate = 0
		end
	end
end

function UiController:ShowHText(text, isMain, color1, color2)
	local hText = SmoothText({
		Text = text,
		Position = isMain and UDim2.fromScale(0.5, 0.5) or UDim2.fromScale(0.5, 0.2),
		TextSize = isMain and 90 or 50,
	})

	if isMain then
		self:ShowParticles(color1, color2)
	end

	hText.Parent = self.MainGui
end

function UiController:KnitInit()
	self.MainGui = ScreenGui({
		Name = "MainGui",
		IgnoreGuiInset = true,
	})

	self.Origin = Frame({
		Size = UDim2.new(0, 1, 0, 1),
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})

	self.MainGui.Parent = Players.LocalPlayer.PlayerGui
	self.Origin.Parent = self.MainGui
end

return UiController
