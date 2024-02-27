local utils = {}

function utils.findPlayerInTable(player: Player, t: table): number
	local r = nil
	for index, value in t do
		if value[player] then
			r = index
		end
	end
	return r
end

function utils.GetRootPart(player: Player)
	if player then
		local char = player.Character
		if char then
			local root = char.PrimaryPart
			return root
		end
	end
	return nil
end

function utils.GetHumanoid(player: Player)
	local rootPart = utils.GetRootPart(player)
	if rootPart then
		return rootPart.Parent:FindFirstChildOfClass("Humanoid")
	end
	return nil
end

return utils
