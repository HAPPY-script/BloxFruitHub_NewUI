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

--=== MOON ========================================================================================================================================

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

--=== COUNT PLAYER ========================================================================================================================================
