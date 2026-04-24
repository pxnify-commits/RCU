local Tab = getgenv().FarmHub.Tabs.Eggs
local RE = getgenv().FarmHub.RE

-- Pfad aus deiner Note
local EggPath = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("List"):WaitForChild("Pets"):WaitForChild("Eggs")

-- Funktion zum Auslesen der Eier
local function getEggList()
    local eggs = {}
    for _, egg in ipairs(EggPath:GetChildren()) do
        table.insert(eggs, egg.Name)
    end
    -- Falls der Ordner leer ist, ein Backup-Ei anzeigen
    if #eggs == 0 then table.insert(eggs, "Forest") end
    return eggs
end

local selectedEgg = "Forest"
local hatchEnabled = false

-- Dropdown mit automatischem Scan
local EggDropdown = Tab:CreateDropdown({
    Name = "Select Egg (Auto-Scan)",
    Options = getEggList(),
    CurrentOption = {"Forest"},
    Callback = function(Option) 
        selectedEgg = Option[1] 
    end,
})

-- Button zum manuellen Aktualisieren der Liste (falls neue Eier ohne Restart kommen)
Tab:CreateButton({
    Name = "Refresh Egg List",
    Callback = function()
        EggDropdown:Refresh(getEggList())
    end,
})

Tab:CreateSection("Hatch Settings")

Tab:CreateToggle({
    Name = "Auto Open Selected Egg",
    CurrentValue = false,
    Callback = function(Value)
        hatchEnabled = Value
        if hatchEnabled then
            task.spawn(function()
                while hatchEnabled do
                    -- Note: Spam remote with delay of 0.3 seconds
                    -- Argumente: Name des Eis und die Zahl 2 (aus deinem Script-Snippet)
                    pcall(function() 
                        RE:FireServer(selectedEgg, 2) 
                    end)
                    task.wait(0.3)
                end
            end)
        end
    end,
})
