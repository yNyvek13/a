local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local plr = game.Players.LocalPlayer
local character = plr.Character or plr.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local UIS = game:GetService("UserInputService")
local Stats = plr:WaitForChild("PlayerStats")
local plrgui = plr:WaitForChild("PlayerGui")
local skills = plrgui:WaitForChild("InGameUI").Bottom.Abilities
local Background = plrgui:WaitForChild("Style").BG
local desc = Background.Desc
local txt = Background.StyleTxt
local slot = Background.Slots.ScrollingFrame.Slot1

-- Atualização contínua dos elementos da UI
while txt.Text ~= "Kaiser" do
    task.wait()
    desc.Text = "The Emperor"
    slot.ImageColor3 = Color3.new(0, 0, 0)
    txt.Text = "Kaiser"
    txt.TextColor3 = Color3.new(255, 255, 255)
    slot.Text.Text = "Kaiser"
    skills["1"].Timer.Text = "Kaiser Impact"
    skills["2"].Timer.Text = "Godly Dribble"
end
