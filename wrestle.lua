--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

--// EXECUTOR-SAFE CORE GUI
local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

--// CONFIGURATION STATE
local State = {
    HitboxSize = 5,
    HitboxEnabled = false,
    ESPEnabled = false,
    ThemeColor = Color3.fromRGB(128, 0, 128),
    
    AutoClick = false,
    DamageMult = false,
    DamageVal = 1,
    
    InfJump = false,
    Noclip = false,
    WalkSpeed = 16,
    
    Spam = { Tag = false, Cheer = false, Boo = false, Deserve = false, Awesome = false }
}

--// UI LIBRARY LOAD
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lxte/lates-lib/main/Main.lua"))()
local Window = Library:CreateWindow({
    Title = "WRESTLE! | Premium Multi-Tool",
    Theme = "Void", 
    Size = UDim2.fromOffset(570, 370),
    Transparency = 0.2,
    MinimizeKeybind = Enum.KeyCode.LeftAlt,
})

--// TABS
Window:AddTabSection({ Name = "Main", Order = 1 })
Window:AddTabSection({ Name = "Wrestling", Order = 2 })
Window:AddTabSection({ Name = "Visuals", Order = 3 })
Window:AddTabSection({ Name = "Settings", Order = 4 })

--// COMBAT
local CombatTab = Window:AddTab({ Title = "Combat", Section = "Main", Icon = "rbxassetid://11963373994" })
Window:AddToggle({ Title = "Universal Autoclicker", Tab = CombatTab, Callback = function(v) State.AutoClick = v end })
Window:AddToggle({ Title = "Damage Multiplier", Tab = CombatTab, Callback = function(v) State.DamageMult = v end })
Window:AddInput({ Title = "Multiplier Value", Tab = CombatTab, Callback = function(t) State.DamageVal = tonumber(t) or 1 end })

--// MOVEMENT
local MoveTab = Window:AddTab({ Title = "Movement", Section = "Main", Icon = "rbxassetid://11963373994" })
Window:AddSlider({ Title = "WalkSpeed", Tab = MoveTab, MaxValue = 250, Callback = function(v) State.WalkSpeed = v end })
Window:AddToggle({ Title = "Infinite Jump", Tab = MoveTab, Callback = function(v) State.InfJump = v end })
Window:AddToggle({ Title = "Noclip", Tab = MoveTab, Callback = function(v) State.Noclip = v end })

--// WRESTLING & TROLL
local WresTab = Window:AddTab({ Title = "Moves & Spam", Section = "Wrestling", Icon = "rbxassetid://11963373994" })
Window:AddDropdown({ Title = "Tag Finisher", Tab = WresTab, Options = {"3D", "Assassination", "BTETrigger", "ChokeslamSpinebuster", "DoubleSuperkick", "F5RKO", "MagicKiller", "ShatterMachine"}, Callback = function(v) pcall(function() ReplicatedStorage.Events.ChangeTeamFinisher:FireServer(v) end) end })
Window:AddDropdown({ Title = "Emotes", Tab = WresTab, Options = {"angry", "backflip", "beast", "boom", "dance1", "floss", "guitar", "hype", "laugh", "shrug", "tpose"}, Callback = function(v) pcall(function() ReplicatedStorage.Events.PlayEmote:FireServer(v) end) end })
Window:AddToggle({ Title = "Spam Tag Requests", Tab = WresTab, Callback = function(v) State.Spam.Tag = v end })
Window:AddToggle({ Title = "Spam Cheer", Tab = WresTab, Callback = function(v) State.Spam.Cheer = v end })
Window:AddToggle({ Title = "Spam Boo", Tab = WresTab, Callback = function(v) State.Spam.Boo = v end })

--// VISUALS
local VisTab = Window:AddTab({ Title = "Visuals", Section = "Visuals", Icon = "rbxassetid://11963373994" })
Window:AddToggle({ Title = "Hitbox Enabled", Tab = VisTab, Callback = function(v) State.HitboxEnabled = v end })
Window:AddSlider({ Title = "Hitbox Size", Tab = VisTab, MaxValue = 50, Callback = function(v) State.HitboxSize = v end })
Window:AddToggle({ Title = "Player ESP", Tab = VisTab, Callback = function(v) State.ESPEnabled = v end })

--// MOBILE UI
local MobileGui = Instance.new("ScreenGui", CoreGui)
local ToggleBtn = Instance.new("TextButton", MobileGui)
ToggleBtn.Size, ToggleBtn.Position = UDim2.new(0, 50, 0, 50), UDim2.new(0.5, -25, 0.1, 0)
ToggleBtn.BackgroundColor3, ToggleBtn.Text = Color3.fromRGB(15, 15, 15), "UI"
ToggleBtn.TextColor3, ToggleBtn.Font = Color3.fromRGB(200, 200, 200), Enum.Font.GothamBold
ToggleBtn.Draggable, ToggleBtn.Active = true, true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
MobileGui.Enabled = IsMobile

ToggleBtn.MouseButton1Click:Connect(function()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftAlt, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftAlt, false, game)
end)

--// BACKEND LOGIC
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" and State.DamageMult then
        local name = tostring(self)
        if name:find("Damage") or name:find("Hit") then
            for i = 1, (State.DamageVal - 1) do oldNamecall(self, ...) end
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

--// MAIN LOOP (Hitbox, ESP, Spam)
task.spawn(function()
    while task.wait(0.1) do
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                local hrp = v.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = State.HitboxEnabled and Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize) or Vector3.new(2, 2, 1)
                    hrp.Transparency = State.HitboxEnabled and 0.7 or 1
                    hrp.CanCollide = false
                end
                
                local hl = v.Character:FindFirstChild("PremiumESP")
                if State.ESPEnabled then
                    if not hl then hl = Instance.new("Highlight", v.Character); hl.Name = "PremiumESP"; hl.FillColor = State.ThemeColor end
                elseif hl then hl:Destroy() end
            end
        end
        
        if State.AutoClick then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.02)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
        
        if State.Spam.Tag then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then pcall(function() ReplicatedStorage.Events.SendTagTeamRequest:FireServer(p) end) end
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = State.WalkSpeed
        if State.Noclip then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if State.InfJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

Window:Notify({ Title = "WRESTLE! Loaded", Description = "All features active.", Duration = 5 })
