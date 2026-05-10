local AutoStopSEvenGui = Instance.new("ScreenGui")
AutoStopSEvenGui.Name = "AutoStopSEvenGui"
AutoStopSEvenGui.ResetOnSpawn = false
AutoStopSEvenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
AutoStopSEvenGui.DisplayOrder = 10
AutoStopSEvenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Size = UDim2.new(0, 450, 0, 450)
Main.BackgroundColor3 = Color3.new(1, 1, 1)
Main.BorderSizePixel = 0
Main.BorderColor3 = Color3.new(0, 0, 0)
Main.Visible = false
Main.ZIndex = 50
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Parent = AutoStopSEvenGui

local TitleFrame = Instance.new("Frame")
TitleFrame.Name = "TitleFrame"
TitleFrame.Position = UDim2.new(0.5, 0, 0.04, 0)
TitleFrame.Size = UDim2.new(1.005, 0, 0.125, 0)
TitleFrame.BackgroundColor3 = Color3.new(1, 1, 1)
TitleFrame.BorderSizePixel = 0
TitleFrame.BorderColor3 = Color3.new(0, 0, 0)
TitleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
TitleFrame.Parent = Main

local UIGradient = Instance.new("UIGradient")
UIGradient.Name = "UIGradient"
UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1, 0.784314, 0)), ColorSequenceKeypoint.new(0.5, Color3.new(0.94902, 1, 0)), ColorSequenceKeypoint.new(1, Color3.new(1, 0.784314, 0))})
UIGradient.Parent = TitleFrame

local UICorner = Instance.new("UICorner")
UICorner.Name = "UICorner"
UICorner.CornerRadius = UDim.new(0.15, 0)
UICorner.Parent = TitleFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Name = "UIStroke"
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = TitleFrame

local Close = Instance.new("ImageButton")
Close.Name = "Close"
Close.Position = UDim2.new(0.95, 0, 0.5, 0)
Close.Size = UDim2.new(0.8, 0, 0.8, 0)
Close.BackgroundColor3 = Color3.new(1, 1, 1)
Close.BorderSizePixel = 0
Close.BorderColor3 = Color3.new(0, 0, 0)
Close.AnchorPoint = Vector2.new(0.5, 0.5)
Close.Parent = TitleFrame

local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint.Parent = Close

local UIStroke2 = Instance.new("UIStroke")
UIStroke2.Name = "UIStroke"
UIStroke2.Thickness = 1.5
UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke2.Parent = Close

local UIGradient2 = Instance.new("UIGradient")
UIGradient2.Name = "UIGradient"
UIGradient2.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1, 0.196078, 0.054902)), ColorSequenceKeypoint.new(0.5, Color3.new(1, 0.45098, 0.235294)), ColorSequenceKeypoint.new(1, Color3.new(1, 0.196078, 0.054902))})
UIGradient2.Rotation = 90
UIGradient2.Parent = Close

local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Name = "ImageLabel"
ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
ImageLabel.Size = UDim2.new(0.75, 0, 0.75, 0)
ImageLabel.BackgroundColor3 = Color3.new(1, 1, 1)
ImageLabel.BackgroundTransparency = 1
ImageLabel.BorderSizePixel = 0
ImageLabel.BorderColor3 = Color3.new(0, 0, 0)
ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
ImageLabel.Transparency = 1
ImageLabel.Image = "rbxassetid://90766052876890"
ImageLabel.Parent = Close

local TextLabel = Instance.new("TextLabel")
TextLabel.Name = "TextLabel"
TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
TextLabel.Size = UDim2.new(0.65, 0, 0.8, 0)
TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel.BackgroundTransparency = 1
TextLabel.BorderSizePixel = 0
TextLabel.BorderColor3 = Color3.new(0, 0, 0)
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.Transparency = 1
TextLabel.Text = "Auto stop settings"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.TextSize = 14
TextLabel.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
TextLabel.TextScaled = true
TextLabel.TextWrapped = true
TextLabel.Parent = TitleFrame

local UIStroke3 = Instance.new("UIStroke")
UIStroke3.Name = "UIStroke"
UIStroke3.Thickness = 1.5
UIStroke3.Parent = TextLabel

local UIStroke4 = Instance.new("UIStroke")
UIStroke4.Name = "UIStroke"
UIStroke4.Thickness = 2
UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke4.Parent = Main

local UIGradient3 = Instance.new("UIGradient")
UIGradient3.Name = "UIGradient"
UIGradient3.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(0, 0.027451, 0.0980392)), ColorSequenceKeypoint.new(0.728374, Color3.new(0.0980392, 0.0980392, 0.0980392)), ColorSequenceKeypoint.new(1, Color3.new(0.14902, 0.14902, 0.14902))})
UIGradient3.Rotation = 90
UIGradient3.Parent = Main

local UICorner2 = Instance.new("UICorner")
UICorner2.Name = "UICorner"
UICorner2.CornerRadius = UDim.new(0.015, 0)
UICorner2.Parent = Main

local UIDragDetector = Instance.new("UIDragDetector")
UIDragDetector.Name = "UIDragDetector"

UIDragDetector.Parent = Main

local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint2.Name = "UIAspectRatioConstraint"
UIAspectRatioConstraint2.AspectRatio = 1.5850000381469727
UIAspectRatioConstraint2.Parent = Main

local ModeFrame = Instance.new("Frame")
ModeFrame.Name = "ModeFrame"
ModeFrame.Position = UDim2.new(0.5, 0, 0.225, 0)
ModeFrame.Size = UDim2.new(0.85, 0, 0.15, 0)
ModeFrame.BackgroundColor3 = Color3.new(1, 1, 1)
ModeFrame.BackgroundTransparency = 1
ModeFrame.BorderSizePixel = 0
ModeFrame.BorderColor3 = Color3.new(0, 0, 0)
ModeFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ModeFrame.Transparency = 1
ModeFrame.Parent = Main

local UIStroke5 = Instance.new("UIStroke")
UIStroke5.Name = "UIStroke"
UIStroke5.Color = Color3.new(1, 0.784314, 0)
UIStroke5.Thickness = 2
UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke5.Parent = ModeFrame

local FrameTitle = Instance.new("Frame")
FrameTitle.Name = "FrameTitle"
FrameTitle.Position = UDim2.new(0.15, 0, 0.5, 0)
FrameTitle.Size = UDim2.new(0.3, 0, 1, 0)
FrameTitle.BackgroundColor3 = Color3.new(1, 1, 1)
FrameTitle.BorderSizePixel = 0
FrameTitle.BorderColor3 = Color3.new(0, 0, 0)
FrameTitle.AnchorPoint = Vector2.new(0.5, 0.5)
FrameTitle.Parent = ModeFrame

local ModeTitle = Instance.new("TextLabel")
ModeTitle.Name = "ModeTitle"
ModeTitle.Position = UDim2.new(0.5, 0, 0.5, 0)
ModeTitle.Size = UDim2.new(0.9, 0, 0.9, 0)
ModeTitle.BackgroundColor3 = Color3.new(1, 1, 1)
ModeTitle.BackgroundTransparency = 1
ModeTitle.BorderSizePixel = 0
ModeTitle.BorderColor3 = Color3.new(0, 0, 0)
ModeTitle.AnchorPoint = Vector2.new(0.5, 0.5)
ModeTitle.Transparency = 1
ModeTitle.Text = "Mode"
ModeTitle.TextColor3 = Color3.new(1, 1, 1)
ModeTitle.TextSize = 14
ModeTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
ModeTitle.TextScaled = true
ModeTitle.TextWrapped = true
ModeTitle.Parent = FrameTitle

local UIGradient4 = Instance.new("UIGradient")
UIGradient4.Name = "UIGradient"
UIGradient4.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1, 0.784314, 0)), ColorSequenceKeypoint.new(0.4, Color3.new(0.94902, 1, 0)), ColorSequenceKeypoint.new(0.5, Color3.new(0.94902, 1, 0)), ColorSequenceKeypoint.new(0.6, Color3.new(0.94902, 1, 0)), ColorSequenceKeypoint.new(1, Color3.new(1, 0.784314, 0))})
UIGradient4.Parent = FrameTitle

local StopTitle = Instance.new("TextLabel")
StopTitle.Name = "StopTitle"
StopTitle.Position = UDim2.new(0.45, 0, 0.5, 0)
StopTitle.Size = UDim2.new(0.2, 0, 0.75, 0)
StopTitle.BackgroundColor3 = Color3.new(1, 1, 1)
StopTitle.BackgroundTransparency = 1
StopTitle.BorderSizePixel = 0
StopTitle.BorderColor3 = Color3.new(0, 0, 0)
StopTitle.AnchorPoint = Vector2.new(0.5, 0.5)
StopTitle.Transparency = 1
StopTitle.Text = "Stop:"
StopTitle.TextColor3 = Color3.new(1, 1, 1)
StopTitle.TextSize = 14
StopTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
StopTitle.TextScaled = true
StopTitle.TextWrapped = true
StopTitle.Parent = ModeFrame

local PauseTitle = Instance.new("TextLabel")
PauseTitle.Name = "PauseTitle"
PauseTitle.Position = UDim2.new(0.75, 0, 0.5, 0)
PauseTitle.Size = UDim2.new(0.2, 0, 0.75, 0)
PauseTitle.BackgroundColor3 = Color3.new(1, 1, 1)
PauseTitle.BackgroundTransparency = 1
PauseTitle.BorderSizePixel = 0
PauseTitle.BorderColor3 = Color3.new(0, 0, 0)
PauseTitle.AnchorPoint = Vector2.new(0.5, 0.5)
PauseTitle.Transparency = 1
PauseTitle.Text = "Pause:"
PauseTitle.TextColor3 = Color3.new(1, 1, 1)
PauseTitle.TextSize = 14
PauseTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
PauseTitle.TextScaled = true
PauseTitle.TextWrapped = true
PauseTitle.Parent = ModeFrame

local StopButton = Instance.new("ImageButton")
StopButton.Name = "StopButton"
StopButton.Position = UDim2.new(0.575, 0, 0.5, 0)
StopButton.Size = UDim2.new(0.5, 0, 0.5, 0)
StopButton.BackgroundColor3 = Color3.new(1, 1, 1)
StopButton.BackgroundTransparency = 1
StopButton.BorderSizePixel = 0
StopButton.BorderColor3 = Color3.new(0, 0, 0)
StopButton.AnchorPoint = Vector2.new(0.5, 0.5)
StopButton.Transparency = 1
StopButton.Image = "rbxassetid://4333896501"
StopButton.ImageColor3 = Color3.new(0, 1, 0)
StopButton.Parent = ModeFrame

local UIAspectRatioConstraint3 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint3.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint3.Parent = StopButton

local UIStroke6 = Instance.new("UIStroke")
UIStroke6.Name = "UIStroke"
UIStroke6.Color = Color3.new(1, 0.784314, 0)
UIStroke6.Thickness = 2
UIStroke6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke6.Parent = StopButton

local PauseButton = Instance.new("ImageButton")
PauseButton.Name = "PauseButton"
PauseButton.Position = UDim2.new(0.888, 0, 0.5, 0)
PauseButton.Size = UDim2.new(0.5, 0, 0.5, 0)
PauseButton.BackgroundColor3 = Color3.new(1, 1, 1)
PauseButton.BackgroundTransparency = 1
PauseButton.BorderSizePixel = 0
PauseButton.BorderColor3 = Color3.new(0, 0, 0)
PauseButton.AnchorPoint = Vector2.new(0.5, 0.5)
PauseButton.Transparency = 1
PauseButton.Image = "rbxassetid://4333896501"
PauseButton.ImageColor3 = Color3.new(0, 1, 0)
PauseButton.ImageTransparency = 1
PauseButton.Parent = ModeFrame

local UIAspectRatioConstraint4 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint4.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint4.Parent = PauseButton

local UIStroke7 = Instance.new("UIStroke")
UIStroke7.Name = "UIStroke"
UIStroke7.Color = Color3.new(1, 0.784314, 0)
UIStroke7.Thickness = 2
UIStroke7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke7.Parent = PauseButton

local SelectEvenFrame = Instance.new("ScrollingFrame")
SelectEvenFrame.Name = "SelectEvenFrame"
SelectEvenFrame.Position = UDim2.new(0.5, 0, 0.65, 0)
SelectEvenFrame.Size = UDim2.new(0.9, 0, 0.6, 0)
SelectEvenFrame.BackgroundColor3 = Color3.new(1, 1, 1)
SelectEvenFrame.BackgroundTransparency = 1
SelectEvenFrame.BorderSizePixel = 0
SelectEvenFrame.BorderColor3 = Color3.new(0, 0, 0)
SelectEvenFrame.AnchorPoint = Vector2.new(0.5, 0.5)
SelectEvenFrame.Transparency = 1
SelectEvenFrame.Active = true
SelectEvenFrame.CanvasSize = UDim2.new(0, 0, 0, 100)
SelectEvenFrame.ScrollBarImageColor3 = Color3.new(1, 0.784314, 0)
SelectEvenFrame.ScrollBarThickness = 7
SelectEvenFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
SelectEvenFrame.Parent = Main

local Leviathan = Instance.new("ImageButton")
Leviathan.Name = "Leviathan"
Leviathan.Position = UDim2.new(0, 50, 0, 100)
Leviathan.Size = UDim2.new(0.5, 0, 0.5, 0)
Leviathan.BackgroundColor3 = Color3.new(0.176471, 0.419608, 0.898039)
Leviathan.BorderSizePixel = 0
Leviathan.BorderColor3 = Color3.new(0, 0, 0)
Leviathan.AnchorPoint = Vector2.new(0.5, 1)
Leviathan.Image = "rbxassetid://110253972106922"
Leviathan.Parent = SelectEvenFrame

local UIAspectRatioConstraint5 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint5.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint5.Parent = Leviathan

local UIStroke8 = Instance.new("UIStroke")
UIStroke8.Name = "UIStroke"
UIStroke8.Color = Color3.new(0.176471, 0.419608, 0.898039)
UIStroke8.Thickness = 2
UIStroke8.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke8.Parent = Leviathan

local PickButton = Instance.new("ImageButton")
PickButton.Name = "PickButton"
PickButton.Position = UDim2.new(1, 0, 1, 0)
PickButton.Size = UDim2.new(0.25, 0, 0.25, 0)
PickButton.BackgroundColor3 = Color3.new(0, 0, 0)
PickButton.BackgroundTransparency = 0.25
PickButton.BorderSizePixel = 0
PickButton.BorderColor3 = Color3.new(0, 0, 0)
PickButton.AnchorPoint = Vector2.new(1, 1)
PickButton.Transparency = 0.25
PickButton.Image = "rbxassetid://4333896501"
PickButton.ImageColor3 = Color3.new(0, 1, 0)
PickButton.ImageTransparency = 1
PickButton.Parent = Leviathan

local UIAspectRatioConstraint6 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint6.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint6.Parent = PickButton

local UIStroke9 = Instance.new("UIStroke")
UIStroke9.Name = "UIStroke"
UIStroke9.Color = Color3.new(0.176471, 0.419608, 0.898039)
UIStroke9.Thickness = 2
UIStroke9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke9.Parent = PickButton

local Name = Instance.new("TextLabel")
Name.Name = "Name"
Name.Position = UDim2.new(0.5, 0, 1, 0)
Name.Size = UDim2.new(1, 0, 0.3, 0)
Name.BackgroundColor3 = Color3.new(1, 1, 1)
Name.BackgroundTransparency = 1
Name.BorderSizePixel = 0
Name.BorderColor3 = Color3.new(0, 0, 0)
Name.AnchorPoint = Vector2.new(0.5, 0)
Name.Transparency = 1
Name.Text = "Frozen Dimension"
Name.TextColor3 = Color3.new(1, 1, 1)
Name.TextSize = 14
Name.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Name.TextScaled = true
Name.TextWrapped = true
Name.Parent = Leviathan

local Icon = Instance.new("ImageLabel")
Icon.Name = "Icon"
Icon.Position = UDim2.new(0.5, 0, 1, 0)
Icon.Size = UDim2.new(0.75, 0, 0.75, 0)
Icon.BackgroundColor3 = Color3.new(1, 1, 1)
Icon.BackgroundTransparency = 1
Icon.BorderSizePixel = 0
Icon.BorderColor3 = Color3.new(0, 0, 0)
Icon.AnchorPoint = Vector2.new(0.5, 1)
Icon.Transparency = 1
Icon.Image = "rbxassetid://79008411553432"
Icon.ImageTransparency = 0.25
Icon.Parent = Leviathan

local Prehistoric = Instance.new("ImageButton")
Prehistoric.Name = "Prehistoric"
Prehistoric.Position = UDim2.new(0, 150, 0, 100)
Prehistoric.Size = UDim2.new(0.5, 0, 0.5, 0)
Prehistoric.BackgroundColor3 = Color3.new(0.941176, 0.32549, 0.0862745)
Prehistoric.BorderSizePixel = 0
Prehistoric.BorderColor3 = Color3.new(0, 0, 0)
Prehistoric.AnchorPoint = Vector2.new(0.5, 1)
Prehistoric.Image = "rbxassetid://103660699403504"
Prehistoric.Parent = SelectEvenFrame

local UIAspectRatioConstraint7 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint7.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint7.Parent = Prehistoric

local UIStroke10 = Instance.new("UIStroke")
UIStroke10.Name = "UIStroke"
UIStroke10.Color = Color3.new(0.941176, 0.32549, 0.0862745)
UIStroke10.Thickness = 2
UIStroke10.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke10.Parent = Prehistoric

local PickButton2 = Instance.new("ImageButton")
PickButton2.Name = "PickButton"
PickButton2.Position = UDim2.new(1, 0, 1, 0)
PickButton2.Size = UDim2.new(0.25, 0, 0.25, 0)
PickButton2.BackgroundColor3 = Color3.new(0, 0, 0)
PickButton2.BackgroundTransparency = 0.25
PickButton2.BorderSizePixel = 0
PickButton2.BorderColor3 = Color3.new(0, 0, 0)
PickButton2.AnchorPoint = Vector2.new(1, 1)
PickButton2.Transparency = 0.25
PickButton2.Image = "rbxassetid://4333896501"
PickButton2.ImageColor3 = Color3.new(0, 1, 0)
PickButton2.ImageTransparency = 1
PickButton2.Parent = Prehistoric

local UIAspectRatioConstraint8 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint8.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint8.Parent = PickButton2

local UIStroke11 = Instance.new("UIStroke")
UIStroke11.Name = "UIStroke"
UIStroke11.Color = Color3.new(0.941176, 0.32549, 0.0862745)
UIStroke11.Thickness = 2
UIStroke11.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke11.Parent = PickButton2

local Name2 = Instance.new("TextLabel")
Name2.Name = "Name"
Name2.Position = UDim2.new(0.5, 0, 1, 0)
Name2.Size = UDim2.new(1, 0, 0.3, 0)
Name2.BackgroundColor3 = Color3.new(1, 1, 1)
Name2.BackgroundTransparency = 1
Name2.BorderSizePixel = 0
Name2.BorderColor3 = Color3.new(0, 0, 0)
Name2.AnchorPoint = Vector2.new(0.5, 0)
Name2.Transparency = 1
Name2.Text = "Prehistoric Island"
Name2.TextColor3 = Color3.new(1, 1, 1)
Name2.TextSize = 14
Name2.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Name2.TextScaled = true
Name2.TextWrapped = true
Name2.Parent = Prehistoric

local Icon2 = Instance.new("ImageLabel")
Icon2.Name = "Icon"
Icon2.Position = UDim2.new(0, 0, 1, 0)
Icon2.Size = UDim2.new(0.5, 0, 0.5, 0)
Icon2.BackgroundColor3 = Color3.new(1, 1, 1)
Icon2.BackgroundTransparency = 1
Icon2.BorderSizePixel = 0
Icon2.BorderColor3 = Color3.new(0, 0, 0)
Icon2.AnchorPoint = Vector2.new(0, 1)
Icon2.Transparency = 1
Icon2.Image = "rbxassetid://85028300277419"
Icon2.ImageTransparency = 0.25
Icon2.Parent = Prehistoric

local SeaBeast = Instance.new("ImageButton")
SeaBeast.Name = "SeaBeast"
SeaBeast.Position = UDim2.new(0, 250, 0, 100)
SeaBeast.Size = UDim2.new(0.5, 0, 0.5, 0)
SeaBeast.BackgroundColor3 = Color3.new(0.65098, 0.0117647, 0.0588235)
SeaBeast.BorderSizePixel = 0
SeaBeast.BorderColor3 = Color3.new(0, 0, 0)
SeaBeast.AnchorPoint = Vector2.new(0.5, 1)
SeaBeast.Image = "rbxassetid://107529841101254"
SeaBeast.Parent = SelectEvenFrame

local UIAspectRatioConstraint9 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint9.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint9.Parent = SeaBeast

local UIStroke12 = Instance.new("UIStroke")
UIStroke12.Name = "UIStroke"
UIStroke12.Color = Color3.new(0.65098, 0.0117647, 0.0588235)
UIStroke12.Thickness = 2
UIStroke12.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke12.Parent = SeaBeast

local PickButton3 = Instance.new("ImageButton")
PickButton3.Name = "PickButton"
PickButton3.Position = UDim2.new(1, 0, 1, 0)
PickButton3.Size = UDim2.new(0.25, 0, 0.25, 0)
PickButton3.BackgroundColor3 = Color3.new(0, 0, 0)
PickButton3.BackgroundTransparency = 0.25
PickButton3.BorderSizePixel = 0
PickButton3.BorderColor3 = Color3.new(0, 0, 0)
PickButton3.AnchorPoint = Vector2.new(1, 1)
PickButton3.Transparency = 0.25
PickButton3.Image = "rbxassetid://4333896501"
PickButton3.ImageColor3 = Color3.new(0, 1, 0)
PickButton3.ImageTransparency = 1
PickButton3.Parent = SeaBeast

local UIAspectRatioConstraint10 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint10.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint10.Parent = PickButton3

local UIStroke13 = Instance.new("UIStroke")
UIStroke13.Name = "UIStroke"
UIStroke13.Color = Color3.new(0.65098, 0.0117647, 0.0588235)
UIStroke13.Thickness = 2
UIStroke13.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke13.Parent = PickButton3

local Name3 = Instance.new("TextLabel")
Name3.Name = "Name"
Name3.Position = UDim2.new(0.5, 0, 1, 0)
Name3.Size = UDim2.new(1, 0, 0.3, 0)
Name3.BackgroundColor3 = Color3.new(1, 1, 1)
Name3.BackgroundTransparency = 1
Name3.BorderSizePixel = 0
Name3.BorderColor3 = Color3.new(0, 0, 0)
Name3.AnchorPoint = Vector2.new(0.5, 0)
Name3.Transparency = 1
Name3.Text = "Sea Beast"
Name3.TextColor3 = Color3.new(1, 1, 1)
Name3.TextSize = 14
Name3.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Name3.TextScaled = true
Name3.TextWrapped = true
Name3.Parent = SeaBeast

local Icon3 = Instance.new("ImageLabel")
Icon3.Name = "Icon"
Icon3.Position = UDim2.new(0, 0, 1, 0)
Icon3.Size = UDim2.new(0.6, 0, 0.6, 0)
Icon3.BackgroundColor3 = Color3.new(1, 1, 1)
Icon3.BackgroundTransparency = 1
Icon3.BorderSizePixel = 0
Icon3.BorderColor3 = Color3.new(0, 0, 0)
Icon3.AnchorPoint = Vector2.new(0.2, 0.8)
Icon3.Transparency = 1
Icon3.Image = "rbxassetid://104212972400269"
Icon3.ImageTransparency = 0.25
Icon3.Parent = SeaBeast

local HauntedShipRaid = Instance.new("ImageButton")
HauntedShipRaid.Name = "HauntedShipRaid"
HauntedShipRaid.Position = UDim2.new(0, 350, 0, 100)
HauntedShipRaid.Size = UDim2.new(0.5, 0, 0.5, 0)
HauntedShipRaid.BackgroundColor3 = Color3.new(0.603922, 0.647059, 0.733333)
HauntedShipRaid.BorderSizePixel = 0
HauntedShipRaid.BorderColor3 = Color3.new(0, 0, 0)
HauntedShipRaid.AnchorPoint = Vector2.new(0.5, 1)
HauntedShipRaid.Image = "rbxassetid://107261285667861"
HauntedShipRaid.Parent = SelectEvenFrame

local UIAspectRatioConstraint11 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint11.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint11.Parent = HauntedShipRaid

local UIStroke14 = Instance.new("UIStroke")
UIStroke14.Name = "UIStroke"
UIStroke14.Color = Color3.new(0.603922, 0.647059, 0.733333)
UIStroke14.Thickness = 2
UIStroke14.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke14.Parent = HauntedShipRaid

local PickButton4 = Instance.new("ImageButton")
PickButton4.Name = "PickButton"
PickButton4.Position = UDim2.new(1, 0, 1, 0)
PickButton4.Size = UDim2.new(0.25, 0, 0.25, 0)
PickButton4.BackgroundColor3 = Color3.new(0, 0, 0)
PickButton4.BackgroundTransparency = 0.25
PickButton4.BorderSizePixel = 0
PickButton4.BorderColor3 = Color3.new(0, 0, 0)
PickButton4.AnchorPoint = Vector2.new(1, 1)
PickButton4.Transparency = 0.25
PickButton4.Image = "rbxassetid://4333896501"
PickButton4.ImageColor3 = Color3.new(0, 1, 0)
PickButton4.ImageTransparency = 1
PickButton4.Parent = HauntedShipRaid

local UIAspectRatioConstraint12 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint12.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint12.Parent = PickButton4

local UIStroke15 = Instance.new("UIStroke")
UIStroke15.Name = "UIStroke"
UIStroke15.Color = Color3.new(0.603922, 0.647059, 0.733333)
UIStroke15.Thickness = 2
UIStroke15.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke15.Parent = PickButton4

local Name4 = Instance.new("TextLabel")
Name4.Name = "Name"
Name4.Position = UDim2.new(0.5, 0, 1, 0)
Name4.Size = UDim2.new(1, 0, 0.3, 0)
Name4.BackgroundColor3 = Color3.new(1, 1, 1)
Name4.BackgroundTransparency = 1
Name4.BorderSizePixel = 0
Name4.BorderColor3 = Color3.new(0, 0, 0)
Name4.AnchorPoint = Vector2.new(0.5, 0)
Name4.Transparency = 1
Name4.Text = "Haunted Ship Raid"
Name4.TextColor3 = Color3.new(1, 1, 1)
Name4.TextSize = 14
Name4.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Name4.TextScaled = true
Name4.TextWrapped = true
Name4.Parent = HauntedShipRaid

local Icon4 = Instance.new("ImageLabel")
Icon4.Name = "Icon"
Icon4.Position = UDim2.new(0, 0, 1, 0)
Icon4.Size = UDim2.new(0.6, 0, 0.6, 0)
Icon4.BackgroundColor3 = Color3.new(1, 1, 1)
Icon4.BackgroundTransparency = 1
Icon4.BorderSizePixel = 0
Icon4.BorderColor3 = Color3.new(0, 0, 0)
Icon4.AnchorPoint = Vector2.new(0.2, 0.8)
Icon4.Transparency = 1
Icon4.Image = "rbxassetid://113010687158718"
Icon4.ImageTransparency = 0.25
Icon4.Parent = HauntedShipRaid

local Piranha = Instance.new("ImageButton")
Piranha.Name = "Piranha"
Piranha.Position = UDim2.new(0, 50, 0, 220)
Piranha.Size = UDim2.new(0.5, 0, 0.5, 0)
Piranha.BackgroundColor3 = Color3.new(0.0745098, 0.317647, 0.611765)
Piranha.BorderSizePixel = 0
Piranha.BorderColor3 = Color3.new(0, 0, 0)
Piranha.AnchorPoint = Vector2.new(0.5, 1)
Piranha.Image = "rbxassetid://134341630427646"
Piranha.Parent = SelectEvenFrame

local UIAspectRatioConstraint13 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint13.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint13.Parent = Piranha

local UIStroke16 = Instance.new("UIStroke")
UIStroke16.Name = "UIStroke"
UIStroke16.Color = Color3.new(0.0745098, 0.317647, 0.611765)
UIStroke16.Thickness = 2
UIStroke16.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke16.Parent = Piranha

local PickButton5 = Instance.new("ImageButton")
PickButton5.Name = "PickButton"
PickButton5.Position = UDim2.new(1, 0, 1, 0)
PickButton5.Size = UDim2.new(0.25, 0, 0.25, 0)
PickButton5.BackgroundColor3 = Color3.new(0, 0, 0)
PickButton5.BackgroundTransparency = 0.25
PickButton5.BorderSizePixel = 0
PickButton5.BorderColor3 = Color3.new(0, 0, 0)
PickButton5.AnchorPoint = Vector2.new(1, 1)
PickButton5.Transparency = 0.25
PickButton5.Image = "rbxassetid://4333896501"
PickButton5.ImageColor3 = Color3.new(0, 1, 0)
PickButton5.ImageTransparency = 1
PickButton5.Parent = Piranha

local UIAspectRatioConstraint14 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint14.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint14.Parent = PickButton5

local UIStroke17 = Instance.new("UIStroke")
UIStroke17.Name = "UIStroke"
UIStroke17.Color = Color3.new(0.0745098, 0.317647, 0.611765)
UIStroke17.Thickness = 2
UIStroke17.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke17.Parent = PickButton5

local Name5 = Instance.new("TextLabel")
Name5.Name = "Name"
Name5.Position = UDim2.new(0.5, 0, 1, 0)
Name5.Size = UDim2.new(1, 0, 0.3, 0)
Name5.BackgroundColor3 = Color3.new(1, 1, 1)
Name5.BackgroundTransparency = 1
Name5.BorderSizePixel = 0
Name5.BorderColor3 = Color3.new(0, 0, 0)
Name5.AnchorPoint = Vector2.new(0.5, 0)
Name5.Transparency = 1
Name5.Text = "Piranha"
Name5.TextColor3 = Color3.new(1, 1, 1)
Name5.TextSize = 14
Name5.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Name5.TextScaled = true
Name5.TextWrapped = true
Name5.Parent = Piranha

local PiranhaImage = Instance.new("ImageLabel")
PiranhaImage.Name = "PiranhaImage"
PiranhaImage.Position = UDim2.new(0.6, 0, 0.4, 0)
PiranhaImage.Size = UDim2.new(0.9, 0, 0.9, 0)
PiranhaImage.BackgroundColor3 = Color3.new(1, 1, 1)
PiranhaImage.BackgroundTransparency = 1
PiranhaImage.BorderSizePixel = 0
PiranhaImage.BorderColor3 = Color3.new(0, 0, 0)
PiranhaImage.AnchorPoint = Vector2.new(0.5, 0.5)
PiranhaImage.Transparency = 1
PiranhaImage.Image = "rbxassetid://114478463067183"
PiranhaImage.ImageTransparency = 0.10000000149011612
PiranhaImage.Parent = Piranha

local Icon5 = Instance.new("ImageLabel")
Icon5.Name = "Icon"
Icon5.Position = UDim2.new(0, 0, 1, 0)
Icon5.Size = UDim2.new(0.45, 0, 0.45, 0)
Icon5.BackgroundColor3 = Color3.new(1, 1, 1)
Icon5.BackgroundTransparency = 1
Icon5.BorderSizePixel = 0
Icon5.BorderColor3 = Color3.new(0, 0, 0)
Icon5.AnchorPoint = Vector2.new(0.2, 0.8)
Icon5.Transparency = 1
Icon5.Image = "rbxassetid://85203151951907"
Icon5.ImageTransparency = 0.25
Icon5.Parent = Piranha

local EndTitle = Instance.new("TextLabel")
EndTitle.Name = "EndTitle"
EndTitle.Position = UDim2.new(0, 0, 0, 290)
EndTitle.Size = UDim2.new(1, 0, 0.15, 0)
EndTitle.BackgroundColor3 = Color3.new(1, 1, 1)
EndTitle.BackgroundTransparency = 1
EndTitle.BorderSizePixel = 0
EndTitle.BorderColor3 = Color3.new(0, 0, 0)
EndTitle.AnchorPoint = Vector2.new(0, 1)
EndTitle.Transparency = 1
EndTitle.Text = "--- End ---"
EndTitle.TextColor3 = Color3.new(1, 1, 1)
EndTitle.TextSize = 14
EndTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
EndTitle.TextScaled = true
EndTitle.TextWrapped = true
EndTitle.Parent = SelectEvenFrame

local Frame = Main
if not Frame then return end
task.spawn(function()
	while true do
		local done = true
		for _, v in ipairs(Frame:GetDescendants()) do
			if v:IsA("TextLabel") or v:IsA("TextBox") or v:IsA("TextButton") then
				if v.TextTransparency ~= 0 or v.TextStrokeTransparency ~= 0 then
					v.TextTransparency = 0
					v.TextStrokeTransparency = 0
					done = false
				end
			end
		end
		if done then
			break
		end
		task.wait(0.1)
	end
end)
