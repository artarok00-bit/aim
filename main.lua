-- [[ Murder Duels — THUNDERHUB STYLE UI ]]
-- H — вкл/выкл хитбоксы
-- Интерфейс в стиле ThunderHub MM2

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

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

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MurderDuelsMenu"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ===== ГЛАВНОЕ ОКНО =====
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 620, 0, 420)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 20)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

-- Фон (картинка)
local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.Position = UDim2.new(0, 0, 0, 0)
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Image = "rbxassetid://133445291771070" -- затемнённый фон с девушкой
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.ZIndex = 0
BackgroundImage.Parent = MainFrame

local BackgroundDarken = Instance.new("Frame")
BackgroundDarken.Size = UDim2.new(1, 0, 1, 0)
BackgroundDarken.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BackgroundDarken.BackgroundTransparency = 0.4
BackgroundDarken.BorderSizePixel = 0
BackgroundDarken.ZIndex = 1
BackgroundDarken.Parent = MainFrame

local DarkenCorner = Instance.new("UICorner")
DarkenCorner.CornerRadius = UDim.new(0, 14)
DarkenCorner.Parent = BackgroundDarken

-- ===== ШАПКА =====
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 12, 12)
TopBar.BackgroundTransparency = 0.3
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 5
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 14)
TopCorner.Parent = TopBar

-- Логотип
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 35, 0, 35)
Logo.Position = UDim2.new(0.02, 0, 0.1, 0)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://133445291771070"
Logo.ScaleType = Enum.ScaleType.Crop
Logo.ZIndex = 6
Logo.Parent = TopBar

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 6)
LogoCorner.Parent = Logo

-- Название
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.4, 0, 0, 20)
Title.Position = UDim2.new(0.09, 0, 0.1, 0)
Title.Text = "THUNDERHUB MM2 🔥"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.ZIndex = 6
Title.Parent = TopBar

-- Автор
local Author = Instance.new("TextLabel")
Author.Size = UDim2.new(0.4, 0, 0, 16)
Author.Position = UDim2.new(0.09, 0, 0.55, 0)
Author.Text = "by CaJfin & Zepr"
Author.TextColor3 = Color3.fromRGB(180, 180, 180)
Author.TextSize = 11
Author.TextXAlignment = Enum.TextXAlignment.Left
Author.BackgroundTransparency = 1
Author.Font = Enum.Font.Gotham
Author.ZIndex = 6
Author.Parent = TopBar

-- Кнопка версии
local VersionBadge = Instance.new("TextButton")
VersionBadge.Size = UDim2.new(0, 130, 0, 28)
VersionBadge.Position = UDim2.new(0.42, 0, 0.2, 0)
VersionBadge.Text = "Версия 7.8.2 alpha"
VersionBadge.TextColor3 = Color3.fromRGB(0, 0, 0)
VersionBadge.TextSize = 12
VersionBadge.BackgroundColor3 = Color3.fromRGB(80, 255, 100)
VersionBadge.BorderSizePixel = 0
VersionBadge.Font = Enum.Font.GothamBold
VersionBadge.ZIndex = 6
VersionBadge.Parent = TopBar

local VersionCorner = Instance.new("UICorner")
VersionCorner.CornerRadius = UDim.new(0, 14)
VersionCorner.Parent = VersionBadge

-- Кнопки управления (свернуть/закрыть)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -75, 0.15, 0)
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.TextSize = 16
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Font = Enum.Font.Gotham
MinimizeBtn.ZIndex = 6
MinimizeBtn.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.15, 0)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.TextSize = 14
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.ZIndex = 6
CloseBtn.Parent = TopBar

-- ===== ЛЕВОЕ МЕНЮ =====
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -50)
Sidebar.Position = UDim2.new(0, 5, 0, 48)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 12, 12)
Sidebar.BackgroundTransparency = 0.4
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 5
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 10)
SidebarCorner.Parent = Sidebar

-- Поиск
local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(0.9, 0, 0, 30)
SearchBox.Position = UDim2.new(0.05, 0, 0.02, 0)
SearchBox.Text = ""
SearchBox.PlaceholderText = "🔍 Search"
SearchBox.TextColor3 = Color3.fromRGB(200, 200, 200)
SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SearchBox.TextSize = 12
SearchBox.BackgroundColor3 = Color3.fromRGB(30, 25, 25)
SearchBox.BackgroundTransparency = 0.2
SearchBox.BorderSizePixel = 0
SearchBox.Font = Enum.Font.Gotham
SearchBox.ZIndex = 6
SearchBox.Parent = Sidebar

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 8)
SearchCorner.Parent = SearchBox

-- Кнопки вкладок
local function CreateSidebarButton(name, icon, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.Text = "  " .. icon .. "  " .. name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 12
    btn.BackgroundTransparency = 1
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 6
    btn.Parent = Sidebar
    return btn
end

local TabChar = CreateSidebarButton("Персонаж", "👤", 50)
local TabTeleport = CreateSidebarButton("Телепорт", "🌀", 85)
local TabCombat = CreateSidebarButton("Комбат", "⚔️", 120)
local TabTrolling = CreateSidebarButton("Троллинг", "😈", 155)
local TabWallhack = CreateSidebarButton("Валлхак", "🧱", 190)
local TabVisual = CreateSidebarButton("Визуал", "👁", 225)
local TabButtons = CreateSidebarButton("Кнопки", "🎮", 260)

-- ===== ПРАВАЯ ПАНЕЛЬ =====
local RightPanel = Instance.new("Frame")
RightPanel.Size = UDim2.new(1, -165, 1, -50)
RightPanel.Position = UDim2.new(0, 160, 0, 48)
RightPanel.BackgroundTransparency = 1
RightPanel.ZIndex = 5
RightPanel.Parent = MainFrame

-- Заголовок панели
local PanelTitle = Instance.new("TextLabel")
PanelTitle.Size = UDim2.new(0.9, 0, 0, 25)
PanelTitle.Position = UDim2.new(0.05, 0, 0.02, 0)
PanelTitle.Text = "Визуал"
PanelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PanelTitle.TextSize = 15
PanelTitle.TextXAlignment = Enum.TextXAlignment.Left
PanelTitle.BackgroundTransparency = 1
PanelTitle.Font = Enum.Font.GothamBold
PanelTitle.ZIndex = 6
PanelTitle.Parent = RightPanel

-- ===== КАРТОЧКА ESP =====
local EspCard = Instance.new("Frame")
EspCard.Size = UDim2.new(0.95, 0, 0, 80)
EspCard.Position = UDim2.new(0.025, 0, 0.1, 0)
EspCard.BackgroundColor3 = Color3.fromRGB(35, 28, 28)
EspCard.BackgroundTransparency = 0.15
EspCard.BorderSizePixel = 0
EspCard.ZIndex = 6
EspCard.Parent = RightPanel

local EspCardCorner = Instance.new("UICorner")
EspCardCorner.CornerRadius = UDim.new(0, 12)
EspCardCorner.Parent = EspCard

local EspCardTitle = Instance.new("TextLabel")
EspCardTitle.Size = UDim2.new(0.7, 0, 0, 20)
EspCardTitle.Position = UDim2.new(0.05, 0, 0.1, 0)
EspCardTitle.Text = "Показать ESP"
EspCardTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
EspCardTitle.TextSize = 13
EspCardTitle.TextXAlignment = Enum.TextXAlignment.Left
EspCardTitle.BackgroundTransparency = 1
EspCardTitle.Font = Enum.Font.GothamSemibold
EspCardTitle.ZIndex = 7
EspCardTitle.Parent = EspCard

local EspCardDesc = Instance.new("TextLabel")
EspCardDesc.Size = UDim2.new(0.7, 0, 0, 18)
EspCardDesc.Position = UDim2.new(0.05, 0, 0.38, 0)
EspCardDesc.Text = "Обводка врагов через стены"
EspCardDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
EspCardDesc.TextSize = 11
EspCardDesc.TextXAlignment = Enum.TextXAlignment.Left
EspCardDesc.BackgroundTransparency = 1
EspCardDesc.Font = Enum.Font.Gotham
EspCardDesc.ZIndex = 7
EspCardDesc.Parent = EspCard

local EspToggleBg = Instance.new("Frame")
EspToggleBg.Size = UDim2.new(0, 45, 0, 24)
EspToggleBg.Position = UDim2.new(1, -55, 0.5, -12)
EspToggleBg.BackgroundColor3 = Color3.fromRGB(60, 55, 55)
EspToggleBg.BorderSizePixel = 0
EspToggleBg.ZIndex = 7
EspToggleBg.Parent = EspCard

local EspToggleBgCorner = Instance.new("UICorner")
EspToggleBgCorner.CornerRadius = UDim.new(1, 0)
EspToggleBgCorner.Parent = EspToggleBg

local EspToggleKnob = Instance.new("Frame")
EspToggleKnob.Size = UDim2.new(0, 18, 0, 18)
EspToggleKnob.Position = UDim2.new(0, 3, 0.5, -9)
EspToggleKnob.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
EspToggleKnob.BorderSizePixel = 0
EspToggleKnob.ZIndex = 8
EspToggleKnob.Parent = EspToggleBg

local EspToggleKnobCorner = Instance.new("UICorner")
EspToggleKnobCorner.CornerRadius = UDim.new(1, 0)
EspToggleKnobCorner.Parent = EspToggleKnob

-- Кнопка ESP (для нажатия)
local EspToggleBtn = Instance.new("TextButton")
EspToggleBtn.Size = UDim2.new(1, 0, 1, 0)
EspToggleBtn.BackgroundTransparency = 1
EspToggleBtn.Text = ""
EspToggleBtn.ZIndex = 9
EspToggleBtn.Parent = EspCard

-- ===== КАРТОЧКА ХИТБОКСА =====
local HitboxCard = Instance.new("Frame")
HitboxCard.Size = UDim2.new(0.95, 0, 0, 80)
HitboxCard.Position = UDim2.new(0.025, 0, 0.35, 0)
HitboxCard.BackgroundColor3 = Color3.fromRGB(35, 28, 28)
HitboxCard.BackgroundTransparency = 0.15
HitboxCard.BorderSizePixel = 0
HitboxCard.ZIndex = 6
HitboxCard.Parent = RightPanel

local HitboxCardCorner = Instance.new("UICorner")
HitboxCardCorner.CornerRadius = UDim.new(0, 12)
HitboxCardCorner.Parent = HitboxCard

local HitboxCardTitle = Instance.new("TextLabel")
HitboxCardTitle.Size = UDim2.new(0.7, 0, 0, 20)
HitboxCardTitle.Position = UDim2.new(0.05, 0, 0.1, 0)
HitboxCardTitle.Text = "Увеличить хитбоксы"
HitboxCardTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HitboxCardTitle.TextSize = 13
HitboxCardTitle.TextXAlignment = Enum.TextXAlignment.Left
HitboxCardTitle.BackgroundTransparency = 1
HitboxCardTitle.Font = Enum.Font.GothamSemibold
HitboxCardTitle.ZIndex = 7
HitboxCardTitle.Parent = HitboxCard

local HitboxCardDesc = Instance.new("TextLabel")
HitboxCardDesc.Size = UDim2.new(0.7, 0, 0, 18)
HitboxCardDesc.Position = UDim2.new(0.05, 0, 0.38, 0)
HitboxCardDesc.Text = "Легче попасть по врагам"
HitboxCardDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
HitboxCardDesc.TextSize = 11
HitboxCardDesc.TextXAlignment = Enum.TextXAlignment.Left
HitboxCardDesc.BackgroundTransparency = 1
HitboxCardDesc.Font = Enum.Font.Gotham
HitboxCardDesc.ZIndex = 7
HitboxCardDesc.Parent = HitboxCard

local HitboxToggleBg = Instance.new("Frame")
HitboxToggleBg.Size = UDim2.new(0, 45, 0, 24)
HitboxToggleBg.Position = UDim2.new(1, -55, 0.5, -12)
HitboxToggleBg.BackgroundColor3 = Color3.fromRGB(60, 55, 55)
HitboxToggleBg.BorderSizePixel = 0
HitboxToggleBg.ZIndex = 7
HitboxToggleBg.Parent = HitboxCard

local HitboxToggleBgCorner = Instance.new("UICorner")
HitboxToggleBgCorner.CornerRadius = UDim.new(1, 0)
HitboxToggleBgCorner.Parent = HitboxToggleBg

local HitboxToggleKnob = Instance.new("Frame")
HitboxToggleKnob.Size = UDim2.new(0, 18, 0, 18)
HitboxToggleKnob.Position = UDim2.new(0, 3, 0.5, -9)
HitboxToggleKnob.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
HitboxToggleKnob.BorderSizePixel = 0
HitboxToggleKnob.ZIndex = 8
HitboxToggleKnob.Parent = HitboxToggleBg

local HitboxToggleKnobCorner = Instance.new("UICorner")
HitboxToggleKnobCorner.CornerRadius = UDim.new(1, 0)
HitboxToggleKnobCorner.Parent = HitboxToggleKnob

local HitboxToggleBtn = Instance.new("TextButton")
HitboxToggleBtn.Size = UDim2.new(1, 0, 1, 0)
HitboxToggleBtn.BackgroundTransparency = 1
HitboxToggleBtn.Text = ""
HitboxToggleBtn.ZIndex = 9
HitboxToggleBtn.Parent = HitboxCard

-- ===== КАРТОЧКА РАЗМЕРА ХИТБОКСА =====
local SizeCard = Instance.new("Frame")
SizeCard.Size = UDim2.new(0.95, 0, 0, 55)
SizeCard.Position = UDim2.new(0.025, 0, 0.6, 0)
SizeCard.BackgroundColor3 = Color3.fromRGB(35, 28, 28)
SizeCard.BackgroundTransparency = 0.15
SizeCard.BorderSizePixel = 0
SizeCard.ZIndex = 6
SizeCard.Parent = RightPanel

local SizeCardCorner = Instance.new("UICorner")
SizeCardCorner.CornerRadius = UDim.new(0, 12)
SizeCardCorner.Parent = SizeCard

local SizeTitle = Instance.new("TextLabel")
SizeTitle.Size = UDim2.new(0.5, 0, 0, 20)
SizeTitle.Position = UDim2.new(0.05, 0, 0.15, 0)
SizeTitle.Text = "Размер хитбокса"
SizeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SizeTitle.TextSize = 12
SizeTitle.TextXAlignment = Enum.TextXAlignment.Left
SizeTitle.BackgroundTransparency = 1
SizeTitle.Font = Enum.Font.GothamSemibold
SizeTitle.ZIndex = 7
SizeTitle.Parent = SizeCard

local SizeInput = Instance.new("TextBox")
SizeInput.Size = UDim2.new(0.2, 0, 0, 28)
SizeInput.Position = UDim2.new(0.75, 0, 0.5, -14)
SizeInput.Text = "3"
SizeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SizeInput.TextSize = 13
SizeInput.BackgroundColor3 = Color3.fromRGB(50, 42, 42)
SizeInput.BackgroundTransparency = 0.2
SizeInput.BorderSizePixel = 0
SizeInput.Font = Enum.Font.GothamBold
SizeInput.TextXAlignment = Enum.TextXAlignment.Center
SizeInput.ZIndex = 7
SizeInput.Parent = SizeCard

local SizeInputCorner = Instance.new("UICorner")
SizeInputCorner.CornerRadius = UDim.new(0, 6)
SizeInputCorner.Parent = SizeInput

-- ===== ФУНКЦИИ =====
local function UpdateToggle(toggleBg, toggleKnob, enabled)
    if enabled then
        toggleBg.BackgroundColor3 = Color3.fromRGB(255, 160, 50)
        TweenService:Create(toggleKnob, TweenInfo.new(0.2), {Position = UDim2.new(0, 24, 0.5, -9)}):Play()
    else
        toggleBg.BackgroundColor3 = Color3.fromRGB(60, 55, 55)
        TweenService:Create(toggleKnob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
    end
end

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
    UpdateToggle(HitboxToggleBg, HitboxToggleKnob, true)
end

function DisableHitbox()
    HitboxActive = false
    for part, data in pairs(OriginalSizes) do
        if part and part.Parent then
            part.Size = data.Size
        end
    end
    OriginalSizes = {}
    UpdateToggle(HitboxToggleBg, HitboxToggleKnob, false)
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
    
    if not char:FindFirstChild("MurderESP") then
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
    UpdateToggle(EspToggleBg, EspToggleKnob, true)
end

function DisableEsp()
    EspActive = false
    for _, highlight in pairs(EspHighlights) do
        if highlight and highlight.Parent then highlight:Destroy() end
    end
    EspHighlights = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p.Character then
            local h = p.Character:FindFirstChild("MurderESP")
            if h then h:Destroy() end
        end
    end
    UpdateToggle(EspToggleBg, EspToggleKnob, false)
end

-- ===== ГОРЯЧАЯ КЛАВИША =====
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == HitboxHotkey then
        if HitboxActive then DisableHitbox() else EnableHitbox() end
    end
end)

-- ===== ГЛАВНЫЙ ЦИКЛ =====
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(CheckInterval)
        if EspActive then
            for _, p in ipairs(game.Players:GetPlayers()) do ApplyEspToPlayer(p) end
        end
        if HitboxActive then
            for _, p in ipairs(game.Players:GetPlayers()) do ApplyHitboxToPlayer(p) end
        end
    end
end)

-- ===== НОВЫЕ ПЕРСОНАЖИ =====
local function OnCharacterAdded(otherPlayer)
    task.wait(1)
    if EspActive then ApplyEspToPlayer(otherPlayer) end
    if HitboxActive then ApplyHitboxToPlayer(otherPlayer) end
end

for _, p in ipairs(game.Players:GetPlayers()) do
    if p ~= Player then
        p.CharacterAdded:Connect(function() OnCharacterAdded(p) end)
    end
end

game.Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() OnCharacterAdded(p) end)
end)

-- ===== КНОПКИ =====
EspToggleBtn.MouseButton1Click:Connect(function()
    if EspActive then DisableEsp() else EnableEsp() end
end)

HitboxToggleBtn.MouseButton1Click:Connect(function()
    if HitboxActive then DisableHitbox() else EnableHitbox() end
end)

SizeInput.FocusLost:Connect(function()
    local val = tonumber(SizeInput.Text)
    if val and val >= 1 and val <= 100 then
        HitboxScale = val
        if HitboxActive then DisableHitbox(); EnableHitbox() end
    else
        SizeInput.Text = tostring(HitboxScale)
    end
end)

-- ===== ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК (визуальное) =====
local function ResetTabs()
    for _, tab in pairs({TabChar, TabTeleport, TabCombat, TabTrolling, TabWallhack, TabVisual, TabButtons}) do
        tab.TextColor3 = Color3.fromRGB(200, 200, 200)
        tab.BackgroundTransparency = 1
    end
end

TabVisual.MouseButton1Click:Connect(function()
    ResetTabs()
    TabVisual.TextColor3 = Color3.fromRGB(255, 255, 255)
    PanelTitle.Text = "Визуал"
end)

TabWallhack.MouseButton1Click:Connect(function()
    ResetTabs()
    TabWallhack.TextColor3 = Color3.fromRGB(255, 255, 255)
    PanelTitle.Text = "Валлхак"
end)

-- ===== ЗАКРЫТИЕ =====
CloseBtn.MouseButton1Click:Connect(function()
    if HitboxActive then DisableHitbox() end
    if EspActive then DisableEsp() end
    ScreenGui:Destroy()
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    if MainFrame.Size.Y.Offset == 420 then
        MainFrame.Size = UDim2.new(0, 620, 0, 50)
    else
        MainFrame.Size = UDim2.new(0, 620, 0, 420)
    end
end)

print("✅ Murder Duels — ThunderHub Style UI загружен!")
print("H — вкл/выкл хитбоксы")
