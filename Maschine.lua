-- RCU Modular Hub | Machines Module
repeat task.wait() until getgenv().FarmHub and getgenv().FarmHub.CoreLoaded == true

local RS = game:GetService("ReplicatedStorage")
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

local RF  = AnnaService:WaitForChild("RF"):WaitForChild(AnnaService.Name)
local Tab = getgenv().FarmHub.Tabs["Machines"]

-- ─────────────────────────────────────────────
--  SECTION: STEAMPUNK MACHINE
-- ─────────────────────────────────────────────
Tab:CreateLabel("⚙️  Steampunk Machine  (+1 Egg / 50s)")

local machineList   = {"Steampunk"}  -- erweiterbar
local selMachines   = {}
local machineActive = false

Tab:CreateDropdown({
    Name = "Select Machine",
    Options = machineList,
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "MachineSelect",
    Callback = function(vals)
        selMachines = vals or {}
    end,
})

Tab:CreateToggle({
    Name = "Auto Machine  [every 50s]",
    CurrentValue = false,
    Flag = "AutoMachine",
    Callback = function(state)
        machineActive = state
        if state then
            task.spawn(function()
                while machineActive do
                    for _, name in ipairs(selMachines) do
                        if name == "Steampunk" then
                            pcall(function()
                                RF:InvokeServer("eggsOpen", 1)
                            end)
                        end
                    end
                    local elapsed = 0
                    while machineActive and elapsed < 50 do
                        task.wait(1)
                        elapsed += 1
                    end
                end
            end)
        end
    end,
})

-- ─────────────────────────────────────────────
--  SECTION: LUNAR FORGE
-- ─────────────────────────────────────────────
Tab:CreateLabel("🌙  Lunar Forge  (3× every 3s)")

local forgeTier   = 1
local forgeActive = false

Tab:CreateSlider({
    Name = "Forge Tier",
    Range = {1, 4},
    Increment = 1,
    Suffix = "",
    CurrentValue = forgeTier,
    Flag = "ForgeTier",
    Callback = function(val)
        forgeTier = val
    end,
})

Tab:CreateToggle({
    Name = "Auto Lunar Forge  [3× / 3s]",
    CurrentValue = false,
    Flag = "AutoForge",
    Callback = function(state)
        forgeActive = state
        if state then
            task.spawn(function()
                while forgeActive do
                    for i = 1, 3 do
                        pcall(function()
                            RF:InvokeServer(forgeTier, 1)
                        end)
                        task.wait(0.2)
                    end
                    local elapsed = 0
                    while forgeActive and elapsed < 3 do
                        task.wait(1)
                        elapsed += 1
                    end
                end
            end)
        end
    end,
})
