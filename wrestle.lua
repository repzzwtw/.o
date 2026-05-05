-- services
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local ts = game:GetService("TeleportService")
local uis = game:GetService("UserInputService")
local vim = game:GetService("VirtualInputManager")
local rep = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local lp = plrs.LocalPlayer

-- globals
_G.HitboxSize = 5
_G.HitboxEnabled = false
_G.ThemeColor = Color3.fromRGB(139, 0, 0) -- Dark Red Theme
_G.ESP = false
_G.InfJ = false
_G.Noclip = false
_G.AutoClick = false
_G.DmgMult = false
_G.DmgVal = 1
_G.SpamTag = false
_G.SpamCheer = false
_G.SpamB = false
_G.SpamDeserve = false
_G.SpamAwesome = false

-- hook (Damage multiplier)
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if method == "FireServer" then
        local req = tostring(self)
        if _G.DmgMult and (req:find("Damage") or req:find("Hit")) then
            for _ = 1, (_G.DmgVal - 1) do 
                old(self, unpack(args)) 
            end
        end
    end
    return old(self, ...)
end)

-- clicker thread
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoClick then
            vim:SendMouseButtonEvent(0,0,0,true,game,0)
            task.wait(0.05)
            vim:SendMouseButtonEvent(0,0,0,false,game,0)
        end
    end
end)

-- ui init (Obsidian)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "WRESTLE!",
    Footer = "made by repz, .gg/mVRWynJVCx for more scripts",
    Icon = 119294576535598,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

-- tabs 
local Tabs = {
    Main = Window:AddTab("Main", "star"),
    Wrestling = Window:AddTab("Wrestling", "sword"),
    Troll = Window:AddTab("Troll", "smile"),
    Local = Window:AddTab("Local", "user"),
    Scripts = Window:AddTab("Scripts", "file"),
    Settings = Window:AddTab("Settings", "settings"),
    Credits = Window:AddTab("Credits", "award")
}

-- groupboxes
local CombatBox = Tabs.Main:AddLeftGroupbox("Combat", "swords")
local ESPBox = Tabs.Main:AddRightGroupbox("Hitbox & ESP", "eye")
local MoveBox = Tabs.Main:AddLeftGroupbox("Movement", "navigation")

local WresBox = Tabs.Wrestling:AddLeftGroupbox("Movesets (No Purchase Needed)", "sword")
local PropBox = Tabs.Wrestling:AddRightGroupbox("Cosmetics & Props", "shirt")

local InteractBox = Tabs.Troll:AddLeftGroupbox("Interactions", "users")
local CrowdBox = Tabs.Troll:AddRightGroupbox("Crowd Sound Spam", "volume-2")

local LocalBox = Tabs.Local:AddLeftGroupbox("Player Adjustments", "user")
local ScriptsBox = Tabs.Scripts:AddLeftGroupbox("Useful Scripts", "file")
local SettingsBox = Tabs.Settings:AddLeftGroupbox("UI & Server Configuration", "settings")
local CreditsGroupBox = Tabs.Credits:AddLeftGroupbox("Credits", "award")

-- MAIN TAB (Combat)
CombatBox:AddToggle("AutoClick", {
    Text = "Universal Autoclicker",
    Default = false,
    Callback = function(Value) _G.AutoClick = Value end
})

CombatBox:AddToggle("DmgMulti", {
    Text = "Damage Multiplier",
    Default = false,
    Callback = function(Value) _G.DmgMult = Value end
})

CombatBox:AddInput("DmgValue", {
    Text = "Multiplier Amount",
    Default = "1",
    Numeric = true,
    Finished = true,
    Placeholder = "Enter Multiplier",
    Callback = function(Value) _G.DmgVal = tonumber(Value) or 1 end
})

-- MAIN TAB (Hitbox & ESP)
ESPBox:AddToggle("HitboxEnabled", {
    Text = "Enable Hitbox",
    Default = false,
    Callback = function(Value)
        _G.HitboxEnabled = Value
        for _, v in pairs(plrs:GetPlayers()) do
            if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = v.Character.HumanoidRootPart
                if Value then
                    hrp.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                    hrp.Transparency = 0.7
                    hrp.Color = _G.ThemeColor
                    hrp.CanCollide = false
                else
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                end
            end
        end
    end
})

ESPBox:AddInput("HitboxSize", {
    Text = "Hitbox Size",
    Default = "5",
    Numeric = true,
    Finished = true,
    Placeholder = "Enter Size",
    Callback = function(Value)
        _G.HitboxSize = tonumber(Value) or 5
        if _G.HitboxEnabled then
            for _, v in pairs(plrs:GetPlayers()) do
                if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    v.Character.HumanoidRootPart.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                end
            end
        end
    end
})

ESPBox:AddToggle("ESPEnabled", {
    Text = "Dark Red ESP",
    Default = false,
    Callback = function(Value) _G.ESP = Value end
})

-- MAIN TAB (Movement)
MoveBox:AddToggle("InfJumpToggle", {
    Text = "Infinite Jump",
    Default = false,
    Callback = function(Value) _G.InfJ = Value end
})

MoveBox:AddToggle("NoclipToggle", {
    Text = "Noclip",
    Default = false,
    Callback = function(Value) _G.Noclip = Value end
})

-- WRESTLING TAB
WresBox:AddDropdown("TagFinisher", {
    Values = {"3D", "Assassination", "BTETrigger", "ChokeslamSpinebuster", "ClaymoreZigZag", "DeathDrop", "Doomsday", "DoubleChokeslam", "DoubleSuperkick", "ExtremeCombination", "F5RKO", "HighFlyingCombo", "MagicKiller", "MeltzerDriver", "ShatterMachine", "SkullCrushingFinale", "SuperkickParty"},
    Default = 1, Multi = false, Text = "Change tag team finishers",
    Callback = function(Value) pcall(function() rep.Events.ChangeTeamFinisher:FireServer(Value) end) end
})

WresBox:AddDropdown("SoloFinisher", {
    Values = {"AnnouncersTableFrogSplash"},
    Default = 1, Multi = false, Text = "Change solo finisher",
    Callback = function(Value) pcall(function() rep.Events.ChangeFinisher:FireServer(Value) end) end
})

PropBox:AddDropdown("EmoteSelect", {
    Values = {"angry", "backflip", "beast", "boom", "bow", "cheer", "chestbeat", "chicken", "confused", "coolwalk", "cry", "dance1", "dance2", "dance3", "dance4", "evilvillian", "flex1", "flex2", "flex3", "floss", "golfswing", "guitar", "headstand", "hype", "kick", "laugh", "loser", "lunge", "nod", "point", "poplock", "pose1", "pose2", "pose3", "pose4", "pose5", "pushups", "robot", "salute", "shrug", "sit", "sleep", "smug", "spiderman", "splits", "stomp", "tpose", "wave", "workout", "yawn", "yes"},
    Default = 1, Multi = false, Text = "Equip Emote",
    Callback = function(Value) pcall(function() rep.Events.PlayEmote:FireServer(Value) end) end
})

PropBox:AddDropdown("PropSelect", {
    Values = {"NewsShow", "Playground", "Throne", "Graveyard", "Podium", "Couch", "HospitalBed", "Coffin", "LockerRoom", "InterviewSet", "Ambulance", "PoliceCar", "Barricade", "Casket", "Chair", "Desk", "Dumpster", "Forklift", "Ladder", "Table", "TrashCan", "Wheelchair"},
    Default = 1, Multi = false, Text = "Equip props",
    Callback = function(Value) pcall(function() rep.Events.ChangePromoProp:FireServer(Value) end) end
})

-- TROLL TAB
InteractBox:AddToggle("SpamTagTeam", {
    Text = "Spam-request tag teams",
    Default = false,
    Callback = function(Value)
        _G.SpamTag = Value
        if Value then task.spawn(function()
            while _G.SpamTag do
                for _, p in pairs(plrs:GetPlayers()) do
                    if p ~= lp then pcall(function() rep.Events.SendTagTeamRequest:FireServer(p) end) end
                end
                task.wait(1.5)
            end
        end) end
    end
})

CrowdBox:AddToggle("SpamCheerSnd", {
    Text = "Spam Cheer",
    Default = false,
    Callback = function(Value)
        _G.SpamCheer = Value
        if Value then task.spawn(function()
            while _G.SpamCheer do pcall(function() rep.Events.TriggerCrowdSound:FireServer("C") end) rs.Heartbeat:Wait() end
        end) end
    end
})

CrowdBox:AddToggle("SpamBSnd", {
    Text = "Spam B",
    Default = false,
    Callback = function(Value)
        _G.SpamB = Value
        if Value then task.spawn(function()
            while _G.SpamB do pcall(function() rep.Events.TriggerCrowdSound:FireServer("B") end) rs.Heartbeat:Wait() end
        end) end
    end
})

CrowdBox:AddToggle("SpamDeserveSnd", {
    Text = "Spam You deserve it! Chant",
    Default = false,
    Callback = function(Value)
        _G.SpamDeserve = Value
        if Value then task.spawn(function()
            while _G.SpamDeserve do pcall(function() rep.Events.TriggerCrowdSound:FireServer("you deserve it") end) rs.Heartbeat:Wait() end
        end) end
    end
})

CrowdBox:AddToggle("SpamAwesomeSnd", {
    Text = "Spam This Is Awesome chant",
    Default = false,
    Callback = function(Value)
        _G.SpamAwesome = Value
        if Value then task.spawn(function()
            while _G.SpamAwesome do pcall(function() rep.Events.TriggerCrowdSound:FireServer("this is awesome") end) rs.Heartbeat:Wait() end
        end) end
    end
})

-- LOCAL TAB
LocalBox:AddSlider("WalkSpeed", {
    Text = "WalkSpeed",
    Min = 16, Max = 250, Default = 16, Rounding = 0,
    Callback = function(Value) if lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = Value end end
})

-- SCRIPTS TAB
ScriptsBox:AddButton("Load Dark Dex", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
end)

-- SETTINGS TAB
SettingsBox:AddButton("Serverhop", function()
    local s, res = pcall(function() return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")) end)
    if s then
        for _, srv in pairs(res.data) do
            if srv.playing < srv.maxPlayers and srv.id ~= game.JobId then ts:TeleportToPlaceInstance(game.PlaceId, srv.id) break end
        end
    end
end)

SettingsBox:AddButton("Rejoin Server", function() ts:TeleportToPlaceInstance(game.PlaceId, game.JobId) end)
SettingsBox:AddButton("Unload UI", function() Library:Unload() end)

-- CREDITS TAB
CreditsGroupBox:AddLabel("Made by Repzz & Ross")
CreditsGroupBox:AddLabel("UI Library: Obsidian")

-- SCREEN GUI FPS/UPTIME
local gui = Instance.new("ScreenGui", game.CoreGui)
local info = Instance.new("TextLabel", gui)
info.Size, info.Position = UDim2.new(0, 200, 0, 50), UDim2.new(1, -210, 1, -60)
info.BackgroundTransparency, info.TextSize = 1, 14
info.TextColor3 = _G.ThemeColor
info.TextXAlignment, info.Font = Enum.TextXAlignment.Right, Enum.Font.Code

local st = os.time()
rs.RenderStepped:Connect(function(dt)
    local u = os.time() - st
    info.Text = string.format("FPS: %d | Uptime: %dm %ds", math.floor(1/dt), math.floor(u/60), u%60)
end)

-- ESP & AUTO-HITBOX FOR NEW PLAYERS
local ESPFolder = CoreGui:FindFirstChild("RepzESP") or Instance.new("Folder", CoreGui)
ESPFolder.Name = "RepzESP"

task.spawn(function()
    while task.wait(0.5) do
        for _, v in pairs(plrs:GetPlayers()) do
            if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local char = v.Character
                local hrp = char.HumanoidRootPart

                -- Highlight ESP
                local hl = ESPFolder:FindFirstChild(v.Name .. "_ESP")
                if _G.ESP then
                    if not hl then 
                        hl = Instance.new("Highlight")
                        hl.Name = v.Name .. "_ESP"
                        hl.Parent = ESPFolder
                    end
                    hl.Adornee = char
                    hl.FillColor = _G.ThemeColor
                    hl.OutlineColor = Color3.fromRGB(0, 0, 0)
                    hl.FillTransparency = 0.5
                    hl.OutlineTransparency = 0
                else
                    if hl then hl:Destroy() end
                end
            end
        end
        
        -- Cleanup
        for _, hl in pairs(ESPFolder:GetChildren()) do
            local plrName = string.gsub(hl.Name, "_ESP", "")
            if not plrs:FindFirstChild(plrName) or not _G.ESP then
                hl:Destroy()
            end
        end
    end
end)

-- ENSURE HITBOX APPLIES WHEN PLAYERS RESPAWN
plrs.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        task.wait(1)
        if _G.HitboxEnabled and p ~= lp then
            local hrp = char:WaitForChild("HumanoidRootPart", 5)
            if hrp then
                hrp.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                hrp.Transparency = 0.7
                hrp.Color = _G.ThemeColor
                hrp.CanCollide = false
            end
        end
    end)
end)

-- INFINITE JUMP
uis.JumpRequest:Connect(function()
    if _G.InfJ and lp.Character then
        local humanoid = lp.Character:FindFirstChildOfClass("Humanoid")
        local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
        if humanoid then humanoid:ChangeState("Jumping") end
        if hrp then hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z) end
    end
end)

-- NOCLIP
rs.Stepped:Connect(function()
    if _G.Noclip and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

Library:Notify("Repz Hub Loaded!", 5)
