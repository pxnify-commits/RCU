-- Warten auf das UI
repeat task.wait() until getgenv().FarmHub and getgenv().FarmHub.CoreLoaded == true

local Tab = getgenv().FarmHub.Tabs.Eggs
local RS = game:GetService("ReplicatedStorage")

local autoHatch = false
local selectedEgg = "200M"
local hatchDelay = 0.3

-- 1. EIER-LISTE LADEN
local function getEggList()
    local names = {}
    local success, data = pcall(function()
        return require(RS:WaitForChild("Shared"):WaitForChild("List"):WaitForChild("Pets"):WaitForChild("Eggs"))
    end)
    if success and type(data) == "table" then
        for eggName, _ in pairs(data) do table.insert(names, tostring(eggName)) end
    else
        names = {"200M", "Forest"} 
    end
    table.sort(names)
    return names
end

-- 2. UI
Tab:CreateSection("🥚 Multi-Remote Hatcher")
local Dropdown = Tab:CreateDropdown({
    Name = "Select Egg",
    Options = getEggList(),
    CurrentOption = {selectedEgg},
    Callback = function(opt) selectedEgg = opt[1] end
})

Tab:CreateToggle({
    Name = "Auto Hatch",
    Callback = function(v) autoHatch = v end
})

-- 3. DER FIX: SCANNE ALLE ORDNER UND FEUERE ALLE REMOTES
task.spawn(function()
    local botName = "jag k\195\164nner en bot, hon heter anna, anna heter hon"
    local KnitServices = RS:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services")
    local ValidRemotes = {}

    print("🔍 Suche nach allen Remotes in der Ordner-Flut...")

    -- Wir suchen alle möglichen Remotes und speichern sie in einer Tabelle
    for _, folder in ipairs(KnitServices:GetChildren()) do
        if folder.Name == botName then
            local reFolder = folder:FindFirstChild("RE")
            if reFolder then
                local remote = reFolder:FindFirstChild(botName)
                if remote and remote:IsA("RemoteEvent") then
                    table.insert(ValidRemotes, remote)
                end
            end
        end
    end

    print("✅ " .. #ValidRemotes .. " mögliche Remotes gefunden. Starte Multi-Fire...")

    -- Endlos-Loop
    while true do
        if autoHatch and selectedEgg ~= "" then
            -- Wir gehen JEDE gefundene Remote durch und feuern sie
            for _, remote in ipairs(ValidRemotes) do
                pcall(function()
                    -- Hier nutzen wir die Argumente aus deinem SimpleSpy Log
                    remote:FireServer(selectedEgg, 1)
                end)
            end
        end
        task.wait(hatchDelay)
    end
end)
