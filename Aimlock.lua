-- Target Lock System
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 1. Create UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimlockSystem"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- 2. Horizontal Rectangle Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 65)
mainFrame.Position = UDim2.new(0.5, -130, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 3
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

-- 3. RGB Border Effect
RunService.RenderStepped:Connect(function()
    local hue = tick() % 4 / 4
    mainFrame.BorderColor3 = Color3.fromHSV(hue, 1, 1)
end)

-- 4. Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0.7, 0)
toggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 18
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Text = "AIMLOCK: OFF"
toggleBtn.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = toggleBtn

-- 5. Draggable Logic
local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- 6. Execution (Corrected Raw Link)
local isActive = false
toggleBtn.MouseButton1Click:Connect(function()
    isActive = not isActive
    if isActive then
        toggleBtn.Text = "AIMLOCK: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
        
        -- Chạy link Raw từ GitHub của bạn
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/minhdat89mt-eng/Aimbot/main/Aimlock.lua"))()
        end)
    else
        toggleBtn.Text = "AIMLOCK: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        -- Lưu ý: Bạn cần Reset nhân vật để hủy ghim nếu script gốc không có nút tắt
    end
end)
