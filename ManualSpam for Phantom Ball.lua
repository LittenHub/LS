if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("SpamToggleGui") then
    if connection then
        connection:Disconnect()
        connection = nil
    end
    game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("SpamToggleGui"):Destroy()
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BlockEvent = ReplicatedStorage.TS.GeneratedNetworkRemotes:FindFirstChild("RE_4.6848415795802784e+76")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Control variables
local isSpamming = false
local connection

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpamToggleGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Create main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 100, 0, 65)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -60)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Add rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 5)
corner.Parent = mainFrame

-- Add shadow/border
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 60, 60)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Create title bar for dragging
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 20)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 5)
titleCorner.Parent = titleBar

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -5, 1, 0)
titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Manual Spam Toggle"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0.9, 0, 0, 40)
toggleButton.Position = UDim2.new(0, 5, 0, 25)
toggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "DISABLED"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 5)
buttonCorner.Parent = toggleButton

local function executeSpam()
    for i = 1, 3 do
        pcall(function()
            BlockEvent:FireServer(2.933813859058389e+76)
        end)
        task.wait(0.000000000000000000000000000000000000000000000000001)
    end
end
-- Function to start/stop spam
local function toggleSpam()
    isSpamming = not isSpamming
    
    if isSpamming then
        toggleButton.Text = "ENABLED"
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        
        -- Start spam loop
        connection = RunService.Heartbeat:Connect(function()
            executeSpam()
        end)
        
        -- Pulse animation when active
        local pulseInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
        local pulseTween = TweenService:Create(toggleButton, pulseInfo, {BackgroundColor3 = Color3.fromRGB(70, 255, 70)})
        pulseTween:Play()
        
    else
        toggleButton.Text = "DISABLED"
        toggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        
        -- Stop spam loop
        if connection then
            connection:Disconnect()
            connection = nil
        end
        
        -- Stop all animations
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}):Play()
    end
end

-- Button event
toggleButton.MouseButton1Click:Connect(toggleSpam)

-- Dragging system (mobile compatible)
local dragging = false
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    
    -- Limit within screen
    local vpSize = workspace.CurrentCamera.ViewportSize
    local frameSize = mainFrame.AbsoluteSize
    
    local maxX = vpSize.X - frameSize.X
    local maxY = vpSize.Y - frameSize.Y
    
    local newX = math.clamp(position.X.Offset, 0, maxX)
    local newY = math.clamp(position.Y.Offset, 0, maxY)
    
    mainFrame.Position = UDim2.new(0, newX, 0, newY)
end

-- Drag events for PC
titleBar.InputBegan:Connect(function(input)
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

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            updateInput(input)
        end
    end
end)

-- Drag events for Mobile
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch and dragging then
        updateInput(input)
    end
end)

-- Add visual effects
local function addHoverEffect(button)
    button.MouseEnter:Connect(function()
        if not isSpamming then
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not isSpamming then
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}):Play()
        end
    end)
end

addHoverEffect(toggleButton)

-- Initial notification
local notificationGui = Instance.new("ScreenGui")
notificationGui.Name = "NotificationGui"
notificationGui.ResetOnSpawn = false
notificationGui.Parent = playerGui

local notification = Instance.new("Frame")
notification.Size = UDim2.new(0, 300, 0, 60)
notification.Position = UDim2.new(0.5, -150, 0, -70)
notification.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
notification.BorderSizePixel = 0
notification.Parent = notificationGui

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 10)
notifCorner.Parent = notification

local notifText = Instance.new("TextLabel")
notifText.Size = UDim2.new(1, -20, 1, 0)
notifText.Position = UDim2.new(0, 10, 0, 0)
notifText.BackgroundTransparency = 1
notifText.Text = "Spam Toggle loaded! Drag by the top bar.\nCurrent multiplier: " .. MULTIPLIER
notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
notifText.TextScaled = true
notifText.Font = Enum.Font.Gotham
notifText.Parent = notification

-- Animate notification
local slideIn = TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -150, 0, 20)})
local slideOut = TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -150, 0, -70)})

slideIn:Play()
wait(5)
slideOut:Play()
slideOut.Completed:Connect(function()
    notificationGui:Destroy()
end)
