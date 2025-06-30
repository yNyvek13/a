local plr = game.Players.LocalPlayer
local gui = plr.PlayerGui
local abilities = gui.InGameUI.Bottom.Abilities
local skill1 = "Butterfly Steal"
local skill2 = "Self Pass"
local skill3 = "Butterfly Dribble"

local skill1frame = abilities["1"]:Clone()
skill1frame.Timer:Destroy()
skill1frame.Parent = abilities
skill1frame.Name = "0.1"
skill1frame.ActualTimer.Text = skill1
skill1frame.Cooldown:Destroy()
skill1frame.Keybind.Text = "F"
local skill2frame = abilities["1"]:Clone()
skill2frame.Timer:Destroy()
skill2frame.Parent = abilities
skill2frame.Name = "0.2"
skill2frame.ActualTimer.Text = skill2
skill2frame.Cooldown:Destroy()
skill2frame.Keybind.Text = "Y"
local skill3frame = abilities["1"]:Clone()
skill3frame.Timer:Destroy()
skill3frame.Parent = abilities
skill3frame.Name = "0.3"
skill3frame.ActualTimer.Text = skill3
skill3frame.Cooldown:Destroy()
skill3frame.Keybind.Text = "H"

local uis = game:GetService("UserInputService")

uis.InputBegan:Connect(function(key, GPE)
    if GPE then return end
    if key.KeyCode == Enum.KeyCode.F then
        local RunService = game:GetService("RunService")
	local TweenService = game:GetService("TweenService")
	local Players = game:GetService("Players")
	
	local player = Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local rootPart = character:WaitForChild("HumanoidRootPart")
	local humanoid = character:WaitForChild("Humanoid")
	
	local ball = workspace:WaitForChild("Football")
	
	local dashDistance = 100
	local dashSpeed = 50
	local perseguindo = false
	
	local animationObject = game.ReplicatedStorage.Assets.ReplicatedAnims.Abilities.Fadeaway
	local animTrack = humanoid:LoadAnimation(animationObject)
	
	local function tocarAnimacao()
		animTrack:Play()
	end
	
	local function dashParaBola()
		if perseguindo then return end
		perseguindo = true
	
		local distanciaInicial = (ball.Position - rootPart.Position).Magnitude
		if distanciaInicial > dashDistance then
			print("Bola está muito longe para dar dash")
			perseguindo = false
			return
		end
	
		tocarAnimacao()
		rootPart.Anchored = true
	
		local conn
		conn = RunService.RenderStepped:Connect(function(dt)
			if not ball or not ball.Parent then
				rootPart.Anchored = false
				conn:Disconnect()
				perseguindo = false
				return
			end
	
			local atual = rootPart.Position
			local targetPos
	
			if ball.Position.Y < rootPart.Position.Y then
				-- Seguir só X e Z, manter Y atual
				targetPos = Vector3.new(ball.Position.X, atual.Y, ball.Position.Z)
			else
				-- Seguir X, Y e Z da bola
				targetPos = ball.Position
			end
	
			local distancia = (targetPos - atual).Magnitude
	
			if distancia > dashDistance then
				print("Bola saiu do alcance do dash")
				rootPart.Anchored = false
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
	
				-- Define posição sem alterar rotação (sem girar no eixo Y)
				rootPart.CFrame = CFrame.new(novo)
			else
				-- Parar e desancorar quando encostar na bola (sem pulo)
				rootPart.Anchored = false
				conn:Disconnect()
				perseguindo = false
				print("Grudado na bola.")
			end
		end)
	end
	
	-- Teste manual
	dashParaBola()
    elseif key.KeyCode == Enum.KeyCode.Y then
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	
	local plr = Players.LocalPlayer
	local character = plr.Character or plr.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")
	local mouse = plr:GetMouse()
	
	local services = game.ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services")
	local ballservice = services:WaitForChild("BallService"):WaitForChild("RE")
	local shotevent = ballservice:WaitForChild("Shoot")
	
	--================= CONFIGURAÇÕES =================--
	local raio = 20                       
	local anguloInicial = 0    
	local anguloFinal = math.pi * 0.45   
	local duracaoArco = 0.6              
	local tempoParado = 4                
	local velocidadeFinal = 150           
	--==================================================--
	
	-- Dispara para o servidor criar a bola
	shotevent:FireServer(1)
	
	local ball = workspace:WaitForChild("Football")
	ball.Anchored = false
	
	-- Criar Attachment para LinearVelocity (central)
	local lvAttachment = Instance.new("Attachment")
	lvAttachment.Name = "LVAttachment"
	lvAttachment.Parent = ball
	lvAttachment.Position = Vector3.new(0, 0, 0)
	
	-- Criar LinearVelocity
	local lv = Instance.new("LinearVelocity")
	lv.Attachment0 = lvAttachment
	lv.MaxForce = math.huge
	lv.RelativeTo = Enum.ActuatorRelativeTo.World
	lv.Enabled = false
	lv.Parent = ball
	
	-- Criar Attachments para a Trail (em posições opostas)
	local attach1 = Instance.new("Attachment")
	attach1.Name = "TrailAttachment1"
	attach1.Parent = ball
	attach1.Position = Vector3.new(0, 0.5, 0) -- topo da bola (ajuste conforme o tamanho da bola)
	
	local attach2 = Instance.new("Attachment")
	attach2.Name = "TrailAttachment2"
	attach2.Parent = ball
	attach2.Position = Vector3.new(0, -0.5, 0) -- base da bola (posição oposta)
	
	-- Criar a Trail
	local trail = Instance.new("Trail")
	trail.Attachment0 = attach1
	trail.Attachment1 = attach2
	trail.Color = ColorSequence.new(Color3.new(255, 255, 0))
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
	
	-- Função para criar e emitir partículas na bola
	local function emitirParticulas()
		local emitter = Instance.new("ParticleEmitter")
		emitter.Texture = "rbxassetid://12800313372" -- exemplo: faíscas, pode trocar
		emitter.Rate = 1
		emitter.Lifetime = NumberRange.new(0.5)
		emitter.Speed = NumberRange.new(25, 50)
	    emitter.Drag = 15
	    emitter.SpreadAngle = Vector2.new(360, 360)
	    emitter.LightInfluence = 0
	    emitter.Orientation = Enum.ParticleOrientation.VelocityParallel
	    emitter.Brightness = 5
	    emitter.Transparency = NumberSequence.new(0,1)
	    emitter.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid2x2
	    emitter.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
	    emitter.Color = ColorSequence.new(Color3.new(255, 255, 0))
		emitter.Size = NumberSequence.new(2, 4)
		emitter.Parent = ball
		
		-- Emite 50 partículas instantaneamente (impacto)
		emitter:Emit(50)
		
		-- Depois de um tempo curto, destrói o emitter
		task.delay(1, function()
			emitter:Destroy()
		end)
	end
	
	
	-- Centro do arco: deslocado para cima e atrás da bola, criando curva em "C"
	local start = ball.Position
	local centro = start + Vector3.new(0, raio * 0.5, -raio * 0.5)
	
	local t = 0
	local connection
	
	-- Variável para armazenar conexão do teleguiamento
	local guideConn
	
	-- Função para limpar componentes e desconectar, incluindo trail e attachments
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
	end
	
	-- Evento para detectar toque da bola no jogador
	ball.Touched:Connect(function(hit)
		if hit == root then
			limparComponentes()
		end
	end)
	
	connection = RunService.RenderStepped:Connect(function(dt)
		t += dt / duracaoArco
		if t >= 1 then t = 1 end
	
		local theta = anguloInicial + (anguloFinal - anguloInicial) * t
		local offset = Vector3.new(0, math.sin(theta), math.cos(theta)) * raio
		ball.Position = centro + offset
	
		if t >= 1 then
			connection:Disconnect()
	
			ball.Anchored = true
			task.delay(tempoParado, function()
				ball.Anchored = false
	
				emitirParticulas()  -- Emite partículas ao fim da pausa
	
				lv.Enabled = true
	
				-- Ativa teleguiamento para o jogador
				guideConn = RunService.RenderStepped:Connect(function()
					if not ball or not ball.Parent or not root then
						limparComponentes()
						return
					end
	
					local direction = (root.Position - ball.Position).Unit * velocidadeFinal
					lv.VectorVelocity = direction
				end)
			end)
		end
	end)
    elseif key.KeyCode == Enum.KeyCode.H then
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
end)
