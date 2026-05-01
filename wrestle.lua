--// Services
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local teleportService = game:GetService("TeleportService")
local userInputService = game:GetService("UserInputService")
local vim = game:GetService("VirtualInputManager")
local coreGui = game:GetService("CoreGui")
local localPlayer = players.LocalPlayer

local isMobile = userInputService.TouchEnabled and not userInputService.KeyboardEnabled

--// Global Settings
_G.HitboxSize = 5
_G.HitboxEnabled = false
_G.HitboxColor = Color3.fromRGB(128, 0, 128)
_G.ESPEnabled = false
_G.InfJump = false
_G.Noclip = false
_G.DamageMultiplierEnabled = false
_G.DamageMultiplierValue = 1
_G.AutoClicker = false

--// MOBILE TOGGLE BUTTON GUI (Built first so Settings can access it)
local MobileGui = Instance.new("ScreenGui")
MobileGui.Name = "BrenMobileToggle"
MobileGui.Parent = coreGui
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
UIStroke.Color = Color3.fromRGB(128, 0, 128) 
UIStroke.Thickness = 2
UIStroke.Parent = ToggleBtn

--// Library Initialization
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

--// Tab Sections
Window:AddTabSection({ Name = "Main", Order = 1 })
Window:AddTabSection({ Name = "Utility", Order = 2 })
Window:AddTabSection({ Name = "Visuals", Order = 3 })
Window:AddTabSection({ Name = "Settings", Order = 4 })

--// TAB: COMBAT
local CombatTab = Window:AddTab({ Title = "Combat", Section = "Main", Icon = "rbxassetid://11963373994" })
Window:AddSection({ Name = "Abilities", Tab = CombatTab })
Window:AddToggle({ Title = "Universal Autoclicker", Description = "Automatically clicks for you", Tab = CombatTab, Callback = function(Value) _G.AutoClicker = Value end })
Window:AddToggle({ Title = "Damage Multiplier", Description = "Increases damage output", Tab = CombatTab, Callback = function(Value) _G.DamageMultiplierEnabled = Value end })
Window:AddInput({ Title = "Multiplier Amount", Description = "How many times to multiply damage", Tab = CombatTab, Callback = function(Text) _G.DamageMultiplierValue = tonumber(Text) or 1 end })

--// TAB: MOVEMENT
local MoveTab = Window:AddTab({ Title = "Movement", Section = "Main", Icon = "rbxassetid://11963373994" })
Window:AddSlider({ Title = "WalkSpeed", Description = "Adjust your speed", Tab = MoveTab, MaxValue = 250, Callback = function(Value) if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then localPlayer.Character.Humanoid.WalkSpeed = Value end end })
Window:AddToggle({ Title = "Infinite Jump", Description = "Jump as many times as you want", Tab = MoveTab, Callback = function(Value) _G.InfJump = Value end })
Window:AddToggle({ Title = "Noclip", Description = "Walk through walls", Tab = MoveTab, Callback = function(Value) _G.Noclip = Value end })

--// TAB: VISUALS
local VisualsTab = Window:AddTab({ Title = "Visuals", Section = "Visuals", Icon = "rbxassetid://11963373994" })
Window:AddSection({ Name = "Hitbox & ESP", Tab = VisualsTab })
Window:AddToggle({ Title = "Enable Hitbox", Description = "Expands enemy hitboxes", Tab = VisualsTab, Callback = function(Value) _G.HitboxEnabled = Value end })
Window:AddSlider({ Title = "Hitbox Size", Description = "Size of the expanded hitbox", Tab = VisualsTab, MaxValue = 50, Callback = function(Value) _G.HitboxSize = Value end })
Window:AddToggle({ Title = "Player ESP", Description = "See players through walls", Tab = VisualsTab, Callback = function(Value) _G.ESPEnabled = Value end })

--// TAB: SETTINGS
local SettingsTab = Window:AddTab({ Title = "Settings", Section = "Settings", Icon = "rbxassetid://11293977610" })
Window:AddKeybind({ Title = "Minimize Keybind", Description = "Set key to open/close menu", Tab = SettingsTab, Callback = function(Key) Window:SetSetting("Keybind", Key) end })
Window:AddDropdown({ Title = "Set Theme", Description = "Change the UI appearance", Tab = SettingsTab, Options = { ["Light Mode"] = "Light", ["Dark Mode"] = "Dark", ["Pitch Black"] = "Void" }, Callback = function(Theme) Window:SetTheme(Themes[Theme]) end })

-- [NEW] Mobile Sizing Dropdown
Window:AddDropdown({
	Title = "Mobile Button Size",
	Description = "Adjust the size of the circular toggle button",
	Tab = SettingsTab,
	Options = {
		["Small"] = 35,
		["Medium (Default)"] = 50,
		["Large"] = 65,
		["Extra Large"] = 80
	},
	Callback = function(SizeValue) 
		if ToggleBtn then
			-- Scale the button
			ToggleBtn.Size = UDim2.new(0, SizeValue, 0, SizeValue)
			-- Scale the text dynamically so it always fits
			ToggleBtn.TextSize = math.floor(SizeValue * 0.35)
		end
	end,
})

--// CUSTOMIZE LIBRARY TOPBAR (OVERRIDE DOTS)
task.spawn(function()
    task.wait(1) 
    for _, gui in pairs(coreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui:FindFirstChild("Main") then
            local mainFrame = gui.Main
            local topbar = mainFrame:FindFirstChild("Topbar") or mainFrame:FindFirstChild("Header")
            if topbar then
                local controls = topbar:FindFirstChild("Controls") or topbar:FindFirstChild("Buttons")
                if controls then
                    controls.AnchorPoint = Vector2.new(1, 0.5)
                    controls.Position = UDim2.new(1, -10, 0.5, 0)
                    
                    local index = 1
                    local icons = {" X ", " - ", " [ ] "}
                    for _, child in pairs(controls:GetChildren()) do
                        if child:IsA("Frame") or child:IsA("TextButton") then
                            child.BackgroundColor3 = Color3.fromRGB(15, 15, 15) 
                            local btnTxt = Instance.new("TextLabel", child)
                            btnTxt.Size = UDim2.new(1, 0, 1, 0)
                            btnTxt.BackgroundTransparency = 1
                            btnTxt.Text = icons[index] or ""
                            btnTxt.TextColor3 = Color3.fromRGB(200, 200, 200)
                            btnTxt.Font = Enum.Font.GothamBold
                            
                            if index == 2 then
                                local clicker = child:FindFirstChildOfClass("TextButton") or child
                                clicker.MouseButton1Click:Connect(function()
                                    if isMobile then
                                        MobileGui.Enabled = true
                                    else
                                        Window:Notify({Title = "UI Minimized", Description = "Press your Minimize Keybind to Re-open.", Duration = 4})
                                    end
                                end)
                            end
                            index = index + 1
                        end
                    end
                end
            end
        end
    end
end)

-- Mobile Reopen Logic
ToggleBtn.MouseButton1Click:Connect(function()
    MobileGui.Enabled = false
    vim:SendKeyEvent(true, Enum.KeyCode.LeftAlt, false, game)
    task.wait(0.1)
    vim:SendKeyEvent(false, Enum.KeyCode.LeftAlt, false, game)
end)

--[[ BACKEND LOGIC ]]--
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if method == "FireServer" and _G.DamageMultiplierEnabled then
        local name = tostring(self)
        if name:find("Damage") or name:find("Hit") or name:find("Attack") then
            for i = 1, (_G.DamageMultiplierValue - 1) do
                oldNamecall(self, unpack(args))
            end
        end
    end
    return oldNamecall(self, ...)
end)

task.spawn(function()
    while true do
        if _G.AutoClicker then
            vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.05)
            vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        for _, v in pairs(players:GetPlayers()) do
            if v ~= localPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = v.Character.HumanoidRootPart
                hrp.Size = _G.HitboxEnabled and Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize) or Vector3.new(2, 2, 1)
                hrp.Transparency = _G.HitboxEnabled and 0.7 or 1
                hrp.Color = _G.HitboxColor
                hrp.CanCollide = false
                
                local highlight = v.Character:FindFirstChild("BrenESP")
                if _G.ESPEnabled then
                    if not highlight then highlight = Instance.new("Highlight", v.Character); highlight.Name = "BrenESP" end
                    highlight.FillColor = _G.HitboxColor
                elseif highlight then highlight:Destroy() end
            end
        end
    end
end)

userInputService.JumpRequest:Connect(function()
    if _G.InfJump and localPlayer.Character then localPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)

runService.Stepped:Connect(function()
    if _G.Noclip and localPlayer.Character then
        for _, part in pairs(localPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

Window:Notify({ Title = "WRESTLE! Loaded", Description = isMobile and "Mobile UI active. Use the top bar to minimize." or "Press Left Alt to toggle UI", Duration = 5 })
