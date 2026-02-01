-- open source script

if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("SpamToggleGui") then
    if connection then
        connection:Disconnect()
        connection = nil
    end
    isSpamming = false
    game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("SpamToggleGui"):Destroy()
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Net = require(ReplicatedStorage.TS.Network.Network).Network

local dragging, dragStart, startPos

local function MakeDraggable(DragPoint, MainDrag)
	pcall(function()
		local Dragging = false
		local DragInput
		local MousePos
		local FramePos
		
		DragPoint.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				
				Dragging = true
				MousePos = Input.Position
				FramePos = MainDrag.Position
				
				Input.Changed:Connect(function()
					if Input.UserInputState == Enum.UserInputState.End then
						Dragging = false
					end
				end)
			end
		end)
		
		DragPoint.InputChanged:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
				DragInput = Input
			end
		end)
		
		UserInputService.InputChanged:Connect(function(Input)
			if Input == DragInput and Dragging then
				local Delta = Input.Position - MousePos

				local newPos = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
			    
				TweenService:Create(MainDrag, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = newPos}):Play()
			end
		end)
	end)
end

-- local BlockEvent = ReplicatedStorage.TS.GeneratedNetworkRemotes:FindFirstChild("RE_4.6848415795802784e+76")

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
mainFrame.Size = UDim2.new(0, 100, 0, 70)
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
			Net:CSendEvent(4.6848415795802784e76, 6.8467442838735085e75)
            -- BlockEvent:FireServer(2.933813859058389e+76)
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

MakeDraggable(titleBar, mainFrame)

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
