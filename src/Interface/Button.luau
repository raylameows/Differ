--!nolint DeprecatedApi
-- To get rid of the stupid Montserrat warning

local Atlas = require(`../Util/Atlas`).localize()

local Button
Button = function(data: {[string]: any})
	local expanded = Atlas.state(false)
	local open = Atlas.computed(function()
		return not expanded:Get() and `rbxassetid://98515959792894` or `rbxassetid://80464345551642`
	end, {expanded})
	
	return Atlas:New "Frame" {
		Parent = data.Parent,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Children = {
			TopList = Atlas:New "UIListLayout" {
				Padding = UDim.new(0, 1),
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
			},
			LeftPadding = Atlas:New "UIPadding" {
				PaddingLeft = UDim.new(0, 5),
			},
			Header = Atlas:New "Frame" {
				Size = UDim2.new(1, 0, 0, 30),
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Children = {
					Visuals = Atlas:New "Frame" {
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						Children = {
							Padding = Atlas:New "UIPadding" {
								PaddingLeft = UDim.new(0, 0)
							},
							TopList = Atlas:New "UIListLayout" {
								Padding = UDim.new(0, 5),
								FillDirection = Enum.FillDirection.Vertical,
								VerticalAlignment = Enum.VerticalAlignment.Top,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								SortOrder = Enum.SortOrder.LayoutOrder,
							},
							Display = Atlas:New "Frame" {
								Size = UDim2.fromScale(1, 1),
								BackgroundTransparency = 1,
								Children = {
									LeftList = Atlas:New "UIListLayout" {
										Padding = UDim.new(0, 0),
										FillDirection = Enum.FillDirection.Horizontal,
										VerticalAlignment = Enum.VerticalAlignment.Center,
									},
									Dropdown = Atlas:New "ImageLabel" {
										Size = UDim2.fromOffset(20, 20),
										BackgroundTransparency = 1,
										Image = open,
										ImageTransparency = 0.1,
										LayoutOrder = 1,
									},
									Icon = Atlas:New "ImageLabel" {
										Size = UDim2.fromOffset(20, 20),
										BackgroundTransparency = 1,
										Image = data.Icon or `rbxassetid://116304482678809`,
										ImageTransparency = 0,
										LayoutOrder = 2,
									},
									Text = Atlas:New "TextLabel" {
										Size = UDim2.fromScale(0.875, 1),
										BackgroundTransparency = 1,
										TextXAlignment = Enum.TextXAlignment.Left,
										TextColor3 = Color3.fromRGB(255, 255, 255),
										Font = Enum.Font.Montserrat,
										Text = data.Name or `TestFolder`,
										TextSize = 18,
										Children = {
											Padding = Atlas:New "UIPadding" {
												PaddingLeft = UDim.new(0, 3),
											}
										}
									},
								}
							},
						}
					},
					Button = Atlas:New "TextButton" {
						Size = UDim2.fromScale(1, 1),
						ZIndex = 2,
						BackgroundTransparency = 1,
						Text = ``,
						TextTransparency = 1,
						Events = {
							Activated = function()
								expanded:Set(not expanded:Get())
							end,
						}
					}
				}
			},
			Holder = Atlas:New "Frame" {
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 2,
				Children = {
					TopList = Atlas:New "UIListLayout" {
						Padding = UDim.new(0, -5),
						FillDirection = Enum.FillDirection.Vertical,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
					},
					Flex = Atlas:New "UIFlexItem" {},
					Padding = Atlas:New "UIPadding" {
						PaddingTop = UDim.new(0, -5),
						PaddingLeft = UDim.new(0, 20),
					}
				}
			}
		}
	}, expanded
end

return Button