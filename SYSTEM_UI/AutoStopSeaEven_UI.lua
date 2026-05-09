local AutoStopSEvenGui = Instance.new("ScreenGui")
AutoStopSEvenGui.Name = "AutoStopSEvenGui"
AutoStopSEvenGui.ResetOnSpawn = false
AutoStopSEvenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
AutoStopSEvenGui.DisplayOrder = 10
AutoStopSEvenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Size = UDim2.new(0, 500, 0, 500)
Main.BackgroundColor3 = Color3.new(1, 1, 1)
Main.BorderSizePixel = 0
Main.BorderColor3 = Color3.new(0, 0, 0)
Main.Visible = false
Main.ZIndex = 50
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Parent = AutoStopSEvenGui

local TitleFrame = Instance.new("Frame")
TitleFrame.Name = "TitleFrame"
TitleFrame.Position = UDim2.new(0.5, 0, 0.025, 0)
TitleFrame.Size = UDim2.new(1.005, 0, 0.15, 0)
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
SelectEvenFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
SelectEvenFrame.ScrollBarImageColor3 = Color3.new(1, 0.784314, 0)
SelectEvenFrame.ScrollBarThickness = 7
SelectEvenFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
SelectEvenFrame.Parent = Main

local UIStroke8 = Instance.new("UIStroke")
UIStroke8.Name = "UIStroke"
UIStroke8.Color = Color3.new(1, 1, 1)
UIStroke8.Thickness = 2
UIStroke8.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke8.Parent = SelectEvenFrame

local Leviathan = Instance.new("ImageButton")
Leviathan.Name = "Leviathan"
Leviathan.Position = UDim2.new(0, 10, 0, 10)
Leviathan.Size = UDim2.new(0.5, 0, 0.5, 0)
Leviathan.BackgroundColor3 = Color3.new(0.176471, 0.419608, 0.898039)
Leviathan.BorderSizePixel = 0
Leviathan.BorderColor3 = Color3.new(0, 0, 0)
Leviathan.Image = "rbxassetid://110253972106922"
Leviathan.Parent = SelectEvenFrame

local UIAspectRatioConstraint5 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint5.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint5.Parent = Leviathan

local UIStroke9 = Instance.new("UIStroke")
UIStroke9.Name = "UIStroke"
UIStroke9.Color = Color3.new(0.176471, 0.419608, 0.898039)
UIStroke9.Thickness = 2
UIStroke9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke9.Parent = Leviathan

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

local UIStroke10 = Instance.new("UIStroke")
UIStroke10.Name = "UIStroke"
UIStroke10.Color = Color3.new(0.176471, 0.419608, 0.898039)
UIStroke10.Thickness = 2
UIStroke10.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke10.Parent = PickButton

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
Prehistoric.Position = UDim2.new(0, 125, 0, 10)
Prehistoric.Size = UDim2.new(0.5, 0, 0.5, 0)
Prehistoric.BackgroundColor3 = Color3.new(0.941176, 0.32549, 0.0862745)
Prehistoric.BorderSizePixel = 0
Prehistoric.BorderColor3 = Color3.new(0, 0, 0)
Prehistoric.Image = "rbxassetid://103660699403504"
Prehistoric.Parent = SelectEvenFrame

local UIAspectRatioConstraint7 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint7.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint7.Parent = Prehistoric

local UIStroke11 = Instance.new("UIStroke")
UIStroke11.Name = "UIStroke"
UIStroke11.Color = Color3.new(0.941176, 0.32549, 0.0862745)
UIStroke11.Thickness = 2
UIStroke11.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke11.Parent = Prehistoric

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

local UIStroke12 = Instance.new("UIStroke")
UIStroke12.Name = "UIStroke"
UIStroke12.Color = Color3.new(0.941176, 0.32549, 0.0862745)
UIStroke12.Thickness = 2
UIStroke12.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke12.Parent = PickButton2

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

local Frame = Main
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
