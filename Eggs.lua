-- Warten, bis das UI-Grundgerüst wirklich existiert
repeat task.wait() until getgenv().FarmHub and getgenv().FarmHub.CoreLoaded == true

local Tab = getgenv().FarmHub.Tabs.Eggs
local RS = game:GetService("ReplicatedStorage")

-- Variablen
local eggsHatchedCount = 0
local autoHatch = false
local selectedEgg = ""
local hatchDelay = 0.3

-- 1. EIER AUS DEM MODULESCRIPT AUSLESEN
local EggList = {}

local function getEggNames()
    local names = {}
    -- Pfad zum ModuleScript (Shared.List.Pets.Eggs ist oft ein Modul)
    local success, result = pcall(function()
        local Path = RS.Shared.List.Pets.Eggs
        if Path:IsA("ModuleScript") then
            local data = require(Path)
            for eggName, _ in pairs(data) do
                if type(eggName) == "string" then
                    table.insert(names, eggName)
                end
            end
        else
            -- Falls es doch ein Ordner ist
            for _, egg in ipairs(Path:GetChildren()) do
                table.insert(names, egg.Name)
            end
        end
    end)
    
    table.sort(names)
    return #names > 0 and names or {"Forest", "Desert"} -- Backup
end

EggList = getEggNames()
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
    
    -- Den Service sicher finden
    local BotService = KnitServices:WaitForChild(BotStr, 10)
    local Remote = BotService and BotService:WaitForChild("RE"):WaitForChild(BotStr, 10)

    while true do
        if autoHatch and selectedEgg ~= "" and Remote then
            pcall(function()
                -- Remote Call wie von dir bestätigt
                Remote:FireServer(selectedEgg, 1) -- '1' oder '2' für die Menge
                
                eggsHatchedCount = eggsHatchedCount + 1
                hatchLabel:Set("Egg Hatched: " .. tostring(eggsHatchedCount))
            end)
        end
        task.wait(hatchDelay)
    end
end)
