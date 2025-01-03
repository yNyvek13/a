local hl = Instance.new("Highlight")
hl.FillColor = Color3.fromRGB(255, 0, 255)
hl.FillTransparency = 0.25
hl.OutlineColor = Color3.fromRGB(255, 0, 255)
hl.OutlineTransparency = 0

for i, v in pairs(game.Players:GetPlayers()) do
	if v.Name ~= "kevindarcico125" or "kaus_Y8" then
		hl:Clone().Parent = v.Character
	end
end
