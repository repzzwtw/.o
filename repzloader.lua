local TS  = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

local SCRIPTS = {
    {
        name  = "Bite By Night",
        sub   = "Auto Farm | Esp | Mobile and pc",
        color = Color3.fromRGB(138, 43, 226),
        url   = "https://raw.githubusercontent.com/repzzwtw/.o/refs/heads/main/BiteByNight.lua",
    }, 
    {
        name  = "Flip Rocks For Brainrots",
        sub   = "Auto Flip | Speed | Mobile and pc",
        color = Color3.fromRGB(80,160,255),
        url   = "https://raw.githubusercontent.com/repzzwtw/.o/refs/heads/main/FRFBR.lua",
    },
    {
        name  = "Catalog Avatar Creator",
        sub   = "Rainbow Avatar| UI tools | Mobile and pc",
        color = Color3.fromRGB(0,255,128),
        url   = "https://raw.githubusercontent.com/repzzwtw/.o/refs/heads/main/CAC.lua",
    },
    {
        name  = "Fling Things And People",
        sub   = "Auto Fling | ESP | Mobile and pc",
        color = Color3.fromRGB(255,80,80),
        url   = "https://raw.githubusercontent.com/repzzwtw/.o/refs/heads/main/flingthingsandpeople.lua",
    },
    {
        name  = "Football Fusion 3",
        sub   = "QB Aimbot | Mags | Mobile and pc",
        color = Color3.fromRGB(0,128,0),
        url   = "https://gist.githubusercontent.com/repzzc/b023e7831c5926bf68828192016d012e/raw/FF3.lua",
    },
    {
        name  = "The Strongest Battlegrounds",
        sub   = "Auto Dodge | Macros | Mobile and pc",
        color = Color3.fromRGB(255,50,50),
        url   = "https://raw.githubusercontent.com/repzzwtw/.o/refs/heads/main/tsb.lua",
    },
    {
        name  = "Basketball Legends",
        sub   = "Auto Green | Auto Guard | Mobile and pc",
        color = Color3.fromRGB(255,165,0),
        url   = "https://raw.githubusercontent.com/repzzwtw/.o/refs/heads/main/basketball-legends.lua",
    },
    {
        name  = "Wrestle! | Roblox Wrestling",
        sub   = "Auto Pin | Infinite Stamina | Mobile and pc",
        color = Color3.fromRGB(200,200,200),
        url   = "https://raw.githubusercontent.com/repzzwtw/.o/refs/heads/main/wrestle.lua",
    },
    {
        name  = "Playground Basketball",
        sub   = "Auto Shoot | Auto Steal | Mobile and pc",
        color = Color3.fromRGB(255,120,0),
        url   = "https://raw.githubusercontent.com/repzzwtw/.o/refs/heads/main/playgroundbasketball.lua",
    },
    {
        name  = "Alter Ego | BETA",
        sub   = "Auto-Tasks, Infinite Stamina Player/Killer ESP",
        color = Color3.fromRGB(255, 255, 255),
        url   = "https://raw.githubusercontent.com/repzzwtw/.o/refs/heads/main/alterego.lua",
    },
    {
        name  = "Boxing BETA!",
        sub   = "Auto-Dodge, Auto-Block, Max Power",
        color = Color3.fromRGB(255, 50, 50),
        url   = "https://raw.githubusercontent.com/repzzwtw/.o/refs/heads/main/boxing.lua",
    }
}

local COUNTER_NAMESPACE = "repzloader_v2"

local function getCount(key)
    local ok, result = pcall(function()
        local res = game:HttpGet("https://api.countapi.xyz/get/" .. COUNTER_NAMESPACE .. "/" .. key)
        local data = HttpService:JSONDecode(res)
        return tostring(data.value or 0)
    end)
    return ok and result or "?"
end

local function hitCount(key)
    task.spawn(function()
        pcall(function()
            game:HttpGet("https://api.countapi.xyz/hit/" .. COUNTER_NAMESPACE .. "/" .. key)
        end)
    end)
end

local SG = Instance.new("ScreenGui")
SG.Name = "RepzLoader"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.IgnoreGuiInset = true
pcall(function() SG.Parent = game:GetService("CoreGui") end)
if not SG.Parent then SG.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

local Dim = Instance.new("Frame", SG)
Dim.BackgroundColor3 = Color3.fromRGB(0,0,0)
Dim.BackgroundTransparency = 0.4
Dim.BorderSizePixel = 0
Dim.Size = UDim2.new(1,0,1,0)

local Panel = Instance.new("Frame", SG)
Panel.BackgroundColor3 = Color3.fromRGB(14,14,22)
Panel.BorderSizePixel = 0
Panel.AnchorPoint = Vector2.new(0.5,0.5)
Panel.Position = UDim2.new(0.5,0,0.5,0)
Panel.Size = UDim2.new(0,0,0,0)
Panel.ClipsDescendants = true
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0,18)

local _brd = Instance.new("UIStroke", Panel)
_brd.Color = Color3.fromRGB(255,120,0)
_brd.Thickness = 2
_brd.Transparency = 0.2
_brd.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local targetSize = isMobile and UDim2.new(0.90,0,0.85,0) or UDim2.new(0,400,0,520)
TS:Create(Panel, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = targetSize}):Play()

local HeaderContainer = Instance.new("Frame", Panel)
HeaderContainer.BackgroundColor3 = Color3.fromRGB(20,20,32)
HeaderContainer.Size = UDim2.new(1,0,0, isMobile and 110 or 95)
HeaderContainer.BorderSizePixel = 0
Instance.new("UICorner", HeaderContainer).CornerRadius = UDim.new(0,18)

local TCov = Instance.new("Frame", HeaderContainer)
TCov.BackgroundColor3 = Color3.fromRGB(20,20,32)
TCov.BorderSizePixel = 0
TCov.Position = UDim2.new(0,0,0.5,0); TCov.Size = UDim2.new(1,0,0.5,0)

local TTitl = Instance.new("TextLabel", HeaderContainer)
TTitl.BackgroundTransparency = 1
TTitl.Position = UDim2.new(0,18,0,8)
TTitl.Size = UDim2.new(1,-18,0, isMobile and 28 or 24)
TTitl.Font = Enum.Font.GothamBold
TTitl.Text = "Repz Loader"
TTitl.TextColor3 = Color3.fromRGB(255,255,255)
TTitl.TextSize = isMobile and 22 or 19
TTitl.TextXAlignment = Enum.TextXAlignment.Left

local TSub = Instance.new("TextLabel", HeaderContainer)
TSub.BackgroundTransparency = 1
TSub.Position = UDim2.new(0,18,0, isMobile and 38 or 32)
TSub.Size = UDim2.new(1,-18,0,18)
TSub.Font = Enum.Font.Gotham
TSub.Text = "discord.gg/mVRWynJVCx"
TSub.TextColor3 = Color3.fromRGB(120,120,155)
TSub.TextSize = isMobile and 13 or 12
TSub.TextXAlignment = Enum.TextXAlignment.Left

local TabFrame = Instance.new("Frame", HeaderContainer)
TabFrame.BackgroundTransparency = 1
TabFrame.Position = UDim2.new(0, 14, 1, -35)
TabFrame.Size = UDim2.new(1, -28, 0, 30)

local FreeTab = Instance.new("TextButton", TabFrame)
FreeTab.BackgroundColor3 = Color3.fromRGB(40,40,60)
FreeTab.Size = UDim2.new(0.48, 0, 1, 0)
FreeTab.Font = Enum.Font.GothamBold; FreeTab.Text = "Free Scripts"
FreeTab.TextColor3 = Color3.fromRGB(255,255,255)
FreeTab.TextSize = 13
Instance.new("UICorner", FreeTab).CornerRadius = UDim.new(0,8)

local PaidTab = Instance.new("TextButton", TabFrame)
PaidTab.BackgroundColor3 = Color3.fromRGB(25,25,35)
PaidTab.Position = UDim2.new(0.52, 0, 0, 0)
PaidTab.Size = UDim2.new(0.48, 0, 1, 0)
PaidTab.Font = Enum.Font.GothamBold; PaidTab.Text = "🚀💲 Paid Scripts"
PaidTab.TextColor3 = Color3.fromRGB(150,150,170)
PaidTab.TextSize = 13
Instance.new("UICorner", PaidTab).CornerRadius = UDim.new(0,8)

local ContentArea = Instance.new("Frame", Panel)
ContentArea.BackgroundTransparency = 1
ContentArea.Position = UDim2.new(0,0, 0, isMobile and 110 or 95)
ContentArea.Size = UDim2.new(1,0, 1, -(isMobile and 148 or 127)) 
ContentArea.ClipsDescendants = true

local FreeScroll = Instance.new("ScrollingFrame", ContentArea)
FreeScroll.BackgroundTransparency = 1
FreeScroll.Size = UDim2.new(1,0,1,0)
FreeScroll.Position = UDim2.new(0,0,0,0)
FreeScroll.ScrollBarThickness = 4
FreeScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
FreeScroll.CanvasSize = UDim2.new(0,0,0,0)
local FPLL = Instance.new("UIListLayout", FreeScroll)
FPLL.Padding = UDim.new(0,0)
local FPad = Instance.new("UIPadding", FreeScroll)
FPad.PaddingBottom = UDim.new(0,14)

local PaidScroll = Instance.new("ScrollingFrame", ContentArea)
PaidScroll.BackgroundTransparency = 1
PaidScroll.Size = UDim2.new(1,0,1,0)
PaidScroll.Position = UDim2.new(1,0,0,0)
PaidScroll.ScrollBarThickness = 4
PaidScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PaidScroll.CanvasSize = UDim2.new(0,0,0,0)
local PPLL = Instance.new("UIListLayout", PaidScroll)
PPLL.Padding = UDim.new(0,0)
local PPad = Instance.new("UIPadding", PaidScroll)
PPad.PaddingBottom = UDim.new(0,14)

local PopupOverlay = Instance.new("Frame", Panel)
PopupOverlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
PopupOverlay.BackgroundTransparency = 0.5
PopupOverlay.Size = UDim2.new(1,0,1,0)
PopupOverlay.ZIndex = 10
PopupOverlay.Visible = false

local PopupBox = Instance.new("Frame", PopupOverlay)
PopupBox.BackgroundColor3 = Color3.fromRGB(20,20,32)
PopupBox.AnchorPoint = Vector2.new(0.5, 0.5)
PopupBox.Position = UDim2.new(0.5, 0, 0.5, 0)
PopupBox.Size = UDim2.new(0.85, 0, 0, 140)
PopupBox.ZIndex = 11
Instance.new("UICorner", PopupBox).CornerRadius = UDim.new(0, 14)
local PopStroke = Instance.new("UIStroke", PopupBox)
PopStroke.Color = Color3.fromRGB(255,50,50); PopStroke.Thickness = 2

local PopText = Instance.new("TextLabel", PopupBox)
PopText.BackgroundTransparency = 1
PopText.Size = UDim2.new(1, -20, 1, -50)
PopText.Position = UDim2.new(0, 10, 0, 10)
PopText.Font = Enum.Font.GothamSemibold
PopText.Text = "⚠️ This script is paid, you cannot access it unless you pay/boost. Join discord.gg/mVRWynJVCx for more information."
PopText.TextColor3 = Color3.fromRGB(255,255,255)
PopText.TextSize = 13
PopText.TextWrapped = true
PopText.ZIndex = 12

local PopClose = Instance.new("TextButton", PopupBox)
PopClose.BackgroundColor3 = Color3.fromRGB(255,50,50)
PopClose.AnchorPoint = Vector2.new(0.5, 1)
PopClose.Position = UDim2.new(0.5, 0, 1, -10)
PopClose.Size = UDim2.new(0, 100, 0, 30)
PopClose.Font = Enum.Font.GothamBold; PopClose.Text = "Got it"
PopClose.TextColor3 = Color3.fromRGB(255,255,255)
PopClose.TextSize = 13
PopClose.ZIndex = 12
Instance.new("UICorner", PopClose).CornerRadius = UDim.new(0, 8)

PopClose.MouseButton1Click:Connect(function()
    PopupOverlay.Visible = false
end)

FreeTab.MouseButton1Click:Connect(function()
    FreeTab.BackgroundColor3 = Color3.fromRGB(40,40,60)
    FreeTab.TextColor3 = Color3.fromRGB(255,255,255)
    PaidTab.BackgroundColor3 = Color3.fromRGB(25,25,35)
    PaidTab.TextColor3 = Color3.fromRGB(150,150,170)
    
    TS:Create(FreeScroll, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {Position = UDim2.new(0,0,0,0)}):Play()
    TS:Create(PaidScroll, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {Position = UDim2.new(1,0,0,0)}):Play()
end)

PaidTab.MouseButton1Click:Connect(function()
    PaidTab.BackgroundColor3 = Color3.fromRGB(40,40,60)
    PaidTab.TextColor3 = Color3.fromRGB(255,255,255)
    FreeTab.BackgroundColor3 = Color3.fromRGB(25,25,35)
    FreeTab.TextColor3 = Color3.fromRGB(150,150,170)
    
    TS:Create(FreeScroll, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {Position = UDim2.new(-1,0,0,0)}):Play()
    TS:Create(PaidScroll, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {Position = UDim2.new(0,0,0,0)}):Play()
end)

local CARD_H    = isMobile and 110 or 92
local BTN_H     = isMobile and 52  or 38
local BTN_W     = isMobile and 110 or 94
local NAME_SIZE = isMobile and 17  or 14
local SUB_SIZE  = isMobile and 12  or 11
local countLabels = {}

local function makeCard(data, idx, isPaid)
    local parentScroll = isPaid and PaidScroll or FreeScroll
    
    local wrapper = Instance.new("Frame", parentScroll)
    wrapper.BackgroundTransparency = 1
    wrapper.BorderSizePixel = 0
    wrapper.Size = UDim2.new(1,0,0, CARD_H + 10)
    wrapper.LayoutOrder = idx

    local card = Instance.new("Frame", wrapper)
    card.BackgroundColor3 = Color3.fromRGB(22,22,36)
    card.BorderSizePixel = 0
    card.Position = UDim2.new(0,14,0,6)
    card.Size = UDim2.new(1,-28,0, CARD_H)
    Instance.new("UICorner", card).CornerRadius = UDim.new(0,14)
    local cStroke = Instance.new("UIStroke", card)
    cStroke.Color = data.color; cStroke.Thickness = 1.5; cStroke.Transparency = 0.35

    local accent = Instance.new("Frame", card)
    accent.BackgroundColor3 = data.color
    accent.BorderSizePixel = 0
    accent.Position = UDim2.new(0,0,0.1,0)
    accent.Size = UDim2.new(0,4,0.8,0)
    Instance.new("UICorner", accent).CornerRadius = UDim.new(1,0)

    local nLbl = Instance.new("TextLabel", card)
    nLbl.BackgroundTransparency = 1
    nLbl.Position = UDim2.new(0,18,0,12)
    nLbl.Size = UDim2.new(1, -(BTN_W+28), 0, NAME_SIZE+4)
    nLbl.Font = Enum.Font.GothamBold; nLbl.Text = data.name
    nLbl.TextColor3 = Color3.fromRGB(255,255,255)
    nLbl.TextSize = NAME_SIZE
    nLbl.TextXAlignment = Enum.TextXAlignment.Left

    local sLbl = Instance.new("TextLabel", card)
    sLbl.BackgroundTransparency = 1
    sLbl.Position = UDim2.new(0,18,0, 14+NAME_SIZE+4)
    sLbl.Size = UDim2.new(1,-(BTN_W+28),0, isMobile and 40 or 32)
    sLbl.Font = Enum.Font.Gotham; sLbl.Text = data.sub
    sLbl.TextColor3 = Color3.fromRGB(120,120,155)
    sLbl.TextSize = SUB_SIZE
    sLbl.TextXAlignment = Enum.TextXAlignment.Left
    sLbl.TextWrapped = true

    local countLbl = Instance.new("TextLabel", card)
    countLbl.BackgroundTransparency = 1
    countLbl.Position = UDim2.new(0,18,1,-20)
    countLbl.Size = UDim2.new(0.5,0,0,18)
    countLbl.Font = Enum.Font.Gotham
    countLbl.Text = "Loads: ..."
    countLbl.TextColor3 = Color3.fromRGB(85,85,115)
    countLbl.TextSize = isMobile and 11 or 10
    countLbl.TextXAlignment = Enum.TextXAlignment.Left

    local countKey = data.name:gsub("%s+", "_"):lower()
    if not isPaid then countLabels[countKey] = countLbl end
    
    task.spawn(function()
        local count = getCount(countKey)
        countLbl.Text = "Loads: " .. count
    end)

    local loadBtn = Instance.new("TextButton", card)
    loadBtn.BackgroundColor3 = data.color
    loadBtn.BorderSizePixel = 0
    loadBtn.AnchorPoint = Vector2.new(1,0.5)
    loadBtn.Position = UDim2.new(1,-14,0.5,0)
    loadBtn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
    loadBtn.Font = Enum.Font.GothamBold; 
    loadBtn.Text = isPaid and "BUY" or "LOAD"
    loadBtn.TextColor3 = Color3.fromRGB(255,255,255)
    loadBtn.TextSize = isMobile and 17 or 14
    Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0,10)

    if isMobile then
        loadBtn.MouseButton1Down:Connect(function()
            TS:Create(loadBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, BTN_W-8, 0, BTN_H-6)}):Play()
        end)
        loadBtn.MouseButton1Up:Connect(function()
            TS:Create(loadBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, BTN_W, 0, BTN_H)}):Play()
        end)
    end

    loadBtn.MouseButton1Click:Connect(function()
        if isPaid then
            PopupOverlay.Visible = true
        else
            loadBtn.Text = "Loading..."
            loadBtn.BackgroundColor3 = Color3.fromRGB(40,40,60)

            hitCount(countKey)
            local newCount = getCount(countKey)
            countLbl.Text = "Loads: " .. newCount

            task.spawn(function()
                local tw = TS:Create(Panel, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Size = UDim2.new(0,0,0,0) })
                tw:Play()
                tw.Completed:Connect(function() SG:Destroy() end)
                task.wait(0.3)
                local ok, err = pcall(function()
                    loadstring(game:HttpGet(data.url))()
                end)
                if not ok then warn("Loader error: " .. tostring(err)) end
            end)
        end
    end)
end

for i, data in pairs(SCRIPTS) do
    makeCard(data, i, false)
    makeCard(data, i, true)
end

local FooterFrame = Instance.new("Frame", Panel)
FooterFrame.BackgroundColor3 = Color3.fromRGB(18,18,28)
FooterFrame.BorderSizePixel = 0
FooterFrame.AnchorPoint = Vector2.new(0, 1)
FooterFrame.Position = UDim2.new(0, 0, 1, 0)
FooterFrame.Size = UDim2.new(1,0,0, isMobile and 38 or 32)
FooterFrame.LayoutOrder = 100
Instance.new("UICorner", FooterFrame).CornerRadius = UDim.new(0,18)

local FooterPad = Instance.new("UIPadding", FooterFrame)
FooterPad.PaddingLeft = UDim.new(0,14); FooterPad.PaddingRight = UDim.new(0,14)

local FOffset = Instance.new("Frame", FooterFrame)
FOffset.BackgroundColor3 = Color3.fromRGB(18,18,28)
FOffset.BorderSizePixel = 0
FOffset.Position = UDim2.new(0,0,0,0); FOffset.Size = UDim2.new(1,0,0.5,0)

local TotalLbl = Instance.new("TextLabel", FooterFrame)
TotalLbl.BackgroundTransparency = 1
TotalLbl.Position = UDim2.new(0,0,0,0); TotalLbl.Size = UDim2.new(0.6,0,1,0)
TotalLbl.Font = Enum.Font.Gotham
TotalLbl.Text = "Total loads: ..."
TotalLbl.TextColor3 = Color3.fromRGB(85,85,115)
TotalLbl.TextSize = isMobile and 12 or 10
TotalLbl.TextXAlignment = Enum.TextXAlignment.Left

local ByLbl = Instance.new("TextLabel", FooterFrame)
ByLbl.BackgroundTransparency = 1
ByLbl.Position = UDim2.new(0.5,0,0,0); ByLbl.Size = UDim2.new(0.5,0,1,0)
ByLbl.Font = Enum.Font.Gotham
ByLbl.Text = "by Repz"
ByLbl.TextColor3 = Color3.fromRGB(70,70,100)
ByLbl.TextSize = isMobile and 12 or 10
ByLbl.TextXAlignment = Enum.TextXAlignment.Right

task.spawn(function()
    while SG and SG.Parent do
        task.wait(5)
        if not SG or not SG.Parent then break end
        local total = 0
        for _, data in pairs(SCRIPTS) do
            local key = data.name:gsub("%s+", "_"):lower()
            pcall(function()
                local res = game:HttpGet("https://api.countapi.xyz/get/" .. COUNTER_NAMESPACE .. "/" .. key)
                local decoded = HttpService:JSONDecode(res)
                local val = decoded.value or 0
                total = total + val
                if countLabels[key] then countLabels[key].Text = "Loads: " .. tostring(val) end
            end)
        end
        if TotalLbl and TotalLbl.Parent then
            TotalLbl.Text = "Total loads: " .. tostring(total)
        end
    end
end)
