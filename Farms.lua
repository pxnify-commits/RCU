-- RCU Modular Hub | Farms Module
repeat task.wait() until getgenv().FarmHub and getgenv().FarmHub.CoreLoaded == true

local RS   = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LP   = Players.LocalPlayer
local AnnaService

repeat
    task.wait(0.5)
    for _, v in pairs(RS.Packages.Knit.Services:GetChildren()) do
        if v.Name:find("anna heter hon") then
            AnnaService = v
            break
        end
    end
until AnnaService

local RF          = AnnaService:WaitForChild("RF"):WaitForChild(AnnaService.Name)
local Tab         = getgenv().FarmHub.Tabs["Farms"]

-- ─────────────────────────────────────────────
--  SECTION: CROP FARMS
-- ─────────────────────────────────────────────
Tab:CreateLabel("🌱  Crop Farms  (3× every 19 min)")

local allFarms     = {"strawberryFarm","PineappleFarm","AppleFarm","GrapeFarm","CarrotFarm","BananaFarm"}
local selectedFarms = {}
local farmActive   = false

Tab:CreateDropdown({
    Name = "Select Farms",
    Options = allFarms,
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "FarmSelect",
    Callback = function(vals)
        selectedFarms = vals or {}
    end,
})

Tab:CreateToggle({
    Name = "Auto Farm  [3× / 19 min]",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(state)
        farmActive = state
        if state then
            task.spawn(function()
                while farmActive do
                    for _, farmName in ipairs(selectedFarms) do
                        for i = 1, 3 do
                            pcall(function()
                                RF:InvokeServer(farmName)
                            end)
                            task.wait(0.5)
                        end
                    end
                    -- Warte 19 Minuten (1140 Sekunden), dabei weiter prüfen
                    local elapsed = 0
                    while farmActive and elapsed < 1140 do
                        task.wait(1)
                        elapsed += 1
                    end
                end
            end)
        end
    end,
})

-- ─────────────────────────────────────────────
--  SECTION: AUTO COLLECT
-- ─────────────────────────────────────────────
Tab:CreateLabel("✨  Auto Collect")

-- Shared timer slider
local collectInterval = 5
Tab:CreateSlider({
    Name = "Collect Interval (seconds)",
    Range = {1, 60},
    Increment = 1,
    Suffix = "s",
    CurrentValue = collectInterval,
    Flag = "CollectInterval",
    Callback = function(val)
        collectInterval = val
    end,
})

-- FALLING STAR  (workspace.Debris → TP + Remote)
local starActive = false
Tab:CreateToggle({
    Name = "Auto Collect: Falling Stars ⭐",
    CurrentValue = false,
    Flag = "AutoStar",
    Callback = function(state)
        starActive = state
        if state then
            task.spawn(function()
                while starActive do
                    pcall(function()
                        local debris = workspace:FindFirstChild("Debris")
                        if debris then
                            for _, item in pairs(debris:GetChildren()) do
                                -- TP zum Item
                                if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                                    LP.Character.HumanoidRootPart.CFrame = item.CFrame + Vector3.new(0, 3, 0)
                                end
                                task.wait(0.1)
                                -- Remote feuern
                                RF:InvokeServer("3933b2916067426ca5d8b3475c8529f7")
                                task.wait(0.2)
                            end
                        end
                    end)
                    task.wait(collectInterval)
                end
            end)
        end
    end,
})

-- METEOR  (TP only, kein Remote bekannt)
local meteorActive = false
Tab:CreateToggle({
    Name = "Auto Collect: Meteors ☄️",
    CurrentValue = false,
    Flag = "AutoMeteor",
    Callback = function(state)
        meteorActive = state
        if state then
            task.spawn(function()
                while meteorActive do
                    pcall(function()
                        local debris = workspace:FindFirstChild("Debris")
                        if debris then
                            for _, item in pairs(debris:GetChildren()) do
                                if item.Name:lower():find("meteor") then
                                    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                                        LP.Character.HumanoidRootPart.CFrame = item.CFrame + Vector3.new(0, 3, 0)
                                    end
                                    task.wait(0.2)
                                end
                            end
                        end
                    end)
                    task.wait(collectInterval)
                end
            end)
        end
    end,
})

-- HONEY  (Remote ohne Argumente)
local honeyActive = false
Tab:CreateToggle({
    Name = "Auto Collect: Honey 🍯",
    CurrentValue = false,
    Flag = "AutoHoney",
    Callback = function(state)
        honeyActive = state
        if state then
            task.spawn(function()
                while honeyActive do
                    pcall(function()
                        RF:InvokeServer()
                    end)
                    task.wait(collectInterval)
                end
            end)
        end
    end,
})
