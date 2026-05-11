local ScrollingTab = game.Players.LocalPlayer.PlayerGui:WaitForChild("BloxFruitHubGui"):WaitForChild("Main"):WaitForChild("ScrollingTab")

local Sea_Even = Instance.new("Frame")
Sea_Even.Name = "Sea Even"
Sea_Even.Size = UDim2.new(1, 0, 1, 0)
Sea_Even.BackgroundColor3 = Color3.new(0, 0.54902, 1)
Sea_Even.BackgroundTransparency = 1
Sea_Even.BorderSizePixel = 0
Sea_Even.BorderColor3 = Color3.new(0, 0, 0)
Sea_Even.Visible = false
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
AutoBoatDriveTitle.Text = "Auto ship drive S3"
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

local AutoBoatDriveModeTitle = Instance.new("TextLabel")
AutoBoatDriveModeTitle.Name = "AutoBoatDriveModeTitle"
AutoBoatDriveModeTitle.Position = UDim2.new(0.265, 0, 0.13, 0)
AutoBoatDriveModeTitle.Size = UDim2.new(0.465, 0, 0.03, 0)
AutoBoatDriveModeTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
AutoBoatDriveModeTitle.BorderSizePixel = 0
AutoBoatDriveModeTitle.BorderColor3 = Color3.new(0, 0, 0)
AutoBoatDriveModeTitle.ZIndex = 2
AutoBoatDriveModeTitle.AnchorPoint = Vector2.new(0.5, 0.5)
AutoBoatDriveModeTitle.Text = "Auto ship drive mode"
AutoBoatDriveModeTitle.TextColor3 = Color3.new(1, 1, 1)
AutoBoatDriveModeTitle.TextSize = 14
AutoBoatDriveModeTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoBoatDriveModeTitle.TextScaled = true
AutoBoatDriveModeTitle.TextWrapped = true
AutoBoatDriveModeTitle.Parent = Sea_Even

local UIStroke5 = Instance.new("UIStroke")
UIStroke5.Name = "UIStroke"
UIStroke5.Color = Color3.new(1, 1, 1)
UIStroke5.Thickness = 2
UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke5.Parent = AutoBoatDriveModeTitle

local AutoDriveBoatModeButton = Instance.new("TextButton")
AutoDriveBoatModeButton.Name = "AutoDriveBoatModeButton"
AutoDriveBoatModeButton.Position = UDim2.new(0.85, 0, 0.13, 0)
AutoDriveBoatModeButton.Size = UDim2.new(0.2, 0, 0.03, 0)
AutoDriveBoatModeButton.BackgroundColor3 = Color3.new(0, 1, 0.784314)
AutoDriveBoatModeButton.BackgroundTransparency = 0.75
AutoDriveBoatModeButton.BorderSizePixel = 0
AutoDriveBoatModeButton.BorderColor3 = Color3.new(0, 0, 0)
AutoDriveBoatModeButton.AnchorPoint = Vector2.new(0.5, 0.5)
AutoDriveBoatModeButton.Transparency = 0.75
AutoDriveBoatModeButton.Text = "Straight"
AutoDriveBoatModeButton.TextColor3 = Color3.new(1, 1, 1)
AutoDriveBoatModeButton.TextSize = 14
AutoDriveBoatModeButton.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoDriveBoatModeButton.TextScaled = true
AutoDriveBoatModeButton.TextWrapped = true
AutoDriveBoatModeButton.Parent = Sea_Even

local UIStroke6 = Instance.new("UIStroke")
UIStroke6.Name = "UIStroke"
UIStroke6.Color = Color3.new(0, 1, 0.784314)
UIStroke6.Thickness = 2
UIStroke6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke6.Parent = AutoDriveBoatModeButton

local IntensityBox = Instance.new("TextBox")
IntensityBox.Name = "IntensityBox"
IntensityBox.Position = UDim2.new(0.625, 0, 0.13, 0)
IntensityBox.Size = UDim2.new(0.2, 0, 0.03, 0)
IntensityBox.BackgroundColor3 = Color3.new(0.439216, 0.654902, 1)
IntensityBox.BackgroundTransparency = 0.75
IntensityBox.BorderSizePixel = 0
IntensityBox.BorderColor3 = Color3.new(0, 0, 0)
IntensityBox.AnchorPoint = Vector2.new(0.5, 0.5)
IntensityBox.Transparency = 0.75
IntensityBox.Text = ""
IntensityBox.TextColor3 = Color3.new(1, 1, 1)
IntensityBox.TextSize = 14
IntensityBox.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
IntensityBox.TextScaled = true
IntensityBox.TextWrapped = true
IntensityBox.PlaceholderText = "Intensity value"
IntensityBox.PlaceholderColor3 = Color3.new(1, 1, 1)
IntensityBox.Parent = Sea_Even

local UIStroke7 = Instance.new("UIStroke")
UIStroke7.Name = "UIStroke"
UIStroke7.Color = Color3.new(0.784314, 0.784314, 0.784314)
UIStroke7.Thickness = 2
UIStroke7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke7.Parent = IntensityBox

local AutoStopSEvenButton = Instance.new("TextButton")
AutoStopSEvenButton.Name = "AutoStopSEvenButton"
AutoStopSEvenButton.Position = UDim2.new(0.85, 0, 0.18, 0)
AutoStopSEvenButton.Size = UDim2.new(0.175, 0, 0.03, 0)
AutoStopSEvenButton.BackgroundColor3 = Color3.new(1, 0, 0)
AutoStopSEvenButton.BackgroundTransparency = 0.75
AutoStopSEvenButton.BorderSizePixel = 0
AutoStopSEvenButton.BorderColor3 = Color3.new(0, 0, 0)
AutoStopSEvenButton.AnchorPoint = Vector2.new(0.5, 0.5)
AutoStopSEvenButton.Transparency = 0.75
AutoStopSEvenButton.Text = ""
AutoStopSEvenButton.TextColor3 = Color3.new(0, 0, 0)
AutoStopSEvenButton.TextSize = 14
AutoStopSEvenButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoStopSEvenButton.Parent = Sea_Even

local UICorner5 = Instance.new("UICorner")
UICorner5.Name = "UICorner"
UICorner5.CornerRadius = UDim.new(1, 0)
UICorner5.Parent = AutoStopSEvenButton

local UIStroke8 = Instance.new("UIStroke")
UIStroke8.Name = "UIStroke"
UIStroke8.Color = Color3.new(1, 0, 0)
UIStroke8.Thickness = 2
UIStroke8.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke8.Parent = AutoStopSEvenButton

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
Dot2.Parent = AutoStopSEvenButton

local UIAspectRatioConstraint3 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint3.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint3.Parent = Dot2

local UICorner6 = Instance.new("UICorner")
UICorner6.Name = "UICorner"
UICorner6.CornerRadius = UDim.new(1, 0)
UICorner6.Parent = Dot2

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

local AutoStopSEvenSettingButton = Instance.new("TextButton")
AutoStopSEvenSettingButton.Name = "AutoStopSEvenSettingButton"
AutoStopSEvenSettingButton.Position = UDim2.new(0.625, 0, 0.18, 0)
AutoStopSEvenSettingButton.Size = UDim2.new(0.2, 0, 0.03, 0)
AutoStopSEvenSettingButton.BackgroundColor3 = Color3.new(1, 1, 0)
AutoStopSEvenSettingButton.BackgroundTransparency = 0.75
AutoStopSEvenSettingButton.BorderSizePixel = 0
AutoStopSEvenSettingButton.BorderColor3 = Color3.new(0, 0, 0)
AutoStopSEvenSettingButton.AnchorPoint = Vector2.new(0.5, 0.5)
AutoStopSEvenSettingButton.Transparency = 0.75
AutoStopSEvenSettingButton.Text = "Setting"
AutoStopSEvenSettingButton.TextColor3 = Color3.new(1, 1, 1)
AutoStopSEvenSettingButton.TextSize = 14
AutoStopSEvenSettingButton.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoStopSEvenSettingButton.TextScaled = true
AutoStopSEvenSettingButton.TextWrapped = true
AutoStopSEvenSettingButton.Parent = Sea_Even

local UIStroke9 = Instance.new("UIStroke")
UIStroke9.Name = "UIStroke"
UIStroke9.Color = Color3.new(1, 1, 0)
UIStroke9.Thickness = 2
UIStroke9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke9.Parent = AutoStopSEvenSettingButton

local AutoStopSEvenTitle = Instance.new("TextLabel")
AutoStopSEvenTitle.Name = "AutoStopSEvenTitle"
AutoStopSEvenTitle.Position = UDim2.new(0.265, 0, 0.18, 0)
AutoStopSEvenTitle.Size = UDim2.new(0.465, 0, 0.03, 0)
AutoStopSEvenTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
AutoStopSEvenTitle.BorderSizePixel = 0
AutoStopSEvenTitle.BorderColor3 = Color3.new(0, 0, 0)
AutoStopSEvenTitle.ZIndex = 2
AutoStopSEvenTitle.AnchorPoint = Vector2.new(0.5, 0.5)
AutoStopSEvenTitle.Text = "Auto stop sea even"
AutoStopSEvenTitle.TextColor3 = Color3.new(1, 1, 1)
AutoStopSEvenTitle.TextSize = 14
AutoStopSEvenTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoStopSEvenTitle.TextScaled = true
AutoStopSEvenTitle.TextWrapped = true
AutoStopSEvenTitle.Parent = Sea_Even

local UIStroke10 = Instance.new("UIStroke")
UIStroke10.Name = "UIStroke"
UIStroke10.Color = Color3.new(1, 1, 1)
UIStroke10.Thickness = 2
UIStroke10.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke10.Parent = AutoStopSEvenTitle

local ShipSpeedBox = Instance.new("TextBox")
ShipSpeedBox.Name = "ShipSpeedBox"
ShipSpeedBox.Position = UDim2.new(0.625, 0, 0.23, 0)
ShipSpeedBox.Size = UDim2.new(0.2, 0, 0.03, 0)
ShipSpeedBox.BackgroundColor3 = Color3.new(0.439216, 0.654902, 1)
ShipSpeedBox.BackgroundTransparency = 0.75
ShipSpeedBox.BorderSizePixel = 0
ShipSpeedBox.BorderColor3 = Color3.new(0, 0, 0)
ShipSpeedBox.AnchorPoint = Vector2.new(0.5, 0.5)
ShipSpeedBox.Transparency = 0.75
ShipSpeedBox.Text = ""
ShipSpeedBox.TextColor3 = Color3.new(1, 1, 1)
ShipSpeedBox.TextSize = 14
ShipSpeedBox.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
ShipSpeedBox.TextScaled = true
ShipSpeedBox.TextWrapped = true
ShipSpeedBox.PlaceholderText = "Speed value"
ShipSpeedBox.PlaceholderColor3 = Color3.new(1, 1, 1)
ShipSpeedBox.Parent = Sea_Even

local UIStroke11 = Instance.new("UIStroke")
UIStroke11.Name = "UIStroke"
UIStroke11.Color = Color3.new(0.784314, 0.784314, 0.784314)
UIStroke11.Thickness = 2
UIStroke11.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke11.Parent = ShipSpeedBox

local ShipSpeedTitle = Instance.new("TextLabel")
ShipSpeedTitle.Name = "ShipSpeedTitle"
ShipSpeedTitle.Position = UDim2.new(0.265, 0, 0.23, 0)
ShipSpeedTitle.Size = UDim2.new(0.465, 0, 0.03, 0)
ShipSpeedTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
ShipSpeedTitle.BorderSizePixel = 0
ShipSpeedTitle.BorderColor3 = Color3.new(0, 0, 0)
ShipSpeedTitle.ZIndex = 2
ShipSpeedTitle.AnchorPoint = Vector2.new(0.5, 0.5)
ShipSpeedTitle.Text = "Ship speed"
ShipSpeedTitle.TextColor3 = Color3.new(1, 1, 1)
ShipSpeedTitle.TextSize = 14
ShipSpeedTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
ShipSpeedTitle.TextScaled = true
ShipSpeedTitle.TextWrapped = true
ShipSpeedTitle.Parent = Sea_Even

local UIStroke12 = Instance.new("UIStroke")
UIStroke12.Name = "UIStroke"
UIStroke12.Color = Color3.new(1, 1, 1)
UIStroke12.Thickness = 2
UIStroke12.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke12.Parent = ShipSpeedTitle

local ShipSpeedButton = Instance.new("TextButton")
ShipSpeedButton.Name = "ShipSpeedButton"
ShipSpeedButton.Position = UDim2.new(0.85, 0, 0.23, 0)
ShipSpeedButton.Size = UDim2.new(0.175, 0, 0.03, 0)
ShipSpeedButton.BackgroundColor3 = Color3.new(1, 0, 0)
ShipSpeedButton.BackgroundTransparency = 0.75
ShipSpeedButton.BorderSizePixel = 0
ShipSpeedButton.BorderColor3 = Color3.new(0, 0, 0)
ShipSpeedButton.AnchorPoint = Vector2.new(0.5, 0.5)
ShipSpeedButton.Transparency = 0.75
ShipSpeedButton.Text = ""
ShipSpeedButton.TextColor3 = Color3.new(0, 0, 0)
ShipSpeedButton.TextSize = 14
ShipSpeedButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
ShipSpeedButton.Parent = Sea_Even

local UICorner7 = Instance.new("UICorner")
UICorner7.Name = "UICorner"
UICorner7.CornerRadius = UDim.new(1, 0)
UICorner7.Parent = ShipSpeedButton

local UIStroke13 = Instance.new("UIStroke")
UIStroke13.Name = "UIStroke"
UIStroke13.Color = Color3.new(1, 0, 0)
UIStroke13.Thickness = 2
UIStroke13.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke13.Parent = ShipSpeedButton

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
Dot3.Parent = ShipSpeedButton

local UIAspectRatioConstraint4 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint4.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint4.Parent = Dot3

local UICorner8 = Instance.new("UICorner")
UICorner8.Name = "UICorner"
UICorner8.CornerRadius = UDim.new(1, 0)
UICorner8.Parent = Dot3

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
