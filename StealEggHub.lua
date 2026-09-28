-- [[ STEAL A EGG HUB v15 ]] --
-- Ir ao ovo = clique | Auto-voltar base = ON/OFF | TP rapido | Anti-AFK

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

-- Carrega hub + patches
local ok, err = pcall(function()
    local src = game:HttpGet("https://raw.githubusercontent.com/tsddev016/Steal-a-Egg-Hub/2e502fb766cab88e6f7d16d8201f7302b88a5624/StealEggHub.lua")

    -- TP: saltos curtos e MAIS RAPIDOS
    src = src:gsub("HopStuds = 40", "HopStuds = 5")
    src = src:gsub("HopDelay = 0%.08", "HopDelay = 0.008") -- bem mais rapido
    src = src:gsub(
        "math%.min%(math%.max%(1, math%.ceil%(dist / step%)%), 60%)",
        "math.min(math.max(1, math.ceil(dist / step)), 300)"
    )

    -- Anti-Taco sem flutuar
    src = src:gsub("root%.Size = Vector3%.new%(0%.4, 0%.4, 0%.4%)", "-- keep size")
    src = src:gsub("root%.Transparency = 1", "-- keep")
    src = src:gsub("root%.CanCollide = false", "root.CanCollide = true")
    src = src:gsub(
        "p%.CanCollide = not %(small or Config%.Noclip%)",
        "if not Config.Noclip then p.CanCollide = true end"
    )

    -- AutoReturn ja existe no hub (toggle "Auto-TP ao roubar")
    -- Garante que nasce OFF e o usuario liga
    src = src:gsub("AutoReturn = false", "AutoReturn = false")

    local fn, e = loadstring(src)
    if not fn then error(e or "loadstring") end
    fn()
end)

if not ok then
    warn("[StealEggHub] hub:", err)
else
    print("[StealEggHub v15] hub OK")
end

-- ==================== AUTO VOLTAR BASE (ON/OFF reforcado) ====================
local autoBack = false
local wasCarrying = false
local goingBack = false

local function getChar() return LP.Character end
local function getRoot(c) return c and c:FindFirstChild("HumanoidRootPart") end

local function nameHas(str, needle)
    return string.find(string.lower(str or ""), string.lower(needle or ""), 1, true) ~= nil
end

local function isCarryingEgg()
    local char = getChar()
    if not char then return false end
    if char:GetAttribute("Carrying") or char:GetAttribute("HasEgg") or char:GetAttribute("HoldingEgg") then
        return true
    end
    for _, c in pairs(char:GetChildren()) do
        if nameHas(c.Name, "egg") then return true end
        if c:IsA("Tool") and (nameHas(c.Name, "egg") or nameHas(c.Name, "steal")) then return true end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in pairs(bp:GetChildren()) do
            if nameHas(t.Name, "egg") then return true end
        end
    end
    -- alguns jogos usam ObjectValue / model no character
    for _, c in pairs(char:GetDescendants()) do
        if c:IsA("Model") and nameHas(c.Name, "egg") then return true end
        if c:IsA("StringValue") and nameHas(c.Value, "egg") then return true end
    end
    return false
end

-- procura o botao "Voltar Base" e "Auto-TP" na GUI e reforca comportamento
task.spawn(function()
    task.wait(2.5)
    local sg = game:GetService("CoreGui"):FindFirstChild("StealEggHub")
    if not sg then return end

    for _, b in pairs(sg:GetDescendants()) do
        if b:IsA("TextButton") then
            local t = b.Text or ""
            -- Auto-TP ao roubar (ja e toggle ON/OFF no hub)
            if t:find("Auto") or t:find("ao roubar") then
                -- deixa como esta
            end
            -- se clicar em Voltar Base com nosso autoBack, so volta uma vez (manual ainda funciona)
        end
    end

    -- cria toggle extra claro na GUI se existir o Main
    local main = sg:FindFirstChild("Main") or sg:FindFirstChildWhichIsA("Frame")
    if main then
        local scroll = main:FindFirstChildWhichIsA("ScrollingFrame", true)
        local parent = scroll or main

        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -12, 0, 44)
        f.BackgroundColor3 = Color3.fromRGB(30, 50, 30)
        f.BorderSizePixel = 0
        f.LayoutOrder = 0
        f.Parent = parent
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
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Steal Egg Hub",
                    Text = autoBack and "Auto voltar BASE: ON (quando pegar ovo)" or "Auto voltar BASE: OFF",
                    Duration = 3
                })
            end)
        end)
    end
end)

-- quando detectar ovo e autoBack ON -> clica o botao Voltar Base da GUI (ou avisa)
RunService.Heartbeat:Connect(function()
    if not autoBack then
        wasCarrying = isCarryingEgg()
        return
    end
    local carrying = isCarryingEgg()
    if carrying and not wasCarrying and not goingBack then
        goingBack = true
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Ovo pego!",
                Text = "Voltando pra base...",
                Duration = 3
            })
        end)
        -- dispara o botao "Voltar Base" da GUI
        task.spawn(function()
            local sg = game:GetService("CoreGui"):FindFirstChild("StealEggHub")
            if sg then
                for _, b in pairs(sg:GetDescendants()) do
                    if b:IsA("TextButton") then
                        local t = string.lower(b.Text or "")
                        if t:find("voltar") or t:find("base") then
                            if t:find("voltar") or t:find("tp base") or t:find("base (salt") then
                                pcall(function() b:Activate() end)
                                -- fallback click
                                pcall(function()
                                    firesignal(b.MouseButton1Click)
                                end)
                                break
                            end
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
        Title = "Steal Egg Hub v15",
        Text = "Ir ovo = clique | Auto base = ON/OFF | TP mais rapido",
        Duration = 5
    })
end)
