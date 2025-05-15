local player = game.Players.LocalPlayer
local Style = player.PlayerGui.Style.BG.StyleTxt
local slot1 = player.PlayerGui.Style.BG.Slots.ScrollingFrame.Slot1
local TxtSlot = slot1.Text
local desc = player.PlayerGui.Style.BG.Desc
local ingameui = player.PlayerGui.InGameUI
local skills = ingameui.Bottom.Abilities
local Name = "Kaiser"
local id = "rbxassetid://83845612021533"
local uis = game:GetService("UserInputService")
local tweensvc = game:GetService("TweenService")
local skillnames = {
    skill1 = "Kaiser Impact",
    skill2 = "Flower Dribble",
}
local skillbinds = {
    skill1 = "Z",
    skill2 = "T",
}
local skillcount = 1

function changename()
    Style.Text = Name
    slot1.Image = id
    Style.TextColor = Color3.new(1,1,1)
    TxtSlot.Text = Name
    desc.Text = "The Blue Emperor"
end

function createskills()
    while skillcount ~= 4 do
        local sk1 = skills["1"]:Clone()
        sk1.Name = tostring(skillcount)
        sk1.LayoutOrder = 0
        sk1.Timer.Text = skillnames["skill" .. tostring(skillcount)]
        sk1.Keybind.Text = skillbinds["skill" .. tostring(skillcount)]
        sk1.Parent = skills
        skillcount += 1
    end
end

function skill1()
    local args = {250}
    game.ReplicatedStorage.Packages.Knit.Services.BallService.RE.Shoot:FireServer(unpack(args))
end

function skill2()
    local dribblesvc = game.ReplicatedStorage.Packages.Knit.Services.BallService.RE.Dribble
    local humanoidrootpart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local hum = player.Character.Humanoid
    if humanoidrootpart then
        local front = humanoidrootpart.CFrame.LookVector
        local right = humanoidrootpart.CFrame.RightVector
        local left = -humanoidrootpart.CFrame.RightVector
        local diagleft = front + left
        local diagright = front + right
        local count = 5

        local tweeninfo = TweenInfo.new(0.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)

            -- Definindo a nova posição e rotação para o movimento
            repeat
            local goal1_position = humanoidrootpart.Position + (diagleft * 12)
            local goal1_rotation = CFrame.new(humanoidrootpart.Position, goal1_position).LookVector

            -- Criar o CFrame de destino com a posição e rotação ajustada
            local goal1 = CFrame.new(goal1_position, goal1_position + goal1_rotation)

            -- Criar o tween para o primeiro movimento
            local tween1 = tweensvc:Create(humanoidrootpart, tweeninfo, {CFrame = goal1})
            dribblesvc:FireServer()
            tween1:Play()
	        dribblesvc:FireServer()
            tween1.Completed:Wait()
            dribblesvc:FireServer()

            -- Criar o CFrame de destino para o segundo movimento, mantendo a rotação original
            local goal2_position = humanoidrootpart.Position + (diagright * 12)
            local goal2_rotation = CFrame.new(humanoidrootpart.Position, goal2_position).LookVector

            -- Criar o CFrame de destino com a posição e rotação ajustada
            local goal2 = CFrame.new(goal2_position, goal2_position + goal2_rotation)

            local tween2 = tweensvc:Create(humanoidrootpart, tweeninfo, {CFrame = goal2})
            dribblesvc:FireServer()
            tween2:Play()
	        dribblesvc:FireServer()
            tween2.Completed:Wait()
            dribblesvc:FireServer()
            count -= 1
            until count == 0
    end     
end


uis.InputBegan:Connect(function(inputobj, gameprocevent)
    if gameprocevent then return end
    if inputobj.KeyCode == Enum.KeyCode.Z then
        skill1()
    end
    if inputobj.KeyCode == Enum.KeyCode.T then
        skill2()
    end
end)

createskills()
