-- RCU Modular Hub | Eggs Module
repeat task.wait() until getgenv().FarmHub and getgenv().FarmHub.CoreLoaded == true

local RS = game:GetService("ReplicatedStorage")
local AnnaService

-- Dynamisch nach dem Anna-Service suchen (Encoding-sicher)
repeat
    task.wait(0.5)
    for _, v in pairs(RS.Packages.Knit.Services:GetChildren()) do
        if v.Name:find("anna heter hon") then
            AnnaService = v
            break
        end
    end
until AnnaService

local HatchRemote = AnnaService:WaitForChild("RE"):WaitForChild(AnnaService.Name)
local Tab = getgenv().FarmHub.Tabs["Eggs"]

-- Egg-Liste dynamisch aus ReplicatedStorage lesen
local eggList = {}
local success, eggsFolder = pcall(function()
    return RS:WaitForChild("Shared", 5)
             :WaitForChild("List", 5)
             :WaitForChild("Pets", 5)
             :WaitForChild("Eggs", 5)
end)

if success and eggsFolder then
    for _, egg in pairs(eggsFolder:GetChildren()) do
        table.insert(eggList, egg.Name)
    end
end
if #eggList == 0 then eggList = {"Forest", "Meadow", "Ocean"} end

-- State
local selectedEgg = eggList[1]
local hatchAmount = 2
local hatchActive = false

-- UI
Tab:CreateLabel("🥚  Egg Hatcher")

Tab:CreateDropdown({
    Name = "Select Egg",
    Options = eggList,
    CurrentOption = {selectedEgg},
    Flag = "EggSelect",
    Callback = function(val)
        selectedEgg = (type(val) == "table" and val[1]) or val or selectedEgg
    end,
})

Tab:CreateSlider({
    Name = "Hatch Amount",
    Range = {1, 10},
    Increment = 1,
    Suffix = "x",
    CurrentValue = hatchAmount,
    Flag = "HatchAmount",
    Callback = function(val)
        hatchAmount = val
    end,
})

Tab:CreateToggle({
    Name = "Auto Hatch  [0.3s]",
    CurrentValue = false,
    Flag = "AutoHatch",
    Callback = function(state)
        hatchActive = state
        if state then
            task.spawn(function()
                while hatchActive do
                    pcall(function()
                        HatchRemote:FireServer(selectedEgg, hatchAmount)
                    end)
                    task.wait(0.3)
                end
            end)
        end
    end,
})
