local Tab = getgenv().FarmHub.Tabs.Machines
local RS = game:GetService("ReplicatedStorage")

local selectedMachines = {}
local autoMachine = false

-- 1. UI ELEMENTE
Tab:CreateDropdown({
    Name = "Select Machines (Multi-Select)",
    Options = {"Steampunk +1 Egg", "Lunar Forge 1", "Lunar Forge 2", "Lunar Forge 3", "Lunar Forge 4"},
    CurrentOption = {},
    MultipleOptions = true,
    Callback = function(opts) 
        selectedMachines = opts 
    end
})

Tab:CreateToggle({
    Name = "Auto Run Selected Machines",
    CurrentValue = false,
    Callback = function(v) 
        autoMachine = v 
    end
})

-- 2. LOGIK LOOP
task.spawn(function()
    local BotStr = "jag k\195\164nner en bot, hon heter anna, anna heter hon"
    local Remote = RS:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild(BotStr):WaitForChild("RF"):WaitForChild(BotStr)

    -- Steampunk Loop (Note: Every 50 seconds)
    task.spawn(function()
        while true do
            if autoMachine and table.find(selectedMachines, "Steampunk +1 Egg") then
                pcall(function() 
                    Remote:InvokeServer("eggsOpen", 1) 
                end)
                task.wait(50)
            end
            task.wait(1)
        end
    end)

    -- Lunar Forge Loop (Note: Spam every 3 seconds 3 times)
    while true do
        if autoMachine then
            for i = 1, 4 do
                if table.find(selectedMachines, "Lunar Forge " .. i) then
                    for spam = 1, 3 do
                        pcall(function() 
                            Remote:InvokeServer(i, 1) 
                        end)
                    end
                end
            end
            task.wait(3)
        end
        task.wait(0.1)
    end
end)
