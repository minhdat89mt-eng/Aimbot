-- Advanced UI: RGB Border & Draggable Menu
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- 1. Create the Main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomBattleMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- 2. Create the Horizontal Frame (The Menu)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 65)
mainFrame.Position = UDim2.new(0.5, -125, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 3 -- Border size for RGB effect
mainFrame.Parent = screenGui

-- Add Rounded Corners
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

-- 3. RGB Border Logic (Rainbow Effect)
RunService.RenderStepped:Connect(function()
    local hue = tick() % 5 / 5 -- Cycle colors every 5 seconds
    local color = Color3.fromHSV(hue, 1, 1)
    mainFrame.BorderColor3 = color
end)

-- 4. Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "AimbotToggle"
toggleButton.Size = UDim2.new(0.9, 0, 0.7, 0)
toggleButton.Position = UDim2.new(0.05, 0, 0.15, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 18
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Text = "Aimbot: OFF"
toggleButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = toggleButton

local isEnabled = false
toggleButton.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    if isEnabled then
        toggleButton.Text = "Aimbot: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        toggleButton.Text = "Aimbot: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)

-- 5. Dragging Logic (Smooth Movement)
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

print("System: Advanced RGB Menu with Dragging Loaded.")
