--[[
    Atlas - A lightweight UI library based on Fusion
    
    © Rayla, 2026
]]

local TweenService = game:GetService("TweenService")

local Atlas = {}
Atlas.__index = Atlas

Atlas.Defaults = {
	["GuiObject"] = {
		BorderSizePixel = 0,
	}
}

-- // INTERNAL CLEANUP REGISTRY

local Cleanup = setmetatable({}, {__mode = "k"})

local function track(instance, connection)
	Cleanup[instance] = Cleanup[instance] or {}
	table.insert(Cleanup[instance], connection)
end

local function cleanupInstance(instance)
	local list = Cleanup[instance]
	if not list then return end

	for _, conn in list do
		if conn.Disconnect then
			conn:Disconnect()
		end
	end

	Cleanup[instance] = nil
end

-- // TWEEN VALUE

local TweenValue = {}
TweenValue.__index = TweenValue
TweenValue.Tween = true

function Atlas.tween(target, duration, style, direction)
	return setmetatable({
		Target = target,
		Time = duration or 0.25,
		Style = style or Enum.EasingStyle.Quad,
		Direction = direction or Enum.EasingDirection.Out,
	}, TweenValue)
end

local ActiveTweens = setmetatable({}, { __mode = "k" })

-- // PROPERTY HANDLERS

local PropertyHandlers = {
	Parent = function(instance, _, value)
		return { Parent = value }
	end,

	Children = function(instance, _, value)
		for key, child in value do
			child.Parent = instance
			if child.Name == child.ClassName then
				child.Name = key
			end
		end
	end,

	Events = function(instance, _, value)
		for name, event in value do
			local conn = instance[name]:Connect(event)
			track(instance, conn)
		end
	end,

	Reference = function(instance, _, value, localizedAtlas)
		localizedAtlas.References[value] = instance
	end,

	any = function(instance, property, value)
		if typeof(value) == "table" then
			if value.Computed == true then
				local computed = value

				computed.Connections[instance] = computed.Connections[instance] or {}
				table.insert(computed.Connections[instance], property)
				if not Cleanup[instance] then
					instance.Destroying:Connect(function()
						computed.Connections[instance] = nil
					end)
				end

				computed:Update()
				return
			end

			if value.Tween == true then
				ActiveTweens[instance] = ActiveTweens[instance] or {}
				if ActiveTweens[instance][property] then
					ActiveTweens[instance][property]:Cancel()
				end

				local tween = TweenService:Create(
					instance,
					TweenInfo.new(value.Time, value.Style, value.Direction),
					{ [property] = value.Target }
				)

				ActiveTweens[instance][property] = tween
				tween:Play()
				return
			end
		end

		instance[property] = value
	end,
}

-- // ATLAS

function Atlas.localize()
	local self = setmetatable({}, Atlas)
	self.Localized = true
	self.References = {}
	self.Data = {}
	return self
end

function Atlas:New(class)
	local instance = Instance.new(class)
	instance.Destroying:Connect(function()
		cleanupInstance(instance)
	end)

	return function(properties)
		local data = {}

		for className, list in Atlas.Defaults do
			if not instance:IsA(className) then continue end
			for defProp, defVal in list do
				instance[defProp] = defVal
			end
		end

		for property, value in properties or {} do
			local handler = PropertyHandlers[property] or PropertyHandlers.any
			local result = handler(instance, property, value, self)

			if result ~= nil then
				for key, set in result do
					data[key] = set
				end
			end
		end

		if data.Parent then
			instance.Parent = data.Parent
		end

		return instance
	end
end

function Atlas.clean(derived, instance)
	local conn
	conn = instance.Destroying:Connect(function()
		derived:Clear()
		conn:Disconnect()
	end)
end

-- // STATE

local State = {}
State.__index = State

function Atlas.state(initialValue)
	local self = setmetatable({}, State)
	self.Value = initialValue
	self.Computeds = setmetatable({}, {__mode = "v"})
	return self
end

function State:Set(value)
	self.Value = value
	for _, computed in self.Computeds do
		if computed then
			computed:Update()
		end
	end
end

function State:Get()
	return self.Value
end

-- // COMPUTED

local Computed = {}
Computed.__index = Computed
Computed.Computed = true

function Atlas.computed(callback, dependencies)
	local self = setmetatable({}, Computed)
	self.Callback = callback
	self.Connections = setmetatable({}, { __mode = "k" }) -- weak keys
	self.Dependencies = dependencies or {}
	self.HasRun = false

	for _, dependency in self.Dependencies do
		table.insert(dependency.Computeds, self)
	end

	return self
end

function Computed:Update(context)
	local isFirst = not self.HasRun
	self.HasRun = true

	local result = self.Callback(context, isFirst)

	for instance, properties in self.Connections do
		for _, property in properties do
			PropertyHandlers.any(instance, property, result)
		end
	end
end

function Computed:Destroy()
	for _, dependency in self.Dependencies do
		for i, comp in ipairs(dependency.Computeds) do
			if comp == self then
				table.remove(dependency.Computeds, i)
				break
			end
		end
	end

	self.Connections = {}
end

-- // DERIVED

local Derived = {}
Derived.__index = Derived

function Atlas.derived(callback, updateEvents)
	local self = setmetatable({}, Derived)
	self.Callback = callback
	self.Events = updateEvents
	self.Connections = {}

	for _, event in self.Events do
		table.insert(self.Connections, event:Connect(callback))
	end

	return self
end

function Derived:Clear()
	for _, connection in self.Connections do
		connection:Disconnect()
	end
	table.clear(self.Connections)
end

-- // TYPES

type Properties = { [string]: any }
type LocalizedAtlas = typeof(setmetatable({}, { __index = Atlas }))
return Atlas