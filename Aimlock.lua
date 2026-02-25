-- Target Lock System (Aimlock)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 1. Interface Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimlockConsole"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- 2. Main Horizontal Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 65)
mainFrame.Position = UDim2.new(0.5, -130, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 3
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

-- 3. Rainbow Border (RGB Effect)
RunService.RenderStepped:Connect(function()
    local hue = tick() % 3 / 3
    mainFrame.BorderColor3 = Color3.fromHSV(hue, 1, 1)
end)

-- 4. The Lock Button
local lockButton = Instance.new("TextButton")
lockButton.Size = UDim2.new(0.9, 0, 0.7, 0)
lockButton.Position = UDim2.new(0.05, 0, 0.15, 0)
lockButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
lockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
lockButton.TextSize = 18
lockButton.Font = Enum.Font.GothamBold
lockButton.Text = "AIMLOCK: OFF"
lockButton.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = lockButton

-- 5. Dragging System (Move the menu anywhere)
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

-- 6. Execution Logic (Link to your GitHub)
local isToggled = false

lockButton.MouseButton1Click:Connect(function()
    isToggled = not isToggled
    if isToggled then
        -- Action: ON
        lockButton.Text = "AIMLOCK: ON"
        lockButton.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
        
        -- Load your specific ghim script
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/minhdat89mt-eng/Aimbot/refs/heads/main/Aimlock.lua"))()
        end)
    else
        -- Action: OFF
        lockButton.Text = "AIMLOCK: OFF"
        lockButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        -- Note: To stop the ghim, you might need to reset your character 
        -- unless your .lua file has a built-in disable function.
    end
end)

print("System: Aimlock Menu with RGB Border is active.")
