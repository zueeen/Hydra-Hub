local HydraLib = {}

local function createMainGui()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "SimpleGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	return screenGui
end

local mainGui = createMainGui()

function HydraLib.CreateButton(buttonText, position, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 200, 0, 50)
	button.Position = position or UDim2.new(0, 100, 0, 100)
	button.Text = buttonText or "Click Me"
	button.Parent = mainGui
	button.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.SourceSans
	button.TextSize = 24

	button.MouseButton1Click:Connect(function()
		if callback then
			callback()
		end
	end)

	return button
end

function HydraLib.CreatePageSystem()
	local screenGui = mainGui

	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.new(0, 500, 0, 300)
	mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	mainFrame.BackgroundTransparency = 0.1
	mainFrame.BorderSizePixel = 0
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.Parent = screenGui

	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 10)
	uiCorner.Parent = mainFrame

	local sidePanel = Instance.new("Frame")
	sidePanel.Size = UDim2.new(0, 50, 0, 300)
	sidePanel.Position = UDim2.new(0.5, -280, 0.5, 0)
	sidePanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	sidePanel.BackgroundTransparency = 0.1
	sidePanel.BorderSizePixel = 0
	sidePanel.AnchorPoint = Vector2.new(0.5, 0.5)
	sidePanel.Parent = screenGui

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
		page.Size = UDim2.new(1, -60, 1, -20)
		page.Position = UDim2.new(0, 60, 0, 10)
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
