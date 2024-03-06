--!strict

--[[

	Assert (v1.0.3)

	made by avocado (@avodey) :3

]]

local ArgError = "invalid argument #%d to '%s' (%s expected)"
local ArgErrorUnknown = "invalid argument #%d (%s expected)"
local ObjectCall = "attempt to call static method on an object"
local StaticCall = "attempt to call instance method on the constructor"

local assert = {}

-- Check if arguments are valid when calling function
function assert.check(condition: boolean, ...: string)
	if not condition then
		local args = { ... }
		for i, arg in pairs(args) do
			args[i] = tostring(arg)
		end
		error(table.concat(args, " "), 3)
	end
end

-- Ensure arguments are of type
function assert.ensure(args: { any }, types: { string })
	for i, type in pairs(types) do
		local optional = type:find("?$")
		type = type:gsub("?", ""):gsub(" ", "")

		local arg = args[i]
		local class = typeof(arg)

		if class == "EnumItem" then
			class = tostring(arg):split(".")[2]
		end

		local next = false
		for _, t in pairs(type:split("|")) do -- Iterate all possible types for argument
			if class == t then -- Value is equal to requested type
				next = true
				break
			end

			if class == "Instance" and arg:IsA(t) then -- Instance is equal to the requested type
				next = true
				break
			end

			if arg == nil and optional then -- Optional argument that was nil is ignored
				next = true
				break
			end
		end

		if next then
			continue
		end

		local method = debug.info(2, "n")
		if method and method ~= "" then
			error(ArgError:format(i, method, type), 3)
		else
			error(ArgErrorUnknown:format(i, type), 3)
		end
	end
end

-- Error if calling from instance of object
function assert.static(self, object)
	if self ~= object then
		error(ObjectCall, 3)
	end
end

-- Error if calling from static object
function assert.object(self, object)
	if self == object then
		error(StaticCall, 3)
	end
end

return assert
