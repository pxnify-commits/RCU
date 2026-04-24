local Tab = getgenv().FarmHub.Tabs.Eggs
local RS = game:GetService("ReplicatedStorage")

-- Variablen für dieses Modul
local eggsHatchedCount = 0
local autoHatch = false
local selectedEgg = ""
local hatchDelay = 0.3

-- 1. EIER DYNAMISCH AUSLESEN
local EggList = {}
local EggFolder = RS:WaitForChild("Shared"):WaitForChild("List"):WaitForChild("Pets"):WaitForChild("Eggs")

for _, egg in ipairs(EggFolder:GetChildren()) do
    table.insert(EggList, egg.Name)
end
if #EggList == 0 then EggList = {"Forest"} end
selectedEgg = EggList[1]

-- 2. UI ELEMENTE
Tab:CreateSection("🥚 Egg Hatching")

Tab:CreateDropdown({
    Name = "Select Egg",
    Options = EggList,
    CurrentOption = {selectedEgg},
    Callback = function(opt) selectedEgg = opt[1] end
})

Tab:CreateToggle({
    Name = "Auto Hatch",
    CurrentValue = false,
    Callback = function(v) autoHatch = v end
})

Tab:CreateSlider({
    Name = "Hatch Delay",
    Range = {0.1, 2},
    Increment = 0.1,
    CurrentValue = 0.3,
    Callback = function(v) hatchDelay = v end
})

Tab:CreateSection("📊 Info")
local hatchLabel = Tab:CreateLabel("Egg Hatched: 0")

-- 3. HATCH LOOP (Hier wird die Remote erst definiert)
task.spawn(function()
    -- Der schwedische Bot-Pfad (Anna Bot)
    local BotStr = "jag k\195\164nner en bot, hon heter anna, anna heter hon"
    local Remote = RS:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild(BotStr):WaitForChild("RE"):WaitForChild(BotStr)

    while true do
        if autoHatch and selectedEgg ~= "" then
            pcall(function()
                Remote:FireServer(selectedEgg, 2)
                eggsHatchedCount = eggsHatchedCount + 1
                hatchLabel:Set("Egg Hatched: " .. tostring(eggsHatchedCount))
            end)
            task.wait(hatchDelay)
        end
        task.wait()
    end
end)
