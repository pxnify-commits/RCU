-- Warten, bis das UI-Grundgerüst wirklich existiert
repeat task.wait() until getgenv().FarmHub and getgenv().FarmHub.CoreLoaded == true

local Tab = getgenv().FarmHub.Tabs.Eggs
local RS = game:GetService("ReplicatedStorage")

-- Variablen
local eggsHatchedCount = 0
local autoHatch = false
local selectedEgg = ""
local hatchDelay = 0.3

-- 1. EIER AUS DEM WORKSPACE HOLEN
local function getEggNames()
    local names = {}
    -- Wir greifen direkt auf workspace.Eggs zu
    local EggFolder = workspace:FindFirstChild("Eggs")
    
    if EggFolder then
        for _, egg in ipairs(EggFolder:GetChildren()) do
            -- Wir fügen den Namen des Objekts zur Liste hinzu
            if not table.find(names, egg.Name) then
                table.insert(names, egg.Name)
            end
        end
    end
    
    table.sort(names)
    -- Falls der Ordner leer ist, ein paar Standardnamen als Backup
    if #names == 0 then names = {"Forest", "Desert", "Snow"} end
    return names
end

local EggList = getEggNames()
selectedEgg = EggList[1]

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

-- Button zum Aktualisieren, falls neue Eier im Workspace spawnen
Tab:CreateButton({
    Name = "Refresh Egg List",
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

-- 3. AUTO HATCH LOGIK
task.spawn(function()
    local KnitServices = RS:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services")
    local BotStr = "jag k\195\164nner en bot, hon heter anna, anna heter hon"
    
    -- Den Service finden (mit Timeout von 10 Sek)
    local BotService = KnitServices:WaitForChild(BotStr, 10)
    if not BotService then 
        warn("❌ Bot Service nicht gefunden!") 
        return 
    end

    local Remote = BotService:WaitForChild("RE"):WaitForChild(BotStr, 10)

    while true do
        if autoHatch and selectedEgg ~= "" and Remote then
            pcall(function()
                -- Remote-Aufruf mit dem Namen des ausgewählten Eies
                Remote:FireServer(selectedEgg, 1) -- 1 = Menge
                
                eggsHatchedCount = eggsHatchedCount + 1
                hatchLabel:Set("Egg Hatched: " .. tostring(eggsHatchedCount))
            end)
        end
        task.wait(hatchDelay)
    end
end)
