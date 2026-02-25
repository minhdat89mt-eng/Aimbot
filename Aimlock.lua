-- Global Settings
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- UI Cleanup to fix the "Infinite Buttons" error
if LocalPlayer.PlayerGui:FindFirstChild("UniversalAimlock") then
    LocalPlayer.PlayerGui.UniversalAimlock:Destroy()
end

local screenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
screenGui.Name = "UniversalAimlock"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 260, 0, 70)
mainFrame.Position = UDim2.new(0.5, -130, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 4
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame)

-- RGB Border
RunService.RenderStepped:Connect(function()
    mainFrame.BorderColor3 = Color3.fromHSV(tick() % 4 / 4, 1, 1)
end)

local toggleBtn = Instance.new("TextButton", mainFrame)
toggleBtn.Size = UDim2.new(0.9, 0, 0.7, 0)
toggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
toggleBtn.Text = "STATUS: OFF"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 18
Instance.new("UICorner", toggleBtn)

-- AIMLOCK ENGINE (The core logic)
local isLocked = false
local currentTarget = nil

local function getClosestPlayer()
    local closest = nil
    local dist = math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if magnitude < dist then
                    closest = p.Character.HumanoidRootPart
                    dist = magnitude
                end
            end
        end
    end
    return closest
end

-- Fast Loop for Locking
RunService.RenderStepped:Connect(function()
    if isLocked then
        currentTarget = getClosestPlayer()
        if currentTarget then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, currentTarget.Position)
        end
    end
end)

-- Toggle Logic
toggleBtn.MouseButton1Click:Connect(function()
    isLocked = not isLocked
    if isLocked then
        toggleBtn.Text = "AIMLOCK: ACTIVE"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        -- Still try to load your GitHub script just in case it has extra features
        pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/minhdat89mt-eng/Aimbot/main/Aimlock.lua"))() end)
    else
        toggleBtn.Text = "STATUS: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        currentTarget = nil
        Camera.CameraType = Enum.CameraType.Custom
    end
end)
