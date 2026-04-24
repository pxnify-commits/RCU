local Tab = getgenv().FarmHub.Tabs.Farms
local RS = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer

local activeFarms = {}
local autoFarm = false

Tab:CreateDropdown({
    Name = "Select Farms",
    Options = {"strawberryFarm", "PineappleFarm", "AppleFarm", "GrapeFarm", "CarrotFarm", "BananaFarm"},
    MultipleOptions = true,
    Callback = function(opts) activeFarms = opts end
})

Tab:CreateToggle({
    Name = "Auto Farm (19 Min Loop)",
    Callback = function(v) autoFarm = v end
})

-- DEBRIS SECTION
Tab:CreateSection("Debris")
local autoDebris = false
Tab:CreateToggle({
    Name = "Auto Collect Debris",
    Callback = function(v) autoDebris = v end
})

-- LOOP
task.spawn(function()
    local BotStr = "jag k\195\164nner en bot, hon heter anna, anna heter hon"
    local Remote = RS:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild(BotStr):WaitForChild("RF"):WaitForChild(BotStr)

    -- Farm Loop (Hintergrund)
    task.spawn(function()
        while true do
            if autoFarm then
                for i = 1, 3 do
                    for _, farm in ipairs(activeFarms) do
                        pcall(function() Remote:InvokeServer(farm) end)
                    end
                end
                task.wait(1140)
            end
            task.wait(1)
        end
    end)

    -- Debris Loop
    while true do
        if autoDebris then
            for _, item in ipairs(workspace.Debris:GetChildren()) do
                pcall(function() 
                    Remote:InvokeServer(item.Name) 
                    Player.Character.HumanoidRootPart.CFrame = item:GetPivot()
                end)
                task.wait(0.1)
            end
        end
        task.wait(1)
    end
end)
