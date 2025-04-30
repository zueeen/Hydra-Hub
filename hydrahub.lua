-- Services
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HydraHubUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

-- Side Panel (Button Bar)
local sidePanel = Instance.new("Frame")
sidePanel.Size = UDim2.new(0, 50, 0, 300)
sidePanel.Position = UDim2.new(0.5, -280, 0.5, 0)
sidePanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
sidePanel.BackgroundTransparency = 0.2
sidePanel.BorderSizePixel = 0
sidePanel.AnchorPoint = Vector2.new(0.5, 0.5)
sidePanel.Parent = screenGui

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 10)
sideCorner.Parent = sidePanel

-- Example Button (Smaller)
local iconButton = Instance.new("ImageButton")
iconButton.Size = UDim2.new(1, -20, 0, 30)  -- Reduced width and height
iconButton.Position = UDim2.new(0, 10, 0, 15)  -- Adjusted Y position
iconButton.Image = "rbxassetid://6031091002"
iconButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
iconButton.Parent = sidePanel

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = iconButton

-- Second Button (Smaller)
local secondButton = Instance.new("ImageButton")
secondButton.Size = UDim2.new(1, -20, 0, 30)  -- Reduced width and height
secondButton.Position = UDim2.new(0, 10, 0, 50)  -- Adjusted Y position to stay below first button
secondButton.Image = "rbxassetid://6031090990"
secondButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
secondButton.Parent = sidePanel

local secondButtonCorner = Instance.new("UICorner")
secondButtonCorner.CornerRadius = UDim.new(0, 6)
secondButtonCorner.Parent = secondButton

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, -10, 0, 30)
topBar.Position = UDim2.new(0, 5, 0, 5)
topBar.BackgroundTransparency = 1
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Text = "Hydra Hub"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextYAlignment = Enum.TextYAlignment.Center
title.Parent = topBar

-- Block camera movement
local function blockCameraMovement(_, _, _)
	return Enum.ContextActionResult.Sink
end

-- Dragging logic
local dragging = false
local dragInput, dragStart, startPos, sideOffset

topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		sideOffset = sidePanel.Position - mainFrame.Position

		ContextActionService:BindAction("BlockCamera", blockCameraMovement, false,
			Enum.UserInputType.MouseMovement,
			Enum.UserInputType.Touch,
			Enum.UserInputType.MouseButton2,
			Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D
		)
	end
end)

topBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
		ContextActionService:UnbindAction("BlockCamera")
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		local newMainPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
									  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		mainFrame.Position = newMainPos
		sidePanel.Position = newMainPos + sideOffset
	end
end)

-- === ADD MINIMIZE BUTTON AND LOGO BUTTON ===

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 40, 0, 30)
minimizeButton.Position = UDim2.new(1, -50, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeButton.BackgroundTransparency = 1
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 20
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = topBar

local minimizeButtonCorner = Instance.new("UICorner")
minimizeButtonCorner.CornerRadius = UDim.new(0, 6)
minimizeButtonCorner.Parent = minimizeButton

-- Logo Button (H) for reappearing UI
local logoButton = Instance.new("TextButton")
logoButton.Size = UDim2.new(0, 50, 0, 50)
logoButton.Position = UDim2.new(0.5, -25, 0.5, -25)  -- Centered in the screen
logoButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
logoButton.Text = "H"
logoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
logoButton.TextSize = 30
logoButton.Font = Enum.Font.GothamBold
logoButton.Visible = false  -- Initially hidden
logoButton.Parent = screenGui

local logoButtonCorner = Instance.new("UICorner")
logoButtonCorner.CornerRadius = UDim.new(0, 25)
logoButtonCorner.Parent = logoButton

-- Dragging logic for the logo button
local logoDragging = false
local logoDragInput, logoDragStart, logoStartPos

logoButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		-- Start dragging
		logoDragging = true
		logoDragStart = input.Position
		logoStartPos = logoButton.Position
	end
end)

logoButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		-- Update dragging position
		if logoDragging then
			local delta = input.Position - logoDragStart
			local newLogoPos = UDim2.new(logoStartPos.X.Scale, logoStartPos.X.Offset + delta.X,
										logoStartPos.Y.Scale, logoStartPos.Y.Offset + delta.Y)
			logoButton.Position = newLogoPos
		end
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		-- Stop dragging
		logoDragging = false
	end
end)

-- Function to Minimize the UI
local function minimizeUI()
	mainFrame.Visible = false
	sidePanel.Visible = false
	logoButton.Visible = true
end

-- Function to Restore the UI
local function restoreUI()
	mainFrame.Visible = true
	sidePanel.Visible = true
	logoButton.Visible = false
end

-- Button Actions
minimizeButton.MouseButton1Click:Connect(minimizeUI)
logoButton.MouseButton1Click:Connect(restoreUI)
