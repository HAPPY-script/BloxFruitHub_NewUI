local ScrollingTab = game.Players.LocalPlayer.PlayerGui:WaitForChild("BloxFruitHubGui"):WaitForChild("Main"):WaitForChild("ScrollingTab")

local Player_Setting = Instance.new("Frame")
Player_Setting.Name = "Player Setting"
Player_Setting.Size = UDim2.new(1, 0, 1, 0)
Player_Setting.BackgroundColor3 = Color3.new(0.784314, 0.784314, 1)
Player_Setting.BackgroundTransparency = 1
Player_Setting.BorderSizePixel = 0
Player_Setting.BorderColor3 = Color3.new(0, 0, 0)
Player_Setting.Transparency = 1
Player_Setting.Parent = ScrollingTab

local TPKeyPCButton = Instance.new("TextButton")
TPKeyPCButton.Name = "TPKeyPCButton"
TPKeyPCButton.Position = UDim2.new(0.85, 0, 0.13, 0)
TPKeyPCButton.Size = UDim2.new(0.175, 0, 0.03, 0)
TPKeyPCButton.BackgroundColor3 = Color3.new(1, 0, 0)
TPKeyPCButton.BackgroundTransparency = 0.75
TPKeyPCButton.BorderSizePixel = 0
TPKeyPCButton.BorderColor3 = Color3.new(0, 0, 0)
TPKeyPCButton.AnchorPoint = Vector2.new(0.5, 0.5)
TPKeyPCButton.Transparency = 0.75
TPKeyPCButton.Text = ""
TPKeyPCButton.TextColor3 = Color3.new(0, 0, 0)
TPKeyPCButton.TextSize = 14
TPKeyPCButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
TPKeyPCButton.Parent = Player_Setting

local UICorner = Instance.new("UICorner")
UICorner.Name = "UICorner"
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = TPKeyPCButton

local UIStroke = Instance.new("UIStroke")
UIStroke.Name = "UIStroke"
UIStroke.Color = Color3.new(1, 0, 0)
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = TPKeyPCButton

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
Dot.Parent = TPKeyPCButton

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

local SpeedButton = Instance.new("TextButton")
SpeedButton.Name = "SpeedButton"
SpeedButton.Position = UDim2.new(0.85, 0, 0.03, 0)
SpeedButton.Size = UDim2.new(0.175, 0, 0.03, 0)
SpeedButton.BackgroundColor3 = Color3.new(1, 0, 0)
SpeedButton.BackgroundTransparency = 0.75
SpeedButton.BorderSizePixel = 0
SpeedButton.BorderColor3 = Color3.new(0, 0, 0)
SpeedButton.AnchorPoint = Vector2.new(0.5, 0.5)
SpeedButton.Transparency = 0.75
SpeedButton.Text = ""
SpeedButton.TextColor3 = Color3.new(0, 0, 0)
SpeedButton.TextSize = 14
SpeedButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
SpeedButton.Parent = Player_Setting

local UICorner3 = Instance.new("UICorner")
UICorner3.Name = "UICorner"
UICorner3.CornerRadius = UDim.new(1, 0)
UICorner3.Parent = SpeedButton

local UIStroke2 = Instance.new("UIStroke")
UIStroke2.Name = "UIStroke"
UIStroke2.Color = Color3.new(1, 0, 0)
UIStroke2.Thickness = 2
UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke2.Parent = SpeedButton

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
Dot2.Parent = SpeedButton

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

local IFNJumpButton = Instance.new("TextButton")
IFNJumpButton.Name = "IFNJumpButton"
IFNJumpButton.Position = UDim2.new(0.85, 0, 0.18, 0)
IFNJumpButton.Size = UDim2.new(0.175, 0, 0.03, 0)
IFNJumpButton.BackgroundColor3 = Color3.new(1, 0, 0)
IFNJumpButton.BackgroundTransparency = 0.75
IFNJumpButton.BorderSizePixel = 0
IFNJumpButton.BorderColor3 = Color3.new(0, 0, 0)
IFNJumpButton.AnchorPoint = Vector2.new(0.5, 0.5)
IFNJumpButton.Transparency = 0.75
IFNJumpButton.Text = ""
IFNJumpButton.TextColor3 = Color3.new(0, 0, 0)
IFNJumpButton.TextSize = 14
IFNJumpButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
IFNJumpButton.Parent = Player_Setting

local UICorner5 = Instance.new("UICorner")
UICorner5.Name = "UICorner"
UICorner5.CornerRadius = UDim.new(1, 0)
UICorner5.Parent = IFNJumpButton

local UIStroke3 = Instance.new("UIStroke")
UIStroke3.Name = "UIStroke"
UIStroke3.Color = Color3.new(1, 0, 0)
UIStroke3.Thickness = 2
UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke3.Parent = IFNJumpButton

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
Dot3.Parent = IFNJumpButton

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

local SelectTPKeyPCButton = Instance.new("TextButton")
SelectTPKeyPCButton.Name = "SelectTPKeyPCButton"
SelectTPKeyPCButton.Position = UDim2.new(0.645, 0, 0.13, 0)
SelectTPKeyPCButton.Size = UDim2.new(0.2, 0, 0.03, 0)
SelectTPKeyPCButton.BackgroundColor3 = Color3.new(1, 0, 0)
SelectTPKeyPCButton.BackgroundTransparency = 0.75
SelectTPKeyPCButton.BorderSizePixel = 0
SelectTPKeyPCButton.BorderColor3 = Color3.new(0, 0, 0)
SelectTPKeyPCButton.AnchorPoint = Vector2.new(0.5, 0.5)
SelectTPKeyPCButton.Transparency = 0.75
SelectTPKeyPCButton.Text = "None"
SelectTPKeyPCButton.TextColor3 = Color3.new(1, 1, 1)
SelectTPKeyPCButton.TextSize = 14
SelectTPKeyPCButton.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
SelectTPKeyPCButton.TextScaled = true
SelectTPKeyPCButton.TextWrapped = true
SelectTPKeyPCButton.Parent = Player_Setting

local UIStroke4 = Instance.new("UIStroke")
UIStroke4.Name = "UIStroke"
UIStroke4.Color = Color3.new(1, 0, 0)
UIStroke4.Thickness = 2
UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke4.Parent = SelectTPKeyPCButton

local IFNJumpTitle = Instance.new("TextLabel")
IFNJumpTitle.Name = "IFNJumpTitle"
IFNJumpTitle.Position = UDim2.new(0.375, 0, 0.18, 0)
IFNJumpTitle.Size = UDim2.new(0.7, 0, 0.03, 0)
IFNJumpTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
IFNJumpTitle.BorderSizePixel = 0
IFNJumpTitle.BorderColor3 = Color3.new(0, 0, 0)
IFNJumpTitle.AnchorPoint = Vector2.new(0.5, 0.5)
IFNJumpTitle.Text = "IFN jump"
IFNJumpTitle.TextColor3 = Color3.new(1, 1, 1)
IFNJumpTitle.TextSize = 14
IFNJumpTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
IFNJumpTitle.TextScaled = true
IFNJumpTitle.TextWrapped = true
IFNJumpTitle.Parent = Player_Setting

local UIStroke5 = Instance.new("UIStroke")
UIStroke5.Name = "UIStroke"
UIStroke5.Color = Color3.new(1, 1, 1)
UIStroke5.Thickness = 2
UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke5.Parent = IFNJumpTitle

local NoClipTitle = Instance.new("TextLabel")
NoClipTitle.Name = "NoClipTitle"
NoClipTitle.Position = UDim2.new(0.375, 0, 0.08, 0)
NoClipTitle.Size = UDim2.new(0.7, 0, 0.03, 0)
NoClipTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
NoClipTitle.BorderSizePixel = 0
NoClipTitle.BorderColor3 = Color3.new(0, 0, 0)
NoClipTitle.AnchorPoint = Vector2.new(0.5, 0.5)
NoClipTitle.Text = "No clip"
NoClipTitle.TextColor3 = Color3.new(1, 1, 1)
NoClipTitle.TextSize = 14
NoClipTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
NoClipTitle.TextScaled = true
NoClipTitle.TextWrapped = true
NoClipTitle.Parent = Player_Setting

local UIStroke6 = Instance.new("UIStroke")
UIStroke6.Name = "UIStroke"
UIStroke6.Color = Color3.new(1, 1, 1)
UIStroke6.Thickness = 2
UIStroke6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke6.Parent = NoClipTitle

local TPKeyPCTitle = Instance.new("TextLabel")
TPKeyPCTitle.Name = "TPKeyPCTitle"
TPKeyPCTitle.Position = UDim2.new(0.275, 0, 0.13, 0)
TPKeyPCTitle.Size = UDim2.new(0.5, 0, 0.03, 0)
TPKeyPCTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
TPKeyPCTitle.BorderSizePixel = 0
TPKeyPCTitle.BorderColor3 = Color3.new(0, 0, 0)
TPKeyPCTitle.AnchorPoint = Vector2.new(0.5, 0.5)
TPKeyPCTitle.Text = "TP key"
TPKeyPCTitle.TextColor3 = Color3.new(1, 1, 1)
TPKeyPCTitle.TextSize = 14
TPKeyPCTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
TPKeyPCTitle.TextScaled = true
TPKeyPCTitle.TextWrapped = true
TPKeyPCTitle.Parent = Player_Setting

local UIStroke7 = Instance.new("UIStroke")
UIStroke7.Name = "UIStroke"
UIStroke7.Color = Color3.new(1, 1, 1)
UIStroke7.Thickness = 2
UIStroke7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke7.Parent = TPKeyPCTitle

local SpeedTitle = Instance.new("TextLabel")
SpeedTitle.Name = "SpeedTitle"
SpeedTitle.Position = UDim2.new(0.275, 0, 0.03, 0)
SpeedTitle.Size = UDim2.new(0.5, 0, 0.03, 0)
SpeedTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
SpeedTitle.BorderSizePixel = 0
SpeedTitle.BorderColor3 = Color3.new(0, 0, 0)
SpeedTitle.AnchorPoint = Vector2.new(0.5, 0.5)
SpeedTitle.Text = "Speed"
SpeedTitle.TextColor3 = Color3.new(1, 1, 1)
SpeedTitle.TextSize = 14
SpeedTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
SpeedTitle.TextScaled = true
SpeedTitle.TextWrapped = true
SpeedTitle.Parent = Player_Setting

local UIStroke8 = Instance.new("UIStroke")
UIStroke8.Name = "UIStroke"
UIStroke8.Color = Color3.new(1, 1, 1)
UIStroke8.Thickness = 2
UIStroke8.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke8.Parent = SpeedTitle

local SpeedBox = Instance.new("TextBox")
SpeedBox.Name = "SpeedBox"
SpeedBox.Position = UDim2.new(0.645, 0, 0.03, 0)
SpeedBox.Size = UDim2.new(0.2, 0, 0.03, 0)
SpeedBox.BackgroundColor3 = Color3.new(0.439216, 0.654902, 1)
SpeedBox.BackgroundTransparency = 0.75
SpeedBox.BorderSizePixel = 0
SpeedBox.BorderColor3 = Color3.new(0, 0, 0)
SpeedBox.AnchorPoint = Vector2.new(0.5, 0.5)
SpeedBox.Transparency = 0.75
SpeedBox.Text = ""
SpeedBox.TextColor3 = Color3.new(1, 1, 1)
SpeedBox.TextSize = 14
SpeedBox.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
SpeedBox.TextScaled = true
SpeedBox.TextWrapped = true
SpeedBox.PlaceholderText = "Speed value"
SpeedBox.PlaceholderColor3 = Color3.new(1, 1, 1)
SpeedBox.Parent = Player_Setting

local UIStroke9 = Instance.new("UIStroke")
UIStroke9.Name = "UIStroke"
UIStroke9.Color = Color3.new(0.784314, 0.784314, 0.784314)
UIStroke9.Thickness = 2
UIStroke9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke9.Parent = SpeedBox

local NoClipButton = Instance.new("TextButton")
NoClipButton.Name = "NoClipButton"
NoClipButton.Position = UDim2.new(0.85, 0, 0.08, 0)
NoClipButton.Size = UDim2.new(0.175, 0, 0.03, 0)
NoClipButton.BackgroundColor3 = Color3.new(1, 0, 0)
NoClipButton.BackgroundTransparency = 0.75
NoClipButton.BorderSizePixel = 0
NoClipButton.BorderColor3 = Color3.new(0, 0, 0)
NoClipButton.AnchorPoint = Vector2.new(0.5, 0.5)
NoClipButton.Transparency = 0.75
NoClipButton.Text = ""
NoClipButton.TextColor3 = Color3.new(0, 0, 0)
NoClipButton.TextSize = 14
NoClipButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
NoClipButton.Parent = Player_Setting

local UICorner7 = Instance.new("UICorner")
UICorner7.Name = "UICorner"
UICorner7.CornerRadius = UDim.new(1, 0)
UICorner7.Parent = NoClipButton

local UIStroke10 = Instance.new("UIStroke")
UIStroke10.Name = "UIStroke"
UIStroke10.Color = Color3.new(1, 0, 0)
UIStroke10.Thickness = 2
UIStroke10.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke10.Parent = NoClipButton

local Dot4 = Instance.new("Frame")
Dot4.Name = "Dot"
Dot4.Position = UDim2.new(0.25, 0, 0.5, 0)
Dot4.Size = UDim2.new(0.85, 0, 0.85, 0)
Dot4.BackgroundColor3 = Color3.new(1, 1, 1)
Dot4.BackgroundTransparency = 1
Dot4.BorderSizePixel = 0
Dot4.BorderColor3 = Color3.new(0, 0, 0)
Dot4.AnchorPoint = Vector2.new(0.5, 0.5)
Dot4.Transparency = 1
Dot4.Parent = NoClipButton

local UIAspectRatioConstraint4 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint4.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint4.Parent = Dot4

local UICorner8 = Instance.new("UICorner")
UICorner8.Name = "UICorner"
UICorner8.CornerRadius = UDim.new(1, 0)
UICorner8.Parent = Dot4

local OnIcon4 = Instance.new("ImageLabel")
OnIcon4.Name = "OnIcon"
OnIcon4.Size = UDim2.new(1, 0, 1, 0)
OnIcon4.BackgroundColor3 = Color3.new(0, 1, 0)
OnIcon4.BackgroundTransparency = 1
OnIcon4.BorderSizePixel = 0
OnIcon4.BorderColor3 = Color3.new(0, 0, 0)
OnIcon4.Transparency = 1
OnIcon4.Image = "rbxassetid://133446041443660"
OnIcon4.ImageTransparency = 1
OnIcon4.Parent = Dot4

local OffIcon4 = Instance.new("ImageLabel")
OffIcon4.Name = "OffIcon"
OffIcon4.Size = UDim2.new(1, 0, 1, 0)
OffIcon4.BackgroundColor3 = Color3.new(1, 0, 0)
OffIcon4.BackgroundTransparency = 1
OffIcon4.BorderSizePixel = 0
OffIcon4.BorderColor3 = Color3.new(0, 0, 0)
OffIcon4.Transparency = 1
OffIcon4.Image = "rbxassetid://109833067427302"
OffIcon4.Parent = Dot4

local AutoBusoTitle = Instance.new("TextLabel")
AutoBusoTitle.Name = "AutoBusoTitle"
AutoBusoTitle.Position = UDim2.new(0.375, 0, 0.23, 0)
AutoBusoTitle.Size = UDim2.new(0.7, 0, 0.03, 0)
AutoBusoTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
AutoBusoTitle.BorderSizePixel = 0
AutoBusoTitle.BorderColor3 = Color3.new(0, 0, 0)
AutoBusoTitle.AnchorPoint = Vector2.new(0.5, 0.5)
AutoBusoTitle.Text = "Auto buso"
AutoBusoTitle.TextColor3 = Color3.new(1, 1, 1)
AutoBusoTitle.TextSize = 14
AutoBusoTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoBusoTitle.TextScaled = true
AutoBusoTitle.TextWrapped = true
AutoBusoTitle.Parent = Player_Setting

local UIStroke11 = Instance.new("UIStroke")
UIStroke11.Name = "UIStroke"
UIStroke11.Color = Color3.new(1, 1, 1)
UIStroke11.Thickness = 2
UIStroke11.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke11.Parent = AutoBusoTitle

local AutoObserveTitle = Instance.new("TextLabel")
AutoObserveTitle.Name = "AutoObserveTitle"
AutoObserveTitle.Position = UDim2.new(0.375, 0, 0.28, 0)
AutoObserveTitle.Size = UDim2.new(0.7, 0, 0.03, 0)
AutoObserveTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
AutoObserveTitle.BorderSizePixel = 0
AutoObserveTitle.BorderColor3 = Color3.new(0, 0, 0)
AutoObserveTitle.AnchorPoint = Vector2.new(0.5, 0.5)
AutoObserveTitle.Text = "Auto observe"
AutoObserveTitle.TextColor3 = Color3.new(1, 1, 1)
AutoObserveTitle.TextSize = 14
AutoObserveTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoObserveTitle.TextScaled = true
AutoObserveTitle.TextWrapped = true
AutoObserveTitle.Parent = Player_Setting

local UIStroke12 = Instance.new("UIStroke")
UIStroke12.Name = "UIStroke"
UIStroke12.Color = Color3.new(1, 1, 1)
UIStroke12.Thickness = 2
UIStroke12.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke12.Parent = AutoObserveTitle

local AutoAbilityTitle = Instance.new("TextLabel")
AutoAbilityTitle.Name = "AutoAbilityTitle"
AutoAbilityTitle.Position = UDim2.new(0.375, 0, 0.33, 0)
AutoAbilityTitle.Size = UDim2.new(0.7, 0, 0.03, 0)
AutoAbilityTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
AutoAbilityTitle.BorderSizePixel = 0
AutoAbilityTitle.BorderColor3 = Color3.new(0, 0, 0)
AutoAbilityTitle.AnchorPoint = Vector2.new(0.5, 0.5)
AutoAbilityTitle.Text = "Auto ability"
AutoAbilityTitle.TextColor3 = Color3.new(1, 1, 1)
AutoAbilityTitle.TextSize = 14
AutoAbilityTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoAbilityTitle.TextScaled = true
AutoAbilityTitle.TextWrapped = true
AutoAbilityTitle.Parent = Player_Setting

local UIStroke13 = Instance.new("UIStroke")
UIStroke13.Name = "UIStroke"
UIStroke13.Color = Color3.new(1, 1, 1)
UIStroke13.Thickness = 2
UIStroke13.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke13.Parent = AutoAbilityTitle

local AutoAwakeningTitle = Instance.new("TextLabel")
AutoAwakeningTitle.Name = "AutoAwakeningTitle"
AutoAwakeningTitle.Position = UDim2.new(0.375, 0, 0.38, 0)
AutoAwakeningTitle.Size = UDim2.new(0.7, 0, 0.03, 0)
AutoAwakeningTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
AutoAwakeningTitle.BorderSizePixel = 0
AutoAwakeningTitle.BorderColor3 = Color3.new(0, 0, 0)
AutoAwakeningTitle.AnchorPoint = Vector2.new(0.5, 0.5)
AutoAwakeningTitle.Text = "Auto awakening"
AutoAwakeningTitle.TextColor3 = Color3.new(1, 1, 1)
AutoAwakeningTitle.TextSize = 14
AutoAwakeningTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoAwakeningTitle.TextScaled = true
AutoAwakeningTitle.TextWrapped = true
AutoAwakeningTitle.Parent = Player_Setting

local UIStroke14 = Instance.new("UIStroke")
UIStroke14.Name = "UIStroke"
UIStroke14.Color = Color3.new(1, 1, 1)
UIStroke14.Thickness = 2
UIStroke14.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke14.Parent = AutoAwakeningTitle

local AutoBusoButton = Instance.new("TextButton")
AutoBusoButton.Name = "AutoBusoButton"
AutoBusoButton.Position = UDim2.new(0.85, 0, 0.23, 0)
AutoBusoButton.Size = UDim2.new(0.175, 0, 0.03, 0)
AutoBusoButton.BackgroundColor3 = Color3.new(1, 0, 0)
AutoBusoButton.BackgroundTransparency = 0.75
AutoBusoButton.BorderSizePixel = 0
AutoBusoButton.BorderColor3 = Color3.new(0, 0, 0)
AutoBusoButton.AnchorPoint = Vector2.new(0.5, 0.5)
AutoBusoButton.Transparency = 0.75
AutoBusoButton.Text = ""
AutoBusoButton.TextColor3 = Color3.new(0, 0, 0)
AutoBusoButton.TextSize = 14
AutoBusoButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoBusoButton.Parent = Player_Setting

local UICorner9 = Instance.new("UICorner")
UICorner9.Name = "UICorner"
UICorner9.CornerRadius = UDim.new(1, 0)
UICorner9.Parent = AutoBusoButton

local UIStroke15 = Instance.new("UIStroke")
UIStroke15.Name = "UIStroke"
UIStroke15.Color = Color3.new(1, 0, 0)
UIStroke15.Thickness = 2
UIStroke15.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke15.Parent = AutoBusoButton

local Dot5 = Instance.new("Frame")
Dot5.Name = "Dot"
Dot5.Position = UDim2.new(0.25, 0, 0.5, 0)
Dot5.Size = UDim2.new(0.85, 0, 0.85, 0)
Dot5.BackgroundColor3 = Color3.new(1, 1, 1)
Dot5.BackgroundTransparency = 1
Dot5.BorderSizePixel = 0
Dot5.BorderColor3 = Color3.new(0, 0, 0)
Dot5.AnchorPoint = Vector2.new(0.5, 0.5)
Dot5.Transparency = 1
Dot5.Parent = AutoBusoButton

local UIAspectRatioConstraint5 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint5.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint5.Parent = Dot5

local UICorner10 = Instance.new("UICorner")
UICorner10.Name = "UICorner"
UICorner10.CornerRadius = UDim.new(1, 0)
UICorner10.Parent = Dot5

local OnIcon5 = Instance.new("ImageLabel")
OnIcon5.Name = "OnIcon"
OnIcon5.Size = UDim2.new(1, 0, 1, 0)
OnIcon5.BackgroundColor3 = Color3.new(0, 1, 0)
OnIcon5.BackgroundTransparency = 1
OnIcon5.BorderSizePixel = 0
OnIcon5.BorderColor3 = Color3.new(0, 0, 0)
OnIcon5.Transparency = 1
OnIcon5.Image = "rbxassetid://133446041443660"
OnIcon5.ImageTransparency = 1
OnIcon5.Parent = Dot5

local OffIcon5 = Instance.new("ImageLabel")
OffIcon5.Name = "OffIcon"
OffIcon5.Size = UDim2.new(1, 0, 1, 0)
OffIcon5.BackgroundColor3 = Color3.new(1, 0, 0)
OffIcon5.BackgroundTransparency = 1
OffIcon5.BorderSizePixel = 0
OffIcon5.BorderColor3 = Color3.new(0, 0, 0)
OffIcon5.Transparency = 1
OffIcon5.Image = "rbxassetid://109833067427302"
OffIcon5.Parent = Dot5

local AutoObserveButton = Instance.new("TextButton")
AutoObserveButton.Name = "AutoObserveButton"
AutoObserveButton.Position = UDim2.new(0.85, 0, 0.28, 0)
AutoObserveButton.Size = UDim2.new(0.175, 0, 0.03, 0)
AutoObserveButton.BackgroundColor3 = Color3.new(1, 0, 0)
AutoObserveButton.BackgroundTransparency = 0.75
AutoObserveButton.BorderSizePixel = 0
AutoObserveButton.BorderColor3 = Color3.new(0, 0, 0)
AutoObserveButton.AnchorPoint = Vector2.new(0.5, 0.5)
AutoObserveButton.Transparency = 0.75
AutoObserveButton.Text = ""
AutoObserveButton.TextColor3 = Color3.new(0, 0, 0)
AutoObserveButton.TextSize = 14
AutoObserveButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoObserveButton.Parent = Player_Setting

local UICorner11 = Instance.new("UICorner")
UICorner11.Name = "UICorner"
UICorner11.CornerRadius = UDim.new(1, 0)
UICorner11.Parent = AutoObserveButton

local UIStroke16 = Instance.new("UIStroke")
UIStroke16.Name = "UIStroke"
UIStroke16.Color = Color3.new(1, 0, 0)
UIStroke16.Thickness = 2
UIStroke16.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke16.Parent = AutoObserveButton

local Dot6 = Instance.new("Frame")
Dot6.Name = "Dot"
Dot6.Position = UDim2.new(0.25, 0, 0.5, 0)
Dot6.Size = UDim2.new(0.85, 0, 0.85, 0)
Dot6.BackgroundColor3 = Color3.new(1, 1, 1)
Dot6.BackgroundTransparency = 1
Dot6.BorderSizePixel = 0
Dot6.BorderColor3 = Color3.new(0, 0, 0)
Dot6.AnchorPoint = Vector2.new(0.5, 0.5)
Dot6.Transparency = 1
Dot6.Parent = AutoObserveButton

local UIAspectRatioConstraint6 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint6.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint6.Parent = Dot6

local UICorner12 = Instance.new("UICorner")
UICorner12.Name = "UICorner"
UICorner12.CornerRadius = UDim.new(1, 0)
UICorner12.Parent = Dot6

local OnIcon6 = Instance.new("ImageLabel")
OnIcon6.Name = "OnIcon"
OnIcon6.Size = UDim2.new(1, 0, 1, 0)
OnIcon6.BackgroundColor3 = Color3.new(0, 1, 0)
OnIcon6.BackgroundTransparency = 1
OnIcon6.BorderSizePixel = 0
OnIcon6.BorderColor3 = Color3.new(0, 0, 0)
OnIcon6.Transparency = 1
OnIcon6.Image = "rbxassetid://133446041443660"
OnIcon6.ImageTransparency = 1
OnIcon6.Parent = Dot6

local OffIcon6 = Instance.new("ImageLabel")
OffIcon6.Name = "OffIcon"
OffIcon6.Size = UDim2.new(1, 0, 1, 0)
OffIcon6.BackgroundColor3 = Color3.new(1, 0, 0)
OffIcon6.BackgroundTransparency = 1
OffIcon6.BorderSizePixel = 0
OffIcon6.BorderColor3 = Color3.new(0, 0, 0)
OffIcon6.Transparency = 1
OffIcon6.Image = "rbxassetid://109833067427302"
OffIcon6.Parent = Dot6

local AutoAbilityButton = Instance.new("TextButton")
AutoAbilityButton.Name = "AutoAbilityButton"
AutoAbilityButton.Position = UDim2.new(0.85, 0, 0.33, 0)
AutoAbilityButton.Size = UDim2.new(0.175, 0, 0.03, 0)
AutoAbilityButton.BackgroundColor3 = Color3.new(1, 0, 0)
AutoAbilityButton.BackgroundTransparency = 0.75
AutoAbilityButton.BorderSizePixel = 0
AutoAbilityButton.BorderColor3 = Color3.new(0, 0, 0)
AutoAbilityButton.AnchorPoint = Vector2.new(0.5, 0.5)
AutoAbilityButton.Transparency = 0.75
AutoAbilityButton.Text = ""
AutoAbilityButton.TextColor3 = Color3.new(0, 0, 0)
AutoAbilityButton.TextSize = 14
AutoAbilityButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoAbilityButton.Parent = Player_Setting

local UICorner13 = Instance.new("UICorner")
UICorner13.Name = "UICorner"
UICorner13.CornerRadius = UDim.new(1, 0)
UICorner13.Parent = AutoAbilityButton

local UIStroke17 = Instance.new("UIStroke")
UIStroke17.Name = "UIStroke"
UIStroke17.Color = Color3.new(1, 0, 0)
UIStroke17.Thickness = 2
UIStroke17.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke17.Parent = AutoAbilityButton

local Dot7 = Instance.new("Frame")
Dot7.Name = "Dot"
Dot7.Position = UDim2.new(0.25, 0, 0.5, 0)
Dot7.Size = UDim2.new(0.85, 0, 0.85, 0)
Dot7.BackgroundColor3 = Color3.new(1, 1, 1)
Dot7.BackgroundTransparency = 1
Dot7.BorderSizePixel = 0
Dot7.BorderColor3 = Color3.new(0, 0, 0)
Dot7.AnchorPoint = Vector2.new(0.5, 0.5)
Dot7.Transparency = 1
Dot7.Parent = AutoAbilityButton

local UIAspectRatioConstraint7 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint7.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint7.Parent = Dot7

local UICorner14 = Instance.new("UICorner")
UICorner14.Name = "UICorner"
UICorner14.CornerRadius = UDim.new(1, 0)
UICorner14.Parent = Dot7

local OnIcon7 = Instance.new("ImageLabel")
OnIcon7.Name = "OnIcon"
OnIcon7.Size = UDim2.new(1, 0, 1, 0)
OnIcon7.BackgroundColor3 = Color3.new(0, 1, 0)
OnIcon7.BackgroundTransparency = 1
OnIcon7.BorderSizePixel = 0
OnIcon7.BorderColor3 = Color3.new(0, 0, 0)
OnIcon7.Transparency = 1
OnIcon7.Image = "rbxassetid://133446041443660"
OnIcon7.ImageTransparency = 1
OnIcon7.Parent = Dot7

local OffIcon7 = Instance.new("ImageLabel")
OffIcon7.Name = "OffIcon"
OffIcon7.Size = UDim2.new(1, 0, 1, 0)
OffIcon7.BackgroundColor3 = Color3.new(1, 0, 0)
OffIcon7.BackgroundTransparency = 1
OffIcon7.BorderSizePixel = 0
OffIcon7.BorderColor3 = Color3.new(0, 0, 0)
OffIcon7.Transparency = 1
OffIcon7.Image = "rbxassetid://109833067427302"
OffIcon7.Parent = Dot7

local AutoAwakeningButton = Instance.new("TextButton")
AutoAwakeningButton.Name = "AutoAwakeningButton"
AutoAwakeningButton.Position = UDim2.new(0.85, 0, 0.38, 0)
AutoAwakeningButton.Size = UDim2.new(0.175, 0, 0.03, 0)
AutoAwakeningButton.BackgroundColor3 = Color3.new(1, 0, 0)
AutoAwakeningButton.BackgroundTransparency = 0.75
AutoAwakeningButton.BorderSizePixel = 0
AutoAwakeningButton.BorderColor3 = Color3.new(0, 0, 0)
AutoAwakeningButton.AnchorPoint = Vector2.new(0.5, 0.5)
AutoAwakeningButton.Transparency = 0.75
AutoAwakeningButton.Text = ""
AutoAwakeningButton.TextColor3 = Color3.new(0, 0, 0)
AutoAwakeningButton.TextSize = 14
AutoAwakeningButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoAwakeningButton.Parent = Player_Setting

local UICorner15 = Instance.new("UICorner")
UICorner15.Name = "UICorner"
UICorner15.CornerRadius = UDim.new(1, 0)
UICorner15.Parent = AutoAwakeningButton

local UIStroke18 = Instance.new("UIStroke")
UIStroke18.Name = "UIStroke"
UIStroke18.Color = Color3.new(1, 0, 0)
UIStroke18.Thickness = 2
UIStroke18.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke18.Parent = AutoAwakeningButton

local Dot8 = Instance.new("Frame")
Dot8.Name = "Dot"
Dot8.Position = UDim2.new(0.25, 0, 0.5, 0)
Dot8.Size = UDim2.new(0.85, 0, 0.85, 0)
Dot8.BackgroundColor3 = Color3.new(1, 1, 1)
Dot8.BackgroundTransparency = 1
Dot8.BorderSizePixel = 0
Dot8.BorderColor3 = Color3.new(0, 0, 0)
Dot8.AnchorPoint = Vector2.new(0.5, 0.5)
Dot8.Transparency = 1
Dot8.Parent = AutoAwakeningButton

local UIAspectRatioConstraint8 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint8.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint8.Parent = Dot8

local UICorner16 = Instance.new("UICorner")
UICorner16.Name = "UICorner"
UICorner16.CornerRadius = UDim.new(1, 0)
UICorner16.Parent = Dot8

local OnIcon8 = Instance.new("ImageLabel")
OnIcon8.Name = "OnIcon"
OnIcon8.Size = UDim2.new(1, 0, 1, 0)
OnIcon8.BackgroundColor3 = Color3.new(0, 1, 0)
OnIcon8.BackgroundTransparency = 1
OnIcon8.BorderSizePixel = 0
OnIcon8.BorderColor3 = Color3.new(0, 0, 0)
OnIcon8.Transparency = 1
OnIcon8.Image = "rbxassetid://133446041443660"
OnIcon8.ImageTransparency = 1
OnIcon8.Parent = Dot8

local OffIcon8 = Instance.new("ImageLabel")
OffIcon8.Name = "OffIcon"
OffIcon8.Size = UDim2.new(1, 0, 1, 0)
OffIcon8.BackgroundColor3 = Color3.new(1, 0, 0)
OffIcon8.BackgroundTransparency = 1
OffIcon8.BorderSizePixel = 0
OffIcon8.BorderColor3 = Color3.new(0, 0, 0)
OffIcon8.Transparency = 1
OffIcon8.Image = "rbxassetid://109833067427302"
OffIcon8.Parent = Dot8

local MarinesButton = Instance.new("TextButton")
MarinesButton.Name = "MarinesButton"
MarinesButton.Position = UDim2.new(0.68, 0, 0.44, 0)
MarinesButton.Size = UDim2.new(0.35, 0, 0.04, 0)
MarinesButton.BackgroundColor3 = Color3.new(0, 0.588235, 1)
MarinesButton.BackgroundTransparency = 0.75
MarinesButton.BorderSizePixel = 0
MarinesButton.BorderColor3 = Color3.new(0, 0, 0)
MarinesButton.AnchorPoint = Vector2.new(0.5, 0.5)
MarinesButton.Transparency = 0.75
MarinesButton.Text = "Marines"
MarinesButton.TextColor3 = Color3.new(1, 1, 1)
MarinesButton.TextSize = 14
MarinesButton.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
MarinesButton.TextScaled = true
MarinesButton.TextWrapped = true
MarinesButton.Parent = Player_Setting

local UIStroke19 = Instance.new("UIStroke")
UIStroke19.Name = "UIStroke"
UIStroke19.Color = Color3.new(0, 0.588235, 1)
UIStroke19.Thickness = 2
UIStroke19.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke19.Parent = MarinesButton

local Icon = Instance.new("ImageLabel")
Icon.Name = "Icon"
Icon.Position = UDim2.new(1.25, 0, -0.25, 0)
Icon.Size = UDim2.new(2.5, 0, 2.5, 0)
Icon.BackgroundColor3 = Color3.new(1, 1, 1)
Icon.BackgroundTransparency = 1
Icon.BorderSizePixel = 0
Icon.BorderColor3 = Color3.new(0, 0, 0)
Icon.Rotation = -15
Icon.AnchorPoint = Vector2.new(0.5, 0.5)
Icon.Transparency = 1
Icon.Image = "rbxassetid://71742259184545"
Icon.ImageTransparency = 1
Icon.Parent = MarinesButton

local UIAspectRatioConstraint9 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint9.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint9.Parent = Icon

local UIGradient = Instance.new("UIGradient")
UIGradient.Name = "UIGradient"
UIGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.25, 0), NumberSequenceKeypoint.new(1, 0, 0)})
UIGradient.Parent = Icon

local PiratesButton = Instance.new("TextButton")
PiratesButton.Name = "PiratesButton"
PiratesButton.Position = UDim2.new(0.32, 0, 0.44, 0)
PiratesButton.Size = UDim2.new(0.35, 0, 0.04, 0)
PiratesButton.BackgroundColor3 = Color3.new(0.745098, 0, 0)
PiratesButton.BackgroundTransparency = 0.75
PiratesButton.BorderSizePixel = 0
PiratesButton.BorderColor3 = Color3.new(0, 0, 0)
PiratesButton.AnchorPoint = Vector2.new(0.5, 0.5)
PiratesButton.Transparency = 0.75
PiratesButton.Text = "Pirates"
PiratesButton.TextColor3 = Color3.new(1, 1, 1)
PiratesButton.TextSize = 14
PiratesButton.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
PiratesButton.TextScaled = true
PiratesButton.TextWrapped = true
PiratesButton.Parent = Player_Setting

local UIStroke20 = Instance.new("UIStroke")
UIStroke20.Name = "UIStroke"
UIStroke20.Color = Color3.new(0.745098, 0, 0)
UIStroke20.Thickness = 2
UIStroke20.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke20.Parent = PiratesButton

local Icon2 = Instance.new("ImageLabel")
Icon2.Name = "Icon"
Icon2.Position = UDim2.new(-0.25, 0, -0.25, 0)
Icon2.Size = UDim2.new(2.5, 0, 2.5, 0)
Icon2.BackgroundColor3 = Color3.new(1, 1, 1)
Icon2.BackgroundTransparency = 1
Icon2.BorderSizePixel = 0
Icon2.BorderColor3 = Color3.new(0, 0, 0)
Icon2.Rotation = 15
Icon2.AnchorPoint = Vector2.new(0.5, 0.5)
Icon2.Transparency = 1
Icon2.Image = "rbxassetid://108379075345543"
Icon2.ImageTransparency = 1
Icon2.Parent = PiratesButton

local UIAspectRatioConstraint10 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint10.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint10.Parent = Icon2

local UIGradient2 = Instance.new("UIGradient")
UIGradient2.Name = "UIGradient"
UIGradient2.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 0.25, 0)})
UIGradient2.Parent = Icon2

local Frame = Player_Setting
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
