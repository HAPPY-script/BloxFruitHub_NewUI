local ScrollingTab = game.Players.LocalPlayer.PlayerGui:WaitForChild("BloxFruitHubGui"):WaitForChild("Main"):WaitForChild("ScrollingTab")

local Island = Instance.new("Frame")
Island.Name = "Island"
Island.Size = UDim2.new(1, 0, 1, 0)
Island.BackgroundColor3 = Color3.new(0, 0.862745, 1)
Island.BackgroundTransparency = 1
Island.BorderSizePixel = 0
Island.BorderColor3 = Color3.new(0, 0, 0)
Island.Transparency = 1
Island.Parent = ScrollingTab

local Sea3 = Instance.new("Folder")
Sea3.Name = "Sea3"

Sea3.Parent = Island

local Hydra_Island = Instance.new("ImageButton")
Hydra_Island.Name = "Hydra Island"
Hydra_Island.Position = UDim2.new(0.5, 0, 0.06, 0)
Hydra_Island.Size = UDim2.new(0.25, 0, 0.25, 0)
Hydra_Island.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Hydra_Island.BackgroundTransparency = 0.75
Hydra_Island.BorderSizePixel = 0
Hydra_Island.BorderColor3 = Color3.new(0, 0, 0)
Hydra_Island.AnchorPoint = Vector2.new(0.5, 0.5)
Hydra_Island.Transparency = 0.75
Hydra_Island.Image = "rbxassetid://117924666879793"
Hydra_Island.Parent = Sea3

local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint.Parent = Hydra_Island

local UICorner = Instance.new("UICorner")
UICorner.Name = "UICorner"
UICorner.CornerRadius = UDim.new(0.15, 0)
UICorner.Parent = Hydra_Island

local Effect = Instance.new("Frame")
Effect.Name = "Effect"
Effect.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect.Size = UDim2.new(1, 0, 1, 0)
Effect.BackgroundColor3 = Color3.new(0, 0, 0)
Effect.BackgroundTransparency = 0.15000000596046448
Effect.BorderSizePixel = 0
Effect.BorderColor3 = Color3.new(0, 0, 0)
Effect.AnchorPoint = Vector2.new(0.5, 0.5)
Effect.Transparency = 0.15000000596046448
Effect.Parent = Hydra_Island

local UICorner2 = Instance.new("UICorner")
UICorner2.Name = "UICorner"
UICorner2.CornerRadius = UDim.new(0.15, 0)
UICorner2.Parent = Effect

local UIGradient = Instance.new("UIGradient")
UIGradient.Name = "UIGradient"
UIGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient.Rotation = -90
UIGradient.Offset = Vector2.new(0, 1)
UIGradient.Parent = Effect

local Name = Instance.new("TextLabel")
Name.Name = "Name"
Name.Position = UDim2.new(0.5, 0, 0.825, 0)
Name.Size = UDim2.new(1, 0, 0.375, 0)
Name.BackgroundColor3 = Color3.new(1, 1, 1)
Name.BackgroundTransparency = 1
Name.BorderSizePixel = 0
Name.BorderColor3 = Color3.new(0, 0, 0)
Name.AnchorPoint = Vector2.new(0.5, 0.5)
Name.Transparency = 1
Name.Text = "Hydra Island"
Name.TextColor3 = Color3.new(1, 1, 1)
Name.TextSize = 14
Name.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name.TextScaled = true
Name.TextWrapped = true
Name.Parent = Effect

local CancelButton = Instance.new("TextButton")
CancelButton.Name = "CancelButton"
CancelButton.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton.BorderSizePixel = 0
CancelButton.BorderColor3 = Color3.new(0, 0, 0)
CancelButton.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton.Text = "Cancel"
CancelButton.TextColor3 = Color3.new(1, 1, 1)
CancelButton.TextSize = 14
CancelButton.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton.TextScaled = true
CancelButton.TextWrapped = true
CancelButton.Parent = Effect

local UIStroke = Instance.new("UIStroke")
UIStroke.Name = "UIStroke"
UIStroke.Color = Color3.new(1, 1, 1)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = CancelButton

local Ratio = Instance.new("TextLabel")
Ratio.Name = "Ratio"
Ratio.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio.Size = UDim2.new(1, 0, 0.25, 0)
Ratio.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio.BackgroundTransparency = 1
Ratio.BorderSizePixel = 0
Ratio.BorderColor3 = Color3.new(0, 0, 0)
Ratio.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio.Transparency = 1
Ratio.Text = "0%"
Ratio.TextColor3 = Color3.new(1, 0, 0)
Ratio.TextSize = 14
Ratio.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio.TextScaled = true
Ratio.TextWrapped = true
Ratio.Parent = Effect

local Loading = Instance.new("Frame")
Loading.Name = "Loading"
Loading.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading.Size = UDim2.new(1, 0, 0.1, 0)
Loading.BackgroundColor3 = Color3.new(1, 1, 1)
Loading.BackgroundTransparency = 1
Loading.BorderSizePixel = 0
Loading.BorderColor3 = Color3.new(0, 0, 0)
Loading.ZIndex = 2
Loading.AnchorPoint = Vector2.new(0.5, 0.5)
Loading.Transparency = 1
Loading.Parent = Effect

local LoadFrame = Instance.new("Frame")
LoadFrame.Name = "LoadFrame"
LoadFrame.Size = UDim2.new(1, 0, 1, 0)
LoadFrame.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame.BorderSizePixel = 0
LoadFrame.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame.Parent = Loading

local UICorner3 = Instance.new("UICorner")
UICorner3.Name = "UICorner"
UICorner3.CornerRadius = UDim.new(1, 0)
UICorner3.Parent = LoadFrame

local Port_Town = Instance.new("ImageButton")
Port_Town.Name = "Port Town"
Port_Town.Position = UDim2.new(0.2, 0, 0.06, 0)
Port_Town.Size = UDim2.new(0.25, 0, 0.25, 0)
Port_Town.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Port_Town.BackgroundTransparency = 0.75
Port_Town.BorderSizePixel = 0
Port_Town.BorderColor3 = Color3.new(0, 0, 0)
Port_Town.AnchorPoint = Vector2.new(0.5, 0.5)
Port_Town.Transparency = 0.75
Port_Town.Image = "rbxassetid://90119384527680"
Port_Town.Parent = Sea3

local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint2.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint2.Parent = Port_Town

local UICorner4 = Instance.new("UICorner")
UICorner4.Name = "UICorner"
UICorner4.CornerRadius = UDim.new(0.15, 0)
UICorner4.Parent = Port_Town

local Effect2 = Instance.new("Frame")
Effect2.Name = "Effect"
Effect2.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect2.Size = UDim2.new(1, 0, 1, 0)
Effect2.BackgroundColor3 = Color3.new(0, 0, 0)
Effect2.BackgroundTransparency = 0.15000000596046448
Effect2.BorderSizePixel = 0
Effect2.BorderColor3 = Color3.new(0, 0, 0)
Effect2.AnchorPoint = Vector2.new(0.5, 0.5)
Effect2.Transparency = 0.15000000596046448
Effect2.Parent = Port_Town

local UICorner5 = Instance.new("UICorner")
UICorner5.Name = "UICorner"
UICorner5.CornerRadius = UDim.new(0.15, 0)
UICorner5.Parent = Effect2

local UIGradient2 = Instance.new("UIGradient")
UIGradient2.Name = "UIGradient"
UIGradient2.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient2.Rotation = -90
UIGradient2.Offset = Vector2.new(0, 1)
UIGradient2.Parent = Effect2

local Name2 = Instance.new("TextLabel")
Name2.Name = "Name"
Name2.Position = UDim2.new(0.5, 0, 0.825, 0)
Name2.Size = UDim2.new(1, 0, 0.375, 0)
Name2.BackgroundColor3 = Color3.new(1, 1, 1)
Name2.BackgroundTransparency = 1
Name2.BorderSizePixel = 0
Name2.BorderColor3 = Color3.new(0, 0, 0)
Name2.AnchorPoint = Vector2.new(0.5, 0.5)
Name2.Transparency = 1
Name2.Text = "Port Town"
Name2.TextColor3 = Color3.new(1, 1, 1)
Name2.TextSize = 14
Name2.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name2.TextScaled = true
Name2.TextWrapped = true
Name2.Parent = Effect2

local CancelButton2 = Instance.new("TextButton")
CancelButton2.Name = "CancelButton"
CancelButton2.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton2.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton2.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton2.BorderSizePixel = 0
CancelButton2.BorderColor3 = Color3.new(0, 0, 0)
CancelButton2.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton2.Text = "Cancel"
CancelButton2.TextColor3 = Color3.new(1, 1, 1)
CancelButton2.TextSize = 14
CancelButton2.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton2.TextScaled = true
CancelButton2.TextWrapped = true
CancelButton2.Parent = Effect2

local UIStroke2 = Instance.new("UIStroke")
UIStroke2.Name = "UIStroke"
UIStroke2.Color = Color3.new(1, 1, 1)
UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke2.Parent = CancelButton2

local Ratio2 = Instance.new("TextLabel")
Ratio2.Name = "Ratio"
Ratio2.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio2.Size = UDim2.new(1, 0, 0.25, 0)
Ratio2.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio2.BackgroundTransparency = 1
Ratio2.BorderSizePixel = 0
Ratio2.BorderColor3 = Color3.new(0, 0, 0)
Ratio2.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio2.Transparency = 1
Ratio2.Text = "0%"
Ratio2.TextColor3 = Color3.new(1, 0, 0)
Ratio2.TextSize = 14
Ratio2.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio2.TextScaled = true
Ratio2.TextWrapped = true
Ratio2.Parent = Effect2

local Loading2 = Instance.new("Frame")
Loading2.Name = "Loading"
Loading2.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading2.Size = UDim2.new(1, 0, 0.1, 0)
Loading2.BackgroundColor3 = Color3.new(1, 1, 1)
Loading2.BackgroundTransparency = 1
Loading2.BorderSizePixel = 0
Loading2.BorderColor3 = Color3.new(0, 0, 0)
Loading2.ZIndex = 2
Loading2.AnchorPoint = Vector2.new(0.5, 0.5)
Loading2.Transparency = 1
Loading2.Parent = Effect2

local LoadFrame2 = Instance.new("Frame")
LoadFrame2.Name = "LoadFrame"
LoadFrame2.Size = UDim2.new(1, 0, 1, 0)
LoadFrame2.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame2.BorderSizePixel = 0
LoadFrame2.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame2.Parent = Loading2

local UICorner6 = Instance.new("UICorner")
UICorner6.Name = "UICorner"
UICorner6.CornerRadius = UDim.new(1, 0)
UICorner6.Parent = LoadFrame2

local Great_Tree = Instance.new("ImageButton")
Great_Tree.Name = "Great Tree"
Great_Tree.Position = UDim2.new(0.8, 0, 0.06, 0)
Great_Tree.Size = UDim2.new(0.25, 0, 0.25, 0)
Great_Tree.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Great_Tree.BackgroundTransparency = 0.75
Great_Tree.BorderSizePixel = 0
Great_Tree.BorderColor3 = Color3.new(0, 0, 0)
Great_Tree.AnchorPoint = Vector2.new(0.5, 0.5)
Great_Tree.Transparency = 0.75
Great_Tree.Image = "rbxassetid://106689913445825"
Great_Tree.Parent = Sea3

local UIAspectRatioConstraint3 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint3.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint3.Parent = Great_Tree

local UICorner7 = Instance.new("UICorner")
UICorner7.Name = "UICorner"
UICorner7.CornerRadius = UDim.new(0.15, 0)
UICorner7.Parent = Great_Tree

local Effect3 = Instance.new("Frame")
Effect3.Name = "Effect"
Effect3.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect3.Size = UDim2.new(1, 0, 1, 0)
Effect3.BackgroundColor3 = Color3.new(0, 0, 0)
Effect3.BackgroundTransparency = 0.15000000596046448
Effect3.BorderSizePixel = 0
Effect3.BorderColor3 = Color3.new(0, 0, 0)
Effect3.AnchorPoint = Vector2.new(0.5, 0.5)
Effect3.Transparency = 0.15000000596046448
Effect3.Parent = Great_Tree

local UICorner8 = Instance.new("UICorner")
UICorner8.Name = "UICorner"
UICorner8.CornerRadius = UDim.new(0.15, 0)
UICorner8.Parent = Effect3

local UIGradient3 = Instance.new("UIGradient")
UIGradient3.Name = "UIGradient"
UIGradient3.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient3.Rotation = -90
UIGradient3.Offset = Vector2.new(0, 1)
UIGradient3.Parent = Effect3

local Name3 = Instance.new("TextLabel")
Name3.Name = "Name"
Name3.Position = UDim2.new(0.5, 0, 0.825, 0)
Name3.Size = UDim2.new(1, 0, 0.375, 0)
Name3.BackgroundColor3 = Color3.new(1, 1, 1)
Name3.BackgroundTransparency = 1
Name3.BorderSizePixel = 0
Name3.BorderColor3 = Color3.new(0, 0, 0)
Name3.AnchorPoint = Vector2.new(0.5, 0.5)
Name3.Transparency = 1
Name3.Text = "Great Tree"
Name3.TextColor3 = Color3.new(1, 1, 1)
Name3.TextSize = 14
Name3.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name3.TextScaled = true
Name3.TextWrapped = true
Name3.Parent = Effect3

local CancelButton3 = Instance.new("TextButton")
CancelButton3.Name = "CancelButton"
CancelButton3.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton3.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton3.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton3.BorderSizePixel = 0
CancelButton3.BorderColor3 = Color3.new(0, 0, 0)
CancelButton3.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton3.Text = "Cancel"
CancelButton3.TextColor3 = Color3.new(1, 1, 1)
CancelButton3.TextSize = 14
CancelButton3.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton3.TextScaled = true
CancelButton3.TextWrapped = true
CancelButton3.Parent = Effect3

local UIStroke3 = Instance.new("UIStroke")
UIStroke3.Name = "UIStroke"
UIStroke3.Color = Color3.new(1, 1, 1)
UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke3.Parent = CancelButton3

local Ratio3 = Instance.new("TextLabel")
Ratio3.Name = "Ratio"
Ratio3.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio3.Size = UDim2.new(1, 0, 0.25, 0)
Ratio3.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio3.BackgroundTransparency = 1
Ratio3.BorderSizePixel = 0
Ratio3.BorderColor3 = Color3.new(0, 0, 0)
Ratio3.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio3.Transparency = 1
Ratio3.Text = "0%"
Ratio3.TextColor3 = Color3.new(1, 0, 0)
Ratio3.TextSize = 14
Ratio3.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio3.TextScaled = true
Ratio3.TextWrapped = true
Ratio3.Parent = Effect3

local Loading3 = Instance.new("Frame")
Loading3.Name = "Loading"
Loading3.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading3.Size = UDim2.new(1, 0, 0.1, 0)
Loading3.BackgroundColor3 = Color3.new(1, 1, 1)
Loading3.BackgroundTransparency = 1
Loading3.BorderSizePixel = 0
Loading3.BorderColor3 = Color3.new(0, 0, 0)
Loading3.ZIndex = 2
Loading3.AnchorPoint = Vector2.new(0.5, 0.5)
Loading3.Transparency = 1
Loading3.Parent = Effect3

local LoadFrame3 = Instance.new("Frame")
LoadFrame3.Name = "LoadFrame"
LoadFrame3.Size = UDim2.new(1, 0, 1, 0)
LoadFrame3.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame3.BorderSizePixel = 0
LoadFrame3.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame3.Parent = Loading3

local UICorner9 = Instance.new("UICorner")
UICorner9.Name = "UICorner"
UICorner9.CornerRadius = UDim.new(1, 0)
UICorner9.Parent = LoadFrame3

local Mansion = Instance.new("ImageButton")
Mansion.Name = "Mansion"
Mansion.Position = UDim2.new(0.2, 0, 0.165, 0)
Mansion.Size = UDim2.new(0.25, 0, 0.25, 0)
Mansion.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Mansion.BackgroundTransparency = 0.75
Mansion.BorderSizePixel = 0
Mansion.BorderColor3 = Color3.new(0, 0, 0)
Mansion.AnchorPoint = Vector2.new(0.5, 0.5)
Mansion.Transparency = 0.75
Mansion.Image = "rbxassetid://115057737431641"
Mansion.Parent = Sea3

local UIAspectRatioConstraint4 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint4.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint4.Parent = Mansion

local UICorner10 = Instance.new("UICorner")
UICorner10.Name = "UICorner"
UICorner10.CornerRadius = UDim.new(0.15, 0)
UICorner10.Parent = Mansion

local Effect4 = Instance.new("Frame")
Effect4.Name = "Effect"
Effect4.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect4.Size = UDim2.new(1, 0, 1, 0)
Effect4.BackgroundColor3 = Color3.new(0, 0, 0)
Effect4.BackgroundTransparency = 0.15000000596046448
Effect4.BorderSizePixel = 0
Effect4.BorderColor3 = Color3.new(0, 0, 0)
Effect4.AnchorPoint = Vector2.new(0.5, 0.5)
Effect4.Transparency = 0.15000000596046448
Effect4.Parent = Mansion

local UICorner11 = Instance.new("UICorner")
UICorner11.Name = "UICorner"
UICorner11.CornerRadius = UDim.new(0.15, 0)
UICorner11.Parent = Effect4

local UIGradient4 = Instance.new("UIGradient")
UIGradient4.Name = "UIGradient"
UIGradient4.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient4.Rotation = -90
UIGradient4.Offset = Vector2.new(0, 1)
UIGradient4.Parent = Effect4

local Name4 = Instance.new("TextLabel")
Name4.Name = "Name"
Name4.Position = UDim2.new(0.5, 0, 0.825, 0)
Name4.Size = UDim2.new(1, 0, 0.375, 0)
Name4.BackgroundColor3 = Color3.new(1, 1, 1)
Name4.BackgroundTransparency = 1
Name4.BorderSizePixel = 0
Name4.BorderColor3 = Color3.new(0, 0, 0)
Name4.AnchorPoint = Vector2.new(0.5, 0.5)
Name4.Transparency = 1
Name4.Text = "Mansion"
Name4.TextColor3 = Color3.new(1, 1, 1)
Name4.TextSize = 14
Name4.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name4.TextScaled = true
Name4.TextWrapped = true
Name4.Parent = Effect4

local CancelButton4 = Instance.new("TextButton")
CancelButton4.Name = "CancelButton"
CancelButton4.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton4.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton4.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton4.BorderSizePixel = 0
CancelButton4.BorderColor3 = Color3.new(0, 0, 0)
CancelButton4.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton4.Text = "Cancel"
CancelButton4.TextColor3 = Color3.new(1, 1, 1)
CancelButton4.TextSize = 14
CancelButton4.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton4.TextScaled = true
CancelButton4.TextWrapped = true
CancelButton4.Parent = Effect4

local UIStroke4 = Instance.new("UIStroke")
UIStroke4.Name = "UIStroke"
UIStroke4.Color = Color3.new(1, 1, 1)
UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke4.Parent = CancelButton4

local Ratio4 = Instance.new("TextLabel")
Ratio4.Name = "Ratio"
Ratio4.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio4.Size = UDim2.new(1, 0, 0.25, 0)
Ratio4.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio4.BackgroundTransparency = 1
Ratio4.BorderSizePixel = 0
Ratio4.BorderColor3 = Color3.new(0, 0, 0)
Ratio4.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio4.Transparency = 1
Ratio4.Text = "0%"
Ratio4.TextColor3 = Color3.new(1, 0, 0)
Ratio4.TextSize = 14
Ratio4.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio4.TextScaled = true
Ratio4.TextWrapped = true
Ratio4.Parent = Effect4

local Loading4 = Instance.new("Frame")
Loading4.Name = "Loading"
Loading4.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading4.Size = UDim2.new(1, 0, 0.1, 0)
Loading4.BackgroundColor3 = Color3.new(1, 1, 1)
Loading4.BackgroundTransparency = 1
Loading4.BorderSizePixel = 0
Loading4.BorderColor3 = Color3.new(0, 0, 0)
Loading4.ZIndex = 2
Loading4.AnchorPoint = Vector2.new(0.5, 0.5)
Loading4.Transparency = 1
Loading4.Parent = Effect4

local LoadFrame4 = Instance.new("Frame")
LoadFrame4.Name = "LoadFrame"
LoadFrame4.Size = UDim2.new(1, 0, 1, 0)
LoadFrame4.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame4.BorderSizePixel = 0
LoadFrame4.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame4.Parent = Loading4

local UICorner12 = Instance.new("UICorner")
UICorner12.Name = "UICorner"
UICorner12.CornerRadius = UDim.new(1, 0)
UICorner12.Parent = LoadFrame4

local Haunted_Castle = Instance.new("ImageButton")
Haunted_Castle.Name = "Haunted Castle"
Haunted_Castle.Position = UDim2.new(0.5, 0, 0.165, 0)
Haunted_Castle.Size = UDim2.new(0.25, 0, 0.25, 0)
Haunted_Castle.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Haunted_Castle.BackgroundTransparency = 0.75
Haunted_Castle.BorderSizePixel = 0
Haunted_Castle.BorderColor3 = Color3.new(0, 0, 0)
Haunted_Castle.AnchorPoint = Vector2.new(0.5, 0.5)
Haunted_Castle.Transparency = 0.75
Haunted_Castle.Image = "rbxassetid://89367301681698"
Haunted_Castle.Parent = Sea3

local UIAspectRatioConstraint5 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint5.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint5.Parent = Haunted_Castle

local UICorner13 = Instance.new("UICorner")
UICorner13.Name = "UICorner"
UICorner13.CornerRadius = UDim.new(0.15, 0)
UICorner13.Parent = Haunted_Castle

local Effect5 = Instance.new("Frame")
Effect5.Name = "Effect"
Effect5.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect5.Size = UDim2.new(1, 0, 1, 0)
Effect5.BackgroundColor3 = Color3.new(0, 0, 0)
Effect5.BackgroundTransparency = 0.15000000596046448
Effect5.BorderSizePixel = 0
Effect5.BorderColor3 = Color3.new(0, 0, 0)
Effect5.AnchorPoint = Vector2.new(0.5, 0.5)
Effect5.Transparency = 0.15000000596046448
Effect5.Parent = Haunted_Castle

local UICorner14 = Instance.new("UICorner")
UICorner14.Name = "UICorner"
UICorner14.CornerRadius = UDim.new(0.15, 0)
UICorner14.Parent = Effect5

local UIGradient5 = Instance.new("UIGradient")
UIGradient5.Name = "UIGradient"
UIGradient5.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient5.Rotation = -90
UIGradient5.Offset = Vector2.new(0, 1)
UIGradient5.Parent = Effect5

local Name5 = Instance.new("TextLabel")
Name5.Name = "Name"
Name5.Position = UDim2.new(0.5, 0, 0.825, 0)
Name5.Size = UDim2.new(1, 0, 0.375, 0)
Name5.BackgroundColor3 = Color3.new(1, 1, 1)
Name5.BackgroundTransparency = 1
Name5.BorderSizePixel = 0
Name5.BorderColor3 = Color3.new(0, 0, 0)
Name5.AnchorPoint = Vector2.new(0.5, 0.5)
Name5.Transparency = 1
Name5.Text = "Haunted Castle"
Name5.TextColor3 = Color3.new(1, 1, 1)
Name5.TextSize = 14
Name5.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name5.TextScaled = true
Name5.TextWrapped = true
Name5.Parent = Effect5

local CancelButton5 = Instance.new("TextButton")
CancelButton5.Name = "CancelButton"
CancelButton5.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton5.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton5.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton5.BorderSizePixel = 0
CancelButton5.BorderColor3 = Color3.new(0, 0, 0)
CancelButton5.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton5.Text = "Cancel"
CancelButton5.TextColor3 = Color3.new(1, 1, 1)
CancelButton5.TextSize = 14
CancelButton5.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton5.TextScaled = true
CancelButton5.TextWrapped = true
CancelButton5.Parent = Effect5

local UIStroke5 = Instance.new("UIStroke")
UIStroke5.Name = "UIStroke"
UIStroke5.Color = Color3.new(1, 1, 1)
UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke5.Parent = CancelButton5

local Ratio5 = Instance.new("TextLabel")
Ratio5.Name = "Ratio"
Ratio5.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio5.Size = UDim2.new(1, 0, 0.25, 0)
Ratio5.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio5.BackgroundTransparency = 1
Ratio5.BorderSizePixel = 0
Ratio5.BorderColor3 = Color3.new(0, 0, 0)
Ratio5.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio5.Transparency = 1
Ratio5.Text = "0%"
Ratio5.TextColor3 = Color3.new(1, 0, 0)
Ratio5.TextSize = 14
Ratio5.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio5.TextScaled = true
Ratio5.TextWrapped = true
Ratio5.Parent = Effect5

local Loading5 = Instance.new("Frame")
Loading5.Name = "Loading"
Loading5.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading5.Size = UDim2.new(1, 0, 0.1, 0)
Loading5.BackgroundColor3 = Color3.new(1, 1, 1)
Loading5.BackgroundTransparency = 1
Loading5.BorderSizePixel = 0
Loading5.BorderColor3 = Color3.new(0, 0, 0)
Loading5.ZIndex = 2
Loading5.AnchorPoint = Vector2.new(0.5, 0.5)
Loading5.Transparency = 1
Loading5.Parent = Effect5

local LoadFrame5 = Instance.new("Frame")
LoadFrame5.Name = "LoadFrame"
LoadFrame5.Size = UDim2.new(1, 0, 1, 0)
LoadFrame5.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame5.BorderSizePixel = 0
LoadFrame5.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame5.Parent = Loading5

local UICorner15 = Instance.new("UICorner")
UICorner15.Name = "UICorner"
UICorner15.CornerRadius = UDim.new(1, 0)
UICorner15.Parent = LoadFrame5

local IcecreamLand = Instance.new("ImageButton")
IcecreamLand.Name = "IcecreamLand"
IcecreamLand.Position = UDim2.new(0.8, 0, 0.165, 0)
IcecreamLand.Size = UDim2.new(0.25, 0, 0.25, 0)
IcecreamLand.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
IcecreamLand.BackgroundTransparency = 0.75
IcecreamLand.BorderSizePixel = 0
IcecreamLand.BorderColor3 = Color3.new(0, 0, 0)
IcecreamLand.AnchorPoint = Vector2.new(0.5, 0.5)
IcecreamLand.Transparency = 0.75
IcecreamLand.Image = "rbxassetid://84425292949709"
IcecreamLand.Parent = Sea3

local UIAspectRatioConstraint6 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint6.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint6.Parent = IcecreamLand

local UICorner16 = Instance.new("UICorner")
UICorner16.Name = "UICorner"
UICorner16.CornerRadius = UDim.new(0.15, 0)
UICorner16.Parent = IcecreamLand

local Effect6 = Instance.new("Frame")
Effect6.Name = "Effect"
Effect6.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect6.Size = UDim2.new(1, 0, 1, 0)
Effect6.BackgroundColor3 = Color3.new(0, 0, 0)
Effect6.BackgroundTransparency = 0.15000000596046448
Effect6.BorderSizePixel = 0
Effect6.BorderColor3 = Color3.new(0, 0, 0)
Effect6.AnchorPoint = Vector2.new(0.5, 0.5)
Effect6.Transparency = 0.15000000596046448
Effect6.Parent = IcecreamLand

local UICorner17 = Instance.new("UICorner")
UICorner17.Name = "UICorner"
UICorner17.CornerRadius = UDim.new(0.15, 0)
UICorner17.Parent = Effect6

local UIGradient6 = Instance.new("UIGradient")
UIGradient6.Name = "UIGradient"
UIGradient6.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient6.Rotation = -90
UIGradient6.Offset = Vector2.new(0, 1)
UIGradient6.Parent = Effect6

local Name6 = Instance.new("TextLabel")
Name6.Name = "Name"
Name6.Position = UDim2.new(0.5, 0, 0.825, 0)
Name6.Size = UDim2.new(1, 0, 0.375, 0)
Name6.BackgroundColor3 = Color3.new(1, 1, 1)
Name6.BackgroundTransparency = 1
Name6.BorderSizePixel = 0
Name6.BorderColor3 = Color3.new(0, 0, 0)
Name6.AnchorPoint = Vector2.new(0.5, 0.5)
Name6.Transparency = 1
Name6.Text = "IcecreamLand"
Name6.TextColor3 = Color3.new(1, 1, 1)
Name6.TextSize = 14
Name6.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name6.TextScaled = true
Name6.TextWrapped = true
Name6.Parent = Effect6

local CancelButton6 = Instance.new("TextButton")
CancelButton6.Name = "CancelButton"
CancelButton6.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton6.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton6.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton6.BorderSizePixel = 0
CancelButton6.BorderColor3 = Color3.new(0, 0, 0)
CancelButton6.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton6.Text = "Cancel"
CancelButton6.TextColor3 = Color3.new(1, 1, 1)
CancelButton6.TextSize = 14
CancelButton6.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton6.TextScaled = true
CancelButton6.TextWrapped = true
CancelButton6.Parent = Effect6

local UIStroke6 = Instance.new("UIStroke")
UIStroke6.Name = "UIStroke"
UIStroke6.Color = Color3.new(1, 1, 1)
UIStroke6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke6.Parent = CancelButton6

local Ratio6 = Instance.new("TextLabel")
Ratio6.Name = "Ratio"
Ratio6.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio6.Size = UDim2.new(1, 0, 0.25, 0)
Ratio6.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio6.BackgroundTransparency = 1
Ratio6.BorderSizePixel = 0
Ratio6.BorderColor3 = Color3.new(0, 0, 0)
Ratio6.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio6.Transparency = 1
Ratio6.Text = "0%"
Ratio6.TextColor3 = Color3.new(1, 0, 0)
Ratio6.TextSize = 14
Ratio6.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio6.TextScaled = true
Ratio6.TextWrapped = true
Ratio6.Parent = Effect6

local Loading6 = Instance.new("Frame")
Loading6.Name = "Loading"
Loading6.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading6.Size = UDim2.new(1, 0, 0.1, 0)
Loading6.BackgroundColor3 = Color3.new(1, 1, 1)
Loading6.BackgroundTransparency = 1
Loading6.BorderSizePixel = 0
Loading6.BorderColor3 = Color3.new(0, 0, 0)
Loading6.ZIndex = 2
Loading6.AnchorPoint = Vector2.new(0.5, 0.5)
Loading6.Transparency = 1
Loading6.Parent = Effect6

local LoadFrame6 = Instance.new("Frame")
LoadFrame6.Name = "LoadFrame"
LoadFrame6.Size = UDim2.new(1, 0, 1, 0)
LoadFrame6.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame6.BorderSizePixel = 0
LoadFrame6.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame6.Parent = Loading6

local UICorner18 = Instance.new("UICorner")
UICorner18.Name = "UICorner"
UICorner18.CornerRadius = UDim.new(1, 0)
UICorner18.Parent = LoadFrame6

local CakeLand = Instance.new("ImageButton")
CakeLand.Name = "CakeLand"
CakeLand.Position = UDim2.new(0.2, 0, 0.27, 0)
CakeLand.Size = UDim2.new(0.25, 0, 0.25, 0)
CakeLand.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
CakeLand.BackgroundTransparency = 0.75
CakeLand.BorderSizePixel = 0
CakeLand.BorderColor3 = Color3.new(0, 0, 0)
CakeLand.AnchorPoint = Vector2.new(0.5, 0.5)
CakeLand.Transparency = 0.75
CakeLand.Image = "rbxassetid://108327090167582"
CakeLand.Parent = Sea3

local UIAspectRatioConstraint7 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint7.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint7.Parent = CakeLand

local UICorner19 = Instance.new("UICorner")
UICorner19.Name = "UICorner"
UICorner19.CornerRadius = UDim.new(0.15, 0)
UICorner19.Parent = CakeLand

local Effect7 = Instance.new("Frame")
Effect7.Name = "Effect"
Effect7.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect7.Size = UDim2.new(1, 0, 1, 0)
Effect7.BackgroundColor3 = Color3.new(0, 0, 0)
Effect7.BackgroundTransparency = 0.15000000596046448
Effect7.BorderSizePixel = 0
Effect7.BorderColor3 = Color3.new(0, 0, 0)
Effect7.AnchorPoint = Vector2.new(0.5, 0.5)
Effect7.Transparency = 0.15000000596046448
Effect7.Parent = CakeLand

local UICorner20 = Instance.new("UICorner")
UICorner20.Name = "UICorner"
UICorner20.CornerRadius = UDim.new(0.15, 0)
UICorner20.Parent = Effect7

local UIGradient7 = Instance.new("UIGradient")
UIGradient7.Name = "UIGradient"
UIGradient7.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient7.Rotation = -90
UIGradient7.Offset = Vector2.new(0, 1)
UIGradient7.Parent = Effect7

local Name7 = Instance.new("TextLabel")
Name7.Name = "Name"
Name7.Position = UDim2.new(0.5, 0, 0.825, 0)
Name7.Size = UDim2.new(1, 0, 0.375, 0)
Name7.BackgroundColor3 = Color3.new(1, 1, 1)
Name7.BackgroundTransparency = 1
Name7.BorderSizePixel = 0
Name7.BorderColor3 = Color3.new(0, 0, 0)
Name7.AnchorPoint = Vector2.new(0.5, 0.5)
Name7.Transparency = 1
Name7.Text = "CakeLand"
Name7.TextColor3 = Color3.new(1, 1, 1)
Name7.TextSize = 14
Name7.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name7.TextScaled = true
Name7.TextWrapped = true
Name7.Parent = Effect7

local CancelButton7 = Instance.new("TextButton")
CancelButton7.Name = "CancelButton"
CancelButton7.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton7.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton7.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton7.BorderSizePixel = 0
CancelButton7.BorderColor3 = Color3.new(0, 0, 0)
CancelButton7.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton7.Text = "Cancel"
CancelButton7.TextColor3 = Color3.new(1, 1, 1)
CancelButton7.TextSize = 14
CancelButton7.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton7.TextScaled = true
CancelButton7.TextWrapped = true
CancelButton7.Parent = Effect7

local UIStroke7 = Instance.new("UIStroke")
UIStroke7.Name = "UIStroke"
UIStroke7.Color = Color3.new(1, 1, 1)
UIStroke7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke7.Parent = CancelButton7

local Ratio7 = Instance.new("TextLabel")
Ratio7.Name = "Ratio"
Ratio7.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio7.Size = UDim2.new(1, 0, 0.25, 0)
Ratio7.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio7.BackgroundTransparency = 1
Ratio7.BorderSizePixel = 0
Ratio7.BorderColor3 = Color3.new(0, 0, 0)
Ratio7.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio7.Transparency = 1
Ratio7.Text = "0%"
Ratio7.TextColor3 = Color3.new(1, 0, 0)
Ratio7.TextSize = 14
Ratio7.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio7.TextScaled = true
Ratio7.TextWrapped = true
Ratio7.Parent = Effect7

local Loading7 = Instance.new("Frame")
Loading7.Name = "Loading"
Loading7.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading7.Size = UDim2.new(1, 0, 0.1, 0)
Loading7.BackgroundColor3 = Color3.new(1, 1, 1)
Loading7.BackgroundTransparency = 1
Loading7.BorderSizePixel = 0
Loading7.BorderColor3 = Color3.new(0, 0, 0)
Loading7.ZIndex = 2
Loading7.AnchorPoint = Vector2.new(0.5, 0.5)
Loading7.Transparency = 1
Loading7.Parent = Effect7

local LoadFrame7 = Instance.new("Frame")
LoadFrame7.Name = "LoadFrame"
LoadFrame7.Size = UDim2.new(1, 0, 1, 0)
LoadFrame7.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame7.BorderSizePixel = 0
LoadFrame7.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame7.Parent = Loading7

local UICorner21 = Instance.new("UICorner")
UICorner21.Name = "UICorner"
UICorner21.CornerRadius = UDim.new(1, 0)
UICorner21.Parent = LoadFrame7

local CandyLand = Instance.new("ImageButton")
CandyLand.Name = "CandyLand"
CandyLand.Position = UDim2.new(0.5, 0, 0.27, 0)
CandyLand.Size = UDim2.new(0.25, 0, 0.25, 0)
CandyLand.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
CandyLand.BackgroundTransparency = 0.75
CandyLand.BorderSizePixel = 0
CandyLand.BorderColor3 = Color3.new(0, 0, 0)
CandyLand.AnchorPoint = Vector2.new(0.5, 0.5)
CandyLand.Transparency = 0.75
CandyLand.Image = "rbxassetid://116318136345685"
CandyLand.Parent = Sea3

local UIAspectRatioConstraint8 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint8.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint8.Parent = CandyLand

local UICorner22 = Instance.new("UICorner")
UICorner22.Name = "UICorner"
UICorner22.CornerRadius = UDim.new(0.15, 0)
UICorner22.Parent = CandyLand

local Effect8 = Instance.new("Frame")
Effect8.Name = "Effect"
Effect8.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect8.Size = UDim2.new(1, 0, 1, 0)
Effect8.BackgroundColor3 = Color3.new(0, 0, 0)
Effect8.BackgroundTransparency = 0.15000000596046448
Effect8.BorderSizePixel = 0
Effect8.BorderColor3 = Color3.new(0, 0, 0)
Effect8.AnchorPoint = Vector2.new(0.5, 0.5)
Effect8.Transparency = 0.15000000596046448
Effect8.Parent = CandyLand

local UICorner23 = Instance.new("UICorner")
UICorner23.Name = "UICorner"
UICorner23.CornerRadius = UDim.new(0.15, 0)
UICorner23.Parent = Effect8

local UIGradient8 = Instance.new("UIGradient")
UIGradient8.Name = "UIGradient"
UIGradient8.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient8.Rotation = -90
UIGradient8.Offset = Vector2.new(0, 1)
UIGradient8.Parent = Effect8

local Name8 = Instance.new("TextLabel")
Name8.Name = "Name"
Name8.Position = UDim2.new(0.5, 0, 0.825, 0)
Name8.Size = UDim2.new(1, 0, 0.375, 0)
Name8.BackgroundColor3 = Color3.new(1, 1, 1)
Name8.BackgroundTransparency = 1
Name8.BorderSizePixel = 0
Name8.BorderColor3 = Color3.new(0, 0, 0)
Name8.AnchorPoint = Vector2.new(0.5, 0.5)
Name8.Transparency = 1
Name8.Text = "CandyLand"
Name8.TextColor3 = Color3.new(1, 1, 1)
Name8.TextSize = 14
Name8.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name8.TextScaled = true
Name8.TextWrapped = true
Name8.Parent = Effect8

local CancelButton8 = Instance.new("TextButton")
CancelButton8.Name = "CancelButton"
CancelButton8.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton8.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton8.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton8.BorderSizePixel = 0
CancelButton8.BorderColor3 = Color3.new(0, 0, 0)
CancelButton8.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton8.Text = "Cancel"
CancelButton8.TextColor3 = Color3.new(1, 1, 1)
CancelButton8.TextSize = 14
CancelButton8.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton8.TextScaled = true
CancelButton8.TextWrapped = true
CancelButton8.Parent = Effect8

local UIStroke8 = Instance.new("UIStroke")
UIStroke8.Name = "UIStroke"
UIStroke8.Color = Color3.new(1, 1, 1)
UIStroke8.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke8.Parent = CancelButton8

local Ratio8 = Instance.new("TextLabel")
Ratio8.Name = "Ratio"
Ratio8.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio8.Size = UDim2.new(1, 0, 0.25, 0)
Ratio8.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio8.BackgroundTransparency = 1
Ratio8.BorderSizePixel = 0
Ratio8.BorderColor3 = Color3.new(0, 0, 0)
Ratio8.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio8.Transparency = 1
Ratio8.Text = "0%"
Ratio8.TextColor3 = Color3.new(1, 0, 0)
Ratio8.TextSize = 14
Ratio8.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio8.TextScaled = true
Ratio8.TextWrapped = true
Ratio8.Parent = Effect8

local Loading8 = Instance.new("Frame")
Loading8.Name = "Loading"
Loading8.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading8.Size = UDim2.new(1, 0, 0.1, 0)
Loading8.BackgroundColor3 = Color3.new(1, 1, 1)
Loading8.BackgroundTransparency = 1
Loading8.BorderSizePixel = 0
Loading8.BorderColor3 = Color3.new(0, 0, 0)
Loading8.ZIndex = 2
Loading8.AnchorPoint = Vector2.new(0.5, 0.5)
Loading8.Transparency = 1
Loading8.Parent = Effect8

local LoadFrame8 = Instance.new("Frame")
LoadFrame8.Name = "LoadFrame"
LoadFrame8.Size = UDim2.new(1, 0, 1, 0)
LoadFrame8.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame8.BorderSizePixel = 0
LoadFrame8.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame8.Parent = Loading8

local UICorner24 = Instance.new("UICorner")
UICorner24.Name = "UICorner"
UICorner24.CornerRadius = UDim.new(1, 0)
UICorner24.Parent = LoadFrame8

local Tiki_Outpost = Instance.new("ImageButton")
Tiki_Outpost.Name = "Tiki Outpost"
Tiki_Outpost.Position = UDim2.new(0.8, 0, 0.27, 0)
Tiki_Outpost.Size = UDim2.new(0.25, 0, 0.25, 0)
Tiki_Outpost.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Tiki_Outpost.BackgroundTransparency = 0.75
Tiki_Outpost.BorderSizePixel = 0
Tiki_Outpost.BorderColor3 = Color3.new(0, 0, 0)
Tiki_Outpost.AnchorPoint = Vector2.new(0.5, 0.5)
Tiki_Outpost.Transparency = 0.75
Tiki_Outpost.Image = "rbxassetid://90999317136742"
Tiki_Outpost.Parent = Sea3

local UIAspectRatioConstraint9 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint9.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint9.Parent = Tiki_Outpost

local UICorner25 = Instance.new("UICorner")
UICorner25.Name = "UICorner"
UICorner25.CornerRadius = UDim.new(0.15, 0)
UICorner25.Parent = Tiki_Outpost

local Effect9 = Instance.new("Frame")
Effect9.Name = "Effect"
Effect9.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect9.Size = UDim2.new(1, 0, 1, 0)
Effect9.BackgroundColor3 = Color3.new(0, 0, 0)
Effect9.BackgroundTransparency = 0.15000000596046448
Effect9.BorderSizePixel = 0
Effect9.BorderColor3 = Color3.new(0, 0, 0)
Effect9.AnchorPoint = Vector2.new(0.5, 0.5)
Effect9.Transparency = 0.15000000596046448
Effect9.Parent = Tiki_Outpost

local UICorner26 = Instance.new("UICorner")
UICorner26.Name = "UICorner"
UICorner26.CornerRadius = UDim.new(0.15, 0)
UICorner26.Parent = Effect9

local UIGradient9 = Instance.new("UIGradient")
UIGradient9.Name = "UIGradient"
UIGradient9.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient9.Rotation = -90
UIGradient9.Offset = Vector2.new(0, 1)
UIGradient9.Parent = Effect9

local Name9 = Instance.new("TextLabel")
Name9.Name = "Name"
Name9.Position = UDim2.new(0.5, 0, 0.825, 0)
Name9.Size = UDim2.new(1, 0, 0.375, 0)
Name9.BackgroundColor3 = Color3.new(1, 1, 1)
Name9.BackgroundTransparency = 1
Name9.BorderSizePixel = 0
Name9.BorderColor3 = Color3.new(0, 0, 0)
Name9.AnchorPoint = Vector2.new(0.5, 0.5)
Name9.Transparency = 1
Name9.Text = "Tiki Outpost"
Name9.TextColor3 = Color3.new(1, 1, 1)
Name9.TextSize = 14
Name9.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name9.TextScaled = true
Name9.TextWrapped = true
Name9.Parent = Effect9

local CancelButton9 = Instance.new("TextButton")
CancelButton9.Name = "CancelButton"
CancelButton9.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton9.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton9.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton9.BorderSizePixel = 0
CancelButton9.BorderColor3 = Color3.new(0, 0, 0)
CancelButton9.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton9.Text = "Cancel"
CancelButton9.TextColor3 = Color3.new(1, 1, 1)
CancelButton9.TextSize = 14
CancelButton9.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton9.TextScaled = true
CancelButton9.TextWrapped = true
CancelButton9.Parent = Effect9

local UIStroke9 = Instance.new("UIStroke")
UIStroke9.Name = "UIStroke"
UIStroke9.Color = Color3.new(1, 1, 1)
UIStroke9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke9.Parent = CancelButton9

local Ratio9 = Instance.new("TextLabel")
Ratio9.Name = "Ratio"
Ratio9.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio9.Size = UDim2.new(1, 0, 0.25, 0)
Ratio9.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio9.BackgroundTransparency = 1
Ratio9.BorderSizePixel = 0
Ratio9.BorderColor3 = Color3.new(0, 0, 0)
Ratio9.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio9.Transparency = 1
Ratio9.Text = "0%"
Ratio9.TextColor3 = Color3.new(1, 0, 0)
Ratio9.TextSize = 14
Ratio9.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio9.TextScaled = true
Ratio9.TextWrapped = true
Ratio9.Parent = Effect9

local Loading9 = Instance.new("Frame")
Loading9.Name = "Loading"
Loading9.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading9.Size = UDim2.new(1, 0, 0.1, 0)
Loading9.BackgroundColor3 = Color3.new(1, 1, 1)
Loading9.BackgroundTransparency = 1
Loading9.BorderSizePixel = 0
Loading9.BorderColor3 = Color3.new(0, 0, 0)
Loading9.ZIndex = 2
Loading9.AnchorPoint = Vector2.new(0.5, 0.5)
Loading9.Transparency = 1
Loading9.Parent = Effect9

local LoadFrame9 = Instance.new("Frame")
LoadFrame9.Name = "LoadFrame"
LoadFrame9.Size = UDim2.new(1, 0, 1, 0)
LoadFrame9.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame9.BorderSizePixel = 0
LoadFrame9.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame9.Parent = Loading9

local UICorner27 = Instance.new("UICorner")
UICorner27.Name = "UICorner"
UICorner27.CornerRadius = UDim.new(1, 0)
UICorner27.Parent = LoadFrame9

local Submerged_Island = Instance.new("ImageButton")
Submerged_Island.Name = "Submerged Island"
Submerged_Island.Position = UDim2.new(0.2, 0, 0.375, 0)
Submerged_Island.Size = UDim2.new(0.25, 0, 0.25, 0)
Submerged_Island.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Submerged_Island.BackgroundTransparency = 0.75
Submerged_Island.BorderSizePixel = 0
Submerged_Island.BorderColor3 = Color3.new(0, 0, 0)
Submerged_Island.AnchorPoint = Vector2.new(0.5, 0.5)
Submerged_Island.Transparency = 0.75
Submerged_Island.Image = "rbxassetid://110386080961147"
Submerged_Island.Parent = Sea3

local UIAspectRatioConstraint10 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint10.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint10.Parent = Submerged_Island

local UICorner28 = Instance.new("UICorner")
UICorner28.Name = "UICorner"
UICorner28.CornerRadius = UDim.new(0.15, 0)
UICorner28.Parent = Submerged_Island

local Effect10 = Instance.new("Frame")
Effect10.Name = "Effect"
Effect10.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect10.Size = UDim2.new(1, 0, 1, 0)
Effect10.BackgroundColor3 = Color3.new(0, 0, 0)
Effect10.BackgroundTransparency = 0.15000000596046448
Effect10.BorderSizePixel = 0
Effect10.BorderColor3 = Color3.new(0, 0, 0)
Effect10.AnchorPoint = Vector2.new(0.5, 0.5)
Effect10.Transparency = 0.15000000596046448
Effect10.Parent = Submerged_Island

local UICorner29 = Instance.new("UICorner")
UICorner29.Name = "UICorner"
UICorner29.CornerRadius = UDim.new(0.15, 0)
UICorner29.Parent = Effect10

local UIGradient10 = Instance.new("UIGradient")
UIGradient10.Name = "UIGradient"
UIGradient10.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient10.Rotation = -90
UIGradient10.Offset = Vector2.new(0, 1)
UIGradient10.Parent = Effect10

local Name10 = Instance.new("TextLabel")
Name10.Name = "Name"
Name10.Position = UDim2.new(0.5, 0, 0.825, 0)
Name10.Size = UDim2.new(1, 0, 0.375, 0)
Name10.BackgroundColor3 = Color3.new(1, 1, 1)
Name10.BackgroundTransparency = 1
Name10.BorderSizePixel = 0
Name10.BorderColor3 = Color3.new(0, 0, 0)
Name10.AnchorPoint = Vector2.new(0.5, 0.5)
Name10.Transparency = 1
Name10.Text = "Submerged Island"
Name10.TextColor3 = Color3.new(1, 1, 1)
Name10.TextSize = 14
Name10.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name10.TextScaled = true
Name10.TextWrapped = true
Name10.Parent = Effect10

local CancelButton10 = Instance.new("TextButton")
CancelButton10.Name = "CancelButton"
CancelButton10.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton10.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton10.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton10.BorderSizePixel = 0
CancelButton10.BorderColor3 = Color3.new(0, 0, 0)
CancelButton10.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton10.Text = "Cancel"
CancelButton10.TextColor3 = Color3.new(1, 1, 1)
CancelButton10.TextSize = 14
CancelButton10.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton10.TextScaled = true
CancelButton10.TextWrapped = true
CancelButton10.Parent = Effect10

local UIStroke10 = Instance.new("UIStroke")
UIStroke10.Name = "UIStroke"
UIStroke10.Color = Color3.new(1, 1, 1)
UIStroke10.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke10.Parent = CancelButton10

local Ratio10 = Instance.new("TextLabel")
Ratio10.Name = "Ratio"
Ratio10.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio10.Size = UDim2.new(1, 0, 0.25, 0)
Ratio10.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio10.BackgroundTransparency = 1
Ratio10.BorderSizePixel = 0
Ratio10.BorderColor3 = Color3.new(0, 0, 0)
Ratio10.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio10.Transparency = 1
Ratio10.Text = "0%"
Ratio10.TextColor3 = Color3.new(1, 0, 0)
Ratio10.TextSize = 14
Ratio10.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio10.TextScaled = true
Ratio10.TextWrapped = true
Ratio10.Parent = Effect10

local Loading10 = Instance.new("Frame")
Loading10.Name = "Loading"
Loading10.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading10.Size = UDim2.new(1, 0, 0.1, 0)
Loading10.BackgroundColor3 = Color3.new(1, 1, 1)
Loading10.BackgroundTransparency = 1
Loading10.BorderSizePixel = 0
Loading10.BorderColor3 = Color3.new(0, 0, 0)
Loading10.ZIndex = 2
Loading10.AnchorPoint = Vector2.new(0.5, 0.5)
Loading10.Transparency = 1
Loading10.Parent = Effect10

local LoadFrame10 = Instance.new("Frame")
LoadFrame10.Name = "LoadFrame"
LoadFrame10.Size = UDim2.new(1, 0, 1, 0)
LoadFrame10.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame10.BorderSizePixel = 0
LoadFrame10.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame10.Parent = Loading10

local UICorner30 = Instance.new("UICorner")
UICorner30.Name = "UICorner"
UICorner30.CornerRadius = UDim.new(1, 0)
UICorner30.Parent = LoadFrame10

local Temple_of_Time = Instance.new("ImageButton")
Temple_of_Time.Name = "Temple of Time"
Temple_of_Time.Position = UDim2.new(0.5, 0, 0.375, 0)
Temple_of_Time.Size = UDim2.new(0.25, 0, 0.25, 0)
Temple_of_Time.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Temple_of_Time.BackgroundTransparency = 0.75
Temple_of_Time.BorderSizePixel = 0
Temple_of_Time.BorderColor3 = Color3.new(0, 0, 0)
Temple_of_Time.AnchorPoint = Vector2.new(0.5, 0.5)
Temple_of_Time.Transparency = 0.75
Temple_of_Time.Image = "rbxassetid://104655232452107"
Temple_of_Time.Parent = Sea3

local UIAspectRatioConstraint11 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint11.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint11.Parent = Temple_of_Time

local UICorner31 = Instance.new("UICorner")
UICorner31.Name = "UICorner"
UICorner31.CornerRadius = UDim.new(0.15, 0)
UICorner31.Parent = Temple_of_Time

local Effect11 = Instance.new("Frame")
Effect11.Name = "Effect"
Effect11.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect11.Size = UDim2.new(1, 0, 1, 0)
Effect11.BackgroundColor3 = Color3.new(0, 0, 0)
Effect11.BackgroundTransparency = 0.15000000596046448
Effect11.BorderSizePixel = 0
Effect11.BorderColor3 = Color3.new(0, 0, 0)
Effect11.AnchorPoint = Vector2.new(0.5, 0.5)
Effect11.Transparency = 0.15000000596046448
Effect11.Parent = Temple_of_Time

local UICorner32 = Instance.new("UICorner")
UICorner32.Name = "UICorner"
UICorner32.CornerRadius = UDim.new(0.15, 0)
UICorner32.Parent = Effect11

local UIGradient11 = Instance.new("UIGradient")
UIGradient11.Name = "UIGradient"
UIGradient11.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient11.Rotation = -90
UIGradient11.Offset = Vector2.new(0, 1)
UIGradient11.Parent = Effect11

local Name11 = Instance.new("TextLabel")
Name11.Name = "Name"
Name11.Position = UDim2.new(0.5, 0, 0.825, 0)
Name11.Size = UDim2.new(1, 0, 0.375, 0)
Name11.BackgroundColor3 = Color3.new(1, 1, 1)
Name11.BackgroundTransparency = 1
Name11.BorderSizePixel = 0
Name11.BorderColor3 = Color3.new(0, 0, 0)
Name11.AnchorPoint = Vector2.new(0.5, 0.5)
Name11.Transparency = 1
Name11.Text = "Temple of Time"
Name11.TextColor3 = Color3.new(1, 1, 1)
Name11.TextSize = 14
Name11.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name11.TextScaled = true
Name11.TextWrapped = true
Name11.Parent = Effect11

local CancelButton11 = Instance.new("TextButton")
CancelButton11.Name = "CancelButton"
CancelButton11.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton11.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton11.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton11.BorderSizePixel = 0
CancelButton11.BorderColor3 = Color3.new(0, 0, 0)
CancelButton11.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton11.Text = "Cancel"
CancelButton11.TextColor3 = Color3.new(1, 1, 1)
CancelButton11.TextSize = 14
CancelButton11.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton11.TextScaled = true
CancelButton11.TextWrapped = true
CancelButton11.Parent = Effect11

local UIStroke11 = Instance.new("UIStroke")
UIStroke11.Name = "UIStroke"
UIStroke11.Color = Color3.new(1, 1, 1)
UIStroke11.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke11.Parent = CancelButton11

local Ratio11 = Instance.new("TextLabel")
Ratio11.Name = "Ratio"
Ratio11.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio11.Size = UDim2.new(1, 0, 0.25, 0)
Ratio11.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio11.BackgroundTransparency = 1
Ratio11.BorderSizePixel = 0
Ratio11.BorderColor3 = Color3.new(0, 0, 0)
Ratio11.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio11.Transparency = 1
Ratio11.Text = "0%"
Ratio11.TextColor3 = Color3.new(1, 0, 0)
Ratio11.TextSize = 14
Ratio11.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio11.TextScaled = true
Ratio11.TextWrapped = true
Ratio11.Parent = Effect11

local Loading11 = Instance.new("Frame")
Loading11.Name = "Loading"
Loading11.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading11.Size = UDim2.new(1, 0, 0.1, 0)
Loading11.BackgroundColor3 = Color3.new(1, 1, 1)
Loading11.BackgroundTransparency = 1
Loading11.BorderSizePixel = 0
Loading11.BorderColor3 = Color3.new(0, 0, 0)
Loading11.ZIndex = 2
Loading11.AnchorPoint = Vector2.new(0.5, 0.5)
Loading11.Transparency = 1
Loading11.Parent = Effect11

local LoadFrame11 = Instance.new("Frame")
LoadFrame11.Name = "LoadFrame"
LoadFrame11.Size = UDim2.new(1, 0, 1, 0)
LoadFrame11.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame11.BorderSizePixel = 0
LoadFrame11.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame11.Parent = Loading11

local UICorner33 = Instance.new("UICorner")
UICorner33.Name = "UICorner"
UICorner33.CornerRadius = UDim.new(1, 0)
UICorner33.Parent = LoadFrame11

local Dojo = Instance.new("ImageButton")
Dojo.Name = "Dojo"
Dojo.Position = UDim2.new(0.8, 0, 0.375, 0)
Dojo.Size = UDim2.new(0.25, 0, 0.25, 0)
Dojo.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Dojo.BackgroundTransparency = 0.75
Dojo.BorderSizePixel = 0
Dojo.BorderColor3 = Color3.new(0, 0, 0)
Dojo.AnchorPoint = Vector2.new(0.5, 0.5)
Dojo.Transparency = 0.75
Dojo.Image = "rbxassetid://138249981711954"
Dojo.Parent = Sea3

local UIAspectRatioConstraint12 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint12.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint12.Parent = Dojo

local UICorner34 = Instance.new("UICorner")
UICorner34.Name = "UICorner"
UICorner34.CornerRadius = UDim.new(0.15, 0)
UICorner34.Parent = Dojo

local Effect12 = Instance.new("Frame")
Effect12.Name = "Effect"
Effect12.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect12.Size = UDim2.new(1, 0, 1, 0)
Effect12.BackgroundColor3 = Color3.new(0, 0, 0)
Effect12.BackgroundTransparency = 0.15000000596046448
Effect12.BorderSizePixel = 0
Effect12.BorderColor3 = Color3.new(0, 0, 0)
Effect12.AnchorPoint = Vector2.new(0.5, 0.5)
Effect12.Transparency = 0.15000000596046448
Effect12.Parent = Dojo

local UICorner35 = Instance.new("UICorner")
UICorner35.Name = "UICorner"
UICorner35.CornerRadius = UDim.new(0.15, 0)
UICorner35.Parent = Effect12

local UIGradient12 = Instance.new("UIGradient")
UIGradient12.Name = "UIGradient"
UIGradient12.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient12.Rotation = -90
UIGradient12.Offset = Vector2.new(0, 1)
UIGradient12.Parent = Effect12

local Name12 = Instance.new("TextLabel")
Name12.Name = "Name"
Name12.Position = UDim2.new(0.5, 0, 0.825, 0)
Name12.Size = UDim2.new(1, 0, 0.375, 0)
Name12.BackgroundColor3 = Color3.new(1, 1, 1)
Name12.BackgroundTransparency = 1
Name12.BorderSizePixel = 0
Name12.BorderColor3 = Color3.new(0, 0, 0)
Name12.AnchorPoint = Vector2.new(0.5, 0.5)
Name12.Transparency = 1
Name12.Text = "Dojo"
Name12.TextColor3 = Color3.new(1, 1, 1)
Name12.TextSize = 14
Name12.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name12.TextScaled = true
Name12.TextWrapped = true
Name12.Parent = Effect12

local CancelButton12 = Instance.new("TextButton")
CancelButton12.Name = "CancelButton"
CancelButton12.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton12.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton12.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton12.BorderSizePixel = 0
CancelButton12.BorderColor3 = Color3.new(0, 0, 0)
CancelButton12.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton12.Text = "Cancel"
CancelButton12.TextColor3 = Color3.new(1, 1, 1)
CancelButton12.TextSize = 14
CancelButton12.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton12.TextScaled = true
CancelButton12.TextWrapped = true
CancelButton12.Parent = Effect12

local UIStroke12 = Instance.new("UIStroke")
UIStroke12.Name = "UIStroke"
UIStroke12.Color = Color3.new(1, 1, 1)
UIStroke12.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke12.Parent = CancelButton12

local Ratio12 = Instance.new("TextLabel")
Ratio12.Name = "Ratio"
Ratio12.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio12.Size = UDim2.new(1, 0, 0.25, 0)
Ratio12.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio12.BackgroundTransparency = 1
Ratio12.BorderSizePixel = 0
Ratio12.BorderColor3 = Color3.new(0, 0, 0)
Ratio12.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio12.Transparency = 1
Ratio12.Text = "0%"
Ratio12.TextColor3 = Color3.new(1, 0, 0)
Ratio12.TextSize = 14
Ratio12.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio12.TextScaled = true
Ratio12.TextWrapped = true
Ratio12.Parent = Effect12

local Loading12 = Instance.new("Frame")
Loading12.Name = "Loading"
Loading12.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading12.Size = UDim2.new(1, 0, 0.1, 0)
Loading12.BackgroundColor3 = Color3.new(1, 1, 1)
Loading12.BackgroundTransparency = 1
Loading12.BorderSizePixel = 0
Loading12.BorderColor3 = Color3.new(0, 0, 0)
Loading12.ZIndex = 2
Loading12.AnchorPoint = Vector2.new(0.5, 0.5)
Loading12.Transparency = 1
Loading12.Parent = Effect12

local LoadFrame12 = Instance.new("Frame")
LoadFrame12.Name = "LoadFrame"
LoadFrame12.Size = UDim2.new(1, 0, 1, 0)
LoadFrame12.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame12.BorderSizePixel = 0
LoadFrame12.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame12.Parent = Loading12

local UICorner36 = Instance.new("UICorner")
UICorner36.Name = "UICorner"
UICorner36.CornerRadius = UDim.new(1, 0)
UICorner36.Parent = LoadFrame12

local Castle_on_the_Sea = Instance.new("ImageButton")
Castle_on_the_Sea.Name = "Castle on the Sea"
Castle_on_the_Sea.Position = UDim2.new(0.2, 0, 0.48, 0)
Castle_on_the_Sea.Size = UDim2.new(0.25, 0, 0.25, 0)
Castle_on_the_Sea.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Castle_on_the_Sea.BackgroundTransparency = 0.75
Castle_on_the_Sea.BorderSizePixel = 0
Castle_on_the_Sea.BorderColor3 = Color3.new(0, 0, 0)
Castle_on_the_Sea.AnchorPoint = Vector2.new(0.5, 0.5)
Castle_on_the_Sea.Transparency = 0.75
Castle_on_the_Sea.Image = "rbxassetid://97420848058237"
Castle_on_the_Sea.Parent = Sea3

local UIAspectRatioConstraint13 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint13.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint13.Parent = Castle_on_the_Sea

local UICorner37 = Instance.new("UICorner")
UICorner37.Name = "UICorner"
UICorner37.CornerRadius = UDim.new(0.15, 0)
UICorner37.Parent = Castle_on_the_Sea

local Effect13 = Instance.new("Frame")
Effect13.Name = "Effect"
Effect13.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect13.Size = UDim2.new(1, 0, 1, 0)
Effect13.BackgroundColor3 = Color3.new(0, 0, 0)
Effect13.BackgroundTransparency = 0.15000000596046448
Effect13.BorderSizePixel = 0
Effect13.BorderColor3 = Color3.new(0, 0, 0)
Effect13.AnchorPoint = Vector2.new(0.5, 0.5)
Effect13.Transparency = 0.15000000596046448
Effect13.Parent = Castle_on_the_Sea

local UICorner38 = Instance.new("UICorner")
UICorner38.Name = "UICorner"
UICorner38.CornerRadius = UDim.new(0.15, 0)
UICorner38.Parent = Effect13

local UIGradient13 = Instance.new("UIGradient")
UIGradient13.Name = "UIGradient"
UIGradient13.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient13.Rotation = -90
UIGradient13.Offset = Vector2.new(0, 1)
UIGradient13.Parent = Effect13

local Name13 = Instance.new("TextLabel")
Name13.Name = "Name"
Name13.Position = UDim2.new(0.5, 0, 0.825, 0)
Name13.Size = UDim2.new(1, 0, 0.375, 0)
Name13.BackgroundColor3 = Color3.new(1, 1, 1)
Name13.BackgroundTransparency = 1
Name13.BorderSizePixel = 0
Name13.BorderColor3 = Color3.new(0, 0, 0)
Name13.AnchorPoint = Vector2.new(0.5, 0.5)
Name13.Transparency = 1
Name13.Text = "Castle on the Sea"
Name13.TextColor3 = Color3.new(1, 1, 1)
Name13.TextSize = 14
Name13.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name13.TextScaled = true
Name13.TextWrapped = true
Name13.Parent = Effect13

local CancelButton13 = Instance.new("TextButton")
CancelButton13.Name = "CancelButton"
CancelButton13.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton13.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton13.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton13.BorderSizePixel = 0
CancelButton13.BorderColor3 = Color3.new(0, 0, 0)
CancelButton13.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton13.Text = "Cancel"
CancelButton13.TextColor3 = Color3.new(1, 1, 1)
CancelButton13.TextSize = 14
CancelButton13.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton13.TextScaled = true
CancelButton13.TextWrapped = true
CancelButton13.Parent = Effect13

local UIStroke13 = Instance.new("UIStroke")
UIStroke13.Name = "UIStroke"
UIStroke13.Color = Color3.new(1, 1, 1)
UIStroke13.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke13.Parent = CancelButton13

local Ratio13 = Instance.new("TextLabel")
Ratio13.Name = "Ratio"
Ratio13.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio13.Size = UDim2.new(1, 0, 0.25, 0)
Ratio13.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio13.BackgroundTransparency = 1
Ratio13.BorderSizePixel = 0
Ratio13.BorderColor3 = Color3.new(0, 0, 0)
Ratio13.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio13.Transparency = 1
Ratio13.Text = "0%"
Ratio13.TextColor3 = Color3.new(1, 0, 0)
Ratio13.TextSize = 14
Ratio13.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio13.TextScaled = true
Ratio13.TextWrapped = true
Ratio13.Parent = Effect13

local Loading13 = Instance.new("Frame")
Loading13.Name = "Loading"
Loading13.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading13.Size = UDim2.new(1, 0, 0.1, 0)
Loading13.BackgroundColor3 = Color3.new(1, 1, 1)
Loading13.BackgroundTransparency = 1
Loading13.BorderSizePixel = 0
Loading13.BorderColor3 = Color3.new(0, 0, 0)
Loading13.ZIndex = 2
Loading13.AnchorPoint = Vector2.new(0.5, 0.5)
Loading13.Transparency = 1
Loading13.Parent = Effect13

local LoadFrame13 = Instance.new("Frame")
LoadFrame13.Name = "LoadFrame"
LoadFrame13.Size = UDim2.new(1, 0, 1, 0)
LoadFrame13.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame13.BorderSizePixel = 0
LoadFrame13.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame13.Parent = Loading13

local UICorner39 = Instance.new("UICorner")
UICorner39.Name = "UICorner"
UICorner39.CornerRadius = UDim.new(1, 0)
UICorner39.Parent = LoadFrame13

local AnimationUI = Instance.new("Folder")
AnimationUI.Name = "AnimationUI"

AnimationUI.Parent = Island

local Animation1 = Instance.new("ImageLabel")
Animation1.Name = "Animation1"
Animation1.Position = UDim2.new(1, 0, -1, 0)
Animation1.Size = UDim2.new(3, 0, 3, 0)
Animation1.BackgroundColor3 = Color3.new(1, 1, 1)
Animation1.BackgroundTransparency = 1
Animation1.BorderSizePixel = 0
Animation1.BorderColor3 = Color3.new(0, 0, 0)
Animation1.AnchorPoint = Vector2.new(0.5, 0.5)
Animation1.Transparency = 1
Animation1.Image = "rbxassetid://129177850900145"
Animation1.Parent = AnimationUI

local UIAspectRatioConstraint14 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint14.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint14.Parent = Animation1

local Animation2 = Instance.new("ImageLabel")
Animation2.Name = "Animation2"
Animation2.Position = UDim2.new(1, 0, -1, 0)
Animation2.Size = UDim2.new(3, 0, 3, 0)
Animation2.BackgroundColor3 = Color3.new(1, 1, 1)
Animation2.BackgroundTransparency = 1
Animation2.BorderSizePixel = 0
Animation2.BorderColor3 = Color3.new(0, 0, 0)
Animation2.AnchorPoint = Vector2.new(0.5, 0.5)
Animation2.Transparency = 1
Animation2.Image = "rbxassetid://136264391077433"
Animation2.Parent = AnimationUI

local UIAspectRatioConstraint15 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint15.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint15.Parent = Animation2

local Animation3 = Instance.new("ImageLabel")
Animation3.Name = "Animation3"
Animation3.Position = UDim2.new(1, 0, -1, 0)
Animation3.Size = UDim2.new(3, 0, 3, 0)
Animation3.BackgroundColor3 = Color3.new(1, 1, 1)
Animation3.BackgroundTransparency = 1
Animation3.BorderSizePixel = 0
Animation3.BorderColor3 = Color3.new(0, 0, 0)
Animation3.AnchorPoint = Vector2.new(0.5, 0.5)
Animation3.Transparency = 1
Animation3.Image = "rbxassetid://83842772196587"
Animation3.Parent = AnimationUI

local UIAspectRatioConstraint16 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint16.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint16.Parent = Animation3

local Animation4 = Instance.new("ImageLabel")
Animation4.Name = "Animation4"
Animation4.Position = UDim2.new(1, 0, -1, 0)
Animation4.Size = UDim2.new(3, 0, 3, 0)
Animation4.BackgroundColor3 = Color3.new(1, 1, 1)
Animation4.BackgroundTransparency = 1
Animation4.BorderSizePixel = 0
Animation4.BorderColor3 = Color3.new(0, 0, 0)
Animation4.AnchorPoint = Vector2.new(0.5, 0.5)
Animation4.Transparency = 1
Animation4.Image = "rbxassetid://122646000251611"
Animation4.Parent = AnimationUI

local UIAspectRatioConstraint17 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint17.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint17.Parent = Animation4

local Animation5 = Instance.new("ImageLabel")
Animation5.Name = "Animation5"
Animation5.Position = UDim2.new(1, 0, -1, 0)
Animation5.Size = UDim2.new(3, 0, 3, 0)
Animation5.BackgroundColor3 = Color3.new(1, 1, 1)
Animation5.BackgroundTransparency = 1
Animation5.BorderSizePixel = 0
Animation5.BorderColor3 = Color3.new(0, 0, 0)
Animation5.AnchorPoint = Vector2.new(0.5, 0.5)
Animation5.Transparency = 1
Animation5.Image = "rbxassetid://106237063049048"
Animation5.Parent = AnimationUI

local UIAspectRatioConstraint18 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint18.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint18.Parent = Animation5

local Sea1 = Instance.new("Folder")
Sea1.Name = "Sea1"

Sea1.Parent = Island

local Sea2 = Instance.new("Folder")
Sea2.Name = "Sea2"

Sea2.Parent = Island

local Frame = Island
if not Frame then return end
task.spawn(function()
	while true do
		local allOk = true
		for _, obj in ipairs(Frame:GetDescendants()) do
			if obj:IsA("TextButton") then
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
