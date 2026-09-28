-- [[ STEAL A EGG HUB v19 ]] --
-- Features antigas de volta | SEM Anti-AFK | SEM Anti-Taco
-- TP leve 12 studs / 0.02s

local ok, err = pcall(function()
    local src = game:HttpGet("https://raw.githubusercontent.com/tsddev016/Steal-a-Egg-Hub/2e502fb766cab88e6f7d16d8201f7302b88a5624/StealEggHub.lua")

    -- version label
    src = src:gsub("v11", "v19")

    -- TP leve
    src = src:gsub("HopStuds = 40", "HopStuds = 12")
    src = src:gsub("HopDelay = 0%.08", "HopDelay = 0.02")
    src = src:gsub(
        "math%.min%(math%.max%(1, math%.ceil%(dist / step%)%), 60%)",
        "math.min(math.max(1, math.ceil(dist / step)), 120)"
    )

    -- Remove Anti-Taco (hitbox / colisao)
    src = src:gsub("root%.Size = Vector3%.new%(0%.4, 0%.4, 0%.4%)", "return")
    src = src:gsub("root%.CanCollide = false", "-- removed")
    src = src:gsub("applyHitbox%(char, true%)", "-- removed")
    src = src:gsub("applyHitbox%(getChar%(%), true%)", "-- removed")
    src = src:gsub("applyHitbox%(char, false%)", "-- removed")
    src = src:gsub("applyHitbox%(getChar%(%), false%)", "-- removed")

    local fn, e = loadstring(src)
    if not fn then error(e or "loadstring") end
    fn()
end)

if not ok then
    warn("[StealEggHub v19] erro:", err)
else
    print("[StealEggHub v19] features antigas | SEM Anti-AFK | SEM Anti-Taco")
end

-- Esconde botao AntiTaco na GUI
task.spawn(function()
    task.wait(2)
    local sg = game:GetService("CoreGui"):FindFirstChild("StealEggHub")
    if not sg then return end
    for _, b in pairs(sg:GetDescendants()) do
        if b:IsA("TextButton") then
            local t = string.lower(b.Text or "")
            if t:find("antitaco") or t:find("anti taco") then
                b.Visible = false
                b.Active = false
            end
        end
    end
end)

-- Auto voltar base ON/OFF (extra, se nao tiver)
task.spawn(function()
    task.wait(2.5)
    local sg = game:GetService("CoreGui"):FindFirstChild("StealEggHub")
    if not sg then return end
    -- se ja existe toggle Auto-TP no hub base, ok
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Steal Egg Hub v19",
            Text = "Hub completo | sem Anti-AFK | sem Anti-Taco",
            Duration = 4
        })
    end)
end)
