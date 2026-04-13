local Selection = game:GetService("Selection")

local Differ = {}

local SourceHandler = require(`./Core/SourceHandler`)
local TreeVisualizer = require(`./Core/TreeVisualizer`)
local Session = require(`./Core/Session`)
local RootUI = require(`./Interface/Root`)

function Differ.Init(plugin)
	local toolbar = plugin:CreateToolbar(`Differ`)
	local button = toolbar:CreateButton(
		`Differ`,
		`Shows you the differences between two instances`,
		`rbxassetid://97554311998769`
	)

	local widgetInfo = DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Float,
		false,
		false,
		600,
		500
	)

	local widget = plugin:CreateDockWidgetPluginGui(`Differ`, widgetInfo)
	widget.Title = `Differ`
	widget.Name = `Differ`

	button.Click:Connect(function()
		widget.Enabled = not widget.Enabled
	end)

	local UI, Atlas = RootUI {
		Parent = widget,
		Version = Differ.Version,
	}

	Atlas.References.CompareButton.Activated:Connect(function()
		local compareAvailable = Atlas.Data.ComparisonAvailable:Get()
		if not compareAvailable then return end

		local selected = Selection:Get()
		local base, head = selected[1], selected[2]

		local session = Session.new(base, head)
		local result = session:Compare()
		TreeVisualizer.Clear(Atlas)
		TreeVisualizer.Render(result, Atlas)
	end)
end

Differ.Version = 0.01
return Differ