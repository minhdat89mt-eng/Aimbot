-- Advanced Universal Menu with Force Stop
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "ForceStopMenu"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 260, 0, 70)
mainFrame.Position = UDim2.new(0.5, -130, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 3
mainFrame.Active = true
mainFrame.Draggable = true

-- Rainbow Border
RunService.RenderStepped:Connect(function()
    mainFrame.BorderColor3 = Color3.fromHSV(tick() % 4 / 4, 1, 1)
end)

local toggleBtn = Instance.new("TextButton", mainFrame)
toggleBtn.Size = UDim2.new(0.9, 0, 0.7, 0)
toggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
toggleBtn.Text = "STATUS: OFF"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 18
Instance.new("UICorner", toggleBtn)

local isRunning = false

toggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        toggleBtn.Text = "AIMLOCK: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
        
        -- Chạy script của bạn
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/minhdat89mt-eng/Aimbot/main/Aimlock.lua"))()
        end)
    else
        toggleBtn.Text = "FORCE STOPPING..."
        toggleBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        
        -- Lệnh cưỡng bức tắt: Xóa bỏ các kết nối camera
        pcall(function()
            -- Giải phóng Camera về mặc định
            workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        end)
        
        wait(1)
        toggleBtn.Text = "STATUS: OFF"
    end
end)
