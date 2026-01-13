--=== Remove fog =====================================================================================================--

local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

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
	local folder = Lighting:FindFirstChild("LightingLayers")
	if folder then
		folder:Destroy()
	end
end

button.MouseButton1Click:Connect(function()
	removeFog()

	if not firstClick then return end
	firstClick = false

	local info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	-- Button background -> xanh
	TweenService:Create(button, info, {
		BackgroundColor3 = Color3.fromRGB(0,255,0)
	}):Play()

	-- Text -> trắng
	TweenService:Create(button, info, {
		TextColor3 = Color3.fromRGB(255,255,255)
	}):Play()

	-- UIStroke -> trắng
	if uiStroke then
		TweenService:Create(uiStroke, info, {
			Color = Color3.new(1,1,1)
		}):Play()
	end

	-- UIGradient: tween toàn bộ keypoints sang trắng
	if uiGradient then
		local newKeys = {}
		for _,kp in ipairs(uiGradient.Color.Keypoints) do
			table.insert(newKeys, ColorSequenceKeypoint.new(kp.Time, Color3.new(1,1,1)))
		end

		TweenService:Create(uiGradient, info, {
			Color = ColorSequence.new(newKeys)
		}):Play()
	end
end)
