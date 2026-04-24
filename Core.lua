-- ==========================================
-- RCU CORE (UI ONLY)
-- ==========================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Fenster erstellen
getgenv().FarmHub.Window = Rayfield:CreateWindow({
    Name = "RCU Modular Hub",
    LoadingTitle = "System Online",
    LoadingSubtitle = "by pxnify",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- Tabs global registrieren
getgenv().FarmHub.Tabs.Eggs = getgenv().FarmHub.Window:CreateTab("🥚 Eggs")
getgenv().FarmHub.Tabs.Farms = getgenv().FarmHub.Window:CreateTab("🌾 Auto Farms")
getgenv().FarmHub.Tabs.Machines = getgenv().FarmHub.Window:CreateTab("⚙️ Machines")
getgenv().FarmHub.Tabs.Minigames = getgenv().FarmHub.Window:CreateTab("🎮 Minigames")

-- WICHTIG: Signal an den Loader und die Module senden
getgenv().FarmHub.CoreLoaded = true

print("✅ Core UI Initialized & Ready")
