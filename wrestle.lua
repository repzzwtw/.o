local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "*UPD* | WRESTLE! | Roblox Wrestling",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "made by repz lol",
    ConfigurationSaving = {Enabled = true, FolderName = "WrestleScript", FileName = "Config"},
    KeySystem = false
})

-- globals
_G.HitboxSize = 5; _G.HitboxEnabled = false; _G.HitboxColor = Color3.fromRGB(128, 0, 128)
_G.ESP = false; _G.InfJ = false; _G.Noclip = false; _G.AutoClick = false
_G.DmgMult = false; _G.DmgVal = 1
_G.SpamTag = false; _G.SpamCheer = false; _G.SpamB = false; _G.SpamDeserve = false; _G.SpamAwesome = false

-- services
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local ts = game:GetService("TeleportService")
local uis = game:GetService("UserInputService")
local vim = game:GetService("VirtualInputManager")
local rep = game:GetService("ReplicatedStorage")
local lp = plrs.LocalPlayer

-- hook
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "FireServer" then
        local req = tostring(self)
        if req:find("Purchase") or req:find("Buy") then return end -- bypass buy checks
        
        if _G.DmgMult and (req:find("Damage") or req:find("Hit")) then
            for i = 1, (_G.DmgVal - 1) do old(self, unpack(args)) end
        end
    end
    return old(self, ...)
end)

-- clicker
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoClick then
            vim:SendMouseButtonEvent(0,0,0,true,game,0)
            task.wait(0.05)
            vim:SendMouseButtonEvent(0,0,0,false,game,0)
        end
    end
end)

-- tabs
local Main = Window:CreateTab("Main")
local Wres = Window:CreateTab("Wrestling / Cosmetics")
local Troll = Window:CreateTab("Troll")
local Lcl = Window:CreateTab("Local")
local Scripts = Window:CreateTab("Useful scripts")
local Set = Window:CreateTab("Settings")

-- main tab
Main:CreateSection("Combat")
Main:CreateToggle({Name = "Universal Autoclicker", CurrentValue = false, Callback = function(v) _G.AutoClick = v end})
Main:CreateToggle({Name = "Damage Multiplier", CurrentValue = false, Callback = function(v) _G.DmgMult = v end})
Main:CreateInput({Name = "Multiplier Amount", PlaceholderText = "Enter Multiplier", Callback = function(v) _G.DmgVal = tonumber(v) or 1 end})

Main:CreateSection("Hitbox & ESP")
Main:CreateToggle({Name = "Enable Hitbox", CurrentValue = false, Callback = function(v) _G.HitboxEnabled = v end})
Main:CreateInput({Name = "Hitbox Size", PlaceholderText = "Enter Number", Callback = function(v) _G.HitboxSize = tonumber(v) or 5 end})
Main:CreateToggle({Name = "Dark Purple ESP", CurrentValue = false, Callback = function(v) _G.ESP = v end})

Main:CreateSection("Movement")
Main:CreateToggle({Name = "Infinite Jump", Callback = function(v) _G.InfJ = v end})
Main:CreateToggle({Name = "Noclip", Callback = function(v) _G.Noclip = v end})

-- wrestling tab
Wres:CreateSection("Movesets (No Purchase Needed)")
Wres:CreateDropdown({
    Name = "Change tag team finishers",
    Options = {"3D", "Assassination", "BTETrigger", "ChokeslamSpinebuster", "ClaymoreZigZag", "DeathDrop", "Doomsday", "DoubleChokeslam", "DoubleSuperkick", "ExtremeCombination", "F5RKO", "HighFlyingCombo", "MagicKiller", "MeltzerDriver", "ShatterMachine", "SkullCrushingFinale", "SuperkickParty"},
    CurrentOption = {"Select Finisher"}, MultipleOptions = false,
    Callback = function(v) pcall(function() rep.Events.ChangeTeamFinisher:FireServer(v[1]) end) end
})

Wres:CreateDropdown({
    Name = "Change solo finisher",
    Options = {"AnnouncersTableFrogSplash"},
    CurrentOption = {"Select Solo Finisher"}, MultipleOptions = false,
    Callback = function(v) pcall(function() rep.Events.ChangeFinisher:FireServer(v[1]) end) end
})

Wres:CreateSection("Cosmetics & Props (No Purchase Needed)")
Wres:CreateDropdown({
    Name = "Equip Emote",
    Options = {"angry", "backflip", "beast", "boom", "bow", "cheer", "chestbeat", "chicken", "confused", "coolwalk", "cry", "dance1", "dance2", "dance3", "dance4", "evilvillian", "flex1", "flex2", "flex3", "floss", "golfswing", "guitar", "headstand", "hype", "kick", "laugh", "loser", "lunge", "nod", "point", "poplock", "pose1", "pose2", "pose3", "pose4", "pose5", "pushups", "robot", "salute", "shrug", "sit", "sleep", "smug", "spiderman", "splits", "stomp", "tpose", "wave", "workout", "yawn", "yes"},
    CurrentOption = {"Select Emote"}, MultipleOptions = false,
    Callback = function(v) pcall(function() rep.Events.PlayEmote:FireServer(v[1]) end) end
})

Wres:CreateDropdown({
    Name = "Equip props",
    Options = {"NewsShow", "Playground", "Throne", "Graveyard", "Podium", "Couch", "HospitalBed", "Coffin", "LockerRoom", "InterviewSet", "Ambulance", "PoliceCar", "Barricade", "Casket", "Chair", "Desk", "Dumpster", "Forklift", "Ladder", "Table", "TrashCan", "Wheelchair"},
    CurrentOption = {"Select Prop"}, MultipleOptions = false,
    Callback = function(v) pcall(function() rep.Events.ChangePromoProp:FireServer(v[1]) end) end
})

-- troll tab
Troll:CreateSection("Interactions")
Troll:CreateToggle({
    Name = "Spam-request tag teams", CurrentValue = false,
    Callback = function(v)
        _G.SpamTag = v
        if v then task.spawn(function()
            while _G.SpamTag do
                for _, p in pairs(plrs:GetPlayers()) do
                    if p ~= lp then pcall(function() rep.Events.SendTagTeamRequest:FireServer(p) end) end
                end
                task.wait(1.5)
            end
        end) end
    end
})

Troll:CreateSection("Crowd Sound Spam")
-- using heartbeat wait so it fires fast as engine allows
Troll:CreateToggle({
    Name = "Spam Cheer", CurrentValue = false,
    Callback = function(v)
        _G.SpamCheer = v
        if v then task.spawn(function()
            while _G.SpamCheer do pcall(function() rep.Events.TriggerCrowdSound:FireServer("C") end) rs.Heartbeat:Wait() end
        end) end
    end
})

Troll:CreateToggle({
    Name = "Spam B", CurrentValue = false,
    Callback = function(v)
        _G.SpamB = v
        if v then task.spawn(function()
            while _G.SpamB do pcall(function() rep.Events.TriggerCrowdSound:FireServer("B") end) rs.Heartbeat:Wait() end
        end) end
    end
})

Troll:CreateToggle({
    Name = "Spam You deserve it! Chant", CurrentValue = false,
    Callback = function(v)
        _G.SpamDeserve = v
        if v then task.spawn(function()
            while _G.SpamDeserve do pcall(function() rep.Events.TriggerCrowdSound:FireServer("you deserve it") end) rs.Heartbeat:Wait() end
        end) end
    end
})

Troll:CreateToggle({
    Name = "Spam This Is Awesome chant", CurrentValue = false,
    Callback = function(v)
        _G.SpamAwesome = v
        if v then task.spawn(function()
            while _G.SpamAwesome do pcall(function() rep.Events.TriggerCrowdSound:FireServer("this is awesome") end) rs.Heartbeat:Wait() end
        end) end
    end
})

-- local tab
Lcl:CreateSlider({
    Name = "WalkSpeed", Range = {16, 250}, Increment = 1, CurrentValue = 16,
    Callback = function(v) if lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = v end end
})

-- scripts
Scripts:CreateButton({Name = "Load Dark Dex", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end})

-- settings
Set:CreateColorPicker({Name = "Hitbox/ESP Color", Color = Color3.fromRGB(128, 0, 128), Callback = function(v) _G.HitboxColor = v end})
Set:CreateButton({
    Name = "Serverhop", Callback = function()
        local Http = game:GetService("HttpService")
        local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local s, res = pcall(function() return Http:JSONDecode(game:HttpGet(Api)) end)
        if s then
            for _, srv in pairs(res.data) do
                if srv.playing < srv.maxPlayers and srv.id ~= game.JobId then
                    ts:TeleportToPlaceInstance(game.PlaceId, srv.id) break
                end
            end
        end
    end
})
Set:CreateButton({Name = "Rejoin Server", Callback = function() ts:TeleportToPlaceInstance(game.PlaceId, game.JobId) end})

-- ui & loops
local gui = Instance.new("ScreenGui", game.CoreGui)
local info = Instance.new("TextLabel", gui)
info.Size, info.Position = UDim2.new(0, 200, 0, 50), UDim2.new(1, -210, 1, -60)
info.BackgroundTransparency, info.TextColor3, info.TextSize = 1, Color3.fromRGB(128, 0, 128), 14
info.TextXAlignment, info.Font = Enum.TextXAlignment.Right, Enum.Font.Code

local st = os.time()
rs.RenderStepped:Connect(function(dt)
    local u = os.time() - st
    info.Text = string.format("FPS: %d | Uptime: %dm %ds", math.floor(1/dt), math.floor(u/60), u%60)
end)

task.spawn(function()
    while task.wait(0.5) do
        for _, v in pairs(plrs:GetPlayers()) do
            if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = v.Character.HumanoidRootPart
                hrp.Size = _G.HitboxEnabled and Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize) or Vector3.new(2, 2, 1)
                hrp.Transparency = _G.HitboxEnabled and 0.7 or 1
                hrp.Color = _G.HitboxColor
                
                local hl = v.Character:FindFirstChild("GeminiESP")
                if _G.ESP then
                    if not hl then hl = Instance.new("Highlight", v.Character); hl.Name = "GeminiESP" end
                    hl.FillColor = _G.HitboxColor
                elseif hl then hl:Destroy() end
            end
        end
    end
end)

uis.JumpRequest:Connect(function()
    if _G.InfJ and lp.Character then lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)
