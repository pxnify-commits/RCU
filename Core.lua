local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Remote Pfade (Zentralisiert)
local RS = game:GetService("ReplicatedStorage")
local BotStr = "jag k\195\164nner en bot, hon heter anna, anna heter hon"
local ServicePath = RS:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild(BotStr)

getgenv().FarmHub.RE = ServicePath:WaitForChild("RE"):WaitForChild(BotStr)
getgenv().FarmHub.RF = ServicePath:WaitForChild("RF"):WaitForChild(BotStr)

-- Fenster Erstellung
getgenv().FarmHub.Window = Rayfield:CreateWindow({
    Name = "RCU Modular Hub",
    LoadingTitle = "Synchronisiere Module...",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- Tabs global verfügbar machen
getgenv().FarmHub.Tabs.Eggs = getgenv().FarmHub.Window:CreateTab("🥚 Eggs")
getgenv().FarmHub.Tabs.Farms = getgenv().FarmHub.Window:CreateTab("🌾 Auto Farms")
getgenv().FarmHub.Tabs.Machines = getgenv().FarmHub.Window:CreateTab("⚙️ Machines")
getgenv().FarmHub.Tabs.Minigames = getgenv().FarmHub.Window:CreateTab("🎮 Minigames")

print("✅ Core geladen")
