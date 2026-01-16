local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local dragging, dragStart, startPos

function MakeDraggable(DragPoint, MainDrag)
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
		
		UIS.InputChanged:Connect(function(Input)
			if Input == DragInput and Dragging then
				local Delta = Input.Position - MousePos

				local newPos = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
			    
				TweenService:Create(MainDrag, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = newPos}):Play()
			end
		end)
	end)
end
