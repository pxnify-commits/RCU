-- Warten auf das UI
repeat task.wait() until getgenv().FarmHub and getgenv().FarmHub.CoreLoaded == true

local Tab = getgenv().FarmHub.Tabs.Eggs
local RS = game:GetService("ReplicatedStorage")
local LP = game:GetService("Players").LocalPlayer

local autoHatch = false
local selectedEgg = "200M"
local hatchDelay = 0.5

-- 1. UI ELEMENTE
Tab:CreateSection("🥚 Verified Hatcher")

Tab:CreateDropdown({
    Name = "Select Egg",
    Options = {"200M", "Forest", "Desert"}, 
    CurrentOption = {"200M"},
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
    CurrentValue = 0.5,
    Callback = function(v) hatchDelay = v end
})

-- 2. DIE FUNKTIONIERENDE LOGIK (An DuckyScriptz angelehnt)
task.spawn(function()
    local botName = "jag k\195\164nner en bot, hon heter anna, anna heter hon"
    local KnitServices = RS:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services")
    
    -- Wir suchen die ECHTE Remote durch Validierung der Parents
    local function getFunctionalRemote()
        for _, service in ipairs(KnitServices:GetChildren()) do
            if service.Name == botName then
                local re = service:FindFirstChild("RE")
                if re then
                    local remote = re:FindFirstChild(botName)
                    -- Ein echter Knit-Service hat meistens diese Struktur
                    if remote and remote:IsA("RemoteEvent") then
                        return remote
                    end
                end
            end
        end
        return nil
    end

    local Remote = getFunctionalRemote()

    while true do
        if autoHatch and selectedEgg ~= "" and Remote then
            pcall(function()
                -- DuckyScriptz nutzt oft den Direktanruf mit den geloggten IDs
                -- Wir feuern den Namen und den Token (2026425) direkt hintereinander
                Remote:FireServer(selectedEgg, 2)
                
                -- Falls das Spiel einen Token-Check hat (wie in deinem Bild 10011):
                Remote:FireServer("2026425", 1)
            end)
        end
        task.wait(hatchDelay)
    end
end)
