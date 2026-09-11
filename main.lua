-- [[ AIMBOT — Кнопка LeftAlt ]]
-- Зажимаешь кнопку "LeftAlt" в меню — камера наводится на ближайшего игрока

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

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimbotGUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 10, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 14)
Corner.Parent = MainFrame

-- ===== ШАПКА =====
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 46)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0.6, 0, 1, 0)
TitleText.Position = UDim2.new(0.05, 0, 0, 0)
TitleText.Text = "🎯 AIMBOT"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.BackgroundTransparency = 1
TitleText.Font = Enum.Font.GothamBold
TitleText.Parent = TitleBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(0.86, 0, 0.08, 0)
MinBtn.Text = "─"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 20
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TitleBar
local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(0.93, 0, 0.08, 0)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 80)
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- ===== КОНТЕНТ =====
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -46)
Content.Position = UDim2.new(0, 0, 0, 46)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Кнопка включения аимбота
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.85, 0, 0, 40)
ToggleBtn.Position = UDim2.new(0.075, 0, 0.05, 0)
ToggleBtn.Text = "ВКЛЮЧИТЬ АИМБОТ"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 15
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Font = Enum.Font.GothamSemibold
ToggleBtn.Parent = Content
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleBtn

-- ===== НОВАЯ КНОПКА "LEFT ALT" =====
local AimBtn = Instance.new("TextButton")
AimBtn.Size = UDim2.new(0.85, 0, 0, 55)
AimBtn.Position = UDim2.new(0.075, 0, 0.4, 0)
AimBtn.Text = "🎯 LEFT ALT"
AimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AimBtn.TextSize = 18
AimBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
AimBtn.BorderSizePixel = 0
AimBtn.Font = Enum.Font.GothamBold
AimBtn.Parent = Content
local AimCorner = Instance.new("UICorner")
AimCorner.CornerRadius = UDim.new(0, 10)
AimCorner.Parent = AimBtn

-- Статус
local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(0.9, 0, 0, 25)
StatusText.Position = UDim2.new(0.05, 0, 0.85, 0)
StatusText.Text = "🔴 ВЫКЛЮЧЕН"
StatusText.TextColor3 = Color3.fromRGB(200, 80, 80)
StatusText.TextSize = 14
StatusText.TextXAlignment = Enum.TextXAlignment.Center
StatusText.BackgroundTransparency = 1
StatusText.Font = Enum.Font.Gotham
StatusText.Parent = Content

-- ===== ФУНКЦИЯ ПОИСКА БЛИЖАЙШЕГО ИГРОКА =====
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
    if not AimbotActive then return end
    if not IsAiming then return end
    
    local target, targetPart = GetClosestPlayer()
    if target and targetPart then
        local targetPos = targetPart.Position
        local currentCFrame = Camera.CFrame
        local lookAt = CFrame.lookAt(currentCFrame.Position, targetPos)
        Camera.CFrame = currentCFrame:Lerp(lookAt, Smoothness)
    end
end)

-- ===== КНОПКА "LEFT ALT" (зажатие) =====
AimBtn.MouseButton1Down:Connect(function()
    if not AimbotActive then return end
    IsAiming = true
    AimBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    AimBtn.Text = "🎯 НАВОДКА..."
    StatusText.Text = "🎯 НАВОДКА АКТИВНА"
    StatusText.TextColor3 = Color3.fromRGB(100, 200, 255)
end)

AimBtn.MouseButton1Up:Connect(function()
    IsAiming = false
    AimBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
    AimBtn.Text = "🎯 LEFT ALT"
    if AimbotActive then
        StatusText.Text = "🟢 АИМБОТ ВКЛЮЧЕН"
        StatusText.TextColor3 = Color3.fromRGB(100, 200, 100)
    end
end)

-- Если мышка уходит с кнопки — тоже отпускаем
AimBtn.MouseLeave:Connect(function()
    if IsAiming then
        IsAiming = false
        AimBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
        AimBtn.Text = "🎯 LEFT ALT"
    end
end)

-- ===== КНОПКА ВКЛЮЧЕНИЯ =====
ToggleBtn.MouseButton1Click:Connect(function()
    AimbotActive = not AimbotActive
    
    if AimbotActive then
        ToggleBtn.Text = "ВЫКЛЮЧИТЬ АИМБОТ"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
        StatusText.Text = "🟢 АИМБОТ ВКЛЮЧЕН"
        StatusText.TextColor3 = Color3.fromRGB(100, 200, 100)
        AimBtn.BackgroundColor3 = Color3.fromRGB(123, 63, 252)
    else
        ToggleBtn.Text = "ВКЛЮЧИТЬ АИМБОТ"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        StatusText.Text = "🔴 ВЫКЛЮЧЕН"
        StatusText.TextColor3 = Color3.fromRGB(200, 80, 80)
        AimBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
        IsAiming = false
    end
end)

-- ===== УПРАВЛЕНИЕ ОКНОМ =====
MinBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    Content.Visible = not Minimized
    MinBtn.Text = Minimized and "+" or "─"
    MainFrame.Size = Minimized and UDim2.new(0, 300, 0, 46) or UDim2.new(0, 300, 0, 200)
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("✅ AIMBOT загружен!")
print("🎯 Зажимай кнопку LEFT ALT в меню для наведения")
