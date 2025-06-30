local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local uis = game:GetService("UserInputService")

local services = game.ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services")
local ballservice = services:WaitForChild("BallService"):WaitForChild("RE")
local shotevent = ballservice:WaitForChild("Shoot")

local gui = player.PlayerGui
local abilities = gui.InGameUI.Bottom.Abilities

local skill1 = "Butterfly Steal"
local skill2 = "Self Pass"
local skill3 = "Butterfly Dribble"

-- Função para criar skill frames
local function createSkillFrame(keybindText, skillName)
    local frame = abilities["1"]:Clone()
    frame.Timer:Destroy()
    frame.Cooldown:Destroy()
    frame.Parent = abilities
    frame.Name = tostring(keybindText)
    frame.ActualTimer.Text = skillName
    frame.Keybind.Text = keybindText
    return frame
end

local skill1frame = createSkillFrame("F", skill1)
local skill2frame = createSkillFrame("Y", skill2)
local skill3frame = createSkillFrame("H", skill3)

uis.InputBegan:Connect(function(key, GPE)
    if GPE then return end

    if key.KeyCode == Enum.KeyCode.F then
        -- Skill 1: Dash para bola
        local characterF = player.Character or player.CharacterAdded:Wait()
        local rootPartF = characterF:WaitForChild("HumanoidRootPart")
        local humanoidF = characterF:WaitForChild("Humanoid")
        local ballF = workspace:WaitForChild("Football")

        local dashDistance = 100
        local dashSpeed = 50
        local perseguindo = false

        local animationObject = game.ReplicatedStorage.Assets.ReplicatedAnims.Abilities.Fadeaway
        local animTrack = humanoidF:LoadAnimation(animationObject)

        local function tocarAnimacao()
            animTrack:Play()
        end

        local function dashParaBola()
            if perseguindo then return end
            perseguindo = true

            local distanciaInicial = (ballF.Position - rootPartF.Position).Magnitude
            if distanciaInicial > dashDistance then
                print("Bola está muito longe para dar dash")
                perseguindo = false
                return
            end

            tocarAnimacao()
            rootPartF.Anchored = true

            local conn
            conn = RunService.RenderStepped:Connect(function(dt)
                if not ballF or not ballF.Parent then
                    rootPartF.Anchored = false
                    conn:Disconnect()
                    perseguindo = false
                    return
                end

                local atual = rootPartF.Position
                local targetPos

                if ballF.Position.Y < rootPartF.Position.Y then
                    targetPos = Vector3.new(ballF.Position.X, atual.Y, ballF.Position.Z)
                else
                    targetPos = ballF.Position
                end

                local distancia = (targetPos - atual).Magnitude

                if distancia > dashDistance then
                    print("Bola saiu do alcance do dash")
                    rootPartF.Anchored = false
                    conn:Disconnect()
                    perseguindo = false
                    return
                end

                if distancia > 0.1 then
                    local direcao = (targetPos - atual).Unit
                    local deslocamento = direcao * dashSpeed * dt
                    local novo = atual + deslocamento

                    if (novo - targetPos).Magnitude < 0.1 then
                        novo = targetPos
                    end

                    rootPartF.CFrame = CFrame.new(novo)
                else
                    rootPartF.Anchored = false
                    conn:Disconnect()
                    perseguindo = false
                    print("Grudado na bola.")
                end
            end)
        end

        dashParaBola()

    elseif key.KeyCode == Enum.KeyCode.Y then
        -- Skill 2: Self Pass
        local characterY = player.Character or player.CharacterAdded:Wait()
        local rootY = characterY:WaitForChild("HumanoidRootPart")

        -- Configurações da skill
        local raio = 20
        local anguloInicial = 0
        local anguloFinal = math.pi * 0.45
        local duracaoArco = 0.6
        local tempoParado = 4
        local velocidadeFinal = 150

        shotevent:FireServer(25)
        wait(0.25)
        local ball = workspace:WaitForChild("Football")
        ball.Anchored = false

        local lvAttachment = Instance.new("Attachment")
        lvAttachment.Name = "LVAttachment"
        lvAttachment.Parent = ball
        lvAttachment.Position = Vector3.new(0, 0, 0)

        local lv = Instance.new("LinearVelocity")
        lv.Attachment0 = lvAttachment
        lv.MaxForce = math.huge
        lv.RelativeTo = Enum.ActuatorRelativeTo.World
        lv.Enabled = false
        lv.Parent = ball

        local attach1 = Instance.new("Attachment")
        attach1.Name = "TrailAttachment1"
        attach1.Parent = ball
        attach1.Position = Vector3.new(0, 0.5, 0)

        local attach2 = Instance.new("Attachment")
        attach2.Name = "TrailAttachment2"
        attach2.Parent = ball
        attach2.Position = Vector3.new(0, -0.5, 0)

        local trail = Instance.new("Trail")
        trail.Attachment0 = attach1
        trail.Attachment1 = attach2
        trail.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0))
        trail.LightEmission = 0
        trail.Texture = "rbxassetid://16892450421"
        trail.Brightness = 5
        trail.MaxLength = 1000
        trail.Transparency = NumberSequence.new(0, 1)
        trail.FaceCamera = true
        trail.LightInfluence = 0
        trail.Lifetime = 2
        trail.Parent = ball
        trail.Enabled = true

        local function emitirParticulas()
            local emitter = Instance.new("ParticleEmitter")
            emitter.Texture = "rbxassetid://12800313372"
            emitter.Rate = 1
            emitter.Lifetime = NumberRange.new(0.5)
            emitter.Speed = NumberRange.new(25, 50)
            emitter.Drag = 15
            emitter.SpreadAngle = Vector2.new(360, 360)
            emitter.LightInfluence = 0
            emitter.Orientation = Enum.ParticleOrientation.VelocityParallel
            emitter.Brightness = 5
            emitter.Transparency = NumberSequence.new(0, 1)
            emitter.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid2x2
            emitter.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
            emitter.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0))
            emitter.Size = NumberSequence.new(2, 4)
            emitter.Parent = ball

            emitter:Emit(50)

            task.delay(1, function()
                emitter:Destroy()
            end)
        end

        local start = ball.Position
        local centro = start + Vector3.new(0, raio * 0.5, -raio * 0.5)

        local t = 0
        local connection
        local guideConn

        local function limparComponentes()
            if lvAttachment then lvAttachment:Destroy() end
            if lv then lv:Destroy() end
            if attach1 then attach1:Destroy() end
            if attach2 then attach2:Destroy() end
            if trail then
                trail.Enabled = false
                trail:Destroy()
            end
            if guideConn then
                guideConn:Disconnect()
                guideConn = nil
            end
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end

        ball.Touched:Connect(function(hit)
            if hit and hit.Parent == characterY then
                limparComponentes()
            end
        end)

        connection = RunService.RenderStepped:Connect(function(dt)
            t += dt / duracaoArco
            if t >= 1 then t = 1 end

            local theta = anguloInicial + (anguloFinal - anguloInicial) * t
            local offset = Vector3.new(0, math.sin(theta), math.cos(theta)) * raio
            ball.CFrame = CFrame.new(centro + offset)

            if t >= 1 then
                connection:Disconnect()
                ball.Anchored = true
                task.delay(tempoParado, function()
                    ball.Anchored = false
                    emitirParticulas()
                    lv.Enabled = true

                    guideConn = RunService.RenderStepped:Connect(function()
                        if not ball or not ball.Parent or not rootY then
                            limparComponentes()
                            return
                        end
                        local direction = (rootY.Position - ball.Position).Unit * velocidadeFinal
                        lv.VectorVelocity = direction
                    end)
                end)
            end
        end)

    elseif key.KeyCode == Enum.KeyCode.H then
        -- Skill 3: Butterfly Dribble (movimento em S)
        local a = game.ReplicatedStorage.Controllers
        local characterH = player.Character or player.CharacterAdded:Wait()
        local hum = characterH:WaitForChild("Humanoid")
        local rootPartH = characterH:WaitForChild("HumanoidRootPart")

        local Ball = characterH:WaitForChild("PlrFootball")

        local attachment1 = characterH.Torso.RightCollarAttachment
        local attachment2 = characterH.Torso.LeftCollarAttachment

        local trail = Instance.new("Trail")
        trail.FaceCamera = true
        trail.Transparency = NumberSequence.new(0, 1)
        trail.LightInfluence = 0
        trail.Brightness = 5
        trail.MaxLength = 25
        trail.Lifetime = 0.5
        trail.WidthScale = NumberSequence.new(1, 0)
        trail.Texture = "rbxassetid://16892450421"
        trail.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 255, 0))
        trail.Attachment0 = attachment1
        trail.Attachment1 = attachment2
        trail.Parent = attachment1.Parent

        local particle = Instance.new("ParticleEmitter")
        particle.Parent = characterH.Torso
        particle.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 255, 0))
        particle.Speed = NumberRange.new(0)
        particle.Texture = "rbxassetid://12800313372"
        particle.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid2x2
        particle.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
        particle.Lifetime = NumberRange.new(0.25)
        particle.Rotation = NumberRange.new(-1000, 1000)
        particle.Rate = 100
        particle.LightInfluence = 0
        particle.Brightness = 5
        particle.Size = NumberSequence.new(2.5)

        local anims = a.AnimationController

        local animtrack1 = hum:LoadAnimation(anims.ZombieDribble1)
        animtrack1.Priority = Enum.AnimationPriority.Action4

        local animtrack2 = hum:LoadAnimation(anims.ZombieDribble2)
        animtrack2.Priority = Enum.AnimationPriority.Action4

        animtrack1:Play(0.1, 1, 1)
        task.delay(0.75, function()
            animtrack1:Stop()
        end)

        animtrack1.Ended:Connect(function()
            animtrack2:Play(0.1, 1, 1)
        end)

        local duration = 2
        local amplitude = 10
        local frequency = 2
        local distance = 150
        local startTime = tick()

        local startPos = rootPartH.Position
        local forwardDir = rootPartH.CFrame.LookVector
        local rightDir = rootPartH.CFrame.RightVector

        local conn
        conn = RunService.RenderStepped:Connect(function()
            local elapsed = tick() - startTime
            local alpha = math.clamp(elapsed / duration, 0, 1)

            local forwardOffset = forwardDir * (distance * alpha)
            local sideOffset = rightDir * math.sin(alpha * math.pi * frequency) * amplitude
            local newPosition = startPos + forwardOffset + sideOffset

            rootPartH.CFrame = CFrame.new(newPosition, newPosition + forwardDir)

            if alpha >= 1 then
                conn:Disconnect()
                animtrack2:Stop()
                trail:Destroy()
                particle:Destroy()
            end
        end)
    end
end)
