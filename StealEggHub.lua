-- [[ STEAL A EGG HUB v7 ]] --
-- GUI: scroll + resize com mouse

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LP:GetMouse()

local Config = {
    Speed = false, SpeedVal = 100,
    Noclip = false,
    SuperJump = false, JumpPower = 80,
    ESP = false, AntiTaco = false, Fling = false,
    Aimlock = false, AimRange = 80,
    BatAura = false, BatRange = 18,
    SelectedArea = "Forest",
    AutoSteal = false, StealDelay = 1.2,
}

-- ==================== GUI (SCROLL + RESIZE) ====================
local SG = Instance.new("ScreenGui")
SG.Name = "StealEggHub"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = game:GetService("CoreGui")

local MIN_W, MIN_H = 260, 280
local MAX_W, MAX_H = 520, 700

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 320, 0, 420)
Main.Position = UDim2.new(0.5, -160, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BorderSizePixel = 0
Main.Active = true
Main.ClipsDescendants = true
Main.Parent = SG
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 2

-- Header (arrastar janela)
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Header.BorderSizePixel = 0
Header.Active = true
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

-- tapa canto de baixo do header
local HeaderFix = Instance.new("Frame", Header)
HeaderFix.Size = UDim2.new(1, 0, 0, 14)
HeaderFix.Position = UDim2.new(0, 0, 1, -14)
HeaderFix.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
HeaderFix.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "♡ STEAL A EGG HUB v7 ♡"
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

-- Drag janela pelo header
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
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Scroll content
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Name = "Scroll"
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
Pad.PaddingBottom = UDim.new(0, 10)
Pad.PaddingLeft = UDim.new(0, 4)
Pad.PaddingRight = UDim.new(0, 8)

-- Footer status
local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, -40, 0, 20)
Status.Position = UDim2.new(0, 10, 1, -24)
Status.BackgroundTransparency = 1
Status.Text = "Arraste o canto ⤡ p/ redimensionar | Scroll no meio"
Status.Font = Enum.Font.Gotham
Status.TextSize = 10
Status.TextColor3 = Color3.fromRGB(140, 140, 140)
Status.TextXAlignment = Enum.TextXAlignment.Left

-- Resize handle (canto inferior direito)
local Resize = Instance.new("TextButton", Main)
Resize.Name = "Resize"
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
    local resizing = false
    local startInput, startSize
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
            local delta = input.Position - startInput
            local newW = math.clamp(startSize.X + delta.X, MIN_W, MAX_W)
            local newH = math.clamp(startSize.Y + delta.Y, MIN_H, MAX_H)
            Main.Size = UDim2.new(0, newW, 0, newH)
        end
    end)
end

-- Helpers UI
local order = 0
local function nextOrder()
    order += 1
    return order
end

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

-- Sections
local S1 = section("Velocidade (sem limite)", 68)
local SpeedBtn = toggle(S1, 5)
local SpeedBox = box(S1, Config.SpeedVal, "Qualquer valor", 34)

local S2 = section("Noclip", 44)
local NoclipBtn = toggle(S2, 12)

local S3 = section("Super Jump", 68)
local JumpBtn = toggle(S3, 5)
local JumpBox = box(S3, Config.JumpPower, "Poder do pulo", 34)

local S4 = section("Area + TP Steal", 168)
local AreaBox = box(S4, Config.SelectedArea, "Forest, Lake, Volcano...", 28)
local TPEggBtn = btn(S4, "TP Ovo da Area", 60)
local TPBaseBtn = btn(S4, "TP Base (Shift+click = salvar base)", 92)
local AutoStealBtn = toggle(S4, 128)
local AutoLabel = Instance.new("TextLabel", S4)
AutoLabel.Size = UDim2.new(0.55, 0, 0, 20)
AutoLabel.Position = UDim2.new(0, 8, 0, 128)
AutoLabel.BackgroundTransparency = 1
AutoLabel.Text = "Auto Steal"
AutoLabel.Font = Enum.Font.Gotham
AutoLabel.TextSize = 12
AutoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
AutoLabel.TextXAlignment = Enum.TextXAlignment.Left

local S5 = section("Aimlock (player perto)", 68)
local AimBtn = toggle(S5, 5)
local AimBox = box(S5, Config.AimRange, "Range aimlock", 34)

local S6 = section("Bat Aura / Hitbox taco", 68)
local BatBtn = toggle(S6, 5)
local BatBox = box(S6, Config.BatRange, "Range do taco", 34)

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

-- ==================== SPEED ====================
RunService.Heartbeat:Connect(function()
    if not Config.Speed then return end
    local hum = getHum(getChar())
    if hum then hum.WalkSpeed = Config.SpeedVal end
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
    if v and v > 0 then Config.JumpPower = v JumpBox.Text = tostring(v) if Config.SuperJump then applyJump() end
    else JumpBox.Text = tostring(Config.JumpPower) end
end)

-- ==================== BASE / TP ====================
local savedBase = nil

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

task.defer(function()
    task.wait(1)
    captureBase()
    if savedBase then notify("Base salva (posicao atual)") end
end)

local function tpTo(cf)
    local root = getRoot(getChar())
    if not root or not cf then return false end
    root.CFrame = cf
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    return true
end

local function nameHas(str, needle)
    return string.find(string.lower(str or ""), string.lower(needle or ""), 1, true) ~= nil
end

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

local function getPart(obj)
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") then return obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart") end
    return nil
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
        if #eggs == 0 then return nil, "Nenhum ovo encontrado" end
        notify("Area sem ovo, usando generico")
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

TPEggBtn.MouseButton1Click:Connect(function()
    local egg, err = pickEggForArea(Config.SelectedArea)
    if not egg then notify(err or "Ovo nao encontrado") return end
    if tpTo(egg.part.CFrame + Vector3.new(0, 3, 0)) then
        notify("TP ovo: " .. Config.SelectedArea .. " (" .. egg.obj.Name .. ")")
    end
end)

TPBaseBtn.MouseButton1Click:Connect(function()
    if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
        captureBase()
        notify("Base salva (posicao atual)")
        return
    end
    local cf = findBaseCFrame()
    if cf and tpTo(cf) then notify("TP Base")
    else notify("Base nao encontrada") end
end)

local function autoStealLoop()
    while Config.AutoSteal do
        local egg = pickEggForArea(Config.SelectedArea)
        if egg then
            tpTo(egg.part.CFrame + Vector3.new(0, 3, 0))
            notify("Auto: ovo " .. egg.obj.Name)
            task.wait(Config.StealDelay)
            for _, d in pairs(egg.obj:GetDescendants()) do
                if d:IsA("ProximityPrompt") then pcall(function() fireproximityprompt(d) end) end
            end
            task.wait(0.35)
            local base = findBaseCFrame()
            if base then tpTo(base) notify("Auto: base") end
            task.wait(Config.StealDelay)
        else
            notify("Auto: sem ovo")
            task.wait(2)
        end
        task.wait(0.25)
    end
end

AutoStealBtn.MouseButton1Click:Connect(function()
    Config.AutoSteal = not Config.AutoSteal
    setBtn(AutoStealBtn, Config.AutoSteal)
    if Config.AutoSteal then
        notify("Auto Steal ON - " .. Config.SelectedArea)
        task.spawn(autoStealLoop)
    else notify("Auto Steal OFF") end
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
    if not Config.BatAura then
        local bat = getBat()
        if bat then enlargeBat(bat, false) end
    end
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

print("[StealEggHub v7] GUI com scroll + resize")
notify("v7: arraste ⤡ no canto p/ redimensionar")
