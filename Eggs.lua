-- Warten, bis das UI-Grundgerüst wirklich existiert
repeat task.wait() until getgenv().FarmHub and getgenv().FarmHub.CoreLoaded == true

local Tab = getgenv().FarmHub.Tabs.Eggs
local RS = game:GetService("ReplicatedStorage")

-- 1. EIER DYNAMISCH AUSLESEN (Exakter Pfad aus deiner Note)
local EggList = {}
local selectedEgg = ""
local eggsHatchedCount = 0
local autoHatch = false
local hatchDelay = 0.3

-- Zugriff auf den von dir genannten Pfad
local EggPath = RS:WaitForChild("Shared"):WaitForChild("List"):WaitForChild("Pets"):WaitForChild("Eggs")

local function updateEggList()
    local list = {}
    for _, egg in ipairs(EggPath:GetChildren()) do
        table.insert(list, egg.Name)
    end
    return list
end

EggList = updateEggList()
selectedEgg = EggList[1] or "Forest"

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

-- Button zum manuellen Aktualisieren, falls das Spiel neue Eier lädt
Tab:CreateButton({
    Name = "Refresh Egg List",
    Callback = function()
        EggDropdown:Refresh(updateEggList())
    end,
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

-- 3. LOGIK-LOOP (Suche nach der Remote im Hintergrund)
task.spawn(function()
    local KnitServices = RS:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services")
    local BotService = nil
    
    -- Suche den Service per Teil-Name (vermeidet Encoding-Probleme mit 'ä')
    while not BotService do
        for _, v in ipairs(KnitServices:GetChildren()) do
            if v.Name:find("anna heter hon") then
                BotService = v
                break
            end
        end
        task.wait(1)
    end

    -- Wenn der Service gefunden wurde, die Remote greifen
    local Remote = BotService:WaitForChild("RE"):FindFirstChildWhichIsA("RemoteEvent")

    while true do
        if autoHatch and selectedEgg ~= "" and Remote then
            pcall(function() 
                -- Note: args = { EggName, Quantity } -> Quantity ist 2 laut deinem Snippet
                Remote:FireServer(selectedEgg, 2)
                eggsHatchedCount = eggsHatchedCount + 1
                hatchLabel:Set("Egg Hatched: " .. tostring(eggsHatchedCount))
            end)
        end
        task.wait(hatchDelay)
    end
end)
