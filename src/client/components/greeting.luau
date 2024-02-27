local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Roact = require(ReplicatedStorage.Packages.Roact)

local Greeting = Roact.Component:extend("Greeting")

function Greeting:render()
	return Roact.createElement("TextLabel", {
		Text = "Hello, " .. self.props.Name,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0.5, 0, 0.5, 0),
		[Roact.Event.MouseEnter] = function()
			print("entered!")
		end,
	})
end

return Greeting
