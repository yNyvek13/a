local hl = Instance.new("Highlight")
hl.FillTransparency = 1
hl.OutlineColor = Color3.fromRGB(255, 0, 255)
hl.OutlineTransparency = 0

for i, v in pairs(game.Players:GetPlayers()) do
    hl:Clone().Parent = v.Character
end
