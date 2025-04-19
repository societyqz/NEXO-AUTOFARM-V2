-- Adonis Anti-Cheat Bypass (Runs First)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua", true))()

-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "NEXO AUTOFARM V2",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "AutoFarm v2 By Sqci",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "AutoFarmConfig"
    },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main", "rewind")

local selectedPlayer = nil
local tracking = false
local forwardOffset = 5
local horizontalOffset = 0

-- Dropdown: Select Player
local playerDropdown = MainTab:CreateDropdown({
    Name = "Select Player to Track",
    Options = {},
    CurrentOption = {},
    Flag = "SelectedPlayer",
    Callback = function(Options)
        selectedPlayer = Options[1]
    end,
})

-- Update dropdown with players
local function UpdatePlayerList()
    local players = game:GetService("Players"):GetPlayers()
    local names = {}
    for _, p in ipairs(players) do
        if p.Name ~= game.Players.LocalPlayer.Name then
            table.insert(names, p.Name)
        end
    end
    playerDropdown:Refresh(names)
end

UpdatePlayerList()
game:GetService("Players").PlayerAdded:Connect(UpdatePlayerList)
game:GetService("Players").PlayerRemoving:Connect(UpdatePlayerList)

-- Slider: Move Left to Right
MainTab:CreateSlider({
    Name = "Move Left To Right",
    Range = {-10, 10},
    Increment = 0.5,
    CurrentValue = 0,
    Flag = "LeftRightOffset",
    Callback = function(Value)
        horizontalOffset = Value
    end,
})

-- Slider: Distance
MainTab:CreateSlider({
    Name = "Distance",
    Range = {2, 20},
    Increment = 1,
    CurrentValue = 5,
    Flag = "ForwardOffset",
    Callback = function(Value)
        forwardOffset = Value
    end,
})

-- Toggle: Autofarm
MainTab:CreateToggle({
    Name = "Autofarm",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(Value)
        tracking = Value
        if tracking and selectedPlayer then
            Rayfield:Notify({
                Title = "Autofarm Enabled",
                Content = "Now tracking: " .. selectedPlayer,
                Duration = 5,
                Image = "target"
            })
        end
    end,
})

-- Movement loop
game:GetService("RunService").Heartbeat:Connect(function()
    if tracking and selectedPlayer then
        local player = game.Players:FindFirstChild(selectedPlayer)
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = player.Character.HumanoidRootPart
            local localHRP = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if localHRP then
                local forward = targetHRP.CFrame.LookVector
                local right = targetHRP.CFrame.RightVector
                local targetPosition = targetHRP.Position + forward * forwardOffset + right * horizontalOffset
                localHRP.CFrame = CFrame.new(targetPosition, targetHRP.Position + forward)
            end
        end
    end
end)