local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Tween = Fusion.Tween

local function SmoothText(props)
	local style = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local fadeOut = TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 3)
	local textSize = Fusion.Value(0)
	local strokeSize = Fusion.Value(0)
	local textRot = Fusion.Value(0)
	local textPos = Fusion.Value(props.Position or UDim2.fromScale(0.5, 0.5))

	local component = Fusion.New("TextLabel")({
		Name = props.Name,
		Text = props.Text,
		ZIndex = props.ZIndex,
		Position = Tween(textPos, fadeOut),
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		TextColor3 = Color3.fromRGB(78, 19, 129),
		TextSize = Tween(strokeSize, style),
		BackgroundTransparency = 1,
		Rotation = Tween(textRot, style),
		FontFace = Font.fromEnum(Enum.Font.FredokaOne),
		[Fusion.Children] = {
			Fusion.New("TextLabel")({
				Name = props.Name,
				Text = props.Text,
				ZIndex = props.ZIndex,
				Position = UDim2.fromScale(0.5, 0.495),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				TextColor3 = Color3.fromRGB(233, 237, 255),
				TextSize = Tween(textSize, style),
				BackgroundTransparency = 1,
				Rotation = Tween(textRot, style),

				FontFace = Font.fromEnum(Enum.Font.FredokaOne),
				[Fusion.Children] = {
					Fusion.New("UIGradient")({
						Color = ColorSequence.new(Color3.fromRGB(180, 180, 180), Color3.fromRGB(255, 255, 255)),
						Rotation = -72,
					}),
				},
			}),
			Fusion.New("UIGradient")({
				Color = ColorSequence.new(Color3.fromRGB(180, 180, 180), Color3.fromRGB(255, 255, 255)),
				Rotation = -72,
			}),
		},
	})
	textSize:set(props.TextSize or 97)
	strokeSize:set(props.TextSize + 1 or 98)
	textRot:set(0)
	textPos:set(UDim2.fromScale(0.5, 2))

	return component
end

return SmoothText
