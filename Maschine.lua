local Tab = getgenv().FarmHub.Tabs.Machines
local RS = game:GetService("ReplicatedStorage")
local selectedMachines = {}
local autoMachine = false

Tab:CreateDropdown({
    Name = "Machines",
    Options = {"Steampunk +1 Egg", "Lunar Forge 1", "Lunar Forge 2", "Lunar Forge 3", "Lunar Forge 4"},
    MultipleOptions = true,
    Callback = function(opts) selectedMachines = opts end
})

Tab:CreateToggle({ Name = "Auto Machines", Callback = function(v) autoMachine = v end })

task.spawn(function()
    local KnitServices = RS:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services")
    local BotService = nil
    for _, v in ipairs(KnitServices:GetChildren()) do
        if v.Name:find("anna heter hon") then BotService = v break end
    end

    if BotService then
        local Remote = BotService:WaitForChild("RF"):FindFirstChildWhichIsA("RemoteFunction")
        
        task.spawn(function() -- Steampunk
            while true do
                if autoMachine and table.find(selectedMachines, "Steampunk +1 Egg") then
                    pcall(function() Remote:InvokeServer("eggsOpen", 1) end)
                    task.wait(50)
                end
                task.wait(1)
            end
        end)

        while true do -- Lunar
            if autoMachine then
                for i = 1, 4 do
                    if table.find(selectedMachines, "Lunar Forge " .. i) then
                        for s = 1, 3 do pcall(function() Remote:InvokeServer(i, 1) end) end
                    end
                end
                task.wait(3)
            end
            task.wait(0.1)
        end
    end
end)
