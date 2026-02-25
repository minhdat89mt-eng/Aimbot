-- Universal Aimlock System
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Xóa UI cũ nếu tồn tại để tránh lỗi
if LocalPlayer.PlayerGui:FindFirstChild("AimlockManager") then
    LocalPlayer.PlayerGui.AimlockManager:Destroy()
end

local screenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
screenGui.Name = "AimlockManager"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 260, 0, 70)
mainFrame.Position = UDim2.new(0.5, -130, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 4
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame)

-- Hiệu ứng viền cầu vồng
RunService.RenderStepped:Connect(function()
    mainFrame.BorderColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
end)

local toggleBtn = Instance.new("TextButton", mainFrame)
toggleBtn.Size = UDim2.new(0.9, 0, 0.7, 0)
toggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
toggleBtn.Text = "STATUS: OFF"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 20
Instance.new("UICorner", toggleBtn)

-- LOGIC GHIM TÂM
local isEnabled = false
local aimConnection = nil

local function getTarget()
    local closest, shortestDist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if dist < shortestDist then
                    closest = p.Character.HumanoidRootPart
                    shortestDist = dist
                end
            end
        end
    end
    return closest
end

-- Sự kiện bấm nút
toggleBtn.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    
    if isEnabled then
        -- KÍCH HOẠT
        toggleBtn.Text = "AIMLOCK: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        -- Chạy ghim tâm
        aimConnection = RunService.RenderStepped:Connect(function()
            local target = getTarget()
            if target then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            end
        end)
        
        -- Load thêm script từ GitHub của bạn
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/minhdat89mt-eng/Aimbot/main/Aimlock.lua"))()
        end)
    else
        -- TẮT (KHÔNG CẦN DIE)
        toggleBtn.Text = "STATUS: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        
        -- Ngắt kết nối vòng lặp ngay lập tức
        if aimConnection then
            aimConnection:Disconnect()
            aimConnection = nil
        end
        
        -- Trả lại quyền điều khiển Camera
        Camera.CameraType = Enum.CameraType.Custom
        
        -- Xóa các biến Global có thể gây ghim ngầm
        getgenv().Aimlock = false
        getgenv().Aimbot = false
    end
end)
