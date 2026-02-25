-- Universal Aimlock Manager (No Reset Version)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- UI Setup
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "SmartAimlockUI"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 260, 0, 70)
mainFrame.Position = UDim2.new(0.5, -130, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 4
mainFrame.Draggable = true
mainFrame.Active = true
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

-- Logic tắt không cần die
local isEnabled = false

toggleBtn.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    
    if isEnabled then
        -- TRẠNG THÁI BẬT
        toggleBtn.Text = "AIMLOCK: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/minhdat89mt-eng/Aimbot/main/Aimlock.lua"))()
        end)
    else
        -- TRẠNG THÁI TẮT (KHÔNG CẦN RESET)
        toggleBtn.Text = "STOPPING..."
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 0)
        
        -- 1. Ép Camera về trạng thái tự do
        Camera.CameraType = Enum.CameraType.Custom
        Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
        
        -- 2. "Bẻ gãy" các vòng lặp ngầm (Master Cleaner)
        -- Hầu hết script ghim tâm đều dùng biến Global hoặc kết nối RunService
        for i, v in pairs(getconnections(RunService.RenderStepped)) do
            v:Disable() -- Vô hiệu hóa các vòng lặp render
        end
        for i, v in pairs(getconnections(RunService.Heartbeat)) do
            v:Disable() 
        end
        
        -- 3. Xóa các biến Global mà script Aimlock thường dùng
        _G.Aimbot = false
        _G.Aimlock = false
        getgenv().Aimbot = false
        getgenv().Aimlock = false
        
        task.wait(0.5)
        toggleBtn.Text = "STATUS: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    end
end)
