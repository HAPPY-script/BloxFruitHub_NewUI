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
AimbotTitle.Text = "Aimbot player"
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
FastAttackEnemyTitle.Position = UDim2.new(0.275, 0, 0.13, 0)
FastAttackEnemyTitle.Size = UDim2.new(0.5, 0, 0.03, 0)
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
FastAttackPlayerTitle.Position = UDim2.new(0.275, 0, 0.18, 0)
FastAttackPlayerTitle.Size = UDim2.new(0.5, 0, 0.03, 0)
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
ModeFastAttackEnemyButton.Position = UDim2.new(0.645, 0, 0.13, 0)
ModeFastAttackEnemyButton.Size = UDim2.new(0.2, 0, 0.03, 0)
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
ModeFastAttackPlayerButton.Position = UDim2.new(0.645, 0, 0.18, 0)
ModeFastAttackPlayerButton.Size = UDim2.new(0.2, 0, 0.03, 0)
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

local Frame = Combat
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
