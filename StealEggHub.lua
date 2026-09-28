-- [[ STEAL A EGG HUB v12 ]] --
-- Anti-AFK + hub completo (v11)

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local LP = Players.LocalPlayer

-- Anti-AFK (ligado por padrao)
local AntiAFK = true

LP.Idled:Connect(function()
    if not AntiAFK then return end
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

task.spawn(function()
    while true do
        if AntiAFK then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
        task.wait(60)
    end
end)

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Steal Egg Hub",
        Text = "Anti-AFK ON",
        Duration = 3
    })
end)

print("[StealEggHub] Anti-AFK ativo")

-- Carrega o hub completo (features anteriores)
local ok, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/tsddev016/Steal-a-Egg-Hub/2e502fb766cab88e6f7d16d8201f7302b88a5624/StealEggHub.lua"))()
end)

if not ok then
    warn("[StealEggHub] Falha ao carregar hub:", err)
else
    print("[StealEggHub v12] Hub + Anti-AFK OK")
end
