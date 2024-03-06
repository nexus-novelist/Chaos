--[[

	Chance (v1.0.1)

	made by avocado (@avodey) :3
	
	https://devforum.roblox.com/t/chance-easy-random-items-luck-modifiers/2806263
	
]]

local Super = {}
local Chance = {}
Chance.__index = Chance

local assert = require(script:WaitForChild("Assert"))
local seed = os.clock() * 2 ^ 8

--\\ Types

export type Chance = {
	_Data: ChanceData,
	_Generator: Random,
	_Luck: number,
} & typeof(Chance)

type ChanceData = {
	[any]: number,
}

type ChanceSlot = {
	Min: number,
	Max: number,
	Value: number,
	Chance: number,

	Item: any,
}

--\\ Private Methods

local function getList(data: ChanceData, luck: number?): { ChanceSlot }
	assert.ensure({ data, luck }, { "table", "number?" })

	luck = luck or 0

	local total = 0
	local result: { ChanceSlot } = {}

	for i, v in pairs(data) do
		if type(v) == "number" then
			local item = {
				Item = i,
				Value = v / 100,
				Chance = v,
			}

			total += v

			table.insert(result, item)
		else
			error(`Can only have number chances. Got '{type(v)}'`)
		end
	end

	assert.check(
		total > 0 and math.floor(total * 100) / 100 <= 100,
		`Chances must not go over 100%! Sum was '{total}'%.`
	)

	--\\ Sort Value

	table.sort(result, function(a, b)
		return a.Value > b.Value
	end)

	--\\ Apply Luck

	local common = result[1]
	local maxdeplet = common.Value / 3
	local change = 0
	local minindex = math.min(3, #result)

	for i, v in pairs(result) do
		if i >= minindex then
			local before = v.Value
			local after = v.Value + v.Value * (luck / 2)

			local beforechange = change
			change = math.min(maxdeplet, change + math.min(maxdeplet / (#result - minindex + 1), (after - before)))

			v.Value += change - beforechange
			v.Chance = v.Value * 100
		end
	end

	common.Value -= change
	common.Chance = common.Value * 100

	--\\ Sort Lucky Values

	table.sort(result, function(a, b)
		return a.Value > b.Value
	end)

	--\\ Set Ranges

	for i, v in pairs(result) do
		local last = result[i - 1] or { Max = 0 }
		v.Min = last.Max
		v.Max = v.Min + v.Value
	end

	return result
end

local function getItem(items: { ChanceSlot }, x: number): any
	for _, slot in pairs(items) do
		if x < slot.Max and x >= slot.Min then
			return slot.Item
		end
	end
end

--\\ Public Methods

local chanceid = 0
function Super.new(items: ChanceData, luck: number?): Chance
	assert.ensure({ items, luck }, { "table", "number?" })

	chanceid += 1

	local self: Chance = setmetatable({}, Chance)
	self._Data = items
	self._Luck = luck or 0
	self._Generator = Random.new(seed + chanceid)

	return self
end

function Super.fromResult(result: { [any]: number }): Chance
	local total = 0

	for _, v in pairs(result) do
		assert.check(type(v) == "number", "All counts must be a number!")
		total += v
	end

	for i, v in pairs(result) do
		if total == 0 then
			result[i] = 0
		else
			result[i] = v / total * 100
		end
	end

	return Super.new(result)
end

function Super:Run(chance: number): boolean
	assert.ensure({ chance }, { "number" })
	return math.random() < math.clamp(chance / 100, 0, 1)
end

--\\ Instance Methods

function Chance.Run(self: Chance): any
	return getItem(getList(self._Data, self._Luck), self._Generator:NextNumber())
end

function Chance.SetLuck(self: Chance, luck: number): Chance
	assert.ensure({ luck }, { "number" })
	luck = math.clamp(luck, 0, 10)
	self._Luck = luck
	return self
end

function Chance.GetItems(self: Chance, luck: number?): { ChanceSlot }
	return getList(self._Data, tonumber(luck) or self._Luck)
end

return Super
