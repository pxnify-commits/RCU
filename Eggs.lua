local Tab = getgenv().FarmHub.Tabs.Eggs
local RS = game:GetService("ReplicatedStorage")

local eggsHatchedCount = 0
local autoHatch = false
local selectedEgg = ""
local hatchDelay = 0.3

local EggList = {}
local EggFolder = RS:WaitForChild("Shared"):WaitForChild("List"):WaitForChild("Pets"):WaitForChild("Eggs")
for _, egg in ipairs(EggFolder:GetChildren()) do table.insert(EggList, egg.Name) end
selectedEgg = EggList[1] or "Forest"

Tab:CreateDropdown({
    Name = "Select Egg",
    Options = EggList,
    CurrentOption = {selectedEgg},
    Callback = function(opt) selectedEgg = opt[1] end
})

Tab:CreateToggle({
    Name = "Auto Hatch",
    Callback = function(v) autoHatch = v end
})

Tab:CreateSlider({
    Name = "Hatch Delay",
    Range = {0.1, 2},
    Increment = 0.1,
    CurrentValue = 0.3,
    Callback = function(v) hatchDelay = v end
})

local hatchLabel = Tab:CreateLabel("Egg Hatched: 0")

task.spawn(function()
    local KnitServices = RS:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services")
    local BotService = nil
    for _, v in ipairs(KnitServices:GetChildren()) do
        if v.Name:find("anna heter hon") then BotService = v break end
    end

    if BotService then
        local Remote = BotService:WaitForChild("RE"):FindFirstChildWhichIsA("RemoteEvent")
        while true do
            if autoHatch and selectedEgg ~= "" and Remote then
                pcall(function() 
                    Remote:FireServer(selectedEgg, 2)
                    eggsHatchedCount = eggsHatchedCount + 1
                    hatchLabel:Set("Egg Hatched: " .. tostring(eggsHatchedCount))
                end)
            end
            task.wait(hatchDelay)
        end
    end
end)
