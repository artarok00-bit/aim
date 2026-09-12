-- [[ Murder Duels — AIMBOT + ХИТБОКСЫ ]]
-- Вкладка "АИМ": выбор цели, наводка на тело
-- Вкладка "ХИТБОКСЫ": увеличение хитбоксов врагов

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- ===== НАСТРОЙКИ =====
local AimbotActive = true
local IsAiming = false
local Smoothness = 0.5
local SelectedPlayer = nil
local RefreshCooldown = 5

-- ===== ХИТБОКСЫ =====
local HitboxScale = 3
local HitboxActive = false
local OriginalSizes = {}

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MurderDuelsMenu"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

-- ===== ШАПКА =====
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.Position = UDim2.new(0, 0, 0, 0)
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

-- ===== ВКЛАДКИ =====
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 35)
TabBar.Position = UDim2.new(0, 0, 0, 40)
TabBar.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local AimTab = Instance.new("TextButton")
AimTab.Size = UDim2.new(0.5, 0, 1, 0)
AimTab.Position = UDim2.new(0, 0, 0, 0)
AimTab.Text = "🎯 АИМ"
AimTab.TextColor3 = Color3.fromRGB(255, 255, 255)
AimTab.TextSize = 13
AimTab.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
AimTab.BorderSizePixel = 0
AimTab.Font = Enum.Font.GothamSemibold
AimTab.Parent = TabBar

local HitboxTab = Instance.new("TextButton")
HitboxTab.Size = UDim2.new(0.5, 0, 1, 0)
HitboxTab.Position = UDim2.new(0.5, 0, 0, 0)
HitboxTab.Text = "📦 ХИТБОКСЫ"
HitboxTab.TextColor3 = Color3.fromRGB(180, 180, 210)
HitboxTab.TextSize = 13
HitboxTab.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
HitboxTab.BorderSizePixel = 0
HitboxTab.Font = Enum.Font.GothamSemibold
HitboxTab.Parent = TabBar

-- ===== КОНТЕНТ =====
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -75)
Content.Position = UDim2.new(0, 0, 0, 75)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- ===== ВКЛАДКА "АИМ" =====
local AimPanel = Instance.new("Frame")
AimPanel.Size = UDim2.new(1, 0, 1, 0)
AimPanel.BackgroundTransparency = 1
AimPanel.Parent = Content

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, 0, 0, 20)
StatusText.Position = UDim2.new(0, 0, 0, 5)
StatusText.Text = "● СКМ — наводка на выбранного"
StatusText.TextColor3 = Color3.fromRGB(100, 200, 100)
StatusText.TextSize = 11
StatusText.TextXAlignment = Enum.TextXAlignment.Center
StatusText.BackgroundTransparency = 1
StatusText.Font = Enum.Font.Gotham
StatusText.Parent = AimPanel

local SelectedLabel = Instance.new("TextLabel")
SelectedLabel.Size = UDim2.new(1, 0, 0, 22)
SelectedLabel.Position = UDim2.new(0, 0, 0, 28)
SelectedLabel.Text = "Цель: НЕ ВЫБРАНА"
SelectedLabel.TextColor3 = Color3.fromRGB(255, 150, 100)
SelectedLabel.TextSize = 12
SelectedLabel.TextXAlignment = Enum.TextXAlignment.Center
SelectedLabel.BackgroundTransparency = 1
SelectedLabel.Font = Enum.Font.GothamBold
SelectedLabel.Parent = AimPanel

local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(0.9, 0, 0, 28)
RefreshBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
RefreshBtn.Text = "🔄 ОБНОВИТЬ СПИСОК"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.TextSize = 12
RefreshBtn.BackgroundColor3 = Color3.fromRGB(123, 63, 252)
RefreshBtn.BorderSizePixel = 0
RefreshBtn.Font = Enum.Font.GothamSemibold
RefreshBtn.Parent = AimPanel
local RefreshCorner = Instance.new("UICorner")
RefreshCorner.CornerRadius = UDim.new(0, 6)
RefreshCorner.Parent = RefreshBtn

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(0.9, 0, 0, 200)
PlayerList.Position = UDim2.new(0.05, 0, 0.25, 0)
PlayerList.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 4
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.Parent = AimPanel
local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 6)
ListCorner.Parent = PlayerList

local ResetBtn = Instance.new("TextButton")
ResetBtn.Size = UDim2.new(0.9, 0, 0, 28)
ResetBtn.Position = UDim2.new(0.05, 0, 0.85, 0)
ResetBtn.Text = "❌ СБРОСИТЬ ВЫБОР"
ResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetBtn.TextSize = 12
ResetBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 80)
ResetBtn.BorderSizePixel = 0
ResetBtn.Font = Enum.Font.GothamSemibold
ResetBtn.Parent = AimPanel
local ResetCorner = Instance.new("UICorner")
ResetCorner.CornerRadius = UDim.new(0, 6)
ResetCorner.Parent = ResetBtn

-- ===== ВКЛАДКА "ХИТБОКСЫ" =====
local HitboxPanel = Instance.new("Frame")
HitboxPanel.Size = UDim2.new(1, 0, 1, 0)
HitboxPanel.BackgroundTransparency = 1
HitboxPanel.Visible = false
HitboxPanel.Parent = Content

local HitboxInfo = Instance.new("TextLabel")
HitboxInfo.Size = UDim2.new(0.9, 0, 0, 40)
HitboxInfo.Position = UDim2.new(0.05, 0, 0.05, 0)
HitboxInfo.Text = "Увеличивает все части тела врагов\nчтобы было легче попасть"
HitboxInfo.TextColor3 = Color3.fromRGB(180, 180, 210)
HitboxInfo.TextSize = 12
HitboxInfo.TextXAlignment = Enum.TextXAlignment.Center
HitboxInfo.BackgroundTransparency = 1
HitboxInfo.Font = Enum.Font.Gotham
HitboxInfo.Parent = HitboxPanel

local HitboxBtn = Instance.new("TextButton")
HitboxBtn.Size = UDim2.new(0.9, 0, 0, 50)
HitboxBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
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

local HitboxStatus = Instance.new("TextLabel")
HitboxStatus.Size = UDim2.new(0.9, 0, 0, 22)
HitboxStatus.Position = UDim2.new(0.05, 0, 0.4, 0)
HitboxStatus.Text = "● ВЫКЛЮЧЕНО"
HitboxStatus.TextColor3 = Color3.fromRGB(200, 80, 80)
HitboxStatus.TextSize = 13
HitboxStatus.TextXAlignment = Enum.TextXAlignment.Center
HitboxStatus.BackgroundTransparency = 1
HitboxStatus.Font = Enum.Font.Gotham
HitboxStatus.Parent = HitboxPanel

-- Настройка размера хитбокса
local ScaleLabel = Instance.new("TextLabel")
ScaleLabel.Size = UDim2.new(0.9, 0, 0, 20)
ScaleLabel.Position = UDim2.new(0.05, 0, 0.52, 0)
ScaleLabel.Text = "РАЗМЕР ХИТБОКСА (х раз)"
ScaleLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
ScaleLabel.TextSize = 11
ScaleLabel.TextXAlignment = Enum.TextXAlignment.Left
ScaleLabel.BackgroundTransparency = 1
ScaleLabel.Font = Enum.Font.Gotham
ScaleLabel.Parent = HitboxPanel

local ScaleInput = Instance.new("TextBox")
ScaleInput.Size = UDim2.new(0.9, 0, 0, 35)
ScaleInput.Position = UDim2.new(0.05, 0, 0.6, 0)
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

ScaleInput.FocusLost:Connect(function()
    local val = tonumber(ScaleInput.Text)
    if val and val >= 1 and val <= 20 then
        HitboxScale = val
        -- Если хитбоксы включены — применяем новые размеры
        if HitboxActive then
            DisableHitbox()
            EnableHitbox()
        end
    else
        ScaleInput.Text = tostring(HitboxScale)
    end
end)

-- ===== ФУНКЦИИ ХИТБОКСОВ =====
local function GetHitboxParts(char)
    local parts = {}
    for _, name in ipairs({"Head", "UpperTorso", "LowerTorso", "Torso",
                            "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm",
                            "LeftHand", "RightHand", "LeftUpperLeg", "RightUpperLeg",
                            "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot",
                            "HumanoidRootPart"}) do
        local part = char:FindFirstChild(name)
        if part and part:IsA("BasePart") then
            table.insert(parts, part)
        end
    end
    return parts
end

function EnableHitbox()
    HitboxActive = true
    OriginalSizes = {}
    local myChar = Player.Character
    
    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        if otherPlayer ~= Player then
            local char = otherPlayer.Character
            if char and char ~= myChar then
                local parts = GetHitboxParts(char)
                for _, part in ipairs(parts) do
                    OriginalSizes[part] = {Size = part.Size}
                    part.Size = part.Size * HitboxScale
                end
            end
        end
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

-- ===== ФУНКЦИЯ СПИСКА =====
local function RefreshPlayerList()
    for _, child in pairs(PlayerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local players = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= Player then
            local char = p.Character
            local humanoid = char and char:FindFirstChild("Humanoid")
            local alive = humanoid and humanoid.Health > 0
            table.insert(players, {player = p, alive = alive})
        end
    end

    table.sort(players, function(a, b)
        return a.alive and not b.alive
    end)

    PlayerList.CanvasSize = UDim2.new(0, 0, 0, #players * 30)

    for i, data in ipairs(players) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -6, 0, 26)
        btn.Position = UDim2.new(0, 3, 0, (i-1) * 30 + 3)
        btn.Text = data.player.Name .. (data.alive and " 🟢" or " 💀")
        btn.TextColor3 = data.alive and Color3.fromRGB(220, 220, 255) or Color3.fromRGB(150, 150, 150)
        btn.TextSize = 11
        btn.BackgroundColor3 = (SelectedPlayer == data.player) and Color3.fromRGB(123, 63, 252) or Color3.fromRGB(35, 38, 55)
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.Gotham
        btn.Parent = PlayerList

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = btn

        btn.MouseButton1Click:Connect(function()
            SelectedPlayer = data.player
            SelectedLabel.Text = "Цель: " .. data.player.Name
            SelectedLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            RefreshPlayerList()
        end)
    end
end

-- ===== ПОИСК ЦЕЛИ =====
local function GetTargetBody(char)
    return char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("Torso")
        or char:FindFirstChild("HumanoidRootPart")
end

local function GetSelectedTarget()
    if not SelectedPlayer then return nil, nil end
    local char = SelectedPlayer.Character
    if not char then return nil, nil end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return nil, nil end
    local part = GetTargetBody(char)
    if not part then return nil, nil end
    local myChar = Player.Character
    if myChar and part:IsDescendantOf(myChar) then return nil, nil end
    return SelectedPlayer, part
end

-- ===== ОСНОВНОЙ ЦИКЛ =====
RunService.RenderStepped:Connect(function()
    if not AimbotActive then return end
    if not IsAiming then return end

    local target, targetPart = GetSelectedTarget()
    if target and targetPart then
        local currentCFrame = Camera.CFrame
        local lookAt = CFrame.lookAt(currentCFrame.Position, targetPart.Position)
        Camera.CFrame = currentCFrame:Lerp(lookAt, Smoothness)
    end
end)

-- ===== СРЕДНЯЯ КНОПКА МЫШИ =====
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton3 then
        if AimbotActive and SelectedPlayer then
            IsAiming = true
            StatusText.Text = "● НАВОДКА НА " .. SelectedPlayer.Name
            StatusText.TextColor3 = Color3.fromRGB(255, 200, 0)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton3 then
        IsAiming = false
        if AimbotActive then
            StatusText.Text = "● СКМ — наводка на выбранного"
            StatusText.TextColor3 = Color3.fromRGB(100, 200, 100)
        end
    end
end)

-- ===== ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК =====
AimTab.MouseButton1Click:Connect(function()
    AimPanel.Visible = true
    HitboxPanel.Visible = false
    AimTab.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
    AimTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    HitboxTab.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
    HitboxTab.TextColor3 = Color3.fromRGB(180, 180, 210)
end)

HitboxTab.MouseButton1Click:Connect(function()
    AimPanel.Visible = false
    HitboxPanel.Visible = true
    HitboxTab.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
    HitboxTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    AimTab.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
    AimTab.TextColor3 = Color3.fromRGB(180, 180, 210)
end)

-- ===== КНОПКИ =====
HitboxBtn.MouseButton1Click:Connect(function()
    if HitboxActive then
        DisableHitbox()
    else
        EnableHitbox()
    end
end)

RefreshBtn.MouseButton1Click:Connect(RefreshPlayerList)

ResetBtn.MouseButton1Click:Connect(function()
    SelectedPlayer = nil
    SelectedLabel.Text = "Цель: НЕ ВЫБРАНА"
    SelectedLabel.TextColor3 = Color3.fromRGB(255, 150, 100)
    RefreshPlayerList()
end)

CloseBtn.MouseButton1Click:Connect(function()
    if HitboxActive then DisableHitbox() end
    ScreenGui:Destroy()
end)

-- Автообновление
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(RefreshCooldown)
        if ScreenGui.Parent then
            RefreshPlayerList()
            if HitboxActive then
                for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
                    if otherPlayer ~= Player then
                        local char = otherPlayer.Character
                        if char and char ~= Player.Character then
                            local parts = GetHitboxParts(char)
                            for _, part in ipairs(parts) do
                                if not OriginalSizes[part] then
                                    OriginalSizes[part] = {Size = part.Size / HitboxScale}
                                    part.Size = part.Size * HitboxScale
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

RefreshPlayerList()
print("✅ Murder Duels меню загружено!")
print("🎯 Вкладка АИМ — выбор цели")
print("📦 Вкладка ХИТБОКСЫ — увеличение хитбоксов")
