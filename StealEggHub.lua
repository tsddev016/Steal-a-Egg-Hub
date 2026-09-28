-- [[ STEAL A EGG HUB v8 ]] --
-- TP seguro: saltos pelas areas ate a base (nao TP direto)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    Speed = false, SpeedVal = 100,
    Noclip = false,
    SuperJump = false, JumpPower = 80,
    ESP = false, AntiTaco = false, Fling = false,
    Aimlock = false, AimRange = 80,
    BatAura = false, BatRange = 18,
    SelectedArea = "Forest",
    AutoSteal = false,
    StealDelay = 1.0,
    HopDelay = 0.35, -- tempo entre cada salto de area
    UseSafeTP = true,
}

-- Ordem das areas: 1 = mais perto da base, ultimo = mais longe
-- Ajuste os nomes se no seu servidor forem diferentes
local AreaOrder = {
    "Forest",
    "Lake",
    "Desert",
    "Jungle",
    "Snow",
    "Volcano",
    "Abyss",
    "Ocean",
    "Prehistoric",
    "Cosmic",
    "Cherry",
    "Titan",
    "Temple",
    "Monkey",
    "Macaco",
    "Block",
    "Bloco",
    "Buzios",
    "Búzios",
    "Angels",
    "Angel",
    "Anjo",
    "Demons",
    "Demon",
}

-- ==================== GUI ====================
local SG = Instance.new("ScreenGui")
SG.Name = "StealEggHub"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = game:GetService("CoreGui")

local MIN_W, MIN_H = 260, 280
local MAX_W, MAX_H = 520, 720

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 330, 0, 440)
Main.Position = UDim2.new(0.5, -165, 0.5, -220)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BorderSizePixel = 0
Main.Active = true
Main.ClipsDescendants = true
Main.Parent = SG
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 2

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Header.BorderSizePixel = 0
Header.Active = true
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)
local HeaderFix = Instance.new("Frame", Header)
HeaderFix.Size = UDim2.new(1, 0, 0, 14)
HeaderFix.Position = UDim2.new(0, 0, 1, -14)
HeaderFix.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
HeaderFix.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "♡ STEAL A EGG HUB v8 ♡"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextXAlignment = Enum.TextXAlignment.Left

local Close = Instance.new("TextButton", Header)
Close.Size = UDim2.new(0, 28, 0, 28)
Close.Position = UDim2.new(1, -34, 0.5, -14)
Close.BackgroundColor3 = Color3.fromRGB(40, 30, 30)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 13
Close.TextColor3 = Color3.fromRGB(255, 90, 90)
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)
Close.MouseButton1Click:Connect(function() SG:Destroy() end)

do
    local dragging, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -12, 1, -70)
Scroll.Position = UDim2.new(0, 6, 0, 44)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 5
Scroll.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 120)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ScrollingDirection = Enum.ScrollingDirection.Y

local List = Instance.new("UIListLayout", Scroll)
List.SortOrder = Enum.SortOrder.LayoutOrder
List.Padding = UDim.new(0, 8)
local Pad = Instance.new("UIPadding", Scroll)
Pad.PaddingTop = UDim.new(0, 4)
Pad.PaddingBottom = UDim.new(0, 12)
Pad.PaddingLeft = UDim.new(0, 4)
Pad.PaddingRight = UDim.new(0, 8)

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, -40, 0, 20)
Status.Position = UDim2.new(0, 10, 1, -24)
Status.BackgroundTransparency = 1
Status.Text = "TP Base = saltos pelas areas (seguro)"
Status.Font = Enum.Font.Gotham
Status.TextSize = 10
Status.TextColor3 = Color3.fromRGB(140, 140, 140)
Status.TextXAlignment = Enum.TextXAlignment.Left

local Resize = Instance.new("TextButton", Main)
Resize.Size = UDim2.new(0, 22, 0, 22)
Resize.Position = UDim2.new(1, -22, 1, -22)
Resize.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Resize.Text = "⤡"
Resize.Font = Enum.Font.GothamBold
Resize.TextSize = 12
Resize.TextColor3 = Color3.fromRGB(180, 180, 180)
Resize.ZIndex = 5
Instance.new("UICorner", Resize).CornerRadius = UDim.new(0, 4)

do
    local resizing, startInput, startSize
    Resize.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            startInput = input.Position
            startSize = Main.AbsoluteSize
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then resizing = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - startInput
            Main.Size = UDim2.new(0, math.clamp(startSize.X + d.X, MIN_W, MAX_W), 0, math.clamp(startSize.Y + d.Y, MIN_H, MAX_H))
        end
    end)
end

local order = 0
local function nextOrder() order += 1 return order end

local function section(titleText, height)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, height)
    f.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    f.BorderSizePixel = 0
    f.LayoutOrder = nextOrder()
    f.Parent = Scroll
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, -12, 0, 18)
    t.Position = UDim2.new(0, 8, 0, 5)
    t.BackgroundTransparency = 1
    t.Text = titleText
    t.Font = Enum.Font.GothamBold
    t.TextSize = 12
    t.TextColor3 = Color3.new(1, 1, 1)
    t.TextXAlignment = Enum.TextXAlignment.Left
    return f
end

local function toggle(parent, y)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0, 60, 0, 22)
    b.Position = UDim2.new(1, -70, 0, y)
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

local function btn(parent, text, y)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -16, 0, 28)
    b.Position = UDim2.new(0, 8, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    return b
end

local function setBtn(b, on)
    b.Text = on and "ON" or "OFF"
    b.TextColor3 = on and Color3.fromRGB(100, 255, 120) or Color3.fromRGB(255, 100, 100)
end

local function styleChip(b, on, label)
    b.Text = on and (label .. " ON") or label
    b.TextColor3 = on and Color3.fromRGB(100, 255, 120) or Color3.fromRGB(255, 100, 100)
end

local S1 = section("Velocidade (sem limite)", 68)
local SpeedBtn = toggle(S1, 5)
local SpeedBox = box(S1, Config.SpeedVal, "Qualquer valor", 34)

local S2 = section("Noclip", 44)
local NoclipBtn = toggle(S2, 12)

local S3 = section("Super Jump", 68)
local JumpBtn = toggle(S3, 5)
local JumpBox = box(S3, Config.JumpPower, "Poder do pulo", 34)

local S4 = section("Area + TP Seguro", 200)
local AreaBox = box(S4, Config.SelectedArea, "Forest, Lake, Angels...", 28)
local TPEggBtn = btn(S4, "TP Ovo (com saltos)", 60)
local TPBaseBtn = btn(S4, "TP Base SEGURO (saltos)", 92)
local SaveBaseBtn = btn(S4, "Salvar Base Aqui", 124)
local AutoStealBtn = toggle(S4, 160)
local AutoLabel = Instance.new("TextLabel", S4)
AutoLabel.Size = UDim2.new(0.55, 0, 0, 20)
AutoLabel.Position = UDim2.new(0, 8, 0, 160)
AutoLabel.BackgroundTransparency = 1
AutoLabel.Text = "Auto Steal Seguro"
AutoLabel.Font = Enum.Font.Gotham
AutoLabel.TextSize = 12
AutoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
AutoLabel.TextXAlignment = Enum.TextXAlignment.Left

local S5 = section("Aimlock", 68)
local AimBtn = toggle(S5, 5)
local AimBox = box(S5, Config.AimRange, "Range", 34)

local S6 = section("Bat Aura / Hitbox", 68)
local BatBtn = toggle(S6, 5)
local BatBox = box(S6, Config.BatRange, "Range taco", 34)

local S7 = section("ESP | Anti-Taco | Fling", 48)
local ESPBtn = Instance.new("TextButton", S7)
ESPBtn.Size = UDim2.new(0, 78, 0, 24)
ESPBtn.Position = UDim2.new(0, 8, 0, 14)
ESPBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ESPBtn.Text = "ESP"
ESPBtn.Font = Enum.Font.GothamBold
ESPBtn.TextSize = 11
ESPBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0, 5)

local AntiBtn = Instance.new("TextButton", S7)
AntiBtn.Size = UDim2.new(0, 90, 0, 24)
AntiBtn.Position = UDim2.new(0, 94, 0, 14)
AntiBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AntiBtn.Text = "AntiTaco"
AntiBtn.Font = Enum.Font.GothamBold
AntiBtn.TextSize = 11
AntiBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
Instance.new("UICorner", AntiBtn).CornerRadius = UDim.new(0, 5)

local FlingBtn = Instance.new("TextButton", S7)
FlingBtn.Size = UDim2.new(0, 70, 0, 24)
FlingBtn.Position = UDim2.new(0, 192, 0, 14)
FlingBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FlingBtn.Text = "Fling"
FlingBtn.Font = Enum.Font.GothamBold
FlingBtn.TextSize = 11
FlingBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
Instance.new("UICorner", FlingBtn).CornerRadius = UDim.new(0, 5)

RunService.RenderStepped:Connect(function()
    local c = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    Stroke.Color = c
    Title.TextColor3 = c
end)

local function getChar() return LP.Character end
local function getHum(c) return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot(c) return c and c:FindFirstChild("HumanoidRootPart") end

local function notify(msg)
    Status.Text = tostring(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Steal Egg Hub", Text = msg, Duration = 3
        })
    end)
end

-- ==================== SPEED / NOCLIP / JUMP ====================
RunService.Heartbeat:Connect(function()
    if Config.Speed then
        local hum = getHum(getChar())
        if hum then hum.WalkSpeed = Config.SpeedVal end
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
    if v and v > 0 then Config.SpeedVal = v SpeedBox.Text = tostring(v)
    else SpeedBox.Text = tostring(Config.SpeedVal) end
end)

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
    if v and v > 0 then Config.JumpPower = v JumpBox.Text = tostring(v) if Config.SuperJump then applyJump() end
    else JumpBox.Text = tostring(Config.JumpPower) end
end)

-- ==================== WAYPOINTS / SAFE HOP TP ====================
local savedBase = nil
local areaWaypoints = {} -- [areaNameLower] = CFrame

local function nameHas(str, needle)
    return string.find(string.lower(str or ""), string.lower(needle or ""), 1, true) ~= nil
end

local function getPart(obj)
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") then return obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart") end
    return nil
end

local function captureBase()
    local root = getRoot(getChar())
    if root then savedBase = root.CFrame end
end

local function findBaseCFrame()
    if savedBase then return savedBase end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("SpawnLocation") then return obj.CFrame + Vector3.new(0, 4, 0) end
    end
    local root = getRoot(getChar())
    if root then savedBase = root.CFrame return savedBase end
    return nil
end

-- Descobre CFrame de cada area (pelo nome de pastas/partes no workspace)
local function refreshAreaWaypoints()
    areaWaypoints = {}
    for _, areaName in ipairs(AreaOrder) do
        local key = string.lower(areaName)
        if not areaWaypoints[key] then
            for _, obj in pairs(workspace:GetDescendants()) do
                if nameHas(obj.Name, areaName) then
                    local part = getPart(obj)
                    if part then
                        areaWaypoints[key] = part.CFrame + Vector3.new(0, 4, 0)
                        break
                    end
                end
            end
        end
    end
end

local function tpInstant(cf)
    local root = getRoot(getChar())
    if not root or not cf then return false end
    root.CFrame = cf
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    return true
end

-- Encontra qual indice de AreaOrder esta mais perto do player
local function getNearestAreaIndex()
    local root = getRoot(getChar())
    if not root then return 1 end
    refreshAreaWaypoints()

    local bestIdx, bestDist = 1, math.huge
    for i, areaName in ipairs(AreaOrder) do
        local wp = areaWaypoints[string.lower(areaName)]
        if wp then
            local d = (root.Position - wp.Position).Magnitude
            if d < bestDist then
                bestDist = d
                bestIdx = i
            end
        end
    end
    return bestIdx
end

local function getAreaIndexByName(name)
    local n = string.lower(name or "")
    for i, areaName in ipairs(AreaOrder) do
        if nameHas(areaName, n) or nameHas(n, areaName) then
            return i
        end
    end
    return nil
end

-- TP em saltos: do indice atual ate targetIdx (inclusive), depois base se for return
local hopping = false

local function hopAlong(fromIdx, toIdx, finallyBase)
    if hopping then notify("Ja esta em TP seguro...") return end
    hopping = true
    refreshAreaWaypoints()

    local step = fromIdx > toIdx and -1 or 1
    notify(string.format("TP seguro: area %d → %d", fromIdx, toIdx))

    for i = fromIdx, toIdx, step do
        if not hopping then break end
        local areaName = AreaOrder[i]
        local wp = areaWaypoints[string.lower(areaName)]
        if wp then
            tpInstant(wp)
            notify("Salto: " .. areaName)
            task.wait(Config.HopDelay)
        end
    end

    if finallyBase then
        local base = findBaseCFrame()
        if base then
            -- ultimos saltos curtos em direcao a base (3 passos)
            local root = getRoot(getChar())
            if root then
                local start = root.Position
                local goal = base.Position
                for t = 1, 3 do
                    local alpha = t / 3
                    local pos = start:Lerp(goal, alpha)
                    tpInstant(CFrame.new(pos + Vector3.new(0, 3, 0)))
                    task.wait(Config.HopDelay * 0.8)
                end
            end
            tpInstant(base)
            notify("Chegou na base (seguro)")
        end
    end

    hopping = false
end

-- Volta pra base com saltos das areas ate Forest e base
local function safeTPBase()
    task.spawn(function()
        local idx = getNearestAreaIndex()
        -- vai de onde esta ate a area 1 (mais perto da base)
        hopAlong(idx, 1, true)
    end)
end

-- Vai ate a area selecionada com saltos
local function safeTPToArea(areaName)
    task.spawn(function()
        refreshAreaWaypoints()
        local targetIdx = getAreaIndexByName(areaName) or getNearestAreaIndex()
        local fromIdx = getNearestAreaIndex()
        hopAlong(fromIdx, targetIdx, false)
    end)
end

task.defer(function()
    task.wait(1)
    captureBase()
    refreshAreaWaypoints()
    if savedBase then notify("Base salva + waypoints carregados") end
end)

-- ==================== EGGS ====================
local function isEggLike(obj)
    if nameHas(obj.Name, "egg") then return true end
    if obj:GetAttribute("Egg") or obj:GetAttribute("IsEgg") then return true end
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

local function eggInArea(obj, area)
    local cur = obj
    for _ = 1, 8 do
        if not cur then break end
        if nameHas(cur.Name, area) then return true end
        cur = cur.Parent
    end
    local ok, path = pcall(function() return obj:GetFullName() end)
    if ok and nameHas(path, area) then return true end
    return false
end

local function findEggsInArea(area)
    local list = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if isEggLike(obj) and eggInArea(obj, area) then
            local part = getPart(obj)
            if part then table.insert(list, {obj = obj, part = part}) end
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
        eggs = findAnyEggs()
        if #eggs == 0 then return nil, "Nenhum ovo" end
        notify("Area sem ovo, generico")
    end
    local root = getRoot(getChar())
    local best, bestDist = nil, math.huge
    for _, e in pairs(eggs) do
        local d = root and (root.Position - e.part.Position).Magnitude or 0
        if d < bestDist then bestDist = d best = e end
    end
    return best, nil
end

AreaBox.FocusLost:Connect(function()
    if AreaBox.Text and #AreaBox.Text > 0 then
        Config.SelectedArea = AreaBox.Text
        notify("Area: " .. Config.SelectedArea)
    else AreaBox.Text = Config.SelectedArea end
end)

-- TP ovo: primeiro saltos ate a area, depois TP curto no ovo
TPEggBtn.MouseButton1Click:Connect(function()
    task.spawn(function()
        safeTPToArea(Config.SelectedArea)
        task.wait(Config.HopDelay * 2)
        local egg, err = pickEggForArea(Config.SelectedArea)
        if not egg then notify(err or "Ovo nao encontrado") return end
        -- salto curto ate o ovo (nao TP de muito longe)
        local root = getRoot(getChar())
        if root then
            local start = root.Position
            local goal = egg.part.Position + Vector3.new(0, 3, 0)
            for t = 1, 4 do
                tpInstant(CFrame.new(start:Lerp(goal, t / 4)))
                task.wait(0.12)
            end
        end
        notify("No ovo: " .. egg.obj.Name)
    end)
end)

TPBaseBtn.MouseButton1Click:Connect(function()
    safeTPBase()
end)

SaveBaseBtn.MouseButton1Click:Connect(function()
    captureBase()
    refreshAreaWaypoints()
    notify("Base + areas atualizadas")
end)

local function autoStealLoop()
    while Config.AutoSteal do
        -- vai ate area com saltos
        safeTPToArea(Config.SelectedArea)
        task.wait(Config.HopDelay * 3)

        local egg = pickEggForArea(Config.SelectedArea)
        if egg then
            local root = getRoot(getChar())
            if root then
                local start = root.Position
                local goal = egg.part.Position + Vector3.new(0, 3, 0)
                for t = 1, 4 do
                    tpInstant(CFrame.new(start:Lerp(goal, t / 4)))
                    task.wait(0.12)
                end
            end
            notify("Auto: ovo " .. egg.obj.Name)
            task.wait(Config.StealDelay)
            for _, d in pairs(egg.obj:GetDescendants()) do
                if d:IsA("ProximityPrompt") then pcall(function() fireproximityprompt(d) end) end
            end
            task.wait(0.4)
            -- volta com saltos seguros
            safeTPBase()
            task.wait(Config.HopDelay * (#AreaOrder * 0.15 + 2))
        else
            notify("Auto: sem ovo")
            task.wait(2)
        end
        task.wait(0.5)
    end
end

AutoStealBtn.MouseButton1Click:Connect(function()
    Config.AutoSteal = not Config.AutoSteal
    setBtn(AutoStealBtn, Config.AutoSteal)
    if Config.AutoSteal then
        notify("Auto Steal SEGURO ON")
        task.spawn(autoStealLoop)
    else
        hopping = false
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
                if d < dist then dist = d closest = plr end
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
    if head then Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position) end
end)

AimBtn.MouseButton1Click:Connect(function()
    Config.Aimlock = not Config.Aimlock
    setBtn(AimBtn, Config.Aimlock)
end)

AimBox.FocusLost:Connect(function()
    local v = tonumber(AimBox.Text)
    if v and v > 0 then Config.AimRange = v AimBox.Text = tostring(v)
    else AimBox.Text = tostring(Config.AimRange) end
end)

-- ==================== BAT AURA ====================
local originalHandles = {}
local function enlargeBat(tool, on)
    if not tool then return end
    local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
    if not handle then return end
    if on then
        if not originalHandles[handle] then originalHandles[handle] = handle.Size end
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
        if t:IsA("Tool") then return t end
    end
    return nil
end

RunService.Heartbeat:Connect(function()
    if not Config.BatAura then return end
    local bat = getBat()
    if not bat then return end
    enlargeBat(bat, true)
    local root = getRoot(getChar())
    if not root then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp and (root.Position - hrp.Position).Magnitude <= Config.BatRange then
                pcall(function() bat:Activate() end)
            end
        end
    end
end)

BatBtn.MouseButton1Click:Connect(function()
    Config.BatAura = not Config.BatAura
    setBtn(BatBtn, Config.BatAura)
    if not Config.BatAura then local bat = getBat() if bat then enlargeBat(bat, false) end end
end)

BatBox.FocusLost:Connect(function()
    local v = tonumber(BatBox.Text)
    if v and v > 0 then Config.BatRange = v BatBox.Text = tostring(v)
    else BatBox.Text = tostring(Config.BatRange) end
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
        if originalSizes[root] then root.Size = originalSizes[root] originalSizes[root] = nil end
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
        local h, r = getHum(getChar()), getRoot(getChar())
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
        if r.CanCollide and not Config.Noclip then applyHitbox(getChar(), true) end
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

ESPBtn.MouseButton1Click:Connect(function()
    Config.ESP = not Config.ESP
    styleChip(ESPBtn, Config.ESP, "ESP")
end)

AntiBtn.MouseButton1Click:Connect(function()
    Config.AntiTaco = not Config.AntiTaco
    styleChip(AntiBtn, Config.AntiTaco, "AntiTaco")
    if Config.AntiTaco then enableAnti() else disableAnti() end
end)

local flingConn
FlingBtn.MouseButton1Click:Connect(function()
    Config.Fling = not Config.Fling
    styleChip(FlingBtn, Config.Fling, "Fling")
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

print("[StealEggHub v8] TP seguro por saltos de area")
notify("v8: TP Base agora usa saltos pelas areas")
