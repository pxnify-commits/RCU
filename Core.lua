local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

getgenv().FarmHub.Window = Rayfield:CreateWindow({
    Name = "RCU Modular Hub",
    LoadingTitle = "GitHub Sync...",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- Nur die leeren Tabs erstellen
getgenv().FarmHub.Tabs.Eggs = getgenv().FarmHub.Window:CreateTab("🥚 Eggs")
getgenv().FarmHub.Tabs.Farms = getgenv().FarmHub.Window:CreateTab("🌾 Auto Farms")
getgenv().FarmHub.Tabs.Machines = getgenv().FarmHub.Window:CreateTab("⚙️ Machines")
getgenv().FarmHub.Tabs.Minigames = getgenv().FarmHub.Window:CreateTab("🎮 Minigames")

print("✅ Core UI Ready")
