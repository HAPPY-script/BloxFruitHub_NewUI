local ScrollingTab = game.Players.LocalPlayer.PlayerGui:WaitForChild("BloxFruitHubGui"):WaitForChild("Main"):WaitForChild("ScrollingTab")

local Raid = Instance.new("Frame")
Raid.Name = "Raid"
Raid.Size = UDim2.new(1, 0, 1, 0)
Raid.BackgroundColor3 = Color3.new(1, 0.352941, 0.784314)
Raid.BackgroundTransparency = 1
Raid.BorderSizePixel = 0
Raid.BorderColor3 = Color3.new(0, 0, 0)
Raid.Transparency = 1
Raid.Parent = ScrollingTab

local AutoDungeonButton = Instance.new("TextButton")
AutoDungeonButton.Name = "AutoDungeonButton"
AutoDungeonButton.Position = UDim2.new(0.85, 0, 0.13, 0)
AutoDungeonButton.Size = UDim2.new(0.175, 0, 0.03, 0)
AutoDungeonButton.BackgroundColor3 = Color3.new(1, 0, 0)
AutoDungeonButton.BackgroundTransparency = 0.75
AutoDungeonButton.BorderSizePixel = 0
AutoDungeonButton.BorderColor3 = Color3.new(0, 0, 0)
AutoDungeonButton.AnchorPoint = Vector2.new(0.5, 0.5)
AutoDungeonButton.Transparency = 0.75
AutoDungeonButton.Text = ""
AutoDungeonButton.TextColor3 = Color3.new(0, 0, 0)
AutoDungeonButton.TextSize = 14
AutoDungeonButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoDungeonButton.Parent = Raid

local UICorner = Instance.new("UICorner")
UICorner.Name = "UICorner"
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = AutoDungeonButton

local UIStroke = Instance.new("UIStroke")
UIStroke.Name = "UIStroke"
UIStroke.Color = Color3.new(1, 0, 0)
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = AutoDungeonButton

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
Dot.Parent = AutoDungeonButton

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

local AutoSelectBuffButton = Instance.new("TextButton")
AutoSelectBuffButton.Name = "AutoSelectBuffButton"
AutoSelectBuffButton.Position = UDim2.new(0.85, 0, 0.18, 0)
AutoSelectBuffButton.Size = UDim2.new(0.175, 0, 0.03, 0)
AutoSelectBuffButton.BackgroundColor3 = Color3.new(1, 0, 0)
AutoSelectBuffButton.BackgroundTransparency = 0.75
AutoSelectBuffButton.BorderSizePixel = 0
AutoSelectBuffButton.BorderColor3 = Color3.new(0, 0, 0)
AutoSelectBuffButton.AnchorPoint = Vector2.new(0.5, 0.5)
AutoSelectBuffButton.Transparency = 0.75
AutoSelectBuffButton.Text = ""
AutoSelectBuffButton.TextColor3 = Color3.new(0, 0, 0)
AutoSelectBuffButton.TextSize = 14
AutoSelectBuffButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoSelectBuffButton.Parent = Raid

local UICorner3 = Instance.new("UICorner")
UICorner3.Name = "UICorner"
UICorner3.CornerRadius = UDim.new(1, 0)
UICorner3.Parent = AutoSelectBuffButton

local UIStroke2 = Instance.new("UIStroke")
UIStroke2.Name = "UIStroke"
UIStroke2.Color = Color3.new(1, 0, 0)
UIStroke2.Thickness = 2
UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke2.Parent = AutoSelectBuffButton

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
Dot2.Parent = AutoSelectBuffButton

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

local AutoRaidButton = Instance.new("TextButton")
AutoRaidButton.Name = "AutoRaidButton"
AutoRaidButton.Position = UDim2.new(0.85, 0, 0.03, 0)
AutoRaidButton.Size = UDim2.new(0.175, 0, 0.03, 0)
AutoRaidButton.BackgroundColor3 = Color3.new(1, 0, 0)
AutoRaidButton.BackgroundTransparency = 0.75
AutoRaidButton.BorderSizePixel = 0
AutoRaidButton.BorderColor3 = Color3.new(0, 0, 0)
AutoRaidButton.AnchorPoint = Vector2.new(0.5, 0.5)
AutoRaidButton.Transparency = 0.75
AutoRaidButton.Text = ""
AutoRaidButton.TextColor3 = Color3.new(0, 0, 0)
AutoRaidButton.TextSize = 14
AutoRaidButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoRaidButton.Parent = Raid

local UICorner5 = Instance.new("UICorner")
UICorner5.Name = "UICorner"
UICorner5.CornerRadius = UDim.new(1, 0)
UICorner5.Parent = AutoRaidButton

local UIStroke3 = Instance.new("UIStroke")
UIStroke3.Name = "UIStroke"
UIStroke3.Color = Color3.new(1, 0, 0)
UIStroke3.Thickness = 2
UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke3.Parent = AutoRaidButton

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
Dot3.Parent = AutoRaidButton

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

local AutoSelectBuffTitle = Instance.new("TextLabel")
AutoSelectBuffTitle.Name = "AutoSelectBuffTitle"
AutoSelectBuffTitle.Position = UDim2.new(0.275, 0, 0.18, 0)
AutoSelectBuffTitle.Size = UDim2.new(0.5, 0, 0.03, 0)
AutoSelectBuffTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
AutoSelectBuffTitle.BorderSizePixel = 0
AutoSelectBuffTitle.BorderColor3 = Color3.new(0, 0, 0)
AutoSelectBuffTitle.AnchorPoint = Vector2.new(0.5, 0.5)
AutoSelectBuffTitle.Text = "Auto buff selection"
AutoSelectBuffTitle.TextColor3 = Color3.new(1, 1, 1)
AutoSelectBuffTitle.TextSize = 14
AutoSelectBuffTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoSelectBuffTitle.TextScaled = true
AutoSelectBuffTitle.TextWrapped = true
AutoSelectBuffTitle.Parent = Raid

local UIStroke4 = Instance.new("UIStroke")
UIStroke4.Name = "UIStroke"
UIStroke4.Color = Color3.new(1, 1, 1)
UIStroke4.Thickness = 2
UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke4.Parent = AutoSelectBuffTitle

local AutoRaidTitle = Instance.new("TextLabel")
AutoRaidTitle.Name = "AutoRaidTitle"
AutoRaidTitle.Position = UDim2.new(0.375, 0, 0.03, 0)
AutoRaidTitle.Size = UDim2.new(0.7, 0, 0.03, 0)
AutoRaidTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
AutoRaidTitle.BorderSizePixel = 0
AutoRaidTitle.BorderColor3 = Color3.new(0, 0, 0)
AutoRaidTitle.AnchorPoint = Vector2.new(0.5, 0.5)
AutoRaidTitle.Text = "Auto raid"
AutoRaidTitle.TextColor3 = Color3.new(1, 1, 1)
AutoRaidTitle.TextSize = 14
AutoRaidTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoRaidTitle.TextScaled = true
AutoRaidTitle.TextWrapped = true
AutoRaidTitle.Parent = Raid

local UIStroke5 = Instance.new("UIStroke")
UIStroke5.Name = "UIStroke"
UIStroke5.Color = Color3.new(1, 1, 1)
UIStroke5.Thickness = 2
UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke5.Parent = AutoRaidTitle

local AutoDungeonTitle = Instance.new("TextLabel")
AutoDungeonTitle.Name = "AutoDungeonTitle"
AutoDungeonTitle.Position = UDim2.new(0.375, 0, 0.13, 0)
AutoDungeonTitle.Size = UDim2.new(0.7, 0, 0.03, 0)
AutoDungeonTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
AutoDungeonTitle.BorderSizePixel = 0
AutoDungeonTitle.BorderColor3 = Color3.new(0, 0, 0)
AutoDungeonTitle.AnchorPoint = Vector2.new(0.5, 0.5)
AutoDungeonTitle.Text = "Auto dungeon"
AutoDungeonTitle.TextColor3 = Color3.new(1, 1, 1)
AutoDungeonTitle.TextSize = 14
AutoDungeonTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoDungeonTitle.TextScaled = true
AutoDungeonTitle.TextWrapped = true
AutoDungeonTitle.Parent = Raid

local UIStroke6 = Instance.new("UIStroke")
UIStroke6.Name = "UIStroke"
UIStroke6.Color = Color3.new(1, 1, 1)
UIStroke6.Thickness = 2
UIStroke6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke6.Parent = AutoDungeonTitle

local SelectMicrochipButton = Instance.new("TextButton")
SelectMicrochipButton.Name = "SelectMicrochipButton"
SelectMicrochipButton.Position = UDim2.new(0.375, 0, 0.08, 0)
SelectMicrochipButton.Size = UDim2.new(0.7, 0, 0.03, 0)
SelectMicrochipButton.BackgroundColor3 = Color3.new(0, 0.588235, 0.392157)
SelectMicrochipButton.BorderSizePixel = 0
SelectMicrochipButton.BorderColor3 = Color3.new(0, 0, 0)
SelectMicrochipButton.AnchorPoint = Vector2.new(0.5, 0.5)
SelectMicrochipButton.Text = "Select Microchip"
SelectMicrochipButton.TextColor3 = Color3.new(1, 1, 1)
SelectMicrochipButton.TextSize = 14
SelectMicrochipButton.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
SelectMicrochipButton.TextScaled = true
SelectMicrochipButton.TextWrapped = true
SelectMicrochipButton.Parent = Raid

local UIStroke7 = Instance.new("UIStroke")
UIStroke7.Name = "UIStroke"
UIStroke7.Color = Color3.new(1, 1, 1)
UIStroke7.Thickness = 2
UIStroke7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke7.Parent = SelectMicrochipButton

local List = Instance.new("Frame")
List.Name = "List"
List.Position = UDim2.new(0.5, 0, 3.55, 0)
List.Size = UDim2.new(1, 0, 5, 0)
List.BackgroundColor3 = Color3.new(0.156863, 0.117647, 0.235294)
List.BorderSizePixel = 0
List.BorderColor3 = Color3.new(0, 0, 0)
List.Visible = false
List.ZIndex = 2
List.AnchorPoint = Vector2.new(0.5, 0.5)
List.Parent = SelectMicrochipButton

local UIStroke8 = Instance.new("UIStroke")
UIStroke8.Name = "UIStroke"
UIStroke8.Color = Color3.new(1, 1, 1)
UIStroke8.Thickness = 2
UIStroke8.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke8.Parent = List

local Flame = Instance.new("ImageButton")
Flame.Name = "Flame"
Flame.Position = UDim2.new(0.1, 0, 0.283333, 0)
Flame.Size = UDim2.new(0.3, 0, 0.3, 0)
Flame.BackgroundColor3 = Color3.new(1, 0.533333, 0)
Flame.BackgroundTransparency = 0.25
Flame.BorderSizePixel = 0
Flame.BorderColor3 = Color3.new(0, 0, 0)
Flame.AnchorPoint = Vector2.new(0.5, 0.5)
Flame.Transparency = 0.25
Flame.Image = "rbxassetid://83606673490838"
Flame.Parent = List

local UIAspectRatioConstraint4 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint4.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint4.Parent = Flame

local Ice = Instance.new("ImageButton")
Ice.Name = "Ice"
Ice.Position = UDim2.new(0.3, 0, 0.283333, 0)
Ice.Size = UDim2.new(0.3, 0, 0.3, 0)
Ice.BackgroundColor3 = Color3.new(0, 0.835294, 1)
Ice.BackgroundTransparency = 0.5
Ice.BorderSizePixel = 0
Ice.BorderColor3 = Color3.new(0, 0, 0)
Ice.AnchorPoint = Vector2.new(0.5, 0.5)
Ice.Transparency = 0.5
Ice.Image = "rbxassetid://90577817008874"
Ice.Parent = List

local UIAspectRatioConstraint5 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint5.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint5.Parent = Ice

local Quake = Instance.new("ImageButton")
Quake.Name = "Quake"
Quake.Position = UDim2.new(0.5, 0, 0.283333, 0)
Quake.Size = UDim2.new(0.3, 0, 0.3, 0)
Quake.BackgroundColor3 = Color3.new(0.509804, 0.827451, 1)
Quake.BackgroundTransparency = 0.5
Quake.BorderSizePixel = 0
Quake.BorderColor3 = Color3.new(0, 0, 0)
Quake.AnchorPoint = Vector2.new(0.5, 0.5)
Quake.Transparency = 0.5
Quake.Image = "rbxassetid://128713873593766"
Quake.Parent = List

local UIAspectRatioConstraint6 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint6.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint6.Parent = Quake

local Light = Instance.new("ImageButton")
Light.Name = "Light"
Light.Position = UDim2.new(0.7, 0, 0.283333, 0)
Light.Size = UDim2.new(0.3, 0, 0.3, 0)
Light.BackgroundColor3 = Color3.new(1, 1, 0)
Light.BackgroundTransparency = 0.5
Light.BorderSizePixel = 0
Light.BorderColor3 = Color3.new(0, 0, 0)
Light.AnchorPoint = Vector2.new(0.5, 0.5)
Light.Transparency = 0.5
Light.Image = "rbxassetid://73704541425274"
Light.Parent = List

local UIAspectRatioConstraint7 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint7.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint7.Parent = Light

local Dark = Instance.new("ImageButton")
Dark.Name = "Dark"
Dark.Position = UDim2.new(0.9, 0, 0.283333, 0)
Dark.Size = UDim2.new(0.3, 0, 0.3, 0)
Dark.BackgroundColor3 = Color3.new(0, 0, 0)
Dark.BackgroundTransparency = 0.5
Dark.BorderSizePixel = 0
Dark.BorderColor3 = Color3.new(0, 0, 0)
Dark.AnchorPoint = Vector2.new(0.5, 0.5)
Dark.Transparency = 0.5
Dark.Image = "rbxassetid://117271537040521"
Dark.Parent = List

local UIAspectRatioConstraint8 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint8.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint8.Parent = Dark

local Spider = Instance.new("ImageButton")
Spider.Name = "Spider"
Spider.Position = UDim2.new(0.1, 0, 0.705556, 0)
Spider.Size = UDim2.new(0.3, 0, 0.3, 0)
Spider.BackgroundColor3 = Color3.new(1, 0.827451, 0.996078)
Spider.BackgroundTransparency = 0.5
Spider.BorderSizePixel = 0
Spider.BorderColor3 = Color3.new(0, 0, 0)
Spider.AnchorPoint = Vector2.new(0.5, 0.5)
Spider.Transparency = 0.5
Spider.Image = "rbxassetid://108067842924565"
Spider.Parent = List

local UIAspectRatioConstraint9 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint9.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint9.Parent = Spider

local Rumble = Instance.new("ImageButton")
Rumble.Name = "Rumble"
Rumble.Position = UDim2.new(0.3, 0, 0.705556, 0)
Rumble.Size = UDim2.new(0.3, 0, 0.3, 0)
Rumble.BackgroundColor3 = Color3.new(0.14902, 0.235294, 1)
Rumble.BackgroundTransparency = 0.5
Rumble.BorderSizePixel = 0
Rumble.BorderColor3 = Color3.new(0, 0, 0)
Rumble.AnchorPoint = Vector2.new(0.5, 0.5)
Rumble.Transparency = 0.5
Rumble.Image = "rbxassetid://98986450435429"
Rumble.Parent = List

local UIAspectRatioConstraint10 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint10.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint10.Parent = Rumble

local Magma = Instance.new("ImageButton")
Magma.Name = "Magma"
Magma.Position = UDim2.new(0.5, 0, 0.705556, 0)
Magma.Size = UDim2.new(0.3, 0, 0.3, 0)
Magma.BackgroundColor3 = Color3.new(1, 0.117647, 0)
Magma.BackgroundTransparency = 0.5
Magma.BorderSizePixel = 0
Magma.BorderColor3 = Color3.new(0, 0, 0)
Magma.AnchorPoint = Vector2.new(0.5, 0.5)
Magma.Transparency = 0.5
Magma.Image = "rbxassetid://74588868666774"
Magma.Parent = List

local UIAspectRatioConstraint11 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint11.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint11.Parent = Magma

local Buddha = Instance.new("ImageButton")
Buddha.Name = "Buddha"
Buddha.Position = UDim2.new(0.7, 0, 0.705556, 0)
Buddha.Size = UDim2.new(0.3, 0, 0.3, 0)
Buddha.BackgroundColor3 = Color3.new(1, 0.87451, 0.380392)
Buddha.BackgroundTransparency = 0.5
Buddha.BorderSizePixel = 0
Buddha.BorderColor3 = Color3.new(0, 0, 0)
Buddha.AnchorPoint = Vector2.new(0.5, 0.5)
Buddha.Transparency = 0.5
Buddha.Image = "rbxassetid://108295975683608"
Buddha.Parent = List

local UIAspectRatioConstraint12 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint12.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint12.Parent = Buddha

local Sand = Instance.new("ImageButton")
Sand.Name = "Sand"
Sand.Position = UDim2.new(0.9, 0, 0.705556, 0)
Sand.Size = UDim2.new(0.3, 0, 0.3, 0)
Sand.BackgroundColor3 = Color3.new(1, 0.988235, 0.654902)
Sand.BackgroundTransparency = 0.5
Sand.BorderSizePixel = 0
Sand.BorderColor3 = Color3.new(0, 0, 0)
Sand.AnchorPoint = Vector2.new(0.5, 0.5)
Sand.Transparency = 0.5
Sand.Image = "rbxassetid://129588398606310"
Sand.Parent = List

local UIAspectRatioConstraint13 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint13.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint13.Parent = Sand

local BuyMicrochipButton = Instance.new("TextButton")
BuyMicrochipButton.Name = "BuyMicrochipButton"
BuyMicrochipButton.Position = UDim2.new(0.85, 0, 0.08, 0)
BuyMicrochipButton.Size = UDim2.new(0.2, 0, 0.03, 0)
BuyMicrochipButton.BackgroundColor3 = Color3.new(1, 0, 0)
BuyMicrochipButton.BackgroundTransparency = 0.75
BuyMicrochipButton.BorderSizePixel = 0
BuyMicrochipButton.BorderColor3 = Color3.new(0, 0, 0)
BuyMicrochipButton.AnchorPoint = Vector2.new(0.5, 0.5)
BuyMicrochipButton.Transparency = 0.75
BuyMicrochipButton.Text = "Buy"
BuyMicrochipButton.TextColor3 = Color3.new(1, 1, 1)
BuyMicrochipButton.TextSize = 14
BuyMicrochipButton.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
BuyMicrochipButton.TextScaled = true
BuyMicrochipButton.TextWrapped = true
BuyMicrochipButton.Parent = Raid

local UIStroke9 = Instance.new("UIStroke")
UIStroke9.Name = "UIStroke"
UIStroke9.Color = Color3.new(1, 0, 0)
UIStroke9.Thickness = 2
UIStroke9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke9.Parent = BuyMicrochipButton

local SettingAutoBuffButton = Instance.new("TextButton")
SettingAutoBuffButton.Name = "SettingAutoBuffButton"
SettingAutoBuffButton.Position = UDim2.new(0.645, 0, 0.18, 0)
SettingAutoBuffButton.Size = UDim2.new(0.2, 0, 0.03, 0)
SettingAutoBuffButton.BackgroundColor3 = Color3.new(1, 1, 0)
SettingAutoBuffButton.BackgroundTransparency = 0.75
SettingAutoBuffButton.BorderSizePixel = 0
SettingAutoBuffButton.BorderColor3 = Color3.new(0, 0, 0)
SettingAutoBuffButton.AnchorPoint = Vector2.new(0.5, 0.5)
SettingAutoBuffButton.Transparency = 0.75
SettingAutoBuffButton.Text = "Setting"
SettingAutoBuffButton.TextColor3 = Color3.new(1, 1, 1)
SettingAutoBuffButton.TextSize = 14
SettingAutoBuffButton.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
SettingAutoBuffButton.TextScaled = true
SettingAutoBuffButton.TextWrapped = true
SettingAutoBuffButton.Parent = Raid

local UIStroke10 = Instance.new("UIStroke")
UIStroke10.Name = "UIStroke"
UIStroke10.Color = Color3.new(1, 1, 0)
UIStroke10.Thickness = 2
UIStroke10.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke10.Parent = SettingAutoBuffButton

local Frame = Raid
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
