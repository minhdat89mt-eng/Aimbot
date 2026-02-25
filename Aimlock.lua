-- Universal Aimlock System
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 1. Create UI System
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalConsole"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 2. Horizontal Menu Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 65)
mainFrame.Position = UDim2.new(0.5, -130, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 3
mainFrame.Active = true
mainFrame.Draggable = true -- Có thể di chuyển menu
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner", mainFrame)

-- 3. Rainbow Border Effect
RunService.RenderStepped:Connect(function()
    mainFrame.BorderColor3 = Color3.fromHSV(tick() % 4 / 4, 1, 1)
end)

-- 4. The Universal Toggle Button
local toggleBtn = Instance.new("TextButton", mainFrame)
toggleBtn.Size = UDim2.new(0.9, 0, 0.7, 0)
toggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 18
toggleBtn.Text = "UNIVERSAL LOCK: OFF"
Instance.new("UICorner", toggleBtn)

-- 5. AIMLOCK LOGIC (UNIVERSAL)
local isLocking = false
local currentTarget = nil

-- Hàm tìm người chơi gần tâm màn hình nhất (áp dụng cho mọi game)
local function getClosestVisibleTarget()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Tìm bộ phận để ghim (Ưu tiên đầu hoặc thân)
            local targetPart = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            
            if targetPart then
                local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                
                if onScreen then
                    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    
                    if distance < shortestDistance then
                        closestPlayer = targetPart
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- Vòng lặp ghim tâm liên tục
RunService.RenderStepped:Connect(function()
    if isLocking then
        currentTarget = getClosestVisibleTarget()
        if currentTarget then
            -- Cưỡng bức Camera ghim chặt vào mục tiêu
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, currentTarget.Position)
        end
    end
end)

-- Toggle Button Logic
toggleBtn.MouseButton1Click:Connect(function()
    isLocking = not isLocking
    if isLocking then
        toggleBtn.Text = "UNIVERSAL LOCK: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        
        -- Load thêm script từ GitHub của bạn nếu cần
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/minhdat89mt-eng/Aimbot/main/Aimlock.lua"))()
        end)
    else
        toggleBtn.Text = "UNIVERSAL LOCK: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        currentTarget = nil
    end
end)
