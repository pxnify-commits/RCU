local Tab = getgenv().FarmHub.Tabs.Machines
local RF = getgenv().FarmHub.RF

local selectedMachines = {}
Tab:CreateDropdown({
    Name = "Select Machines (Multi-Select)",
    Options = {"Steampunk", "Lunar 1", "Lunar 2", "Lunar 3", "Lunar 4"},
    CurrentOption = {},
    MultipleOptions = true,
    Callback = function(O) selectedMachines = O end,
})

local machineEnabled = false
Tab:CreateToggle({
    Name = "Auto Run Machines",
    CurrentValue = false,
    Callback = function(Value)
        machineEnabled = Value
        if machineEnabled then
            -- Steampunk Loop (50s)
            task.spawn(function()
                while machineEnabled do
                    if table.find(selectedMachines, "Steampunk") then
                        pcall(function() RF:InvokeServer("eggsOpen", 1) end)
                    end
                    task.wait(50) -- Note: Every 50 seconds
                end
            end)
            
            -- Lunar Forge Loop (3x alle 3s)
            task.spawn(function()
                while machineEnabled do
                    for i = 1, 4 do
                        if table.find(selectedMachines, "Lunar "..i) then
                            for spam = 1, 3 do -- Note: Spam 3 times
                                pcall(function() RF:InvokeServer(i, 1) end)
                            end
                        end
                    end
                    task.wait(3) -- Note: Every 3 seconds
                end
            end)
        end
    end,
})
