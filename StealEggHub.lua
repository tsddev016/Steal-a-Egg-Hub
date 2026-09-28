-- [[ STEAL A EGG HUB v5 ]] --
-- Sem fly vertical (jogo mata). Speed + Noclip + Super Jump

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local LP = Players.LocalPlayer

local Config = {
    Speed = false,
    SpeedVal = 50,
    Noclip = false,
    SuperJump = false,
    JumpPower = 80,
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
Main.Size = UDim2.new(0, 280, 0, 530)
Main.Position = UDim2.new(0.5, -140, 0.5, -265)
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
Title.Text = "♡ STEAL A EGG HUB v5 ♡"
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

local S1 = section(48, 72, "Velocidade")
local SpeedBtn = toggle(S1, 5)
local SpeedBox = box(S1, Config.SpeedVal, "Ex: 50", 36)

local S2 = section(128, 48, "Noclip (atravessa parede)")
local NoclipBtn = toggle(S2, 13)

local S3 = section(184, 72, "Super Jump (pula alto)")
local JumpBtn = toggle(S3, 5)
local JumpBox = box(S3, Config.JumpPower, "Poder do pulo (ex: 80)", 36)

local S4 = section(264, 48, "ESP Visual")
local ESPBtn = toggle(S4, 13)

local S5 = section(320, 48, "Anti-Taco + Hitbox menor")
local AntiBtn = toggle(S5, 13)

local S6 = section(376, 48, "Fling")
local FlingBtn = toggle(S6, 13)

local Tip = Instance.new("TextLabel", Main)
Tip.Size = UDim2.new(1, -20, 0, 40)
Tip.Position = UDim2.new(0, 10, 0, 435)
Tip.BackgroundTransparency = 1
Tip.Text = "Sem fly: o jogo mata se subir no ar.\nUse Speed + Noclip + Super Jump."
Tip.Font = Enum.Font.Gotham
Tip.TextSize = 11
Tip.TextColor3 = Color3.fromRGB(160, 160, 160)
Tip.TextWrapped = true

local Foot = Instance.new("TextLabel", Main)
Foot.Size = UDim2.new(1, 0, 0, 22)
Foot.Position = UDim2.new(0, 0, 1, -26)
Foot.BackgroundTransparency = 1
Foot.Text = "v5 • RightControl = abrir/fechar"
Foot.Font = Enum.Font.Gotham
Foot.TextSize = 11
Foot.TextColor3 = Color3.fromRGB(120, 120, 120)

RunService.RenderStepped:Connect(function()
    local c = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    Stroke.Color = c
    Title.TextColor3 = c
end)

local function getChar() return LP.Character end
local function getHum(c) return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot(c) return c and c:FindFirstChild("HumanoidRootPart") end

-- ==================== SPEED ====================
RunService.Heartbeat:Connect(function()
    if not Config.Speed then return end
    local hum = getHum(getChar())
    if hum and hum.WalkSpeed ~= Config.SpeedVal then
        hum.WalkSpeed = Config.SpeedVal
    end
end)

SpeedBtn.MouseButton1Click:Connect(function()
    Config.Speed = not Config.Speed
    setBtn(SpeedBtn, Config.Speed)
    local hum = getHum(getChar())
    if hum then hum.WalkSpeed = Config.Speed and Config.SpeedVal or 16 end
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

-- ==================== NOCLIP ====================
-- Só desliga CanCollide. Não mexe em Y / não voa.

local noclipConn

local function setNoclip(char, on)
    if not char then return end
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            p.CanCollide = not on
        end
    end
end

NoclipBtn.MouseButton1Click:Connect(function()
    Config.Noclip = not Config.Noclip
    setBtn(NoclipBtn, Config.Noclip)

    if Config.Noclip then
        setNoclip(getChar(), true)
        if noclipConn then noclipConn:Disconnect() end
        noclipConn = RunService.Stepped:Connect(function()
            if not Config.Noclip then return end
            setNoclip(getChar(), true)
        end)
    else
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
        setNoclip(getChar(), false)
    end
end)

-- ==================== SUPER JUMP ====================
-- Só aumenta JumpPower / JumpHeight. Não flutua.

local function applyJump()
    local hum = getHum(getChar())
    if not hum then return end
    if Config.SuperJump then
        pcall(function()
            hum.UseJumpPower = true
            hum.JumpPower = Config.JumpPower
        end)
        pcall(function()
            hum.JumpHeight = Config.JumpPower / 5
        end)
    else
        pcall(function()
            hum.JumpPower = 50
            hum.JumpHeight = 7.2
        end)
    end
end

RunService.Heartbeat:Connect(function()
    if not Config.SuperJump then return end
    applyJump()
end)

JumpBtn.MouseButton1Click:Connect(function()
    Config.SuperJump = not Config.SuperJump
    setBtn(JumpBtn, Config.SuperJump)
    applyJump()
end)

JumpBox.FocusLost:Connect(function()
    local v = tonumber(JumpBox.Text)
    if v and v > 0 then
        Config.JumpPower = math.clamp(v, 10, 200)
        JumpBox.Text = tostring(Config.JumpPower)
        if Config.SuperJump then applyJump() end
    else
        JumpBox.Text = tostring(Config.JumpPower)
    end
end)

-- ==================== ANTI-TACO + HITBOX ====================
local originalSizes = {}
local antiConn

local function applyHitbox(char, small)
    local root = getRoot(char)
    if not root then return end

    if small then
        if not originalSizes[root] then
            originalSizes[root] = root.Size
        end
        root.Size = Vector3.new(0.4, 0.4, 0.4)
        root.Transparency = 1
        root.CanCollide = false
    else
        if originalSizes[root] then
            root.Size = originalSizes[root]
            originalSizes[root] = nil
        end
        if not Config.Noclip then
            root.CanCollide = true
        end
    end

    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p ~= root then
            if small or Config.Noclip then
                p.CanCollide = false
            else
                p.CanCollide = true
            end
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

        -- Só corta knockback absurdo (taco), sem deixar lento
        local vel = r.AssemblyLinearVelocity
        if vel.Magnitude > 140 then
            r.AssemblyLinearVelocity = vel.Unit * 50
        end

        if r.CanCollide and not Config.Noclip then
            applyHitbox(c, true)
        end
    end)
end

local function disableAnti()
    if antiConn then antiConn:Disconnect() antiConn = nil end
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
    if Config.AntiTaco then enableAnti() else disableAnti() end
end)

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if Config.Speed then
        local hum = getHum(getChar())
        if hum then hum.WalkSpeed = Config.SpeedVal end
    end
    if Config.Noclip then setNoclip(getChar(), true) end
    if Config.SuperJump then applyJump() end
    if Config.AntiTaco then enableAnti() end
end)

-- ==================== FLING ====================
local flingConn

local function enableFling()
    if flingConn then flingConn:Disconnect() end
    flingConn = RunService.Heartbeat:Connect(function()
        if not Config.Fling then return end
        local root = getRoot(getChar())
        if not root then return end

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local oRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                if oRoot and (root.Position - oRoot.Position).Magnitude < 7 then
                    local dir = (oRoot.Position - root.Position)
                    if dir.Magnitude < 0.1 then dir = Vector3.new(0, 1, 0) end
                    dir = dir.Unit

                    pcall(function()
                        oRoot.AssemblyLinearVelocity = (dir + Vector3.new(0, 1.1, 0)).Unit * 180
                    end)

                    local bv = Instance.new("BodyVelocity")
                    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                    bv.Velocity = (dir + Vector3.new(0, 1, 0)).Unit * 160
                    bv.Parent = oRoot
                    Debris:AddItem(bv, 0.2)

                    pcall(function()
                        oRoot.AssemblyAngularVelocity = Vector3.new(35, 35, 35)
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
    for _, p in pairs(Players:GetPlayers()) do makeESP(p) end
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
        if o.Name == p.Name or o.Name == p.Name .. "_bb" then o:Destroy() end
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

UIS.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
    end
end)

print("[StealEggHub v5] sem fly vertical")
print("Speed | Noclip | SuperJump | ESP | AntiTaco | Fling")
