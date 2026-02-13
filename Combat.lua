local ScrollingTab = game.Players.LocalPlayer.PlayerGui:WaitForChild("BloxFruitHubGui"):WaitForChild("Main"):WaitForChild("ScrollingTab")

local Combat = Instance.new("Frame")
Combat.Name = "Combat"
Combat.Size = UDim2.new(1, 0, 1, 0)
Combat.BackgroundColor3 = Color3.new(1, 0, 0)
Combat.BackgroundTransparency = 1
Combat.BorderSizePixel = 0
Combat.BorderColor3 = Color3.new(0, 0, 0)
Combat.Transparency = 1
Combat.Parent = ScrollingTab

local FollowPlayerBox = Instance.new("TextBox")
FollowPlayerBox.Name = "FollowPlayerBox"
FollowPlayerBox.Position = UDim2.new(0.645, 0, 0.03, 0)
FollowPlayerBox.Size = UDim2.new(0.2, 0, 0.03, 0)
FollowPlayerBox.BackgroundColor3 = Color3.new(0.439216, 0.654902, 1)
FollowPlayerBox.BackgroundTransparency = 0.75
FollowPlayerBox.BorderSizePixel = 0
FollowPlayerBox.BorderColor3 = Color3.new(0, 0, 0)
FollowPlayerBox.AnchorPoint = Vector2.new(0.5, 0.5)
FollowPlayerBox.Transparency = 0.75
FollowPlayerBox.Text = ""
FollowPlayerBox.TextColor3 = Color3.new(1, 1, 1)
FollowPlayerBox.TextSize = 14
FollowPlayerBox.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
FollowPlayerBox.TextScaled = true
FollowPlayerBox.TextWrapped = true
FollowPlayerBox.PlaceholderText = "Username"
FollowPlayerBox.PlaceholderColor3 = Color3.new(1, 1, 1)
FollowPlayerBox.Parent = Combat

local UIStroke = Instance.new("UIStroke")
UIStroke.Name = "UIStroke"
UIStroke.Color = Color3.new(0.784314, 0.784314, 0.784314)
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = FollowPlayerBox

local FastAttackEnemyButton = Instance.new("TextButton")
FastAttackEnemyButton.Name = "FastAttackEnemyButton"
FastAttackEnemyButton.Position = UDim2.new(0.85, 0, 0.13, 0)
FastAttackEnemyButton.Size = UDim2.new(0.175, 0, 0.03, 0)
FastAttackEnemyButton.BackgroundColor3 = Color3.new(1, 0, 0)
FastAttackEnemyButton.BackgroundTransparency = 0.75
FastAttackEnemyButton.BorderSizePixel = 0
FastAttackEnemyButton.BorderColor3 = Color3.new(0, 0, 0)
FastAttackEnemyButton.AnchorPoint = Vector2.new(0.5, 0.5)
FastAttackEnemyButton.Transparency = 0.75
FastAttackEnemyButton.Text = ""
FastAttackEnemyButton.TextColor3 = Color3.new(0, 0, 0)
FastAttackEnemyButton.TextSize = 14
FastAttackEnemyButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
FastAttackEnemyButton.Parent = Combat

local UICorner = Instance.new("UICorner")
UICorner.Name = "UICorner"
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = FastAttackEnemyButton

local UIStroke2 = Instance.new("UIStroke")
UIStroke2.Name = "UIStroke"
UIStroke2.Color = Color3.new(1, 0, 0)
UIStroke2.Thickness = 2
UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke2.Parent = FastAttackEnemyButton

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
Dot.Parent = FastAttackEnemyButton

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

local AimbotButton = Instance.new("TextButton")
AimbotButton.Name = "AimbotButton"
AimbotButton.Position = UDim2.new(0.85, 0, 0.08, 0)
AimbotButton.Size = UDim2.new(0.175, 0, 0.03, 0)
AimbotButton.BackgroundColor3 = Color3.new(1, 0, 0)
AimbotButton.BackgroundTransparency = 0.75
AimbotButton.BorderSizePixel = 0
AimbotButton.BorderColor3 = Color3.new(0, 0, 0)
AimbotButton.AnchorPoint = Vector2.new(0.5, 0.5)
AimbotButton.Transparency = 0.75
AimbotButton.Text = ""
AimbotButton.TextColor3 = Color3.new(0, 0, 0)
AimbotButton.TextSize = 14
AimbotButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AimbotButton.Parent = Combat

local UICorner3 = Instance.new("UICorner")
UICorner3.Name = "UICorner"
UICorner3.CornerRadius = UDim.new(1, 0)
UICorner3.Parent = AimbotButton

local UIStroke3 = Instance.new("UIStroke")
UIStroke3.Name = "UIStroke"
UIStroke3.Color = Color3.new(1, 0, 0)
UIStroke3.Thickness = 2
UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke3.Parent = AimbotButton

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
Dot2.Parent = AimbotButton

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

local FollowPlayerButton = Instance.new("TextButton")
FollowPlayerButton.Name = "FollowPlayerButton"
FollowPlayerButton.Position = UDim2.new(0.85, 0, 0.03, 0)
FollowPlayerButton.Size = UDim2.new(0.175, 0, 0.03, 0)
FollowPlayerButton.BackgroundColor3 = Color3.new(1, 0, 0)
FollowPlayerButton.BackgroundTransparency = 0.75
FollowPlayerButton.BorderSizePixel = 0
FollowPlayerButton.BorderColor3 = Color3.new(0, 0, 0)
FollowPlayerButton.AnchorPoint = Vector2.new(0.5, 0.5)
FollowPlayerButton.Transparency = 0.75
FollowPlayerButton.Text = ""
FollowPlayerButton.TextColor3 = Color3.new(0, 0, 0)
FollowPlayerButton.TextSize = 14
FollowPlayerButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
FollowPlayerButton.Parent = Combat

local UICorner5 = Instance.new("UICorner")
UICorner5.Name = "UICorner"
UICorner5.CornerRadius = UDim.new(1, 0)
UICorner5.Parent = FollowPlayerButton

local UIStroke4 = Instance.new("UIStroke")
UIStroke4.Name = "UIStroke"
UIStroke4.Color = Color3.new(1, 0, 0)
UIStroke4.Thickness = 2
UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke4.Parent = FollowPlayerButton

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
Dot3.Parent = FollowPlayerButton

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

local KeyAimbotButton = Instance.new("TextButton")
KeyAimbotButton.Name = "KeyAimbotButton"
KeyAimbotButton.Position = UDim2.new(0.645, 0, 0.08, 0)
KeyAimbotButton.Size = UDim2.new(0.2, 0, 0.03, 0)
KeyAimbotButton.BackgroundColor3 = Color3.new(1, 0, 0)
KeyAimbotButton.BackgroundTransparency = 0.75
KeyAimbotButton.BorderSizePixel = 0
KeyAimbotButton.BorderColor3 = Color3.new(0, 0, 0)
KeyAimbotButton.AnchorPoint = Vector2.new(0.5, 0.5)
KeyAimbotButton.Transparency = 0.75
KeyAimbotButton.Text = "None"
KeyAimbotButton.TextColor3 = Color3.new(1, 1, 1)
KeyAimbotButton.TextSize = 14
KeyAimbotButton.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
KeyAimbotButton.TextScaled = true
KeyAimbotButton.TextWrapped = true
KeyAimbotButton.Parent = Combat

local UIStroke5 = Instance.new("UIStroke")
UIStroke5.Name = "UIStroke"
UIStroke5.Color = Color3.new(1, 0, 0)
UIStroke5.Thickness = 2
UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke5.Parent = KeyAimbotButton

local AimbotTitle = Instance.new("TextLabel")
AimbotTitle.Name = "AimbotTitle"
AimbotTitle.Position = UDim2.new(0.275, 0, 0.08, 0)
AimbotTitle.Size = UDim2.new(0.5, 0, 0.03, 0)
AimbotTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
AimbotTitle.BorderSizePixel = 0
AimbotTitle.BorderColor3 = Color3.new(0, 0, 0)
AimbotTitle.AnchorPoint = Vector2.new(0.5, 0.5)
AimbotTitle.Text = "Aimbot lock camera"
AimbotTitle.TextColor3 = Color3.new(1, 1, 1)
AimbotTitle.TextSize = 14
AimbotTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AimbotTitle.TextScaled = true
AimbotTitle.TextWrapped = true
AimbotTitle.Parent = Combat

local UIStroke6 = Instance.new("UIStroke")
UIStroke6.Name = "UIStroke"
UIStroke6.Color = Color3.new(1, 1, 1)
UIStroke6.Thickness = 2
UIStroke6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke6.Parent = AimbotTitle

local ReturnYTitle = Instance.new("TextLabel")
ReturnYTitle.Name = "ReturnYTitle"
ReturnYTitle.Position = UDim2.new(0.375, 0, 0.28, 0)
ReturnYTitle.Size = UDim2.new(0.7, 0, 0.03, 0)
ReturnYTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
ReturnYTitle.BorderSizePixel = 0
ReturnYTitle.BorderColor3 = Color3.new(0, 0, 0)
ReturnYTitle.AnchorPoint = Vector2.new(0.5, 0.5)
ReturnYTitle.Text = "Return to original height"
ReturnYTitle.TextColor3 = Color3.new(1, 1, 1)
ReturnYTitle.TextSize = 14
ReturnYTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
ReturnYTitle.TextScaled = true
ReturnYTitle.TextWrapped = true
ReturnYTitle.Parent = Combat

local UIStroke7 = Instance.new("UIStroke")
UIStroke7.Name = "UIStroke"
UIStroke7.Color = Color3.new(1, 1, 1)
UIStroke7.Thickness = 2
UIStroke7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke7.Parent = ReturnYTitle

local FollowPlayerTitle = Instance.new("TextLabel")
FollowPlayerTitle.Name = "FollowPlayerTitle"
FollowPlayerTitle.Position = UDim2.new(0.275, 0, 0.03, 0)
FollowPlayerTitle.Size = UDim2.new(0.5, 0, 0.03, 0)
FollowPlayerTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
FollowPlayerTitle.BorderSizePixel = 0
FollowPlayerTitle.BorderColor3 = Color3.new(0, 0, 0)
FollowPlayerTitle.AnchorPoint = Vector2.new(0.5, 0.5)
FollowPlayerTitle.Text = "Follow player"
FollowPlayerTitle.TextColor3 = Color3.new(1, 1, 1)
FollowPlayerTitle.TextSize = 14
FollowPlayerTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
FollowPlayerTitle.TextScaled = true
FollowPlayerTitle.TextWrapped = true
FollowPlayerTitle.Parent = Combat

local UIStroke8 = Instance.new("UIStroke")
UIStroke8.Name = "UIStroke"
UIStroke8.Color = Color3.new(1, 1, 1)
UIStroke8.Thickness = 2
UIStroke8.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke8.Parent = FollowPlayerTitle

local FastAttackEnemyTitle = Instance.new("TextLabel")
FastAttackEnemyTitle.Name = "FastAttackEnemyTitle"
FastAttackEnemyTitle.Position = UDim2.new(0.225, 0, 0.13, 0)
FastAttackEnemyTitle.Size = UDim2.new(0.4, 0, 0.03, 0)
FastAttackEnemyTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
FastAttackEnemyTitle.BorderSizePixel = 0
FastAttackEnemyTitle.BorderColor3 = Color3.new(0, 0, 0)
FastAttackEnemyTitle.AnchorPoint = Vector2.new(0.5, 0.5)
FastAttackEnemyTitle.Text = "Fast attack enemy"
FastAttackEnemyTitle.TextColor3 = Color3.new(1, 1, 1)
FastAttackEnemyTitle.TextSize = 14
FastAttackEnemyTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
FastAttackEnemyTitle.TextScaled = true
FastAttackEnemyTitle.TextWrapped = true
FastAttackEnemyTitle.Parent = Combat

local UIStroke9 = Instance.new("UIStroke")
UIStroke9.Name = "UIStroke"
UIStroke9.Color = Color3.new(1, 1, 1)
UIStroke9.Thickness = 2
UIStroke9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke9.Parent = FastAttackEnemyTitle

local FastAttackPlayerTitle = Instance.new("TextLabel")
FastAttackPlayerTitle.Name = "FastAttackPlayerTitle"
FastAttackPlayerTitle.Position = UDim2.new(0.225, 0, 0.18, 0)
FastAttackPlayerTitle.Size = UDim2.new(0.4, 0, 0.03, 0)
FastAttackPlayerTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
FastAttackPlayerTitle.BorderSizePixel = 0
FastAttackPlayerTitle.BorderColor3 = Color3.new(0, 0, 0)
FastAttackPlayerTitle.AnchorPoint = Vector2.new(0.5, 0.5)
FastAttackPlayerTitle.Text = "Fast attack player"
FastAttackPlayerTitle.TextColor3 = Color3.new(1, 1, 1)
FastAttackPlayerTitle.TextSize = 14
FastAttackPlayerTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
FastAttackPlayerTitle.TextScaled = true
FastAttackPlayerTitle.TextWrapped = true
FastAttackPlayerTitle.Parent = Combat

local UIStroke10 = Instance.new("UIStroke")
UIStroke10.Name = "UIStroke"
UIStroke10.Color = Color3.new(1, 1, 1)
UIStroke10.Thickness = 2
UIStroke10.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke10.Parent = FastAttackPlayerTitle

local AutoEscapeTitle = Instance.new("TextLabel")
AutoEscapeTitle.Name = "AutoEscapeTitle"
AutoEscapeTitle.Position = UDim2.new(0.275, 0, 0.23, 0)
AutoEscapeTitle.Size = UDim2.new(0.5, 0, 0.03, 0)
AutoEscapeTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
AutoEscapeTitle.BorderSizePixel = 0
AutoEscapeTitle.BorderColor3 = Color3.new(0, 0, 0)
AutoEscapeTitle.AnchorPoint = Vector2.new(0.5, 0.5)
AutoEscapeTitle.Text = "Auto escape"
AutoEscapeTitle.TextColor3 = Color3.new(1, 1, 1)
AutoEscapeTitle.TextSize = 14
AutoEscapeTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoEscapeTitle.TextScaled = true
AutoEscapeTitle.TextWrapped = true
AutoEscapeTitle.Parent = Combat

local UIStroke11 = Instance.new("UIStroke")
UIStroke11.Name = "UIStroke"
UIStroke11.Color = Color3.new(1, 1, 1)
UIStroke11.Thickness = 2
UIStroke11.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke11.Parent = AutoEscapeTitle

local ModeFastAttackEnemyButton = Instance.new("TextButton")
ModeFastAttackEnemyButton.Name = "ModeFastAttackEnemyButton"
ModeFastAttackEnemyButton.Position = UDim2.new(0.674, 0, 0.13, 0)
ModeFastAttackEnemyButton.Size = UDim2.new(0.15, 0, 0.03, 0)
ModeFastAttackEnemyButton.BackgroundColor3 = Color3.new(1, 0.490196, 0)
ModeFastAttackEnemyButton.BackgroundTransparency = 0.75
ModeFastAttackEnemyButton.BorderSizePixel = 0
ModeFastAttackEnemyButton.BorderColor3 = Color3.new(0, 0, 0)
ModeFastAttackEnemyButton.AnchorPoint = Vector2.new(0.5, 0.5)
ModeFastAttackEnemyButton.Transparency = 0.75
ModeFastAttackEnemyButton.Text = "Mode: Toggle"
ModeFastAttackEnemyButton.TextColor3 = Color3.new(1, 1, 1)
ModeFastAttackEnemyButton.TextSize = 14
ModeFastAttackEnemyButton.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
ModeFastAttackEnemyButton.TextScaled = true
ModeFastAttackEnemyButton.TextWrapped = true
ModeFastAttackEnemyButton.Parent = Combat

local UIStroke12 = Instance.new("UIStroke")
UIStroke12.Name = "UIStroke"
UIStroke12.Color = Color3.new(1, 0.490196, 0)
UIStroke12.Thickness = 2
UIStroke12.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke12.Parent = ModeFastAttackEnemyButton

local ModeFastAttackPlayerButton = Instance.new("TextButton")
ModeFastAttackPlayerButton.Name = "ModeFastAttackPlayerButton"
ModeFastAttackPlayerButton.Position = UDim2.new(0.674, 0, 0.18, 0)
ModeFastAttackPlayerButton.Size = UDim2.new(0.15, 0, 0.03, 0)
ModeFastAttackPlayerButton.BackgroundColor3 = Color3.new(1, 0.490196, 0)
ModeFastAttackPlayerButton.BackgroundTransparency = 0.75
ModeFastAttackPlayerButton.BorderSizePixel = 0
ModeFastAttackPlayerButton.BorderColor3 = Color3.new(0, 0, 0)
ModeFastAttackPlayerButton.AnchorPoint = Vector2.new(0.5, 0.5)
ModeFastAttackPlayerButton.Transparency = 0.75
ModeFastAttackPlayerButton.Text = "Mode: Toggle"
ModeFastAttackPlayerButton.TextColor3 = Color3.new(1, 1, 1)
ModeFastAttackPlayerButton.TextSize = 14
ModeFastAttackPlayerButton.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
ModeFastAttackPlayerButton.TextScaled = true
ModeFastAttackPlayerButton.TextWrapped = true
ModeFastAttackPlayerButton.Parent = Combat

local UIStroke13 = Instance.new("UIStroke")
UIStroke13.Name = "UIStroke"
UIStroke13.Color = Color3.new(1, 0.490196, 0)
UIStroke13.Thickness = 2
UIStroke13.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke13.Parent = ModeFastAttackPlayerButton

local AutoEscapeBox = Instance.new("TextBox")
AutoEscapeBox.Name = "AutoEscapeBox"
AutoEscapeBox.Position = UDim2.new(0.645, 0, 0.23, 0)
AutoEscapeBox.Size = UDim2.new(0.2, 0, 0.03, 0)
AutoEscapeBox.BackgroundColor3 = Color3.new(0.439216, 0.654902, 1)
AutoEscapeBox.BackgroundTransparency = 0.75
AutoEscapeBox.BorderSizePixel = 0
AutoEscapeBox.BorderColor3 = Color3.new(0, 0, 0)
AutoEscapeBox.AnchorPoint = Vector2.new(0.5, 0.5)
AutoEscapeBox.Transparency = 0.75
AutoEscapeBox.Text = ""
AutoEscapeBox.TextColor3 = Color3.new(1, 1, 1)
AutoEscapeBox.TextSize = 14
AutoEscapeBox.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoEscapeBox.TextScaled = true
AutoEscapeBox.TextWrapped = true
AutoEscapeBox.PlaceholderText = "Health Rate (%)"
AutoEscapeBox.PlaceholderColor3 = Color3.new(1, 1, 1)
AutoEscapeBox.Parent = Combat

local UIStroke14 = Instance.new("UIStroke")
UIStroke14.Name = "UIStroke"
UIStroke14.Color = Color3.new(0.784314, 0.784314, 0.784314)
UIStroke14.Thickness = 2
UIStroke14.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke14.Parent = AutoEscapeBox

local FastAttackPlayerButton = Instance.new("TextButton")
FastAttackPlayerButton.Name = "FastAttackPlayerButton"
FastAttackPlayerButton.Position = UDim2.new(0.85, 0, 0.18, 0)
FastAttackPlayerButton.Size = UDim2.new(0.175, 0, 0.03, 0)
FastAttackPlayerButton.BackgroundColor3 = Color3.new(1, 0, 0)
FastAttackPlayerButton.BackgroundTransparency = 0.75
FastAttackPlayerButton.BorderSizePixel = 0
FastAttackPlayerButton.BorderColor3 = Color3.new(0, 0, 0)
FastAttackPlayerButton.AnchorPoint = Vector2.new(0.5, 0.5)
FastAttackPlayerButton.Transparency = 0.75
FastAttackPlayerButton.Text = ""
FastAttackPlayerButton.TextColor3 = Color3.new(0, 0, 0)
FastAttackPlayerButton.TextSize = 14
FastAttackPlayerButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
FastAttackPlayerButton.Parent = Combat

local UICorner7 = Instance.new("UICorner")
UICorner7.Name = "UICorner"
UICorner7.CornerRadius = UDim.new(1, 0)
UICorner7.Parent = FastAttackPlayerButton

local UIStroke15 = Instance.new("UIStroke")
UIStroke15.Name = "UIStroke"
UIStroke15.Color = Color3.new(1, 0, 0)
UIStroke15.Thickness = 2
UIStroke15.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke15.Parent = FastAttackPlayerButton

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
Dot4.Parent = FastAttackPlayerButton

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

local AutoEscapeButton = Instance.new("TextButton")
AutoEscapeButton.Name = "AutoEscapeButton"
AutoEscapeButton.Position = UDim2.new(0.85, 0, 0.23, 0)
AutoEscapeButton.Size = UDim2.new(0.175, 0, 0.03, 0)
AutoEscapeButton.BackgroundColor3 = Color3.new(1, 0, 0)
AutoEscapeButton.BackgroundTransparency = 0.75
AutoEscapeButton.BorderSizePixel = 0
AutoEscapeButton.BorderColor3 = Color3.new(0, 0, 0)
AutoEscapeButton.AnchorPoint = Vector2.new(0.5, 0.5)
AutoEscapeButton.Transparency = 0.75
AutoEscapeButton.Text = ""
AutoEscapeButton.TextColor3 = Color3.new(0, 0, 0)
AutoEscapeButton.TextSize = 14
AutoEscapeButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoEscapeButton.Parent = Combat

local UICorner9 = Instance.new("UICorner")
UICorner9.Name = "UICorner"
UICorner9.CornerRadius = UDim.new(1, 0)
UICorner9.Parent = AutoEscapeButton

local UIStroke16 = Instance.new("UIStroke")
UIStroke16.Name = "UIStroke"
UIStroke16.Color = Color3.new(1, 0, 0)
UIStroke16.Thickness = 2
UIStroke16.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke16.Parent = AutoEscapeButton

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
Dot5.Parent = AutoEscapeButton

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

local ReturnYButton = Instance.new("TextButton")
ReturnYButton.Name = "ReturnYButton"
ReturnYButton.Position = UDim2.new(0.85, 0, 0.28, 0)
ReturnYButton.Size = UDim2.new(0.2, 0, 0.03, 0)
ReturnYButton.BackgroundColor3 = Color3.new(1, 0, 0)
ReturnYButton.BackgroundTransparency = 0.75
ReturnYButton.BorderSizePixel = 0
ReturnYButton.BorderColor3 = Color3.new(0, 0, 0)
ReturnYButton.AnchorPoint = Vector2.new(0.5, 0.5)
ReturnYButton.Transparency = 0.75
ReturnYButton.Text = "Y=0"
ReturnYButton.TextColor3 = Color3.new(1, 1, 1)
ReturnYButton.TextSize = 14
ReturnYButton.FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
ReturnYButton.TextScaled = true
ReturnYButton.TextWrapped = true
ReturnYButton.Parent = Combat

local UIStroke17 = Instance.new("UIStroke")
UIStroke17.Name = "UIStroke"
UIStroke17.Color = Color3.new(1, 0, 0)
UIStroke17.Thickness = 2
UIStroke17.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke17.Parent = ReturnYButton

local StrokeFrame = Instance.new("Frame")
StrokeFrame.Name = "StrokeFrame"
StrokeFrame.Position = UDim2.new(0.485, 0, 0.055, 0)
StrokeFrame.Size = UDim2.new(0.95, 0, 0.09, 0)
StrokeFrame.BackgroundColor3 = Color3.new(1, 1, 1)
StrokeFrame.BackgroundTransparency = 1
StrokeFrame.BorderSizePixel = 0
StrokeFrame.BorderColor3 = Color3.new(0, 0, 0)
StrokeFrame.AnchorPoint = Vector2.new(0.5, 0.5)
StrokeFrame.Transparency = 1
StrokeFrame.Parent = Combat

local UIStroke18 = Instance.new("UIStroke")
UIStroke18.Name = "UIStroke"
UIStroke18.Color = Color3.new(0.8, 0, 1)
UIStroke18.Parent = StrokeFrame

local StrokeFrame2 = Instance.new("Frame")
StrokeFrame2.Name = "StrokeFrame"
StrokeFrame2.Position = UDim2.new(0.485, 0, 0.155, 0)
StrokeFrame2.Size = UDim2.new(0.95, 0, 0.09, 0)
StrokeFrame2.BackgroundColor3 = Color3.new(1, 1, 1)
StrokeFrame2.BackgroundTransparency = 1
StrokeFrame2.BorderSizePixel = 0
StrokeFrame2.BorderColor3 = Color3.new(0, 0, 0)
StrokeFrame2.AnchorPoint = Vector2.new(0.5, 0.5)
StrokeFrame2.Transparency = 1
StrokeFrame2.Parent = Combat

local UIStroke19 = Instance.new("UIStroke")
UIStroke19.Name = "UIStroke"
UIStroke19.Color = Color3.new(0.8, 0, 1)
UIStroke19.Parent = StrokeFrame2

local StrokeFrame3 = Instance.new("Frame")
StrokeFrame3.Name = "StrokeFrame"
StrokeFrame3.Position = UDim2.new(0.485, 0, 0.255, 0)
StrokeFrame3.Size = UDim2.new(0.95, 0, 0.09, 0)
StrokeFrame3.BackgroundColor3 = Color3.new(1, 1, 1)
StrokeFrame3.BackgroundTransparency = 1
StrokeFrame3.BorderSizePixel = 0
StrokeFrame3.BorderColor3 = Color3.new(0, 0, 0)
StrokeFrame3.AnchorPoint = Vector2.new(0.5, 0.5)
StrokeFrame3.Transparency = 1
StrokeFrame3.Parent = Combat

local UIStroke20 = Instance.new("UIStroke")
UIStroke20.Name = "UIStroke"
UIStroke20.Color = Color3.new(0.8, 0, 1)
UIStroke20.Parent = StrokeFrame3

local BGTPKeyAimButton = Instance.new("TextButton")
BGTPKeyAimButton.Name = "BGTPKeyAimButton"
BGTPKeyAimButton.Position = UDim2.new(0.512, 0, 0.38, 0)
BGTPKeyAimButton.Size = UDim2.new(0.15, 0, 0.03, 0)
BGTPKeyAimButton.BackgroundColor3 = Color3.new(0, 1, 0)
BGTPKeyAimButton.BackgroundTransparency = 0.75
BGTPKeyAimButton.BorderSizePixel = 0
BGTPKeyAimButton.BorderColor3 = Color3.new(0, 0, 0)
BGTPKeyAimButton.AnchorPoint = Vector2.new(0.5, 0.5)
BGTPKeyAimButton.Transparency = 0.75
BGTPKeyAimButton.Text = "Aim gui: ON"
BGTPKeyAimButton.TextColor3 = Color3.new(1, 1, 1)
BGTPKeyAimButton.TextSize = 14
BGTPKeyAimButton.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
BGTPKeyAimButton.TextScaled = true
BGTPKeyAimButton.TextWrapped = true
BGTPKeyAimButton.Parent = Combat

local UIStroke21 = Instance.new("UIStroke")
UIStroke21.Name = "UIStroke"
UIStroke21.Color = Color3.new(0, 1, 0)
UIStroke21.Thickness = 2
UIStroke21.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke21.Parent = BGTPKeyAimButton

local StyleFastAttackEnemyButton = Instance.new("TextButton")
StyleFastAttackEnemyButton.Name = "StyleFastAttackEnemyButton"
StyleFastAttackEnemyButton.Position = UDim2.new(0.512, 0, 0.13, 0)
StyleFastAttackEnemyButton.Size = UDim2.new(0.15, 0, 0.03, 0)
StyleFastAttackEnemyButton.BackgroundColor3 = Color3.new(0, 0.784314, 1)
StyleFastAttackEnemyButton.BackgroundTransparency = 0.75
StyleFastAttackEnemyButton.BorderSizePixel = 0
StyleFastAttackEnemyButton.BorderColor3 = Color3.new(0, 0, 0)
StyleFastAttackEnemyButton.AnchorPoint = Vector2.new(0.5, 0.5)
StyleFastAttackEnemyButton.Transparency = 0.75
StyleFastAttackEnemyButton.Text = "Style: melee"
StyleFastAttackEnemyButton.TextColor3 = Color3.new(1, 1, 1)
StyleFastAttackEnemyButton.TextSize = 14
StyleFastAttackEnemyButton.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
StyleFastAttackEnemyButton.TextScaled = true
StyleFastAttackEnemyButton.TextWrapped = true
StyleFastAttackEnemyButton.Parent = Combat

local UIStroke22 = Instance.new("UIStroke")
UIStroke22.Name = "UIStroke"
UIStroke22.Color = Color3.new(0, 0.784314, 1)
UIStroke22.Thickness = 2
UIStroke22.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke22.Parent = StyleFastAttackEnemyButton

local StrokeFrameSilentAim = Instance.new("Frame")
StrokeFrameSilentAim.Name = "StrokeFrameSilentAim"
StrokeFrameSilentAim.Position = UDim2.new(0.485, 0, 0.475, 0)
StrokeFrameSilentAim.Size = UDim2.new(0.95, 0, 0.1, 0)
StrokeFrameSilentAim.BackgroundColor3 = Color3.new(1, 1, 1)
StrokeFrameSilentAim.BackgroundTransparency = 1
StrokeFrameSilentAim.BorderSizePixel = 0
StrokeFrameSilentAim.BorderColor3 = Color3.new(0, 0, 0)
StrokeFrameSilentAim.AnchorPoint = Vector2.new(0.5, 0.5)
StrokeFrameSilentAim.Transparency = 1
StrokeFrameSilentAim.Parent = Combat

local UIStroke23 = Instance.new("UIStroke")
UIStroke23.Name = "UIStroke"
UIStroke23.Color = Color3.new(0.8, 0, 1)
UIStroke23.Parent = StrokeFrameSilentAim

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Position = UDim2.new(0.5, 0, -0.05, 0)
Title.Size = UDim2.new(0.25, 0, 0.15, 0)
Title.BackgroundColor3 = Color3.new(0.156863, 0, 0.235294)
Title.BorderSizePixel = 0
Title.BorderColor3 = Color3.new(0, 0, 0)
Title.AnchorPoint = Vector2.new(0.5, 0.5)
Title.Text = "Silent aim"
Title.TextColor3 = Color3.new(0.8, 0, 1)
Title.TextSize = 14
Title.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Title.TextScaled = true
Title.TextWrapped = true
Title.Parent = StrokeFrameSilentAim

local SilentAimButton = Instance.new("TextButton")
SilentAimButton.Name = "SilentAimButton"
SilentAimButton.Position = UDim2.new(0.85, 0, 0.45, 0)
SilentAimButton.Size = UDim2.new(0.175, 0, 0.03, 0)
SilentAimButton.BackgroundColor3 = Color3.new(1, 0, 0)
SilentAimButton.BackgroundTransparency = 0.75
SilentAimButton.BorderSizePixel = 0
SilentAimButton.BorderColor3 = Color3.new(0, 0, 0)
SilentAimButton.AnchorPoint = Vector2.new(0.5, 0.5)
SilentAimButton.Transparency = 0.75
SilentAimButton.Text = ""
SilentAimButton.TextColor3 = Color3.new(0, 0, 0)
SilentAimButton.TextSize = 14
SilentAimButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
SilentAimButton.Parent = Combat

local UICorner11 = Instance.new("UICorner")
UICorner11.Name = "UICorner"
UICorner11.CornerRadius = UDim.new(1, 0)
UICorner11.Parent = SilentAimButton

local UIStroke24 = Instance.new("UIStroke")
UIStroke24.Name = "UIStroke"
UIStroke24.Color = Color3.new(1, 0, 0)
UIStroke24.Thickness = 2
UIStroke24.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke24.Parent = SilentAimButton

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
Dot6.Parent = SilentAimButton

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

local SilentAimTitle = Instance.new("TextLabel")
SilentAimTitle.Name = "SilentAimTitle"
SilentAimTitle.Position = UDim2.new(0.375, 0, 0.45, 0)
SilentAimTitle.Size = UDim2.new(0.7, 0, 0.03, 0)
SilentAimTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
SilentAimTitle.BorderSizePixel = 0
SilentAimTitle.BorderColor3 = Color3.new(0, 0, 0)
SilentAimTitle.AnchorPoint = Vector2.new(0.5, 0.5)
SilentAimTitle.Text = "Silent aim"
SilentAimTitle.TextColor3 = Color3.new(1, 1, 1)
SilentAimTitle.TextSize = 14
SilentAimTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
SilentAimTitle.TextScaled = true
SilentAimTitle.TextWrapped = true
SilentAimTitle.Parent = Combat

local UIStroke25 = Instance.new("UIStroke")
UIStroke25.Name = "UIStroke"
UIStroke25.Color = Color3.new(1, 1, 1)
UIStroke25.Thickness = 2
UIStroke25.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke25.Parent = SilentAimTitle

local SilentAimModeTitle = Instance.new("TextLabel")
SilentAimModeTitle.Name = "SilentAimModeTitle"
SilentAimModeTitle.Position = UDim2.new(0.275, 0, 0.5, 0)
SilentAimModeTitle.Size = UDim2.new(0.5, 0, 0.03, 0)
SilentAimModeTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
SilentAimModeTitle.BorderSizePixel = 0
SilentAimModeTitle.BorderColor3 = Color3.new(0, 0, 0)
SilentAimModeTitle.ZIndex = 2
SilentAimModeTitle.AnchorPoint = Vector2.new(0.5, 0.5)
SilentAimModeTitle.Text = "Aim limit"
SilentAimModeTitle.TextColor3 = Color3.new(1, 1, 1)
SilentAimModeTitle.TextSize = 14
SilentAimModeTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
SilentAimModeTitle.TextScaled = true
SilentAimModeTitle.TextWrapped = true
SilentAimModeTitle.Parent = Combat

local UIStroke26 = Instance.new("UIStroke")
UIStroke26.Name = "UIStroke"
UIStroke26.Color = Color3.new(1, 1, 1)
UIStroke26.Thickness = 2
UIStroke26.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke26.Parent = SilentAimModeTitle

local n360ModeButton = Instance.new("TextButton")
n360ModeButton.Name = "360ModeButton"
n360ModeButton.Position = UDim2.new(0.85, 0, 0.5, 0)
n360ModeButton.Size = UDim2.new(0.2, 0, 0.03, 0)
n360ModeButton.BackgroundColor3 = Color3.new(0.564706, 0, 1)
n360ModeButton.BackgroundTransparency = 0.75
n360ModeButton.BorderSizePixel = 0
n360ModeButton.BorderColor3 = Color3.new(0, 0, 0)
n360ModeButton.AnchorPoint = Vector2.new(0.5, 0.5)
n360ModeButton.Transparency = 0.75
n360ModeButton.Text = "Mode:\nLimit"
n360ModeButton.TextColor3 = Color3.new(1, 1, 1)
n360ModeButton.TextSize = 14
n360ModeButton.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
n360ModeButton.TextScaled = true
n360ModeButton.TextWrapped = true
n360ModeButton.Parent = Combat

local UIStroke27 = Instance.new("UIStroke")
UIStroke27.Name = "UIStroke"
UIStroke27.Color = Color3.new(0.564706, 0, 1)
UIStroke27.Thickness = 2
UIStroke27.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke27.Parent = n360ModeButton

local SilentAimBox = Instance.new("TextBox")
SilentAimBox.Name = "SilentAimBox"
SilentAimBox.Position = UDim2.new(0.635, 0, 0.5, 0)
SilentAimBox.Size = UDim2.new(0.185, 0, 0.03, 0)
SilentAimBox.BackgroundColor3 = Color3.new(0.439216, 0.654902, 1)
SilentAimBox.BackgroundTransparency = 0.75
SilentAimBox.BorderSizePixel = 0
SilentAimBox.BorderColor3 = Color3.new(0, 0, 0)
SilentAimBox.AnchorPoint = Vector2.new(0.5, 0.5)
SilentAimBox.Transparency = 0.75
SilentAimBox.Text = ""
SilentAimBox.TextColor3 = Color3.new(1, 1, 1)
SilentAimBox.TextSize = 14
SilentAimBox.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
SilentAimBox.TextScaled = true
SilentAimBox.TextWrapped = true
SilentAimBox.PlaceholderText = "Radius"
SilentAimBox.PlaceholderColor3 = Color3.new(1, 1, 1)
SilentAimBox.Parent = Combat

local UIStroke28 = Instance.new("UIStroke")
UIStroke28.Name = "UIStroke"
UIStroke28.Color = Color3.new(0.784314, 0.784314, 0.784314)
UIStroke28.Thickness = 2
UIStroke28.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke28.Parent = SilentAimBox

local NotificationBlackTitle = Instance.new("TextLabel")
NotificationBlackTitle.Name = "NotificationBlackTitle"
NotificationBlackTitle.Position = UDim2.new(0.485, 0, 0.475, 0)
NotificationBlackTitle.Size = UDim2.new(0.95, 0, 0.095, 0)
NotificationBlackTitle.BackgroundColor3 = Color3.new(0, 0, 0)
NotificationBlackTitle.BackgroundTransparency = 0.05000000074505806
NotificationBlackTitle.BorderSizePixel = 0
NotificationBlackTitle.BorderColor3 = Color3.new(0, 0, 0)
NotificationBlackTitle.ZIndex = 3
NotificationBlackTitle.AnchorPoint = Vector2.new(0.5, 0.5)
NotificationBlackTitle.Transparency = 0.05000000074505806
NotificationBlackTitle.Text = "Exploid currently does not support this functionality; please use an exploid that does.\n\n(Examples: Bunni, Ronix, Delta, etc...)"
NotificationBlackTitle.TextColor3 = Color3.new(0.921569, 0, 0.392157)
NotificationBlackTitle.TextSize = 14
NotificationBlackTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
NotificationBlackTitle.TextScaled = true
NotificationBlackTitle.TextWrapped = true
NotificationBlackTitle.Parent = Combat

local StrokeFrame4 = Instance.new("Frame")
StrokeFrame4.Name = "StrokeFrame"
StrokeFrame4.Position = UDim2.new(0.485, 0, 0.355, 0)
StrokeFrame4.Size = UDim2.new(0.95, 0, 0.09, 0)
StrokeFrame4.BackgroundColor3 = Color3.new(1, 1, 1)
StrokeFrame4.BackgroundTransparency = 1
StrokeFrame4.BorderSizePixel = 0
StrokeFrame4.BorderColor3 = Color3.new(0, 0, 0)
StrokeFrame4.AnchorPoint = Vector2.new(0.5, 0.5)
StrokeFrame4.Transparency = 1
StrokeFrame4.Parent = Combat

local UIStroke29 = Instance.new("UIStroke")
UIStroke29.Name = "UIStroke"
UIStroke29.Color = Color3.new(0.8, 0, 1)
UIStroke29.Parent = StrokeFrame4

local TPKeyPCButton = Instance.new("TextButton")
TPKeyPCButton.Name = "TPKeyPCButton"
TPKeyPCButton.Position = UDim2.new(0.85, 0, 0.33, 0)
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
TPKeyPCButton.Parent = Combat

local UICorner13 = Instance.new("UICorner")
UICorner13.Name = "UICorner"
UICorner13.CornerRadius = UDim.new(1, 0)
UICorner13.Parent = TPKeyPCButton

local UIStroke30 = Instance.new("UIStroke")
UIStroke30.Name = "UIStroke"
UIStroke30.Color = Color3.new(1, 0, 0)
UIStroke30.Thickness = 2
UIStroke30.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke30.Parent = TPKeyPCButton

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
Dot7.Parent = TPKeyPCButton

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

local SelectTPKeyPCButton = Instance.new("TextButton")
SelectTPKeyPCButton.Name = "SelectTPKeyPCButton"
SelectTPKeyPCButton.Position = UDim2.new(0.645, 0, 0.33, 0)
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
SelectTPKeyPCButton.Parent = Combat

local UIStroke31 = Instance.new("UIStroke")
UIStroke31.Name = "UIStroke"
UIStroke31.Color = Color3.new(1, 0, 0)
UIStroke31.Thickness = 2
UIStroke31.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke31.Parent = SelectTPKeyPCButton

local TPKeyPCTitle = Instance.new("TextLabel")
TPKeyPCTitle.Name = "TPKeyPCTitle"
TPKeyPCTitle.Position = UDim2.new(0.275, 0, 0.33, 0)
TPKeyPCTitle.Size = UDim2.new(0.5, 0, 0.03, 0)
TPKeyPCTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
TPKeyPCTitle.BorderSizePixel = 0
TPKeyPCTitle.BorderColor3 = Color3.new(0, 0, 0)
TPKeyPCTitle.ZIndex = 2
TPKeyPCTitle.AnchorPoint = Vector2.new(0.5, 0.5)
TPKeyPCTitle.Text = "TP key"
TPKeyPCTitle.TextColor3 = Color3.new(1, 1, 1)
TPKeyPCTitle.TextSize = 14
TPKeyPCTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
TPKeyPCTitle.TextScaled = true
TPKeyPCTitle.TextWrapped = true
TPKeyPCTitle.Parent = Combat

local UIStroke32 = Instance.new("UIStroke")
UIStroke32.Name = "UIStroke"
UIStroke32.Color = Color3.new(1, 1, 1)
UIStroke32.Thickness = 2
UIStroke32.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke32.Parent = TPKeyPCTitle

local TPKeyAimPCButton = Instance.new("TextButton")
TPKeyAimPCButton.Name = "TPKeyAimPCButton"
TPKeyAimPCButton.Position = UDim2.new(0.85, 0, 0.38, 0)
TPKeyAimPCButton.Size = UDim2.new(0.175, 0, 0.03, 0)
TPKeyAimPCButton.BackgroundColor3 = Color3.new(1, 0, 0)
TPKeyAimPCButton.BackgroundTransparency = 0.75
TPKeyAimPCButton.BorderSizePixel = 0
TPKeyAimPCButton.BorderColor3 = Color3.new(0, 0, 0)
TPKeyAimPCButton.AnchorPoint = Vector2.new(0.5, 0.5)
TPKeyAimPCButton.Transparency = 0.75
TPKeyAimPCButton.Text = ""
TPKeyAimPCButton.TextColor3 = Color3.new(0, 0, 0)
TPKeyAimPCButton.TextSize = 14
TPKeyAimPCButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
TPKeyAimPCButton.Parent = Combat

local UICorner15 = Instance.new("UICorner")
UICorner15.Name = "UICorner"
UICorner15.CornerRadius = UDim.new(1, 0)
UICorner15.Parent = TPKeyAimPCButton

local UIStroke33 = Instance.new("UIStroke")
UIStroke33.Name = "UIStroke"
UIStroke33.Color = Color3.new(1, 0, 0)
UIStroke33.Thickness = 2
UIStroke33.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke33.Parent = TPKeyAimPCButton

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
Dot8.Parent = TPKeyAimPCButton

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

local TPKeyAimPCTitle = Instance.new("TextLabel")
TPKeyAimPCTitle.Name = "TPKeyAimPCTitle"
TPKeyAimPCTitle.Position = UDim2.new(0.225, 0, 0.38, 0)
TPKeyAimPCTitle.Size = UDim2.new(0.4, 0, 0.03, 0)
TPKeyAimPCTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
TPKeyAimPCTitle.BorderSizePixel = 0
TPKeyAimPCTitle.BorderColor3 = Color3.new(0, 0, 0)
TPKeyAimPCTitle.ZIndex = 2
TPKeyAimPCTitle.AnchorPoint = Vector2.new(0.5, 0.5)
TPKeyAimPCTitle.Text = "Aim TP key (Comming soon)"
TPKeyAimPCTitle.TextColor3 = Color3.new(1, 1, 1)
TPKeyAimPCTitle.TextSize = 14
TPKeyAimPCTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
TPKeyAimPCTitle.TextScaled = true
TPKeyAimPCTitle.TextWrapped = true
TPKeyAimPCTitle.Parent = Combat

local UIStroke34 = Instance.new("UIStroke")
UIStroke34.Name = "UIStroke"
UIStroke34.Color = Color3.new(1, 1, 1)
UIStroke34.Thickness = 2
UIStroke34.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke34.Parent = TPKeyAimPCTitle

local StyleFastAttackPlayerButton = Instance.new("TextButton")
StyleFastAttackPlayerButton.Name = "StyleFastAttackPlayerButton"
StyleFastAttackPlayerButton.Position = UDim2.new(0.512, 0, 0.18, 0)
StyleFastAttackPlayerButton.Size = UDim2.new(0.15, 0, 0.03, 0)
StyleFastAttackPlayerButton.BackgroundColor3 = Color3.new(0, 0.784314, 1)
StyleFastAttackPlayerButton.BackgroundTransparency = 0.75
StyleFastAttackPlayerButton.BorderSizePixel = 0
StyleFastAttackPlayerButton.BorderColor3 = Color3.new(0, 0, 0)
StyleFastAttackPlayerButton.AnchorPoint = Vector2.new(0.5, 0.5)
StyleFastAttackPlayerButton.Transparency = 0.75
StyleFastAttackPlayerButton.Text = "Style: melee"
StyleFastAttackPlayerButton.TextColor3 = Color3.new(1, 1, 1)
StyleFastAttackPlayerButton.TextSize = 14
StyleFastAttackPlayerButton.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
StyleFastAttackPlayerButton.TextScaled = true
StyleFastAttackPlayerButton.TextWrapped = true
StyleFastAttackPlayerButton.Parent = Combat

local UIStroke35 = Instance.new("UIStroke")
UIStroke35.Name = "UIStroke"
UIStroke35.Color = Color3.new(0, 0.784314, 1)
UIStroke35.Thickness = 2
UIStroke35.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke35.Parent = StyleFastAttackPlayerButton

local SelectTPKeyAimPCButton = Instance.new("TextButton")
SelectTPKeyAimPCButton.Name = "SelectTPKeyAimPCButton"
SelectTPKeyAimPCButton.Position = UDim2.new(0.674, 0, 0.38, 0)
SelectTPKeyAimPCButton.Size = UDim2.new(0.15, 0, 0.03, 0)
SelectTPKeyAimPCButton.BackgroundColor3 = Color3.new(1, 0, 0)
SelectTPKeyAimPCButton.BackgroundTransparency = 0.75
SelectTPKeyAimPCButton.BorderSizePixel = 0
SelectTPKeyAimPCButton.BorderColor3 = Color3.new(0, 0, 0)
SelectTPKeyAimPCButton.AnchorPoint = Vector2.new(0.5, 0.5)
SelectTPKeyAimPCButton.Transparency = 0.75
SelectTPKeyAimPCButton.Text = "None"
SelectTPKeyAimPCButton.TextColor3 = Color3.new(1, 1, 1)
SelectTPKeyAimPCButton.TextSize = 14
SelectTPKeyAimPCButton.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
SelectTPKeyAimPCButton.TextScaled = true
SelectTPKeyAimPCButton.TextWrapped = true
SelectTPKeyAimPCButton.Parent = Combat

local UIStroke36 = Instance.new("UIStroke")
UIStroke36.Name = "UIStroke"
UIStroke36.Color = Color3.new(1, 0, 0)
UIStroke36.Thickness = 2
UIStroke36.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke36.Parent = SelectTPKeyAimPCButton

local Frame = Combat
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
