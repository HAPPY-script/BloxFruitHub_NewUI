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
Hydra_Island.Visible = false
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
Port_Town.Visible = false
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
Great_Tree.Visible = false
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
Mansion.Visible = false
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
Haunted_Castle.Visible = false
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
IcecreamLand.Visible = false
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
CakeLand.Visible = false
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
CandyLand.Visible = false
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
Tiki_Outpost.Visible = false
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
Submerged_Island.Visible = false
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
Temple_of_Time.Visible = false
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
Dojo.Visible = false
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
Castle_on_the_Sea.Visible = false
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

local UIAspectRatioConstraint14 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint14.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint14.Parent = Animation2

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

local UIAspectRatioConstraint15 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint15.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint15.Parent = Animation3

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

local UIAspectRatioConstraint16 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint16.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint16.Parent = Animation4

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

local UIAspectRatioConstraint17 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint17.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint17.Parent = Animation5

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

local UIAspectRatioConstraint18 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint18.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint18.Parent = Animation1

local Sea1 = Instance.new("Folder")
Sea1.Name = "Sea1"

Sea1.Parent = Island

local Sea2 = Instance.new("Folder")
Sea2.Name = "Sea2"

Sea2.Parent = Island

local Cafe = Instance.new("ImageButton")
Cafe.Name = "Cafe"
Cafe.Position = UDim2.new(0.2, 0, 0.06, 0)
Cafe.Size = UDim2.new(0.25, 0, 0.25, 0)
Cafe.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Cafe.BackgroundTransparency = 0.75
Cafe.BorderSizePixel = 0
Cafe.BorderColor3 = Color3.new(0, 0, 0)
Cafe.AnchorPoint = Vector2.new(0.5, 0.5)
Cafe.Transparency = 0.75
Cafe.Image = "rbxassetid://130347540308634"
Cafe.Parent = Sea2

local UIAspectRatioConstraint19 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint19.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint19.Parent = Cafe

local UICorner40 = Instance.new("UICorner")
UICorner40.Name = "UICorner"
UICorner40.CornerRadius = UDim.new(0.15, 0)
UICorner40.Parent = Cafe

local Effect14 = Instance.new("Frame")
Effect14.Name = "Effect"
Effect14.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect14.Size = UDim2.new(1, 0, 1, 0)
Effect14.BackgroundColor3 = Color3.new(0, 0, 0)
Effect14.BackgroundTransparency = 0.15000000596046448
Effect14.BorderSizePixel = 0
Effect14.BorderColor3 = Color3.new(0, 0, 0)
Effect14.AnchorPoint = Vector2.new(0.5, 0.5)
Effect14.Transparency = 0.15000000596046448
Effect14.Parent = Cafe

local UICorner41 = Instance.new("UICorner")
UICorner41.Name = "UICorner"
UICorner41.CornerRadius = UDim.new(0.15, 0)
UICorner41.Parent = Effect14

local UIGradient14 = Instance.new("UIGradient")
UIGradient14.Name = "UIGradient"
UIGradient14.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient14.Rotation = -90
UIGradient14.Offset = Vector2.new(0, 1)
UIGradient14.Parent = Effect14

local Name14 = Instance.new("TextLabel")
Name14.Name = "Name"
Name14.Position = UDim2.new(0.5, 0, 0.825, 0)
Name14.Size = UDim2.new(1, 0, 0.375, 0)
Name14.BackgroundColor3 = Color3.new(1, 1, 1)
Name14.BackgroundTransparency = 1
Name14.BorderSizePixel = 0
Name14.BorderColor3 = Color3.new(0, 0, 0)
Name14.AnchorPoint = Vector2.new(0.5, 0.5)
Name14.Transparency = 1
Name14.Text = "Cafe"
Name14.TextColor3 = Color3.new(1, 1, 1)
Name14.TextSize = 14
Name14.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name14.TextScaled = true
Name14.TextWrapped = true
Name14.Parent = Effect14

local CancelButton14 = Instance.new("TextButton")
CancelButton14.Name = "CancelButton"
CancelButton14.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton14.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton14.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton14.BorderSizePixel = 0
CancelButton14.BorderColor3 = Color3.new(0, 0, 0)
CancelButton14.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton14.Text = "Cancel"
CancelButton14.TextColor3 = Color3.new(1, 1, 1)
CancelButton14.TextSize = 14
CancelButton14.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton14.TextScaled = true
CancelButton14.TextWrapped = true
CancelButton14.Parent = Effect14

local UIStroke14 = Instance.new("UIStroke")
UIStroke14.Name = "UIStroke"
UIStroke14.Color = Color3.new(1, 1, 1)
UIStroke14.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke14.Parent = CancelButton14

local Ratio14 = Instance.new("TextLabel")
Ratio14.Name = "Ratio"
Ratio14.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio14.Size = UDim2.new(1, 0, 0.25, 0)
Ratio14.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio14.BackgroundTransparency = 1
Ratio14.BorderSizePixel = 0
Ratio14.BorderColor3 = Color3.new(0, 0, 0)
Ratio14.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio14.Transparency = 1
Ratio14.Text = "0%"
Ratio14.TextColor3 = Color3.new(1, 0, 0)
Ratio14.TextSize = 14
Ratio14.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio14.TextScaled = true
Ratio14.TextWrapped = true
Ratio14.Parent = Effect14

local Loading14 = Instance.new("Frame")
Loading14.Name = "Loading"
Loading14.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading14.Size = UDim2.new(1, 0, 0.1, 0)
Loading14.BackgroundColor3 = Color3.new(1, 1, 1)
Loading14.BackgroundTransparency = 1
Loading14.BorderSizePixel = 0
Loading14.BorderColor3 = Color3.new(0, 0, 0)
Loading14.ZIndex = 2
Loading14.AnchorPoint = Vector2.new(0.5, 0.5)
Loading14.Transparency = 1
Loading14.Parent = Effect14

local LoadFrame14 = Instance.new("Frame")
LoadFrame14.Name = "LoadFrame"
LoadFrame14.Size = UDim2.new(1, 0, 1, 0)
LoadFrame14.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame14.BorderSizePixel = 0
LoadFrame14.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame14.Parent = Loading14

local UICorner42 = Instance.new("UICorner")
UICorner42.Name = "UICorner"
UICorner42.CornerRadius = UDim.new(1, 0)
UICorner42.Parent = LoadFrame14

local Factory = Instance.new("ImageButton")
Factory.Name = "Factory"
Factory.Position = UDim2.new(0.5, 0, 0.06, 0)
Factory.Size = UDim2.new(0.25, 0, 0.25, 0)
Factory.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Factory.BackgroundTransparency = 0.75
Factory.BorderSizePixel = 0
Factory.BorderColor3 = Color3.new(0, 0, 0)
Factory.AnchorPoint = Vector2.new(0.5, 0.5)
Factory.Transparency = 0.75
Factory.Image = "rbxassetid://110936326414018"
Factory.Parent = Sea2

local UIAspectRatioConstraint20 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint20.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint20.Parent = Factory

local UICorner43 = Instance.new("UICorner")
UICorner43.Name = "UICorner"
UICorner43.CornerRadius = UDim.new(0.15, 0)
UICorner43.Parent = Factory

local Effect15 = Instance.new("Frame")
Effect15.Name = "Effect"
Effect15.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect15.Size = UDim2.new(1, 0, 1, 0)
Effect15.BackgroundColor3 = Color3.new(0, 0, 0)
Effect15.BackgroundTransparency = 0.15000000596046448
Effect15.BorderSizePixel = 0
Effect15.BorderColor3 = Color3.new(0, 0, 0)
Effect15.AnchorPoint = Vector2.new(0.5, 0.5)
Effect15.Transparency = 0.15000000596046448
Effect15.Parent = Factory

local UICorner44 = Instance.new("UICorner")
UICorner44.Name = "UICorner"
UICorner44.CornerRadius = UDim.new(0.15, 0)
UICorner44.Parent = Effect15

local UIGradient15 = Instance.new("UIGradient")
UIGradient15.Name = "UIGradient"
UIGradient15.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient15.Rotation = -90
UIGradient15.Offset = Vector2.new(0, 1)
UIGradient15.Parent = Effect15

local Name15 = Instance.new("TextLabel")
Name15.Name = "Name"
Name15.Position = UDim2.new(0.5, 0, 0.825, 0)
Name15.Size = UDim2.new(1, 0, 0.375, 0)
Name15.BackgroundColor3 = Color3.new(1, 1, 1)
Name15.BackgroundTransparency = 1
Name15.BorderSizePixel = 0
Name15.BorderColor3 = Color3.new(0, 0, 0)
Name15.AnchorPoint = Vector2.new(0.5, 0.5)
Name15.Transparency = 1
Name15.Text = "Factory"
Name15.TextColor3 = Color3.new(1, 1, 1)
Name15.TextSize = 14
Name15.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name15.TextScaled = true
Name15.TextWrapped = true
Name15.Parent = Effect15

local CancelButton15 = Instance.new("TextButton")
CancelButton15.Name = "CancelButton"
CancelButton15.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton15.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton15.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton15.BorderSizePixel = 0
CancelButton15.BorderColor3 = Color3.new(0, 0, 0)
CancelButton15.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton15.Text = "Cancel"
CancelButton15.TextColor3 = Color3.new(1, 1, 1)
CancelButton15.TextSize = 14
CancelButton15.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton15.TextScaled = true
CancelButton15.TextWrapped = true
CancelButton15.Parent = Effect15

local UIStroke15 = Instance.new("UIStroke")
UIStroke15.Name = "UIStroke"
UIStroke15.Color = Color3.new(1, 1, 1)
UIStroke15.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke15.Parent = CancelButton15

local Ratio15 = Instance.new("TextLabel")
Ratio15.Name = "Ratio"
Ratio15.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio15.Size = UDim2.new(1, 0, 0.25, 0)
Ratio15.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio15.BackgroundTransparency = 1
Ratio15.BorderSizePixel = 0
Ratio15.BorderColor3 = Color3.new(0, 0, 0)
Ratio15.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio15.Transparency = 1
Ratio15.Text = "0%"
Ratio15.TextColor3 = Color3.new(1, 0, 0)
Ratio15.TextSize = 14
Ratio15.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio15.TextScaled = true
Ratio15.TextWrapped = true
Ratio15.Parent = Effect15

local Loading15 = Instance.new("Frame")
Loading15.Name = "Loading"
Loading15.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading15.Size = UDim2.new(1, 0, 0.1, 0)
Loading15.BackgroundColor3 = Color3.new(1, 1, 1)
Loading15.BackgroundTransparency = 1
Loading15.BorderSizePixel = 0
Loading15.BorderColor3 = Color3.new(0, 0, 0)
Loading15.ZIndex = 2
Loading15.AnchorPoint = Vector2.new(0.5, 0.5)
Loading15.Transparency = 1
Loading15.Parent = Effect15

local LoadFrame15 = Instance.new("Frame")
LoadFrame15.Name = "LoadFrame"
LoadFrame15.Size = UDim2.new(1, 0, 1, 0)
LoadFrame15.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame15.BorderSizePixel = 0
LoadFrame15.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame15.Parent = Loading15

local UICorner45 = Instance.new("UICorner")
UICorner45.Name = "UICorner"
UICorner45.CornerRadius = UDim.new(1, 0)
UICorner45.Parent = LoadFrame15

local Swan_Room = Instance.new("ImageButton")
Swan_Room.Name = "Swan Room"
Swan_Room.Position = UDim2.new(0.8, 0, 0.06, 0)
Swan_Room.Size = UDim2.new(0.25, 0, 0.25, 0)
Swan_Room.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Swan_Room.BackgroundTransparency = 0.75
Swan_Room.BorderSizePixel = 0
Swan_Room.BorderColor3 = Color3.new(0, 0, 0)
Swan_Room.AnchorPoint = Vector2.new(0.5, 0.5)
Swan_Room.Transparency = 0.75
Swan_Room.Image = "rbxassetid://114497290613799"
Swan_Room.Parent = Sea2

local UIAspectRatioConstraint21 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint21.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint21.Parent = Swan_Room

local UICorner46 = Instance.new("UICorner")
UICorner46.Name = "UICorner"
UICorner46.CornerRadius = UDim.new(0.15, 0)
UICorner46.Parent = Swan_Room

local Effect16 = Instance.new("Frame")
Effect16.Name = "Effect"
Effect16.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect16.Size = UDim2.new(1, 0, 1, 0)
Effect16.BackgroundColor3 = Color3.new(0, 0, 0)
Effect16.BackgroundTransparency = 0.15000000596046448
Effect16.BorderSizePixel = 0
Effect16.BorderColor3 = Color3.new(0, 0, 0)
Effect16.AnchorPoint = Vector2.new(0.5, 0.5)
Effect16.Transparency = 0.15000000596046448
Effect16.Parent = Swan_Room

local UICorner47 = Instance.new("UICorner")
UICorner47.Name = "UICorner"
UICorner47.CornerRadius = UDim.new(0.15, 0)
UICorner47.Parent = Effect16

local UIGradient16 = Instance.new("UIGradient")
UIGradient16.Name = "UIGradient"
UIGradient16.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient16.Rotation = -90
UIGradient16.Offset = Vector2.new(0, 1)
UIGradient16.Parent = Effect16

local Name16 = Instance.new("TextLabel")
Name16.Name = "Name"
Name16.Position = UDim2.new(0.5, 0, 0.825, 0)
Name16.Size = UDim2.new(1, 0, 0.375, 0)
Name16.BackgroundColor3 = Color3.new(1, 1, 1)
Name16.BackgroundTransparency = 1
Name16.BorderSizePixel = 0
Name16.BorderColor3 = Color3.new(0, 0, 0)
Name16.AnchorPoint = Vector2.new(0.5, 0.5)
Name16.Transparency = 1
Name16.Text = "Swan Room"
Name16.TextColor3 = Color3.new(1, 1, 1)
Name16.TextSize = 14
Name16.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name16.TextScaled = true
Name16.TextWrapped = true
Name16.Parent = Effect16

local CancelButton16 = Instance.new("TextButton")
CancelButton16.Name = "CancelButton"
CancelButton16.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton16.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton16.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton16.BorderSizePixel = 0
CancelButton16.BorderColor3 = Color3.new(0, 0, 0)
CancelButton16.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton16.Text = "Cancel"
CancelButton16.TextColor3 = Color3.new(1, 1, 1)
CancelButton16.TextSize = 14
CancelButton16.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton16.TextScaled = true
CancelButton16.TextWrapped = true
CancelButton16.Parent = Effect16

local UIStroke16 = Instance.new("UIStroke")
UIStroke16.Name = "UIStroke"
UIStroke16.Color = Color3.new(1, 1, 1)
UIStroke16.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke16.Parent = CancelButton16

local Ratio16 = Instance.new("TextLabel")
Ratio16.Name = "Ratio"
Ratio16.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio16.Size = UDim2.new(1, 0, 0.25, 0)
Ratio16.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio16.BackgroundTransparency = 1
Ratio16.BorderSizePixel = 0
Ratio16.BorderColor3 = Color3.new(0, 0, 0)
Ratio16.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio16.Transparency = 1
Ratio16.Text = "0%"
Ratio16.TextColor3 = Color3.new(1, 0, 0)
Ratio16.TextSize = 14
Ratio16.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio16.TextScaled = true
Ratio16.TextWrapped = true
Ratio16.Parent = Effect16

local Loading16 = Instance.new("Frame")
Loading16.Name = "Loading"
Loading16.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading16.Size = UDim2.new(1, 0, 0.1, 0)
Loading16.BackgroundColor3 = Color3.new(1, 1, 1)
Loading16.BackgroundTransparency = 1
Loading16.BorderSizePixel = 0
Loading16.BorderColor3 = Color3.new(0, 0, 0)
Loading16.ZIndex = 2
Loading16.AnchorPoint = Vector2.new(0.5, 0.5)
Loading16.Transparency = 1
Loading16.Parent = Effect16

local LoadFrame16 = Instance.new("Frame")
LoadFrame16.Name = "LoadFrame"
LoadFrame16.Size = UDim2.new(1, 0, 1, 0)
LoadFrame16.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame16.BorderSizePixel = 0
LoadFrame16.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame16.Parent = Loading16

local UICorner48 = Instance.new("UICorner")
UICorner48.Name = "UICorner"
UICorner48.CornerRadius = UDim.new(1, 0)
UICorner48.Parent = LoadFrame16

local Green_Zone = Instance.new("ImageButton")
Green_Zone.Name = "Green Zone"
Green_Zone.Position = UDim2.new(0.2, 0, 0.165, 0)
Green_Zone.Size = UDim2.new(0.25, 0, 0.25, 0)
Green_Zone.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Green_Zone.BackgroundTransparency = 0.75
Green_Zone.BorderSizePixel = 0
Green_Zone.BorderColor3 = Color3.new(0, 0, 0)
Green_Zone.AnchorPoint = Vector2.new(0.5, 0.5)
Green_Zone.Transparency = 0.75
Green_Zone.Image = "rbxassetid://91026341302713"
Green_Zone.Parent = Sea2

local UIAspectRatioConstraint22 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint22.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint22.Parent = Green_Zone

local UICorner49 = Instance.new("UICorner")
UICorner49.Name = "UICorner"
UICorner49.CornerRadius = UDim.new(0.15, 0)
UICorner49.Parent = Green_Zone

local Effect17 = Instance.new("Frame")
Effect17.Name = "Effect"
Effect17.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect17.Size = UDim2.new(1, 0, 1, 0)
Effect17.BackgroundColor3 = Color3.new(0, 0, 0)
Effect17.BackgroundTransparency = 0.15000000596046448
Effect17.BorderSizePixel = 0
Effect17.BorderColor3 = Color3.new(0, 0, 0)
Effect17.AnchorPoint = Vector2.new(0.5, 0.5)
Effect17.Transparency = 0.15000000596046448
Effect17.Parent = Green_Zone

local UICorner50 = Instance.new("UICorner")
UICorner50.Name = "UICorner"
UICorner50.CornerRadius = UDim.new(0.15, 0)
UICorner50.Parent = Effect17

local UIGradient17 = Instance.new("UIGradient")
UIGradient17.Name = "UIGradient"
UIGradient17.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient17.Rotation = -90
UIGradient17.Offset = Vector2.new(0, 1)
UIGradient17.Parent = Effect17

local Name17 = Instance.new("TextLabel")
Name17.Name = "Name"
Name17.Position = UDim2.new(0.5, 0, 0.825, 0)
Name17.Size = UDim2.new(1, 0, 0.375, 0)
Name17.BackgroundColor3 = Color3.new(1, 1, 1)
Name17.BackgroundTransparency = 1
Name17.BorderSizePixel = 0
Name17.BorderColor3 = Color3.new(0, 0, 0)
Name17.AnchorPoint = Vector2.new(0.5, 0.5)
Name17.Transparency = 1
Name17.Text = "Green Zone"
Name17.TextColor3 = Color3.new(1, 1, 1)
Name17.TextSize = 14
Name17.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name17.TextScaled = true
Name17.TextWrapped = true
Name17.Parent = Effect17

local CancelButton17 = Instance.new("TextButton")
CancelButton17.Name = "CancelButton"
CancelButton17.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton17.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton17.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton17.BorderSizePixel = 0
CancelButton17.BorderColor3 = Color3.new(0, 0, 0)
CancelButton17.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton17.Text = "Cancel"
CancelButton17.TextColor3 = Color3.new(1, 1, 1)
CancelButton17.TextSize = 14
CancelButton17.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton17.TextScaled = true
CancelButton17.TextWrapped = true
CancelButton17.Parent = Effect17

local UIStroke17 = Instance.new("UIStroke")
UIStroke17.Name = "UIStroke"
UIStroke17.Color = Color3.new(1, 1, 1)
UIStroke17.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke17.Parent = CancelButton17

local Ratio17 = Instance.new("TextLabel")
Ratio17.Name = "Ratio"
Ratio17.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio17.Size = UDim2.new(1, 0, 0.25, 0)
Ratio17.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio17.BackgroundTransparency = 1
Ratio17.BorderSizePixel = 0
Ratio17.BorderColor3 = Color3.new(0, 0, 0)
Ratio17.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio17.Transparency = 1
Ratio17.Text = "0%"
Ratio17.TextColor3 = Color3.new(1, 0, 0)
Ratio17.TextSize = 14
Ratio17.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio17.TextScaled = true
Ratio17.TextWrapped = true
Ratio17.Parent = Effect17

local Loading17 = Instance.new("Frame")
Loading17.Name = "Loading"
Loading17.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading17.Size = UDim2.new(1, 0, 0.1, 0)
Loading17.BackgroundColor3 = Color3.new(1, 1, 1)
Loading17.BackgroundTransparency = 1
Loading17.BorderSizePixel = 0
Loading17.BorderColor3 = Color3.new(0, 0, 0)
Loading17.ZIndex = 2
Loading17.AnchorPoint = Vector2.new(0.5, 0.5)
Loading17.Transparency = 1
Loading17.Parent = Effect17

local LoadFrame17 = Instance.new("Frame")
LoadFrame17.Name = "LoadFrame"
LoadFrame17.Size = UDim2.new(1, 0, 1, 0)
LoadFrame17.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame17.BorderSizePixel = 0
LoadFrame17.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame17.Parent = Loading17

local UICorner51 = Instance.new("UICorner")
UICorner51.Name = "UICorner"
UICorner51.CornerRadius = UDim.new(1, 0)
UICorner51.Parent = LoadFrame17

local Graveyard_Island = Instance.new("ImageButton")
Graveyard_Island.Name = "Graveyard Island"
Graveyard_Island.Position = UDim2.new(0.5, 0, 0.165, 0)
Graveyard_Island.Size = UDim2.new(0.25, 0, 0.25, 0)
Graveyard_Island.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Graveyard_Island.BackgroundTransparency = 0.75
Graveyard_Island.BorderSizePixel = 0
Graveyard_Island.BorderColor3 = Color3.new(0, 0, 0)
Graveyard_Island.AnchorPoint = Vector2.new(0.5, 0.5)
Graveyard_Island.Transparency = 0.75
Graveyard_Island.Image = "rbxassetid://109176559760741"
Graveyard_Island.Parent = Sea2

local UIAspectRatioConstraint23 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint23.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint23.Parent = Graveyard_Island

local UICorner52 = Instance.new("UICorner")
UICorner52.Name = "UICorner"
UICorner52.CornerRadius = UDim.new(0.15, 0)
UICorner52.Parent = Graveyard_Island

local Effect18 = Instance.new("Frame")
Effect18.Name = "Effect"
Effect18.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect18.Size = UDim2.new(1, 0, 1, 0)
Effect18.BackgroundColor3 = Color3.new(0, 0, 0)
Effect18.BackgroundTransparency = 0.15000000596046448
Effect18.BorderSizePixel = 0
Effect18.BorderColor3 = Color3.new(0, 0, 0)
Effect18.AnchorPoint = Vector2.new(0.5, 0.5)
Effect18.Transparency = 0.15000000596046448
Effect18.Parent = Graveyard_Island

local UICorner53 = Instance.new("UICorner")
UICorner53.Name = "UICorner"
UICorner53.CornerRadius = UDim.new(0.15, 0)
UICorner53.Parent = Effect18

local UIGradient18 = Instance.new("UIGradient")
UIGradient18.Name = "UIGradient"
UIGradient18.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient18.Rotation = -90
UIGradient18.Offset = Vector2.new(0, 1)
UIGradient18.Parent = Effect18

local Name18 = Instance.new("TextLabel")
Name18.Name = "Name"
Name18.Position = UDim2.new(0.5, 0, 0.825, 0)
Name18.Size = UDim2.new(1, 0, 0.375, 0)
Name18.BackgroundColor3 = Color3.new(1, 1, 1)
Name18.BackgroundTransparency = 1
Name18.BorderSizePixel = 0
Name18.BorderColor3 = Color3.new(0, 0, 0)
Name18.AnchorPoint = Vector2.new(0.5, 0.5)
Name18.Transparency = 1
Name18.Text = "Graveyard Island"
Name18.TextColor3 = Color3.new(1, 1, 1)
Name18.TextSize = 14
Name18.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name18.TextScaled = true
Name18.TextWrapped = true
Name18.Parent = Effect18

local CancelButton18 = Instance.new("TextButton")
CancelButton18.Name = "CancelButton"
CancelButton18.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton18.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton18.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton18.BorderSizePixel = 0
CancelButton18.BorderColor3 = Color3.new(0, 0, 0)
CancelButton18.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton18.Text = "Cancel"
CancelButton18.TextColor3 = Color3.new(1, 1, 1)
CancelButton18.TextSize = 14
CancelButton18.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton18.TextScaled = true
CancelButton18.TextWrapped = true
CancelButton18.Parent = Effect18

local UIStroke18 = Instance.new("UIStroke")
UIStroke18.Name = "UIStroke"
UIStroke18.Color = Color3.new(1, 1, 1)
UIStroke18.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke18.Parent = CancelButton18

local Ratio18 = Instance.new("TextLabel")
Ratio18.Name = "Ratio"
Ratio18.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio18.Size = UDim2.new(1, 0, 0.25, 0)
Ratio18.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio18.BackgroundTransparency = 1
Ratio18.BorderSizePixel = 0
Ratio18.BorderColor3 = Color3.new(0, 0, 0)
Ratio18.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio18.Transparency = 1
Ratio18.Text = "0%"
Ratio18.TextColor3 = Color3.new(1, 0, 0)
Ratio18.TextSize = 14
Ratio18.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio18.TextScaled = true
Ratio18.TextWrapped = true
Ratio18.Parent = Effect18

local Loading18 = Instance.new("Frame")
Loading18.Name = "Loading"
Loading18.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading18.Size = UDim2.new(1, 0, 0.1, 0)
Loading18.BackgroundColor3 = Color3.new(1, 1, 1)
Loading18.BackgroundTransparency = 1
Loading18.BorderSizePixel = 0
Loading18.BorderColor3 = Color3.new(0, 0, 0)
Loading18.ZIndex = 2
Loading18.AnchorPoint = Vector2.new(0.5, 0.5)
Loading18.Transparency = 1
Loading18.Parent = Effect18

local LoadFrame18 = Instance.new("Frame")
LoadFrame18.Name = "LoadFrame"
LoadFrame18.Size = UDim2.new(1, 0, 1, 0)
LoadFrame18.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame18.BorderSizePixel = 0
LoadFrame18.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame18.Parent = Loading18

local UICorner54 = Instance.new("UICorner")
UICorner54.Name = "UICorner"
UICorner54.CornerRadius = UDim.new(1, 0)
UICorner54.Parent = LoadFrame18

local Hot_and_Cold = Instance.new("ImageButton")
Hot_and_Cold.Name = "Hot and Cold"
Hot_and_Cold.Position = UDim2.new(0.8, 0, 0.165, 0)
Hot_and_Cold.Size = UDim2.new(0.25, 0, 0.25, 0)
Hot_and_Cold.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Hot_and_Cold.BackgroundTransparency = 0.75
Hot_and_Cold.BorderSizePixel = 0
Hot_and_Cold.BorderColor3 = Color3.new(0, 0, 0)
Hot_and_Cold.AnchorPoint = Vector2.new(0.5, 0.5)
Hot_and_Cold.Transparency = 0.75
Hot_and_Cold.Image = "rbxassetid://137395189499291"
Hot_and_Cold.Parent = Sea2

local UIAspectRatioConstraint24 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint24.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint24.Parent = Hot_and_Cold

local UICorner55 = Instance.new("UICorner")
UICorner55.Name = "UICorner"
UICorner55.CornerRadius = UDim.new(0.15, 0)
UICorner55.Parent = Hot_and_Cold

local Effect19 = Instance.new("Frame")
Effect19.Name = "Effect"
Effect19.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect19.Size = UDim2.new(1, 0, 1, 0)
Effect19.BackgroundColor3 = Color3.new(0, 0, 0)
Effect19.BackgroundTransparency = 0.15000000596046448
Effect19.BorderSizePixel = 0
Effect19.BorderColor3 = Color3.new(0, 0, 0)
Effect19.AnchorPoint = Vector2.new(0.5, 0.5)
Effect19.Transparency = 0.15000000596046448
Effect19.Parent = Hot_and_Cold

local UICorner56 = Instance.new("UICorner")
UICorner56.Name = "UICorner"
UICorner56.CornerRadius = UDim.new(0.15, 0)
UICorner56.Parent = Effect19

local UIGradient19 = Instance.new("UIGradient")
UIGradient19.Name = "UIGradient"
UIGradient19.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient19.Rotation = -90
UIGradient19.Offset = Vector2.new(0, 1)
UIGradient19.Parent = Effect19

local Name19 = Instance.new("TextLabel")
Name19.Name = "Name"
Name19.Position = UDim2.new(0.5, 0, 0.825, 0)
Name19.Size = UDim2.new(1, 0, 0.375, 0)
Name19.BackgroundColor3 = Color3.new(1, 1, 1)
Name19.BackgroundTransparency = 1
Name19.BorderSizePixel = 0
Name19.BorderColor3 = Color3.new(0, 0, 0)
Name19.AnchorPoint = Vector2.new(0.5, 0.5)
Name19.Transparency = 1
Name19.Text = "Hot and Cold"
Name19.TextColor3 = Color3.new(1, 1, 1)
Name19.TextSize = 14
Name19.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name19.TextScaled = true
Name19.TextWrapped = true
Name19.Parent = Effect19

local CancelButton19 = Instance.new("TextButton")
CancelButton19.Name = "CancelButton"
CancelButton19.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton19.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton19.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton19.BorderSizePixel = 0
CancelButton19.BorderColor3 = Color3.new(0, 0, 0)
CancelButton19.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton19.Text = "Cancel"
CancelButton19.TextColor3 = Color3.new(1, 1, 1)
CancelButton19.TextSize = 14
CancelButton19.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton19.TextScaled = true
CancelButton19.TextWrapped = true
CancelButton19.Parent = Effect19

local UIStroke19 = Instance.new("UIStroke")
UIStroke19.Name = "UIStroke"
UIStroke19.Color = Color3.new(1, 1, 1)
UIStroke19.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke19.Parent = CancelButton19

local Ratio19 = Instance.new("TextLabel")
Ratio19.Name = "Ratio"
Ratio19.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio19.Size = UDim2.new(1, 0, 0.25, 0)
Ratio19.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio19.BackgroundTransparency = 1
Ratio19.BorderSizePixel = 0
Ratio19.BorderColor3 = Color3.new(0, 0, 0)
Ratio19.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio19.Transparency = 1
Ratio19.Text = "0%"
Ratio19.TextColor3 = Color3.new(1, 0, 0)
Ratio19.TextSize = 14
Ratio19.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio19.TextScaled = true
Ratio19.TextWrapped = true
Ratio19.Parent = Effect19

local Loading19 = Instance.new("Frame")
Loading19.Name = "Loading"
Loading19.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading19.Size = UDim2.new(1, 0, 0.1, 0)
Loading19.BackgroundColor3 = Color3.new(1, 1, 1)
Loading19.BackgroundTransparency = 1
Loading19.BorderSizePixel = 0
Loading19.BorderColor3 = Color3.new(0, 0, 0)
Loading19.ZIndex = 2
Loading19.AnchorPoint = Vector2.new(0.5, 0.5)
Loading19.Transparency = 1
Loading19.Parent = Effect19

local LoadFrame19 = Instance.new("Frame")
LoadFrame19.Name = "LoadFrame"
LoadFrame19.Size = UDim2.new(1, 0, 1, 0)
LoadFrame19.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame19.BorderSizePixel = 0
LoadFrame19.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame19.Parent = Loading19

local UICorner57 = Instance.new("UICorner")
UICorner57.Name = "UICorner"
UICorner57.CornerRadius = UDim.new(1, 0)
UICorner57.Parent = LoadFrame19

local Snow_Mountain = Instance.new("ImageButton")
Snow_Mountain.Name = "Snow Mountain"
Snow_Mountain.Position = UDim2.new(0.2, 0, 0.27, 0)
Snow_Mountain.Size = UDim2.new(0.25, 0, 0.25, 0)
Snow_Mountain.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Snow_Mountain.BackgroundTransparency = 0.75
Snow_Mountain.BorderSizePixel = 0
Snow_Mountain.BorderColor3 = Color3.new(0, 0, 0)
Snow_Mountain.AnchorPoint = Vector2.new(0.5, 0.5)
Snow_Mountain.Transparency = 0.75
Snow_Mountain.Image = "rbxassetid://129439797530180"
Snow_Mountain.Parent = Sea2

local UIAspectRatioConstraint25 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint25.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint25.Parent = Snow_Mountain

local UICorner58 = Instance.new("UICorner")
UICorner58.Name = "UICorner"
UICorner58.CornerRadius = UDim.new(0.15, 0)
UICorner58.Parent = Snow_Mountain

local Effect20 = Instance.new("Frame")
Effect20.Name = "Effect"
Effect20.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect20.Size = UDim2.new(1, 0, 1, 0)
Effect20.BackgroundColor3 = Color3.new(0, 0, 0)
Effect20.BackgroundTransparency = 0.15000000596046448
Effect20.BorderSizePixel = 0
Effect20.BorderColor3 = Color3.new(0, 0, 0)
Effect20.AnchorPoint = Vector2.new(0.5, 0.5)
Effect20.Transparency = 0.15000000596046448
Effect20.Parent = Snow_Mountain

local UICorner59 = Instance.new("UICorner")
UICorner59.Name = "UICorner"
UICorner59.CornerRadius = UDim.new(0.15, 0)
UICorner59.Parent = Effect20

local UIGradient20 = Instance.new("UIGradient")
UIGradient20.Name = "UIGradient"
UIGradient20.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient20.Rotation = -90
UIGradient20.Offset = Vector2.new(0, 1)
UIGradient20.Parent = Effect20

local Name20 = Instance.new("TextLabel")
Name20.Name = "Name"
Name20.Position = UDim2.new(0.5, 0, 0.825, 0)
Name20.Size = UDim2.new(1, 0, 0.375, 0)
Name20.BackgroundColor3 = Color3.new(1, 1, 1)
Name20.BackgroundTransparency = 1
Name20.BorderSizePixel = 0
Name20.BorderColor3 = Color3.new(0, 0, 0)
Name20.AnchorPoint = Vector2.new(0.5, 0.5)
Name20.Transparency = 1
Name20.Text = "Snow Mountain"
Name20.TextColor3 = Color3.new(1, 1, 1)
Name20.TextSize = 14
Name20.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name20.TextScaled = true
Name20.TextWrapped = true
Name20.Parent = Effect20

local CancelButton20 = Instance.new("TextButton")
CancelButton20.Name = "CancelButton"
CancelButton20.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton20.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton20.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton20.BorderSizePixel = 0
CancelButton20.BorderColor3 = Color3.new(0, 0, 0)
CancelButton20.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton20.Text = "Cancel"
CancelButton20.TextColor3 = Color3.new(1, 1, 1)
CancelButton20.TextSize = 14
CancelButton20.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton20.TextScaled = true
CancelButton20.TextWrapped = true
CancelButton20.Parent = Effect20

local UIStroke20 = Instance.new("UIStroke")
UIStroke20.Name = "UIStroke"
UIStroke20.Color = Color3.new(1, 1, 1)
UIStroke20.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke20.Parent = CancelButton20

local Ratio20 = Instance.new("TextLabel")
Ratio20.Name = "Ratio"
Ratio20.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio20.Size = UDim2.new(1, 0, 0.25, 0)
Ratio20.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio20.BackgroundTransparency = 1
Ratio20.BorderSizePixel = 0
Ratio20.BorderColor3 = Color3.new(0, 0, 0)
Ratio20.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio20.Transparency = 1
Ratio20.Text = "0%"
Ratio20.TextColor3 = Color3.new(1, 0, 0)
Ratio20.TextSize = 14
Ratio20.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio20.TextScaled = true
Ratio20.TextWrapped = true
Ratio20.Parent = Effect20

local Loading20 = Instance.new("Frame")
Loading20.Name = "Loading"
Loading20.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading20.Size = UDim2.new(1, 0, 0.1, 0)
Loading20.BackgroundColor3 = Color3.new(1, 1, 1)
Loading20.BackgroundTransparency = 1
Loading20.BorderSizePixel = 0
Loading20.BorderColor3 = Color3.new(0, 0, 0)
Loading20.ZIndex = 2
Loading20.AnchorPoint = Vector2.new(0.5, 0.5)
Loading20.Transparency = 1
Loading20.Parent = Effect20

local LoadFrame20 = Instance.new("Frame")
LoadFrame20.Name = "LoadFrame"
LoadFrame20.Size = UDim2.new(1, 0, 1, 0)
LoadFrame20.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame20.BorderSizePixel = 0
LoadFrame20.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame20.Parent = Loading20

local UICorner60 = Instance.new("UICorner")
UICorner60.Name = "UICorner"
UICorner60.CornerRadius = UDim.new(1, 0)
UICorner60.Parent = LoadFrame20

local Ice_Castle = Instance.new("ImageButton")
Ice_Castle.Name = "Ice Castle"
Ice_Castle.Position = UDim2.new(0.5, 0, 0.27, 0)
Ice_Castle.Size = UDim2.new(0.25, 0, 0.25, 0)
Ice_Castle.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Ice_Castle.BackgroundTransparency = 0.75
Ice_Castle.BorderSizePixel = 0
Ice_Castle.BorderColor3 = Color3.new(0, 0, 0)
Ice_Castle.AnchorPoint = Vector2.new(0.5, 0.5)
Ice_Castle.Transparency = 0.75
Ice_Castle.Image = "rbxassetid://106485327348425"
Ice_Castle.Parent = Sea2

local UIAspectRatioConstraint26 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint26.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint26.Parent = Ice_Castle

local UICorner61 = Instance.new("UICorner")
UICorner61.Name = "UICorner"
UICorner61.CornerRadius = UDim.new(0.15, 0)
UICorner61.Parent = Ice_Castle

local Effect21 = Instance.new("Frame")
Effect21.Name = "Effect"
Effect21.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect21.Size = UDim2.new(1, 0, 1, 0)
Effect21.BackgroundColor3 = Color3.new(0, 0, 0)
Effect21.BackgroundTransparency = 0.15000000596046448
Effect21.BorderSizePixel = 0
Effect21.BorderColor3 = Color3.new(0, 0, 0)
Effect21.AnchorPoint = Vector2.new(0.5, 0.5)
Effect21.Transparency = 0.15000000596046448
Effect21.Parent = Ice_Castle

local UICorner62 = Instance.new("UICorner")
UICorner62.Name = "UICorner"
UICorner62.CornerRadius = UDim.new(0.15, 0)
UICorner62.Parent = Effect21

local UIGradient21 = Instance.new("UIGradient")
UIGradient21.Name = "UIGradient"
UIGradient21.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient21.Rotation = -90
UIGradient21.Offset = Vector2.new(0, 1)
UIGradient21.Parent = Effect21

local Name21 = Instance.new("TextLabel")
Name21.Name = "Name"
Name21.Position = UDim2.new(0.5, 0, 0.825, 0)
Name21.Size = UDim2.new(1, 0, 0.375, 0)
Name21.BackgroundColor3 = Color3.new(1, 1, 1)
Name21.BackgroundTransparency = 1
Name21.BorderSizePixel = 0
Name21.BorderColor3 = Color3.new(0, 0, 0)
Name21.AnchorPoint = Vector2.new(0.5, 0.5)
Name21.Transparency = 1
Name21.Text = "Ice Castle"
Name21.TextColor3 = Color3.new(1, 1, 1)
Name21.TextSize = 14
Name21.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name21.TextScaled = true
Name21.TextWrapped = true
Name21.Parent = Effect21

local CancelButton21 = Instance.new("TextButton")
CancelButton21.Name = "CancelButton"
CancelButton21.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton21.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton21.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton21.BorderSizePixel = 0
CancelButton21.BorderColor3 = Color3.new(0, 0, 0)
CancelButton21.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton21.Text = "Cancel"
CancelButton21.TextColor3 = Color3.new(1, 1, 1)
CancelButton21.TextSize = 14
CancelButton21.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton21.TextScaled = true
CancelButton21.TextWrapped = true
CancelButton21.Parent = Effect21

local UIStroke21 = Instance.new("UIStroke")
UIStroke21.Name = "UIStroke"
UIStroke21.Color = Color3.new(1, 1, 1)
UIStroke21.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke21.Parent = CancelButton21

local Ratio21 = Instance.new("TextLabel")
Ratio21.Name = "Ratio"
Ratio21.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio21.Size = UDim2.new(1, 0, 0.25, 0)
Ratio21.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio21.BackgroundTransparency = 1
Ratio21.BorderSizePixel = 0
Ratio21.BorderColor3 = Color3.new(0, 0, 0)
Ratio21.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio21.Transparency = 1
Ratio21.Text = "0%"
Ratio21.TextColor3 = Color3.new(1, 0, 0)
Ratio21.TextSize = 14
Ratio21.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio21.TextScaled = true
Ratio21.TextWrapped = true
Ratio21.Parent = Effect21

local Loading21 = Instance.new("Frame")
Loading21.Name = "Loading"
Loading21.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading21.Size = UDim2.new(1, 0, 0.1, 0)
Loading21.BackgroundColor3 = Color3.new(1, 1, 1)
Loading21.BackgroundTransparency = 1
Loading21.BorderSizePixel = 0
Loading21.BorderColor3 = Color3.new(0, 0, 0)
Loading21.ZIndex = 2
Loading21.AnchorPoint = Vector2.new(0.5, 0.5)
Loading21.Transparency = 1
Loading21.Parent = Effect21

local LoadFrame21 = Instance.new("Frame")
LoadFrame21.Name = "LoadFrame"
LoadFrame21.Size = UDim2.new(1, 0, 1, 0)
LoadFrame21.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame21.BorderSizePixel = 0
LoadFrame21.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame21.Parent = Loading21

local UICorner63 = Instance.new("UICorner")
UICorner63.Name = "UICorner"
UICorner63.CornerRadius = UDim.new(1, 0)
UICorner63.Parent = LoadFrame21

local Forgotten_Island = Instance.new("ImageButton")
Forgotten_Island.Name = "Forgotten Island"
Forgotten_Island.Position = UDim2.new(0.8, 0, 0.27, 0)
Forgotten_Island.Size = UDim2.new(0.25, 0, 0.25, 0)
Forgotten_Island.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Forgotten_Island.BackgroundTransparency = 0.75
Forgotten_Island.BorderSizePixel = 0
Forgotten_Island.BorderColor3 = Color3.new(0, 0, 0)
Forgotten_Island.AnchorPoint = Vector2.new(0.5, 0.5)
Forgotten_Island.Transparency = 0.75
Forgotten_Island.Image = "rbxassetid://77880790468242"
Forgotten_Island.Parent = Sea2

local UIAspectRatioConstraint27 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint27.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint27.Parent = Forgotten_Island

local UICorner64 = Instance.new("UICorner")
UICorner64.Name = "UICorner"
UICorner64.CornerRadius = UDim.new(0.15, 0)
UICorner64.Parent = Forgotten_Island

local Effect22 = Instance.new("Frame")
Effect22.Name = "Effect"
Effect22.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect22.Size = UDim2.new(1, 0, 1, 0)
Effect22.BackgroundColor3 = Color3.new(0, 0, 0)
Effect22.BackgroundTransparency = 0.15000000596046448
Effect22.BorderSizePixel = 0
Effect22.BorderColor3 = Color3.new(0, 0, 0)
Effect22.AnchorPoint = Vector2.new(0.5, 0.5)
Effect22.Transparency = 0.15000000596046448
Effect22.Parent = Forgotten_Island

local UICorner65 = Instance.new("UICorner")
UICorner65.Name = "UICorner"
UICorner65.CornerRadius = UDim.new(0.15, 0)
UICorner65.Parent = Effect22

local UIGradient22 = Instance.new("UIGradient")
UIGradient22.Name = "UIGradient"
UIGradient22.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient22.Rotation = -90
UIGradient22.Offset = Vector2.new(0, 1)
UIGradient22.Parent = Effect22

local Name22 = Instance.new("TextLabel")
Name22.Name = "Name"
Name22.Position = UDim2.new(0.5, 0, 0.825, 0)
Name22.Size = UDim2.new(1, 0, 0.375, 0)
Name22.BackgroundColor3 = Color3.new(1, 1, 1)
Name22.BackgroundTransparency = 1
Name22.BorderSizePixel = 0
Name22.BorderColor3 = Color3.new(0, 0, 0)
Name22.AnchorPoint = Vector2.new(0.5, 0.5)
Name22.Transparency = 1
Name22.Text = "Forgotten Island"
Name22.TextColor3 = Color3.new(1, 1, 1)
Name22.TextSize = 14
Name22.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name22.TextScaled = true
Name22.TextWrapped = true
Name22.Parent = Effect22

local CancelButton22 = Instance.new("TextButton")
CancelButton22.Name = "CancelButton"
CancelButton22.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton22.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton22.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton22.BorderSizePixel = 0
CancelButton22.BorderColor3 = Color3.new(0, 0, 0)
CancelButton22.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton22.Text = "Cancel"
CancelButton22.TextColor3 = Color3.new(1, 1, 1)
CancelButton22.TextSize = 14
CancelButton22.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton22.TextScaled = true
CancelButton22.TextWrapped = true
CancelButton22.Parent = Effect22

local UIStroke22 = Instance.new("UIStroke")
UIStroke22.Name = "UIStroke"
UIStroke22.Color = Color3.new(1, 1, 1)
UIStroke22.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke22.Parent = CancelButton22

local Ratio22 = Instance.new("TextLabel")
Ratio22.Name = "Ratio"
Ratio22.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio22.Size = UDim2.new(1, 0, 0.25, 0)
Ratio22.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio22.BackgroundTransparency = 1
Ratio22.BorderSizePixel = 0
Ratio22.BorderColor3 = Color3.new(0, 0, 0)
Ratio22.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio22.Transparency = 1
Ratio22.Text = "0%"
Ratio22.TextColor3 = Color3.new(1, 0, 0)
Ratio22.TextSize = 14
Ratio22.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio22.TextScaled = true
Ratio22.TextWrapped = true
Ratio22.Parent = Effect22

local Loading22 = Instance.new("Frame")
Loading22.Name = "Loading"
Loading22.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading22.Size = UDim2.new(1, 0, 0.1, 0)
Loading22.BackgroundColor3 = Color3.new(1, 1, 1)
Loading22.BackgroundTransparency = 1
Loading22.BorderSizePixel = 0
Loading22.BorderColor3 = Color3.new(0, 0, 0)
Loading22.ZIndex = 2
Loading22.AnchorPoint = Vector2.new(0.5, 0.5)
Loading22.Transparency = 1
Loading22.Parent = Effect22

local LoadFrame22 = Instance.new("Frame")
LoadFrame22.Name = "LoadFrame"
LoadFrame22.Size = UDim2.new(1, 0, 1, 0)
LoadFrame22.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame22.BorderSizePixel = 0
LoadFrame22.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame22.Parent = Loading22

local UICorner66 = Instance.new("UICorner")
UICorner66.Name = "UICorner"
UICorner66.CornerRadius = UDim.new(1, 0)
UICorner66.Parent = LoadFrame22

local Cursed_Ship = Instance.new("ImageButton")
Cursed_Ship.Name = "Cursed Ship"
Cursed_Ship.Position = UDim2.new(0.2, 0, 0.375, 0)
Cursed_Ship.Size = UDim2.new(0.25, 0, 0.25, 0)
Cursed_Ship.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Cursed_Ship.BackgroundTransparency = 0.75
Cursed_Ship.BorderSizePixel = 0
Cursed_Ship.BorderColor3 = Color3.new(0, 0, 0)
Cursed_Ship.AnchorPoint = Vector2.new(0.5, 0.5)
Cursed_Ship.Transparency = 0.75
Cursed_Ship.Image = "rbxassetid://93408458535090"
Cursed_Ship.Parent = Sea2

local UIAspectRatioConstraint28 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint28.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint28.Parent = Cursed_Ship

local UICorner67 = Instance.new("UICorner")
UICorner67.Name = "UICorner"
UICorner67.CornerRadius = UDim.new(0.15, 0)
UICorner67.Parent = Cursed_Ship

local Effect23 = Instance.new("Frame")
Effect23.Name = "Effect"
Effect23.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect23.Size = UDim2.new(1, 0, 1, 0)
Effect23.BackgroundColor3 = Color3.new(0, 0, 0)
Effect23.BackgroundTransparency = 0.15000000596046448
Effect23.BorderSizePixel = 0
Effect23.BorderColor3 = Color3.new(0, 0, 0)
Effect23.AnchorPoint = Vector2.new(0.5, 0.5)
Effect23.Transparency = 0.15000000596046448
Effect23.Parent = Cursed_Ship

local UICorner68 = Instance.new("UICorner")
UICorner68.Name = "UICorner"
UICorner68.CornerRadius = UDim.new(0.15, 0)
UICorner68.Parent = Effect23

local UIGradient23 = Instance.new("UIGradient")
UIGradient23.Name = "UIGradient"
UIGradient23.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient23.Rotation = -90
UIGradient23.Offset = Vector2.new(0, 1)
UIGradient23.Parent = Effect23

local Name23 = Instance.new("TextLabel")
Name23.Name = "Name"
Name23.Position = UDim2.new(0.5, 0, 0.825, 0)
Name23.Size = UDim2.new(1, 0, 0.375, 0)
Name23.BackgroundColor3 = Color3.new(1, 1, 1)
Name23.BackgroundTransparency = 1
Name23.BorderSizePixel = 0
Name23.BorderColor3 = Color3.new(0, 0, 0)
Name23.AnchorPoint = Vector2.new(0.5, 0.5)
Name23.Transparency = 1
Name23.Text = "Cursed Ship"
Name23.TextColor3 = Color3.new(1, 1, 1)
Name23.TextSize = 14
Name23.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name23.TextScaled = true
Name23.TextWrapped = true
Name23.Parent = Effect23

local CancelButton23 = Instance.new("TextButton")
CancelButton23.Name = "CancelButton"
CancelButton23.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton23.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton23.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton23.BorderSizePixel = 0
CancelButton23.BorderColor3 = Color3.new(0, 0, 0)
CancelButton23.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton23.Text = "Cancel"
CancelButton23.TextColor3 = Color3.new(1, 1, 1)
CancelButton23.TextSize = 14
CancelButton23.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton23.TextScaled = true
CancelButton23.TextWrapped = true
CancelButton23.Parent = Effect23

local UIStroke23 = Instance.new("UIStroke")
UIStroke23.Name = "UIStroke"
UIStroke23.Color = Color3.new(1, 1, 1)
UIStroke23.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke23.Parent = CancelButton23

local Ratio23 = Instance.new("TextLabel")
Ratio23.Name = "Ratio"
Ratio23.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio23.Size = UDim2.new(1, 0, 0.25, 0)
Ratio23.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio23.BackgroundTransparency = 1
Ratio23.BorderSizePixel = 0
Ratio23.BorderColor3 = Color3.new(0, 0, 0)
Ratio23.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio23.Transparency = 1
Ratio23.Text = "0%"
Ratio23.TextColor3 = Color3.new(1, 0, 0)
Ratio23.TextSize = 14
Ratio23.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio23.TextScaled = true
Ratio23.TextWrapped = true
Ratio23.Parent = Effect23

local Loading23 = Instance.new("Frame")
Loading23.Name = "Loading"
Loading23.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading23.Size = UDim2.new(1, 0, 0.1, 0)
Loading23.BackgroundColor3 = Color3.new(1, 1, 1)
Loading23.BackgroundTransparency = 1
Loading23.BorderSizePixel = 0
Loading23.BorderColor3 = Color3.new(0, 0, 0)
Loading23.ZIndex = 2
Loading23.AnchorPoint = Vector2.new(0.5, 0.5)
Loading23.Transparency = 1
Loading23.Parent = Effect23

local LoadFrame23 = Instance.new("Frame")
LoadFrame23.Name = "LoadFrame"
LoadFrame23.Size = UDim2.new(1, 0, 1, 0)
LoadFrame23.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame23.BorderSizePixel = 0
LoadFrame23.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame23.Parent = Loading23

local UICorner69 = Instance.new("UICorner")
UICorner69.Name = "UICorner"
UICorner69.CornerRadius = UDim.new(1, 0)
UICorner69.Parent = LoadFrame23

local Dark_Arena = Instance.new("ImageButton")
Dark_Arena.Name = "Dark Arena"
Dark_Arena.Position = UDim2.new(0.5, 0, 0.375, 0)
Dark_Arena.Size = UDim2.new(0.25, 0, 0.25, 0)
Dark_Arena.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Dark_Arena.BackgroundTransparency = 0.75
Dark_Arena.BorderSizePixel = 0
Dark_Arena.BorderColor3 = Color3.new(0, 0, 0)
Dark_Arena.AnchorPoint = Vector2.new(0.5, 0.5)
Dark_Arena.Transparency = 0.75
Dark_Arena.Image = "rbxassetid://115077834395031"
Dark_Arena.Parent = Sea2

local UIAspectRatioConstraint29 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint29.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint29.Parent = Dark_Arena

local UICorner70 = Instance.new("UICorner")
UICorner70.Name = "UICorner"
UICorner70.CornerRadius = UDim.new(0.15, 0)
UICorner70.Parent = Dark_Arena

local Effect24 = Instance.new("Frame")
Effect24.Name = "Effect"
Effect24.Position = UDim2.new(0.5, 0, 0.5, 0)
Effect24.Size = UDim2.new(1, 0, 1, 0)
Effect24.BackgroundColor3 = Color3.new(0, 0, 0)
Effect24.BackgroundTransparency = 0.15000000596046448
Effect24.BorderSizePixel = 0
Effect24.BorderColor3 = Color3.new(0, 0, 0)
Effect24.AnchorPoint = Vector2.new(0.5, 0.5)
Effect24.Transparency = 0.15000000596046448
Effect24.Parent = Dark_Arena

local UICorner71 = Instance.new("UICorner")
UICorner71.Name = "UICorner"
UICorner71.CornerRadius = UDim.new(0.15, 0)
UICorner71.Parent = Effect24

local UIGradient24 = Instance.new("UIGradient")
UIGradient24.Name = "UIGradient"
UIGradient24.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient24.Rotation = -90
UIGradient24.Offset = Vector2.new(0, 1)
UIGradient24.Parent = Effect24

local Name24 = Instance.new("TextLabel")
Name24.Name = "Name"
Name24.Position = UDim2.new(0.5, 0, 0.825, 0)
Name24.Size = UDim2.new(1, 0, 0.375, 0)
Name24.BackgroundColor3 = Color3.new(1, 1, 1)
Name24.BackgroundTransparency = 1
Name24.BorderSizePixel = 0
Name24.BorderColor3 = Color3.new(0, 0, 0)
Name24.AnchorPoint = Vector2.new(0.5, 0.5)
Name24.Transparency = 1
Name24.Text = "Dark Arena"
Name24.TextColor3 = Color3.new(1, 1, 1)
Name24.TextSize = 14
Name24.FontFace = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Name24.TextScaled = true
Name24.TextWrapped = true
Name24.Parent = Effect24

local CancelButton24 = Instance.new("TextButton")
CancelButton24.Name = "CancelButton"
CancelButton24.Position = UDim2.new(0.5, 0, 0.25, 0)
CancelButton24.Size = UDim2.new(0.8, 0, 0.275, 0)
CancelButton24.BackgroundColor3 = Color3.new(0.784314, 0, 0)
CancelButton24.BorderSizePixel = 0
CancelButton24.BorderColor3 = Color3.new(0, 0, 0)
CancelButton24.AnchorPoint = Vector2.new(0.5, 0.5)
CancelButton24.Text = "Cancel"
CancelButton24.TextColor3 = Color3.new(1, 1, 1)
CancelButton24.TextSize = 14
CancelButton24.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CancelButton24.TextScaled = true
CancelButton24.TextWrapped = true
CancelButton24.Parent = Effect24

local UIStroke24 = Instance.new("UIStroke")
UIStroke24.Name = "UIStroke"
UIStroke24.Color = Color3.new(1, 1, 1)
UIStroke24.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke24.Parent = CancelButton24

local Ratio24 = Instance.new("TextLabel")
Ratio24.Name = "Ratio"
Ratio24.Position = UDim2.new(0.5, 0, 0.6, 0)
Ratio24.Size = UDim2.new(1, 0, 0.25, 0)
Ratio24.BackgroundColor3 = Color3.new(1, 1, 1)
Ratio24.BackgroundTransparency = 1
Ratio24.BorderSizePixel = 0
Ratio24.BorderColor3 = Color3.new(0, 0, 0)
Ratio24.AnchorPoint = Vector2.new(0.5, 0.5)
Ratio24.Transparency = 1
Ratio24.Text = "0%"
Ratio24.TextColor3 = Color3.new(1, 0, 0)
Ratio24.TextSize = 14
Ratio24.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Ratio24.TextScaled = true
Ratio24.TextWrapped = true
Ratio24.Parent = Effect24

local Loading24 = Instance.new("Frame")
Loading24.Name = "Loading"
Loading24.Position = UDim2.new(0.5, 0, 0.95, 0)
Loading24.Size = UDim2.new(1, 0, 0.1, 0)
Loading24.BackgroundColor3 = Color3.new(1, 1, 1)
Loading24.BackgroundTransparency = 1
Loading24.BorderSizePixel = 0
Loading24.BorderColor3 = Color3.new(0, 0, 0)
Loading24.ZIndex = 2
Loading24.AnchorPoint = Vector2.new(0.5, 0.5)
Loading24.Transparency = 1
Loading24.Parent = Effect24

local LoadFrame24 = Instance.new("Frame")
LoadFrame24.Name = "LoadFrame"
LoadFrame24.Size = UDim2.new(1, 0, 1, 0)
LoadFrame24.BackgroundColor3 = Color3.new(0.92549, 0.737255, 1)
LoadFrame24.BorderSizePixel = 0
LoadFrame24.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame24.Parent = Loading24

local UICorner72 = Instance.new("UICorner")
UICorner72.Name = "UICorner"
UICorner72.CornerRadius = UDim.new(1, 0)
UICorner72.Parent = LoadFrame24

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
