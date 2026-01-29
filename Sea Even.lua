local ScrollingTab = game.Players.LocalPlayer.PlayerGui:WaitForChild("BloxFruitHubGui"):WaitForChild("Main"):WaitForChild("ScrollingTab")

local Sea_Even = Instance.new("Frame")
Sea_Even.Name = "Sea Even"
Sea_Even.Size = UDim2.new(1, 0, 1, 0)
Sea_Even.BackgroundColor3 = Color3.new(0, 0.54902, 1)
Sea_Even.BackgroundTransparency = 1
Sea_Even.BorderSizePixel = 0
Sea_Even.BorderColor3 = Color3.new(0, 0, 0)
Sea_Even.Transparency = 1
Sea_Even.Parent = ScrollingTab

local AutoBoatDriveButton = Instance.new("TextButton")
AutoBoatDriveButton.Name = "AutoBoatDriveButton"
AutoBoatDriveButton.Position = UDim2.new(0.85, 0, 0.03, 0)
AutoBoatDriveButton.Size = UDim2.new(0.175, 0, 0.03, 0)
AutoBoatDriveButton.BackgroundColor3 = Color3.new(1, 0, 0)
AutoBoatDriveButton.BackgroundTransparency = 0.75
AutoBoatDriveButton.BorderSizePixel = 0
AutoBoatDriveButton.BorderColor3 = Color3.new(0, 0, 0)
AutoBoatDriveButton.AnchorPoint = Vector2.new(0.5, 0.5)
AutoBoatDriveButton.Transparency = 0.75
AutoBoatDriveButton.Text = ""
AutoBoatDriveButton.TextColor3 = Color3.new(0, 0, 0)
AutoBoatDriveButton.TextSize = 14
AutoBoatDriveButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoBoatDriveButton.Parent = Sea_Even

local UICorner = Instance.new("UICorner")
UICorner.Name = "UICorner"
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = AutoBoatDriveButton

local UIStroke = Instance.new("UIStroke")
UIStroke.Name = "UIStroke"
UIStroke.Color = Color3.new(1, 0, 0)
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = AutoBoatDriveButton

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
Dot.Parent = AutoBoatDriveButton

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

local AutoBoatDriveTitle = Instance.new("TextLabel")
AutoBoatDriveTitle.Name = "AutoBoatDriveTitle"
AutoBoatDriveTitle.Position = UDim2.new(0.375, 0, 0.03, 0)
AutoBoatDriveTitle.Size = UDim2.new(0.7, 0, 0.03, 0)
AutoBoatDriveTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
AutoBoatDriveTitle.BorderSizePixel = 0
AutoBoatDriveTitle.BorderColor3 = Color3.new(0, 0, 0)
AutoBoatDriveTitle.AnchorPoint = Vector2.new(0.5, 0.5)
AutoBoatDriveTitle.Text = "Auto boat drive S3"
AutoBoatDriveTitle.TextColor3 = Color3.new(1, 1, 1)
AutoBoatDriveTitle.TextSize = 14
AutoBoatDriveTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoBoatDriveTitle.TextScaled = true
AutoBoatDriveTitle.TextWrapped = true
AutoBoatDriveTitle.Parent = Sea_Even

local UIStroke2 = Instance.new("UIStroke")
UIStroke2.Name = "UIStroke"
UIStroke2.Color = Color3.new(1, 1, 1)
UIStroke2.Thickness = 2
UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke2.Parent = AutoBoatDriveTitle

local ElevationFrame = Instance.new("Frame")
ElevationFrame.Name = "ElevationFrame"
ElevationFrame.Position = UDim2.new(0.375, 0, 0.085, 0)
ElevationFrame.Size = UDim2.new(0.7, 0, 0.02, 0)
ElevationFrame.BackgroundColor3 = Color3.new(0, 0.101961, 0.384314)
ElevationFrame.BorderSizePixel = 0
ElevationFrame.BorderColor3 = Color3.new(0, 0, 0)
ElevationFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ElevationFrame.Parent = Sea_Even

local UIStroke3 = Instance.new("UIStroke")
UIStroke3.Name = "UIStroke"
UIStroke3.Color = Color3.new(1, 1, 1)
UIStroke3.Thickness = 2
UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke3.Parent = ElevationFrame

local Bar = Instance.new("TextButton")
Bar.Name = "Bar"
Bar.Position = UDim2.new(0.5, 0, 0.5, 0)
Bar.Size = UDim2.new(0.95, 0, 0.3, 0)
Bar.BackgroundColor3 = Color3.new(0.568627, 0, 0.568627)
Bar.BorderSizePixel = 0
Bar.BorderColor3 = Color3.new(0, 0, 0)
Bar.AnchorPoint = Vector2.new(0.5, 0.5)
Bar.Text = ""
Bar.TextColor3 = Color3.new(0, 0, 0)
Bar.TextSize = 14
Bar.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Bar.Parent = ElevationFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Name = "UIGradient"
UIGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1, 0), NumberSequenceKeypoint.new(0.4, 0, 0), NumberSequenceKeypoint.new(0.6, 0, 0), NumberSequenceKeypoint.new(1, 1, 0), NumberSequenceKeypoint.new(1, 0, 0), NumberSequenceKeypoint.new(1, 0, 0)})
UIGradient.Rotation = 90
UIGradient.Parent = Bar

local Fill = Instance.new("Frame")
Fill.Name = "Fill"
Fill.Position = UDim2.new(0, 0, 0.5, 0)
Fill.Size = UDim2.new(1, 0, 1, 0)
Fill.BackgroundColor3 = Color3.new(1, 0, 1)
Fill.BorderSizePixel = 0
Fill.BorderColor3 = Color3.new(0, 0, 0)
Fill.AnchorPoint = Vector2.new(0, 0.5)
Fill.Parent = Bar

local UICorner3 = Instance.new("UICorner")
UICorner3.Name = "UICorner"
UICorner3.CornerRadius = UDim.new(1, 0)
UICorner3.Parent = Fill

local Knob = Instance.new("TextButton")
Knob.Name = "Knob"
Knob.Size = UDim2.new(3, 0, 3, 0)
Knob.BackgroundColor3 = Color3.new(1, 1, 1)
Knob.BackgroundTransparency = 1
Knob.BorderSizePixel = 0
Knob.BorderColor3 = Color3.new(0, 0, 0)
Knob.ZIndex = 2
Knob.Transparency = 1
Knob.Text = ""
Knob.TextColor3 = Color3.new(0, 0, 0)
Knob.TextSize = 14
Knob.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Knob.Parent = Bar

local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint2.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint2.Parent = Knob

local BoatIcon = Instance.new("ImageLabel")
BoatIcon.Name = "BoatIcon"
BoatIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
BoatIcon.Size = UDim2.new(2, 0, 2, 0)
BoatIcon.BackgroundColor3 = Color3.new(1, 1, 1)
BoatIcon.BackgroundTransparency = 1
BoatIcon.BorderSizePixel = 0
BoatIcon.BorderColor3 = Color3.new(0, 0, 0)
BoatIcon.AnchorPoint = Vector2.new(0.5, 0.5)
BoatIcon.Transparency = 1
BoatIcon.Image = "rbxassetid://107829383651875"
BoatIcon.Parent = Knob

local UICorner4 = Instance.new("UICorner")
UICorner4.Name = "UICorner"
UICorner4.CornerRadius = UDim.new(1, 0)
UICorner4.Parent = Bar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Position = UDim2.new(0.5, 0, -0.5, 0)
Title.Size = UDim2.new(0.75, 0, 1, 0)
Title.BackgroundColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.BorderSizePixel = 0
Title.BorderColor3 = Color3.new(0, 0, 0)
Title.AnchorPoint = Vector2.new(0.5, 0.5)
Title.Transparency = 1
Title.Text = "Altitude when auto boat drive"
Title.TextColor3 = Color3.new(1, 0, 1)
Title.TextSize = 14
Title.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Title.TextScaled = true
Title.TextWrapped = true
Title.Parent = ElevationFrame

local ElevationBox = Instance.new("TextBox")
ElevationBox.Name = "ElevationBox"
ElevationBox.Position = UDim2.new(0.85, 0, 0.08, 0)
ElevationBox.Size = UDim2.new(0.2, 0, 0.03, 0)
ElevationBox.BackgroundColor3 = Color3.new(0.439216, 0.654902, 1)
ElevationBox.BackgroundTransparency = 0.75
ElevationBox.BorderSizePixel = 0
ElevationBox.BorderColor3 = Color3.new(0, 0, 0)
ElevationBox.AnchorPoint = Vector2.new(0.5, 0.5)
ElevationBox.Transparency = 0.75
ElevationBox.Text = ""
ElevationBox.TextColor3 = Color3.new(1, 1, 1)
ElevationBox.TextSize = 14
ElevationBox.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
ElevationBox.TextScaled = true
ElevationBox.TextWrapped = true
ElevationBox.PlaceholderText = "Elevation value"
ElevationBox.PlaceholderColor3 = Color3.new(1, 1, 1)
ElevationBox.Parent = Sea_Even

local UIStroke4 = Instance.new("UIStroke")
UIStroke4.Name = "UIStroke"
UIStroke4.Color = Color3.new(0.784314, 0.784314, 0.784314)
UIStroke4.Thickness = 2
UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke4.Parent = ElevationBox

local Frame = Sea_Even
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
