-- [[ STEAL A EGG HUB v23 ]] --
-- Hub completo | Auto Farm | SEM Anti-AFK | SEM Anti-Taco
-- Painel moderno com scroll + resize + todas as funcoes antigas

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    Speed = false, SpeedVal = 50,
    Noclip = false,
    SuperJump = false, JumpPower = 80,
    ESP = false,
    Fling = false,
    Aimlock = false, AimRange = 80,
    BatAura = false, BatRange = 18,
    SelectedArea = "Ocean",
    AutoFarm = false,
    OnlyRare = false,
    DelayGo = 0.8,
    DelayBack = 1.0,
    HopStuds = 12,
    HopDelay = 0.02,
}

local AreaList = {
    "Forest", "Lake", "Desert", "Jungle", "Snow", "Volcano",
    "Ocean", "Prehistoric", "Cosmic", "Cherry", "Titan", "Monkey", "Angels",
}

local RareWords = {"mythic", "mitico", "secret", "secreto", "divine", "legendary", "eternal", "mythical"}

local function getChar() return LP.Character end
local function getHum(c) return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot(c) return c and c:FindFirstChild("HumanoidRootPart") end

local function nameHas(s, n)
    return string.find(string.lower(tostring(s or "")), string.lower(tostring(n or "")), 1, true) ~= nil
end

local function notify(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Steal Egg Hub v23",
            Text = tostring(msg),
            Duration = 3,
        })
    end)
end

-- ========== GUI ==========
local guiParent = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 5) or game:GetService("CoreGui")
pcall(function()
    for _, n in ipairs({"StealEggHub", "EggAutoFarm", "StealEggHubLite"}) do
        local o = guiParent:FindFirstChild(n)
        if o then o:Destroy() end
        local o2 = game:GetService("CoreGui"):FindFirstChild(n)
        if o2 then o2:Destroy() end
    end
end)

local SG = Instance.new("ScreenGui")
SG.Name = "StealEggHub"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = guiParent

local MIN_W, MIN_H, MAX_W, MAX_H = 300, 360, 560, 780

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 360, 0, 540)
Main.Position = UDim2.new(0.5, -180, 0.5, -270)
Main.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
Main.BorderSizePixel = 0
Main.Active = true
Main.ClipsDescendants = true
Main.Parent = SG
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(80, 40, 160)

task.spawn(function()
    local t = 0
    while Main and Main.Parent do
        t = t + 0.02
        local r = math.sin(t) * 0.5 + 0.5
        local g = math.sin(t + 2.1) * 0.5 + 0.5
        local b = math.sin(t + 4.2) * 0.5 + 0.5
        Stroke.Color = Color3.new(r * 0.7 + 0.2, g * 0.4 + 0.1, b * 0.9 + 0.3)
        task.wait(0.04)
    end
end)

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 44)
Header.BackgroundColor3 = Color3.fromRGB(20, 18, 28)
Header.BorderSizePixel = 0
Header.Active = true
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "STEAL A EGG HUB  v23"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(220, 200, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 60)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -72, 0.5, -15)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
MinBtn.Text = "_"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
MinBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

local StatusBar = Instance.new("Frame", Main)
StatusBar.Size = UDim2.new(1, 0, 0, 22)
StatusBar.Position = UDim2.new(0, 0, 1, -22)
StatusBar.BackgroundColor3 = Color3.fromRGB(18, 16, 24)
StatusBar.BorderSizePixel = 0

local StatusTxt = Instance.new("TextLabel", StatusBar)
StatusTxt.Size = UDim2.new(1, -16, 1, 0)
StatusTxt.Position = UDim2.new(0, 10, 0, 0)
StatusTxt.BackgroundTransparency = 1
StatusTxt.Text = "Hub pronto | RightCtrl = toggle"
StatusTxt.Font = Enum.Font.Gotham
StatusTxt.TextSize = 11
StatusTxt.TextColor3 = Color3.fromRGB(160, 160, 180)
StatusTxt.TextXAlignment = Enum.TextXAlignment.Left

local function setStatus(t)
    StatusTxt.Text = tostring(t)
end

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -8, 1, -70)
Scroll.Position = UDim2.new(0, 4, 0, 48)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 5
Scroll.ScrollBarImageColor3 = Color3.fromRGB(120, 80, 200)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

local Pad = Instance.new("UIPadding", Scroll)
Pad.PaddingTop = UDim.new(0, 4)
Pad.PaddingBottom = UDim.new(0, 12)
Pad.PaddingLeft = UDim.new(0, 4)
Pad.PaddingRight = UDim.new(0, 8)

local minimized = false
local savedSize = Main.Size
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        savedSize = Main.Size
        Main.Size = UDim2.new(0, Main.Size.X.Offset, 0, 44)
        Scroll.Visible = false
    else
        Main.Size = savedSize
        Scroll.Visible = true
    end
end)

local function section(title, height)
    local f = Instance.new("Frame", Scroll)
    f.Size = UDim2.new(1, -4, 0, height)
    f.BackgroundColor3 = Color3.fromRGB(22, 20, 30)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    local st = Instance.new("UIStroke", f)
    st.Thickness = 1
    st.Color = Color3.fromRGB(50, 40, 70)
    local lab = Instance.new("TextLabel", f)
    lab.Size = UDim2.new(1, -12, 0, 18)
    lab.Position = UDim2.new(0, 10, 0, 4)
    lab.BackgroundTransparency = 1
    lab.Text = title
    lab.Font = Enum.Font.GothamBold
    lab.TextSize = 12
    lab.TextColor3 = Color3.fromRGB(180, 150, 255)
    lab.TextXAlignment = Enum.TextXAlignment.Left
    return f
end

local function makeToggle(parent, y, label)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.55, -10, 0, 28)
    btn.Position = UDim2.new(0, 8, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
    btn.Text = label .. ": OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
    return btn
end

local function makeBox(parent, y, default, placeholder)
    local box = Instance.new("TextBox", parent)
    box.Size = UDim2.new(0.4, -10, 0, 28)
    box.Position = UDim2.new(0.58, 0, 0, y)
    box.BackgroundColor3 = Color3.fromRGB(30, 28, 40)
    box.Text = tostring(default)
    box.PlaceholderText = placeholder or ""
    box.Font = Enum.Font.Gotham
    box.TextSize = 12
    box.TextColor3 = Color3.new(1, 1, 1)
    box.ClearTextOnFocus = false
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 7)
    return box
end

local function setBtn(btn, on, label)
    if on then
        btn.Text = (label or "") .. ": ON"
        btn.TextColor3 = Color3.fromRGB(100, 255, 140)
        btn.BackgroundColor3 = Color3.fromRGB(30, 70, 45)
    else
        btn.Text = (label or "") .. ": OFF"
        btn.TextColor3 = Color3.fromRGB(255, 100, 100)
        btn.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
    end
end

-- MOVIMENTO
local S1 = section("Movimento", 100)
local SpeedBtn = makeToggle(S1, 28, "Speed")
local SpeedBox = makeBox(S1, 28, Config.SpeedVal, "Velocidade")
local NoclipBtn = makeToggle(S1, 62, "Noclip")
local JumpBtn = Instance.new("TextButton", S1)
JumpBtn.Size = UDim2.new(0.4, -10, 0, 28)
JumpBtn.Position = UDim2.new(0.58, 0, 0, 62)
JumpBtn.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
JumpBtn.Text = "Super Jump: OFF"
JumpBtn.Font = Enum.Font.GothamBold
JumpBtn.TextSize = 11
JumpBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
Instance.new("UICorner", JumpBtn).CornerRadius = UDim.new(0, 7)

-- AREA
local areaH = 28 + math.ceil(#AreaList / 3) * 32
local SArea = section("Area (clique no bioma)", areaH)
local areaLabel = Instance.new("TextLabel", SArea)
areaLabel.Size = UDim2.new(1, -12, 0, 16)
areaLabel.Position = UDim2.new(0, 10, 0, 4)
areaLabel.BackgroundTransparency = 1
areaLabel.Text = "Selecionado: " .. Config.SelectedArea
areaLabel.Font = Enum.Font.GothamBold
areaLabel.TextSize = 11
areaLabel.TextColor3 = Color3.fromRGB(100, 220, 255)
areaLabel.TextXAlignment = Enum.TextXAlignment.Left

local areaButtons = {}
local function selectArea(name)
    Config.SelectedArea = name
    areaLabel.Text = "Selecionado: " .. name
    for n, b in pairs(areaButtons) do
        if n == name then
            b.BackgroundColor3 = Color3.fromRGB(40, 100, 70)
            b.TextColor3 = Color3.fromRGB(120, 255, 160)
        else
            b.BackgroundColor3 = Color3.fromRGB(35, 32, 48)
            b.TextColor3 = Color3.new(1, 1, 1)
        end
    end
end

for i, name in ipairs(AreaList) do
    local row = math.floor((i - 1) / 3)
    local col = (i - 1) % 3
    local b = Instance.new("TextButton", SArea)
    b.Size = UDim2.new(0, 100, 0, 28)
    b.Position = UDim2.new(0, 10 + col * 108, 0, 26 + row * 32)
    b.BackgroundColor3 = Color3.fromRGB(35, 32, 48)
    b.Text = name
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    areaButtons[name] = b
    b.MouseButton1Click:Connect(function() selectArea(name) end)
end
selectArea(Config.SelectedArea)

-- TP / AUTO FARM
local S4 = section("TP / Auto Farm", 220)
local GoEggBtn = Instance.new("TextButton", S4)
GoEggBtn.Size = UDim2.new(1, -16, 0, 30)
GoEggBtn.Position = UDim2.new(0, 8, 0, 26)
GoEggBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 90)
GoEggBtn.Text = "IR AO OVO (area selecionada)"
GoEggBtn.Font = Enum.Font.GothamBold
GoEggBtn.TextSize = 12
GoEggBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", GoEggBtn).CornerRadius = UDim.new(0, 7)

local GoBaseBtn = Instance.new("TextButton", S4)
GoBaseBtn.Size = UDim2.new(0.48, -10, 0, 28)
GoBaseBtn.Position = UDim2.new(0, 8, 0, 62)
GoBaseBtn.BackgroundColor3 = Color3.fromRGB(40, 60, 90)
GoBaseBtn.Text = "Voltar Base"
GoBaseBtn.Font = Enum.Font.GothamBold
GoBaseBtn.TextSize = 12
GoBaseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", GoBaseBtn).CornerRadius = UDim.new(0, 7)

local SaveBaseBtn = Instance.new("TextButton", S4)
SaveBaseBtn.Size = UDim2.new(0.48, -10, 0, 28)
SaveBaseBtn.Position = UDim2.new(0.52, 0, 0, 62)
SaveBaseBtn.BackgroundColor3 = Color3.fromRGB(40, 70, 50)
SaveBaseBtn.Text = "Salvar Base"
SaveBaseBtn.Font = Enum.Font.GothamBold
SaveBaseBtn.TextSize = 12
SaveBaseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", SaveBaseBtn).CornerRadius = UDim.new(0, 7)

local DelayGoBox = makeBox(S4, 98, Config.DelayGo, "Delay ovo")
DelayGoBox.Size = UDim2.new(0.45, -10, 0, 26)
DelayGoBox.Position = UDim2.new(0, 8, 0, 98)
local DelayBackBox = makeBox(S4, 98, Config.DelayBack, "Delay base")
DelayBackBox.Size = UDim2.new(0.45, -10, 0, 26)
DelayBackBox.Position = UDim2.new(0.52, 0, 0, 98)

local FarmBtn = makeToggle(S4, 132, "Auto Farm")
local RareBtn = Instance.new("TextButton", S4)
RareBtn.Size = UDim2.new(0.4, -10, 0, 28)
RareBtn.Position = UDim2.new(0.58, 0, 0, 132)
RareBtn.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
RareBtn.Text = "So Rare: OFF"
RareBtn.Font = Enum.Font.GothamBold
RareBtn.TextSize = 11
RareBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
Instance.new("UICorner", RareBtn).CornerRadius = UDim.new(0, 7)

local HopInfo = Instance.new("TextLabel", S4)
HopInfo.Size = UDim2.new(1, -16, 0, 18)
HopInfo.Position = UDim2.new(0, 8, 0, 168)
HopInfo.BackgroundTransparency = 1
HopInfo.Text = "Hop: " .. Config.HopStuds .. " studs | " .. (Config.HopDelay * 1000) .. "ms"
HopInfo.Font = Enum.Font.Gotham
HopInfo.TextSize = 11
HopInfo.TextColor3 = Color3.fromRGB(140, 140, 160)
HopInfo.TextXAlignment = Enum.TextXAlignment.Left

local HopStudsBox = makeBox(S4, 186, Config.HopStuds, "Studs")
HopStudsBox.Size = UDim2.new(0.45, -10, 0, 24)
HopStudsBox.Position = UDim2.new(0, 8, 0, 186)
local HopDelayBox = makeBox(S4, 186, Config.HopDelay, "Delay s")
HopDelayBox.Size = UDim2.new(0.45, -10, 0, 24)
HopDelayBox.Position = UDim2.new(0.52, 0, 0, 186)

-- AIMLOCK
local S5 = section("Aimlock", 70)
local AimBtn = makeToggle(S5, 28, "Aimlock")
local AimBox = makeBox(S5, 28, Config.AimRange, "Range")

-- BAT AURA
local S6 = section("Bat Aura", 70)
local BatBtn = makeToggle(S6, 28, "Bat Aura")
local BatBox = makeBox(S6, 28, Config.BatRange, "Range")

-- ESP / FLING
local S7 = section("ESP | Fling", 56)
local ESPBtn = Instance.new("TextButton", S7)
ESPBtn.Size = UDim2.new(0, 140, 0, 30)
ESPBtn.Position = UDim2.new(0, 10, 0, 22)
ESPBtn.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
ESPBtn.Text = "ESP: OFF"
ESPBtn.Font = Enum.Font.GothamBold
ESPBtn.TextSize = 12
ESPBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0, 7)

local FlingBtn = Instance.new("TextButton", S7)
FlingBtn.Size = UDim2.new(0, 140, 0, 30)
FlingBtn.Position = UDim2.new(0, 160, 0, 22)
FlingBtn.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
FlingBtn.Text = "Fling: OFF"
FlingBtn.Font = Enum.Font.GothamBold
FlingBtn.TextSize = 12
FlingBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
Instance.new("UICorner", FlingBtn).CornerRadius = UDim.new(0, 7)

-- Resize
local Resize = Instance.new("TextButton", Main)
Resize.Size = UDim2.new(0, 18, 0, 18)
Resize.Position = UDim2.new(1, -20, 1, -20)
Resize.BackgroundColor3 = Color3.fromRGB(80, 60, 140)
Resize.Text = ""
Resize.ZIndex = 10
Instance.new("UICorner", Resize).CornerRadius = UDim.new(0, 4)

-- Drag
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
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local resizing, rStart, rSize
Resize.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        rStart = input.Position
        rSize = Main.Size
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then resizing = false end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - rStart
        local nw = math.clamp(rSize.X.Offset + delta.X, MIN_W, MAX_W)
        local nh = math.clamp(rSize.Y.Offset + delta.Y, MIN_H, MAX_H)
        Main.Size = UDim2.new(0, nw, 0, nh)
    end
end)

-- ========== LOGIC ==========
local savedBase = nil
local hopping = false
local farmRunning = false

local function captureBase()
    local r = getRoot(getChar())
    if r then
        savedBase = r.Position
        setStatus("Base salva")
        notify("Base salva")
    end
end

local function hopTo(pos)
    local root = getRoot(getChar())
    if not root or not pos then return false end
    hopping = true
    local start = root.Position
    local dist = (pos - start).Magnitude
    local steps = math.ceil(dist / Config.HopStuds)
    if steps < 1 then steps = 1 end
    if steps > 150 then steps = 150 end
    for i = 1, steps do
        root = getRoot(getChar())
        if not root then
            hopping = false
            return false
        end
        local p = start:Lerp(pos, i / steps)
        root.CFrame = CFrame.new(p + Vector3.new(0, 1.2, 0))
        root.AssemblyLinearVelocity = Vector3.zero
        task.wait(Config.HopDelay)
    end
    root = getRoot(getChar())
    if root then
        root.CFrame = CFrame.new(pos + Vector3.new(0, 1, 0))
        root.AssemblyLinearVelocity = Vector3.zero
    end
    hopping = false
    return true
end

local function isRare(obj)
    local n = string.lower(tostring(obj.Name or ""))
    local full = ""
    pcall(function() full = string.lower(obj:GetFullName()) end)
    for _, w in ipairs(RareWords) do
        if string.find(n, w, 1, true) or string.find(full, w, 1, true) then
            return true
        end
    end
    return false
end

local function findEgg()
    local root = getRoot(getChar())
    local best, bestScore = nil, math.huge
    local list = workspace:GetDescendants()
    for i = 1, #list do
        local obj = list[i]
        if nameHas(obj.Name, "egg") then
            local rareOk = true
            if Config.OnlyRare then
                rareOk = isRare(obj)
            end
            if rareOk then
                local part = nil
                if obj:IsA("BasePart") then
                    part = obj
                elseif obj:IsA("Model") then
                    part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                end
                if part then
                    local full = ""
                    pcall(function() full = obj:GetFullName() end)
                    local inArea = nameHas(full, Config.SelectedArea) or nameHas(obj.Name, Config.SelectedArea)
                    local d = root and (root.Position - part.Position).Magnitude or 0
                    local score = inArea and d or (d + 8000)
                    if score < bestScore then
                        bestScore = score
                        best = {pos = part.Position, obj = obj}
                    end
                end
            end
        end
    end
    return best
end

local function tryPrompt(obj)
    if not obj then return end
    local ok, desc = pcall(function() return obj:GetDescendants() end)
    if not ok or not desc then return end
    for i = 1, #desc do
        local d = desc[i]
        if d:IsA("ProximityPrompt") then
            pcall(function()
                if fireproximityprompt then
                    fireproximityprompt(d)
                end
            end)
        end
    end
end

local function isCarryingEgg()
    local c = getChar()
    if not c then return false end
    for _, v in pairs(c:GetChildren()) do
        if nameHas(v.Name, "egg") then return true end
    end
    local tool = c:FindFirstChildOfClass("Tool")
    if tool and nameHas(tool.Name, "egg") then return true end
    return false
end

RunService.Heartbeat:Connect(function()
    if not Config.Speed then return end
    local h = getHum(getChar())
    if h then h.WalkSpeed = Config.SpeedVal end
end)

SpeedBtn.MouseButton1Click:Connect(function()
    Config.Speed = not Config.Speed
    setBtn(SpeedBtn, Config.Speed, "Speed")
    local h = getHum(getChar())
    if h then h.WalkSpeed = Config.Speed and Config.SpeedVal or 16 end
    setStatus(Config.Speed and ("Speed " .. Config.SpeedVal) or "Speed off")
end)

SpeedBox.FocusLost:Connect(function()
    local v = tonumber(SpeedBox.Text)
    if v and v > 0 then
        Config.SpeedVal = math.clamp(v, 1, 99999)
        SpeedBox.Text = tostring(Config.SpeedVal)
        if Config.Speed then
            local h = getHum(getChar())
            if h then h.WalkSpeed = Config.SpeedVal end
        end
    else
        SpeedBox.Text = tostring(Config.SpeedVal)
    end
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
    setBtn(NoclipBtn, Config.Noclip, "Noclip")
    if Config.Noclip then
        if noclipConn then noclipConn:Disconnect() end
        noclipConn = RunService.Stepped:Connect(function()
            if Config.Noclip then setNoclip(getChar(), true) end
        end)
        setNoclip(getChar(), true)
    else
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
        setNoclip(getChar(), false)
    end
    setStatus(Config.Noclip and "Noclip ON" or "Noclip OFF")
end)

local function applyJump()
    local h = getHum(getChar())
    if h then
        h.UseJumpPower = true
        h.JumpPower = Config.SuperJump and Config.JumpPower or 50
        pcall(function() h.JumpHeight = Config.SuperJump and (Config.JumpPower / 3) or 7.2 end)
    end
end

JumpBtn.MouseButton1Click:Connect(function()
    Config.SuperJump = not Config.SuperJump
    setBtn(JumpBtn, Config.SuperJump, "Super Jump")
    applyJump()
    setStatus(Config.SuperJump and ("Jump " .. Config.JumpPower) or "Jump normal")
end)

GoEggBtn.MouseButton1Click:Connect(function()
    if hopping then return end
    setStatus("Procurando ovo...")
    local egg = findEgg()
    if egg then
        setStatus("Indo ao ovo...")
        hopTo(egg.pos)
        task.wait(0.15)
        tryPrompt(egg.obj)
        setStatus("Chegou no ovo")
    else
        setStatus("Nenhum ovo encontrado")
        notify("Nenhum ovo na area")
    end
end)

GoBaseBtn.MouseButton1Click:Connect(function()
    if hopping then return end
    if savedBase then
        setStatus("Voltando base...")
        hopTo(savedBase)
        setStatus("Na base")
    else
        notify("Salve a base primeiro")
        setStatus("Base nao salva")
    end
end)

SaveBaseBtn.MouseButton1Click:Connect(function()
    captureBase()
end)

DelayGoBox.FocusLost:Connect(function()
    local v = tonumber(DelayGoBox.Text)
    if v and v >= 0 then Config.DelayGo = v else DelayGoBox.Text = tostring(Config.DelayGo) end
end)
DelayBackBox.FocusLost:Connect(function()
    local v = tonumber(DelayBackBox.Text)
    if v and v >= 0 then Config.DelayBack = v else DelayBackBox.Text = tostring(Config.DelayBack) end
end)
HopStudsBox.FocusLost:Connect(function()
    local v = tonumber(HopStudsBox.Text)
    if v and v > 0 then
        Config.HopStuds = math.clamp(v, 3, 40)
        HopStudsBox.Text = tostring(Config.HopStuds)
        HopInfo.Text = "Hop: " .. Config.HopStuds .. " studs | " .. (Config.HopDelay * 1000) .. "ms"
    else
        HopStudsBox.Text = tostring(Config.HopStuds)
    end
end)
HopDelayBox.FocusLost:Connect(function()
    local v = tonumber(HopDelayBox.Text)
    if v and v >= 0 then
        Config.HopDelay = math.clamp(v, 0.005, 0.2)
        HopDelayBox.Text = tostring(Config.HopDelay)
        HopInfo.Text = "Hop: " .. Config.HopStuds .. " studs | " .. (Config.HopDelay * 1000) .. "ms"
    else
        HopDelayBox.Text = tostring(Config.HopDelay)
    end
end)

RareBtn.MouseButton1Click:Connect(function()
    Config.OnlyRare = not Config.OnlyRare
    if Config.OnlyRare then
        RareBtn.Text = "So Rare: ON"
        RareBtn.TextColor3 = Color3.fromRGB(100, 255, 140)
        RareBtn.BackgroundColor3 = Color3.fromRGB(30, 70, 45)
    else
        RareBtn.Text = "So Rare: OFF"
        RareBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        RareBtn.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
    end
end)

FarmBtn.MouseButton1Click:Connect(function()
    Config.AutoFarm = not Config.AutoFarm
    setBtn(FarmBtn, Config.AutoFarm, "Auto Farm")
    if Config.AutoFarm then
        setStatus("Auto Farm ON")
        notify("Auto Farm ligado")
        if not farmRunning then
            farmRunning = true
            task.spawn(function()
                while Config.AutoFarm do
                    if hopping then
                        task.wait(0.3)
                    else
                        if isCarryingEgg() then
                            if savedBase then
                                setStatus("Ovo pego -> base")
                                hopTo(savedBase)
                                task.wait(Config.DelayBack)
                            else
                                setStatus("Sem base salva!")
                                task.wait(1)
                            end
                        else
                            local egg = findEgg()
                            if egg then
                                setStatus("Farm -> ovo")
                                hopTo(egg.pos)
                                task.wait(0.12)
                                tryPrompt(egg.obj)
                                task.wait(Config.DelayGo)
                            else
                                setStatus("Sem ovo, aguardando...")
                                task.wait(1.2)
                            end
                        end
                    end
                    task.wait(0.05)
                end
                farmRunning = false
                setStatus("Auto Farm OFF")
            end)
        end
    else
        setStatus("Auto Farm OFF")
    end
end)

local aimConn
AimBtn.MouseButton1Click:Connect(function()
    Config.Aimlock = not Config.Aimlock
    setBtn(AimBtn, Config.Aimlock, "Aimlock")
    if Config.Aimlock then
        if aimConn then aimConn:Disconnect() end
        aimConn = RunService.RenderStepped:Connect(function()
            if not Config.Aimlock then return end
            local root = getRoot(getChar())
            if not root then return end
            local closest, dist = nil, Config.AimRange
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local hr = plr.Character:FindFirstChild("HumanoidRootPart")
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if hr and hum and hum.Health > 0 then
                        local d = (root.Position - hr.Position).Magnitude
                        if d < dist then
                            dist = d
                            closest = hr
                        end
                    end
                end
            end
            if closest then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position)
            end
        end)
    else
        if aimConn then aimConn:Disconnect() aimConn = nil end
    end
end)

AimBox.FocusLost:Connect(function()
    local v = tonumber(AimBox.Text)
    if v and v > 0 then Config.AimRange = v else AimBox.Text = tostring(Config.AimRange) end
end)

local batConn
BatBtn.MouseButton1Click:Connect(function()
    Config.BatAura = not Config.BatAura
    setBtn(BatBtn, Config.BatAura, "Bat Aura")
    if Config.BatAura then
        if batConn then batConn:Disconnect() end
        batConn = RunService.Heartbeat:Connect(function()
            if not Config.BatAura then return end
            local c = getChar()
            if not c then return end
            local tool = c:FindFirstChildOfClass("Tool")
            if not tool then return end
            local root = getRoot(c)
            if not root then return end
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local hr = plr.Character:FindFirstChild("HumanoidRootPart")
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if hr and hum and hum.Health > 0 and (root.Position - hr.Position).Magnitude <= Config.BatRange then
                        pcall(function() tool:Activate() end)
                        for _, rem in pairs(tool:GetDescendants()) do
                            if rem:IsA("RemoteEvent") then
                                pcall(function() rem:FireServer() end)
                            end
                        end
                    end
                end
            end
        end)
    else
        if batConn then batConn:Disconnect() batConn = nil end
    end
end)

BatBox.FocusLost:Connect(function()
    local v = tonumber(BatBox.Text)
    if v and v > 0 then Config.BatRange = v else BatBox.Text = tostring(Config.BatRange) end
end)

local ESPFolder = Instance.new("Folder", SG)
ESPFolder.Name = "ESPFolder"

local function clearESP()
    for _, v in pairs(ESPFolder:GetChildren()) do v:Destroy() end
end

local function makeESP(plr)
    if plr == LP then return end
    local char = plr.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    if not root or not head then return end

    local hl = Instance.new("Highlight")
    hl.Adornee = char
    hl.FillColor = Color3.fromRGB(255, 60, 80)
    hl.OutlineColor = Color3.new(1, 1, 1)
    hl.FillTransparency = 0.55
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = ESPFolder

    local bb = Instance.new("BillboardGui", ESPFolder)
    bb.Adornee = head
    bb.Size = UDim2.new(0, 140, 0, 32)
    bb.StudsOffset = Vector3.new(0, 2.4, 0)
    bb.AlwaysOnTop = true

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
    Config.ESP = not Config.ESP
    ESPBtn.Text = Config.ESP and "ESP: ON" or "ESP: OFF"
    ESPBtn.TextColor3 = Config.ESP and Color3.fromRGB(100, 255, 120) or Color3.fromRGB(255, 100, 100)
    ESPBtn.BackgroundColor3 = Config.ESP and Color3.fromRGB(30, 70, 45) or Color3.fromRGB(40, 35, 55)
    refreshESP()
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if Config.ESP then makeESP(p) end
    end)
end)

local flingConn
FlingBtn.MouseButton1Click:Connect(function()
    Config.Fling = not Config.Fling
    FlingBtn.Text = Config.Fling and "Fling: ON" or "Fling: OFF"
    FlingBtn.TextColor3 = Config.Fling and Color3.fromRGB(100, 255, 120) or Color3.fromRGB(255, 100, 100)
    FlingBtn.BackgroundColor3 = Config.Fling and Color3.fromRGB(30, 70, 45) or Color3.fromRGB(40, 35, 55)
    if Config.Fling then
        if flingConn then flingConn:Disconnect() end
        flingConn = RunService.Heartbeat:Connect(function()
            if not Config.Fling then return end
            local root = getRoot(getChar())
            if not root then return end
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local o = plr.Character:FindFirstChild("HumanoidRootPart")
                    if o and (root.Position - o.Position).Magnitude < 8 then
                        local dir = (o.Position - root.Position)
                        if dir.Magnitude < 0.1 then dir = Vector3.yAxis end
                        dir = dir.Unit
                        pcall(function()
                            o.AssemblyLinearVelocity = (dir + Vector3.new(0, 1.2, 0)).Unit * 190
                        end)
                        local bv = Instance.new("BodyVelocity")
                        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                        bv.Velocity = (dir + Vector3.new(0, 1.1, 0)).Unit * 170
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

LP.CharacterAdded:Connect(function()
    task.wait(0.6)
    if Config.Speed then
        local h = getHum(getChar())
        if h then h.WalkSpeed = Config.SpeedVal end
    end
    if Config.Noclip then setNoclip(getChar(), true) end
    if Config.SuperJump then applyJump() end
    if Config.ESP then task.wait(0.5) refreshESP() end
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
    end
end)

task.defer(function()
    task.wait(0.5)
    captureBase()
    notify("Hub v23 completo restaurado")
    setStatus("Hub v23 pronto | RightCtrl = menu")
end)

print("[StealEggHub v23] hub completo com funcoes antigas carregado")
