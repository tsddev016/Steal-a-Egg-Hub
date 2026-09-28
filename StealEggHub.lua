-- [[ STEAL A EGG HUB - Speed + Fly + ESP + Anti-Taco + Fling ]] --
-- Atualizado: fly mais estavel, anti-ragdoll, intangivel e fling

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local PhysicsService = game:GetService("PhysicsService")

local player = Players.LocalPlayer

-- ==================== CONFIG ====================
local Config = {
    SpeedEnabled = false,
    SpeedValue = 50,
    FlyEnabled = false,
    FlySpeed = 50,
    ESPEnabled = false,
    AntiTacoEnabled = false,
    FlingEnabled = false,
}

-- ==================== GUI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealEggHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui") -- LocalScript: player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 290, 0, 520)
Main.Position = UDim2.new(0.5, -145, 0.5, -260)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 42)
Title.BackgroundTransparency = 1
Title.Text = "♡ STEAL A EGG HUB ♡"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 17
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = Main

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Parent = Main
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 7)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local function createSection(y, height, titleText)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -28, 0, height)
    section.Position = UDim2.new(0, 14, 0, y)
    section.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    section.BorderSizePixel = 0
    section.Parent = Main
    Instance.new("UICorner", section).CornerRadius = UDim.new(0, 10)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 22)
    title.Position = UDim2.new(0, 10, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = section

    return section
end

local function createToggle(parent, text, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 68, 0, 24)
    btn.Position = UDim2.new(1, -78, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = "OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local function createBox(parent, default, placeholder, y)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -20, 0, 28)
    box.Position = UDim2.new(0, 10, 0, y)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    box.Text = tostring(default)
    box.PlaceholderText = placeholder
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.ClearTextOnFocus = false
    box.Parent = parent
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
    return box
end

-- SPEED
local SpeedSection = createSection(50, 78, "Velocidade")
local SpeedToggle = createToggle(SpeedSection, "OFF", 6)
local SpeedBox = createBox(SpeedSection, Config.SpeedValue, "Valor (ex: 50)", 38)

-- FLY
local FlySection = createSection(136, 78, "Fly (mais estavel)")
local FlyToggle = createToggle(FlySection, "OFF", 6)
local FlyBox = createBox(FlySection, Config.FlySpeed, "Velocidade do Fly", 38)

-- ESP
local ESPSection = createSection(222, 55, "ESP Visual")
local ESPToggle = createToggle(ESPSection, "OFF", 16)

-- ANTI TACO
local AntiSection = createSection(285, 55, "Anti-Taco (Anti-Ragdoll + Intangivel)")
local AntiToggle = createToggle(AntiSection, "OFF", 16)

-- FLING
local FlingSection = createSection(348, 55, "Fling (encosta = voa longe)")
local FlingToggle = createToggle(FlingSection, "OFF", 16)

local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 28)
Footer.Position = UDim2.new(0, 0, 1, -32)
Footer.BackgroundTransparency = 1
Footer.Text = "RightControl = Abrir/Fechar"
Footer.Font = Enum.Font.Gotham
Footer.TextSize = 11
Footer.TextColor3 = Color3.fromRGB(150, 150, 150)
Footer.Parent = Main

-- RGB
RunService.RenderStepped:Connect(function()
    local color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    Stroke.Color = color
    Title.TextColor3 = color
end)

local function setToggle(btn, state)
    if state then
        btn.Text = "ON"
        btn.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        btn.Text = "OFF"
        btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end

-- ==================== SPEED ====================
local function applySpeed()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = Config.SpeedEnabled and Config.SpeedValue or 16
    end
end

SpeedToggle.MouseButton1Click:Connect(function()
    Config.SpeedEnabled = not Config.SpeedEnabled
    setToggle(SpeedToggle, Config.SpeedEnabled)
    applySpeed()
end)

SpeedBox.FocusLost:Connect(function()
    local v = tonumber(SpeedBox.Text)
    if v and v > 0 then
        Config.SpeedValue = v
        if Config.SpeedEnabled then applySpeed() end
    else
        SpeedBox.Text = tostring(Config.SpeedValue)
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(0.4)
    applySpeed()
    if Config.AntiTacoEnabled then enableAntiTaco() end
end)

-- ==================== FLY (mais estavel / menos obvio) ====================
-- Usa BodyVelocity com forca controlada + nao deixa PlatformStand extremo
-- Evita velocidades ridiculas e tenta manter o personagem mais "normal" pro servidor

local flyBV, flyBG
local lastFlyPos = nil

local function startFly()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    lastFlyPos = root.Position

    -- Nao usa PlatformStand = true (isso e muito detectavel)
    -- Em vez disso controla velocity de forma mais suave

    flyBV = Instance.new("BodyVelocity")
    flyBV.Name = "HubFlyBV"
    flyBV.MaxForce = Vector3.new(40000, 40000, 40000) -- forca limitada (menos obvio)
    flyBV.P = 1250
    flyBV.Velocity = Vector3.zero
    flyBV.Parent = root

    flyBG = Instance.new("BodyGyro")
    flyBG.Name = "HubFlyBG"
    flyBG.MaxTorque = Vector3.new(40000, 40000, 40000)
    flyBG.P = 3000
    flyBG.D = 500
    flyBG.Parent = root
end

local function stopFly()
    if flyBV then flyBV:Destroy() flyBV = nil end
    if flyBG then flyBG:Destroy() flyBG = nil end
    lastFlyPos = nil

    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = false
        end
    end
end

FlyToggle.MouseButton1Click:Connect(function()
    Config.FlyEnabled = not Config.FlyEnabled
    setToggle(FlyToggle, Config.FlyEnabled)
    if Config.FlyEnabled then
        startFly()
    else
        stopFly()
    end
end)

FlyBox.FocusLost:Connect(function()
    local v = tonumber(FlyBox.Text)
    if v and v > 0 then
        Config.FlySpeed = math.clamp(v, 1, 120) -- limite pra nao ficar absurdo
        FlyBox.Text = tostring(Config.FlySpeed)
    else
        FlyBox.Text = tostring(Config.FlySpeed)
    end
end)

RunService.Heartbeat:Connect(function()
    if not Config.FlyEnabled or not flyBV or not flyBG then return end

    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    local cam = workspace.CurrentCamera
    local move = Vector3.zero

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 1, 0) end

    if move.Magnitude > 0 then
        move = move.Unit * Config.FlySpeed
    end

    -- Suaviza um pouco a velocidade (menos teleporte / menos flag)
    flyBV.Velocity = flyBV.Velocity:Lerp(move, 0.35)
    flyBG.CFrame = CFrame.new(root.Position, root.Position + cam.CFrame.LookVector)

    -- Cancela ragdoll enquanto voa
    if hum:GetState() == Enum.HumanoidStateType.Physics or hum:GetState() == Enum.HumanoidStateType.Ragdoll then
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        hum.PlatformStand = false
    end
end)

-- ==================== ANTI-TACO ====================
-- Remove ragdoll, reduz knockback e deixa partes nao-colidiveis (intangivel)

local antiConnections = {}

local function setCharacterIntangible(char, state)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
            -- Nao mexe em Anchored pra nao quebrar o personagem
        end
    end
end

function enableAntiTaco()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    -- Desativa estados de ragdoll / falling down
    pcall(function()
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    end)

    setCharacterIntangible(char, true)

    -- Loop que tira ragdoll e zera velocity absurda (anti-knockback)
    local conn = RunService.Heartbeat:Connect(function()
        if not Config.AntiTacoEnabled then return end
        if not char.Parent or not hum.Parent then return end

        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
            or state == Enum.HumanoidStateType.Physics then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum.PlatformStand = false
            hum.Sit = false
        end

        -- Reduz knockback forte
        if root.AssemblyLinearVelocity.Magnitude > 80 then
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity.Unit * 30
        end

        -- Garante intangibilidade
        setCharacterIntangible(char, true)
    end)

    table.insert(antiConnections, conn)
end

local function disableAntiTaco()
    for _, c in pairs(antiConnections) do
        c:Disconnect()
    end
    antiConnections = {}

    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
            end)
        end
        setCharacterIntangible(char, false)
    end
end

AntiToggle.MouseButton1Click:Connect(function()
    Config.AntiTacoEnabled = not Config.AntiTacoEnabled
    setToggle(AntiToggle, Config.AntiTacoEnabled)
    if Config.AntiTacoEnabled then
        enableAntiTaco()
    else
        disableAntiTaco()
    end
end)

-- ==================== FLING ====================
-- Quando ligado, ao encostar em outro player aplica forca forte

local flingConn

local function enableFling()
    if flingConn then flingConn:Disconnect() end

    flingConn = RunService.Heartbeat:Connect(function()
        if not Config.FlingEnabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local otherRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                if otherRoot then
                    local dist = (root.Position - otherRoot.Position).Magnitude
                    if dist < 6 then -- distancia de contato
                        -- Aplica impulso forte no outro (client-side; efeito depende da rede)
                        local dir = (otherRoot.Position - root.Position).Unit
                        local flingPower = 150

                        -- Tenta usar BodyVelocity temporario no outro (funciona melhor em alguns jogos)
                        local bv = Instance.new("BodyVelocity")
                        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                        bv.Velocity = (dir + Vector3.new(0, 0.6, 0)).Unit * flingPower
                        bv.Parent = otherRoot
                        game:GetService("Debris"):AddItem(bv, 0.25)

                        -- Tambem empurra via AssemblyLinearVelocity
                        pcall(function()
                            otherRoot.AssemblyLinearVelocity = (dir + Vector3.new(0, 0.8, 0)).Unit * flingPower
                        end)
                    end
                end
            end
        end
    end)
end

local function disableFling()
    if flingConn then
        flingConn:Disconnect()
        flingConn = nil
    end
end

FlingToggle.MouseButton1Click:Connect(function()
    Config.FlingEnabled = not Config.FlingEnabled
    setToggle(FlingToggle, Config.FlingEnabled)
    if Config.FlingEnabled then
        enableFling()
    else
        disableFling()
    end
end)

-- ==================== ESP ====================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESPObjects"
ESPFolder.Parent = ScreenGui

local function clearESP()
    for _, obj in pairs(ESPFolder:GetChildren()) do
        obj:Destroy()
    end
end

local function createESP(targetPlayer)
    if targetPlayer == player then return end
    if not targetPlayer.Character then return end

    local character = targetPlayer.Character
    local head = character:FindFirstChild("Head")
    local root = character:FindFirstChild("HumanoidRootPart")
    if not head or not root then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = targetPlayer.Name
    highlight.Adornee = character
    highlight.FillColor = Color3.fromRGB(255, 50, 50)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = ESPFolder

    local billboard = Instance.new("BillboardGui")
    billboard.Name = targetPlayer.Name .. "_Name"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = ESPFolder

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = targetPlayer.DisplayName
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Parent = billboard

    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0m"
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextSize = 11
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.TextStrokeTransparency = 0.5
    distLabel.Parent = billboard

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not Config.ESPEnabled or not character.Parent or not root.Parent then
            if connection then connection:Disconnect() end
            return
        end
        local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if myRoot then
            distLabel.Text = math.floor((myRoot.Position - root.Position).Magnitude) .. "m"
        end
    end)
end

local function refreshESP()
    clearESP()
    if not Config.ESPEnabled then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            createESP(plr)
        end
    end
end

ESPToggle.MouseButton1Click:Connect(function()
    Config.ESPEnabled = not Config.ESPEnabled
    setToggle(ESPToggle, Config.ESPEnabled)
    if Config.ESPEnabled then
        refreshESP()
    else
        clearESP()
    end
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.5)
        if Config.ESPEnabled then createESP(plr) end
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    for _, obj in pairs(ESPFolder:GetChildren()) do
        if obj.Name == plr.Name or obj.Name == plr.Name .. "_Name" then
            obj:Destroy()
        end
    end
end)

for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= player then
        plr.CharacterAdded:Connect(function()
            task.wait(0.5)
            if Config.ESPEnabled then createESP(plr) end
        end)
    end
end

-- ==================== TOGGLE UI ====================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
    end
end)

print("✅ Steal a Egg Hub carregado!")
print("Features: Speed | Fly (estavel) | ESP | Anti-Taco | Fling")
print("RightControl = Abrir/Fechar")
