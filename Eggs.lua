-- Warten, bis das UI-Grundgerüst wirklich existiert
repeat task.wait() until getgenv().FarmHub and getgenv().FarmHub.CoreLoaded == true

local Tab = getgenv().FarmHub.Tabs.Eggs
local RS = game:GetService("ReplicatedStorage")

-- Variablen
local eggsHatchedCount = 0
local autoHatch = false
local selectedEgg = ""
local hatchDelay = 0.3

-- 1. EIER DIREKT AUS DEM PFAD HOLEN
-- game:GetService("ReplicatedStorage").Shared.List.Pets.Eggs
local EggPath = RS:WaitForChild("Shared"):WaitForChild("List"):WaitForChild("Pets"):WaitForChild("Eggs")

local function getEggNames()
    local names = {}
    for _, egg in ipairs(EggPath:GetChildren()) do
        -- Wir nehmen den Namen des Objekts (z.B. "Desert")
        table.insert(names, egg.Name)
    end
    -- Sortieren für bessere Übersicht
    table.sort(names)
    return names
end

local EggList = getEggNames()
selectedEgg = EggList[1] or "Desert"

-- 2. UI ELEMENTE
Tab:CreateSection("🥚 Egg Hatching")

local EggDropdown = Tab:CreateDropdown({
    Name = "Select Egg",
    Options = EggList,
    CurrentOption = {selectedEgg},
    Callback = function(opt) 
        selectedEgg = opt[1] 
    end
})

Tab:CreateButton({
    Name = "Refresh Eggs",
    Callback = function()
        EggDropdown:Refresh(getEggNames())
    end
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

-- 3. AUTO HATCH LOGIK (Remote Hook)
task.spawn(function()
    local KnitServices = RS:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services")
    local BotStr = "jag k\195\164nner en bot, hon heter anna, anna heter hon"
    
    -- Sicherer Zugriff auf den Service
    local BotService = KnitServices:WaitForChild(BotStr, 10)
    if not BotService then
        warn("❌ Bot Service (Anna) nicht gefunden!")
        return
    end

    -- Zugriff auf die Remote (RE)
    local Remote = BotService:WaitForChild("RE"):WaitForChild(BotStr, 10)

    while true do
        if autoHatch and selectedEgg ~= "" and Remote then
            pcall(function()
                -- Dein angegebener Remote-Aufruf:
                -- args sind typischerweise (EggName, Amount)
                -- Wir nutzen '2' als Amount, wie im vorherigen Snippet
                Remote:FireServer(selectedEgg, 2)
                
                eggsHatchedCount = eggsHatchedCount + 1
                hatchLabel:Set("Egg Hatched: " .. tostring(eggsHatchedCount))
            end)
        end
        task.wait(hatchDelay)
    end
end)
