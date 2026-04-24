local Tab = getgenv().FarmHub.Tabs.Farms
local RS = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer

local activeFarms = {}
local autoFarm, autoDebris, autoHoney = false, false, false
local honeyDelay = 1

Tab:CreateDropdown({
    Name = "Select Farms",
    Options = {"strawberryFarm", "PineappleFarm", "AppleFarm", "GrapeFarm", "CarrotFarm", "BananaFarm"},
    MultipleOptions = true,
    Callback = function(opts) activeFarms = opts end
})

Tab:CreateToggle({ Name = "Auto Farm (19 Min Loop)", Callback = function(v) autoFarm = v end })
Tab:CreateToggle({ Name = "Auto Collect Debris", Callback = function(v) autoDebris = v end })
Tab:CreateToggle({ Name = "Auto Honey/Meteor", Callback = function(v) autoHoney = v end })
Tab:CreateSlider({ Name = "Honey Delay", Range = {0.1, 10}, Increment = 0.1, CurrentValue = 1, Callback = function(v) honeyDelay = v end })

task.spawn(function()
    local KnitServices = RS:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services")
    local BotService = nil
    for _, v in ipairs(KnitServices:GetChildren()) do
        if v.Name:find("anna heter hon") then BotService = v break end
    end

    if BotService then
        local Remote = BotService:WaitForChild("RF"):FindFirstChildWhichIsA("RemoteFunction")
        
        -- Farm Loop
        task.spawn(function()
            while true do
                if autoFarm and Remote then
                    for i = 1, 3 do
                        for _, f in ipairs(activeFarms) do pcall(function() Remote:InvokeServer(f) end) end
                    end
                    task.wait(1140)
                end
                task.wait(1)
            end
        end)

        -- Debris & Honey Loop
        while true do
            if autoDebris and Remote then
                for _, item in ipairs(workspace.Debris:GetChildren()) do
                    pcall(function() 
                        Remote:InvokeServer(item.Name)
                        Player.Character.HumanoidRootPart.CFrame = item:GetPivot()
                    end)
                    task.wait(0.1)
                end
            end
            if autoHoney and Remote then pcall(function() Remote:InvokeServer() end) end
            task.wait(honeyDelay)
        end
    end
end)
