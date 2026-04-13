--!nolint DeprecatedApi
-- To get rid of the stupid Montserrat warning

local Selection = game:GetService("Selection")
local Atlas = require(`../Util/Atlas`).localize()

local Button = require(`./Button`)

return function(data: {[string]: any})
	local compareAvailable = Atlas.state(false)
	local update = Atlas.derived(function()
		local selection = Selection:Get()
		local base, head = selection[1], selection[2]
		if base and head then
			compareAvailable:Set(true)
		else
			compareAvailable:Set(false)
		end
	end, {Selection.SelectionChanged})
	
	local container = Atlas:New "Frame" {
		Name = `Container`,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Parent = data.Parent,
		Children = {
			LeftList = Atlas:New "UIListLayout" {
				Padding = UDim.new(0, 0),
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
			},
			Sidebar = Atlas:New "Frame" {
				Size = UDim2.new(0, 260, 1, 0),
				BackgroundColor3 = Color3.fromRGB(30, 30, 30),
				LayoutOrder = 1,
				Children = {
					Toplist = Atlas:New "UIListLayout" {
						Padding = UDim.new(0, 0),
						FillDirection = Enum.FillDirection.Vertical,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
					},
					MainList = Atlas:New "Frame" {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0.95),
						Children = {
							Toplist = Atlas:New "UIListLayout" {
								Padding = UDim.new(0, 5),
								FillDirection = Enum.FillDirection.Vertical,
								VerticalAlignment = Enum.VerticalAlignment.Top,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								SortOrder = Enum.SortOrder.LayoutOrder,
							},
							Header = Atlas:New "Frame" {
								Size = UDim2.new(1, 0, 0, 50),
								BackgroundTransparency = 1,
								LayoutOrder = 1,
								Children = {
									LeftList = Atlas:New "UIListLayout" {
										Padding = UDim.new(0, 5),
										FillDirection = Enum.FillDirection.Horizontal,
										VerticalAlignment = Enum.VerticalAlignment.Center,
									},
									Padding = Atlas:New "UIPadding" {
										PaddingLeft = UDim.new(0, 10),
										PaddingTop = UDim.new(0, 8),
									},
									Logo = Atlas:New "ImageLabel" {
										Image = `rbxassetid://116022020747132`,
										Size = UDim2.fromOffset(90, 50),
										BackgroundTransparency = 1,
									},
									Version = Atlas:New "TextLabel" {
										BackgroundTransparency = 1,
										TextColor3 = Color3.fromRGB(129, 129, 129),
										Text = `v0.01`,
										Size = UDim2.fromScale(0.11, 0.5),
										TextScaled = true,
										Font = Enum.Font.MontserratBold,
										Children = {
											Padding = Atlas:New "UIPadding" {
												PaddingTop = UDim.new(0, 5)
											}
										}
									}
								}
							},
							Searchbar = Atlas:New "Frame" {
								Size = UDim2.new(1, 0, 0, 40),
								BackgroundTransparency = 1,
								LayoutOrder = 2,
								Children = {
									Search = Atlas:New "Frame" {
										BackgroundTransparency = 0,
										AnchorPoint = Vector2.new(0.5, 0.5),
										Position = UDim2.fromScale(0.5, 0.5),
										Size = UDim2.fromOffset(210, 30),
										BackgroundColor3 = Color3.fromRGB(49, 49, 53),
										Children = {
											Corners = Atlas:New "UICorner" {
												CornerRadius = UDim.new(0, 9)
											},
											Input = Atlas:New "TextBox" {
												Position = UDim2.fromOffset(35, 0),
												Size = UDim2.fromScale(1, 1),
												BackgroundTransparency = 1,
												TextColor3 = Color3.fromRGB(255, 255, 255),
												PlaceholderColor3 = Color3.fromRGB(161, 161, 161),
												TextSize = 17,
												Font = Enum.Font.Montserrat,
												TextXAlignment = Enum.TextXAlignment.Left,
												Text = ``,
												PlaceholderText = `Search`,
											},
											Icon = Atlas:New "ImageLabel" {
												Size = UDim2.fromOffset(30, 30),
												BackgroundTransparency = 1,
												Image = `rbxassetid://100364551524914`,
												ImageColor3 = Color3.fromRGB(161, 161, 161),
											}
										}
									}
								}
							},
							Seperator = Atlas:New "Frame" {
								Size = UDim2.fromOffset(220, 1),
								BackgroundColor3 = Color3.fromRGB(150, 150, 150),
								BackgroundTransparency = 0.7,
								LayoutOrder = 3,
							},
							List = Atlas:New "ScrollingFrame" {
								Size = UDim2.new(1, 0, 0, 920),
								LayoutOrder = 4,
								BackgroundTransparency = 1,
								ScrollBarThickness = 2,
								ScrollBarImageTransparency = 0.8,
								CanvasSize = UDim2.fromScale(0, 0),
								AutomaticCanvasSize = Enum.AutomaticSize.Y,
								Reference = `List`,
								Children = {
									TopList = Atlas:New "UIListLayout" {
										Padding = UDim.new(0, 0),
										FillDirection = Enum.FillDirection.Vertical,
										VerticalAlignment = Enum.VerticalAlignment.Top,
										HorizontalAlignment = Enum.HorizontalAlignment.Center,
										SortOrder = Enum.SortOrder.LayoutOrder,
									},
								}
							},
						},
					},
					Button = Atlas:New "Frame" {
						Size = UDim2.fromScale(1, 0),
						BackgroundTransparency = 1,
						Children = {
							Flex = Atlas:New "UIFlexItem" {
								FlexMode = Enum.UIFlexMode.Fill,
							},
							Button = Atlas:New "TextButton" {
								AnchorPoint = Vector2.new(0.5, 0.5),
								Size = UDim2.fromScale(0.87, 0.75),
								Position = UDim2.fromScale(0.5, 0.3),
								TextScaled = true,
								Font = Enum.Font.Montserrat,
								BackgroundColor3 = Atlas.computed(function(_, isFirst)
									return isFirst and Color3.fromRGB(67, 67, 67) or Atlas.tween(
										compareAvailable:Get() and Color3.fromRGB(144, 255, 142) or Color3.fromRGB(67, 67, 67), 
										0.3
									)
								end, {compareAvailable}),
								Text = `Compare`,
								TextColor3 = Color3.fromRGB(0, 0, 0),
								Children = {
									Corners = Atlas:New "UICorner" {
										CornerRadius = UDim.new(0, 6)
									},
									TextSize = Atlas:New "UITextSizeConstraint" {
										MaxTextSize = 20,
									}
								},
								Reference = `CompareButton`,
							}
						}
					},
				},
			},
			Display = Atlas:New "Frame" {
				Size = UDim2.fromScale(0, 1),
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(37, 37, 37),
				LayoutOrder = 2,
				Children = {
					Flex = Atlas:New "UIFlexItem" {
						FlexMode = Enum.UIFlexMode.Fill,
					},
					Background = Atlas:New "ImageLabel" {
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						ImageTransparency = 0.95,
						Image = `rbxassetid://106415912242239`,
						ScaleType = Enum.ScaleType.Tile,
						TileSize = UDim2.new(0, 40, 0, 40),
						ZIndex = -50,
					},
					ScriptViewer = Atlas:New "Frame" {
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						Children = {
							TopList = Atlas:New "UIListLayout" {
								Padding = UDim.new(0, 0),
								FillDirection = Enum.FillDirection.Vertical,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								SortOrder = Enum.SortOrder.LayoutOrder,
							},
							Lines = Atlas:New "ScrollingFrame" {
								Size = UDim2.fromScale(1, 1),
								BackgroundTransparency = 1,
								CanvasSize = UDim2.fromScale(0, 0),
								AutomaticCanvasSize = Enum.AutomaticSize.Y,
								Reference = `ScriptLines`,
								Children = {
									Toplist = Atlas:New "UIListLayout" {
										Padding = UDim.new(0, 0),
										FillDirection = Enum.FillDirection.Vertical,
										VerticalAlignment = Enum.VerticalAlignment.Top,
										HorizontalAlignment = Enum.HorizontalAlignment.Center,
										SortOrder = Enum.SortOrder.LayoutOrder,
									},
								}
							}
						}
					}
				}
			}
		}
	}
	
	Atlas.clean(update, container)
	Atlas.Data.ComparisonAvailable = compareAvailable
	return container, Atlas
end