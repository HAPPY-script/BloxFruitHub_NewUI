local ScrollingTab = game.Players.LocalPlayer.PlayerGui:WaitForChild("BloxFruitHubGui"):WaitForChild("Main"):WaitForChild("ScrollingTab")

local Status = Instance.new("Frame")
Status.Name = "Status"
Status.Size = UDim2.new(1, 0, 1, 0)
Status.BackgroundColor3 = Color3.new(0, 0.54902, 1)
Status.BackgroundTransparency = 1
Status.BorderSizePixel = 0
Status.BorderColor3 = Color3.new(0, 0, 0)
Status.Transparency = 1
Status.Parent = ScrollingTab

local MoonStatus = Instance.new("ImageLabel")
MoonStatus.Name = "MoonStatus"
MoonStatus.Position = UDim2.new(0.75, 0, 0.075, 0)
MoonStatus.Size = UDim2.new(0.3, 0, 0.3, 0)
MoonStatus.BackgroundColor3 = Color3.new(1, 0, 1)
MoonStatus.BackgroundTransparency = 0.5
MoonStatus.BorderSizePixel = 0
MoonStatus.BorderColor3 = Color3.new(0, 0, 0)
MoonStatus.Rotation = 180
MoonStatus.AnchorPoint = Vector2.new(0.5, 0.5)
MoonStatus.Transparency = 0.5
MoonStatus.Parent = Status

local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint.Parent = MoonStatus

local UIStroke = Instance.new("UIStroke")
UIStroke.Name = "UIStroke"
UIStroke.Color = Color3.new(1, 1, 1)
UIStroke.Thickness = 2
UIStroke.Parent = MoonStatus

local MoonTitle = Instance.new("TextLabel")
MoonTitle.Name = "MoonTitle"
MoonTitle.Position = UDim2.new(0.495, 0, -0.14, 0)
MoonTitle.Size = UDim2.new(1, 0, 0.25, 0)
MoonTitle.BackgroundColor3 = Color3.new(1, 1, 1)
MoonTitle.BackgroundTransparency = 1
MoonTitle.BorderSizePixel = 0
MoonTitle.BorderColor3 = Color3.new(0, 0, 0)
MoonTitle.Rotation = 180
MoonTitle.AnchorPoint = Vector2.new(0.5, 0.5)
MoonTitle.Text = "Moon state"
MoonTitle.TextColor3 = Color3.new(1, 1, 1)
MoonTitle.TextSize = 14
MoonTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
MoonTitle.TextScaled = true
MoonTitle.TextWrapped = true
MoonTitle.Parent = MoonStatus

local UIStroke2 = Instance.new("UIStroke")
UIStroke2.Name = "UIStroke"
UIStroke2.Color = Color3.new(1, 1, 1)
UIStroke2.Thickness = 2
UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke2.Parent = MoonTitle

local CountPlayer = Instance.new("TextLabel")
CountPlayer.Name = "CountPlayer"
CountPlayer.Position = UDim2.new(0.3, 0, 0.08, 0)
CountPlayer.Size = UDim2.new(0.25, 0, 0.025, 0)
CountPlayer.BackgroundColor3 = Color3.new(1, 1, 1)
CountPlayer.BackgroundTransparency = 1
CountPlayer.BorderSizePixel = 0
CountPlayer.BorderColor3 = Color3.new(0, 0, 0)
CountPlayer.AnchorPoint = Vector2.new(0.5, 0.5)
CountPlayer.Text = "A/N"
CountPlayer.TextColor3 = Color3.new(1, 1, 1)
CountPlayer.TextSize = 14
CountPlayer.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CountPlayer.TextScaled = true
CountPlayer.TextWrapped = true
CountPlayer.Parent = Status

local PlayerIcon = Instance.new("ImageLabel")
PlayerIcon.Name = "PlayerIcon"
PlayerIcon.Position = UDim2.new(0.3, 0, 0.045, 0)
PlayerIcon.Size = UDim2.new(0.125, 0, 0.125, 0)
PlayerIcon.BackgroundColor3 = Color3.new(1, 1, 1)
PlayerIcon.BackgroundTransparency = 1
PlayerIcon.BorderSizePixel = 0
PlayerIcon.BorderColor3 = Color3.new(0, 0, 0)
PlayerIcon.AnchorPoint = Vector2.new(0.5, 0.5)
PlayerIcon.Transparency = 1
PlayerIcon.Image = "rbxassetid://11577689639"
PlayerIcon.ImageColor3 = Color3.new(1, 0, 1)
PlayerIcon.Parent = Status

local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint2.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint2.Parent = PlayerIcon

local Frame = Status
if not Frame then return end
task.spawn(function()
	while true do
		local allOk = true
		for _, obj in ipairs(Frame:GetDescendants()) do
			if obj:IsA("TextLabel")
			or obj:IsA("TextBox")
			or obj:IsA("TextButton") then
				if obj.TextTransparency ~= 0 then
					obj.TextTransparency = 0
					allOk = false
				end
			end
		end
		if allOk then break end
		task.wait(0.1)
	end
end)
