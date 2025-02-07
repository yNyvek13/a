local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local plr = game.Players.LocalPlayer
local character = plr.Character or plr.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local UIS = game:GetService("UserInputService")
local Stats = plr:WaitForChild("PlayerStats")
local style = Stats:WaitForChild("Style")
local plrgui = plr:WaitForChild("PlayerGui")
local skills = plrgui:WaitForChild("InGameUI").Bottom.Abilities
local Background = plrgui:WaitForChild("Style").BG
local desc = Background.Desc
local txt = Background.StyleTxt
local slot = Background.Slots.ScrollingFrame.Slot1
local hasball = Workspace:FindFirstChild(plr).Values.HasBall
local abilityCooldown = 0

-- Atualização contínua dos elementos da UI
while style.Value ~= "Kaiser" do
    task.wait()
    style.Value = "Kaiser"
    desc.Text = "The Emperor"
    slot.ImageColor3 = Color3.new(0, 0, 0)
    txt.Text = "Kaiser"
    txt.TextColor3 = Color3.new(255, 255, 255)
    slot.Text.Text = "Kaiser"
    skills["1"].Timer.Text = "Kaiser Impact"
    skills["2"].Timer.Text = "Godly Dribble"
end

-- Função para Chute Hiper Forte (Tecla C)
local function ChuteHiperForte()
    -- Verifica se há a bola e se a habilidade não está em cooldown
    if tick() < abilityCooldown then return end
    if hasball.Value == false then return end

    -- Configura o cooldown da habilidade
    abilityCooldown = tick() + 40  -- Habilidade com cooldown de 40 segundos

    -- Inicia o efeito visual da câmera (campo de visão)
    local cameraTween = TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {FieldOfView = 95})
    cameraTween:Play()
    Debris:AddItem(cameraTween, 0.5)

    -- Inicia animações do jogador e da bola
    local chuteAnim = Instance.new("Animation")
    chuteAnim.AnimationId = "rbxassetid://18723315763"  -- ID da animação de chute
    local animTrack = humanoid:WaitForChild("Animator"):LoadAnimation(chuteAnim)
    animTrack.Priority = Enum.AnimationPriority.Action4  -- Definindo a prioridade da animação para Action4
    animTrack:Play()

    -- Reproduz a animação da bola
    local ball = game.Workspace:FindFirstChild("kevindarcico125").Football
    if ball then
        local ballAnim = Instance.new("Animation")
        ballAnim.AnimationId = "rbxassetid://18723315763"  -- ID da animação de chute da bola
        local ballAnimTrack = ball:FindFirstChild("Humanoid"):WaitForChild("Animator"):LoadAnimation(ballAnim)
        ballAnimTrack:Play()
    end

    -- Efeito de câmera e animação de impacto (iluminação)
    task.delay(0.835, function()
        game.Lighting.ColorCorrection.Contrast = -10
        game.Lighting.ColorCorrection.Saturation = -1
        task.delay(0.05, function()
            game.Lighting.ColorCorrection.Contrast = 10
            game.Lighting.ColorCorrection.Saturation = -1
        end)
        task.delay(0.1, function()
            game.Lighting.ColorCorrection.Contrast = 0.25
            game.Lighting.ColorCorrection.Saturation = 0.5
        end)
        task.delay(0.25, function()
            -- Resetando o estado da habilidade e câmera
            local resetCameraTween = TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {FieldOfView = 70})
            resetCameraTween:Play()
            Debris:AddItem(resetCameraTween, 0.7)
        end)
    end)

    -- Atraso para simular o chute após a animação
    task.delay(0.5, function()
        local ball = game.Workspace:FindFirstChild("kevindarcico125").Football
        if ball then
            -- Deslocar a bola ligeiramente para fora do jogador para garantir que não fique presa
            ball.Position = character.HumanoidRootPart.Position + character.HumanoidRootPart.CFrame.LookVector * 2

            -- Aplicando a física para a bola sair voando
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
            bodyVelocity.Velocity = character.HumanoidRootPart.CFrame.LookVector * 300  -- Aumentando a força para maior distância
            bodyVelocity.Parent = ball

            -- Adicionando o som de chute com volume ajustado
            local chuteSom = Instance.new("Sound")
            chuteSom.SoundId = "rbxassetid://133670968984347"  -- ID do som de chute
            chuteSom.Volume = 0.8  -- Ajustando o volume do som
            chuteSom.Parent = ball
            chuteSom:Play()

            -- Deletar o som após ser reproduzido
            chuteSom.Ended:Connect(function()
                chuteSom:Destroy()
            end)

            -- Remover o BodyVelocity depois de algum tempo (ajustando para simular a física real)
            task.delay(1, function()
                bodyVelocity:Destroy()  -- Permite que a bola continue seu movimento natural após o tempo
            end)
        end
    end)
end

-- Função para ativar as habilidades
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.C then
        ChuteHiperForte()
    end
end)
