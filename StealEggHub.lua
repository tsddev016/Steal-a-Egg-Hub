-- [[ STEAL A EGG HUB v3 ]] --
-- Fix: Speed loop | Fly CFrame (sem BodyVelocity) | Anti-Taco sem lag | Hitbox menor | Fling

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local LP = Players.LocalPlayer

local Config = {
    Speed = false,
    SpeedVal = 45,
    Fly = false,
    FlySpeed = 2.2, -- studs por frame (teleporte suave)
    ESP = false,
    AntiTaco = false,
    Fling = false,
}

-- ==================== GUI ====================
local SG = Instance.new("ScreenGui")
SG.Name = "StealEggHub"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 280, 0, 500)
Main.Position = UDim2.new(0.5, -140, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = SG
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "♡ STEAL A EGG HUB v3 ♡"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.new(1, 1, 1)

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 28, 0, 28)
Close.Position = UDim2.new(1, -34, 0, 6)
Close.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 13
Close.TextColor3 = Color3.fromRGB(255, 90, 90)
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)
Close.MouseButton1Click:Connect(function() SG:Destroy() end)

local function section(y, h, txt)
    local f = Instance.new("Frame", Main)
    f.Size = UDim2.new(1, -24, 0, h)
    f.Position = UDim2.new(0, 12, 0, y)
    f.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 9)
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, -16, 0, 20)
    t.Position = UDim2.new(0, 8, 0, 5)
    t.BackgroundTransparency = 1
    t.Text = txt
    t.Font = Enum.Font.GothamBold
    t.TextSize = 12
    t.TextColor3 = Color3.new(1, 1, 1)
    t.TextXAlignment = Enum.TextXAlignment.Left
    return f
end

local function toggle(parent, y)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0, 64, 0, 22)
    b.Position = UDim2.new(1, -72, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.Text = "OFF"
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.TextColor3 = Color3.fromRGB(255, 100, 100)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    return b
end

local function box(parent, val, ph, y)
    local t = Instance.new("TextBox", parent)
    t.Size = UDim2.new(1, -16, 0, 26)
    t.Position = UDim2.new(0, 8, 0, y)
    t.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    t.Text = tostring(val)
    t.PlaceholderText = ph
    t.Font = Enum.Font.Gotham
    t.TextSize = 12
    t.TextColor3 = Color3.new(1, 1, 1)
    t.ClearTextOnFocus = false
    Instance.new("UICorner", t).CornerRadius = UDim.new(0, 5)
    return t
end

local function setBtn(b, on)
    b.Text = on and "ON" or "OFF"
    b.TextColor3 = on and Color3.fromRGB(100, 255, 120) or Color3.fromRGB(255, 100, 100)
end

-- Sections
local S1 = section(48, 72, "Velocidade")
local SpeedBtn = toggle(S1, 5)
local SpeedBox = box(S1, Config.SpeedVal, "Ex: 45", 36)

local S2 = section(128, 72, "Fly (teleporte suave)")
local FlyBtn = toggle(S2, 5)
local FlyBox = box(S2, Config.FlySpeed, "Velocidade fly (1 a 5)", 36)

local S3 = section(208, 48, "ESP Visual")
local ESPBtn = toggle(S3, 13)

local S4 = section(264, 48, "Anti-Taco + Hitbox menor")
local AntiBtn = toggle(S4, 13)

local S5 = section(320, 48, "Fling")
local FlingBtn = toggle(S5, 13)

local Tip = Instance.new("TextLabel", Main)
Tip.Size = UDim2.new(1, -20, 0, 50)
Tip.Position = UDim2.new(0, 10, 0, 380)
Tip.BackgroundTransparency = 1
Tip.Text = "Fly = WASD + Space/Shift\nAnti-Taco = intangivel + hitbox pequena\nRightControl = abrir/fechar"
Tip.Font = Enum.Font.Gotham
Tip.TextSize = 11
Tip.TextColor3 = Color3.fromRGB(160, 160, 160)
Tip.TextWrapped = true

local Foot = Instance.new("TextLabel", Main)
Foot.Size = UDim2.new(1, 0, 0, 24)
Foot.Position = UDim2.new(0, 0, 1, -28)
Foot.BackgroundTransparency = 1
Foot.Text = "v3 • RightControl"
Foot.Font = Enum.Font.Gotham
Foot.TextSize = 11
Foot.TextColor3 = Color3.fromRGB(120, 120, 120)

RunService.RenderStepped:Connect(function()
    local c = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    Stroke.Color = c
    Title.TextColor3 = c
end)

-- ==================== HELPERS ====================
local function getChar()
    return LP.Character
end

local function getHum(char)
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function getRoot(char)
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- ==================== SPEED (loop constante) ====================
-- Muitos jogos resetam WalkSpeed todo frame. Por isso o loop.

RunService.Heartbeat:Connect(function()
    if not Config.Speed then return end
    local char = getChar()
    local hum = getHum(char)
    if hum and hum.WalkSpeed ~= Config.SpeedVal then
        hum.WalkSpeed = Config.SpeedVal
    end
end)

SpeedBtn.MouseButton1Click:Connect(function()
    Config.Speed = not Config.Speed
    setBtn(SpeedBtn, Config.Speed)
    local hum = getHum(getChar())
    if hum then
        hum.WalkSpeed = Config.Speed and Config.SpeedVal or 16
    end
end)

SpeedBox.FocusLost:Connect(function()
    local v = tonumber(SpeedBox.Text)
    if v and v > 0 then
        Config.SpeedVal = math.clamp(v, 1, 200)
        SpeedBox.Text = tostring(Config.SpeedVal)
    else
        SpeedBox.Text = tostring(Config.SpeedVal)
    end
end)

-- ==================== FLY (CFrame teleport suave) ====================
-- SEM BodyVelocity / BodyGyro / PlatformStand
-- Só move o HumanoidRootPart com CFrame (bem menos chance de kill)

FlyBtn.MouseButton1Click:Connect(function()
    Config.Fly = not Config.Fly
    setBtn(FlyBtn, Config.Fly)
end)

FlyBox.FocusLost:Connect(function()
    local v = tonumber(FlyBox.Text)
    if v and v > 0 then
        Config.FlySpeed = math.clamp(v, 0.5, 8)
        FlyBox.Text = tostring(Config.FlySpeed)
    else
        FlyBox.Text = tostring(Config.FlySpeed)
    end
end)

RunService.RenderStepped:Connect(function()
    if not Config.Fly then return end
    local char = getChar()
    local root = getRoot(char)
    local hum = getHum(char)
    if not root or not hum then return end

    -- Cancela ragdoll sem travar velocidade
    if hum:GetState() == Enum.HumanoidStateType.Ragdoll
        or hum:GetState() == Enum.HumanoidStateType.FallingDown then
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end

    local cam = workspace.CurrentCamera
    local dir = Vector3.zero

    if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
    if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.yAxis end

    if dir.Magnitude > 0 then
        dir = dir.Unit * Config.FlySpeed
        -- Teleporte suave (CFrame) — não usa velocidade física
        root.CFrame = root.CFrame + dir
        -- Zera velocity pra não acumular e o jogo matar
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
end)

-- ==================== ANTI-TACO + HITBOX MENOR ====================
-- Não usa loop pesado de velocity clamp (isso deixava lento)
-- Só: CanCollide off + estados de ragdoll desligados + hitbox pequena

local originalSizes = {}
local antiConn

local function applyHitbox(char, small)
    local root = getRoot(char)
    if not root then return end

    if small then
        if not originalSizes[root] then
            originalSizes[root] = root.Size
        end
        -- Hitbox bem menor (bicho/NPC erra mais)
        root.Size = Vector3.new(0.5, 0.5, 0.5)
        root.Transparency = 1
        root.CanCollide = false
    else
        if originalSizes[root] then
            root.Size = originalSizes[root]
            originalSizes[root] = nil
        end
        root.CanCollide = true
    end

    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p ~= root then
            p.CanCollide = not small
        end
    end
end

local function enableAnti()
    local char = getChar()
    if not char then return end
    local hum = getHum(char)
    if not hum then return end

    pcall(function()
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    end)

    applyHitbox(char, true)

    if antiConn then antiConn:Disconnect() end
    antiConn = RunService.Heartbeat:Connect(function()
        if not Config.AntiTaco then return end
        local c = getChar()
        local h = getHum(c)
        local r = getRoot(c)
        if not c or not h or not r then return end

        local st = h:GetState()
        if st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown
            or st == Enum.HumanoidStateType.Physics then
            h:ChangeState(Enum.HumanoidStateType.Running)
            h.PlatformStand = false
            h.Sit = false
        end

        -- Só corta velocity absurda (taco forte), sem deixar lento
        local vel = r.AssemblyLinearVelocity
        if vel.Magnitude > 120 then
            r.AssemblyLinearVelocity = vel.Unit * 40
        end

        -- Reaplica intangibilidade (alguns jogos religam CanCollide)
        if r.CanCollide then
            applyHitbox(c, true)
        end
    end)
end

local function disableAnti()
    if antiConn then
        antiConn:Disconnect()
        antiConn = nil
    end
    local char = getChar()
    if not char then return end
    local hum = getHum(char)
    if hum then
        pcall(function()
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
        end)
    end
    applyHitbox(char, false)
end

AntiBtn.MouseButton1Click:Connect(function()
    Config.AntiTaco = not Config.AntiTaco
    setBtn(AntiBtn, Config.AntiTaco)
    if Config.AntiTaco then
        enableAnti()
    else
        disableAnti()
    end
end)

-- Reaplica no respawn
LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if Config.Speed then
        local hum = getHum(getChar())
        if hum then hum.WalkSpeed = Config.SpeedVal end
    end
    if Config.AntiTaco then
        enableAnti()
    end
end)

-- ==================== FLING ====================
local flingConn

local function enableFling()
    if flingConn then flingConn:Disconnect() end
    flingConn = RunService.Heartbeat:Connect(function()
        if not Config.Fling then return end
        local char = getChar()
        local root = getRoot(char)
        if not root then return end

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local oRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                if oRoot and (root.Position - oRoot.Position).Magnitude < 7 then
                    local dir = (oRoot.Position - root.Position)
                    if dir.Magnitude < 0.1 then dir = Vector3.new(0, 1, 0) end
                    dir = dir.Unit

                    -- Método 1: velocity direta
                    pcall(function()
                        oRoot.AssemblyLinearVelocity = (dir + Vector3.new(0, 1.2, 0)).Unit * 180
                    end)

                    -- Método 2: BodyVelocity temporário
                    local bv = Instance.new("BodyVelocity")
                    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                    bv.Velocity = (dir + Vector3.new(0, 1, 0)).Unit * 160
                    bv.Parent = oRoot
                    Debris:AddItem(bv, 0.2)

                    -- Método 3: Angular (gira + joga)
                    pcall(function()
                        oRoot.AssemblyAngularVelocity = Vector3.new(40, 40, 40)
                    end)
                end
            end
        end
    end)
end

FlingBtn.MouseButton1Click:Connect(function()
    Config.Fling = not Config.Fling
    setBtn(FlingBtn, Config.Fling)
    if Config.Fling then
        enableFling()
    else
        if flingConn then flingConn:Disconnect() flingConn = nil end
    end
end)

-- ==================== ESP ====================
local ESPFolder = Instance.new("Folder", SG)
ESPFolder.Name = "ESP"

local function clearESP()
    ESPFolder:ClearAllChildren()
end

local function makeESP(plr)
    if plr == LP or not plr.Character then return end
    local char = plr.Character
    local head = char:FindFirstChild("Head")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not head or not root then return end

    local hl = Instance.new("Highlight")
    hl.Name = plr.Name
    hl.Adornee = char
    hl.FillColor = Color3.fromRGB(255, 60, 60)
    hl.OutlineColor = Color3.new(1, 1, 1)
    hl.FillTransparency = 0.55
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = ESPFolder

    local bb = Instance.new("BillboardGui")
    bb.Name = plr.Name .. "_bb"
    bb.Adornee = head
    bb.Size = UDim2.new(0, 180, 0, 40)
    bb.StudsOffset = Vector3.new(0, 2.4, 0)
    bb.AlwaysOnTop = true
    bb.Parent = ESPFolder

    local name = Instance.new("TextLabel", bb)
    name.Size = UDim2.new(1, 0, 0.55, 0)
    name.BackgroundTransparency = 1
    name.Text = plr.DisplayName
    name.Font = Enum.Font.GothamBold
    name.TextSize = 12
    name.TextColor3 = Color3.new(1, 1, 1)
    name.TextStrokeTransparency = 0.4

    local dist = Instance.new("TextLabel", bb)
    dist.Size = UDim2.new(1, 0, 0.45, 0)
    dist.Position = UDim2.new(0, 0, 0.55, 0)
    dist.BackgroundTransparency = 1
    dist.Text = "0m"
    dist.Font = Enum.Font.Gotham
    dist.TextSize = 11
    dist.TextColor3 = Color3.fromRGB(200, 200, 200)
    dist.TextStrokeTransparency = 0.4

    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not Config.ESP or not char.Parent or not root.Parent then
            if conn then conn:Disconnect() end
            return
        end
        local my = getRoot(getChar())
        if my then
            dist.Text = math.floor((my.Position - root.Position).Magnitude) .. "m"
        end
    end)
end

local function refreshESP()
    clearESP()
    if not Config.ESP then return end
    for _, p in pairs(Players:GetPlayers()) do
        makeESP(p)
    end
end

ESPBtn.MouseButton1Click:Connect(function()
    Config.ESP = not Config.ESP
    setBtn(ESPBtn, Config.ESP)
    if Config.ESP then refreshESP() else clearESP() end
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.4)
        if Config.ESP then makeESP(p) end
    end)
end)

Players.PlayerRemoving:Connect(function(p)
    for _, o in pairs(ESPFolder:GetChildren()) do
        if o.Name == p.Name or o.Name == p.Name .. "_bb" then
            o:Destroy()
        end
    end
end)

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LP then
        p.CharacterAdded:Connect(function()
            task.wait(0.4)
            if Config.ESP then makeESP(p) end
        end)
    end
end

-- UI toggle
UIS.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
    end
end)

print("[StealEggHub v3] carregado")
print("Speed loop | Fly CFrame | Anti-Taco + hitbox | Fling | ESP")
