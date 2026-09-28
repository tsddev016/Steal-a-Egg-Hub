-- [[ STEAL A EGG HUB v16 ]] --
-- SEM Anti-Taco | TP curto | Anti-AFK | Auto voltar base

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

-- Anti-AFK
LP.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)
task.spawn(function()
    while true do
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        task.wait(60)
    end
end)
print("[StealEggHub] Anti-AFK ON")

local ok, err = pcall(function()
    local src = game:HttpGet("https://raw.githubusercontent.com/tsddev016/Steal-a-Egg-Hub/2e502fb766cab88e6f7d16d8201f7302b88a5624/StealEggHub.lua")

    -- TP curto e rapido
    src = src:gsub("HopStuds = 40", "HopStuds = 5")
    src = src:gsub("HopDelay = 0%.08", "HopDelay = 0.008")
    src = src:gsub(
        "math%.min%(math%.max%(1, math%.ceil%(dist / step%)%), 60%)",
        "math.min(math.max(1, math.ceil(dist / step)), 300)"
    )

    -- ========== REMOVE ANTI-TACO ========== --
    -- desliga flag
    src = src:gsub("AntiTaco = false", "AntiTaco = false -- DESATIVADO")
    -- aplica hitbox nao faz nada
    src = src:gsub("root%.Size = Vector3%.new%(0%.4, 0%.4, 0%.4%)", "return -- anti-taco removido")
    src = src:gsub("root%.Transparency = 1", "-- removed")
    src = src:gsub("root%.CanCollide = false", "-- removed")
    -- enableAnti vira so anti-ragdoll leve (sem hitbox/colisao)
    src = src:gsub(
        "applyHitbox%(char, true%)",
        "-- applyHitbox removido"
    )
    src = src:gsub(
        "applyHitbox%(getChar%(%), true%)",
        "-- applyHitbox removido"
    )
    src = src:gsub(
        "applyHitbox%(char, false%)",
        "-- applyHitbox removido"
    )
    src = src:gsub(
        "applyHitbox%(getChar%(%), false%)",
        "-- applyHitbox removido"
    )

    local fn, e = loadstring(src)
    if not fn then error(e or "loadstring") end
    fn()
end)

if not ok then
    warn("[StealEggHub]", err)
else
    print("[StealEggHub v16] SEM Anti-Taco")
end

-- Esconde/desativa botao AntiTaco na GUI
task.spawn(function()
    task.wait(2)
    local sg = game:GetService("CoreGui"):FindFirstChild("StealEggHub")
    if not sg then return end
    for _, b in pairs(sg:GetDescendants()) do
        if b:IsA("TextButton") then
            local t = string.lower(b.Text or "")
            if t:find("antitaco") or t:find("anti taco") or t:find("anti%-taco") then
                b.Visible = false
                b.Active = false
                b.Text = "(removido)"
            end
        end
    end
end)

-- Anti-ragdoll LEVE (sem mexer em colisao / tamanho)
local antiRagdoll = true
RunService.Heartbeat:Connect(function()
    if not antiRagdoll then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if hum.PlatformStand then hum.PlatformStand = false end
    local st = hum:GetState()
    if st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown then
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end)

-- Auto voltar base ON/OFF
local autoBack = false
local wasCarrying = false
local goingBack = false

local function nameHas(str, needle)
    return string.find(string.lower(str or ""), string.lower(needle or ""), 1, true) ~= nil
end

local function isCarryingEgg()
    local char = LP.Character
    if not char then return false end
    if char:GetAttribute("Carrying") or char:GetAttribute("HasEgg") or char:GetAttribute("HoldingEgg") then
        return true
    end
    for _, c in pairs(char:GetChildren()) do
        if nameHas(c.Name, "egg") then return true end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in pairs(bp:GetChildren()) do
            if nameHas(t.Name, "egg") then return true end
        end
    end
    return false
end

task.spawn(function()
    task.wait(2.5)
    local sg = game:GetService("CoreGui"):FindFirstChild("StealEggHub")
    if not sg then return end
    local main = sg:FindFirstChildWhichIsA("Frame")
    if not main then return end
    local scroll = main:FindFirstChildWhichIsA("ScrollingFrame", true) or main

    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -12, 0, 44)
    f.BackgroundColor3 = Color3.fromRGB(30, 50, 30)
    f.BorderSizePixel = 0
    f.Parent = scroll
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

    local lab = Instance.new("TextLabel", f)
    lab.Size = UDim2.new(0.7, 0, 1, 0)
    lab.Position = UDim2.new(0, 8, 0, 0)
    lab.BackgroundTransparency = 1
    lab.Text = "AUTO VOLTAR BASE (com ovo)"
    lab.Font = Enum.Font.GothamBold
    lab.TextSize = 11
    lab.TextColor3 = Color3.fromRGB(180, 255, 180)
    lab.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0, 60, 0, 24)
    btn.Position = UDim2.new(1, -70, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = "OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        autoBack = not autoBack
        btn.Text = autoBack and "ON" or "OFF"
        btn.TextColor3 = autoBack and Color3.fromRGB(100, 255, 120) or Color3.fromRGB(255, 100, 100)
    end)
end)

RunService.Heartbeat:Connect(function()
    if not autoBack then
        wasCarrying = isCarryingEgg()
        return
    end
    local carrying = isCarryingEgg()
    if carrying and not wasCarrying and not goingBack then
        goingBack = true
        task.spawn(function()
            local sg = game:GetService("CoreGui"):FindFirstChild("StealEggHub")
            if sg then
                for _, b in pairs(sg:GetDescendants()) do
                    if b:IsA("TextButton") then
                        local t = string.lower(b.Text or "")
                        if t:find("voltar") and t:find("base") then
                            pcall(function() firesignal(b.MouseButton1Click) end)
                            break
                        end
                    end
                end
            end
            task.wait(8)
            goingBack = false
        end)
    end
    wasCarrying = carrying
end)

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Steal Egg Hub v16",
        Text = "Anti-Taco REMOVIDO | so anti-ragdoll leve",
        Duration = 4
    })
end)
