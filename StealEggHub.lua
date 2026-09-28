-- [[ STEAL A EGG HUB v21 ]] --
-- Fix: executa sem erro | Auto Farm | sem Anti-AFK

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local Farm = {
    Enabled = false,
    Area = "Ocean",
    DelayGo = 0.8,
    DelayBack = 1.0,
    HopStuds = 12,
    HopDelay = 0.02,
    OnlyRare = false,
    Speed = false,
    SpeedVal = 50,
}

local RareWords = {"mythic", "mitico", "secret", "secreto", "divine", "legendary", "eternal"}

local function notify(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Egg Hub v21",
            Text = tostring(msg),
            Duration = 3,
        })
    end)
end

local function getChar()
    return LP.Character
end

local function getRoot()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function getHum()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function nameHas(s, n)
    return string.find(string.lower(tostring(s or "")), string.lower(tostring(n or "")), 1, true) ~= nil
end

-- GUI parent seguro
local guiParent = LP:FindFirstChild("PlayerGui")
if not guiParent then
    pcall(function()
        guiParent = LP:WaitForChild("PlayerGui", 3)
    end)
end
if not guiParent then
    guiParent = game:GetService("CoreGui")
end

-- limpa GUI antiga
pcall(function()
    local old = guiParent:FindFirstChild("EggAutoFarm")
    if old then old:Destroy() end
    local old2 = game:GetService("CoreGui"):FindFirstChild("EggAutoFarm")
    if old2 then old2:Destroy() end
end)

local SG = Instance.new("ScreenGui")
SG.Name = "EggAutoFarm"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = guiParent

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 290, 0, 380)
Main.Position = UDim2.new(0, 24, 0.35, 0)
Main.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = SG
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 1
Stroke.Color = Color3.fromRGB(60, 60, 60)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -50, 0, 34)
Title.Position = UDim2.new(0, 12, 0, 4)
Title.BackgroundTransparency = 1
Title.Text = "STEAL EGG - Auto Farm v21"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextXAlignment = Enum.TextXAlignment.Left

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 28, 0, 28)
Close.Position = UDim2.new(1, -34, 0, 6)
Close.BackgroundColor3 = Color3.fromRGB(45, 30, 30)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 12
Close.TextColor3 = Color3.fromRGB(255, 100, 100)
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)
Close.MouseButton1Click:Connect(function()
    Farm.Enabled = false
    SG:Destroy()
end)

-- drag
do
    local dragging, dragStart, startPos
    Title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
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

local function makeLabel(y, text)
    local l = Instance.new("TextLabel", Main)
    l.Size = UDim2.new(1, -24, 0, 16)
    l.Position = UDim2.new(0, 12, 0, y)
    l.BackgroundTransparency = 1
    l.Text = text
    l.Font = Enum.Font.Gotham
    l.TextSize = 11
    l.TextColor3 = Color3.fromRGB(170, 170, 170)
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

local function makeBox(y, val)
    local t = Instance.new("TextBox", Main)
    t.Size = UDim2.new(1, -24, 0, 28)
    t.Position = UDim2.new(0, 12, 0, y)
    t.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    t.Text = tostring(val)
    t.Font = Enum.Font.Gotham
    t.TextSize = 13
    t.TextColor3 = Color3.new(1, 1, 1)
    t.ClearTextOnFocus = false
    Instance.new("UICorner", t).CornerRadius = UDim.new(0, 6)
    return t
end

local function makeBtn(y, text, color)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -24, 0, 30)
    b.Position = UDim2.new(0, 12, 0, y)
    b.BackgroundColor3 = color or Color3.fromRGB(40, 40, 50)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

makeLabel(40, "Area (Ocean, Forest, Angels...)")
local AreaBox = makeBox(56, Farm.Area)

makeLabel(90, "Delay no ovo (s)")
local DelayGoBox = makeBox(106, Farm.DelayGo)

makeLabel(140, "Delay na base (s)")
local DelayBackBox = makeBox(156, Farm.DelayBack)

makeLabel(190, "Velocidade WalkSpeed")
local SpeedBox = makeBox(206, Farm.SpeedVal)

local SpeedBtn = makeBtn(242, "Speed: OFF", Color3.fromRGB(40, 40, 40))
SpeedBtn.TextColor3 = Color3.fromRGB(255, 100, 100)

local RareBtn = makeBtn(278, "So Mythic/Secret: OFF", Color3.fromRGB(40, 40, 40))
RareBtn.TextColor3 = Color3.fromRGB(255, 100, 100)

local FarmBtn = makeBtn(314, "AUTO FARM: OFF", Color3.fromRGB(35, 55, 35))
FarmBtn.TextColor3 = Color3.fromRGB(255, 100, 100)

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, -24, 0, 24)
Status.Position = UDim2.new(0, 12, 0, 350)
Status.BackgroundTransparency = 1
Status.Text = "Pronto - fique na base e ligue o farm"
Status.Font = Enum.Font.Gotham
Status.TextSize = 11
Status.TextColor3 = Color3.fromRGB(130, 130, 130)
Status.TextWrapped = true

local function setStatus(t)
    Status.Text = tostring(t)
end

AreaBox.FocusLost:Connect(function()
    if AreaBox.Text ~= "" then
        Farm.Area = AreaBox.Text
        setStatus("Area: " .. Farm.Area)
    end
end)

DelayGoBox.FocusLost:Connect(function()
    local v = tonumber(DelayGoBox.Text)
    if v and v >= 0 then
        Farm.DelayGo = v
    else
        DelayGoBox.Text = tostring(Farm.DelayGo)
    end
end)

DelayBackBox.FocusLost:Connect(function()
    local v = tonumber(DelayBackBox.Text)
    if v and v >= 0 then
        Farm.DelayBack = v
    else
        DelayBackBox.Text = tostring(Farm.DelayBack)
    end
end)

SpeedBox.FocusLost:Connect(function()
    local v = tonumber(SpeedBox.Text)
    if v and v > 0 then
        Farm.SpeedVal = v
    else
        SpeedBox.Text = tostring(Farm.SpeedVal)
    end
end)

local speedConn = nil
SpeedBtn.MouseButton1Click:Connect(function()
    Farm.Speed = not Farm.Speed
    if Farm.Speed then
        SpeedBtn.Text = "Speed: ON"
        SpeedBtn.TextColor3 = Color3.fromRGB(100, 255, 120)
        if speedConn then speedConn:Disconnect() end
        speedConn = RunService.Heartbeat:Connect(function()
            local h = getHum()
            if h then
                h.WalkSpeed = Farm.SpeedVal
            end
        end)
    else
        SpeedBtn.Text = "Speed: OFF"
        SpeedBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        if speedConn then
            speedConn:Disconnect()
            speedConn = nil
        end
        local h = getHum()
        if h then
            h.WalkSpeed = 16
        end
    end
end)

RareBtn.MouseButton1Click:Connect(function()
    Farm.OnlyRare = not Farm.OnlyRare
    if Farm.OnlyRare then
        RareBtn.Text = "So Mythic/Secret: ON"
        RareBtn.TextColor3 = Color3.fromRGB(100, 255, 120)
    else
        RareBtn.Text = "So Mythic/Secret: OFF"
        RareBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- farm logic
local savedBase = nil
local hopping = false

local function isRare(obj)
    local blob = string.lower(tostring(obj.Name) .. " " .. tostring((pcall(function() return obj:GetFullName() end) and obj:GetFullName()) or ""))
    for i = 1, #RareWords do
        if string.find(blob, RareWords[i], 1, true) then
            return true
        end
    end
    local attrs = {"Rarity", "EggRarity", "Tier"}
    for i = 1, #attrs do
        local v = obj:GetAttribute(attrs[i])
        if v then
            local sv = string.lower(tostring(v))
            for j = 1, #RareWords do
                if string.find(sv, RareWords[j], 1, true) then
                    return true
                end
            end
        end
    end
    return false
end

local function hopTo(pos)
    local root = getRoot()
    if not root or not pos then
        return false
    end
    hopping = true
    local start = root.Position
    local dist = (pos - start).Magnitude
    local steps = math.ceil(dist / Farm.HopStuds)
    if steps < 1 then steps = 1 end
    if steps > 100 then steps = 100 end
    for i = 1, steps do
        root = getRoot()
        if not root then
            hopping = false
            return false
        end
        local alpha = i / steps
        local p = start:Lerp(pos, alpha)
        root.CFrame = CFrame.new(p + Vector3.new(0, 1, 0))
        root.AssemblyLinearVelocity = Vector3.zero
        task.wait(Farm.HopDelay)
    end
    root = getRoot()
    if root then
        root.CFrame = CFrame.new(pos)
        root.AssemblyLinearVelocity = Vector3.zero
    end
    hopping = false
    return true
end

local function findEgg()
    local root = getRoot()
    local best = nil
    local bestScore = math.huge
    local descendants = workspace:GetDescendants()
    for i = 1, #descendants do
        local obj = descendants[i]
        if nameHas(obj.Name, "egg") then
            local rareOk = true
            if Farm.OnlyRare then
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
                    local fullName = ""
                    pcall(function()
                        fullName = obj:GetFullName()
                    end)
                    local inArea = nameHas(fullName, Farm.Area) or nameHas(obj.Name, Farm.Area)
                    local d = 0
                    if root then
                        d = (root.Position - part.Position).Magnitude
                    end
                    local score = d
                    if not inArea then
                        score = d + 5000
                    end
                    if score < bestScore then
                        bestScore = score
                        best = { pos = part.Position, obj = obj }
                    end
                end
            end
        end
    end
    return best
end

local function tryPrompt(obj)
    if not obj then return end
    local ok, desc = pcall(function()
        return obj:GetDescendants()
    end)
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

local function farmLoop()
    while Farm.Enabled do
        if not savedBase then
            local r = getRoot()
            if r then
                savedBase = r.Position
            end
        end

        setStatus("Buscando ovo: " .. Farm.Area)
        local egg = findEgg()
        if egg then
            setStatus("Indo ao ovo...")
            hopTo(egg.pos + Vector3.new(0, 3, 0))
            tryPrompt(egg.obj)
            setStatus("Esperando no ovo")
            task.wait(Farm.DelayGo)
            if savedBase then
                setStatus("Voltando base...")
                hopTo(savedBase)
                setStatus("Ciclo OK - base")
                task.wait(Farm.DelayBack)
            end
        else
            setStatus("Sem ovo - tentando de novo")
            task.wait(2)
        end
        task.wait(0.15)
    end
    setStatus("Auto Farm OFF")
end

FarmBtn.MouseButton1Click:Connect(function()
    Farm.Enabled = not Farm.Enabled
    if AreaBox.Text ~= "" then
        Farm.Area = AreaBox.Text
    end
    if Farm.Enabled then
        FarmBtn.Text = "AUTO FARM: ON"
        FarmBtn.TextColor3 = Color3.fromRGB(100, 255, 120)
        local r = getRoot()
        if r then
            savedBase = r.Position
        end
        setStatus("Farm ON - " .. Farm.Area)
        task.spawn(farmLoop)
    else
        FarmBtn.Text = "AUTO FARM: OFF"
        FarmBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        setStatus("Farm OFF")
    end
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
    end
end)

task.defer(function()
    task.wait(0.3)
    local r = getRoot()
    if r then
        savedBase = r.Position
        setStatus("Base salva - ligue o Auto Farm")
    end
    notify("v21 OK - script executou")
end)

print("[StealEggHub v21] executou com sucesso")
