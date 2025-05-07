local HydraLib = {}

local function createMainGui()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "SimpleGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	return screenGui
end

local mainGui = createMainGui()

function HydraLib.CreateSwitch(switchText, position, callback, Page)
	-- Container
	local switchcontainer = Instance.new("Frame")
	switchcontainer.Size = UDim2.new(0, 460, 0, 30)
	switchcontainer.Position = position or UDim2.new(0, 20, 0, 50)
	switchcontainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	switchcontainer.BackgroundTransparency = 0
	switchcontainer.Parent = Page

	local switchcontainerCorner = Instance.new("UICorner")
	switchcontainerCorner.CornerRadius = UDim.new(0, 5)
	switchcontainerCorner.Parent = switchcontainer

	-- Label
	local switchlabel = Instance.new("TextLabel")
	switchlabel.Size = UDim2.new(1, -60, 1, 0)
	switchlabel.Position = UDim2.new(0, 10, 0, 0)
	switchlabel.Text = switchText or "???"
	switchlabel.Font = Enum.Font.GothamBold
	switchlabel.TextSize = 10
	switchlabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	switchlabel.BackgroundTransparency = 1
	switchlabel.TextXAlignment = Enum.TextXAlignment.Left
	switchlabel.Parent = switchcontainer

	-- Switch background
	local switch = Instance.new("Frame")
	switch.Size = UDim2.new(0, 40, 0, 20)
	switch.Position = UDim2.new(1, -45, 0.5, -10)
	switch.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	switch.BorderSizePixel = 0
	switch.ClipsDescendants = true
	switch.Parent = switchcontainer

	local switchCorner = Instance.new("UICorner")
	switchCorner.CornerRadius = UDim.new(1, 0)
	switchCorner.Parent = switch

	-- Knob
	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 18, 0, 18)
	knob.Position = UDim2.new(0, 1, 0, 1)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.BorderSizePixel = 0
	knob.Parent = switch

	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob

	-- Clickable overlay
	local button = Instance.new("TextButton")
	button.Size = switch.Size
	button.Position = UDim2.new(0, 0, 0, 0)
	button.BackgroundTransparency = 1
	button.Text = ""
	button.Parent = switch

	-- Toggle logic
	local toggled = false

	local function updateSwitch(state)
		toggled = state
		if toggled then
			knob:TweenPosition(UDim2.new(1, -19, 0, 1), "Out", "Quad", 0.2, true)
			switch.BackgroundColor3 = Color3.fromRGB(0, 170, 127) -- ON color
		else
			knob:TweenPosition(UDim2.new(0, 1, 0, 1), "Out", "Quad", 0.2, true)
			switch.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- OFF color
		end

		if callback then
			callback(toggled)
		end
	end

	button.MouseButton1Click:Connect(function()
		updateSwitch(not toggled)
	end)

	-- Return an interface to externally control or query the switch
	return {
	Button = button,             -- The invisible clickable button
	Set = updateSwitch,          -- Function to set toggle state
	Get = function() return toggled end, -- Function to get current state
	Toggled = function() return toggled end, -- Alias for Get
	Container = switchcontainer, -- The full row (label + switch)
	Switch = switch,             -- The switch frame
	Knob = knob,                 -- The moving knob
	Label = switchlabel          -- The text label
}
end

function HydraLib.CreatePageSystem()
	local screenGui = mainGui
	local UserInputService = game:GetService("UserInputService")

	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.new(0, 500, 0, 300)
	mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	mainFrame.BackgroundTransparency = 0.1
	mainFrame.BorderSizePixel = 0
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.Parent = screenGui

	-- Update drag logic to avoid blocking clicks
local drag = Instance.new("Frame")
drag.Size = UDim2.new(1, 0, 0, 30) -- only top area
drag.Position = UDim2.new(0, 0, 0, 0)
drag.BackgroundTransparency = 1 -- make it transparent
drag.Name = "DragArea"
drag.ZIndex = 10
drag.Parent = mainFrame

	-- Custom dragging logic
	local dragging
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	drag.InputBegan:Connect(function(input)
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

	drag.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)

	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 10)
	uiCorner.Parent = mainFrame

	-- Top bar (unchanged)
	local topBar = Instance.new("Frame")
	topBar.Size = UDim2.new(1, -10, 0, 30)
	topBar.Position = UDim2.new(0, 5, 0, 5)
	topBar.BackgroundTransparency = 1
	topBar.BorderSizePixel = 0
	topBar.Parent = mainFrame

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

	-- Parent sidePanel to mainFrame instead of screenGui
local sidePanel = Instance.new("Frame")
sidePanel.Size = UDim2.new(0, 50, 1, 0) -- match height of mainFrame
sidePanel.Position = UDim2.new(0, -55, 0, 0)
sidePanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
sidePanel.BackgroundTransparency = 0.1
sidePanel.BorderSizePixel = 0
sidePanel.Parent = mainFrame -- moved here

	local sideCorner = Instance.new("UICorner")
	sideCorner.CornerRadius = UDim.new(0, 10)
	sideCorner.Parent = sidePanel

	local pages = {}
	local currentPage

	local function switchToPage(name)
		for pageName, frame in pairs(pages) do
			frame.Visible = (pageName == name)
		end
		currentPage = name
	end

	local function createPage(name)
		local page = Instance.new("Frame")
		page.Name = name
		page.Size = UDim2.new(1, -60, 1, -40)
		page.Position = UDim2.new(0, 60, 0, 35)
		page.BackgroundTransparency = 1
		page.Visible = false
		page.Parent = mainFrame
		pages[name] = page
		return page
	end

	local function addSidebarButton(iconId, pageName, positionY)
		local button = Instance.new("ImageButton")
		button.Size = UDim2.new(1, -20, 0, 30)
		button.Position = UDim2.new(0, 10, 0, positionY)
		button.Image = iconId
		button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		button.Parent = sidePanel

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 6)
		corner.Parent = button

		button.MouseButton1Click:Connect(function()
			switchToPage(pageName)
		end)
	end

	return {
		CreatePage = createPage,
		AddSidebarButton = addSidebarButton,
		SwitchToPage = switchToPage,
		MainFrame = mainFrame,
		SidePanel = sidePanel,
	}
end

return HydraLib