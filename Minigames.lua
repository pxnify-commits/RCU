local Tab = getgenv().FarmHub.Tabs.Minigames
local RS = game:GetService("ReplicatedStorage")

local autoFrozen = false

-- 1. UI ELEMENTE
Tab:CreateSection("🎮 Frozen Treasure")

Tab:CreateToggle({
    Name = "Auto Frozen Treasure",
    CurrentValue = false,
    Callback = function(v) 
        autoFrozen = v 
    end
})

-- 2. LOGIK LOOP
task.spawn(function()
    local BotStr = "jag k\195\164nner en bot, hon heter anna, anna heter hon"
    local Remote = RS:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild(BotStr):WaitForChild("RF"):WaitForChild(BotStr)

    while true do
        if autoFrozen then
            pcall(function() 
                -- Note: Remote for Frozen Treasure
                Remote:InvokeServer("normal") 
            end)
            task.wait(2) -- Kleiner Delay zur Stabilität
        end
        task.wait(0.5)
    end
end)
