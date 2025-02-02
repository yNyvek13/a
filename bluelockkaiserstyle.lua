local plr = game.Players.LocalPlayer
local Background = plr.PlayerGui.Style.BG
local desc = Background.Desc
local txt = Background.StyleTxt
local slots = Background.Slots.ScrollingFrame
local slot = slots.Slot1
local rarities = Background.Rarities.ScrollingFrame
local epic = rarities["500 Legendary"]:Clone()
if not rarities:FindFirstChild("700 World") then
    epic.Name = "700 World"
    epic.Parent = rarities
end
local WorldClass = rarities["700 World"]

WorldClass.Image = rarities["400 Epic"].Image
WorldClass.ImageColor3 = Color3.new(0,255,255)
WorldClass.Text.Text = "WORLD (0.05%)"

while true do
    task.wait()
    desc.Text = "The Emperor"
    slot.Image = rarities["400 Epic"].Image
    slot.ImageColor3 = Color3.new(0,255,255)
    txt.Text = "Kaiser"
    txt.TextColor3 = Color3.new(255,255,255)
    slot.Text.Text = "Kaiser"
end
