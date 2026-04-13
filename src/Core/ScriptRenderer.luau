local Highlighter = require(`../Packages/Highlighter`)
local Line = require(`../Interface/Line`)

local ScriptRenderer = {}

function ScriptRenderer.Render(node, Atlas)
	local scriptLines = Atlas.References.ScriptLines

	for _, c in scriptLines:GetChildren() do
		if c:IsA(`Frame`) then
			c:Destroy()
		end
	end

	local str = {}

	for _, line in node.SourceDiffs do
		table.insert(str, line.Source)
	end

	local lines = Highlighter.buildRichTextLines({
		src = table.concat(str, `\n`)
	})

	for index, line in lines do
		node.SourceDiffs[index].FormattedSource = line
	end

	for _, diff in node.SourceDiffs do
		Line {
			Diff = diff,
			Parent = scriptLines,
		}
	end
end

return ScriptRenderer