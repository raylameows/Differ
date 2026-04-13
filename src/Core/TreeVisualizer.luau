local Button = require(`../Interface/Button`)
local InstanceIcon = require(`../Util/InstanceIcon`)
local ScriptRenderer = require(`./ScriptRenderer`)

local TreeVisualizer = {}

local function Traverse(node, Atlas, parentButton)
	local list = Atlas.References.List

	local button, toggled = Button {
		Name = node.Name,
		Parent = not parentButton and list,
		Icon = InstanceIcon:Get(node.Class)
	}

	local children = {}

	for _, child in (node.Children or {}) do
		table.insert(children, Traverse(child, Atlas, button))
	end

	if #children == 0 then
		button.Header.Visuals.Display.Dropdown.ImageTransparency = 1
	end

	Atlas.computed(function()
		if toggled:Get() then
			for _, subButton in children do
				subButton.Parent = button.Holder
			end

			if node.IsScript then
				ScriptRenderer.Render(node, Atlas)
			end
		else
			for _, subButton in children do
				subButton.Parent = nil
			end
		end
	end, {toggled})

	return button
end

function TreeVisualizer.Clear(Atlas)
	local list = Atlas.References.List
	for _, child in (list:GetChildren()) do
		if child:IsA(`Frame`) then
			child:Destroy()
		end
	end
end

function TreeVisualizer.Render(result, Atlas)
	for _, child in result.Children do
		Traverse(child, Atlas)
	end
end

return TreeVisualizer