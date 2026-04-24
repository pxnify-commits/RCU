-- RCU Modular Hub | Minigames Module
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
local Tab = getgenv().FarmHub.Tabs["Minigames"]

-- ─────────────────────────────────────────────
--  FROZEN TREASURE
-- ─────────────────────────────────────────────
Tab:CreateLabel("❄️  Frozen Treasure")

local frozenModes   = {"normal", "hard", "extreme"}
local selectedMode  = "normal"
local frozenActive  = false
local frozenDelay   = 5

Tab:CreateDropdown({
    Name = "Difficulty",
    Options = frozenModes,
    CurrentOption = {"normal"},
    Flag = "FrozenMode",
    Callback = function(val)
        selectedMode = (type(val) == "table" and val[1]) or val or "normal"
    end,
})

Tab:CreateSlider({
    Name = "Repeat Delay (seconds)",
    Range = {1, 30},
    Increment = 1,
    Suffix = "s",
    CurrentValue = frozenDelay,
    Flag = "FrozenDelay",
    Callback = function(val)
        frozenDelay = val
    end,
})

Tab:CreateToggle({
    Name = "Auto Frozen Treasure",
    CurrentValue = false,
    Flag = "AutoFrozen",
    Callback = function(state)
        frozenActive = state
        if state then
            task.spawn(function()
                while frozenActive do
                    pcall(function()
                        RF:InvokeServer(selectedMode)
                    end)
                    local elapsed = 0
                    while frozenActive and elapsed < frozenDelay do
                        task.wait(1)
                        elapsed += 1
                    end
                end
            end)
        end
    end,
})
