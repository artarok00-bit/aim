-- [[ Murder Duels — ХИТБОКС ГОЛОВЫ + ESP + WALLBANG ]]
-- Хитбокс головы, ESP, стрельба сквозь стены

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- ===== НАСТРОЙКИ =====
local CheckInterval = 0.2

-- ===== ХИТБОКС =====
local HitboxScale = 5
local HitboxActive = false
local OriginalSizes = {}

-- ===== ESP =====
local EspActive = false
local EspColor = Color3.fromRGB(255, 0, 0)
local EspHighlights = {}

-- ===== WALLBANG =====
local WallbangActive = false
local OriginalCollisions = {} -- [part] = CanCollide

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
HitboxTab.Text = "🎯 ГОЛОВА"
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

local WallbangTab = Instance.new("TextButton")
WallbangTab.Size = UDim2.new(0.33, 0, 1, 0)
WallbangTab.Position = UDim2.new(0.67, 0, 0, 0)
WallbangTab.Text = "🔫 WALLBANG"
WallbangTab.TextColor3 = Color3.fromRGB(180, 180, 210)
WallbangTab.TextSize = 12
WallbangTab.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
WallbangTab.BorderSizePixel = 0
WallbangTab.Font = Enum.Font.GothamSemibold
WallbangTab.Parent = TabBar

-- Контент
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -75)
Content.Position = UDim2.new(0, 0, 0, 75)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- ===== ВКЛАДКА "ГОЛОВА" =====
local HitboxPanel = Instance.new("Frame")
HitboxPanel.Size = UDim2.new(1, 0, 1, 0)
HitboxPanel.BackgroundTransparency = 1
HitboxPanel.Parent = Content

local HitboxInfo = Instance.new("TextLabel")
HitboxInfo.Size = UDim2.new(0.9, 0, 0, 40)
HitboxInfo.Position = UDim2.new(0.05, 0, 0.05, 0)
HitboxInfo.Text = "Увеличивает голову врагов\n(включая NPC)"
HitboxInfo.TextColor3 = Color3.fromRGB(180, 180, 210)
HitboxInfo.TextSize = 12
HitboxInfo.TextXAlignment = Enum.TextXAlignment.Center
HitboxInfo.BackgroundTransparency = 1
HitboxInfo.Font = Enum.Font.Gotham
HitboxInfo.Parent = HitboxPanel

local HitboxBtn = Instance.new("TextButton")
HitboxBtn.Size = UDim2.new(0.9, 0, 0, 50)
HitboxBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
HitboxBtn.Text = "🎯 ВКЛЮЧИТЬ ХИТБОКС ГОЛОВЫ"
HitboxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HitboxBtn.TextSize = 14
HitboxBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
HitboxBtn.BorderSizePixel = 0
HitboxBtn.Font = Enum.Font.GothamBold
HitboxBtn.Parent = HitboxPanel
local HitboxCorner = Instance.new("UICorner")
HitboxCorner.CornerRadius = UDim.new(0, 8)
HitboxCorner.Parent = HitboxBtn

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
ScaleLabel.Text = "РАЗМЕР (1-100)"
ScaleLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
ScaleLabel.TextSize = 11
ScaleLabel.TextXAlignment = Enum.TextXAlignment.Left
ScaleLabel.BackgroundTransparency = 1
ScaleLabel.Font = Enum.Font.Gotham
ScaleLabel.Parent = HitboxPanel

local ScaleInput = Instance.new("TextBox")
ScaleInput.Size = UDim2.new(0.9, 0, 0, 35)
ScaleInput.Position = UDim2.new(0.05, 0, 0.7, 0)
ScaleInput.Text = "5"
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

for i, val in ipairs({3, 5, 10, 30, 100}) do
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

-- ===== ВКЛАДКА "WALLBANG" =====
local WallbangPanel = Instance.new("Frame")
WallbangPanel.Size = UDim2.new(1, 0, 1, 0)
WallbangPanel.BackgroundTransparency = 1
WallbangPanel.Visible = false
WallbangPanel.Parent = Content

local WallbangInfo = Instance.new("TextLabel")
WallbangInfo.Size = UDim2.new(0.9, 0, 0, 60)
WallbangInfo.Position = UDim2.new(0.05, 0, 0.05, 0)
WallbangInfo.Text = "🔫 СТРЕЛЬБА СКВОЗЬ СТЕНЫ\n\nОтключает коллизии у стен вокруг\nчтобы пули проходили насквозь"
WallbangInfo.TextColor3 = Color3.fromRGB(180, 180, 210)
WallbangInfo.TextSize = 12
WallbangInfo.TextXAlignment = Enum.TextXAlignment.Center
WallbangInfo.BackgroundTransparency = 1
WallbangInfo.Font = Enum.Font.Gotham
WallbangInfo.Parent = WallbangPanel

local WallbangBtn = Instance.new("TextButton")
WallbangBtn.Size = UDim2.new(0.9, 0, 0, 50)
WallbangBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
WallbangBtn.Text = "🔫 ВКЛЮЧИТЬ WALLBANG"
WallbangBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
WallbangBtn.TextSize = 14
WallbangBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
WallbangBtn.BorderSizePixel = 0
WallbangBtn.Font = Enum.Font.GothamBold
WallbangBtn.Parent = WallbangPanel
local WallbangCorner = Instance.new("UICorner")
WallbangCorner.CornerRadius = UDim.new(0, 8)
WallbangCorner.Parent = WallbangBtn

local WallbangStatus = Instance.new("TextLabel")
WallbangStatus.Size = UDim2.new(0.9, 0, 0, 22)
WallbangStatus.Position = UDim2.new(0.05, 0, 0.55, 0)
WallbangStatus.Text = "● ВЫКЛЮЧЕНО"
WallbangStatus.TextColor3 = Color3.fromRGB(200, 80, 80)
WallbangStatus.TextSize = 13
WallbangStatus.TextXAlignment = Enum.TextXAlignment.Center
WallbangStatus.BackgroundTransparency = 1
WallbangStatus.Font = Enum.Font.Gotham
WallbangStatus.Parent = WallbangPanel

local WallbangRange = Instance.new("TextLabel")
WallbangRange.Size = UDim2.new(0.9, 0, 0, 20)
WallbangRange.Position = UDim2.new(0.05, 0, 0.68, 0)
WallbangRange.Text = "РАДИУС (студов)"
WallbangRange.TextColor3 = Color3.fromRGB(180, 180, 210)
WallbangRange.TextSize = 11
WallbangRange.TextXAlignment = Enum.TextXAlignment.Left
WallbangRange.BackgroundTransparency = 1
WallbangRange.Font = Enum.Font.Gotham
WallbangRange.Parent = WallbangPanel

local RangeInput = Instance.new("TextBox")
RangeInput.Size = UDim2.new(0.9, 0, 0, 30)
RangeInput.Position = UDim2.new(0.05, 0, 0.75, 0)
RangeInput.Text = "50"
RangeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
RangeInput.TextSize = 14
RangeInput.BackgroundColor3 = Color3.fromRGB(30, 33, 50)
RangeInput.BorderSizePixel = 0
RangeInput.TextXAlignment = Enum.TextXAlignment.Center
RangeInput.Font = Enum.Font.GothamBold
RangeInput.Parent = WallbangPanel
local RangeCorner = Instance.new("UICorner")
RangeCorner.CornerRadius = UDim.new(0, 6)
RangeCorner.Parent = RangeInput

-- ===== УНИВЕРСАЛЬНЫЙ ПОИСК ГОЛОВЫ =====
local function GetHeadParts(char)
    local heads = {}
    local head = char:FindFirstChild("Head")
    if head and head:IsA("BasePart") then
        table.insert(heads, head)
    end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and string.find(string.lower(part.Name), "head") then
            if not table.find(heads, part) then
                table.insert(heads, part)
            end
        end
    end
    if #heads == 0 then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Position.Y > root.Position.Y + 1 then
                    table.insert(heads, part)
                end
            end
        end
    end
    return heads
end

-- ===== ХИТБОКС =====
local function ApplyHitboxToPlayer(otherPlayer)
    if otherPlayer == Player then return end
    local char = otherPlayer.Character
    if not char or char == Player.Character then return end
    
    local heads = GetHeadParts(char)
    for _, head in ipairs(heads) do
        if not OriginalSizes[head] then
            OriginalSizes[head] = {Size = head.Size}
            head.Size = head.Size * HitboxScale
        end
    end
end

local function ApplyHitboxToNPCs()
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and not game.Players:GetPlayerFromCharacter(obj) then
            local humanoid = obj:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local heads = GetHeadParts(obj)
                for _, head in ipairs(heads) do
                    if not OriginalSizes[head] then
                        OriginalSizes[head] = {Size = head.Size}
                        head.Size = head.Size * HitboxScale
                    end
                end
            end
        end
    end
end

function EnableHitbox()
    HitboxActive = true
    OriginalSizes = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        ApplyHitboxToPlayer(p)
    end
    ApplyHitboxToNPCs()
    HitboxBtn.Text = "🎯 ВЫКЛЮЧИТЬ ХИТБОКС ГОЛОВЫ"
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
    HitboxBtn.Text = "🎯 ВКЛЮЧИТЬ ХИТБОКС ГОЛОВЫ"
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
    if not char or char == Player.Character then return end
    if not char:FindFirstChildOfClass("Humanoid") then return end
    if char:FindFirstChild("MurderESP") then return end
    local highlight = CreateHighlight(char)
    if highlight then EspHighlights[otherPlayer] = highlight end
end

local function ApplyEspToNPCs()
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and not game.Players:GetPlayerFromCharacter(obj) then
            if obj:FindFirstChildOfClass("Humanoid") and not obj:FindFirstChild("MurderESP") then
                CreateHighlight(obj)
            end
        end
    end
end

function EnableEsp()
    EspActive = true
    EspHighlights = {}
    for _, p in ipairs(game.Players:GetPlayers()) do ApplyEspToPlayer(p) end
    ApplyEspToNPCs()
    EspBtn.Text = "👁 ВЫКЛЮЧИТЬ ESP"
    EspBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
    EspStatus.Text = "● ВКЛЮЧЕНО"
    EspStatus.TextColor3 = Color3.fromRGB(100, 200, 100)
end

function DisableEsp()
    EspActive = false
    for _, h in pairs(EspHighlights) do
        if h and h.Parent then h:Destroy() end
    end
    EspHighlights = {}
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") then
            local h = obj:FindFirstChild("MurderESP")
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
    
    local range = tonumber(RangeInput.Text) or 50
    local myPos = myRoot.Position
    
    -- Проходим по всем частям в радиусе и отключаем коллизии (только для стен)
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            -- Пропускаем части персонажа и моего персонажа
            if not part:IsDescendantOf(myChar) then
                -- Проверяем что это часть карты (не игрок, не NPC)
                local isCharacter = false
                for _, p in ipairs(game.Players:GetPlayers()) do
                    if p.Character and part:IsDescendantOf(p.Character) then
                        isCharacter = true
                        break
                    end
                end
                
                if not isCharacter and part.Anchored then
                    local dist = (part.Position - myPos).Magnitude
                    if dist <= range then
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
    WallbangStatus.Text = "● ВКЛЮЧЕНО"
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

-- ===== ГЛАВНЫЙ ЦИКЛ =====
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(CheckInterval)
        if EspActive then
            for _, p in ipairs(game.Players:GetPlayers()) do ApplyEspToPlayer(p) end
            ApplyEspToNPCs()
        end
        if HitboxActive then
            for _, p in ipairs(game.Players:GetPlayers()) do ApplyHitboxToPlayer(p) end
            ApplyHitboxToNPCs()
        end
        if WallbangActive then
            ApplyWallbang()
        end
    end
end)

-- ===== ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК =====
HitboxTab.MouseButton1Click:Connect(function()
    HitboxPanel.Visible = true
    ViewPanel.Visible = false
    WallbangPanel.Visible = false
    HitboxTab.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
    HitboxTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    ViewTab.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
    ViewTab.TextColor3 = Color3.fromRGB(180, 180, 210)
    WallbangTab.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
    WallbangTab.TextColor3 = Color3.fromRGB(180, 180, 210)
end)

ViewTab.MouseButton1Click:Connect(function()
    HitboxPanel.Visible = false
    ViewPanel.Visible = true
    WallbangPanel.Visible = false
    ViewTab.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
    ViewTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    HitboxTab.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
    HitboxTab.TextColor3 = Color3.fromRGB(180, 180, 210)
    WallbangTab.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
    WallbangTab.TextColor3 = Color3.fromRGB(180, 180, 210)
end)

WallbangTab.MouseButton1Click:Connect(function()
    HitboxPanel.Visible = false
    ViewPanel.Visible = false
    WallbangPanel.Visible = true
    WallbangTab.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
    WallbangTab.TextColor3 = Color3.fromRGB(255, 255, 255)
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

print("✅ Murder Duels загружено! Голова + ESP + Wallbang")
