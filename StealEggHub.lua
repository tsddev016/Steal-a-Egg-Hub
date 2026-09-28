-- [[ STEAL A EGG HUB v6 ]] --
-- Speed sem limite | Area select | TP ovo/base | Aimlock | Bat Aura

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    Speed = false,
    SpeedVal = 100,
    Noclip = false,
    SuperJump = false,
    JumpPower = 80,
    ESP = false,
    AntiTaco = false,
    Fling = false,
    Aimlock = false,
    AimRange = 80,
    BatAura = false,
    BatRange = 18,
    SelectedArea = "Forest",
    AutoSteal = false,
    StealDelay = 1.2,
}

local Areas = {
    "Forest", "Lake", "Desert", "Jungle", "Snow",
    "Volcano", "Abyss", "Ocean", "Prehistoric", "Cosmic",
    "Cherry", "Titan", "Temple", "Angels", "Demons"
}

-- ==================== GUI ====================
local SG = Instance.new("ScreenGui")
SG.Name = "StealEggHub"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 300, 0, 620)
Main.Position = UDim2.new(0.5, -150, 0.5, -310)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = SG
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 36)
Title.BackgroundTransparency = 1
Title.Text = "♡ STEAL A EGG HUB v6 ♡"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextColor3 = Color3.new(1, 1, 1)

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 26, 0, 26)
Close.Position = UDim2.new(1, -32, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 12
Close.TextColor3 = Color3.fromRGB(255, 90, 90)
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)
Close.MouseButton1Click:Connect(function() SG:Destroy() end)

local function section(y, h, txt)
    local f = Instance.new("Frame", Main)
    f.Size = UDim2.new(1, -20, 0, h)
    f.Position = UDim2.new(0, 10, 0, y)
    f.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, -12, 0, 18)
    t.Position = UDim2.new(0, 6, 0, 4)
    t.BackgroundTransparency = 1
    t.Text = txt
    t.Font = Enum.Font.GothamBold
    t.TextSize = 11
    t.TextColor3 = Color3.new(1, 1, 1)
    t.TextXAlignment = Enum.TextXAlignment.Left
    return f
end

local function toggle(parent, y)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0, 58, 0, 20)
    b.Position = UDim2.new(1, -66, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.Text = "OFF"
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    b.TextColor3 = Color3.fromRGB(255, 100, 100)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    return b
end

local function box(parent, val, ph, y)
    local t = Instance.new("TextBox", parent)
    t.Size = UDim2.new(1, -12, 0, 24)
    t.Position = UDim2.new(0, 6, 0, y)
    t.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    t.Text = tostring(val)
    t.PlaceholderText = ph
    t.Font = Enum.Font.Gotham
    t.TextSize = 11
    t.TextColor3 = Color3.new(1, 1, 1)
    t.ClearTextOnFocus = false
    Instance.new("UICorner", t).CornerRadius = UDim.new(0, 5)
    return t
end

local function btn(parent, text, y, h)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -12, 0, h or 26)
    b.Position = UDim2.new(0, 6, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    return b
end

local function setBtn(b, on)
    b.Text = on and "ON" or "OFF"
    b.TextColor3 = on and Color3.fromRGB(100, 255, 120) or Color3.fromRGB(255, 100, 100)
end

-- SPEED
local S1 = section(40, 64, "Velocidade (sem limite)")
local SpeedBtn = toggle(S1, 4)
local SpeedBox = box(S1, Config.SpeedVal, "Qualquer valor", 32)

-- NOCLIP + JUMP
local S2 = section(110, 48, "Noclip")
local NoclipBtn = toggle(S2, 14)

local S3 = section(164, 64, "Super Jump")
local JumpBtn = toggle(S3, 4)
local JumpBox = box(S3, Config.JumpPower, "Pulo", 32)

-- AREA + TP
local S4 = section(234, 150, "Area + TP Steal")
local AreaBox = box(S4, Config.SelectedArea, "Area: Forest, Lake, Volcano...", 26)
local TPEggBtn = btn(S4, "TP Ovo da Area", 54, 24)
local TPBaseBtn = btn(S4, "TP Base", 82, 24)
local AutoStealBtn = toggle(S4, 112)
local AutoLabel = Instance.new("TextLabel", S4)
AutoLabel.Size = UDim2.new(0.55, 0, 0, 18)
AutoLabel.Position = UDim2.new(0, 6, 0, 112)
AutoLabel.BackgroundTransparency = 1
AutoLabel.Text = "Auto Steal"
AutoLabel.Font = Enum.Font.Gotham
AutoLabel.TextSize = 11
AutoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
AutoLabel.TextXAlignment = Enum.TextXAlignment.Left

-- COMBAT
local S5 = section(390, 64, "Aimlock (player perto)")
local AimBtn = toggle(S5, 4)
local AimBox = box(S5, Config.AimRange, "Range aimlock", 32)

local S6 = section(460, 64, "Bat Aura / Hitbox taco")
local BatBtn = toggle(S6, 4)
local BatBox = box(S6, Config.BatRange, "Range do taco", 32)

-- EXTRA
local S7 = section(530, 40, "ESP | Anti-Taco | Fling")
local ESPBtn = toggle(S7, 10)
ESPBtn.Position = UDim2.new(0, 8, 0, 10)
ESPBtn.Size = UDim2.new(0, 70, 0, 20)
ESPBtn.Text = "ESP"
local AntiBtn = toggle(S7, 10)
AntiBtn.Position = UDim2.new(0, 86, 0, 10)
AntiBtn.Size = UDim2.new(0, 90, 0, 20)
AntiBtn.Text = "AntiTaco"
local FlingBtn = toggle(S7, 10)
FlingBtn.Position = UDim2.new(0, 184, 0, 10)
FlingBtn.Size = UDim2.new(0, 70, 0, 20)
FlingBtn.Text = "Fling"

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, -16, 0, 18)
Status.Position = UDim2.new(0, 8, 1, -22)
Status.BackgroundTransparency = 1
Status.Text = "RightControl = GUI | Area = digite o bioma"
Status.Font = Enum.Font.Gotham
Status.TextSize = 10
Status.TextColor3 = Color3.fromRGB(140, 140, 140)

RunService.RenderStepped:Connect(function()
    local c = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    Stroke.Color = c
    Title.TextColor3 = c
end)

local function getChar() return LP.Character end
local function getHum(c) return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot(c) return c and c:FindFirstChild("HumanoidRootPart") end

local function notify(msg)
    Status.Text = msg
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Steal Egg Hub",
            Text = msg,
            Duration = 3
        })
    end)
end

-- ==================== SPEED SEM LIMITE ====================
RunService.Heartbeat:Connect(function()
    if not Config.Speed then return end
    local hum = getHum(getChar())
    if hum then
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
        Config.SpeedVal = v -- sem clamp / sem limite
        SpeedBox.Text = tostring(Config.SpeedVal)
    else
        SpeedBox.Text = tostring(Config.SpeedVal)
    end
end)

-- ==================== NOCLIP ====================
local noclipConn
local function setNoclip(char, on)
    if not char then return end
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = not on end
    end
end

NoclipBtn.MouseButton1Click:Connect(function()
    Config.Noclip = not Config.Noclip
    setBtn(NoclipBtn, Config.Noclip)
    if Config.Noclip then
        if noclipConn then noclipConn:Disconnect() end
        noclipConn = RunService.Stepped:Connect(function()
            if Config.Noclip then setNoclip(getChar(), true) end
        end)
    else
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
        setNoclip(getChar(), false)
    end
end)

-- ==================== SUPER JUMP ====================
local function applyJump()
    local hum = getHum(getChar())
    if not hum then return end
    if Config.SuperJump then
        pcall(function() hum.UseJumpPower = true hum.JumpPower = Config.JumpPower end)
        pcall(function() hum.JumpHeight = Config.JumpPower / 5 end)
    else
        pcall(function() hum.JumpPower = 50 hum.JumpHeight = 7.2 end)
    end
end

RunService.Heartbeat:Connect(function()
    if Config.SuperJump then applyJump() end
end)

JumpBtn.MouseButton1Click:Connect(function()
    Config.SuperJump = not Config.SuperJump
    setBtn(JumpBtn, Config.SuperJump)
    applyJump()
end)

JumpBox.FocusLost:Connect(function()
    local v = tonumber(JumpBox.Text)
    if v and v > 0 then
        Config.JumpPower = v
        JumpBox.Text = tostring(v)
        if Config.SuperJump then applyJump() end
    else
        JumpBox.Text = tostring(Config.JumpPower)
    end
end)

-- ==================== BASE POSITION ====================
local savedBase = nil

local function captureBase()
    local root = getRoot(getChar())
    if root then
        savedBase = root.CFrame
    end
end

-- tenta pegar base pelo spawn / plot
local function findBaseCFrame()
    if savedBase then return savedBase end

    -- SpawnLocation do time / padrao
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("SpawnLocation") then
            return obj.CFrame + Vector3.new(0, 4, 0)
        end
    end

    -- fallback: posicao atual como base
    local root = getRoot(getChar())
    if root then
        savedBase = root.CFrame
        return savedBase
    end
    return nil
end

-- salva base quando o script carrega (voce deve estar na base)
task.defer(function()
    task.wait(1)
    captureBase()
    if savedBase then
        notify("Base salva! (posicao atual)")
    end
end)

local function tpTo(cf)
    local root = getRoot(getChar())
    if not root or not cf then return false end
    root.CFrame = cf
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    return true
end

-- ==================== FIND EGGS BY AREA ====================
local function nameHas(str, needle)
    return string.find(string.lower(str or ""), string.lower(needle or ""), 1, true) ~= nil
end

local function isEggLike(obj)
    local n = obj.Name
    if nameHas(n, "egg") then return true end
    if obj:GetAttribute("Egg") or obj:GetAttribute("IsEgg") then return true end
    -- prompt de coletar
    if obj:IsA("Model") or obj:IsA("BasePart") then
        for _, d in pairs(obj:GetDescendants()) do
            if d:IsA("ProximityPrompt") then
                local t = (d.ActionText or "") .. (d.ObjectText or "")
                if nameHas(t, "egg") or nameHas(t, "steal") or nameHas(t, "grab") or nameHas(t, "pick") then
                    return true
                end
            end
        end
    end
    return false
end

local function getPart(obj)
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") then
        return obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
    end
    return nil
end

local function eggInArea(obj, area)
    -- checa nome do objeto e dos parents
    local cur = obj
    for _ = 1, 8 do
        if not cur then break end
        if nameHas(cur.Name, area) then return true end
        cur = cur.Parent
    end
    -- checa path
    local ok, path = pcall(function() return obj:GetFullName() end)
    if ok and nameHas(path, area) then return true end
    return false
end

local function findEggsInArea(area)
    local list = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if isEggLike(obj) and eggInArea(obj, area) then
            local part = getPart(obj)
            if part then
                table.insert(list, {obj = obj, part = part})
            end
        end
    end
    return list
end

local function findAnyEggs()
    local list = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if isEggLike(obj) then
            local part = getPart(obj)
            if part then table.insert(list, {obj = obj, part = part}) end
        end
    end
    return list
end

local function pickEggForArea(area)
    local eggs = findEggsInArea(area)
    if #eggs == 0 then
        -- fallback: qualquer ovo (avisar)
        eggs = findAnyEggs()
        if #eggs == 0 then return nil, "Nenhum ovo encontrado" end
        notify("Area sem ovo detectado, usando ovo generico")
    end

    local root = getRoot(getChar())
    local best, bestDist = nil, math.huge
    for _, e in pairs(eggs) do
        local d = root and (root.Position - e.part.Position).Magnitude or 0
        if d < bestDist then
            bestDist = d
            best = e
        end
    end
    return best, nil
end

AreaBox.FocusLost:Connect(function()
    local t = AreaBox.Text
    if t and #t > 0 then
        Config.SelectedArea = t
        notify("Area: " .. t)
    else
        AreaBox.Text = Config.SelectedArea
    end
end)

TPEggBtn.MouseButton1Click:Connect(function()
    local egg, err = pickEggForArea(Config.SelectedArea)
    if not egg then
        notify(err or "Ovo nao encontrado")
        return
    end
    local cf = egg.part.CFrame + Vector3.new(0, 3, 0)
    if tpTo(cf) then
        notify("TP ovo: " .. Config.SelectedArea .. " (" .. egg.obj.Name .. ")")
    end
end)

TPBaseBtn.MouseButton1Click:Connect(function()
    -- atualiza base se quiser: segura Alt? por enquanto usa saved/spawn
    local cf = findBaseCFrame()
    if cf and tpTo(cf) then
        notify("TP Base")
    else
        notify("Base nao encontrada - fique na base e reconecte o script")
    end
end)

-- botao escondido: clicar 2x em TP Base com shift salva base atual
TPBaseBtn.MouseButton1Click:Connect(function()
    if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
        captureBase()
        notify("Base sobrescrita (posicao atual)")
    end
end)

-- ==================== AUTO STEAL ====================
local autoThread = nil

local function autoStealLoop()
    while Config.AutoSteal do
        local egg = pickEggForArea(Config.SelectedArea)
        if egg then
            tpTo(egg.part.CFrame + Vector3.new(0, 3, 0))
            notify("Auto: no ovo " .. egg.obj.Name)
            task.wait(Config.StealDelay)
            -- tenta ativar prompt perto
            for _, d in pairs(egg.obj:GetDescendants()) do
                if d:IsA("ProximityPrompt") then
                    pcall(function() fireproximityprompt(d) end)
                end
            end
            task.wait(0.35)
            local base = findBaseCFrame()
            if base then
                tpTo(base)
                notify("Auto: voltou base")
            end
            task.wait(Config.StealDelay)
        else
            notify("Auto: nenhum ovo na area")
            task.wait(2)
        end
        task.wait(0.3)
    end
end

AutoStealBtn.MouseButton1Click:Connect(function()
    Config.AutoSteal = not Config.AutoSteal
    setBtn(AutoStealBtn, Config.AutoSteal)
    if Config.AutoSteal then
        notify("Auto Steal ON - Area: " .. Config.SelectedArea)
        task.spawn(autoStealLoop)
    else
        notify("Auto Steal OFF")
    end
end)

-- ==================== AIMLOCK ====================
local function getClosestPlayer(range)
    local root = getRoot(getChar())
    if not root then return nil end
    local closest, dist = nil, range
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local d = (root.Position - hrp.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = plr
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if not Config.Aimlock then return end
    local target = getClosestPlayer(Config.AimRange)
    if not target or not target.Character then return end
    local head = target.Character:FindFirstChild("Head")
    if not head then return end
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
end)

AimBtn.MouseButton1Click:Connect(function()
    Config.Aimlock = not Config.Aimlock
    setBtn(AimBtn, Config.Aimlock)
end)

AimBox.FocusLost:Connect(function()
    local v = tonumber(AimBox.Text)
    if v and v > 0 then
        Config.AimRange = v
        AimBox.Text = tostring(v)
    else
        AimBox.Text = tostring(Config.AimRange)
    end
end)

-- ==================== BAT AURA / HITBOX ====================
local originalHandles = {}

local function enlargeBat(tool, on)
    if not tool then return end
    local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
    if not handle then return end
    if on then
        if not originalHandles[handle] then
            originalHandles[handle] = handle.Size
        end
        -- hitbox bem maior
        handle.Size = Vector3.new(
            math.max(originalHandles[handle].X, Config.BatRange / 2),
            math.max(originalHandles[handle].Y, 2),
            math.max(originalHandles[handle].Z, Config.BatRange / 2)
        )
        handle.Transparency = 0.7
        handle.Massless = true
    else
        if originalHandles[handle] then
            handle.Size = originalHandles[handle]
            handle.Transparency = 0
            originalHandles[handle] = nil
        end
    end
end

local function getBat()
    local char = getChar()
    if not char then return nil end
    for _, t in pairs(char:GetChildren()) do
        if t:IsA("Tool") then
            local n = string.lower(t.Name)
            if n:find("bat") or n:find("taco") or n:find("club") or n:find("hammer") or n:find("weapon") then
                return t
            end
            return t -- qualquer tool equipada
        end
    end
    return nil
end

RunService.Heartbeat:Connect(function()
    if not Config.BatAura then return end
    local bat = getBat()
    if bat then
        enlargeBat(bat, true)
        -- tenta "ativar" tool nos players no range
        local root = getRoot(getChar())
        if not root then return end
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp and (root.Position - hrp.Position).Magnitude <= Config.BatRange then
                    pcall(function()
                        bat:Activate()
                    end)
                end
            end
        end
    end
end)

BatBtn.MouseButton1Click:Connect(function()
    Config.BatAura = not Config.BatAura
    setBtn(BatBtn, Config.BatAura)
    if not Config.BatAura then
        local bat = getBat()
        if bat then enlargeBat(bat, false) end
    end
end)

BatBox.FocusLost:Connect(function()
    local v = tonumber(BatBox.Text)
    if v and v > 0 then
        Config.BatRange = v
        BatBox.Text = tostring(v)
    else
        BatBox.Text = tostring(Config.BatRange)
    end
end)

-- ==================== ANTI TACO ====================
local originalSizes = {}
local antiConn

local function applyHitbox(char, small)
    local root = getRoot(char)
    if not root then return end
    if small then
        if not originalSizes[root] then originalSizes[root] = root.Size end
        root.Size = Vector3.new(0.4, 0.4, 0.4)
        root.Transparency = 1
        root.CanCollide = false
    else
        if originalSizes[root] then
            root.Size = originalSizes[root]
            originalSizes[root] = nil
        end
        if not Config.Noclip then root.CanCollide = true end
    end
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p ~= root then
            p.CanCollide = not (small or Config.Noclip)
        end
    end
end

local function enableAnti()
    local char = getChar()
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
        local c, h, r = getChar(), getHum(getChar()), getRoot(getChar())
        if not h or not r then return end
        local st = h:GetState()
        if st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown or st == Enum.HumanoidStateType.Physics then
            h:ChangeState(Enum.HumanoidStateType.Running)
            h.PlatformStand = false
            h.Sit = false
        end
        if r.AssemblyLinearVelocity.Magnitude > 140 then
            r.AssemblyLinearVelocity = r.AssemblyLinearVelocity.Unit * 50
        end
        if r.CanCollide and not Config.Noclip then applyHitbox(c, true) end
    end)
end

local function disableAnti()
    if antiConn then antiConn:Disconnect() antiConn = nil end
    local char = getChar()
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

-- ESP / Anti / Fling buttons (multi)
local function styleToggle(b, on, label)
    b.Text = on and (label .. " ON") or label
    b.TextColor3 = on and Color3.fromRGB(100, 255, 120) or Color3.fromRGB(255, 100, 100)
end

ESPBtn.MouseButton1Click:Connect(function()
    Config.ESP = not Config.ESP
    styleToggle(ESPBtn, Config.ESP, "ESP")
end)

AntiBtn.MouseButton1Click:Connect(function()
    Config.AntiTaco = not Config.AntiTaco
    styleToggle(AntiBtn, Config.AntiTaco, "AntiTaco")
    if Config.AntiTaco then enableAnti() else disableAnti() end
end)

-- FLING
local flingConn
FlingBtn.MouseButton1Click:Connect(function()
    Config.Fling = not Config.Fling
    styleToggle(FlingBtn, Config.Fling, "Fling")
    if Config.Fling then
        if flingConn then flingConn:Disconnect() end
        flingConn = RunService.Heartbeat:Connect(function()
            if not Config.Fling then return end
            local root = getRoot(getChar())
            if not root then return end
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local o = plr.Character:FindFirstChild("HumanoidRootPart")
                    if o and (root.Position - o.Position).Magnitude < 7 then
                        local dir = (o.Position - root.Position)
                        if dir.Magnitude < 0.1 then dir = Vector3.yAxis end
                        dir = dir.Unit
                        pcall(function() o.AssemblyLinearVelocity = (dir + Vector3.new(0, 1.1, 0)).Unit * 180 end)
                        local bv = Instance.new("BodyVelocity")
                        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                        bv.Velocity = (dir + Vector3.new(0, 1, 0)).Unit * 160
                        bv.Parent = o
                        Debris:AddItem(bv, 0.2)
                    end
                end
            end
        end)
    else
        if flingConn then flingConn:Disconnect() flingConn = nil end
    end
end)

-- ==================== ESP ====================
local ESPFolder = Instance.new("Folder", SG)
ESPFolder.Name = "ESP"

local function clearESP() ESPFolder:ClearAllChildren() end

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
    bb.Size = UDim2.new(0, 160, 0, 36)
    bb.StudsOffset = Vector3.new(0, 2.3, 0)
    bb.AlwaysOnTop = true
    bb.Parent = ESPFolder

    local name = Instance.new("TextLabel", bb)
    name.Size = UDim2.new(1, 0, 0.55, 0)
    name.BackgroundTransparency = 1
    name.Text = plr.DisplayName
    name.Font = Enum.Font.GothamBold
    name.TextSize = 11
    name.TextColor3 = Color3.new(1, 1, 1)
    name.TextStrokeTransparency = 0.4

    local dist = Instance.new("TextLabel", bb)
    dist.Size = UDim2.new(1, 0, 0.45, 0)
    dist.Position = UDim2.new(0, 0, 0.55, 0)
    dist.BackgroundTransparency = 1
    dist.Text = "0m"
    dist.Font = Enum.Font.Gotham
    dist.TextSize = 10
    dist.TextColor3 = Color3.fromRGB(200, 200, 200)

    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not Config.ESP or not char.Parent or not root.Parent then
            if conn then conn:Disconnect() end
            return
        end
        local my = getRoot(getChar())
        if my then dist.Text = math.floor((my.Position - root.Position).Magnitude) .. "m" end
    end)
end

local function refreshESP()
    clearESP()
    if not Config.ESP then return end
    for _, p in pairs(Players:GetPlayers()) do makeESP(p) end
end

-- re-hook ESP button to also refresh
ESPBtn.MouseButton1Click:Connect(function()
    if Config.ESP then refreshESP() else clearESP() end
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.4)
        if Config.ESP then makeESP(p) end
    end)
end)

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LP then
        p.CharacterAdded:Connect(function()
            task.wait(0.4)
            if Config.ESP then makeESP(p) end
        end)
    end
end

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if Config.Speed then local h = getHum(getChar()) if h then h.WalkSpeed = Config.SpeedVal end end
    if Config.Noclip then setNoclip(getChar(), true) end
    if Config.SuperJump then applyJump() end
    if Config.AntiTaco then enableAnti() end
end)

UIS.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
    end
end)

print("[StealEggHub v6] carregado")
print("Area select + TP ovo/base | Speed | Aimlock | Bat Aura")
notify("Hub v6 pronto - salve a base ficando nela ao executar")
