-- [[ AIMBOT для Murder Duels — ВЫБОР ЦЕЛИ ]]
-- Выбираешь игрока из списка — наводится на ТЕЛО (Torso / UpperTorso)
-- Зажми СРЕДНЮЮ кнопку мыши для наводки

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- ===== НАСТРОЙКИ =====
local AimbotActive = true
local IsAiming = false
local MaxDistance = 2000
local Smoothness = 0.5
local SelectedPlayer = nil
local RefreshCooldown = 5 -- обновление списка раз в 5 секунд (медленнее)

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MurderDuelsAimbot"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 320)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BackgroundTransparency = 0.1
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
TopBar.Size = UDim2.new(1, 0, 0, 35)
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
Title.Text = "AIMBOT | ВЫБОР ЦЕЛИ"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
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

-- Статус
local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, 0, 0, 18)
StatusText.Position = UDim2.new(0, 0, 0, 40)
StatusText.Text = "● СКМ — наводка на выбранного"
StatusText.TextColor3 = Color3.fromRGB(100, 200, 100)
StatusText.TextSize = 10
StatusText.TextXAlignment = Enum.TextXAlignment.Center
StatusText.BackgroundTransparency = 1
StatusText.Font = Enum.Font.Gotham
StatusText.Parent = MainFrame

-- Выбранная цель
local SelectedLabel = Instance.new("TextLabel")
SelectedLabel.Size = UDim2.new(1, 0, 0, 18)
SelectedLabel.Position = UDim2.new(0, 0, 0, 58)
SelectedLabel.Text = "Цель: НЕ ВЫБРАНА"
SelectedLabel.TextColor3 = Color3.fromRGB(255, 150, 100)
SelectedLabel.TextSize = 11
SelectedLabel.TextXAlignment = Enum.TextXAlignment.Center
SelectedLabel.BackgroundTransparency = 1
SelectedLabel.Font = Enum.Font.GothamBold
SelectedLabel.Parent = MainFrame

-- Кнопка обновить список
local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(0.9, 0, 0, 25)
RefreshBtn.Position = UDim2.new(0.05, 0, 0.26, 0)
RefreshBtn.Text = "🔄 ОБНОВИТЬ СПИСОК"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.TextSize = 11
RefreshBtn.BackgroundColor3 = Color3.fromRGB(123, 63, 252)
RefreshBtn.BorderSizePixel = 0
RefreshBtn.Font = Enum.Font.GothamSemibold
RefreshBtn.Parent = MainFrame
local RefreshCorner = Instance.new("UICorner")
RefreshCorner.CornerRadius = UDim.new(0, 6)
RefreshCorner.Parent = RefreshBtn

-- Список игроков
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(0.9, 0, 0, 130)
PlayerList.Position = UDim2.new(0.05, 0, 0.38, 0)
PlayerList.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 4
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.Parent = MainFrame
local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 6)
ListCorner.Parent = PlayerList

-- Кнопка сброса
local ResetBtn = Instance.new("TextButton")
ResetBtn.Size = UDim2.new(0.9, 0, 0, 25)
ResetBtn.Position = UDim2.new(0.05, 0, 0.85, 0)
ResetBtn.Text = "❌ СБРОСИТЬ ВЫБОР"
ResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetBtn.TextSize = 11
ResetBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 80)
ResetBtn.BorderSizePixel = 0
ResetBtn.Font = Enum.Font.GothamSemibold
ResetBtn.Parent = MainFrame
local ResetCorner = Instance.new("UICorner")
ResetCorner.CornerRadius = UDim.new(0, 6)
ResetCorner.Parent = ResetBtn

-- ===== ФУНКЦИЯ ОБНОВЛЕНИЯ СПИСКА =====
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

-- ===== ФУНКЦИЯ ПОЛУЧЕНИЯ ТЕЛА (НЕ ГОЛОВЫ) =====
local function GetTargetBody(char)
    -- Приоритет: UpperTorso (R15), Torso (R6), HumanoidRootPart
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
            TopBar.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton3 then
        IsAiming = false
        if AimbotActive then
            StatusText.Text = "● СКМ — наводка на выбранного"
            StatusText.TextColor3 = Color3.fromRGB(100, 200, 100)
            TopBar.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
        end
    end
end)

-- ===== КНОПКИ =====
RefreshBtn.MouseButton1Click:Connect(RefreshPlayerList)

ResetBtn.MouseButton1Click:Connect(function()
    SelectedPlayer = nil
    SelectedLabel.Text = "Цель: НЕ ВЫБРАНА"
    SelectedLabel.TextColor3 = Color3.fromRGB(255, 150, 100)
    RefreshPlayerList()
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Автообновление раз в 5 секунд (медленнее)
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(RefreshCooldown)
        if ScreenGui.Parent then
            RefreshPlayerList()
        end
    end
end)

RefreshPlayerList()
print("✅ AIMBOT загружен! Наводка на ТЕЛО, список обновляется раз в 5 сек.")
