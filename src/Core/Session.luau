local Session = {}
Session.__index = Session

local SourceHandler = require(`./SourceHandler`)
local DumpParser = require(`../Packages/DumpParser`)
local Dump = DumpParser.fetchFromServer()

local function getProperties(instance: Instance)
	local properties = {}

	for _, property in (Dump:GetProperties(instance)) do
		properties[property.Name] = instance[property.Name]
	end

	return properties
end

local function getRelativePath(root: Instance, instance: Instance)
	local path = {}

	while instance and instance ~= root do
		table.insert(path, 1, instance.Name)
		instance = instance.Parent
	end

	return table.concat(path, "/")
end

local function indexTree(root: Instance)
	local map = {}

	for _, descendant in (root:GetDescendants()) do
		local path = getRelativePath(root, descendant)
		map[path] = descendant
	end

	return map
end

function Session.new(base, head)
	return setmetatable({
		Base = base,
		Head = head,
		HasRun = false,
		Result = nil,
	}, Session)
end

function Session:CompareNodes(base: Instance?, head: Instance?, path: string?)
	path = path or ""
	
	if not base and head then
		return {
			Type = `added`,
			Path = path,
			Instance = head,
			Class = head.ClassName,
			Name = head.Name,
		}
	elseif base and not head then
		return {
			Type = `removed`,
			Path = path,
			Instance = base,
			Class = base.ClassName,
			Name = base.Name,
		}
	end

	local result = {
		Type = "modified",
		Path = path,
		Class = head.ClassName,
		Name = head.Name,
		ClassChanged = base.ClassName ~= head.ClassName,
		PropertyDiffs = {},
		SourceDiffs = nil,
		Children = {}
	}

	local propsBase = getProperties(base)
	local propsHead = getProperties(head)
	local seen = {}

	for prop, valueBase in (propsBase) do
		seen[prop] = true
		local valueHead = propsHead[prop]

		if valueHead == nil then
			table.insert(result.PropertyDiffs, {
				Property = prop,
				Type = "removed",
				Old = valueBase
			})
		elseif valueBase ~= valueHead then
			table.insert(result.PropertyDiffs, {
				Property = prop,
				Type = "changed",
				Old = valueBase,
				New = valueHead
			})
		end
	end

	for prop, valueHead in (propsHead) do
		if not seen[prop] then
			table.insert(result.PropertyDiffs, {
				Property = prop,
				Type = "added",
				New = valueHead
			})
		end
	end
	
	if base:IsA("LuaSourceContainer") and head:IsA("LuaSourceContainer") then
		result.SourceDiffs = SourceHandler:Compare(base.Source, head.Source)
		result.IsScript = true
	end

	local baseChildren = {}
	local headChildren = {}

	for _, child in (base:GetChildren()) do
		baseChildren[child.Name .. ":" .. child.ClassName] = child
	end

	for _, child in (head:GetChildren()) do
		headChildren[child.Name .. ":" .. child.ClassName] = child
	end

	local seenChildren = {}

	for key, baseChild in (baseChildren) do
		seenChildren[key] = true
		local headChild = headChildren[key]

		table.insert(result.Children, self:CompareNodes(
			baseChild,
			headChild,
			(path == "" and base.Name or path .. "/" .. base.Name) .. "/" .. baseChild.Name
			))
	end

	for key, headChild in (headChildren) do
		if not seenChildren[key] then
			table.insert(result.Children, self:CompareNodes(
				nil,
				headChild,
				(path == "" and head.Name or path .. "/" .. head.Name) .. "/" .. headChild.Name
				))
		end
	end

	return result
end

function Session:Compare()
	return self:CompareNodes(self.Base, self.Head)
end

return Session