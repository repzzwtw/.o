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
