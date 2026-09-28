-- [[ STEAL A EGG HUB v18 LITE ]] --
-- Sem Anti-AFK spam, sem anti-ragdoll Heartbeat, sem scan no load
-- TP so quando voce clicar | GUI tenta PlayerGui primeiro

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local Config = {
    Speed = false, SpeedVal = 50,
    Noclip = false,
    SelectedArea = "Ocean",
    HopStuds = 12,
    HopDelay = 0.02,
    AutoBack = false,
}

local AreaList = {
    "Forest", "Lake", "Desert", "Jungle", "Snow", "Volcano",
    "Ocean", "Prehistoric", "Cosmic", "Cherry", "Titan", "Monkey", "Angels",
}

local function getChar() return LP.Character end
local function getHum(c) return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot(c) return c and c:FindFirstChild("HumanoidRootPart") end

local function notify(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Egg Hub v18",
            Text = tostring(msg),
            Duration = 3
        })
    end)
end

-- Parent da GUI: PlayerGui (menos "exploit") com fallback
local function getGuiParent()
    local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
    if pg then return pg end
    return game:GetService("CoreGui")
end

local SG = Instance.new("ScreenGui")
SG.Name = "StealEggHubLite"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() SG.Parent = getGuiParent() end)
if not SG.Parent then SG.Parent = game:GetService("CoreGui") end

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 300, 0, 360)
Main.Position = UDim2.new(0.5, -150, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = SG
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -40, 0, 36)
Title.Position = UDim2.new(0, 10, 0, 4)
Title.BackgroundTransparency = 1
Title.Text = "Egg Hub v18 LITE"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextXAlignment = Enum.TextXAlignment.Left

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 28, 0, 28)
Close.Position = UDim2.new(1, -34, 0, 6)
Close.BackgroundColor3 = Color3.fromRGB(40, 30, 30)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 100, 100)
Close.Font = Enum.Font.GothamBold
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)
Close.MouseButton1Click:Connect(function() SG:Destroy() end)

-- drag
do
    local dragging, start, pos
    Title.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            start = i.Position
            pos = Main.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - start
            Main.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y)
        end
    end)
end

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -16, 1, -50)
Scroll.Position = UDim2.new(0, 8, 0, 42)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
local lay = Instance.new("UIListLayout", Scroll)
lay.Padding = UDim.new(0, 8)
lay.SortOrder = Enum.SortOrder.LayoutOrder

local function section(text, h)
    local f = Instance.new("Frame", Scroll)
    f.Size = UDim2.new(1, -4, 0, h)
    f.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, -10, 0, 20)
    t.Position = UDim2.new(0, 8, 0, 4)
    t.BackgroundTransparency = 1
    t.Text = text
    t.Font = Enum.Font.GothamBold
    t.TextSize = 12
    t.TextColor3 = Color3.new(1, 1, 1)
    t.TextXAlignment = Enum.TextXAlignment.Left
    return f
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
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

local function toggle(parent, y)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0, 56, 0, 22)
    b.Position = UDim2.new(1, -66, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.Text = "OFF"
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.TextColor3 = Color3.fromRGB(255, 100, 100)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    return b
end

local function setOn(b, on)
    b.Text = on and "ON" or "OFF"
    b.TextColor3 = on and Color3.fromRGB(100, 255, 120) or Color3.fromRGB(255, 100, 100)
end

-- Speed (so aplica se ON, e so WalkSpeed - sem loop pesado desnecessario)
local S1 = section("Velocidade", 56)
local SpeedBtn = toggle(S1, 8)
local SpeedBox = Instance.new("TextBox", S1)
SpeedBox.Size = UDim2.new(0.55, 0, 0, 22)
SpeedBox.Position = UDim2.new(0, 8, 0, 28)
SpeedBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SpeedBox.Text = tostring(Config.SpeedVal)
SpeedBox.TextColor3 = Color3.new(1, 1, 1)
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.TextSize = 12
Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0, 5)

local speedConn
SpeedBtn.MouseButton1Click:Connect(function()
    Config.Speed = not Config.Speed
    setOn(SpeedBtn, Config.Speed)
    if speedConn then speedConn:Disconnect() speedConn = nil end
    if Config.Speed then
        speedConn = RunService.Heartbeat:Connect(function()
            local h = getHum(getChar())
            if h then h.WalkSpeed = Config.SpeedVal end
        end)
    else
        local h = getHum(getChar())
        if h then h.WalkSpeed = 16 end
    end
end)
SpeedBox.FocusLost:Connect(function()
    local v = tonumber(SpeedBox.Text)
    if v and v > 0 then Config.SpeedVal = v else SpeedBox.Text = tostring(Config.SpeedVal) end
end)

-- Areas
local S2 = section("Area", 28 + math.ceil(#AreaList / 3) * 28)
local areaLabel = Instance.new("TextLabel", S2)
areaLabel.Size = UDim2.new(1, -10, 0, 18)
areaLabel.Position = UDim2.new(0, 8, 0, 4)
areaLabel.BackgroundTransparency = 1
areaLabel.Text = "Area: " .. Config.SelectedArea
areaLabel.Font = Enum.Font.Gotham
areaLabel.TextSize = 11
areaLabel.TextColor3 = Color3.fromRGB(150, 220, 255)
areaLabel.TextXAlignment = Enum.TextXAlignment.Left

for i, name in ipairs(AreaList) do
    local row = math.floor((i - 1) / 3)
    local col = (i - 1) % 3
    local b = Instance.new("TextButton", S2)
    b.Size = UDim2.new(0, 88, 0, 24)
    b.Position = UDim2.new(0, 8 + col * 94, 0, 24 + row * 28)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    b.Text = name
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    b.MouseButton1Click:Connect(function()
        Config.SelectedArea = name
        areaLabel.Text = "Area: " .. name
    end)
end

-- TP
local S3 = section("TP (clique)", 130)
local GoEgg = btn(S3, "Ir ao Ovo", 28)
local GoBase = btn(S3, "Voltar Base (1x)", 60)
local SaveBase = btn(S3, "Salvar Base Aqui", 92)

local S4 = section("Auto voltar com ovo", 44)
local AutoBtn = toggle(S4, 12)
local AutoLab = Instance.new("TextLabel", S4)
AutoLab.Size = UDim2.new(0.65, 0, 0, 20)
AutoLab.Position = UDim2.new(0, 8, 0, 12)
AutoLab.BackgroundTransparency = 1
AutoLab.Text = "ON = volta ao pegar ovo"
AutoLab.Font = Enum.Font.Gotham
AutoLab.TextSize = 11
AutoLab.TextColor3 = Color3.fromRGB(200, 200, 200)
AutoLab.TextXAlignment = Enum.TextXAlignment.Left

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, -16, 0, 16)
Status.Position = UDim2.new(0, 8, 1, -18)
Status.BackgroundTransparency = 1
Status.Text = "Lite: sem AFK spam / sem scan no load"
Status.Font = Enum.Font.Gotham
Status.TextSize = 10
Status.TextColor3 = Color3.fromRGB(140, 140, 140)

-- Base + hop so sob demanda
local savedBase = nil
local hopping = false

local function captureBase()
    local r = getRoot(getChar())
    if r then savedBase = r.Position notify("Base salva") end
end

local function hopTo(target)
    if hopping then return end
    local root = getRoot(getChar())
    if not root or not target then return end
    hopping = true
    local start = root.Position
    local dist = (target - start).Magnitude
    if dist < 5 then
        root.CFrame = CFrame.new(target)
        hopping = false
        return
    end
    local step = Config.HopStuds
    local steps = math.min(math.max(1, math.ceil(dist / step)), 80)
    for i = 1, steps do
        root = getRoot(getChar())
        if not root then break end
        root.CFrame = CFrame.new(start:Lerp(target, i / steps) + Vector3.new(0, 1, 0))
        root.AssemblyLinearVelocity = Vector3.zero
        task.wait(Config.HopDelay)
    end
    root = getRoot(getChar())
    if root then root.CFrame = CFrame.new(target) end
    hopping = false
end

local function nameHas(a, b)
    return string.find(string.lower(a or ""), string.lower(b or ""), 1, true) ~= nil
end

-- Busca ovo SO quando clicar (nao no load)
local function findEgg()
    local root = getRoot(getChar())
    local best, bestD = nil, math.huge
    local area = Config.SelectedArea
    for _, obj in pairs(workspace:GetDescendants()) do
        if nameHas(obj.Name, "egg") then
            local part = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
            if part then
                local inArea = nameHas(obj:GetFullName(), area) or true
                if inArea then
                    local d = root and (root.Position - part.Position).Magnitude or 0
                    if d < bestD then bestD = d best = part.Position end
                end
            end
        end
    end
    return best
end

GoEgg.MouseButton1Click:Connect(function()
    if hopping then notify("Aguarde") return end
    task.spawn(function()
        Status.Text = "Buscando ovo..."
        local pos = findEgg()
        if not pos then notify("Ovo nao encontrado") Status.Text = "Sem ovo" return end
        Status.Text = "Indo ao ovo..."
        hopTo(pos + Vector3.new(0, 3, 0))
        Status.Text = "No ovo"
    end)
end)

GoBase.MouseButton1Click:Connect(function()
    if hopping then return end
    task.spawn(function()
        if not savedBase then captureBase() end
        if savedBase then
            Status.Text = "Voltando base..."
            hopTo(savedBase)
            Status.Text = "Na base"
        end
    end)
end)

SaveBase.MouseButton1Click:Connect(captureBase)

AutoBtn.MouseButton1Click:Connect(function()
    Config.AutoBack = not Config.AutoBack
    setOn(AutoBtn, Config.AutoBack)
end)

local function isCarrying()
    local char = getChar()
    if not char then return false end
    for _, c in pairs(char:GetChildren()) do
        if nameHas(c.Name, "egg") then return true end
    end
    return false
end

local wasCarry = false
-- checa ovo so a cada 1s (nao Heartbeat pesado)
task.spawn(function()
    while SG.Parent do
        if Config.AutoBack then
            local c = isCarrying()
            if c and not wasCarry and not hopping then
                notify("Ovo pego - voltando")
                if not savedBase then captureBase() end
                if savedBase then hopTo(savedBase) end
            end
            wasCarry = c
        end
        task.wait(1)
    end
end)

UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
    end
end)

task.defer(function()
    task.wait(0.5)
    captureBase()
    notify("v18 LITE - clique pra TP (nada agressivo no load)")
end)

print("[EggHub v18 LITE] ready")
