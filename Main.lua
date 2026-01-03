local ScrollingTab = game.Players.LocalPlayer.PlayerGui:WaitForChild("BloxFruitHubGui"):WaitForChild("Main"):WaitForChild("ScrollingTab")

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(1, 0, 1, 0)
Main.BackgroundColor3 = Color3.new(0.901961, 0.901961, 0.901961)
Main.BackgroundTransparency = 1
Main.BorderSizePixel = 0
Main.BorderColor3 = Color3.new(0, 0, 0)
Main.Transparency = 1
Main.Parent = ScrollingTab

local AutoHoldToolTitle = Instance.new("TextLabel")
AutoHoldToolTitle.Name = "AutoHoldToolTitle"
AutoHoldToolTitle.Position = UDim2.new(0.275, 0, 0.03, 0)
AutoHoldToolTitle.Size = UDim2.new(0.5, 0, 0.03, 0)
AutoHoldToolTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
AutoHoldToolTitle.BorderSizePixel = 0
AutoHoldToolTitle.BorderColor3 = Color3.new(0, 0, 0)
AutoHoldToolTitle.AnchorPoint = Vector2.new(0.5, 0.5)
AutoHoldToolTitle.Text = "Auto tool holding"
AutoHoldToolTitle.TextColor3 = Color3.new(1, 1, 1)
AutoHoldToolTitle.TextSize = 14
AutoHoldToolTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoHoldToolTitle.TextScaled = true
AutoHoldToolTitle.TextWrapped = true
AutoHoldToolTitle.Parent = Main

local UIStroke = Instance.new("UIStroke")
UIStroke.Name = "UIStroke"
UIStroke.Color = Color3.new(1, 1, 1)
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = AutoHoldToolTitle

local AutoHoldToolButton = Instance.new("TextButton")
AutoHoldToolButton.Name = "AutoHoldToolButton"
AutoHoldToolButton.Position = UDim2.new(0.85, 0, 0.03, 0)
AutoHoldToolButton.Size = UDim2.new(0.175, 0, 0.03, 0)
AutoHoldToolButton.BackgroundColor3 = Color3.new(1, 0, 0)
AutoHoldToolButton.BackgroundTransparency = 0.75
AutoHoldToolButton.BorderSizePixel = 0
AutoHoldToolButton.BorderColor3 = Color3.new(0, 0, 0)
AutoHoldToolButton.AnchorPoint = Vector2.new(0.5, 0.5)
AutoHoldToolButton.Transparency = 0.75
AutoHoldToolButton.Text = ""
AutoHoldToolButton.TextColor3 = Color3.new(0, 0, 0)
AutoHoldToolButton.TextSize = 14
AutoHoldToolButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoHoldToolButton.Parent = Main

local UICorner = Instance.new("UICorner")
UICorner.Name = "UICorner"
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = AutoHoldToolButton

local UIStroke2 = Instance.new("UIStroke")
UIStroke2.Name = "UIStroke"
UIStroke2.Color = Color3.new(1, 0, 0)
UIStroke2.Thickness = 2
UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke2.Parent = AutoHoldToolButton

local Dot = Instance.new("Frame")
Dot.Name = "Dot"
Dot.Position = UDim2.new(0.25, 0, 0.5, 0)
Dot.Size = UDim2.new(0.85, 0, 0.85, 0)
Dot.BackgroundColor3 = Color3.new(1, 1, 1)
Dot.BackgroundTransparency = 1
Dot.BorderSizePixel = 0
Dot.BorderColor3 = Color3.new(0, 0, 0)
Dot.AnchorPoint = Vector2.new(0.5, 0.5)
Dot.Transparency = 1
Dot.Parent = AutoHoldToolButton

local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint.Parent = Dot

local UICorner2 = Instance.new("UICorner")
UICorner2.Name = "UICorner"
UICorner2.CornerRadius = UDim.new(1, 0)
UICorner2.Parent = Dot

local OnIcon = Instance.new("ImageLabel")
OnIcon.Name = "OnIcon"
OnIcon.Size = UDim2.new(1, 0, 1, 0)
OnIcon.BackgroundColor3 = Color3.new(0, 1, 0)
OnIcon.BackgroundTransparency = 1
OnIcon.BorderSizePixel = 0
OnIcon.BorderColor3 = Color3.new(0, 0, 0)
OnIcon.Transparency = 1
OnIcon.Image = "rbxassetid://133446041443660"
OnIcon.ImageTransparency = 1
OnIcon.Parent = Dot

local OffIcon = Instance.new("ImageLabel")
OffIcon.Name = "OffIcon"
OffIcon.Size = UDim2.new(1, 0, 1, 0)
OffIcon.BackgroundColor3 = Color3.new(1, 0, 0)
OffIcon.BackgroundTransparency = 1
OffIcon.BorderSizePixel = 0
OffIcon.BorderColor3 = Color3.new(0, 0, 0)
OffIcon.Transparency = 1
OffIcon.Image = "rbxassetid://109833067427302"
OffIcon.Parent = Dot

local CheckToolButton = Instance.new("TextButton")
CheckToolButton.Name = "CheckToolButton"
CheckToolButton.Position = UDim2.new(0.644979, 0, 0.03, 0)
CheckToolButton.Size = UDim2.new(0.2, 0, 0.03, 0)
CheckToolButton.BackgroundColor3 = Color3.new(1, 0, 0)
CheckToolButton.BackgroundTransparency = 0.75
CheckToolButton.BorderSizePixel = 0
CheckToolButton.BorderColor3 = Color3.new(0, 0, 0)
CheckToolButton.AnchorPoint = Vector2.new(0.5, 0.5)
CheckToolButton.Transparency = 0.75
CheckToolButton.Text = "None"
CheckToolButton.TextColor3 = Color3.new(1, 1, 1)
CheckToolButton.TextSize = 14
CheckToolButton.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CheckToolButton.TextScaled = true
CheckToolButton.TextWrapped = true
CheckToolButton.Parent = Main

local UIStroke3 = Instance.new("UIStroke")
UIStroke3.Name = "UIStroke"
UIStroke3.Color = Color3.new(1, 0, 0)
UIStroke3.Thickness = 2
UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke3.Parent = CheckToolButton

local AutoFarmLvlTitle = Instance.new("TextLabel")
AutoFarmLvlTitle.Name = "AutoFarmLvlTitle"
AutoFarmLvlTitle.Position = UDim2.new(0.375, 0, 0.08, 0)
AutoFarmLvlTitle.Size = UDim2.new(0.7, 0, 0.03, 0)
AutoFarmLvlTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
AutoFarmLvlTitle.BorderSizePixel = 0
AutoFarmLvlTitle.BorderColor3 = Color3.new(0, 0, 0)
AutoFarmLvlTitle.AnchorPoint = Vector2.new(0.5, 0.5)
AutoFarmLvlTitle.Text = "Auto farm level"
AutoFarmLvlTitle.TextColor3 = Color3.new(1, 1, 1)
AutoFarmLvlTitle.TextSize = 14
AutoFarmLvlTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoFarmLvlTitle.TextScaled = true
AutoFarmLvlTitle.TextWrapped = true
AutoFarmLvlTitle.Parent = Main

local UIStroke4 = Instance.new("UIStroke")
UIStroke4.Name = "UIStroke"
UIStroke4.Color = Color3.new(1, 1, 1)
UIStroke4.Thickness = 2
UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke4.Parent = AutoFarmLvlTitle

local AutoFarmLvlButton = Instance.new("TextButton")
AutoFarmLvlButton.Name = "AutoFarmLvlButton"
AutoFarmLvlButton.Position = UDim2.new(0.85, 0, 0.08, 0)
AutoFarmLvlButton.Size = UDim2.new(0.175, 0, 0.03, 0)
AutoFarmLvlButton.BackgroundColor3 = Color3.new(1, 0, 0)
AutoFarmLvlButton.BackgroundTransparency = 0.75
AutoFarmLvlButton.BorderSizePixel = 0
AutoFarmLvlButton.BorderColor3 = Color3.new(0, 0, 0)
AutoFarmLvlButton.AnchorPoint = Vector2.new(0.5, 0.5)
AutoFarmLvlButton.Transparency = 0.75
AutoFarmLvlButton.Text = ""
AutoFarmLvlButton.TextColor3 = Color3.new(0, 0, 0)
AutoFarmLvlButton.TextSize = 14
AutoFarmLvlButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoFarmLvlButton.Parent = Main

local UICorner3 = Instance.new("UICorner")
UICorner3.Name = "UICorner"
UICorner3.CornerRadius = UDim.new(1, 0)
UICorner3.Parent = AutoFarmLvlButton

local UIStroke5 = Instance.new("UIStroke")
UIStroke5.Name = "UIStroke"
UIStroke5.Color = Color3.new(1, 0, 0)
UIStroke5.Thickness = 2
UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke5.Parent = AutoFarmLvlButton

local Dot2 = Instance.new("Frame")
Dot2.Name = "Dot"
Dot2.Position = UDim2.new(0.25, 0, 0.5, 0)
Dot2.Size = UDim2.new(0.85, 0, 0.85, 0)
Dot2.BackgroundColor3 = Color3.new(1, 1, 1)
Dot2.BackgroundTransparency = 1
Dot2.BorderSizePixel = 0
Dot2.BorderColor3 = Color3.new(0, 0, 0)
Dot2.AnchorPoint = Vector2.new(0.5, 0.5)
Dot2.Transparency = 1
Dot2.Parent = AutoFarmLvlButton

local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint2.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint2.Parent = Dot2

local UICorner4 = Instance.new("UICorner")
UICorner4.Name = "UICorner"
UICorner4.CornerRadius = UDim.new(1, 0)
UICorner4.Parent = Dot2

local OnIcon2 = Instance.new("ImageLabel")
OnIcon2.Name = "OnIcon"
OnIcon2.Size = UDim2.new(1, 0, 1, 0)
OnIcon2.BackgroundColor3 = Color3.new(0, 1, 0)
OnIcon2.BackgroundTransparency = 1
OnIcon2.BorderSizePixel = 0
OnIcon2.BorderColor3 = Color3.new(0, 0, 0)
OnIcon2.Transparency = 1
OnIcon2.Image = "rbxassetid://133446041443660"
OnIcon2.ImageTransparency = 1
OnIcon2.Parent = Dot2

local OffIcon2 = Instance.new("ImageLabel")
OffIcon2.Name = "OffIcon"
OffIcon2.Size = UDim2.new(1, 0, 1, 0)
OffIcon2.BackgroundColor3 = Color3.new(1, 0, 0)
OffIcon2.BackgroundTransparency = 1
OffIcon2.BorderSizePixel = 0
OffIcon2.BorderColor3 = Color3.new(0, 0, 0)
OffIcon2.Transparency = 1
OffIcon2.Image = "rbxassetid://109833067427302"
OffIcon2.Parent = Dot2

local AutoFarmArenaTitle = Instance.new("TextLabel")
AutoFarmArenaTitle.Name = "AutoFarmArenaTitle"
AutoFarmArenaTitle.Position = UDim2.new(0.275, 0, 0.13, 0)
AutoFarmArenaTitle.Size = UDim2.new(0.5, 0, 0.03, 0)
AutoFarmArenaTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
AutoFarmArenaTitle.BorderSizePixel = 0
AutoFarmArenaTitle.BorderColor3 = Color3.new(0, 0, 0)
AutoFarmArenaTitle.AnchorPoint = Vector2.new(0.5, 0.5)
AutoFarmArenaTitle.Text = "Auto farm arena"
AutoFarmArenaTitle.TextColor3 = Color3.new(1, 1, 1)
AutoFarmArenaTitle.TextSize = 14
AutoFarmArenaTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoFarmArenaTitle.TextScaled = true
AutoFarmArenaTitle.TextWrapped = true
AutoFarmArenaTitle.Parent = Main

local UIStroke6 = Instance.new("UIStroke")
UIStroke6.Name = "UIStroke"
UIStroke6.Color = Color3.new(1, 1, 1)
UIStroke6.Thickness = 2
UIStroke6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke6.Parent = AutoFarmArenaTitle

local AutoFarmArenaBox = Instance.new("TextBox")
AutoFarmArenaBox.Name = "AutoFarmArenaBox"
AutoFarmArenaBox.Position = UDim2.new(0.645, 0, 0.13, 0)
AutoFarmArenaBox.Size = UDim2.new(0.2, 0, 0.03, 0)
AutoFarmArenaBox.BackgroundColor3 = Color3.new(0.439216, 0.654902, 1)
AutoFarmArenaBox.BackgroundTransparency = 0.75
AutoFarmArenaBox.BorderSizePixel = 0
AutoFarmArenaBox.BorderColor3 = Color3.new(0, 0, 0)
AutoFarmArenaBox.AnchorPoint = Vector2.new(0.5, 0.5)
AutoFarmArenaBox.Transparency = 0.75
AutoFarmArenaBox.Text = ""
AutoFarmArenaBox.TextColor3 = Color3.new(1, 1, 1)
AutoFarmArenaBox.TextSize = 14
AutoFarmArenaBox.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoFarmArenaBox.TextScaled = true
AutoFarmArenaBox.TextWrapped = true
AutoFarmArenaBox.PlaceholderText = "Distance"
AutoFarmArenaBox.PlaceholderColor3 = Color3.new(1, 1, 1)
AutoFarmArenaBox.Parent = Main

local UIStroke7 = Instance.new("UIStroke")
UIStroke7.Name = "UIStroke"
UIStroke7.Color = Color3.new(0.784314, 0.784314, 0.784314)
UIStroke7.Thickness = 2
UIStroke7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke7.Parent = AutoFarmArenaBox

local AutoFarmArenaButton = Instance.new("TextButton")
AutoFarmArenaButton.Name = "AutoFarmArenaButton"
AutoFarmArenaButton.Position = UDim2.new(0.85, 0, 0.13, 0)
AutoFarmArenaButton.Size = UDim2.new(0.175, 0, 0.03, 0)
AutoFarmArenaButton.BackgroundColor3 = Color3.new(1, 0, 0)
AutoFarmArenaButton.BackgroundTransparency = 0.75
AutoFarmArenaButton.BorderSizePixel = 0
AutoFarmArenaButton.BorderColor3 = Color3.new(0, 0, 0)
AutoFarmArenaButton.AnchorPoint = Vector2.new(0.5, 0.5)
AutoFarmArenaButton.Transparency = 0.75
AutoFarmArenaButton.Text = ""
AutoFarmArenaButton.TextColor3 = Color3.new(0, 0, 0)
AutoFarmArenaButton.TextSize = 14
AutoFarmArenaButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoFarmArenaButton.Parent = Main

local UICorner5 = Instance.new("UICorner")
UICorner5.Name = "UICorner"
UICorner5.CornerRadius = UDim.new(1, 0)
UICorner5.Parent = AutoFarmArenaButton

local UIStroke8 = Instance.new("UIStroke")
UIStroke8.Name = "UIStroke"
UIStroke8.Color = Color3.new(1, 0, 0)
UIStroke8.Thickness = 2
UIStroke8.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke8.Parent = AutoFarmArenaButton

local Dot3 = Instance.new("Frame")
Dot3.Name = "Dot"
Dot3.Position = UDim2.new(0.25, 0, 0.5, 0)
Dot3.Size = UDim2.new(0.85, 0, 0.85, 0)
Dot3.BackgroundColor3 = Color3.new(1, 1, 1)
Dot3.BackgroundTransparency = 1
Dot3.BorderSizePixel = 0
Dot3.BorderColor3 = Color3.new(0, 0, 0)
Dot3.AnchorPoint = Vector2.new(0.5, 0.5)
Dot3.Transparency = 1
Dot3.Parent = AutoFarmArenaButton

local UIAspectRatioConstraint3 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint3.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint3.Parent = Dot3

local UICorner6 = Instance.new("UICorner")
UICorner6.Name = "UICorner"
UICorner6.CornerRadius = UDim.new(1, 0)
UICorner6.Parent = Dot3

local OnIcon3 = Instance.new("ImageLabel")
OnIcon3.Name = "OnIcon"
OnIcon3.Size = UDim2.new(1, 0, 1, 0)
OnIcon3.BackgroundColor3 = Color3.new(0, 1, 0)
OnIcon3.BackgroundTransparency = 1
OnIcon3.BorderSizePixel = 0
OnIcon3.BorderColor3 = Color3.new(0, 0, 0)
OnIcon3.Transparency = 1
OnIcon3.Image = "rbxassetid://133446041443660"
OnIcon3.ImageTransparency = 1
OnIcon3.Parent = Dot3

local OffIcon3 = Instance.new("ImageLabel")
OffIcon3.Name = "OffIcon"
OffIcon3.Size = UDim2.new(1, 0, 1, 0)
OffIcon3.BackgroundColor3 = Color3.new(1, 0, 0)
OffIcon3.BackgroundTransparency = 1
OffIcon3.BorderSizePixel = 0
OffIcon3.BorderColor3 = Color3.new(0, 0, 0)
OffIcon3.Transparency = 1
OffIcon3.Image = "rbxassetid://109833067427302"
OffIcon3.Parent = Dot3

local Frame = Main
if not Frame then return end
task.spawn(function()
	while true do
		local allOk = true
		for _, obj in ipairs(Frame:GetDescendants()) do
			if obj:IsA("TextLabel") or obj:IsA("TextBox") then
				if obj.TextTransparency ~= 0 then
					obj.TextTransparency = 0
					allOk = false
				end
			end
		end
		if allOk then
			break
		end
		task.wait(0.1)
	end
end)
