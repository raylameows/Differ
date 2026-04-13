--!nolint DeprecatedApi
-- To get rid of the stupid Montserrat warning

local Atlas = require(`../Util/Atlas`).localize()

local Line
Line = function(data: {[string]: any})
	local diff = data.Diff
	
	return Atlas:New "Frame" {
		Size = UDim2.new(1, 0, 0, 20),
		BorderSizePixel = 0,
		BackgroundTransparency = diff.Type ~= `added` and diff.Type ~= `removed` and 1 or 0,
		BackgroundColor3 = diff.Type == `added` and Color3.fromRGB(40, 80, 40) or diff.Type == `removed` and Color3.fromRGB(80, 40, 40) or Color3.fromRGB(0, 0, 0),
		Parent = data.Parent,
		Children = {
			Atlas:New "TextLabel" {
				TextColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(1, -10, 1, 0),
				Position = UDim2.new(0, 10, 0, 0),
				BackgroundTransparency = 1,
				Font = Enum.Font.Code,
				TextSize = 16,
				TextXAlignment = Enum.TextXAlignment.Left,
				RichText = true,
				Text = diff.FormattedSource,
			}
		}
	}
end

return Line