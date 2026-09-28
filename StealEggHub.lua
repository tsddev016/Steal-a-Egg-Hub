-- [[ STEAL A EGG HUB v22 ]] --
-- Hub completo (partes no repo)

local BASE = "https://raw.githubusercontent.com/tsddev016/Steal-a-Egg-Hub/main/"

local ok, err = pcall(function()
    local a = game:HttpGet(BASE .. "hub_part1.lua")
    local b = game:HttpGet(BASE .. "hub_part2.lua")
    local fn, e = loadstring(a .. b)
    if not fn then
        error(tostring(e))
    end
    fn()
end)

if not ok then
    warn("[StealEggHub v22] erro:", err)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Steal Egg Hub",
            Text = "Erro ao carregar: " .. tostring(err),
            Duration = 5,
        })
    end)
else
    print("[StealEggHub v22] hub completo OK")
end
