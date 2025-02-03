local plr = game.Players.LocalPlayer
local Stats = plr.PlayerStats
local style = Stats.Style
local plrgui = plr.PlayerGui
local skills = plrgui.InGameUI.Bottom.Abilities
local Background = plrgui.Style.BG
local desc = Background.Desc
local txt = Background.StyleTxt
local slots = Background.Slots.ScrollingFrame
local slot = slots.Slot1
local rarities = Background.Rarities.ScrollingFrame

while true do
    task.wait()
    style.Value = "Kaiser"
    desc.Text = "The Emperor"
    slot.Image = rarities["400 Epic"].Image
    slot.ImageColor3 = Color3.new(0,255,255)
    txt.Text = "Kaiser"
    txt.TextColor3 = Color3.new(255,255,255)
    slot.Text.Text = "Kaiser"
    skills["1"].Timer.Text = "Kaiser Impact"
    skills["2"].Timer.Text = "Godly Dribble"
end

if skills["1"]:FindFirstChild("Cooldown") or skills["2"]:FindFirstChild("Cooldown") then
    skills["2"]:FindFirstChild("Cooldown"):Destroy()
    skills["1"]:FindFirstChild("Cooldown"):Destroy()
end

