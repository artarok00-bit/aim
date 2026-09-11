-- [[ AIMBOT — Минимальный интерфейс ]]
-- F — наведение на ближайшего игрока (без себя)

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- ===== НАСТРОЙКИ =====
local AimbotActive = false
local IsAiming = false
local MaxDistance = 1000
local Smoothness = 0.6
local Minimized = false
local AimKey = Enum.KeyCode.F

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Aimbot"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Компактное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 180, 0, 70)
MainFrame.Position = UDim2.new(0.5, -90, 0.85, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

-- Тонкая полоска сверху
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 3)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

-- Название
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 20)
Title.Position = UDim2.new(0, 0, 0, 8)
Title.Text = "AIMBOT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Статус
local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, 0, 0, 16)
StatusText.Position = UDim2.new(0, 0, 0, 26)
StatusText.Text = "● ВЫКЛ"
StatusText.TextColor3 = Color3.fromRGB(200, 80, 80)
StatusText.TextSize = 11
StatusText.TextXAlignment = Enum.TextXAlignment.Center
StatusText.BackgroundTransparency = 1
StatusText.Font = Enum.Font.Gotham
StatusText.Parent = MainFrame

-- Кнопка включения
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 22)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
ToggleBtn.Text = "ВКЛЮЧИТЬ"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 11
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Font = Enum.Font.GothamSemibold
ToggleBtn.Parent = MainFrame
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleBtn

-- Маленький крестик в углу
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 18, 0, 18)
CloseBtn.Position = UDim2.new(1, -22, 0, 4)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
CloseBtn.TextSize = 12
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
CloseBtn.BorderSizePixel = 0
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.Parent = MainFrame
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseBtn

-- ===== ФУНКЦИЯ ПОИСКА =====
local function GetClosestPlayer()
    local closestPlayer = nil
    local closestDist = MaxDistance
    local closestPart = nil
    
    local myChar = Player.Character
    if not myChar then return nil, nil end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil, nil end
    
    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        if otherPlayer ~= Player then
            local char = otherPlayer.Character
            if char then
                local humanoid = char:FindFirstChild("Humanoid")
                local head = char:FindFirstChild("Head")
                if head and humanoid and humanoid.Health > 0 then
                    local dist = (head.Position - myRoot.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestPlayer = otherPlayer
                        closestPart = head
                    end
                end
            end
        end
    end
    return closestPlayer, closestPart
end

-- ===== ОСНОВНОЙ ЦИКЛ =====
RunService.RenderStepped:Connect(function()
    if not AimbotActive or not IsAiming then return end
    local target, targetPart = GetClosestPlayer()
    if target and targetPart then
        local currentCFrame = Camera.CFrame
        local lookAt = CFrame.lookAt(currentCFrame.Position, targetPart.Position)
        Camera.CFrame = currentCFrame:Lerp(lookAt, Smoothness)
    end
end)

-- ===== КЛАВИША F =====
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == AimKey and AimbotActive then
        IsAiming = true
        StatusText.Text = "● НАВОДКА"
        StatusText.TextColor3 = Color3.fromRGB(100, 200, 255)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == AimKey then
        IsAiming = false
        if AimbotActive then
            StatusText.Text = "● ВКЛ"
            StatusText.TextColor3 = Color3.fromRGB(100, 200, 100)
        end
    end
end)

-- ===== КНОПКА =====
ToggleBtn.MouseButton1Click:Connect(function()
    AimbotActive = not AimbotActive
    if AimbotActive then
        ToggleBtn.Text = "ВЫКЛЮЧИТЬ"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
        TopBar.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
        StatusText.Text = "● ВКЛ (F)"
        StatusText.TextColor3 = Color3.fromRGB(100, 200, 100)
    else
        ToggleBtn.Text = "ВКЛЮЧИТЬ"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        TopBar.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        StatusText.Text = "● ВЫКЛ"
        StatusText.TextColor3 = Color3.fromRGB(200, 80, 80)
        IsAiming = false
    end
end)

-- ===== ЗАКРЫТИЕ =====
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("✅ AIMBOT загружен! F — наведение")
