local ScrollingTab = game.Players.LocalPlayer.PlayerGui:WaitForChild("BloxFruitHubGui"):WaitForChild("Main"):WaitForChild("ScrollingTab")

local Order = Instance.new("Frame")
Order.Name = "Order"
Order.Size = UDim2.new(1, 0, 1, 0)
Order.BackgroundColor3 = Color3.new(1, 0.862745, 0)
Order.BackgroundTransparency = 1
Order.BorderSizePixel = 0
Order.BorderColor3 = Color3.new(0, 0, 0)
Order.Transparency = 1
Order.Parent = ScrollingTab

local GhoulRace = Instance.new("ImageButton")
GhoulRace.Name = "GhoulRace"
GhoulRace.Position = UDim2.new(0.05, 0, 0.01, 0)
GhoulRace.Size = UDim2.new(0.25, 0, 0.25, 0)
GhoulRace.BackgroundColor3 = Color3.new(1, 1, 1)
GhoulRace.BackgroundTransparency = 1
GhoulRace.BorderSizePixel = 0
GhoulRace.BorderColor3 = Color3.new(0, 0, 0)
GhoulRace.Transparency = 1
GhoulRace.Image = "rbxassetid://106638145137120"
GhoulRace.Parent = Order

local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint.Parent = GhoulRace

local TextLabel = Instance.new("TextLabel")
TextLabel.Name = "TextLabel"
TextLabel.Position = UDim2.new(0.5, 0, 0.85, 0)
TextLabel.Size = UDim2.new(1, 0, 0.25, 0)
TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel.BackgroundTransparency = 1
TextLabel.BorderSizePixel = 0
TextLabel.BorderColor3 = Color3.new(0, 0, 0)
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.Transparency = 1
TextLabel.Text = "Buy"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.TextSize = 14
TextLabel.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
TextLabel.TextScaled = true
TextLabel.TextWrapped = true
TextLabel.Parent = GhoulRace

local UIGradient = Instance.new("UIGradient")
UIGradient.Name = "UIGradient"
UIGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1, 0), NumberSequenceKeypoint.new(1, 0, 0)})
UIGradient.Rotation = -90
UIGradient.Offset = Vector2.new(0, -0.15)
UIGradient.Parent = GhoulRace

local CyborgRace = Instance.new("ImageButton")
CyborgRace.Name = "CyborgRace"
CyborgRace.Position = UDim2.new(0.315, 0, 0.01, 0)
CyborgRace.Size = UDim2.new(0.25, 0, 0.25, 0)
CyborgRace.BackgroundColor3 = Color3.new(1, 1, 1)
CyborgRace.BackgroundTransparency = 1
CyborgRace.BorderSizePixel = 0
CyborgRace.BorderColor3 = Color3.new(0, 0, 0)
CyborgRace.Transparency = 1
CyborgRace.Image = "rbxassetid://94784097982936"
CyborgRace.Parent = Order

local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint2.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint2.Parent = CyborgRace

local TextLabel2 = Instance.new("TextLabel")
TextLabel2.Name = "TextLabel"
TextLabel2.Position = UDim2.new(0.5, 0, 0.85, 0)
TextLabel2.Size = UDim2.new(1, 0, 0.25, 0)
TextLabel2.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel2.BackgroundTransparency = 1
TextLabel2.BorderSizePixel = 0
TextLabel2.BorderColor3 = Color3.new(0, 0, 0)
TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel2.Transparency = 1
TextLabel2.Text = "Buy"
TextLabel2.TextColor3 = Color3.new(1, 1, 1)
TextLabel2.TextSize = 14
TextLabel2.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
TextLabel2.TextScaled = true
TextLabel2.TextWrapped = true
TextLabel2.Parent = CyborgRace

local UIGradient2 = Instance.new("UIGradient")
UIGradient2.Name = "UIGradient"
UIGradient2.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1, 0), NumberSequenceKeypoint.new(1, 0, 0)})
UIGradient2.Rotation = -90
UIGradient2.Offset = Vector2.new(0, -0.15)
UIGradient2.Parent = CyborgRace

local RandomRaceFrame = Instance.new("Frame")
RandomRaceFrame.Name = "RandomRaceFrame"
RandomRaceFrame.Position = UDim2.new(0.575, 0, 0.015, 0)
RandomRaceFrame.Size = UDim2.new(0.4, 0, 0.4, 0)
RandomRaceFrame.BackgroundColor3 = Color3.new(1, 1, 1)
RandomRaceFrame.BackgroundTransparency = 1
RandomRaceFrame.BorderSizePixel = 0
RandomRaceFrame.BorderColor3 = Color3.new(0, 0, 0)
RandomRaceFrame.Transparency = 1
RandomRaceFrame.Parent = Order

local UIAspectRatioConstraint3 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint3.Name = "UIAspectRatioConstraint"
UIAspectRatioConstraint3.AspectRatio = 2
UIAspectRatioConstraint3.Parent = RandomRaceFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Name = "UIStroke"
UIStroke.Color = Color3.new(0.784314, 0, 1)
UIStroke.Thickness = 1.5
UIStroke.Parent = RandomRaceFrame

local Human = Instance.new("ImageLabel")
Human.Name = "Human"
Human.Position = UDim2.new(0.5, 0, 0.5, 0)
Human.Size = UDim2.new(0.8, 0, 0.8, 0)
Human.BackgroundColor3 = Color3.new(1, 1, 1)
Human.BackgroundTransparency = 1
Human.BorderSizePixel = 0
Human.BorderColor3 = Color3.new(0, 0, 0)
Human.ZIndex = 3
Human.AnchorPoint = Vector2.new(0.5, 0.5)
Human.Transparency = 1
Human.Image = "rbxassetid://116968283113252"
Human.Parent = RandomRaceFrame

local UIAspectRatioConstraint4 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint4.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint4.Parent = Human

local Shark = Instance.new("ImageLabel")
Shark.Name = "Shark"
Shark.Position = UDim2.new(0.15, 0, 0.7, 0)
Shark.Size = UDim2.new(0.5, 0, 0.5, 0)
Shark.BackgroundColor3 = Color3.new(1, 1, 1)
Shark.BackgroundTransparency = 1
Shark.BorderSizePixel = 0
Shark.BorderColor3 = Color3.new(0, 0, 0)
Shark.ZIndex = 4
Shark.AnchorPoint = Vector2.new(0.5, 0.5)
Shark.Transparency = 1
Shark.Image = "rbxassetid://85063098470655"
Shark.ImageTransparency = 0.5
Shark.Parent = RandomRaceFrame

local UIAspectRatioConstraint5 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint5.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint5.Parent = Shark

local Rabbit = Instance.new("ImageLabel")
Rabbit.Name = "Rabbit"
Rabbit.Position = UDim2.new(0.85, 0, 0.7, 0)
Rabbit.Size = UDim2.new(0.5, 0, 0.5, 0)
Rabbit.BackgroundColor3 = Color3.new(1, 1, 1)
Rabbit.BackgroundTransparency = 1
Rabbit.BorderSizePixel = 0
Rabbit.BorderColor3 = Color3.new(0, 0, 0)
Rabbit.ZIndex = 2
Rabbit.AnchorPoint = Vector2.new(0.5, 0.5)
Rabbit.Transparency = 1
Rabbit.Image = "rbxassetid://120737853947051"
Rabbit.ImageTransparency = 0.5
Rabbit.Parent = RandomRaceFrame

local UIAspectRatioConstraint6 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint6.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint6.Parent = Rabbit

local Angel = Instance.new("ImageLabel")
Angel.Name = "Angel"
Angel.Position = UDim2.new(0.5, 0, 0.5, 0)
Angel.Size = UDim2.new(0.5, 0, 0.5, 0)
Angel.BackgroundColor3 = Color3.new(1, 1, 1)
Angel.BackgroundTransparency = 1
Angel.BorderSizePixel = 0
Angel.BorderColor3 = Color3.new(0, 0, 0)
Angel.AnchorPoint = Vector2.new(0.5, 0.5)
Angel.Transparency = 1
Angel.Image = "rbxassetid://126783733723567"
Angel.ImageTransparency = 1
Angel.Parent = RandomRaceFrame

local UIAspectRatioConstraint7 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint7.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint7.Parent = Angel

local RandomButton = Instance.new("TextButton")
RandomButton.Name = "RandomButton"
RandomButton.Position = UDim2.new(0, 0, 1, 0)
RandomButton.Size = UDim2.new(1, 0, 0.35, 0)
RandomButton.BackgroundColor3 = Color3.new(0.392157, 0, 0.286275)
RandomButton.BackgroundTransparency = 0.5
RandomButton.BorderSizePixel = 0
RandomButton.BorderColor3 = Color3.new(0, 0, 0)
RandomButton.Transparency = 0.5
RandomButton.Text = "Random"
RandomButton.TextColor3 = Color3.new(1, 1, 1)
RandomButton.TextSize = 14
RandomButton.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
RandomButton.TextScaled = true
RandomButton.TextWrapped = true
RandomButton.Parent = RandomRaceFrame

local UICorner = Instance.new("UICorner")
UICorner.Name = "UICorner"
UICorner.CornerRadius = UDim.new(0.15, 0)
UICorner.Parent = RandomButton

local UIStroke2 = Instance.new("UIStroke")
UIStroke2.Name = "UIStroke"
UIStroke2.Color = Color3.new(0.784314, 0, 1)
UIStroke2.Thickness = 1.5
UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke2.Parent = RandomButton

local RandomBoneButton = Instance.new("TextButton")
RandomBoneButton.Name = "RandomBoneButton"
RandomBoneButton.Position = UDim2.new(0.85, 0, 0.15, 0)
RandomBoneButton.Size = UDim2.new(0.175, 0, 0.03, 0)
RandomBoneButton.BackgroundColor3 = Color3.new(1, 0, 0)
RandomBoneButton.BackgroundTransparency = 0.75
RandomBoneButton.BorderSizePixel = 0
RandomBoneButton.BorderColor3 = Color3.new(0, 0, 0)
RandomBoneButton.AnchorPoint = Vector2.new(0.5, 0.5)
RandomBoneButton.Transparency = 0.75
RandomBoneButton.Text = ""
RandomBoneButton.TextColor3 = Color3.new(0, 0, 0)
RandomBoneButton.TextSize = 14
RandomBoneButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
RandomBoneButton.Parent = Order

local UICorner2 = Instance.new("UICorner")
UICorner2.Name = "UICorner"
UICorner2.CornerRadius = UDim.new(1, 0)
UICorner2.Parent = RandomBoneButton

local UIStroke3 = Instance.new("UIStroke")
UIStroke3.Name = "UIStroke"
UIStroke3.Color = Color3.new(1, 0, 0)
UIStroke3.Thickness = 2
UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke3.Parent = RandomBoneButton

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
Dot.Parent = RandomBoneButton

local UIAspectRatioConstraint8 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint8.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint8.Parent = Dot

local UICorner3 = Instance.new("UICorner")
UICorner3.Name = "UICorner"
UICorner3.CornerRadius = UDim.new(1, 0)
UICorner3.Parent = Dot

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

local RandomBoneTitle = Instance.new("TextLabel")
RandomBoneTitle.Name = "RandomBoneTitle"
RandomBoneTitle.Position = UDim2.new(0.375, 0, 0.15, 0)
RandomBoneTitle.Size = UDim2.new(0.7, 0, 0.03, 0)
RandomBoneTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
RandomBoneTitle.BorderSizePixel = 0
RandomBoneTitle.BorderColor3 = Color3.new(0, 0, 0)
RandomBoneTitle.AnchorPoint = Vector2.new(0.5, 0.5)
RandomBoneTitle.Text = "Auto random bone"
RandomBoneTitle.TextColor3 = Color3.new(1, 1, 1)
RandomBoneTitle.TextSize = 14
RandomBoneTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
RandomBoneTitle.TextScaled = true
RandomBoneTitle.TextWrapped = true
RandomBoneTitle.Parent = Order

local UIStroke4 = Instance.new("UIStroke")
UIStroke4.Name = "UIStroke"
UIStroke4.Color = Color3.new(1, 1, 1)
UIStroke4.Thickness = 2
UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke4.Parent = RandomBoneTitle

local Frame = Order
if not Frame then return end
task.spawn(function()
	while true do
		local allOk = true
		for _, obj in ipairs(Frame:GetDescendants()) do
			if obj:IsA("TextButton")
			or obj:IsA("TextLabel") then
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
