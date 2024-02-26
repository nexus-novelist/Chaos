local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.AddControllers(script.Parent.controllers)

Knit.Start()
	:andThen(function()
		print("Knit started on client!")
	end)
	:catch(warn)
