-- [[ Murder Duels — ХИТБОКСЫ + ESP + WALLBANG + HOTKEY ]]
-- H — вкл/выкл хитбоксы
-- Вкладка "🔫 СТРЕЛЬБА" — стрельба сквозь стены

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ===== НАСТРОЙКИ =====
local CheckInterval = 0.5
local HitboxHotkey = Enum.KeyCode.H

-- ===== ХИТБОКСЫ =====
local HitboxScale = 3
local HitboxActive = false
local OriginalSizes = {}

-- ===== ESP =====
local EspActive = false
local EspColor = Color3.fromRGB(255, 0, 0)
local EspHighlights = {}

-- ===== WALLBANG =====
local WallbangActive = false
local OriginalCollisions = {}
local WallbangRange = 100

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MurderDuelsMenu"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 400)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

-- Шапка
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.Text = "MURDER DUELS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 7)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 80)
CloseBtn.BorderSizePixel = 0
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.Parent = TopBar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseBtn

-- Вкладки (теперь 3)
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 35)
TabBar.Position = UDim2.new(0, 0, 0, 40)
TabBar.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local HitboxTab = Instance.new("TextButton")
HitboxTab.Size = UDim2.new(0.34, 0, 1, 0)
HitboxTab.Position = UDim2.new(0, 0, 0, 0)
HitboxTab.Text = "📦 ХИТБОКС"
HitboxTab.TextColor3 = Color3.fromRGB(255, 255, 255)
HitboxTab.TextSize = 12
HitboxTab.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
HitboxTab.BorderSizePixel = 0
HitboxTab.Font = Enum.Font.GothamSemibold
HitboxTab.Parent = TabBar

local ViewTab = Instance.new("TextButton")
ViewTab.Size = UDim2.new(0.33, 0, 1, 0)
ViewTab.Position = UDim2.new(0.34, 0, 0, 0)
ViewTab.Text = "👁 ВИД"
ViewTab.TextColor3 = Color3.fromRGB(180, 180, 210)
ViewTab.TextSize = 12
ViewTab.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
ViewTab.BorderSizePixel = 0
ViewTab.Font = Enum.Font.GothamSemibold
ViewTab.Parent = TabBar

local ShootTab = Instance.new("TextButton")
ShootTab.Size = UDim2.new(0.33, 0, 1, 0)
ShootTab.Position = UDim2.new(0.67, 0, 0, 0)
ShootTab.Text = "🔫 СТРЕЛЬБА"
ShootTab.TextColor3 = Color3.fromRGB(180, 180, 210)
ShootTab.TextSize = 12
ShootTab.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
ShootTab.BorderSizePixel = 0
ShootTab.Font = Enum.Font.GothamSemibold
ShootTab.Parent = TabBar

-- Контент
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -75)
Content.Position = UDim2.new(0, 0, 0, 75)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- ===== ВКЛАДКА "ХИТБОКС" =====
local HitboxPanel = Instance.new("Frame")
HitboxPanel.Size = UDim2.new(1, 0, 1, 0)
HitboxPanel.BackgroundTransparency = 1
HitboxPanel.Parent = Content

local HitboxInfo = Instance.new("TextLabel")
HitboxInfo.Size = UDim2.new(0.9, 0, 0, 40)
HitboxInfo.Position = UDim2.new(0.05, 0, 0.05, 0)
HitboxInfo.Text = "Увеличивает все части тела врагов\nдо 100 раз (легче попасть)"
HitboxInfo.TextColor3 = Color3.fromRGB(180, 180, 210)
HitboxInfo.TextSize = 12
HitboxInfo.TextXAlignment = Enum.TextXAlignment.Center
HitboxInfo.BackgroundTransparency = 1
HitboxInfo.Font = Enum.Font.Gotham
HitboxInfo.Parent = HitboxPanel

local HitboxBtn = Instance.new("TextButton")
HitboxBtn.Size = UDim2.new(0.9, 0, 0, 50)
HitboxBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
HitboxBtn.Text = "🎯 ВКЛЮЧИТЬ ХИТБОКСЫ"
HitboxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HitboxBtn.TextSize = 15
HitboxBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
HitboxBtn.BorderSizePixel = 0
HitboxBtn.Font = Enum.Font.GothamBold
HitboxBtn.Parent = HitboxPanel
local HitboxCorner = Instance.new("UICorner")
HitboxCorner.CornerRadius = UDim.new(0, 8)
HitboxCorner.Parent = HitboxBtn

local HotkeyHint = Instance.new("TextLabel")
HotkeyHint.Size = UDim2.new(0.9, 0, 0, 18)
HotkeyHint.Position = UDim2.new(0.05, 0, 0.42, 0)
HotkeyHint.Text = "⌨️ H — быстрый вкл/выкл"
HotkeyHint.TextColor3 = Color3.fromRGB(255, 200, 100)
HotkeyHint.TextSize = 11
HotkeyHint.TextXAlignment = Enum.TextXAlignment.Center
HotkeyHint.BackgroundTransparency = 1
HotkeyHint.Font = Enum.Font.Gotham
HotkeyHint.Parent = HitboxPanel

local HitboxStatus = Instance.new("TextLabel")
HitboxStatus.Size = UDim2.new(0.9, 0, 0, 22)
HitboxStatus.Position = UDim2.new(0.05, 0, 0.5, 0)
HitboxStatus.Text = "● ВЫКЛЮЧЕНО"
HitboxStatus.TextColor3 = Color3.fromRGB(200, 80, 80)
HitboxStatus.TextSize = 13
HitboxStatus.TextXAlignment = Enum.TextXAlignment.Center
HitboxStatus.BackgroundTransparency = 1
HitboxStatus.Font = Enum.Font.Gotham
HitboxStatus.Parent = HitboxPanel

local ScaleLabel = Instance.new("TextLabel")
ScaleLabel.Size = UDim2.new(0.9, 0, 0, 20)
ScaleLabel.Position = UDim2.new(0.05, 0, 0.62, 0)
ScaleLabel.Text = "РАЗМЕР ХИТБОКСА (1-100)"
ScaleLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
ScaleLabel.TextSize = 11
ScaleLabel.TextXAlignment = Enum.TextXAlignment.Left
ScaleLabel.BackgroundTransparency = 1
ScaleLabel.Font = Enum.Font.Gotham
ScaleLabel.Parent = HitboxPanel

local ScaleInput = Instance.new("TextBox")
ScaleInput.Size = UDim2.new(0.9, 0, 0, 35)
ScaleInput.Position = UDim2.new(0.05, 0, 0.7, 0)
ScaleInput.Text = "3"
ScaleInput.TextColor3 = Color3.fromRGB(255, 255, 255)
ScaleInput.TextSize = 15
ScaleInput.BackgroundColor3 = Color3.fromRGB(30, 33, 50)
ScaleInput.BorderSizePixel = 0
ScaleInput.TextXAlignment = Enum.TextXAlignment.Center
ScaleInput.Font = Enum.Font.GothamBold
ScaleInput.Parent = HitboxPanel
local ScaleCorner = Instance.new("UICorner")
ScaleCorner.CornerRadius = UDim.new(0, 6)
ScaleCorner.Parent = ScaleInput

local QuickFrame = Instance.new("Frame")
QuickFrame.Size = UDim2.new(0.9, 0, 0, 30)
QuickFrame.Position = UDim2.new(0.05, 0, 0.88, 0)
QuickFrame.BackgroundTransparency = 1
QuickFrame.Parent = HitboxPanel

local quickValues = {3, 10, 30, 50, 100}
for i, val in ipairs(quickValues) do
    local qBtn = Instance.new("TextButton")
    qBtn.Size = UDim2.new(0.18, 0, 1, 0)
    qBtn.Position = UDim2.new((i-1) * 0.2, 0, 0, 0)
    qBtn.Text = tostring(val)
    qBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    qBtn.TextSize = 11
    qBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
    qBtn.BorderSizePixel = 0
    qBtn.Font = Enum.Font.GothamBold
    qBtn.Parent = QuickFrame
    local qCorner = Instance.new("UICorner")
    qCorner.CornerRadius = UDim.new(0, 5)
    qCorner.Parent = qBtn
    
    qBtn.MouseButton1Click:Connect(function()
        HitboxScale = val
        ScaleInput.Text = tostring(val)
        if HitboxActive then
            DisableHitbox()
            EnableHitbox()
        end
    end)
end

ScaleInput.FocusLost:Connect(function()
    local val = tonumber(ScaleInput.Text)
    if val and val >= 1 and val <= 100 then
        HitboxScale = val
        if HitboxActive then
            DisableHitbox()
            EnableHitbox()
        end
    else
        ScaleInput.Text = tostring(HitboxScale)
    end
end)

-- ===== ВКЛАДКА "ВИД" =====
local ViewPanel = Instance.new("Frame")
ViewPanel.Size = UDim2.new(1, 0, 1, 0)
ViewPanel.BackgroundTransparency = 1
ViewPanel.Visible = false
ViewPanel.Parent = Content

local EspInfo = Instance.new("TextLabel")
EspInfo.Size = UDim2.new(0.9, 0, 0, 40)
EspInfo.Position = UDim2.new(0.05, 0, 0.05, 0)
EspInfo.Text = "ESP — красная обводка вокруг\nвсех врагов на сервере"
EspInfo.TextColor3 = Color3.fromRGB(180, 180, 210)
EspInfo.TextSize = 12
EspInfo.TextXAlignment = Enum.TextXAlignment.Center
EspInfo.BackgroundTransparency = 1
EspInfo.Font = Enum.Font.Gotham
EspInfo.Parent = ViewPanel

local EspBtn = Instance.new("TextButton")
EspBtn.Size = UDim2.new(0.9, 0, 0, 50)
EspBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
EspBtn.Text = "👁 ВКЛЮЧИТЬ ESP"
EspBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EspBtn.TextSize = 15
EspBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
EspBtn.BorderSizePixel = 0
EspBtn.Font = Enum.Font.GothamBold
EspBtn.Parent = ViewPanel
local EspCorner = Instance.new("UICorner")
EspCorner.CornerRadius = UDim.new(0, 8)
EspCorner.Parent = EspBtn

local EspStatus = Instance.new("TextLabel")
EspStatus.Size = UDim2.new(0.9, 0, 0, 22)
EspStatus.Position = UDim2.new(0.05, 0, 0.5, 0)
EspStatus.Text = "● ВЫКЛЮЧЕНО"
EspStatus.TextColor3 = Color3.fromRGB(200, 80, 80)
EspStatus.TextSize = 13
EspStatus.TextXAlignment = Enum.TextXAlignment.Center
EspStatus.BackgroundTransparency = 1
EspStatus.Font = Enum.Font.Gotham
EspStatus.Parent = ViewPanel

local EspColorLabel = Instance.new("TextLabel")
EspColorLabel.Size = UDim2.new(0.9, 0, 0, 20)
EspColorLabel.Position = UDim2.new(0.05, 0, 0.62, 0)
EspColorLabel.Text = "ЦВЕТ ОБВОДКИ"
EspColorLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
EspColorLabel.TextSize = 11
EspColorLabel.TextXAlignment = Enum.TextXAlignment.Left
EspColorLabel.BackgroundTransparency = 1
EspColorLabel.Font = Enum.Font.Gotham
EspColorLabel.Parent = ViewPanel

local ColorsFrame = Instance.new("Frame")
ColorsFrame.Size = UDim2.new(0.9, 0, 0, 40)
ColorsFrame.Position = UDim2.new(0.05, 0, 0.7, 0)
ColorsFrame.BackgroundTransparency = 1
ColorsFrame.Parent = ViewPanel

local colors = {
    {color = Color3.fromRGB(255, 0, 0)},
    {color = Color3.fromRGB(0, 255, 0)},
    {color = Color3.fromRGB(0, 150, 255)},
    {color = Color3.fromRGB(180, 0, 255)}
}

for i, c in ipairs(colors) do
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0.22, 0, 1, 0)
    colorBtn.Position = UDim2.new((i-1) * 0.26, 0, 0, 0)
    colorBtn.Text = ""
    colorBtn.BackgroundColor3 = c.color
    colorBtn.BorderSizePixel = 0
    colorBtn.Parent = ColorsFrame
    local colorCorner = Instance.new("UICorner")
    colorCorner.CornerRadius = UDim.new(0, 6)
    colorCorner.Parent = colorBtn
    
    colorBtn.MouseButton1Click:Connect(function()
        EspColor = c.color
        for _, highlight in pairs(EspHighlights) do
            if highlight and highlight.Parent then
                highlight.FillColor = EspColor
                highlight.OutlineColor = EspColor
            end
        end
    end)
end

-- ===== ВКЛАДКА "СТРЕЛЬБА" =====
local ShootPanel = Instance.new("Frame")
ShootPanel.Size = UDim2.new(1, 0, 1, 0)
ShootPanel.BackgroundTransparency = 1
ShootPanel.Visible = false
ShootPanel.Parent = Content

local ShootInfo = Instance.new("TextLabel")
ShootInfo.Size = UDim2.new(0.9, 0, 0, 50)
ShootInfo.Position = UDim2.new(0.05, 0, 0.03, 0)
ShootInfo.Text = "🔫 СТРЕЛЬБА СКВОЗЬ СТЕНЫ\n\nОтключает коллизии у стен вокруг\nтебя, чтобы пули проходили сквозь"
ShootInfo.TextColor3 = Color3.fromRGB(180, 180, 210)
ShootInfo.TextSize = 12
ShootInfo.TextXAlignment = Enum.TextXAlignment.Center
ShootInfo.BackgroundTransparency = 1
ShootInfo.Font = Enum.Font.Gotham
ShootInfo.Parent = ShootPanel

local WallbangBtn = Instance.new("TextButton")
WallbangBtn.Size = UDim2.new(0.9, 0, 0, 50)
WallbangBtn.Position = UDim2.new(0.05, 0, 0.32, 0)
WallbangBtn.Text = "🔫 ВКЛЮЧИТЬ WALLBANG"
WallbangBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
WallbangBtn.TextSize = 15
WallbangBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
WallbangBtn.BorderSizePixel = 0
WallbangBtn.Font = Enum.Font.GothamBold
WallbangBtn.Parent = ShootPanel
local WallbangCorner = Instance.new("UICorner")
WallbangCorner.CornerRadius = UDim.new(0, 8)
WallbangCorner.Parent = WallbangBtn

local WallbangStatus = Instance.new("TextLabel")
WallbangStatus.Size = UDim2.new(0.9, 0, 0, 22)
WallbangStatus.Position = UDim2.new(0.05, 0, 0.57, 0)
WallbangStatus.Text = "● ВЫКЛЮЧЕНО"
WallbangStatus.TextColor3 = Color3.fromRGB(200, 80, 80)
WallbangStatus.TextSize = 13
WallbangStatus.TextXAlignment = Enum.TextXAlignment.Center
WallbangStatus.BackgroundTransparency = 1
WallbangStatus.Font = Enum.Font.Gotham
WallbangStatus.Parent = ShootPanel

local RangeLabel = Instance.new("TextLabel")
RangeLabel.Size = UDim2.new(0.9, 0, 0, 20)
RangeLabel.Position = UDim2.new(0.05, 0, 0.68, 0)
RangeLabel.Text = "РАДИУС (студов)"
RangeLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
RangeLabel.TextSize = 11
RangeLabel.TextXAlignment = Enum.TextXAlignment.Left
RangeLabel.BackgroundTransparency = 1
RangeLabel.Font = Enum.Font.Gotham
RangeLabel.Parent = ShootPanel

local RangeInput = Instance.new("TextBox")
RangeInput.Size = UDim2.new(0.9, 0, 0, 35)
RangeInput.Position = UDim2.new(0.05, 0, 0.75, 0)
RangeInput.Text = "100"
RangeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
RangeInput.TextSize = 15
RangeInput.BackgroundColor3 = Color3.fromRGB(30, 33, 50)
RangeInput.BorderSizePixel = 0
RangeInput.TextXAlignment = Enum.TextXAlignment.Center
RangeInput.Font = Enum.Font.GothamBold
RangeInput.Parent = ShootPanel
local RangeCorner = Instance.new("UICorner")
RangeCorner.CornerRadius = UDim.new(0, 6)
RangeCorner.Parent = RangeInput

RangeInput.FocusLost:Connect(function()
    local val = tonumber(RangeInput.Text)
    if val and val >= 10 and val <= 1000 then
        WallbangRange = val
    else
        RangeInput.Text = tostring(WallbangRange)
    end
end)

-- ===== ФУНКЦИИ =====
local function GetHitboxParts(char)
    local parts = {}
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            table.insert(parts, part)
        end
    end
    return parts
end

-- ===== ХИТБОКСЫ =====
local function ApplyHitboxToPlayer(otherPlayer)
    if otherPlayer == Player then return end
    local char = otherPlayer.Character
    if not char then return end
    if char == Player.Character then return end
    
    local parts = GetHitboxParts(char)
    for _, part in ipairs(parts) do
        if not OriginalSizes[part] then
            OriginalSizes[part] = {Size = part.Size}
            part.Size = part.Size * HitboxScale
        end
    end
end

function EnableHitbox()
    HitboxActive = true
    OriginalSizes = {}
    
    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        ApplyHitboxToPlayer(otherPlayer)
    end
    
    HitboxBtn.Text = "🎯 ВЫКЛЮЧИТЬ ХИТБОКСЫ"
    HitboxBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
    HitboxStatus.Text = "● ВКЛЮЧЕНО (x" .. HitboxScale .. ")"
    HitboxStatus.TextColor3 = Color3.fromRGB(100, 200, 100)
end

function DisableHitbox()
    HitboxActive = false
    
    for part, data in pairs(OriginalSizes) do
        if part and part.Parent then
            part.Size = data.Size
        end
    end
    OriginalSizes = {}
    
    HitboxBtn.Text = "🎯 ВКЛЮЧИТЬ ХИТБОКСЫ"
    HitboxBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    HitboxStatus.Text = "● ВЫКЛЮЧЕНО"
    HitboxStatus.TextColor3 = Color3.fromRGB(200, 80, 80)
end

-- ===== ESP =====
local function CreateHighlight(char)
    if not char then return nil end
    local old = char:FindFirstChild("MurderESP")
    if old then old:Destroy() end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "MurderESP"
    highlight.FillColor = EspColor
    highlight.FillTransparency = 0.7
    highlight.OutlineColor = EspColor
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char
    
    return highlight
end

local function ApplyEspToPlayer(otherPlayer)
    if otherPlayer == Player then return end
    local char = otherPlayer.Character
    if not char then return end
    if char == Player.Character then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    
    local existing = char:FindFirstChild("MurderESP")
    if not existing then
        local highlight = CreateHighlight(char)
        if highlight then
            EspHighlights[otherPlayer] = highlight
        end
    end
end

function EnableEsp()
    EspActive = true
    EspHighlights = {}
    
    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        ApplyEspToPlayer(otherPlayer)
    end
    
    EspBtn.Text = "👁 ВЫКЛЮЧИТЬ ESP"
    EspBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
    EspStatus.Text = "● ВКЛЮЧЕНО"
    EspStatus.TextColor3 = Color3.fromRGB(100, 200, 100)
end

function DisableEsp()
    EspActive = false
    
    for _, highlight in pairs(EspHighlights) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
    end
    EspHighlights = {}
    
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p.Character then
            local h = p.Character:FindFirstChild("MurderESP")
            if h then h:Destroy() end
        end
    end
    
    EspBtn.Text = "👁 ВКЛЮЧИТЬ ESP"
    EspBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    EspStatus.Text = "● ВЫКЛЮЧЕНО"
    EspStatus.TextColor3 = Color3.fromRGB(200, 80, 80)
end

-- ===== WALLBANG =====
local function ApplyWallbang()
    local myChar = Player.Character
    if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local myPos = myRoot.Position
    
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Anchored then
            -- Пропускаем своего персонажа
            if not part:IsDescendantOf(myChar) then
                -- Пропускаем персонажей игроков
                local isPlayerPart = false
                for _, p in ipairs(game.Players:GetPlayers()) do
                    if p.Character and part:IsDescendantOf(p.Character) then
                        isPlayerPart = true
                        break
                    end
                end
                
                if not isPlayerPart then
                    local dist = (part.Position - myPos).Magnitude
                    if dist <= WallbangRange then
                        if not OriginalCollisions[part] then
                            OriginalCollisions[part] = part.CanCollide
                            part.CanCollide = false
                        end
                    end
                end
            end
        end
    end
end

local function RestoreWallbang()
    for part, data in pairs(OriginalCollisions) do
        if part and part.Parent then
            part.CanCollide = data
        end
    end
    OriginalCollisions = {}
end

function EnableWallbang()
    WallbangActive = true
    ApplyWallbang()
    WallbangBtn.Text = "🔫 ВЫКЛЮЧИТЬ WALLBANG"
    WallbangBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
    WallbangStatus.Text = "● ВКЛЮЧЕНО (радиус " .. WallbangRange .. ")"
    WallbangStatus.TextColor3 = Color3.fromRGB(100, 200, 100)
end

function DisableWallbang()
    WallbangActive = false
    RestoreWallbang()
    WallbangBtn.Text = "🔫 ВКЛЮЧИТЬ WALLBANG"
    WallbangBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    WallbangStatus.Text = "● ВЫКЛЮЧЕНО"
    WallbangStatus.TextColor3 = Color3.fromRGB(200, 80, 80)
end

-- ===== 🔥 ГОРЯЧАЯ КЛАВИША H =====
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == HitboxHotkey then
        if HitboxActive then
            DisableHitbox()
        else
            EnableHitbox()
        end
    end
end)

-- ===== ГЛАВНЫЙ ЦИКЛ =====
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(CheckInterval)
        
        if EspActive then
            for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
                ApplyEspToPlayer(otherPlayer)
            end
        end
        
        if HitboxActive then
            for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
                ApplyHitboxToPlayer(otherPlayer)
            end
        end
        
        if WallbangActive then
            ApplyWallbang()
        end
    end
end)

-- ===== ОТСЛЕЖИВАНИЕ НОВЫХ ПЕРСОНАЖЕЙ =====
local function OnCharacterAdded(otherPlayer)
    task.wait(1)
    if EspActive then ApplyEspToPlayer(otherPlayer) end
    if HitboxActive then ApplyHitboxToPlayer(otherPlayer) end
end

for _, p in ipairs(game.Players:GetPlayers()) do
    if p ~= Player then
        p.CharacterAdded:Connect(function()
            OnCharacterAdded(p)
        end)
    end
end

game.Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        OnCharacterAdded(p)
    end)
end)

-- ===== ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК =====
HitboxTab.MouseButton1Click:Connect(function()
    HitboxPanel.Visible = true
    ViewPanel.Visible = false
    ShootPanel.Visible = false
    HitboxTab.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
    HitboxTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    ViewTab.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
    ViewTab.TextColor3 = Color3.fromRGB(180, 180, 210)
    ShootTab.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
    ShootTab.TextColor3 = Color3.fromRGB(180, 180, 210)
end)

ViewTab.MouseButton1Click:Connect(function()
    HitboxPanel.Visible = false
    ViewPanel.Visible = true
    ShootPanel.Visible = false
    ViewTab.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
    ViewTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    HitboxTab.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
    HitboxTab.TextColor3 = Color3.fromRGB(180, 180, 210)
    ShootTab.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
    ShootTab.TextColor3 = Color3.fromRGB(180, 180, 210)
end)

ShootTab.MouseButton1Click:Connect(function()
    HitboxPanel.Visible = false
    ViewPanel.Visible = false
    ShootPanel.Visible = true
    ShootTab.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
    ShootTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    HitboxTab.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
    HitboxTab.TextColor3 = Color3.fromRGB(180, 180, 210)
    ViewTab.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
    ViewTab.TextColor3 = Color3.fromRGB(180, 180, 210)
end)

-- ===== КНОПКИ =====
HitboxBtn.MouseButton1Click:Connect(function()
    if HitboxActive then DisableHitbox() else EnableHitbox() end
end)

EspBtn.MouseButton1Click:Connect(function()
    if EspActive then DisableEsp() else EnableEsp() end
end)

WallbangBtn.MouseButton1Click:Connect(function()
    if WallbangActive then DisableWallbang() else EnableWallbang() end
end)

CloseBtn.MouseButton1Click:Connect(function()
    if HitboxActive then DisableHitbox() end
    if EspActive then DisableEsp() end
    if WallbangActive then DisableWallbang() end
    ScreenGui:Destroy()
end)

print("✅ Murder Duels загружено! Хитбоксы + ESP + Wallbang. H — вкл/выкл хитбоксы")
