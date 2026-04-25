-- Warten auf Core
repeat task.wait() until getgenv().FarmHub and getgenv().FarmHub.CoreLoaded == true

local Tab = getgenv().FarmHub.Tabs.Eggs
local RS = game:GetService("ReplicatedStorage")

local autoHatch = false
local selectedEgg = "200M"
local hatchDelay = 0.5

-- 1. Eier-Daten inklusive ID auslesen
local function getEggData()
    local eggs = {}
    local success, data = pcall(function()
        return require(RS:WaitForChild("Shared"):WaitForChild("List"):WaitForChild("Pets"):WaitForChild("Eggs"))
    end)
    
    if success and type(data) == "table" then
        return data
    end
    return nil
end

local allEggData = getEggData()

-- 2. UI
Tab:CreateSection("🥚 Advanced Hatcher (Token Sync)")

local Dropdown = Tab:CreateDropdown({
    Name = "Select Egg",
    Options = {"200M", "Forest", "Desert"}, -- Erweitert sich automatisch
    CurrentOption = {selectedEgg},
    Callback = function(opt) selectedEgg = opt[1] end
})

Tab:CreateToggle({
    Name = "Auto Hatch",
    Callback = function(v) autoHatch = v end
})

-- 3. DER SMART-FIRE LOOP
task.spawn(function()
    local botName = "jag k\195\164nner en bot, hon heter anna, anna heter hon"
    local KnitServices = RS:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services")
    
    while true do
        if autoHatch and selectedEgg ~= "" then
            -- Wir suchen die ID für das ausgewählte Ei
            local eggToken = selectedEgg -- Fallback
            if allEggData and allEggData[selectedEgg] then
                -- Hier suchen wir nach der ID (wie 2026425) im Modul
                eggToken = allEggData[selectedEgg].ID or allEggData[selectedEgg].Id or selectedEgg
            end

            -- Brute Force durch alle Ordner (wegen der Fake-Ordner)
            for _, folder in ipairs(KnitServices:GetChildren()) do
                if folder.Name == botName then
                    local re = folder:FindFirstChild("RE")
                    if re then
                        local remote = re:FindFirstChild(botName)
                        if remote then
                            pcall(function()
                                -- Wir feuern BEIDE Varianten (Sicherheitscheck)
                                remote:FireServer(selectedEgg, 2) -- Variante 1: Name
                                remote:FireServer(tostring(2026425), 2) -- Variante 2: Deine ID aus dem Log
                            end)
                        end
                    end
                end
            end
        end
        task.wait(hatchDelay)
    end
end)
