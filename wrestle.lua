-- services & locals
local plrs, rs, ts, uis, vim, rep = game:GetService("Players"), game:GetService("RunService"), game:GetService("TeleportService"), game:GetService("UserInputService"), game:GetService("VirtualInputManager"), game:GetService("ReplicatedStorage")
local lp = plrs.LocalPlayer

-- globals
_G.HitboxSize = 5; _G.HitboxEnabled = false; _G.HitboxColor = Color3.fromRGB(128, 0, 128)
_G.ESP = false; _G.InfJ = false; _G.Noclip = false; _G.AutoClick = false
_G.DmgMult = false; _G.DmgVal = 1
_G.SpamTag = false; _G.SpamCheer = false; _G.SpamB = false; _G.SpamDeserve = false; _G.SpamAwesome = false

-- hook 
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if method == "FireServer" then
        local req = tostring(self)
        if req:find("Purchase") or req:find("Buy") then return end -- drop purchases
        if _G.DmgMult and (req:find("Damage") or req:find("Hit")) then
            for _ = 1, (_G.DmgVal - 1) do old(self, unpack(args)) end
        end
    end
    return old(self, ...)
end)

-- ui init (obsidian)
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/obsidian.lua"))() or loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = Lib:MakeWindow({
    Name = "WRESTLE! | Premium Multi-Tool - made by repz lol",
    HidePremium = true,
    SaveConfig = true,
    ConfigFolder = "RepzWrestle",
    Icon = "rbxassetid://119294576535598", -- W repz
    IntroEnabled = false -- skip
})

-- tabs (with standard icons)
local Main = Window:MakeTab({Name = "Main", Icon = "rbxassetid://773365636"})
local Wres = Window:MakeTab({Name = "Wrestling", Icon = "rbxassetid://773380486"})
local Troll = Window:MakeTab({Name = "Troll", Icon = "rbxassetid://773379966"})
local Lcl = Window:MakeTab({Name = "Local", Icon = "rbxassetid://773376404"})
local Set = Window:MakeTab({Name = "Settings", Icon = "rbxassetid://773376510"})
local Creds = Window:MakeTab({Name = "Credits", Icon = "rbxassetid://773378523"})

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

-- main
Main:AddToggle({Name = "Universal Autoclicker", Default = false, Callback = function(v) _G.AutoClick = v end})
Main:AddToggle({Name = "Damage Multiplier", Default = false, Callback = function(v) _G.DmgMult = v end})
Main:AddTextbox({Name = "Multiplier Amount", Default = "1", TextDisappear = false, Callback = function(v) _G.DmgVal = tonumber(v) or 1 end})

Main:AddToggle({Name = "Enable Hitbox", Default = false, Callback = function(v) _G.HitboxEnabled = v end})
Main:AddTextbox({Name = "Hitbox Size", Default = "5", TextDisappear = false, Callback = function(v) _G.HitboxSize = tonumber(v) or 5 end})
Main:AddToggle({Name = "Dark Purple ESP", Default = false, Callback = function(v) _G.ESP = v end})

Main:AddToggle({Name = "Infinite Jump", Default = false, Callback = function(v) _G.InfJ = v end})
Main:AddToggle({Name = "Noclip", Default = false, Callback = function(v) _G.Noclip = v end})

-- wrestling
Wres:AddDropdown({
    Name = "Change tag team finishers",
    Options = {"3D", "Assassination", "BTETrigger", "ChokeslamSpinebuster", "ClaymoreZigZag", "DeathDrop", "Doomsday", "DoubleChokeslam", "DoubleSuperkick", "ExtremeCombination", "F5RKO", "HighFlyingCombo", "MagicKiller", "MeltzerDriver", "ShatterMachine", "SkullCrushingFinale", "SuperkickParty"},
    Default = "Select Finisher",
    Callback = function(v) pcall(function() rep.Events.ChangeTeamFinisher:FireServer(v) end) end
})

Wres:AddDropdown({
    Name = "Change solo finisher",
    Options = {"AnnouncersTableFrogSplash"},
    Default = "Select Solo Finisher",
    Callback = function(v) pcall(function() rep.Events.ChangeFinisher:FireServer(v) end) end
})

Wres:AddDropdown({
    Name = "Equip Emote",
    Options = {"angry", "backflip", "beast", "boom", "bow", "cheer", "chestbeat", "chicken", "confused", "coolwalk", "cry", "dance1", "dance2", "dance3", "dance4", "evilvillian", "flex1", "flex2", "flex3", "floss", "golfswing", "guitar", "headstand", "hype", "kick", "laugh", "loser", "lunge", "nod", "point", "poplock", "pose1", "pose2", "pose3", "pose4", "pose5", "pushups", "robot", "salute", "shrug", "sit", "sleep", "smug", "spiderman", "splits", "stomp", "tpose", "wave", "workout", "yawn", "yes"},
    Default = "Select Emote",
    Callback = function(v) pcall(function() rep.Events.PlayEmote:FireServer(v) end) end
})

Wres:AddDropdown({
    Name = "Equip props",
    Options = {"NewsShow", "Playground", "Throne", "Graveyard", "Podium", "Couch", "HospitalBed", "Coffin", "LockerRoom", "InterviewSet", "Ambulance", "PoliceCar", "Barricade", "Casket", "Chair", "Desk", "Dumpster", "Forklift", "Ladder", "Table", "TrashCan", "Wheelchair"},
    Default = "Select Prop",
    Callback = function(v) pcall(function() rep.Events.ChangePromoProp:FireServer(v) end) end
})

-- troll
Troll:AddToggle({
    Name = "Spam-request tag teams", Default = false,
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

-- Heartbeat loop for max speed spam
Troll:AddToggle({
    Name = "Spam Cheer", Default = false,
    Callback = function(v)
        _G.SpamCheer = v
        if v then task.spawn(function()
            while _G.SpamCheer do pcall(function() rep.Events.TriggerCrowdSound:FireServer("C") end) rs.Heartbeat:Wait() end
        end) end
    end
})

Troll:AddToggle({
    Name = "Spam B", Default = false,
    Callback = function(v)
        _G.SpamB = v
        if v then task.spawn(function()
            while _G.SpamB do pcall(function() rep.Events.TriggerCrowdSound:FireServer("B") end) rs.Heartbeat:Wait() end
        end) end
    end
})

Troll:AddToggle({
    Name = "Spam You deserve it! Chant", Default = false,
    Callback = function(v)
        _G.SpamDeserve = v
        if v then task.spawn(function()
            while _G.SpamDeserve do pcall(function() rep.Events.TriggerCrowdSound:FireServer("you deserve it") end) rs.Heartbeat:Wait() end
        end) end
    end
})

Troll:AddToggle({
    Name = "Spam This Is Awesome chant", Default = false,
    Callback = function(v)
        _G.SpamAwesome = v
        if v then task.spawn(function()
            while _G.SpamAwesome do pcall(function() rep.Events.TriggerCrowdSound:FireServer("this is awesome") end) rs.Heartbeat:Wait() end
        end) end
    end
})

-- local
Lcl:AddSlider({
    Name = "WalkSpeed", Min = 16, Max = 250, Default = 16, Color = Color3.fromRGB(128,0,128), Increment = 1, ValueName = "Speed",
    Callback = function(v) if lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = v end end
})

-- settings / config
Set:AddLabel("Obsidian UI Configuration")
Set:AddColorpicker({Name = "Hitbox/ESP Color", Default = Color3.fromRGB(128, 0, 128), Callback = function(v) _G.HitboxColor = v end})
Set:AddButton({Name = "Save UI Configuration", Callback = function() Lib:SaveConfig() end})
Set:AddButton({Name = "Unload UI", Callback = function() Lib:Destroy() end})

Set:AddButton({
    Name = "Serverhop", Callback = function()
        local s, res = pcall(function() return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")) end)
        if s then
            for _, srv in pairs(res.data) do
                if srv.playing < srv.maxPlayers and srv.id ~= game.JobId then ts:TeleportToPlaceInstance(game.PlaceId, srv.id) break end
            end
        end
    end
})
Set:AddButton({Name = "Rejoin Server", Callback = function() ts:TeleportToPlaceInstance(game.PlaceId, game.JobId) end})

-- credits
Creds:AddLabel("Main developers: Repzz, Ross")
Creds:AddLabel("Special thanks to the community for supporting :>")

-- loops
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

Lib:Init()
