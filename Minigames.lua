local Tab = getgenv().FarmHub.Tabs.Minigames
local RS = game:GetService("ReplicatedStorage")
local autoFrozen = false

Tab:CreateToggle({ Name = "Auto Frozen Treasure", Callback = function(v) autoFrozen = v end })

task.spawn(function()
    local KnitServices = RS:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services")
    local BotService = nil
    for _, v in ipairs(KnitServices:GetChildren()) do
        if v.Name:find("anna heter hon") then BotService = v break end
    end

    if BotService then
        local Remote = BotService:WaitForChild("RF"):FindFirstChildWhichIsA("RemoteFunction")
        while true do
            if autoFrozen and Remote then pcall(function() Remote:InvokeServer("normal") end) end
            task.wait(2)
        end
    end
end)
