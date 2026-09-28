-- [[ STEAL A EGG HUB v13 ]] --
-- TP curto (5 studs) + rapido + Anti-AFK

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
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

-- ==================== HUB + TP CURTO ====================
-- Carrega o hub e troca o tamanho/velocidade dos saltos
local ok, err = pcall(function()
    local src = game:HttpGet("https://raw.githubusercontent.com/tsddev016/Steal-a-Egg-Hub/2e502fb766cab88e6f7d16d8201f7302b88a5624/StealEggHub.lua")

    -- saltinhos bem curtos (~5 studs) e mais rapidos
    src = src:gsub("HopStuds = 40", "HopStuds = 5")
    src = src:gsub("HopDelay = 0%.08", "HopDelay = 0.015")
    -- permite mais passos (caminho longo com passos de 5)
    src = src:gsub(", 60%)", ", 250)")
    src = src:gsub("math%.min%(math%.max%(1, math%.ceil%(dist / step%)%), 60%)", "math.min(math.max(1, math.ceil(dist / step)), 250)")

    local fn, compileErr = loadstring(src)
    if not fn then
        error(compileErr or "loadstring falhou")
    end
    fn()
end)

if not ok then
    warn("[StealEggHub] Erro:", err)
else
    print("[StealEggHub v13] TP 5 studs / delay 0.015 + Anti-AFK")
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Steal Egg Hub v13",
            Text = "TP curto e rapido + Anti-AFK",
            Duration = 4
        })
    end)
end
