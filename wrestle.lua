--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

--// STATE CONFIGURATION
local State = {
    Combat = { AutoClick = false, DmgMultEnabled = false, DmgMultVal = 1 },
    Movement = { InfJump = false, Noclip = false },
    Visuals = { Hitbox = false, HitboxSize = 5, ESP = false, Color = Color3.fromRGB(128, 0, 128) },
    Spam = { Tag = false, Cheer = false, Boo = false, Deserve = false, Awesome = false }
}

--// MOBILE TOGGLE GUI
local MobileGui = Instance.new("ScreenGui")
MobileGui.Name = "PremiumMobileToggle"
MobileGui.Parent = CoreGui
MobileGui.Enabled = false

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = MobileGui
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.5, -25, 0.1, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleBtn.Text = "UI"
ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 18
ToggleBtn.Active = true
ToggleBtn.Draggable = true 

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0) 
UICorner.Parent = ToggleBtn

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = State.Visuals.Color 
UIStroke.Thickness = 2
UIStroke.Parent = ToggleBtn

--// ON-SCREEN PERFORMANCE STATS
local StatsGui = Instance.new("ScreenGui", CoreGui)
StatsGui.Name = "PerformanceStats"
local InfoLabel = Instance.new("TextLabel", StatsGui)
InfoLabel.Size = UDim2.new(0, 200, 0, 50)
InfoLabel.Position = UDim2.new(1, -210, 1, -60)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextSize = 14
InfoLabel.TextColor3 = State.Visuals.Color
InfoLabel.TextXAlignment = Enum.TextXAlignment.Right
InfoLabel.Font = Enum.Font.Code
InfoLabel.TextStrokeTransparency = 0.5

local StartTime = os.time()
RunService.RenderStepped:Connect(function(dt)
    local uptime = os.time() - StartTime
    InfoLabel.Text = string.format("FPS: %d | Uptime: %dm %ds", math.floor(1 / dt), math.floor(uptime / 60), uptime % 60)
end)

--// LIBRARY INITIALIZATION
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lxte/lates-lib/main/Main.lua"))()
local Window = Library:CreateWindow({
    Title = "WRESTLE! | Premium Multi-Tool",
    Theme = "Void", 
    Size = UDim2.fromOffset(570, 370),
    Transparency = 0.2,
    Blurring = true,
    MinimizeKeybind = Enum.KeyCode.LeftAlt,
})

local Themes = {
    Light = { Primary = Color3.fromRGB(232, 232, 232), Secondary = Color3.fromRGB(255, 255, 255), Component = Color3.fromRGB(245, 245, 245), Interactables = Color3.fromRGB(235, 235, 235), Tab = Color3.fromRGB(50, 50, 50), Title = Color3.fromRGB(0, 0, 0), Description = Color3.fromRGB(100, 100, 100), Shadow = Color3.fromRGB(255, 255, 255), Outline = Color3.fromRGB(210, 210, 210), Icon = Color3.fromRGB(100, 100, 100) },
    Dark = { Primary = Color3.fromRGB(30, 30, 30), Secondary = Color3.fromRGB(35, 35, 35), Component = Color3.fromRGB(40, 40, 40), Interactables = Color3.fromRGB(45, 45, 45), Tab = Color3.fromRGB(200, 200, 200), Title = Color3.fromRGB(240,240,240), Description = Color3.fromRGB(200,200,200), Shadow = Color3.fromRGB(0, 0, 0), Outline = Color3.fromRGB(40, 40, 40), Icon = Color3.fromRGB(220, 220, 220) },
    Void = { Primary = Color3.fromRGB(15, 15, 15), Secondary = Color3.fromRGB(20, 20, 20), Component = Color3.fromRGB(25, 25, 25), Interactables = Color3.fromRGB(30, 30, 30), Tab = Color3.fromRGB(200, 200, 200), Title = Color3.fromRGB(240,240,240), Description = Color3.fromRGB(200,200,200), Shadow = Color3.fromRGB(0, 0, 0), Outline = Color3.fromRGB(40, 40, 40), Icon = Color3.fromRGB(220, 220, 220) },
}

Window:SetTheme(Themes.Void) 

--// TAB SECTIONS
Window:AddTabSection({ Name = "Main", Order = 1 })
Window:AddTabSection({ Name = "Utility", Order = 2 })
Window:AddTabSection({ Name = "Visuals", Order = 3 })
Window:AddTabSection({ Name = "Settings", Order = 4 })

--// COMBAT TAB
local CombatTab = Window:AddTab({ Title = "Combat", Section = "Main", Icon = "rbxassetid://11963373994" })
Window:AddSection({ Name = "Abilities", Tab = CombatTab })
Window:AddToggle({ Title = "Universal Autoclicker", Description = "Automatically clicks for you", Tab = CombatTab, Callback = function(v) State.Combat.AutoClick = v end })
Window:AddToggle({ Title = "Damage Multiplier", Description = "Increases damage output", Tab = CombatTab, Callback = function(v) State.Combat.DmgMultEnabled = v end })
Window:AddInput({ Title = "Multiplier Amount", Description = "How many times to multiply damage", Tab = CombatTab, Callback = function(txt) State.Combat.DmgMultVal = tonumber(txt) or 1 end })

--// MOVEMENT TAB
local MoveTab = Window:AddTab({ Title = "Movement", Section = "Main", Icon = "rbxassetid://11963373994" })
Window:AddSlider({ Title = "WalkSpeed", Description = "Adjust your speed", Tab = MoveTab, MaxValue = 250, Callback = function(v) if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = v end end })
Window:AddToggle({ Title = "Infinite Jump", Description = "Jump as many times as you want", Tab = MoveTab, Callback = function(v) State.Movement.InfJump = v end })
Window:AddToggle({ Title = "Noclip", Description = "Walk through walls", Tab = MoveTab, Callback = function(v) State.Movement.Noclip = v end })

--// WRESTLING TAB (Utility)
local WresTab = Window:AddTab({ Title = "Wrestling", Section = "Utility", Icon = "rbxassetid://11963373994" })
Window:AddSection({ Name = "Movesets & Animations", Tab = WresTab })
Window:AddDropdown({ Title = "Tag Team Finisher", Description = "Equip tag finishers (No purchase needed)", Tab = WresTab, Options = {"3D", "Assassination", "BTETrigger", "ChokeslamSpinebuster", "ClaymoreZigZag", "DeathDrop", "Doomsday", "DoubleChokeslam", "DoubleSuperkick", "ExtremeCombination", "F5RKO", "HighFlyingCombo", "MagicKiller", "MeltzerDriver", "ShatterMachine", "SkullCrushingFinale", "SuperkickParty"}, Callback = function(val) pcall(function() ReplicatedStorage.Events.ChangeTeamFinisher:FireServer(val) end) end })
Window:AddDropdown({ Title = "Solo Finisher", Description = "Equip solo finishers", Tab = WresTab, Options = {"AnnouncersTableFrogSplash"}, Callback = function(val) pcall(function() ReplicatedStorage.Events.ChangeFinisher:FireServer(val) end) end })
Window:AddDropdown({ Title = "Emotes", Description = "Play custom animations", Tab = WresTab, Options = {"angry", "backflip", "beast", "boom", "bow", "cheer", "chestbeat", "chicken", "confused", "coolwalk", "cry", "dance1", "dance2", "dance3", "dance4", "evilvillian", "flex1", "flex2", "flex3", "floss", "golfswing", "guitar", "headstand", "hype", "kick", "laugh", "loser", "lunge", "nod", "point", "poplock", "pose1", "pose2", "pose3", "pose4", "pose5", "pushups", "robot", "salute", "shrug", "sit", "sleep", "smug", "spiderman", "splits", "stomp", "tpose", "wave", "workout", "yawn", "yes"}, Callback = function(val) pcall(function() ReplicatedStorage.Events.PlayEmote:FireServer(val) end) end })
Window:AddDropdown({ Title = "Equip Props", Description = "Spawn cosmetic items", Tab = WresTab, Options = {"NewsShow", "Playground", "Throne", "Graveyard", "Podium", "Couch", "HospitalBed", "Coffin", "LockerRoom", "InterviewSet", "Ambulance", "PoliceCar", "Barricade", "Casket", "Chair", "Desk", "Dumpster", "Forklift", "Ladder", "Table", "TrashCan", "Wheelchair"}, Callback = function(val) pcall(function() ReplicatedStorage.Events.ChangePromoProp:FireServer(val) end) end })

--// TROLL TAB (Utility)
local TrollTab = Window:AddTab({ Title = "Troll / Spam", Section = "Utility", Icon = "rbxassetid://11963373994" })
Window:AddSection({ Name = "Server Disruptions", Tab = TrollTab })
Window:AddToggle({ Title = "Spam Tag-Team Requests", Description = "Mass request all players", Tab = TrollTab, Callback = function(v) State.Spam.Tag = v end })
Window:AddToggle({ Title = "Spam Cheer Sound", Description = "Triggers global cheer", Tab = TrollTab, Callback = function(v) State.Spam.Cheer = v end })
Window:AddToggle({ Title = "Spam Boo Sound", Description = "Triggers global boo", Tab = TrollTab, Callback = function(v) State.Spam.Boo = v end })
Window:AddToggle({ Title = "Spam 'Deserve It' Chant", Description = "Triggers crowd chant", Tab = TrollTab, Callback = function(v) State.Spam.Deserve = v end })
Window:AddToggle({ Title = "Spam 'Awesome' Chant", Description = "Triggers crowd chant", Tab = TrollTab, Callback = function(v) State.Spam.Awesome = v end })

--// SCRIPTS TAB (Utility)
local ScriptsTab = Window:AddTab({ Title = "External Scripts", Section = "Utility", Icon = "rbxassetid://11963373994" })
Window:AddButton({ Title = "Load Dark Dex", Description = "Advanced game explorer", Tab = ScriptsTab, Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end })

--// VISUALS TAB
local VisualsTab = Window:AddTab({ Title = "Visuals", Section = "Visuals", Icon = "rbxassetid://11963373994" })
Window:AddSection({ Name = "Hitbox & ESP", Tab = VisualsTab })
Window:AddToggle({ Title = "Enable Hitbox", Description = "Expands enemy hitboxes", Tab = VisualsTab, Callback = function(v) State.Visuals.Hitbox = v end })
Window:AddSlider({ Title = "Hitbox Size", Description = "Size of the expanded hitbox", Tab = VisualsTab, MaxValue = 50, Callback = function(v) State.Visuals.HitboxSize = v end })
Window:AddToggle({ Title = "Player ESP", Description = "See players through walls", Tab = VisualsTab, Callback = function(v) State.Visuals.ESP = v end })

--// SETTINGS TAB
local SettingsTab = Window:AddTab({ Title = "Settings", Section = "Settings", Icon = "rbxassetid://11293977610" })
Window:AddSection({ Name = "Interface Configurations", Tab = SettingsTab })
Window:AddKeybind({ Title = "Minimize Keybind", Description = "Set key to open/close menu", Tab = SettingsTab, Callback = function(Key) Window:SetSetting("Keybind", Key) end })
Window:AddDropdown({ Title = "Set Theme", Description = "Change the UI appearance", Tab = SettingsTab, Options = { ["Light Mode"] = "Light", ["Dark Mode"] = "Dark", ["Pitch Black"] = "Void" }, Callback = function(Theme) Window:SetTheme(Themes[Theme]) end })
Window:AddDropdown({ Title = "Mobile Button Size", Description = "Adjust circular toggle size", Tab = SettingsTab, Options = { ["Small"] = 35, ["Medium (Default)"] = 50, ["Large"] = 65, ["Extra Large"] = 80 }, Callback = function(SizeValue) ToggleBtn.Size = UDim2.new(0, SizeValue, 0, SizeValue); ToggleBtn.TextSize = math.floor(SizeValue * 0.35) end })

Window:AddSection({ Name = "Server Actions", Tab = SettingsTab })
Window:AddButton({ Title = "Serverhop", Description = "Finds a different server", Tab = SettingsTab, Callback = function()
    local s, res = pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")) end)
    if s and res and res.data then
        for _, srv in pairs(res.data) do
            if srv.playing < srv.maxPlayers and srv.id ~= game.JobId then TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id) break end
        end
    end
end})
Window:AddButton({ Title = "Rejoin Server", Description = "Reconnects to current lobby", Tab = SettingsTab, Callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId) end })

--// CUSTOM TOPBAR / MOBILE OVERRIDE
task.spawn(function()
    task.wait(1) 
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui:FindFirstChild("Main") then
            local topbar = gui.Main:FindFirstChild("Topbar") or gui.Main:FindFirstChild("Header")
            if topbar then
                local controls = topbar:FindFirstChild("Controls") or topbar:FindFirstChild("Buttons")
                if controls then
                    controls.AnchorPoint = Vector2.new(1, 0.5)
                    controls.Position = UDim2.new(1, -10, 0.5, 0)
                    
                    local icons = {" X ", " - ", " [ ] "}
                    for idx, child in ipairs(controls:GetChildren()) do
                        if child:IsA("Frame") or child:IsA("TextButton") then
                            child.BackgroundColor3 = Color3.fromRGB(15, 15, 15) 
                            local btnTxt = Instance.new("TextLabel", child)
                            btnTxt.Size = UDim2.new(1, 0, 1, 0)
                            btnTxt.BackgroundTransparency = 1
                            btnTxt.Text = icons[idx] or ""
                            btnTxt.TextColor3 = Color3.fromRGB(200, 200, 200)
                            btnTxt.Font = Enum.Font.GothamBold
                            
                            if idx == 2 then
                                local clicker = child:FindFirstChildOfClass("TextButton") or child
                                clicker.MouseButton1Click:Connect(function()
                                    if IsMobile then
                                        MobileGui.Enabled = true
                                    else
                                        Window:Notify({Title = "UI Minimized", Description = "Press your Minimize Keybind to Re-open.", Duration = 4})
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    MobileGui.Enabled = false
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftAlt, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftAlt, false, game)
end)

--// CORE HOOKS & EXPLOITS
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "FireServer" and State.Combat.DmgMultEnabled then
        local name = self.Name
        if name:find("Damage") or name:find("Hit") or name:find("Attack") then
            for i = 1, (State.Combat.DmgMultVal - 1) do
                oldNamecall(self, unpack(args))
            end
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

--// BACKGROUND LOOPS
task.spawn(function()
    while task.wait(0.1) do
        -- Combat Loop
        if State.Combat.AutoClick then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.05)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
        
        -- Troll/Spam Event Dispatchers
        local evt = ReplicatedStorage:FindFirstChild("Events")
        if evt then
            if State.Spam.Tag then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer then pcall(function() evt.SendTagTeamRequest:FireServer(p) end) end
                end
                task.wait(1.5) -- Throttled tag requests to avoid kicks
            end
            if State.Spam.Cheer then pcall(function() evt.TriggerCrowdSound:FireServer("C") end) end
            if State.Spam.Boo then pcall(function() evt.TriggerCrowdSound:FireServer("B") end) end
            if State.Spam.Deserve then pcall(function() evt.TriggerCrowdSound:FireServer("you deserve it") end) end
            if State.Spam.Awesome then pcall(function() evt.TriggerCrowdSound:FireServer("this is awesome") end) end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = v.Character.HumanoidRootPart
                
                -- Hitbox
                if State.Visuals.Hitbox then
                    hrp.Size = Vector3.new(State.Visuals.HitboxSize, State.Visuals.HitboxSize, State.Visuals.HitboxSize)
                    hrp.Transparency = 0.7
                    hrp.Color = State.Visuals.Color
                    hrp.CanCollide = false
                else
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                end
                
                -- ESP Highlighting
                local highlight = v.Character:FindFirstChild("PremiumESP")
                if State.Visuals.ESP then
                    if not highlight then 
                        highlight = Instance.new("Highlight", v.Character)
                        highlight.Name = "PremiumESP"
                        highlight.FillColor = State.Visuals.Color
                        highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
                        highlight.FillTransparency = 0.5
                    end
                elseif highlight then 
                    highlight:Destroy() 
                end
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if State.Movement.InfJump and LocalPlayer.Character then 
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.Stepped:Connect(function()
    if State.Movement.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

Window:Notify({ Title = "Premium Load Complete", Description = IsMobile and "Mobile UI active. Use the top bar to minimize." or "Press Left Alt to toggle UI", Duration = 5 })
