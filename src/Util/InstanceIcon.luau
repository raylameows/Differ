local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local InstanceIcon = {}

function InstanceIcon:Check(id: string)
	local dummy = Instance.new(`ImageLabel`)
	dummy.Image = id
	dummy.Parent = ReplicatedStorage
	
	local success = false
	local _, err = pcall(function()
		ContentProvider:PreloadAsync({dummy}, function(assetId, assetFetchStatus)
			success = assetFetchStatus == Enum.AssetFetchStatus.Success
		end)
	end)
	
	dummy:Destroy()
	return success, err
end

function InstanceIcon:Attempt(list: {})
	for _, id in (list) do
		local success = self:Check(id)
		if success then return id end
		print(`Moving to next`)
	end
	
	return ``
end

function InstanceIcon:Get(class: string)
	local prefix = `rbxasset://studio_svg_textures/Shared/InsertableObjects`
	
	return self:Attempt({
		`{prefix}/Dark/Standard/{class}@3x.png`,
		`{prefix}/Dark/Standard/{class}@2x.png`,
		`{prefix}/Dark/Standard/{class}.png`,
		
		`{prefix}/Light/Standard/{class}@3x.png`,
		`{prefix}/Light/Standard/{class}@2x.png`,
		`{prefix}/Light/Standard/{class}.png`,
	})
end

return InstanceIcon