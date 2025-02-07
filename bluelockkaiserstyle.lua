local plr = game.Players.LocalPlayer
local character = plr.Character or plr.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local UIS = game:GetService("UserInputService")

-- Atualização dos elementos da UI
local Stats = plr:WaitForChild("PlayerStats")
local style = Stats:WaitForChild("Style")
local plrgui = plr:WaitForChild("PlayerGui")
local skills = plrgui:WaitForChild("InGameUI").Bottom.Abilities
local Background = plrgui:WaitForChild("Style").BG
local desc = Background.Desc
local txt = Background.StyleTxt
local slot = Background.Slots.ScrollingFrame.Slot1

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

-- Função para Drible Rápido (Tecla V)
local function DribleRapido()
    -- Aumenta a velocidade do jogador
    humanoid.WalkSpeed = 50

    -- Distância para a pedalada (aumentada para ficar mais longo)
    local pedalDistance = 40  -- Aumenta a distância da pedalada (agora mais longa)
    local moveSpeed = 0.1    -- Reduz o tempo de espera para acelerar os movimentos (mais rápido)
    local pedalCount = 10     -- Aumenta a quantidade de pedaladas para ter mais movimento (pedaladas mais longas)

    -- Movimenta o personagem para a direita e esquerda com MoveTo
    for i = 1, pedalCount do  -- Aumenta o número de movimentos para mais pedaladas
        -- Alterna para a direita e esquerda com base na orientação do personagem
        local rightVector = character.HumanoidRootPart.CFrame.RightVector
        local leftVector = -rightVector

        -- Move para a direita usando MoveTo
        humanoid:MoveTo(character.HumanoidRootPart.Position + rightVector * pedalDistance)
        wait(moveSpeed)
        -- Move para a esquerda usando MoveTo
        humanoid:MoveTo(character.HumanoidRootPart.Position + leftVector * pedalDistance)
        wait(moveSpeed)
    end

    -- Movimentar para frente com MoveTo (aumentando a distância também)
    local forwardPosition = character.HumanoidRootPart.Position + character.HumanoidRootPart.CFrame.LookVector * 30  -- Movimento para frente (agora 30 metros)
    humanoid:MoveTo(forwardPosition)

    -- Atraso para garantir que o drible rápido aconteça por um tempo
    wait(2)  -- Tempo reduzido de espera após o drible
    humanoid.WalkSpeed = 16 -- Retorna à velocidade normal
end


-- Função para Chute Hiper Forte (Tecla C)
local function ChuteHiperForte()
    -- Acessando a bola diretamente do Workspace (garanta que ela está lá)
    local ball = game.Workspace:FindFirstChild("Football")
    
    if ball then
        -- Acelera a bola com a direção do jogador
        ball.Velocity = character.HumanoidRootPart.CFrame.LookVector * 100  -- Chute com alta velocidade
        ball.Parent = game.Workspace -- Garante que a bola está na Workspace

        -- Efeito visual (Highlight piscante no jogador)
        local highlight = Instance.new("Highlight")
        highlight.Parent = character
        highlight.FillColor = Color3.fromRGB(255, 215, 0)  -- Cor dourada
        highlight.OutlineColor = Color3.fromRGB(255, 215, 0)
        highlight.OutlineTransparency = 0.5
        highlight.FillTransparency = 0.5
        highlight.Enabled = true

        -- Deletar o highlight após um tempo
        wait(1)
        highlight:Destroy()
    else
        warn("Football não encontrado no Workspace!") -- Aviso caso a bola não exista
    end
end

-- Função para ativar as habilidades
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.V then
        DribleRapido()
    elseif input.KeyCode == Enum.KeyCode.C then
        ChuteHiperForte()
    end
end)
