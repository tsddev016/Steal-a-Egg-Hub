-- [[ STEAL A EGG HUB v20 ]] --
-- Auto Farm configuravel | SEM Anti-AFK | SEM Anti-Taco

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

-- ==================== CONFIG AUTO FARM ====================
local Farm = {
    Enabled = false,
    Area = "Ocean",          -- area alvo
    DelayGo = 0.8,           -- espera depois de chegar no ovo
    DelayBack = 1.0,         -- espera depois de voltar na base
    HopStuds = 12,
    HopDelay = 0.02,
    OnlyRare = false,        -- true = so mythic/secret
}

local Areas = {
    "Forest", "Lake", "Desert", "Jungle", "Snow", "Volcano",
    "Ocean", "Prehistoric", "Cosmic", "Cherry", "Titan", "Monkey", "Angels",
}

local RareWords = {"mythic", "mitico", "secret", "secreto", "divine", "legendary", "eternal"}

-- carrega hub base (UI antiga) em paralelo, opcional
pcall(function()
    local src = game:HttpGet("https://raw.githubusercontent.com/tsddev016/Steal-a-Egg-Hub/2e502fb766cab88e6f7d16d8201f7302b88a5624/StealEggHub.lua")
    src = src:gsub("HopStuds = 40", "HopStuds = 12")
    src = src:gsub("HopDelay = 0%.08", "HopDelay = 0.02")
    src = src:gsub("root%.Size = Vector3%.new%(0%.4, 0%.4, 0%.4%)", "return")
    src = src:gsub("applyHitbox%(char, true%)", "-- no")
    src = src:gsub("applyHitbox%(getChar%(%), true%)", "-- no")
    local fn = loadstring(src)
    if fn then fn() end
end)

-- ==================== GUI AUTO FARM ====================
local SG = Instance.new("ScreenGui")
SG.Name = "EggAutoFarm"
SG.ResetOnSpawn = false
SG.Parent = (LP:FindFirstChild("PlayerGui") or game:GetService("CoreGui"))

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 280, 0, 320)
Main.Position = UDim2.new(0, 20, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Main.BorderSizePixel = 0
Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -16, 0, 32)
Title.Position = UDim2.new(0, 10, 0, 4)
Title.BackgroundTransparency = 1
Title.Text = "AUTO FARM - Config"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextXAlignment = Enum.TextXAlignment.Left

local function label(y, text)
    local l = Instance.new("TextLabel", Main)
    l.Size = UDim2.new(1, -20, 0, 18)
    l.Position = UDim2.new(0, 10, 0, y)
    l.BackgroundTransparency = 1
    l.Text = text
    l.Font = Enum.Font.Gotham
    l.TextSize = 12
    l.TextColor3 = Color3.fromRGB(180, 180, 180)
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

local function box(y, val)
    local t = Instance.new("TextBox", Main)
    t.Size = UDim2.new(1, -20, 0, 28)
    t.Position = UDim2.new(0, 10, 0, y)
    t.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    t.Text = tostring(val)
    t.Font = Enum.Font.Gotham
    t.TextSize = 13
    t.TextColor3 = Color3.new(1, 1, 1)
    t.ClearTextOnFocus = false
    Instance.new("UICorner", t).CornerRadius = UDim.new(0, 6)
    return t
end

label(40, "Area (Forest, Ocean, Angels...)")
local AreaBox = box(58, Farm.Area)

label(92, "Delay no ovo (segundos)")
local DelayGoBox = box(110, Farm.DelayGo)

label(144, "Delay na base (segundos)")
local DelayBackBox = box(162, Farm.DelayBack)

local OnlyRareBtn = Instance.new("TextButton", Main)
OnlyRareBtn.Size = UDim2.new(1, -20, 0, 28)
OnlyRareBtn.Position = UDim2.new(0, 10, 0, 198)
OnlyRareBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
OnlyRareBtn.Text = "So Mythic/Secret: OFF"
OnlyRareBtn.Font = Enum.Font.GothamBold
OnlyRareBtn.TextSize = 12
OnlyRareBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
Instance.new("UICorner", OnlyRareBtn).CornerRadius = UDim.new(0, 6)

local FarmBtn = Instance.new("TextButton", Main)
FarmBtn.Size = UDim2.new(1, -20, 0, 36)
FarmBtn.Position = UDim2.new(0, 10, 0, 236)
FarmBtn.BackgroundColor3 = Color3.fromRGB(40, 70, 40)
FarmBtn.Text = "AUTO FARM: OFF"
FarmBtn.Font = Enum.Font.GothamBold
FarmBtn.TextSize = 14
FarmBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
Instance.new("UICorner", FarmBtn).CornerRadius = UDim.new(0, 6)

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, -20, 0, 28)
Status.Position = UDim2.new(0, 10, 0, 280)
Status.BackgroundTransparency = 1
Status.Text = "Salve a base andando nela e ligue o farm"
Status.Font = Enum.Font.Gotham
Status.TextSize = 11
Status.TextColor3 = Color3.fromRGB(140, 140, 140)
Status.TextWrapped = true

local function setStatus(t)
    Status.Text = tostring(t)
end

AreaBox.FocusLost:Connect(function()
    if AreaBox.Text ~= "" then Farm.Area = AreaBox.Text end
end)
DelayGoBox.FocusLost:Connect(function()
    local v = tonumber(DelayGoBox.Text)
    if v and v >= 0 then Farm.DelayGo = v else DelayGoBox.Text = tostring(Farm.DelayGo) end
end)
DelayBackBox.FocusLost:Connect(function()
    local v = tonumber(DelayBackBox.Text)
    if v and v >= 0 then Farm.DelayBack = v else DelayBackBox.Text = tostring(Farm.DelayBack) end
end)

OnlyRareBtn.MouseButton1Click:Connect(function()
    Farm.OnlyRare = not Farm.OnlyRare
    OnlyRareBtn.Text = Farm.OnlyRare and "So Mythic/Secret: ON" or "So Mythic/Secret: OFF"
    OnlyRareBtn.TextColor3 = Farm.OnlyRare and Color3.fromRGB(100, 255, 120) or Color3.fromRGB(255, 100, 100)
end)

-- ==================== FARM LOGIC ====================
local savedBase = nil
local hopping = false

local function getRoot()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function nameHas(s, n)
    return string.find(string.lower(s or ""), string.lower(n or ""), 1, true) ~= nil
end

local function isRare(obj)
    local blob = string.lower(obj.Name .. " " .. (obj:GetFullName() or ""))
    for _, w in ipairs(RareWords) do
        if blob:find(w, 1, true) then return true end
    end
    for _, a in ipairs({"Rarity", "EggRarity", "Tier"}) do
        local v = obj:GetAttribute(a)
        if v then
            for _, w in ipairs(RareWords) do
                if string.lower(tostring(v)):find(w, 1, true) then return true end
            end
        end
    end
    return false
end

local function hopTo(pos)
    local root = getRoot()
    if not root or not pos then return false end
    hopping = true
    local start = root.Position
    local dist = (pos - start).Magnitude
    local steps = math.min(math.max(1, math.ceil(dist / Farm.HopStuds)), 100)
    for i = 1, steps do
        if not Farm.Enabled and steps > 1 then break end
        root = getRoot()
        if not root then hopping = false return false end
        root.CFrame = CFrame.new(start:Lerp(pos, i / steps) + Vector3.new(0, 1, 0))
        root.AssemblyLinearVelocity = Vector3.zero
        task.wait(Farm.HopDelay)
    end
    root = getRoot()
    if root then root.CFrame = CFrame.new(pos) end
    hopping = false
    return true
end

local function findEgg()
    local root = getRoot()
    local best, bestD = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if nameHas(obj.Name, "egg") then
            if Farm.OnlyRare and not isRare(obj) then continue end
            local part = obj:IsA("BasePart") and obj
                or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
            if part then
                local pathOk = nameHas(obj:GetFullName(), Farm.Area)
                -- se nao achar na area, ainda considera (fallback)
                local d = root and (root.Position - part.Position).Magnitude or 0
                local score = pathOk and d or (d + 5000)
                if score < bestD then
                    bestD = score
                    best = {pos = part.Position, obj = obj, part = part}
                end
            end
        end
    end
    return best
end

local function tryPrompt(obj)
    if not obj then return end
    for _, d in pairs(obj:GetDescendants()) do
        if d:IsA("ProximityPrompt") then
            pcall(function() fireproximityprompt(d) end)
        end
    end
end

-- salva base no start
task.defer(function()
    task.wait(1)
    local r = getRoot()
    if r then savedBase = r.Position setStatus("Base salva (posicao atual)") end
end)

local function farmLoop()
    while Farm.Enabled do
        if not savedBase then
            local r = getRoot()
            if r then savedBase = r.Position end
        end

        setStatus("Buscando ovo em " .. Farm.Area .. "...")
        local egg = findEgg()
        if egg then
            setStatus("Indo ao ovo...")
            hopTo(egg.pos + Vector3.new(0, 3, 0))
            tryPrompt(egg.obj)
            setStatus("No ovo - esperando")
            task.wait(Farm.DelayGo)

            if savedBase then
                setStatus("Voltando base...")
                hopTo(savedBase)
                setStatus("Na base - ciclo OK")
                task.wait(Farm.DelayBack)
            end
        else
            setStatus("Nenhum ovo - retry")
            task.wait(2)
        end
        task.wait(0.2)
    end
    setStatus("Auto Farm OFF")
end

FarmBtn.MouseButton1Click:Connect(function()
    Farm.Enabled = not Farm.Enabled
    Farm.Area = AreaBox.Text ~= "" and AreaBox.Text or Farm.Area
    FarmBtn.Text = Farm.Enabled and "AUTO FARM: ON" or "AUTO FARM: OFF"
    FarmBtn.TextColor3 = Farm.Enabled and Color3.fromRGB(100, 255, 120) or Color3.fromRGB(255, 100, 100)
    if Farm.Enabled then
        local r = getRoot()
        if r and not savedBase then savedBase = r.Position end
        setStatus("Farm ligado - " .. Farm.Area)
        task.spawn(farmLoop)
    else
        setStatus("Farm desligado")
    end
end)

-- arrastar painel
do
    local drag, start, pos
    Title.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            start = i.Position
            pos = Main.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then drag = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - start
            Main.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y)
        end
    end)
end

UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
    end
end)

print("[EggHub v20] Auto Farm config pronta")
setStatus("Configure area/delays e ligue o farm")
