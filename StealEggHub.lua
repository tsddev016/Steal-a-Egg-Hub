-- [[ STEAL A EGG HUB - Speed + Fly + ESP ]] --
-- Script limpo e funcional

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ==================== CONFIG ====================
local Config = {
    SpeedEnabled = false,
    SpeedValue = 50,
    FlyEnabled = false,
    FlySpeed = 60,
    ESPEnabled = false,
}

-- ==================== GUI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealEggHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui") -- se for LocalScript no seu jogo, mude para player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 280, 0, 420)
Main.Position = UDim2.new(0.5, -140, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 14)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Parent = Main

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "♡ STEAL A EGG HUB ♡"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = Main

-- Botão fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Parent = Main

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ==================== SPEED ====================
local SpeedSection = Instance.new("Frame")
SpeedSection.Size = UDim2.new(1, -30, 0, 90)
SpeedSection.Position = UDim2.new(0, 15, 0, 55)
SpeedSection.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SpeedSection.BorderSizePixel = 0
SpeedSection.Parent = Main

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 10)
SpeedCorner.Parent = SpeedSection

local SpeedTitle = Instance.new("TextLabel")
SpeedTitle.Size = UDim2.new(1, -20, 0, 25)
SpeedTitle.Position = UDim2.new(0, 10, 0, 8)
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.Text = "Velocidade"
SpeedTitle.Font = Enum.Font.GothamBold
SpeedTitle.TextSize = 14
SpeedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedTitle.TextXAlignment = Enum.TextXAlignment.Left
SpeedTitle.Parent = SpeedSection

local SpeedToggle = Instance.new("TextButton")
SpeedToggle.Size = UDim2.new(0, 70, 0, 26)
SpeedToggle.Position = UDim2.new(1, -80, 0, 8)
SpeedToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedToggle.Text = "OFF"
SpeedToggle.Font = Enum.Font.GothamBold
SpeedToggle.TextSize = 12
SpeedToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
SpeedToggle.Parent = SpeedSection

local SpeedToggleCorner = Instance.new("UICorner")
SpeedToggleCorner.CornerRadius = UDim.new(0, 6)
SpeedToggleCorner.Parent = SpeedToggle

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(1, -20, 0, 32)
SpeedBox.Position = UDim2.new(0, 10, 0, 45)
SpeedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpeedBox.Text = tostring(Config.SpeedValue)
SpeedBox.PlaceholderText = "Velocidade (ex: 50)"
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.TextSize = 14
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.ClearTextOnFocus = false
SpeedBox.Parent = SpeedSection

local SpeedBoxCorner = Instance.new("UICorner")
SpeedBoxCorner.CornerRadius = UDim.new(0, 6)
SpeedBoxCorner.Parent = SpeedBox

-- ==================== FLY ====================
local FlySection = Instance.new("Frame")
FlySection.Size = UDim2.new(1, -30, 0, 90)
FlySection.Position = UDim2.new(0, 15, 0, 155)
FlySection.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FlySection.BorderSizePixel = 0
FlySection.Parent = Main

local FlyCorner = Instance.new("UICorner")
FlyCorner.CornerRadius = UDim.new(0, 10)
FlyCorner.Parent = FlySection

local FlyTitle = Instance.new("TextLabel")
FlyTitle.Size = UDim2.new(1, -20, 0, 25)
FlyTitle.Position = UDim2.new(0, 10, 0, 8)
FlyTitle.BackgroundTransparency = 1
FlyTitle.Text = "Fly"
FlyTitle.Font = Enum.Font.GothamBold
FlyTitle.TextSize = 14
FlyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyTitle.TextXAlignment = Enum.TextXAlignment.Left
FlyTitle.Parent = FlySection

local FlyToggle = Instance.new("TextButton")
FlyToggle.Size = UDim2.new(0, 70, 0, 26)
FlyToggle.Position = UDim2.new(1, -80, 0, 8)
FlyToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FlyToggle.Text = "OFF"
FlyToggle.Font = Enum.Font.GothamBold
FlyToggle.TextSize = 12
FlyToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
FlyToggle.Parent = FlySection

local FlyToggleCorner = Instance.new("UICorner")
FlyToggleCorner.CornerRadius = UDim.new(0, 6)
FlyToggleCorner.Parent = FlyToggle

local FlyBox = Instance.new("TextBox")
FlyBox.Size = UDim2.new(1, -20, 0, 32)
FlyBox.Position = UDim2.new(0, 10, 0, 45)
FlyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FlyBox.Text = tostring(Config.FlySpeed)
FlyBox.PlaceholderText = "Velocidade do Fly"
FlyBox.Font = Enum.Font.Gotham
FlyBox.TextSize = 14
FlyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyBox.ClearTextOnFocus = false
FlyBox.Parent = FlySection

local FlyBoxCorner = Instance.new("UICorner")
FlyBoxCorner.CornerRadius = UDim.new(0, 6)
FlyBoxCorner.Parent = FlyBox

-- ==================== ESP ====================
local ESPSection = Instance.new("Frame")
ESPSection.Size = UDim2.new(1, -30, 0, 70)
ESPSection.Position = UDim2.new(0, 15, 0, 255)
ESPSection.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ESPSection.BorderSizePixel = 0
ESPSection.Parent = Main

local ESPCorner = Instance.new("UICorner")
ESPCorner.CornerRadius = UDim.new(0, 10)
ESPCorner.Parent = ESPSection

local ESPTitle = Instance.new("TextLabel")
ESPTitle.Size = UDim2.new(1, -20, 0, 25)
ESPTitle.Position = UDim2.new(0, 10, 0, 8)
ESPTitle.BackgroundTransparency = 1
ESPTitle.Text = "ESP Visual"
ESPTitle.Font = Enum.Font.GothamBold
ESPTitle.TextSize = 14
ESPTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPTitle.TextXAlignment = Enum.TextXAlignment.Left
ESPTitle.Parent = ESPSection

local ESPToggle = Instance.new("TextButton")
ESPToggle.Size = UDim2.new(0, 70, 0, 26)
ESPToggle.Position = UDim2.new(1, -80, 0, 22)
ESPToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ESPToggle.Text = "OFF"
ESPToggle.Font = Enum.Font.GothamBold
ESPToggle.TextSize = 12
ESPToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
ESPToggle.Parent = ESPSection

local ESPToggleCorner = Instance.new("UICorner")
ESPToggleCorner.CornerRadius = UDim.new(0, 6)
ESPToggleCorner.Parent = ESPToggle

-- Rodapé
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 30)
Footer.Position = UDim2.new(0, 0, 1, -35)
Footer.BackgroundTransparency = 1
Footer.Text = "RightControl = Abrir/Fechar"
Footer.Font = Enum.Font.Gotham
Footer.TextSize = 12
Footer.TextColor3 = Color3.fromRGB(150, 150, 150)
Footer.Parent = Main

-- ==================== RGB EFFECT ====================
RunService.RenderStepped:Connect(function()
    local hue = tick() % 5 / 5
    local color = Color3.fromHSV(hue, 1, 1)
    Stroke.Color = color
    Title.TextColor3 = color
end)

-- ==================== LÓGICA DE VELOCIDADE ====================
local function applySpeed()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if Config.SpeedEnabled then
            humanoid.WalkSpeed = Config.SpeedValue
        else
            humanoid.WalkSpeed = 16
        end
    end
end

SpeedToggle.MouseButton1Click:Connect(function()
    Config.SpeedEnabled = not Config.SpeedEnabled
    if Config.SpeedEnabled then
        SpeedToggle.Text = "ON"
        SpeedToggle.TextColor3 = Color3.fromRGB(100, 255, 100)
        applySpeed()
    else
        SpeedToggle.Text = "OFF"
        SpeedToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
        applySpeed()
    end
end)

SpeedBox.FocusLost:Connect(function()
    local value = tonumber(SpeedBox.Text)
    if value and value > 0 then
        Config.SpeedValue = value
        if Config.SpeedEnabled then
            applySpeed()
        end
    else
        SpeedBox.Text = tostring(Config.SpeedValue)
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(0.3)
    applySpeed()
end)

-- ==================== LÓGICA DE FLY ====================
local bodyVelocity = nil
local bodyGyro = nil

local function startFly()
    local character = player.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then return end

    humanoid.PlatformStand = true

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.Parent = root

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.P = 10000
    bodyGyro.Parent = root
end

local function stopFly()
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
end

FlyToggle.MouseButton1Click:Connect(function()
    Config.FlyEnabled = not Config.FlyEnabled
    if Config.FlyEnabled then
        FlyToggle.Text = "ON"
        FlyToggle.TextColor3 = Color3.fromRGB(100, 255, 100)
        startFly()
    else
        FlyToggle.Text = "OFF"
        FlyToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
        stopFly()
    end
end)

FlyBox.FocusLost:Connect(function()
    local value = tonumber(FlyBox.Text)
    if value and value > 0 then
        Config.FlySpeed = value
    else
        FlyBox.Text = tostring(Config.FlySpeed)
    end
end)

RunService.RenderStepped:Connect(function()
    if not Config.FlyEnabled or not bodyVelocity or not bodyGyro then return end

    local character = player.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local cam = workspace.CurrentCamera
    local direction = Vector3.zero

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        direction = direction + cam.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        direction = direction - cam.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        direction = direction - cam.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        direction = direction + cam.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        direction = direction + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        direction = direction - Vector3.new(0, 1, 0)
    end

    if direction.Magnitude > 0 then
        direction = direction.Unit * Config.FlySpeed
    end

    bodyVelocity.Velocity = direction
    bodyGyro.CFrame = cam.CFrame
end)

-- ==================== LÓGICA DE ESP ====================
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
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")

    if not head or not humanoid or not root then return end

    -- Highlight (caixa colorida)
    local highlight = Instance.new("Highlight")
    highlight.Name = targetPlayer.Name
    highlight.Adornee = character
    highlight.FillColor = Color3.fromRGB(255, 50, 50)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = ESPFolder

    -- Nome + Distância
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
    nameLabel.TextSize = 14
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Parent = billboard

    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0m"
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextSize = 12
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.TextStrokeTransparency = 0.5
    distLabel.Parent = billboard

    -- Atualiza distância
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not Config.ESPEnabled or not character.Parent or not root.Parent then
            if connection then connection:Disconnect() end
            return
        end

        local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if myRoot then
            local distance = math.floor((myRoot.Position - root.Position).Magnitude)
            distLabel.Text = distance .. "m"
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
    if Config.ESPEnabled then
        ESPToggle.Text = "ON"
        ESPToggle.TextColor3 = Color3.fromRGB(100, 255, 100)
        refreshESP()
    else
        ESPToggle.Text = "OFF"
        ESPToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
        clearESP()
    end
end)

-- Atualiza ESP quando alguém entra/sai ou respawna
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.5)
        if Config.ESPEnabled then
            createESP(plr)
        end
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
            if Config.ESPEnabled then
                createESP(plr)
            end
        end)
    end
end

-- ==================== TECLA PARA ABRIR/FECHAR ====================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
    end
end)

print("✅ Steal a Egg Hub carregado! (Speed + Fly + ESP)")
print("RightControl = Abrir/Fechar GUI")
