local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Size = UDim2.new(0.5, 0, 0.5, 0)
Main.BackgroundColor3 = Color3.new(0.156863, 0, 0.235294)
Main.BorderSizePixel = 0
Main.BorderColor3 = Color3.new(0, 0, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint.Name = "UIAspectRatioConstraint"
UIAspectRatioConstraint.AspectRatio = 1.649999976158142
UIAspectRatioConstraint.Parent = Main

local UICorner = Instance.new("UICorner")
UICorner.Name = "UICorner"
UICorner.CornerRadius = UDim.new(0.025, 0)
UICorner.Parent = Main

local UIStroke = Instance.new("UIStroke")
UIStroke.Name = "UIStroke"
UIStroke.Color = Color3.new(1, 0, 1)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.75
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = Main

local ScrollingSelectTab = Instance.new("ScrollingFrame")
ScrollingSelectTab.Name = "ScrollingSelectTab"
ScrollingSelectTab.Position = UDim2.new(0.075, 0, 0.5, 0)
ScrollingSelectTab.Size = UDim2.new(0.15, 0, 1, 0)
ScrollingSelectTab.BackgroundColor3 = Color3.new(1, 1, 1)
ScrollingSelectTab.BackgroundTransparency = 1
ScrollingSelectTab.BorderSizePixel = 0
ScrollingSelectTab.BorderColor3 = Color3.new(0, 0, 0)
ScrollingSelectTab.AnchorPoint = Vector2.new(0.5, 0.5)
ScrollingSelectTab.Transparency = 1
ScrollingSelectTab.Active = true
ScrollingSelectTab.ScrollBarImageColor3 = Color3.new(1, 0, 1)
ScrollingSelectTab.ScrollBarThickness = 5
ScrollingSelectTab.Parent = Main

local UIStroke2 = Instance.new("UIStroke")
UIStroke2.Name = "UIStroke"
UIStroke2.Color = Color3.new(1, 0, 1)
UIStroke2.Thickness = 2
UIStroke2.Transparency = 0.75
UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke2.Parent = ScrollingSelectTab

local UICorner2 = Instance.new("UICorner")
UICorner2.Name = "UICorner"
UICorner2.CornerRadius = UDim.new(0.1, 0)
UICorner2.Parent = ScrollingSelectTab

local Main2 = Instance.new("ImageButton")
Main2.Name = "Main"
Main2.Position = UDim2.new(0.475, 0, 0.17, 0)
Main2.Size = UDim2.new(0.75, 0, 0.75, 0)
Main2.BackgroundColor3 = Color3.new(1, 1, 1)
Main2.BackgroundTransparency = 1
Main2.BorderSizePixel = 0
Main2.BorderColor3 = Color3.new(0, 0, 0)
Main2.AnchorPoint = Vector2.new(0.5, 0.5)
Main2.Transparency = 1
Main2.Image = "rbxassetid://70947458717927"
Main2.Parent = ScrollingSelectTab

local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint2.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint2.Parent = Main2

local UIStroke3 = Instance.new("UIStroke")
UIStroke3.Name = "UIStroke"
UIStroke3.Color = Color3.new(1, 0, 1)
UIStroke3.Thickness = 2
UIStroke3.Transparency = 1
UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke3.Parent = Main2

local UICorner3 = Instance.new("UICorner")
UICorner3.Name = "UICorner"
UICorner3.CornerRadius = UDim.new(0.15, 0)
UICorner3.Parent = Main2

local Status = Instance.new("ImageButton")
Status.Name = "Status"
Status.Position = UDim2.new(0.475, 0, 0.06, 0)
Status.Size = UDim2.new(0.75, 0, 0.75, 0)
Status.BackgroundColor3 = Color3.new(1, 1, 1)
Status.BackgroundTransparency = 1
Status.BorderSizePixel = 0
Status.BorderColor3 = Color3.new(0, 0, 0)
Status.AnchorPoint = Vector2.new(0.5, 0.5)
Status.Transparency = 1
Status.Image = "rbxassetid://101429843995746"
Status.Parent = ScrollingSelectTab

local UIAspectRatioConstraint3 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint3.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint3.Parent = Status

local UIStroke4 = Instance.new("UIStroke")
UIStroke4.Name = "UIStroke"
UIStroke4.Color = Color3.new(1, 0, 1)
UIStroke4.Thickness = 2
UIStroke4.Transparency = 1
UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke4.Parent = Status

local UICorner4 = Instance.new("UICorner")
UICorner4.Name = "UICorner"
UICorner4.CornerRadius = UDim.new(0.15, 0)
UICorner4.Parent = Status

local Raid = Instance.new("ImageButton")
Raid.Name = "Raid"
Raid.Position = UDim2.new(0.475, 0, 0.28, 0)
Raid.Size = UDim2.new(0.75, 0, 0.75, 0)
Raid.BackgroundColor3 = Color3.new(1, 1, 1)
Raid.BackgroundTransparency = 1
Raid.BorderSizePixel = 0
Raid.BorderColor3 = Color3.new(0, 0, 0)
Raid.AnchorPoint = Vector2.new(0.5, 0.5)
Raid.Transparency = 1
Raid.Image = "rbxassetid://103855992725664"
Raid.Parent = ScrollingSelectTab

local UIAspectRatioConstraint4 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint4.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint4.Parent = Raid

local UIStroke5 = Instance.new("UIStroke")
UIStroke5.Name = "UIStroke"
UIStroke5.Color = Color3.new(1, 0, 1)
UIStroke5.Thickness = 2
UIStroke5.Transparency = 1
UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke5.Parent = Raid

local UICorner5 = Instance.new("UICorner")
UICorner5.Name = "UICorner"
UICorner5.CornerRadius = UDim.new(0.15, 0)
UICorner5.Parent = Raid

local Fruit = Instance.new("ImageButton")
Fruit.Name = "Fruit"
Fruit.Position = UDim2.new(0.475, 0, 0.39, 0)
Fruit.Size = UDim2.new(0.75, 0, 0.75, 0)
Fruit.BackgroundColor3 = Color3.new(1, 1, 1)
Fruit.BackgroundTransparency = 1
Fruit.BorderSizePixel = 0
Fruit.BorderColor3 = Color3.new(0, 0, 0)
Fruit.AnchorPoint = Vector2.new(0.5, 0.5)
Fruit.Transparency = 1
Fruit.Image = "rbxassetid://82365925335043"
Fruit.Parent = ScrollingSelectTab

local UIAspectRatioConstraint5 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint5.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint5.Parent = Fruit

local UIStroke6 = Instance.new("UIStroke")
UIStroke6.Name = "UIStroke"
UIStroke6.Color = Color3.new(1, 0, 1)
UIStroke6.Thickness = 2
UIStroke6.Transparency = 1
UIStroke6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke6.Parent = Fruit

local UICorner6 = Instance.new("UICorner")
UICorner6.Name = "UICorner"
UICorner6.CornerRadius = UDim.new(0.15, 0)
UICorner6.Parent = Fruit

local Visual = Instance.new("ImageButton")
Visual.Name = "Visual"
Visual.Position = UDim2.new(0.475, 0, 0.5, 0)
Visual.Size = UDim2.new(0.75, 0, 0.75, 0)
Visual.BackgroundColor3 = Color3.new(1, 1, 1)
Visual.BackgroundTransparency = 1
Visual.BorderSizePixel = 0
Visual.BorderColor3 = Color3.new(0, 0, 0)
Visual.AnchorPoint = Vector2.new(0.5, 0.5)
Visual.Transparency = 1
Visual.Image = "rbxassetid://117717020688824"
Visual.Parent = ScrollingSelectTab

local UIAspectRatioConstraint6 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint6.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint6.Parent = Visual

local UIStroke7 = Instance.new("UIStroke")
UIStroke7.Name = "UIStroke"
UIStroke7.Color = Color3.new(1, 0, 1)
UIStroke7.Thickness = 2
UIStroke7.Transparency = 1
UIStroke7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke7.Parent = Visual

local UICorner7 = Instance.new("UICorner")
UICorner7.Name = "UICorner"
UICorner7.CornerRadius = UDim.new(0.15, 0)
UICorner7.Parent = Visual

local Player_Setting = Instance.new("ImageButton")
Player_Setting.Name = "Player Setting"
Player_Setting.Position = UDim2.new(0.475, 0, 0.61, 0)
Player_Setting.Size = UDim2.new(0.75, 0, 0.75, 0)
Player_Setting.BackgroundColor3 = Color3.new(1, 1, 1)
Player_Setting.BackgroundTransparency = 1
Player_Setting.BorderSizePixel = 0
Player_Setting.BorderColor3 = Color3.new(0, 0, 0)
Player_Setting.AnchorPoint = Vector2.new(0.5, 0.5)
Player_Setting.Transparency = 1
Player_Setting.Image = "rbxassetid://128675006078471"
Player_Setting.Parent = ScrollingSelectTab

local UIAspectRatioConstraint7 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint7.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint7.Parent = Player_Setting

local UIStroke8 = Instance.new("UIStroke")
UIStroke8.Name = "UIStroke"
UIStroke8.Color = Color3.new(1, 0, 1)
UIStroke8.Thickness = 2
UIStroke8.Transparency = 1
UIStroke8.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke8.Parent = Player_Setting

local UICorner8 = Instance.new("UICorner")
UICorner8.Name = "UICorner"
UICorner8.CornerRadius = UDim.new(0.15, 0)
UICorner8.Parent = Player_Setting

local Combat = Instance.new("ImageButton")
Combat.Name = "Combat"
Combat.Position = UDim2.new(0.475, 0, 0.72, 0)
Combat.Size = UDim2.new(0.75, 0, 0.75, 0)
Combat.BackgroundColor3 = Color3.new(1, 1, 1)
Combat.BackgroundTransparency = 1
Combat.BorderSizePixel = 0
Combat.BorderColor3 = Color3.new(0, 0, 0)
Combat.AnchorPoint = Vector2.new(0.5, 0.5)
Combat.Transparency = 1
Combat.Image = "rbxassetid://123740650003723"
Combat.Parent = ScrollingSelectTab

local UIAspectRatioConstraint8 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint8.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint8.Parent = Combat

local UIStroke9 = Instance.new("UIStroke")
UIStroke9.Name = "UIStroke"
UIStroke9.Color = Color3.new(1, 0, 1)
UIStroke9.Thickness = 2
UIStroke9.Transparency = 1
UIStroke9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke9.Parent = Combat

local UICorner9 = Instance.new("UICorner")
UICorner9.Name = "UICorner"
UICorner9.CornerRadius = UDim.new(0.15, 0)
UICorner9.Parent = Combat

local Island = Instance.new("ImageButton")
Island.Name = "Island"
Island.Position = UDim2.new(0.475, 0, 0.83, 0)
Island.Size = UDim2.new(0.75, 0, 0.75, 0)
Island.BackgroundColor3 = Color3.new(1, 1, 1)
Island.BackgroundTransparency = 1
Island.BorderSizePixel = 0
Island.BorderColor3 = Color3.new(0, 0, 0)
Island.AnchorPoint = Vector2.new(0.5, 0.5)
Island.Transparency = 1
Island.Image = "rbxassetid://91207551058460"
Island.Parent = ScrollingSelectTab

local UIAspectRatioConstraint9 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint9.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint9.Parent = Island

local UIStroke10 = Instance.new("UIStroke")
UIStroke10.Name = "UIStroke"
UIStroke10.Color = Color3.new(1, 0, 1)
UIStroke10.Thickness = 2
UIStroke10.Transparency = 1
UIStroke10.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke10.Parent = Island

local UICorner10 = Instance.new("UICorner")
UICorner10.Name = "UICorner"
UICorner10.CornerRadius = UDim.new(0.15, 0)
UICorner10.Parent = Island

local Order = Instance.new("ImageButton")
Order.Name = "Order"
Order.Position = UDim2.new(0.475, 0, 0.94, 0)
Order.Size = UDim2.new(0.75, 0, 0.75, 0)
Order.BackgroundColor3 = Color3.new(1, 1, 1)
Order.BackgroundTransparency = 1
Order.BorderSizePixel = 0
Order.BorderColor3 = Color3.new(0, 0, 0)
Order.AnchorPoint = Vector2.new(0.5, 0.5)
Order.Transparency = 1
Order.Image = "rbxassetid://133222903384583"
Order.Parent = ScrollingSelectTab

local UIAspectRatioConstraint10 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint10.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint10.Parent = Order

local UIStroke11 = Instance.new("UIStroke")
UIStroke11.Name = "UIStroke"
UIStroke11.Color = Color3.new(1, 0, 1)
UIStroke11.Thickness = 2
UIStroke11.Transparency = 1
UIStroke11.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke11.Parent = Order

local UICorner11 = Instance.new("UICorner")
UICorner11.Name = "UICorner"
UICorner11.CornerRadius = UDim.new(0.15, 0)
UICorner11.Parent = Order

local TabName = Instance.new("TextLabel")
TabName.Name = "TabName"
TabName.Position = UDim2.new(0.575, 0, 0.05, 0)
TabName.Size = UDim2.new(0.85, 0, 0.1, 0)
TabName.BackgroundColor3 = Color3.new(0.415686, 0, 0.658824)
TabName.BackgroundTransparency = 1
TabName.BorderSizePixel = 0
TabName.BorderColor3 = Color3.new(0, 0, 0)
TabName.AnchorPoint = Vector2.new(0.5, 0.5)
TabName.Transparency = 1
TabName.Text = "Status"
TabName.TextColor3 = Color3.new(1, 1, 1)
TabName.TextSize = 14
TabName.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
TabName.TextScaled = true
TabName.TextWrapped = true
TabName.Parent = Main

local ScrollingTab = Instance.new("ScrollingFrame")
ScrollingTab.Name = "ScrollingTab"
ScrollingTab.Position = UDim2.new(0.575, 0, 0.55, 0)
ScrollingTab.Size = UDim2.new(0.85, 0, 0.9, 0)
ScrollingTab.BackgroundColor3 = Color3.new(1, 0, 1)
ScrollingTab.BorderSizePixel = 0
ScrollingTab.BorderColor3 = Color3.new(0, 0, 0)
ScrollingTab.AnchorPoint = Vector2.new(0.5, 0.5)
ScrollingTab.Active = true
ScrollingTab.CanvasSize = UDim2.new(0, 0, 4, 0)
ScrollingTab.ScrollBarImageColor3 = Color3.new(1, 0, 1)
ScrollingTab.ScrollBarThickness = 7
ScrollingTab.Parent = Main

local UICorner12 = Instance.new("UICorner")
UICorner12.Name = "UICorner"
UICorner12.CornerRadius = UDim.new(0.025, 0)
UICorner12.Parent = ScrollingTab

local UIGradient = Instance.new("UIGradient")
UIGradient.Name = "UIGradient"
UIGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1, 0), NumberSequenceKeypoint.new(0.9, 1, 0), NumberSequenceKeypoint.new(1, 0.85, 0)})
UIGradient.Rotation = 90
UIGradient.Parent = ScrollingTab

local TopButton = Instance.new("ImageButton")
TopButton.Name = "TopButton"
TopButton.Position = UDim2.new(0.5, 0, 1.125, 0)
TopButton.Size = UDim2.new(0.16, 0, 0.16, 0)
TopButton.BackgroundColor3 = Color3.new(1, 0, 1)
TopButton.BackgroundTransparency = 0.25
TopButton.BorderSizePixel = 0
TopButton.BorderColor3 = Color3.new(0, 0, 0)
TopButton.AnchorPoint = Vector2.new(0.5, 0.5)
TopButton.Transparency = 0.25
TopButton.Image = "rbxassetid://12971937041"
TopButton.Parent = Main

local UICorner13 = Instance.new("UICorner")
UICorner13.Name = "UICorner"
UICorner13.CornerRadius = UDim.new(1, 0)
UICorner13.Parent = TopButton

local UIAspectRatioConstraint11 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint11.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint11.Parent = TopButton

local gui = BloxFruitHubGui
if gui then
	for _, obj in ipairs(gui:GetDescendants()) do
		if obj:IsA("TextLabel") then
			obj.TextTransparency = 0
		end
	end
end
