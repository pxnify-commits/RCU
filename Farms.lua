local Tab = getgenv().FarmHub.Tabs.Farms
local RF = getgenv().FarmHub.RF
local Player = game.Players.LocalPlayer

-- Multi-Select für Farms
local activeFarms = {}
Tab:CreateDropdown({
    Name = "Select Farms (Multi-Select)",
    Options = {"strawberryFarm", "PineappleFarm", "AppleFarm", "GrapeFarm", "CarrotFarm", "BananaFarm"},
    CurrentOption = {},
    MultipleOptions = true,
    Callback = function(Options) activeFarms = Options end,
})

local farmEnabled = false
Tab:CreateToggle({
    Name = "Auto Farm (3x every 19 min)",
    CurrentValue = false,
    Callback = function(Value)
        farmEnabled = Value
        if farmEnabled then
            task.spawn(function()
                while farmEnabled do
                    -- Note: Spam this remote 3 times
                    for i = 1, 3 do
                        for _, farm in ipairs(activeFarms) do
                            pcall(function() RF:InvokeServer(farm) end)
                        end
                    end
                    task.wait(1140) -- Note: Every 19 min
                end
            end)
        end
    end,
})

Tab:CreateSection("Collectibles")

local debrisEnabled = false
Tab:CreateToggle({
    Name = "Auto Collect Debris (TP + Remote)",
    CurrentValue = false,
    Callback = function(Value)
        debrisEnabled = Value
        if debrisEnabled then
            task.spawn(function()
                while debrisEnabled do
                    for _, item in ipairs(workspace.Debris:GetChildren()) do
                        -- Note: Remote collect
                        pcall(function() RF:InvokeServer(item.Name) end)
                        -- Note: TP under player
                        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                            local pos = item:IsA("Model") and item:GetPivot().Position or item.Position
                            Player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
                        end
                        task.wait(0.1)
                    end
                    task.wait(1)
                end
            end)
        end
    end,
})

local honeyTime = 1
Tab:CreateSlider({
    Name = "Honey/Meteor Delay",
    Range = {0.1, 10},
    Increment = 0.1,
    CurrentValue = 1,
    Callback = function(V) honeyTime = V end,
})

local honeyEnabled = false
Tab:CreateToggle({
    Name = "Auto Honey/Meteor",
    CurrentValue = false,
    Callback = function(Value)
        honeyEnabled = Value
        if honeyEnabled then
            task.spawn(function()
                while honeyEnabled do
                    pcall(function() RF:InvokeServer() end)
                    task.wait(honeyTime)
                end
            end)
        end
    end,
})
