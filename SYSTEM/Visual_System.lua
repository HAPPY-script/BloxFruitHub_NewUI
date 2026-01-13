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

	-- UIGradient tween mượt thật sự
	if uiGradient then
		local startColor = Color3.fromRGB(52,52,52)
		local endColor = Color3.fromRGB(255,255,255)

		local alpha = Instance.new("NumberValue")
		alpha.Value = 0

		local tween = TweenService:Create(alpha, info, {Value = 1})
		tween:Play()

		alpha.Changed:Connect(function(v)
			local c = startColor:Lerp(endColor, v)
			uiGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, c),
				ColorSequenceKeypoint.new(1, c),
			})
		end)

		tween.Completed:Connect(function()
			alpha:Destroy()
		end)
	end
end)
