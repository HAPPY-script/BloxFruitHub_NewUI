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
AutoFarmArenaTitle.Position = UDim2.new(0.225, 0, 0.13, 0)
AutoFarmArenaTitle.Size = UDim2.new(0.4, 0, 0.03, 0)
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
AutoFarmArenaBox.Position = UDim2.new(0.674, 0, 0.13, 0)
AutoFarmArenaBox.Size = UDim2.new(0.15, 0, 0.03, 0)
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

local BringModTitle = Instance.new("TextLabel")
BringModTitle.Name = "BringModTitle"
BringModTitle.Position = UDim2.new(0.375, 0, 0.23, 0)
BringModTitle.Size = UDim2.new(0.7, 0, 0.03, 0)
BringModTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
BringModTitle.BorderSizePixel = 0
BringModTitle.BorderColor3 = Color3.new(0, 0, 0)
BringModTitle.AnchorPoint = Vector2.new(0.5, 0.5)
BringModTitle.Text = "Bring mod"
BringModTitle.TextColor3 = Color3.new(1, 1, 1)
BringModTitle.TextSize = 14
BringModTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
BringModTitle.TextScaled = true
BringModTitle.TextWrapped = true
BringModTitle.Parent = Main

local UIStroke9 = Instance.new("UIStroke")
UIStroke9.Name = "UIStroke"
UIStroke9.Color = Color3.new(1, 1, 1)
UIStroke9.Thickness = 2
UIStroke9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke9.Parent = BringModTitle

local BringModButton = Instance.new("TextButton")
BringModButton.Name = "BringModButton"
BringModButton.Position = UDim2.new(0.85, 0, 0.23, 0)
BringModButton.Size = UDim2.new(0.175, 0, 0.03, 0)
BringModButton.BackgroundColor3 = Color3.new(1, 0, 0)
BringModButton.BackgroundTransparency = 0.75
BringModButton.BorderSizePixel = 0
BringModButton.BorderColor3 = Color3.new(0, 0, 0)
BringModButton.AnchorPoint = Vector2.new(0.5, 0.5)
BringModButton.Transparency = 0.75
BringModButton.Text = ""
BringModButton.TextColor3 = Color3.new(0, 0, 0)
BringModButton.TextSize = 14
BringModButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
BringModButton.Parent = Main

local UICorner7 = Instance.new("UICorner")
UICorner7.Name = "UICorner"
UICorner7.CornerRadius = UDim.new(1, 0)
UICorner7.Parent = BringModButton

local UIStroke10 = Instance.new("UIStroke")
UIStroke10.Name = "UIStroke"
UIStroke10.Color = Color3.new(1, 0, 0)
UIStroke10.Thickness = 2
UIStroke10.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke10.Parent = BringModButton

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
Dot4.Parent = BringModButton

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

local SupportStyleButton = Instance.new("TextButton")
SupportStyleButton.Name = "SupportStyleButton"
SupportStyleButton.Position = UDim2.new(0.512, 0, 0.13, 0)
SupportStyleButton.Size = UDim2.new(0.15, 0, 0.03, 0)
SupportStyleButton.BackgroundColor3 = Color3.new(0, 0.784314, 1)
SupportStyleButton.BackgroundTransparency = 0.75
SupportStyleButton.BorderSizePixel = 0
SupportStyleButton.BorderColor3 = Color3.new(0, 0, 0)
SupportStyleButton.AnchorPoint = Vector2.new(0.5, 0.5)
SupportStyleButton.Transparency = 0.75
SupportStyleButton.Text = "Support: melee"
SupportStyleButton.TextColor3 = Color3.new(1, 1, 1)
SupportStyleButton.TextSize = 14
SupportStyleButton.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
SupportStyleButton.TextScaled = true
SupportStyleButton.TextWrapped = true
SupportStyleButton.Parent = Main

local UIStroke11 = Instance.new("UIStroke")
UIStroke11.Name = "UIStroke"
UIStroke11.Color = Color3.new(0, 0.784314, 1)
UIStroke11.Thickness = 2
UIStroke11.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke11.Parent = SupportStyleButton

local AutoFarmCakePrinceButton = Instance.new("TextButton")
AutoFarmCakePrinceButton.Name = "AutoFarmCakePrinceButton"
AutoFarmCakePrinceButton.Position = UDim2.new(0.85, 0, 0.18, 0)
AutoFarmCakePrinceButton.Size = UDim2.new(0.175, 0, 0.03, 0)
AutoFarmCakePrinceButton.BackgroundColor3 = Color3.new(1, 0, 0)
AutoFarmCakePrinceButton.BackgroundTransparency = 0.75
AutoFarmCakePrinceButton.BorderSizePixel = 0
AutoFarmCakePrinceButton.BorderColor3 = Color3.new(0, 0, 0)
AutoFarmCakePrinceButton.AnchorPoint = Vector2.new(0.5, 0.5)
AutoFarmCakePrinceButton.Transparency = 0.75
AutoFarmCakePrinceButton.Text = ""
AutoFarmCakePrinceButton.TextColor3 = Color3.new(0, 0, 0)
AutoFarmCakePrinceButton.TextSize = 14
AutoFarmCakePrinceButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoFarmCakePrinceButton.Parent = Main

local UICorner9 = Instance.new("UICorner")
UICorner9.Name = "UICorner"
UICorner9.CornerRadius = UDim.new(1, 0)
UICorner9.Parent = AutoFarmCakePrinceButton

local UIStroke12 = Instance.new("UIStroke")
UIStroke12.Name = "UIStroke"
UIStroke12.Color = Color3.new(1, 0, 0)
UIStroke12.Thickness = 2
UIStroke12.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke12.Parent = AutoFarmCakePrinceButton

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
Dot5.Parent = AutoFarmCakePrinceButton

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

local AutoFarmCakePrinceTitle = Instance.new("TextLabel")
AutoFarmCakePrinceTitle.Name = "AutoFarmCakePrinceTitle"
AutoFarmCakePrinceTitle.Position = UDim2.new(0.375, 0, 0.18, 0)
AutoFarmCakePrinceTitle.Size = UDim2.new(0.7, 0, 0.03, 0)
AutoFarmCakePrinceTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
AutoFarmCakePrinceTitle.BorderSizePixel = 0
AutoFarmCakePrinceTitle.BorderColor3 = Color3.new(0, 0, 0)
AutoFarmCakePrinceTitle.AnchorPoint = Vector2.new(0.5, 0.5)
AutoFarmCakePrinceTitle.Text = "Auto farm cake prince"
AutoFarmCakePrinceTitle.TextColor3 = Color3.new(1, 1, 1)
AutoFarmCakePrinceTitle.TextSize = 14
AutoFarmCakePrinceTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoFarmCakePrinceTitle.TextScaled = true
AutoFarmCakePrinceTitle.TextWrapped = true
AutoFarmCakePrinceTitle.Parent = Main

local UIStroke13 = Instance.new("UIStroke")
UIStroke13.Name = "UIStroke"
UIStroke13.Color = Color3.new(1, 1, 1)
UIStroke13.Thickness = 2
UIStroke13.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke13.Parent = AutoFarmCakePrinceTitle

local AutoChestButton = Instance.new("TextButton")
AutoChestButton.Name = "AutoChestButton"
AutoChestButton.Position = UDim2.new(0.85, 0, 0.28, 0)
AutoChestButton.Size = UDim2.new(0.175, 0, 0.03, 0)
AutoChestButton.BackgroundColor3 = Color3.new(1, 0, 0)
AutoChestButton.BackgroundTransparency = 0.75
AutoChestButton.BorderSizePixel = 0
AutoChestButton.BorderColor3 = Color3.new(0, 0, 0)
AutoChestButton.AnchorPoint = Vector2.new(0.5, 0.5)
AutoChestButton.Transparency = 0.75
AutoChestButton.Text = ""
AutoChestButton.TextColor3 = Color3.new(0, 0, 0)
AutoChestButton.TextSize = 14
AutoChestButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoChestButton.Parent = Main

local UICorner11 = Instance.new("UICorner")
UICorner11.Name = "UICorner"
UICorner11.CornerRadius = UDim.new(1, 0)
UICorner11.Parent = AutoChestButton

local UIStroke14 = Instance.new("UIStroke")
UIStroke14.Name = "UIStroke"
UIStroke14.Color = Color3.new(1, 0, 0)
UIStroke14.Thickness = 2
UIStroke14.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke14.Parent = AutoChestButton

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
Dot6.Parent = AutoChestButton

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

local AutoChestTitle = Instance.new("TextLabel")
AutoChestTitle.Name = "AutoChestTitle"
AutoChestTitle.Position = UDim2.new(0.375, 0, 0.28, 0)
AutoChestTitle.Size = UDim2.new(0.7, 0, 0.03, 0)
AutoChestTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
AutoChestTitle.BorderSizePixel = 0
AutoChestTitle.BorderColor3 = Color3.new(0, 0, 0)
AutoChestTitle.AnchorPoint = Vector2.new(0.5, 0.5)
AutoChestTitle.Text = "Auto chest"
AutoChestTitle.TextColor3 = Color3.new(1, 1, 1)
AutoChestTitle.TextSize = 14
AutoChestTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoChestTitle.TextScaled = true
AutoChestTitle.TextWrapped = true
AutoChestTitle.Parent = Main

local UIStroke15 = Instance.new("UIStroke")
UIStroke15.Name = "UIStroke"
UIStroke15.Color = Color3.new(1, 1, 1)
UIStroke15.Thickness = 2
UIStroke15.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke15.Parent = AutoChestTitle

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
