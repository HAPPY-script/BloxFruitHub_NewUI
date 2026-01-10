local ScrollingTab = game.Players.LocalPlayer.PlayerGui:WaitForChild("BloxFruitHubGui"):WaitForChild("Main"):WaitForChild("ScrollingTab")

local Fruit = Instance.new("Frame")
Fruit.Name = "Fruit"
Fruit.Size = UDim2.new(1, 0, 1, 0)
Fruit.BackgroundColor3 = Color3.new(0, 1, 0)
Fruit.BackgroundTransparency = 1
Fruit.BorderSizePixel = 0
Fruit.BorderColor3 = Color3.new(0, 0, 0)
Fruit.Transparency = 1
Fruit.Parent = ScrollingTab

local AutoFruitCollectionTitle = Instance.new("TextLabel")
AutoFruitCollectionTitle.Name = "AutoFruitCollectionTitle"
AutoFruitCollectionTitle.Position = UDim2.new(0.375, 0, 0.03, 0)
AutoFruitCollectionTitle.Size = UDim2.new(0.7, 0, 0.03, 0)
AutoFruitCollectionTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
AutoFruitCollectionTitle.BorderSizePixel = 0
AutoFruitCollectionTitle.BorderColor3 = Color3.new(0, 0, 0)
AutoFruitCollectionTitle.AnchorPoint = Vector2.new(0.5, 0.5)
AutoFruitCollectionTitle.Text = "Auto fruit collection"
AutoFruitCollectionTitle.TextColor3 = Color3.new(1, 1, 1)
AutoFruitCollectionTitle.TextSize = 14
AutoFruitCollectionTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoFruitCollectionTitle.TextScaled = true
AutoFruitCollectionTitle.TextWrapped = true
AutoFruitCollectionTitle.Parent = Fruit

local UIStroke = Instance.new("UIStroke")
UIStroke.Name = "UIStroke"
UIStroke.Color = Color3.new(1, 1, 1)
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = AutoFruitCollectionTitle

local ESPFruitTitle = Instance.new("TextLabel")
ESPFruitTitle.Name = "ESPFruitTitle"
ESPFruitTitle.Position = UDim2.new(0.375, 0, 0.08, 0)
ESPFruitTitle.Size = UDim2.new(0.7, 0, 0.03, 0)
ESPFruitTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
ESPFruitTitle.BorderSizePixel = 0
ESPFruitTitle.BorderColor3 = Color3.new(0, 0, 0)
ESPFruitTitle.AnchorPoint = Vector2.new(0.5, 0.5)
ESPFruitTitle.Text = "ESP fruit"
ESPFruitTitle.TextColor3 = Color3.new(1, 1, 1)
ESPFruitTitle.TextSize = 14
ESPFruitTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
ESPFruitTitle.TextScaled = true
ESPFruitTitle.TextWrapped = true
ESPFruitTitle.Parent = Fruit

local UIStroke2 = Instance.new("UIStroke")
UIStroke2.Name = "UIStroke"
UIStroke2.Color = Color3.new(1, 1, 1)
UIStroke2.Thickness = 2
UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke2.Parent = ESPFruitTitle

local RandomFruitTitle = Instance.new("TextLabel")
RandomFruitTitle.Name = "RandomFruitTitle"
RandomFruitTitle.Position = UDim2.new(0.375, 0, 0.13, 0)
RandomFruitTitle.Size = UDim2.new(0.7, 0, 0.03, 0)
RandomFruitTitle.BackgroundColor3 = Color3.new(0.490196, 0, 0.392157)
RandomFruitTitle.BorderSizePixel = 0
RandomFruitTitle.BorderColor3 = Color3.new(0, 0, 0)
RandomFruitTitle.AnchorPoint = Vector2.new(0.5, 0.5)
RandomFruitTitle.Text = "Random fruit"
RandomFruitTitle.TextColor3 = Color3.new(1, 1, 1)
RandomFruitTitle.TextSize = 14
RandomFruitTitle.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
RandomFruitTitle.TextScaled = true
RandomFruitTitle.TextWrapped = true
RandomFruitTitle.Parent = Fruit

local UIStroke3 = Instance.new("UIStroke")
UIStroke3.Name = "UIStroke"
UIStroke3.Color = Color3.new(1, 1, 1)
UIStroke3.Thickness = 2
UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke3.Parent = RandomFruitTitle

local AutoFruitCollectionButton = Instance.new("TextButton")
AutoFruitCollectionButton.Name = "AutoFruitCollectionButton"
AutoFruitCollectionButton.Position = UDim2.new(0.85, 0, 0.03, 0)
AutoFruitCollectionButton.Size = UDim2.new(0.175, 0, 0.03, 0)
AutoFruitCollectionButton.BackgroundColor3 = Color3.new(1, 0, 0)
AutoFruitCollectionButton.BackgroundTransparency = 0.75
AutoFruitCollectionButton.BorderSizePixel = 0
AutoFruitCollectionButton.BorderColor3 = Color3.new(0, 0, 0)
AutoFruitCollectionButton.AnchorPoint = Vector2.new(0.5, 0.5)
AutoFruitCollectionButton.Transparency = 0.75
AutoFruitCollectionButton.Text = ""
AutoFruitCollectionButton.TextColor3 = Color3.new(0, 0, 0)
AutoFruitCollectionButton.TextSize = 14
AutoFruitCollectionButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AutoFruitCollectionButton.Parent = Fruit

local UICorner = Instance.new("UICorner")
UICorner.Name = "UICorner"
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = AutoFruitCollectionButton

local UIStroke4 = Instance.new("UIStroke")
UIStroke4.Name = "UIStroke"
UIStroke4.Color = Color3.new(1, 0, 0)
UIStroke4.Thickness = 2
UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke4.Parent = AutoFruitCollectionButton

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
Dot.Parent = AutoFruitCollectionButton

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

local ESPFruitButton = Instance.new("TextButton")
ESPFruitButton.Name = "ESPFruitButton"
ESPFruitButton.Position = UDim2.new(0.85, 0, 0.08, 0)
ESPFruitButton.Size = UDim2.new(0.175, 0, 0.03, 0)
ESPFruitButton.BackgroundColor3 = Color3.new(1, 0, 0)
ESPFruitButton.BackgroundTransparency = 0.75
ESPFruitButton.BorderSizePixel = 0
ESPFruitButton.BorderColor3 = Color3.new(0, 0, 0)
ESPFruitButton.AnchorPoint = Vector2.new(0.5, 0.5)
ESPFruitButton.Transparency = 0.75
ESPFruitButton.Text = ""
ESPFruitButton.TextColor3 = Color3.new(0, 0, 0)
ESPFruitButton.TextSize = 14
ESPFruitButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
ESPFruitButton.Parent = Fruit

local UICorner3 = Instance.new("UICorner")
UICorner3.Name = "UICorner"
UICorner3.CornerRadius = UDim.new(1, 0)
UICorner3.Parent = ESPFruitButton

local UIStroke5 = Instance.new("UIStroke")
UIStroke5.Name = "UIStroke"
UIStroke5.Color = Color3.new(1, 0, 0)
UIStroke5.Thickness = 2
UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke5.Parent = ESPFruitButton

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
Dot2.Parent = ESPFruitButton

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

local RandomFruitButton = Instance.new("TextButton")
RandomFruitButton.Name = "RandomFruitButton"
RandomFruitButton.Position = UDim2.new(0.85, 0, 0.13, 0)
RandomFruitButton.Size = UDim2.new(0.2, 0, 0.03, 0)
RandomFruitButton.BackgroundColor3 = Color3.new(0, 1, 0.392157)
RandomFruitButton.BackgroundTransparency = 0.75
RandomFruitButton.BorderSizePixel = 0
RandomFruitButton.BorderColor3 = Color3.new(0, 0, 0)
RandomFruitButton.AnchorPoint = Vector2.new(0.5, 0.5)
RandomFruitButton.Transparency = 0.75
RandomFruitButton.Text = "Random"
RandomFruitButton.TextColor3 = Color3.new(1, 1, 1)
RandomFruitButton.TextSize = 14
RandomFruitButton.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
RandomFruitButton.TextScaled = true
RandomFruitButton.TextWrapped = true
RandomFruitButton.Parent = Fruit

local UIStroke6 = Instance.new("UIStroke")
UIStroke6.Name = "UIStroke"
UIStroke6.Color = Color3.new(0, 1, 0.392157)
UIStroke6.Thickness = 2
UIStroke6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke6.Parent = RandomFruitButton

local Frame = Fruit
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
