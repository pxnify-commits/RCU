-- Warten auf Core
repeat task.wait() until getgenv().FarmHub and getgenv().FarmHub.CoreLoaded == true

local Tab = getgenv().FarmHub.Tabs.Eggs
local RS = game:GetService("ReplicatedStorage")
local EggFolder = workspace:WaitForChild("Eggs", 10)

local eggsHatchedCount = 0
local autoHatch = false
local selectedEgg = ""
local hatchDelay = 0.3

-- Eier aus Workspace auslesen
local function getEggs()
    local names = {}
    if EggFolder then
        for _, v in ipairs(EggFolder:GetChildren()) do
            if not table.find(names, v.Name) then table.insert(names, v.Name) end
        end
    end
    table.sort(names)
    return #names > 0 and names or {"Forest"}
end

local currentEggs = getEggs()
selectedEgg = currentEggs[1]

Tab:CreateSection("🥚 Egg Hatching")

local Dropdown = Tab:CreateDropdown({
    Name = "Select Egg",
    Options = currentEggs,
    CurrentOption = {selectedEgg},
    Callback = function(opt) selectedEgg = opt[1] end
})

Tab:CreateButton({
    Name = "Refresh List",
    Callback = function() Dropdown:Refresh(getEggs()) end
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

local hatchLabel = Tab:CreateLabel("Hatched: 0")

-- Knit Remote Suche & Loop
task.spawn(function()
    local KnitServices = RS:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services")
    local BotService = nil
    
    -- Such-Loop für den Anna-Bot (umgeht Knit-Tarnung)
    while not BotService do
        for _, v in ipairs(KnitServices:GetChildren()) do
            if v.Name:find("anna heter hon") then BotService = v break end
        end
        task.wait(1)
    end

    local Remote = BotService:WaitForChild("RE"):FindFirstChildWhichIsA("RemoteEvent")

    while true do
        if autoHatch and selectedEgg ~= "" and Remote then
            pcall(function()
                Remote:FireServer(selectedEgg, 1)
                eggsHatchedCount = eggsHatchedCount + 1
                hatchLabel:Set("Hatched: " .. tostring(eggsHatchedCount))
            end)
        end
        task.wait(hatchDelay)
    end
end)
