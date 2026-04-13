local Root = require(`./Root`)
local Button = require(`./Button`)

return function(holder)
	local container, localizedAtlas = Root {
		Parent = holder
	}
	local list = localizedAtlas.References.List
	if list then
		local b = Button {
			Parent = list,
		}
	end

	return function()
		container:Destroy()
	end
end