-- Warten auf Core
repeat task.wait() until getgenv().FarmHub and getgenv().FarmHub.CoreLoaded == true

local Tab = getgenv().FarmHub.Tabs.Eggs
local RS = game:GetService("ReplicatedStorage")

local autoHatch = false
local selectedEgg = "200M" -- Standard gesetzt
local hatchDelay = 0.3

-- 1. EIER AUS DEM SPIEL-SYSTEM AUSLESEN (Sicherer Weg)
local function getEggList()
    local names = {}
    -- Pfad aus deinem Screenshot image_9502b5.png
    local success, data = pcall(function()
        return require(RS.Shared.List.Pets.Eggs)
    end)
    
    if success and type(data) == "table" then
        for eggName, _ in pairs(data) do
            table.insert(names, tostring(eggName))
        end
    else
        -- Backup, falls das Modul nicht geladen werden kann
        names = {"200M", "Forest", "Desert", "Snow", "Volcano"}
    end
    table.sort(names)
    return names
end

local eggOptions = getEggList()

-- 2. UI ELEMENTE
Tab:CreateSection("🥚 Egg Hatching")

local Dropdown = Tab:CreateDropdown({
    Name = "Select Egg",
    Options = eggOptions,
    CurrentOption = {selectedEgg},
    Callback = function(opt) selectedEgg = opt[1] end
})

Tab:CreateToggle({
    Name = "Auto Hatch",
    Callback = function(v) autoHatch = v end
})

Tab:CreateSlider({
    Name = "Hatch Delay",
    Range = {0.1, 2},
    Increment = 0.1,
    CurrentValue = 0.3,
    Callback = function(v) hatchDelay = v end
})

-- 3. AUTO HATCH LOOP (Der funktionierende Remote-Weg)
task.spawn(function()
    local BotStr = "jag k\195\164nner en bot, hon heter anna, anna heter hon"
    local Knit = RS:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services")
    local Service = Knit:WaitForChild(BotStr, 15)
    local Remote = Service and Service:WaitForChild("RE"):WaitForChild(BotStr, 15)

    while true do
        if autoHatch and Remote then
            pcall(function()
                -- Nutzt exakt deine verifizierten Argumente: Name und Menge 2
                Remote:FireServer(selectedEgg, 2)
            end)
        end
        task.wait(hatchDelay)
    end
end)
