local Tab = getgenv().FarmHub.Tabs.Minigames
local RF = getgenv().FarmHub.RF

local frozenEnabled = false
Tab:CreateToggle({
    Name = "Auto Frozen Treasure",
    CurrentValue = false,
    Callback = function(Value)
        frozenEnabled = Value
        if frozenEnabled then
            task.spawn(function()
                while frozenEnabled do
                    pcall(function() RF:InvokeServer("normal") end)
                    task.wait(1)
                end
            end)
        end
    end,
})
