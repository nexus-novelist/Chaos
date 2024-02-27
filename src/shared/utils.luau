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

return utils
