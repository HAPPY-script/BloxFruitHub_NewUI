--=== Remove fog =====================================================================================================--

local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- tìm button đúng đường dẫn
local Frame = player.PlayerGui
	:WaitForChild("BloxFruitHubGui")
	:WaitForChild("Main")
	:WaitForChild("ScrollingTab")
	:WaitForChild("Visual")

local button = Frame:WaitForChild("Remove fog")

local uiStroke = button:FindFirstChildOfClass("UIStroke")
local uiGradient = button:FindFirstChildOfClass("UIGradient")

local firstClick = true

local function removeFog()
	-- Xóa LightingLayers nếu có
	local folder = Lighting:FindFirstChild("LightingLayers")
	if folder then
		folder:Destroy()
	end
end

button.MouseButton1Click:Connect(function()
	removeFog()

	if not firstClick then
		return
	end
	firstClick = false

	-- Tween settings
	local info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	-- Tween BackgroundColor -> xanh
	TweenService:Create(button, info, {
		BackgroundColor3 = Color3.fromRGB(0,255,0)
	}):Play()

	-- Tween TextColor -> trắng
	TweenService:Create(button, info, {
		TextColor3 = Color3.fromRGB(255,255,255)
	}):Play()

	-- Tween UIStroke -> trắng
	if uiStroke then
		TweenService:Create(uiStroke, info, {
			Color = Color3.fromRGB(255,255,255)
		}):Play()
	end

	-- Tween UIGradient -> toàn trắng
	if uiGradient then
		TweenService:Create(uiGradient, info, {
			Color = ColorSequence.new(Color3.fromRGB(255,255,255))
		}):Play()
	end
end)
