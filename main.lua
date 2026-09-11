-- [[ AIMBOT для Murder Duels — ИСПРАВЛЕННЫЙ ]]
-- Зажми СРЕДНЮЮ кнопку мыши — наводится на ЧУЖОГО игрока (не на себя)

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- ===== НАСТРОЙКИ =====
local AimbotActive = true
local IsAiming = false
local MaxDistance = 2000
local Smoothness = 0.5

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MurderDuelsAimbot"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 180, 0, 95)
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

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 3)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 20)
Title.Position = UDim2.new(0, 0, 0, 8)
Title.Text = "AIMBOT | Murder Duels"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, 0, 0, 16)
StatusText.Position = UDim2.new(0, 0, 0, 26)
StatusText.Text = "● ВКЛ | СКМ — наводка"
StatusText.TextColor3 = Color3.fromRGB(100, 200, 100)
StatusText.TextSize = 10
StatusText.TextXAlignment = Enum.TextXAlignment.Center
StatusText.BackgroundTransparency = 1
StatusText.Font = Enum.Font.Gotham
StatusText.Parent = MainFrame

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(1, 0, 0, 14)
TargetLabel.Position = UDim2.new(0, 0, 0, 42)
TargetLabel.Text = "Цель: —"
TargetLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
TargetLabel.TextSize = 9
TargetLabel.TextXAlignment = Enum.TextXAlignment.Center
TargetLabel.BackgroundTransparency = 1
TargetLabel.Font = Enum.Font.Gotham
TargetLabel.Parent = MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 22)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
ToggleBtn.Text = "ВЫКЛЮЧИТЬ"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 11
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Font = Enum.Font.GothamSemibold
ToggleBtn.Parent = MainFrame
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleBtn

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

-- ===== ФУНКЦИЯ ПОИСКА ЦЕЛИ =====
local function GetTargetPart(char)
    local head = char:FindFirstChild("Head")
    if head then return head end
    
    local upperTorso = char:FindFirstChild("UpperTorso")
    if upperTorso then return upperTorso end
    
    local torso = char:FindFirstChild("Torso")
    if torso then return torso end
    
    return char:FindFirstChild("HumanoidRootPart")
end

local function GetClosestEnemy()
    local closestPlayer = nil
    local closestDist = MaxDistance
    local closestPart = nil

    local myChar = Player.Character
    if not myChar then return nil, nil end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil, nil end

    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        -- ПРОВЕРКА 1: это не я
        if otherPlayer ~= Player then
            local char = otherPlayer.Character
            
            -- ПРОВЕРКА 2: персонаж существует и это не мой персонаж
            if char and char ~= myChar then
                local humanoid = char:FindFirstChild("Humanoid")
                
                -- ПРОВЕРКА 3: жив
                if humanoid and humanoid.Health > 0 then
                    local part = GetTargetPart(char)
                    
                    if part then
                        -- ПРОВЕРКА 4: часть не принадлежит моему персонажу
                        if part:IsDescendantOf(myChar) == false then
                            local dist = (part.Position - myRoot.Position).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                                closestPlayer = otherPlayer
                                closestPart = part
                            end
                        end
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

    local target, targetPart = GetClosestEnemy()
    if target and targetPart then
        TargetLabel.Text = "Цель: " .. target.Name
        TargetLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        
        local currentCFrame = Camera.CFrame
        local lookAt = CFrame.lookAt(currentCFrame.Position, targetPart.Position)
        Camera.CFrame = currentCFrame:Lerp(lookAt, Smoothness)
    else
        TargetLabel.Text = "Цель: —"
        TargetLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
    end
end)

-- ===== СРЕДНЯЯ КНОПКА МЫШИ =====
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton3 then
        if AimbotActive then
            IsAiming = true
            StatusText.Text = "● НАВОДКА"
            StatusText.TextColor3 = Color3.fromRGB(255, 200, 0)
            TopBar.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton3 then
        IsAiming = false
        if AimbotActive then
            StatusText.Text = "● ВКЛ | СКМ — наводка"
            StatusText.TextColor3 = Color3.fromRGB(100, 200, 100)
            TopBar.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
        end
    end
end)

-- ===== КНОПКА ВКЛЮЧЕНИЯ =====
ToggleBtn.MouseButton1Click:Connect(function()
    AimbotActive = not AimbotActive
    if AimbotActive then
        ToggleBtn.Text = "ВЫКЛЮЧИТЬ"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
        TopBar.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
        StatusText.Text = "● ВКЛ | СКМ — наводка"
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

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("✅ AIMBOT загружен! Не наводится на себя.")
