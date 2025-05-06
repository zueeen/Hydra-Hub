-- SimpleGuiLib.lua
local SimpleGuiLib = {}

local function createMainGui()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "SimpleGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	return screenGui
end

local mainGui = createMainGui()

function SimpleGuiLib.CreateButton(buttonText, position, callback)
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

return SimpleGuiLib
