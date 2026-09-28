-- [[ STEAL A EGG HUB v11 ]] --
-- Auto Mythic/Secret spawn + roubo automatico

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
    SelectedArea = "Ocean",
    AutoReturn = false,
    AutoRare = false, -- auto rouba mythic/secret
    HopStuds = 40,
    HopDelay = 0.08,
}

local RareKeywords = {
    "mythic", "mitico", "mítico", "secret", "secreto",
    "divine", "divino", "eternal", "cosmic", "legendary",
    "secrect", "mythical"
}

local AreaList = {
    {name = "Forest", keys = {"Forest", "Floresta"}},
    {name = "Lake", keys = {"Lake", "Lago"}},
    {name = "Desert", keys = {"Desert", "Deserto"}},
    {name = "Jungle", keys = {"Jungle", "Selva"}},
    {name = "Snow", keys = {"Snow", "Neve"}},
    {name = "Volcano", keys = {"Volcano", "Vulcao"}},
    {name = "Ocean", keys = {"Ocean", "Abyss", "Mar", "Sea"}},
    {name = "Prehistoric", keys = {"Prehistoric"}},
    {name = "Cosmic", keys = {"Cosmic"}},
    {name = "Cherry", keys = {"Cherry", "Blossom"}},
    {name = "Titan", keys = {"Titan", "Temple"}},
    {name = "Monkey", keys = {"Monkey", "Macaco", "Gorilla"}},
    {name = "Angels", keys = {"Angels", "Angel", "Anjo", "Demons"}},
}

-- GUI
local SG = Instance.new("ScreenGui")
SG.Name = "StealEggHub"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = game:GetService("CoreGui")

local MIN_W, MIN_H, MAX_W, MAX_H = 280, 300, 560, 760

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 340, 0, 480)
Main.Position = UDim2.new(0.5, -170, 0.5, -240)
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
Title.Text = "♡ STEAL A EGG HUB v11 ♡"
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
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollingDirection = Enum.ScrollingDirection.Y

local layout = Instance.new("UIListLayout", Scroll)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)

local Pad = Instance.new("UIPadding", Scroll)
Pad.PaddingTop = UDim.new(0, 4)
Pad.PaddingBottom = UDim.new(0, 12)
Pad.PaddingLeft = UDim.new(0, 4)
Pad.PaddingRight = UDim.new(0, 8)

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, -40, 0, 20)
Status.Position = UDim2.new(0, 10, 1, -24)
Status.BackgroundTransparency = 1
Status.Text = "v11: Auto Mythic/Secret"
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

local function notify(msg)
    Status.Text = tostring(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Steal Egg Hub", Text = tostring(msg), Duration = 4
        })
    end)
end

-- Sections
local S1 = section("Velocidade", 68)
local SpeedBtn = toggle(S1, 5)
local SpeedBox = box(S1, Config.SpeedVal, "Valor", 34)

local S2 = section("Noclip", 44)
local NoclipBtn = toggle(S2, 12)

local S3 = section("Super Jump", 68)
local JumpBtn = toggle(S3, 5)
local JumpBox = box(S3, Config.JumpPower, "Pulo", 34)

local areaSectionH = 28 + math.ceil(#AreaList / 3) * 30 + 8
local SArea = section("Area (clique)", areaSectionH)
local SelectedLabel = Instance.new("TextLabel", SArea)
SelectedLabel.Size = UDim2.new(1, -16, 0, 18)
SelectedLabel.Position = UDim2.new(0, 8, 0, 4)
SelectedLabel.BackgroundTransparency = 1
SelectedLabel.Text = "Area: " .. Config.SelectedArea
SelectedLabel.Font = Enum.Font.GothamBold
SelectedLabel.TextSize = 12
SelectedLabel.TextColor3 = Color3.fromRGB(120, 220, 255)
SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left

local areaButtons = {}
local function selectArea(name)
    Config.SelectedArea = name
    SelectedLabel.Text = "Area: " .. name
    for n, b in pairs(areaButtons) do
        if n == name then
            b.BackgroundColor3 = Color3.fromRGB(40, 90, 60)
            b.TextColor3 = Color3.fromRGB(120, 255, 160)
        else
            b.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            b.TextColor3 = Color3.new(1, 1, 1)
        end
    end
end

for i, info in ipairs(AreaList) do
    local row = math.floor((i - 1) / 3)
    local col = (i - 1) % 3
    local b = Instance.new("TextButton", SArea)
    b.Size = UDim2.new(0, 96, 0, 26)
    b.Position = UDim2.new(0, 8 + col * 102, 0, 26 + row * 30)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    b.Text = info.name
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    areaButtons[info.name] = b
    b.MouseButton1Click:Connect(function() selectArea(info.name) end)
end
selectArea(Config.SelectedArea)

local S4 = section("TP / Auto", 200)
local GoEggBtn = btn(S4, "Ir ao Ovo (saltinhos)", 28)
local GoBaseBtn = btn(S4, "Voltar Base (saltinhos)", 60)
local SaveBaseBtn = btn(S4, "Salvar Base Aqui", 92)
local AutoReturnBtn = toggle(S4, 128)
local AutoReturnLabel = Instance.new("TextLabel", S4)
AutoReturnLabel.Size = UDim2.new(0.65, 0, 0, 18)
AutoReturnLabel.Position = UDim2.new(0, 8, 0, 128)
AutoReturnLabel.BackgroundTransparency = 1
AutoReturnLabel.Text = "Auto-TP ao roubar"
AutoReturnLabel.Font = Enum.Font.Gotham
AutoReturnLabel.TextSize = 11
AutoReturnLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
AutoReturnLabel.TextXAlignment = Enum.TextXAlignment.Left

local AutoRareBtn = toggle(S4, 156)
local AutoRareLabel = Instance.new("TextLabel", S4)
AutoRareLabel.Size = UDim2.new(0.65, 0, 0, 18)
AutoRareLabel.Position = UDim2.new(0, 8, 0, 156)
AutoRareLabel.BackgroundTransparency = 1
AutoRareLabel.Text = "Auto Mythic/Secret"
AutoRareLabel.Font = Enum.Font.GothamBold
AutoRareLabel.TextSize = 11
AutoRareLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
AutoRareLabel.TextXAlignment = Enum.TextXAlignment.Left

local S5 = section("Aimlock", 68)
local AimBtn = toggle(S5, 5)
local AimBox = box(S5, Config.AimRange, "Range", 34)

local S6 = section("Bat Aura", 68)
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

-- SPEED / NOCLIP / JUMP
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
    if v and v > 0 then Config.SpeedVal = v else SpeedBox.Text = tostring(Config.SpeedVal) end
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
RunService.Heartbeat:Connect(function() if Config.SuperJump then applyJump() end end)
JumpBtn.MouseButton1Click:Connect(function()
    Config.SuperJump = not Config.SuperJump
    setBtn(JumpBtn, Config.SuperJump)
    applyJump()
end)
JumpBox.FocusLost:Connect(function()
    local v = tonumber(JumpBox.Text)
    if v and v > 0 then Config.JumpPower = v if Config.SuperJump then applyJump() end
    else JumpBox.Text = tostring(Config.JumpPower) end
end)

-- CACHE
local savedBase = nil
local waypointCache = {}
local eggCache = {}
local knownEggs = {} -- path -> true (pra detectar spawn novo)
local lastCacheTime = 0
local CACHE_TTL = 6

local function nameHas(str, needle)
    return string.find(string.lower(str or ""), string.lower(needle or ""), 1, true) ~= nil
end

local function getPart(obj)
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") then return obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true) end
    return nil
end

local function isRareText(text)
    local t = string.lower(text or "")
    for _, k in ipairs(RareKeywords) do
        if string.find(t, k, 1, true) then return true end
    end
    return false
end

local function isRareEgg(obj)
    if isRareText(obj.Name) then return true end
    -- atributos
    local attrs = {"Rarity", "EggRarity", "Tier", "Type", "Quality"}
    for _, a in ipairs(attrs) do
        local v = obj:GetAttribute(a)
        if v and isRareText(tostring(v)) then return true end
    end
    -- filhos (labels, StringValues)
    for _, d in pairs(obj:GetDescendants()) do
        if d:IsA("StringValue") or d:IsA("StringValue") then
            if isRareText(d.Value) or isRareText(d.Name) then return true end
        end
        if d:IsA("TextLabel") or d:IsA("TextBox") then
            if isRareText(d.Text) then return true end
        end
        if isRareText(d.Name) then return true end
    end
    local ok, path = pcall(function() return obj:GetFullName() end)
    if ok and isRareText(path) then return true end
    return false
end

local function isEggLike(obj)
    if nameHas(obj.Name, "egg") then return true end
    if obj:GetAttribute("Egg") or obj:GetAttribute("IsEgg") then return true end
    for _, d in pairs(obj:GetChildren()) do
        if d:IsA("ProximityPrompt") then
            local t = (d.ActionText or "") .. (d.ObjectText or "")
            if nameHas(t, "egg") or nameHas(t, "steal") or nameHas(t, "grab") or nameHas(t, "pick") then
                return true
            end
        end
    end
    return false
end

local function captureBase()
    local root = getRoot(getChar())
    if root then savedBase = root.Position end
end

local function rebuildCache()
    waypointCache = {}
    eggCache = {}
    lastCacheTime = tick()

    for _, obj in pairs(workspace:GetDescendants()) do
        local n = obj.Name
        for _, area in ipairs(AreaList) do
            if not waypointCache[area.name] then
                for _, key in ipairs(area.keys) do
                    if nameHas(n, key) then
                        local part = getPart(obj)
                        if part then
                            waypointCache[area.name] = part.Position + Vector3.new(0, 4, 0)
                            break
                        end
                    end
                end
            end
        end
        if isEggLike(obj) then
            local part = getPart(obj)
            if part then
                local id = obj:GetFullName()
                table.insert(eggCache, {
                    pos = part.Position,
                    obj = obj,
                    part = part,
                    rare = isRareEgg(obj),
                    id = id,
                })
                knownEggs[id] = true
            end
        end
    end
end

local function ensureCache()
    if tick() - lastCacheTime > CACHE_TTL then
        rebuildCache()
    end
end

local function getBasePos()
    if savedBase then return savedBase end
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("SpawnLocation") then return obj.Position + Vector3.new(0, 4, 0) end
    end
    local root = getRoot(getChar())
    return root and root.Position or nil
end

-- HOP
local hopping = false
local hopToken = 0

local function hopTo(targetPos)
    local root = getRoot(getChar())
    if not root or not targetPos then return false end
    hopToken += 1
    local myToken = hopToken
    hopping = true

    local start = root.Position
    local dist = (targetPos - start).Magnitude
    if dist < 3 then
        root.CFrame = CFrame.new(targetPos)
        hopping = false
        return true
    end

    local step = Config.HopStuds
    local steps = math.min(math.max(1, math.ceil(dist / step)), 60)

    for i = 1, steps do
        if hopToken ~= myToken then hopping = false return false end
        root = getRoot(getChar())
        if not root then hopping = false return false end
        local pos = start:Lerp(targetPos, i / steps)
        root.CFrame = CFrame.new(pos + Vector3.new(0, 1.5, 0))
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        task.wait(Config.HopDelay)
    end

    root = getRoot(getChar())
    if root then
        root.CFrame = CFrame.new(targetPos)
        root.AssemblyLinearVelocity = Vector3.zero
    end
    hopping = false
    return true
end

local function hopAlongPath(points)
    for _, p in ipairs(points) do
        if not hopTo(p) then return false end
    end
    return true
end

local function buildPathToBase()
    ensureCache()
    local root = getRoot(getChar())
    if not root then return {} end
    local fromPos = root.Position
    local base = getBasePos()
    if not base then return {} end

    local wps = {}
    for name, pos in pairs(waypointCache) do
        table.insert(wps, {pos = pos, dBase = (pos - base).Magnitude})
    end
    table.sort(wps, function(a, b) return a.dBase > b.dBase end)

    local myDist = (fromPos - base).Magnitude
    local path = {}
    for _, w in ipairs(wps) do
        if w.dBase < myDist - 20 and w.dBase > 15 then
            table.insert(path, w.pos)
        end
    end
    table.sort(path, function(a, b)
        return (a - base).Magnitude > (b - base).Magnitude
    end)
    table.insert(path, base)
    return path
end

local function findEggInSelectedArea()
    ensureCache()
    local area
    for _, a in ipairs(AreaList) do
        if a.name == Config.SelectedArea then area = a break end
    end
    local keys = area and area.keys or {Config.SelectedArea}
    local root = getRoot(getChar())
    local best, bestD = nil, math.huge

    for _, e in ipairs(eggCache) do
        if e.part and e.part.Parent then
            local match = false
            local cur = e.obj
            for _ = 1, 8 do
                if not cur then break end
                for _, k in ipairs(keys) do
                    if nameHas(cur.Name, k) then match = true break end
                end
                if match then break end
                cur = cur.Parent
            end
            if match or #eggCache < 8 then
                local d = root and (root.Position - e.pos).Magnitude or 0
                if d < bestD then bestD = d best = e end
            end
        end
    end
    return best
end

local function stealEggObj(egg)
    if not egg or not egg.pos then return end
    notify("Roubando: " .. (egg.obj and egg.obj.Name or "ovo"))
    local path = {}
    -- tenta waypoint da area se existir
    if egg.obj then
        for _, a in ipairs(AreaList) do
            for _, k in ipairs(a.keys) do
                if nameHas(egg.obj:GetFullName(), k) and waypointCache[a.name] then
                    table.insert(path, waypointCache[a.name])
                    break
                end
            end
        end
    end
    table.insert(path, egg.pos + Vector3.new(0, 3, 0))
    hopAlongPath(path)
    if egg.obj then
        for _, d in pairs(egg.obj:GetDescendants()) do
            if d:IsA("ProximityPrompt") then
                pcall(function() fireproximityprompt(d) end)
            end
        end
    end
    task.wait(0.4)
    -- volta
    local back = buildPathToBase()
    if #back == 0 then
        local base = getBasePos()
        if base then hopTo(base) end
    else
        hopAlongPath(back)
    end
    notify("Roubo finalizado")
end

local function goToEgg()
    if hopping then notify("Aguarde o TP") return end
    task.spawn(function()
        ensureCache()
        local egg = findEggInSelectedArea()
        if not egg then
            rebuildCache()
            egg = findEggInSelectedArea()
        end
        if not egg then notify("Ovo nao encontrado") return end
        stealEggObj(egg)
    end)
end

local function goToBase()
    if hopping then notify("Aguarde") return end
    task.spawn(function()
        notify("Voltando...")
        local path = buildPathToBase()
        if #path == 0 then
            local base = getBasePos()
            if base then hopTo(base) end
        else
            hopAlongPath(path)
        end
        notify("Na base")
    end)
end

-- AUTO RETURN
local wasCarrying = false
local function isCarryingEgg()
    local char = getChar()
    if not char then return false end
    for _, c in pairs(char:GetChildren()) do
        if nameHas(c.Name, "egg") then return true end
    end
    if char:GetAttribute("Carrying") or char:GetAttribute("HasEgg") or char:GetAttribute("HoldingEgg") then
        return true
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in pairs(bp:GetChildren()) do
            if nameHas(t.Name, "egg") then return true end
        end
    end
    return false
end

RunService.Heartbeat:Connect(function()
    if not Config.AutoReturn then
        wasCarrying = isCarryingEgg()
        return
    end
    local carrying = isCarryingEgg()
    if carrying and not wasCarrying and not hopping then
        notify("Ovo detectado! Voltando...")
        goToBase()
    end
    wasCarrying = carrying
end)

-- AUTO MYTHIC / SECRET
local rareBusy = false
local function scanForNewRare()
    if not Config.AutoRare or rareBusy or hopping then return end

    for _, obj in pairs(workspace:GetDescendants()) do
        if isEggLike(obj) and isRareEgg(obj) then
            local id = obj:GetFullName()
            if not knownEggs[id] then
                knownEggs[id] = true
                local part = getPart(obj)
                if part then
                    rareBusy = true
                    notify("MYTHIC/SECRET SPAWNOU! Roubando...")
                    task.spawn(function()
                        stealEggObj({
                            pos = part.Position,
                            obj = obj,
                            part = part,
                            rare = true,
                            id = id,
                        })
                        rareBusy = false
                    end)
                    return
                end
            end
        end
    end
end

-- scan leve a cada 1.5s (nao trava)
task.spawn(function()
    while SG.Parent do
        if Config.AutoRare then
            pcall(scanForNewRare)
        end
        task.wait(1.5)
    end
end)

-- tambem escuta ChildAdded em pastas principais
workspace.DescendantAdded:Connect(function(obj)
    if not Config.AutoRare or rareBusy or hopping then return end
    task.defer(function()
        if isEggLike(obj) and isRareEgg(obj) then
            local id = obj:GetFullName()
            if not knownEggs[id] then
                knownEggs[id] = true
                local part = getPart(obj)
                if part then
                    rareBusy = true
                    notify("SECRET/MYTHIC detectado!")
                    task.spawn(function()
                        stealEggObj({pos = part.Position, obj = obj, part = part, rare = true, id = id})
                        rareBusy = false
                    end)
                end
            end
        end
    end)
end)

task.defer(function()
    task.wait(1)
    captureBase()
    rebuildCache()
    notify("v11 pronto - ligue Auto Mythic/Secret")
end)

GoEggBtn.MouseButton1Click:Connect(goToEgg)
GoBaseBtn.MouseButton1Click:Connect(goToBase)
SaveBaseBtn.MouseButton1Click:Connect(function()
    captureBase()
    rebuildCache()
    notify("Base + cache salvos")
end)

AutoReturnBtn.MouseButton1Click:Connect(function()
    Config.AutoReturn = not Config.AutoReturn
    setBtn(AutoReturnBtn, Config.AutoReturn)
end)

AutoRareBtn.MouseButton1Click:Connect(function()
    Config.AutoRare = not Config.AutoRare
    setBtn(AutoRareBtn, Config.AutoRare)
    if Config.AutoRare then
        rebuildCache()
        notify("Auto Mythic/Secret ON - esperando spawn")
    else
        notify("Auto Mythic/Secret OFF")
    end
end)

-- AIMLOCK / BAT / ANTI / FLING / ESP (iguais v10, resumidos)
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
    local t = getClosestPlayer(Config.AimRange)
    if t and t.Character and t.Character:FindFirstChild("Head") then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position)
    end
end)
AimBtn.MouseButton1Click:Connect(function()
    Config.Aimlock = not Config.Aimlock
    setBtn(AimBtn, Config.Aimlock)
end)
AimBox.FocusLost:Connect(function()
    local v = tonumber(AimBox.Text)
    if v and v > 0 then Config.AimRange = v else AimBox.Text = tostring(Config.AimRange) end
end)

local originalHandles = {}
local function enlargeBat(tool, on)
    if not tool then return end
    local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
    if not handle then return end
    if on then
        if not originalHandles[handle] then originalHandles[handle] = handle.Size end
        handle.Size = Vector3.new(math.max(originalHandles[handle].X, Config.BatRange/2), math.max(originalHandles[handle].Y, 2), math.max(originalHandles[handle].Z, Config.BatRange/2))
        handle.Transparency = 0.7
        handle.Massless = true
    else
        if originalHandles[handle] then handle.Size = originalHandles[handle] handle.Transparency = 0 originalHandles[handle] = nil end
    end
end
local function getBat()
    local char = getChar()
    if not char then return nil end
    for _, t in pairs(char:GetChildren()) do if t:IsA("Tool") then return t end end
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
    if not Config.BatAura then local b = getBat() if b then enlargeBat(b, false) end end
end)
BatBox.FocusLost:Connect(function()
    local v = tonumber(BatBox.Text)
    if v and v > 0 then Config.BatRange = v else BatBox.Text = tostring(Config.BatRange) end
end)

local originalSizes, antiConn = {}, nil
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
        if p:IsA("BasePart") and p ~= root then p.CanCollide = not (small or Config.Noclip) end
    end
end
local function enableAnti()
    local hum = getHum(getChar())
    if not hum then return end
    pcall(function()
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    end)
    applyHitbox(getChar(), true)
    if antiConn then antiConn:Disconnect() end
    antiConn = RunService.Heartbeat:Connect(function()
        if not Config.AntiTaco then return end
        local h, r = getHum(getChar()), getRoot(getChar())
        if not h or not r then return end
        local st = h:GetState()
        if st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown or st == Enum.HumanoidStateType.Physics then
            h:ChangeState(Enum.HumanoidStateType.Running)
            h.PlatformStand = false
        end
        if r.AssemblyLinearVelocity.Magnitude > 140 then
            r.AssemblyLinearVelocity = r.AssemblyLinearVelocity.Unit * 50
        end
        if r.CanCollide and not Config.Noclip then applyHitbox(getChar(), true) end
    end)
end
local function disableAnti()
    if antiConn then antiConn:Disconnect() antiConn = nil end
    local hum = getHum(getChar())
    if hum then
        pcall(function()
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
        end)
    end
    applyHitbox(getChar(), false)
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

local ESPFolder = Instance.new("Folder", SG)
ESPFolder.Name = "ESP"
local function clearESP() ESPFolder:ClearAllChildren() end
local function makeESP(plr)
    if plr == LP or not plr.Character then return end
    local char = plr.Character
    local head, root = char:FindFirstChild("Head"), char:FindFirstChild("HumanoidRootPart")
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
ESPBtn.MouseButton1Click:Connect(function()
    if Config.ESP then
        clearESP()
        for _, p in pairs(Players:GetPlayers()) do makeESP(p) end
    else clearESP() end
end)

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    wasCarrying = false
    if Config.Speed then local h = getHum(getChar()) if h then h.WalkSpeed = Config.SpeedVal end end
    if Config.Noclip then setNoclip(getChar(), true) end
    if Config.SuperJump then applyJump() end
    if Config.AntiTaco then enableAnti() end
end)

UIS.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.RightControl then Main.Visible = not Main.Visible end
end)

print("[StealEggHub v11] Auto Mythic/Secret")
notify("Ligue Auto Mythic/Secret e espere o spawn")
