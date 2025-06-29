local plr = game.Players.LocalPlayer
local gui = plr.PlayerGui
local abilities = gui.InGameUI.Bottom.Abilities
local skill1 = "Butterfly Dribble"
local skill2 = "Curve Shot"
local skill3 = "Lavinho Shot"

local skill1frame = abilities["1"]:Clone()
skill1frame.Timer:Destroy()
skill1frame.Parent = abilities
skill1frame.Name = 0.25
skill1frame.ActualTimer.Text = skill1
skill1frame.Cooldown:Destroy()
skill1frame.Keybind.Text = "F"
local skill2frame = abilities["1"]:Clone()
skill2frame.Timer:Destroy()
skill2frame.Parent = abilities
skill2frame.Name = 0.25
skill2frame.ActualTimer.Text = skill2
skill2frame.Cooldown:Destroy()
skill2frame.Keybind.Text = "Y"
local skill3frame = abilities["1"]:Clone()
skill3frame.Timer:Destroy()
skill3frame.Parent = abilities
skill3frame.Name = 0.25
skill3frame.ActualTimer.Text = skill3
skill3frame.Cooldown:Destroy()
skill3frame.Keybind.Text = "H"

local uis = game:GetService("UserInputService")

local isLocked = false -- Estado do toggle

local function toggleMouseLock()
	isLocked = not isLocked

	if isLocked then
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		UserInputService.MouseIconEnabled = false
	else
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		UserInputService.MouseIconEnabled = true
	end
end

uis.InputBegan:Connect(function(key, GPE)
    if GPE then return end
    if key.KeyCode == Enum.KeyCode.F then
        local TweenService = game:GetService("TweenService")
        local RunService = game:GetService("RunService")
        local a = game.ReplicatedStorage.Controllers
        local plr = game.Players.LocalPlayer
        local Anims = a.AnimationController

        local char = plr.Character or plr.CharacterAdded:Wait()
        local hum = char:WaitForChild("Humanoid")
        local rootPart = char:WaitForChild("HumanoidRootPart")
        local Ball = char:WaitForChild("PlrFootball")

        local attachment1 = char.Torso.RightCollarAttachment
        local attachment2 = char.Torso.LeftCollarAttachment

        -- === Trail ===
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

        -- === Partículas ===
        local particle = Instance.new("ParticleEmitter")
        particle.Parent = char.Torso
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

        -- === Animação ===
        local animtrack1 = hum:LoadAnimation(Anims.ZombieDribble1)
        animtrack1.Priority = Enum.AnimationPriority.Action4

        local animtrack2 = hum:LoadAnimation(Anims.ZombieDribble2)
        animtrack2.Priority = Enum.AnimationPriority.Action4

        animtrack1:Play(0.1, 1, 1)
        task.delay(0.75, function()
            animtrack1:Stop()
        end)

        animtrack1.Ended:Connect(function()
            animtrack2:Play(0.1, 1, 1)
        end)

        -- === Parâmetros do movimento em S ===
        local duration = 2
        local amplitude = 10          -- Largura do "S"
        local frequency = 2          -- Quantas curvas (meio-S por ciclo)
        local distance = 150         -- Distância para frente
        local startTime = tick()

        local startPos = rootPart.Position
        local forwardDir = rootPart.CFrame.LookVector
        local rightDir = rootPart.CFrame.RightVector

        -- === Movimento em S deitado ===
        local conn
        conn = RunService.RenderStepped:Connect(function()
            local elapsed = tick() - startTime
            local alpha = math.clamp(elapsed / duration, 0, 1)

            local forwardOffset = forwardDir * (distance * alpha)
            local sideOffset = rightDir * math.sin(alpha * math.pi * frequency) * amplitude
            local newPosition = startPos + forwardOffset + sideOffset

            rootPart.CFrame = CFrame.new(newPosition, newPosition + forwardDir)

            if alpha >= 1 then
                conn:Disconnect()
                animtrack2:Stop()
                trail:Destroy()
                particle:Destroy()
            end
        end)
    elseif key.KeyCode == Enum.KeyCode.Y then
        local RunService = game:GetService("RunService")
        local plr = game.Players.LocalPlayer
        local mouse = plr:GetMouse()
        local services = game.ReplicatedStorage.Packages.Knit.Services
        local ballservice = services.BallService.RE
        local shotevent = ballservice.Shoot

        shotevent:FireServer(1)

        local ball = workspace:WaitForChild("Football")

        local startPos = ball.Position
        mouse.TargetFilter = ball
        local mousePos = mouse.Hit.Position
        local direction = (mousePos - startPos).Unit
        local endPos = mousePos

        local char = plr.Character or plr.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

        -- Curva para frente e para a direita
        local frontRight = (hrp.CFrame.LookVector + hrp.CFrame.RightVector).Unit * 30
        local curvePos = startPos + frontRight + Vector3.new(0, 7, 0) -- altura do arco

        local function quadLerp(a, b, c, t)
            local ab = a:Lerp(b, t)
            local bc = b:Lerp(c, t)
            return ab:Lerp(bc, t)
        end

        local duration = 0.75
        local startTime = tick()
        local ignoreCollision = true

        local conn

        local function stopMovement()
            if conn then
                conn:Disconnect()
                conn = nil
            end
        end

        local function onTouch(hit)
            if ignoreCollision then return end
            if hit and hit:IsA("BasePart") and hit.Transparency < 1 then
                stopMovement()
                -- opcional: parar bola aqui
            end
        end

        ball.Touched:Connect(onTouch)

        conn = RunService.RenderStepped:Connect(function()
            local elapsed = tick() - startTime
            local alpha = math.clamp(elapsed / duration, 0, 1)
            local newPos = quadLerp(startPos, curvePos, endPos, alpha)
            ball.CFrame = CFrame.new(newPos)

            if elapsed > 0.25 then
                ignoreCollision = false
            end

            if alpha >= 1 then
                stopMovement()

                local attachment = Instance.new("Attachment")
                attachment.Parent = ball

                local linearvel = Instance.new("LinearVelocity")
                linearvel.Attachment0 = attachment
                linearvel.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
                linearvel.RelativeTo = Enum.ActuatorRelativeTo.World
                linearvel.MaxForce = math.huge
                linearvel.VectorVelocity = direction * 160
                linearvel.Name = "BallLinearVelocity"
                linearvel.Parent = ball

                task.delay(2, function()
                    if linearvel and linearvel.Parent then
                        linearvel:Destroy()
                    end
                    if attachment and attachment.Parent then
                        attachment:Destroy()
                    end
                end)
            end
        end)
    elseif key.KeyCode == Enum.KeyCode.H then
        local plr = game.Players.LocalPlayer
        local mouse = plr:GetMouse()
        local services = game.ReplicatedStorage.Packages.Knit.Services
        local ballservice = services.BallService.RE
        local shotevent = ballservice.Shoot

        local char = plr.Character or plr.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

        -- Cria o Attachment
        shotevent:FireServer(1)
        local ball = workspace:WaitForChild("Football")
        local attachment = Instance.new("Attachment")
        attachment.Parent = ball

        -- Calcula a direção para o mouse
        mouse.TargetFilter = ball
        local mousePos = mouse.Hit.Position
        local direction = (mousePos - ball.Position).Unit

        -- Cria o LinearVelocity corretamente
        local linearvel = Instance.new("LinearVelocity")
        linearvel.Attachment0 = attachment
        linearvel.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
        linearvel.RelativeTo = Enum.ActuatorRelativeTo.World
        linearvel.MaxForce = math.huge
        linearvel.VectorVelocity = direction * 320  -- aplica velocidade com força
        linearvel.Name = "BallKick"
        linearvel.Parent = ball

        -- Dispara evento do servidor (caso necessário)

        -- Opcional: remover a força depois de 1 segundo
        task.delay(1, function()
            if linearvel and linearvel.Parent then
                linearvel:Destroy()
            end
            if attachment and attachment.Parent then
                attachment:Destroy()
            end
        end)
    elseif key.KeyCode == Enum.KeyCode.LeftControl then
        toggleMouseLock()
    end
end)
