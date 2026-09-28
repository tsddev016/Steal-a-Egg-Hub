-- [[ STEAL A EGG HUB v14 ]] --
-- Anti-Taco SEM flutuar | TP curto | Anti-AFK

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

-- ==================== ANTI-AFK ====================
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

-- ==================== HUB ====================
local ok, err = pcall(function()
    local src = game:HttpGet("https://raw.githubusercontent.com/tsddev016/Steal-a-Egg-Hub/2e502fb766cab88e6f7d16d8201f7302b88a5624/StealEggHub.lua")

    -- TP curto e rapido
    src = src:gsub("HopStuds = 40", "HopStuds = 5")
    src = src:gsub("HopDelay = 0%.08", "HopDelay = 0.015")
    src = src:gsub("math%.min%(math%.max%(1, math%.ceil%(dist / step%)%), 60%)", "math.min(math.max(1, math.ceil(dist / step)), 250)")

    -- Anti-Taco: NAO encolher root / NAO desligar CanCollide (isso deixava no ar)
    src = src:gsub(
        "root%.Size = Vector3%.new%(0%.4, 0%.4, 0%.4%)", 
        "-- root size keep"
    )
    src = src:gsub(
        "root%.Transparency = 1", 
        "-- no transparency"
    )
    src = src:gsub(
        "root%.CanCollide = false", 
        "root.CanCollide = true -- manter no chao"
    )
    -- nao desligar colisao do corpo inteiro
    src = src:gsub(
        "p%.CanCollide = not %(small or Config%.Noclip%)", 
        "if not Config.Noclip then p.CanCollide = true end -- anti-taco nao tira colisao"
    )
    src = src:gsub(
        "p%.CanCollide = not %(small or Config%.Noclip%)", 
        "if not Config.Noclip then p.CanCollide = true end"
    )

    local fn, compileErr = loadstring(src)
    if not fn then error(compileErr or "loadstring falhou") end
    fn()
end)

if not ok then
    warn("[StealEggHub] Erro hub:", err)
else
    print("[StealEggHub v14] carregado")
end

-- ==================== ANTI-TACO SEGURO (extra) ====================
-- So tira ragdoll / knockback absurdo. Nao mexe em colisao.
local antiOn = false

local function getChar() return LP.Character end
local function getHum(c) return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot(c) return c and c:FindFirstChild("HumanoidRootPart") end

RunService.Heartbeat:Connect(function()
    if not antiOn then return end
    local char = getChar()
    local hum = getHum(char)
    local root = getRoot(char)
    if not hum or not root then return end

    -- nunca ficar PlatformStand / ragdoll
    if hum.PlatformStand then hum.PlatformStand = false end
    if hum.Sit then hum.Sit = false end

    local st = hum:GetState()
    if st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown
        or st == Enum.HumanoidStateType.Physics then
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end

    -- so corta knockback absurdo do taco (nao trava movimento normal)
    local v = root.AssemblyLinearVelocity
    if v.Magnitude > 150 then
        root.AssemblyLinearVelocity = Vector3.new(v.X * 0.3, math.min(v.Y, 40), v.Z * 0.3)
    end

    -- garante pe no chao (colisao do root)
    if not root.CanCollide then
        root.CanCollide = true
    end
end)

-- tenta ligar junto quando o botao AntiTaco da GUI e clicado
task.spawn(function()
    task.wait(2)
    local sg = game:GetService("CoreGui"):FindFirstChild("StealEggHub")
    if not sg then return end
    for _, b in pairs(sg:GetDescendants()) do
        if b:IsA("TextButton") and (b.Text == "AntiTaco" or b.Text:find("AntiTaco")) then
            b.MouseButton1Click:Connect(function()
                task.wait(0.05)
                -- alterna nosso anti seguro
                antiOn = not antiOn
                local hum = getHum(getChar())
                if hum then
                    pcall(function()
                        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not antiOn)
                        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, not antiOn)
                        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, not antiOn)
                    end)
                end
                -- desfaz qualquer hitbox quebrada
                local char = getChar()
                if char then
                    local root = getRoot(char)
                    if root then
                        root.CanCollide = true
                        root.Transparency = 1 -- root normal invisivel
                    end
                    for _, p in pairs(char:GetDescendants()) do
                        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                            -- nao forcar false
                        end
                    end
                end
                print("[Anti-Taco seguro]", antiOn and "ON" or "OFF")
            end)
            break
        end
    end
end)

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Steal Egg Hub v14",
        Text = "Anti-Taco corrigido (sem flutuar)",
        Duration = 4
    })
end)
