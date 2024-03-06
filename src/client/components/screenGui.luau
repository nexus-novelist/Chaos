local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.fusion)

local function ScreenGui(props)
	return Fusion.New("ScreenGui")({
		ResetOnSpawn = false,
		Name = props.Name,
		IgnoreGuiInset = props.IgnoreGuiInset,
	})
end

return ScreenGui
