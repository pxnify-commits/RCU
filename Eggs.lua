-- Warten auf das UI
repeat task.wait() until getgenv().FarmHub and getgenv().FarmHub.CoreLoaded == true

local Tab = getgenv().FarmHub.Tabs.Eggs
local RS = game:GetService("ReplicatedStorage")

local autoHatch = false
local selectedEgg = "200M"
local hatchDelay = 0.3

-- 1. Eier-Liste laden (Sicherer Pfad aus deinem Modul-Screenshot)
local function getEggList()
    local names = {}
    local success, data = pcall(function()
        return require(RS:WaitForChild("Shared"):WaitForChild("List"):WaitForChild("Pets"):WaitForChild("Eggs"))
    end)
    
    if success and type(data) == "table" then
        for eggName, _ in pairs(data) do
            table.insert(names, tostring(eggName))
        end
    else
        names = {"200M", "Forest", "Desert"} -- Fallback
    end
    table.sort(names)
    return names
end

-- 2. UI erstellen
Tab:CreateSection("🥚 Auto Hatcher")

local Dropdown = Tab:CreateDropdown({
    Name = "Select Egg",
    Options = getEggList(),
    CurrentOption = {selectedEgg},
    Callback = function(opt) selectedEgg = opt[1] end
})

Tab:CreateToggle({
    Name = "Auto Hatch",
    CurrentValue = false,
    Callback = function(v) autoHatch = v end
})

Tab:CreateSlider({
    Name = "Hatch Speed",
    Range = {0.1, 2},
    Increment = 0.1,
    CurrentValue = 0.3,
    Callback = function(v) hatchDelay = v end
})

-- 3. DER FIX: Remote-Loop ohne Blockieren
task.spawn(function()
    local botName = "jag k\195\164nner en bot, hon heter anna, anna heter hon"
    local KnitServices = RS:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services")
    
    -- Wir suchen NUR den RE Ordner, wir ignorieren RF komplett!
    local AnnaService = KnitServices:WaitForChild(botName, 15)
    local RE_Folder = AnnaService:WaitForChild("RE", 10)
    local Remote = RE_Folder:WaitForChild(botName, 10)

    if Remote then
        print("✅ Remote für Hatch gefunden! Loop aktiv.")
        while true do
            if autoHatch and selectedEgg ~= "" then
                -- Wir feuern die Remote exakt so, wie SimpleSpy es getan hat
                pcall(function()
                    Remote:FireServer(selectedEgg, 1) -- Menge 1 oder 2 testen
                end)
            end
            task.wait(hatchDelay)
        end
    else
        warn("❌ Remote konnte nicht gefunden werden - Script abgebrochen.")
    end
end)
