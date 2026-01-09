local FrameSea = game.Players.LocalPlayer.PlayerGui:WaitForChild("BloxFruitHubGui"):WaitForChild("Main"):WaitForChild("ScrollingTab"):WaitForChild("Island")

local Sea1 = Instance.new("Folder")
Sea1.Name = "Sea1"

Sea1.Parent = FrameSea

local Pirate_Starter = Instance.new("ImageButton")
Pirate_Starter.Name = "Pirate Starter"
Pirate_Starter.Position = UDim2.new(0.2, 0, 0.06, 0)
Pirate_Starter.Size = UDim2.new(0.25, 0, 0.25, 0)
Pirate_Starter.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Pirate_Starter.BackgroundTransparency = 0.75
Pirate_Starter.BorderSizePixel = 0
Pirate_Starter.BorderColor3 = Color3.new(0, 0, 0)
Pirate_Starter.AnchorPoint = Vector2.new(0.5, 0.5)
Pirate_Starter.Transparency = 0.75
Pirate_Starter.Image = "rbxassetid://93119023496063"
Pirate_Starter.Parent = Sea1

local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint.Parent = Pirate_Starter

local UICorner = Instance.new("UICorner")
UICorner.Name = "UICorner"
UICorner.CornerRadius = UDim.new(0.15, 0)
UICorner.Parent = Pirate_Starter

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
Effect.Parent = Pirate_Starter

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
Name.Text = "Pirate Starter"
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

local Marine_Starter = Instance.new("ImageButton")
Marine_Starter.Name = "Marine Starter"
Marine_Starter.Position = UDim2.new(0.5, 0, 0.06, 0)
Marine_Starter.Size = UDim2.new(0.25, 0, 0.25, 0)
Marine_Starter.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Marine_Starter.BackgroundTransparency = 0.75
Marine_Starter.BorderSizePixel = 0
Marine_Starter.BorderColor3 = Color3.new(0, 0, 0)
Marine_Starter.AnchorPoint = Vector2.new(0.5, 0.5)
Marine_Starter.Transparency = 0.75
Marine_Starter.Image = "rbxassetid://81845568114627"
Marine_Starter.Parent = Sea1

local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint2.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint2.Parent = Marine_Starter

local UICorner4 = Instance.new("UICorner")
UICorner4.Name = "UICorner"
UICorner4.CornerRadius = UDim.new(0.15, 0)
UICorner4.Parent = Marine_Starter

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
Effect2.Parent = Marine_Starter

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
Name2.Text = "Marine Starter"
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

local Jungle = Instance.new("ImageButton")
Jungle.Name = "Jungle"
Jungle.Position = UDim2.new(0.8, 0, 0.06, 0)
Jungle.Size = UDim2.new(0.25, 0, 0.25, 0)
Jungle.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Jungle.BackgroundTransparency = 0.75
Jungle.BorderSizePixel = 0
Jungle.BorderColor3 = Color3.new(0, 0, 0)
Jungle.AnchorPoint = Vector2.new(0.5, 0.5)
Jungle.Transparency = 0.75
Jungle.Image = "rbxassetid://110135799712602"
Jungle.Parent = Sea1

local UIAspectRatioConstraint3 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint3.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint3.Parent = Jungle

local UICorner7 = Instance.new("UICorner")
UICorner7.Name = "UICorner"
UICorner7.CornerRadius = UDim.new(0.15, 0)
UICorner7.Parent = Jungle

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
Effect3.Parent = Jungle

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
Name3.Text = "Jungle"
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

local Pirate_Village = Instance.new("ImageButton")
Pirate_Village.Name = "Pirate Village"
Pirate_Village.Position = UDim2.new(0.2, 0, 0.165, 0)
Pirate_Village.Size = UDim2.new(0.25, 0, 0.25, 0)
Pirate_Village.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Pirate_Village.BackgroundTransparency = 0.75
Pirate_Village.BorderSizePixel = 0
Pirate_Village.BorderColor3 = Color3.new(0, 0, 0)
Pirate_Village.AnchorPoint = Vector2.new(0.5, 0.5)
Pirate_Village.Transparency = 0.75
Pirate_Village.Image = "rbxassetid://84402586443529"
Pirate_Village.Parent = Sea1

local UIAspectRatioConstraint4 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint4.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint4.Parent = Pirate_Village

local UICorner10 = Instance.new("UICorner")
UICorner10.Name = "UICorner"
UICorner10.CornerRadius = UDim.new(0.15, 0)
UICorner10.Parent = Pirate_Village

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
Effect4.Parent = Pirate_Village

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
Name4.Text = "Pirate Village"
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

local Desert = Instance.new("ImageButton")
Desert.Name = "Desert"
Desert.Position = UDim2.new(0.5, 0, 0.165, 0)
Desert.Size = UDim2.new(0.25, 0, 0.25, 0)
Desert.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Desert.BackgroundTransparency = 0.75
Desert.BorderSizePixel = 0
Desert.BorderColor3 = Color3.new(0, 0, 0)
Desert.AnchorPoint = Vector2.new(0.5, 0.5)
Desert.Transparency = 0.75
Desert.Image = "rbxassetid://81823229427019"
Desert.Parent = Sea1

local UIAspectRatioConstraint5 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint5.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint5.Parent = Desert

local UICorner13 = Instance.new("UICorner")
UICorner13.Name = "UICorner"
UICorner13.CornerRadius = UDim.new(0.15, 0)
UICorner13.Parent = Desert

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
Effect5.Parent = Desert

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
Name5.Text = "Desert"
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

local Frozen_Village = Instance.new("ImageButton")
Frozen_Village.Name = "Frozen Village"
Frozen_Village.Position = UDim2.new(0.8, 0, 0.165, 0)
Frozen_Village.Size = UDim2.new(0.25, 0, 0.25, 0)
Frozen_Village.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Frozen_Village.BackgroundTransparency = 0.75
Frozen_Village.BorderSizePixel = 0
Frozen_Village.BorderColor3 = Color3.new(0, 0, 0)
Frozen_Village.AnchorPoint = Vector2.new(0.5, 0.5)
Frozen_Village.Transparency = 0.75
Frozen_Village.Image = "rbxassetid://111872920418416"
Frozen_Village.Parent = Sea1

local UIAspectRatioConstraint6 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint6.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint6.Parent = Frozen_Village

local UICorner16 = Instance.new("UICorner")
UICorner16.Name = "UICorner"
UICorner16.CornerRadius = UDim.new(0.15, 0)
UICorner16.Parent = Frozen_Village

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
Effect6.Parent = Frozen_Village

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
Name6.Text = "Frozen Village"
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

local Marine_Fortress = Instance.new("ImageButton")
Marine_Fortress.Name = "Marine Fortress"
Marine_Fortress.Position = UDim2.new(0.2, 0, 0.27, 0)
Marine_Fortress.Size = UDim2.new(0.25, 0, 0.25, 0)
Marine_Fortress.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Marine_Fortress.BackgroundTransparency = 0.75
Marine_Fortress.BorderSizePixel = 0
Marine_Fortress.BorderColor3 = Color3.new(0, 0, 0)
Marine_Fortress.AnchorPoint = Vector2.new(0.5, 0.5)
Marine_Fortress.Transparency = 0.75
Marine_Fortress.Image = "rbxassetid://109840580199818"
Marine_Fortress.Parent = Sea1

local UIAspectRatioConstraint7 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint7.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint7.Parent = Marine_Fortress

local UICorner19 = Instance.new("UICorner")
UICorner19.Name = "UICorner"
UICorner19.CornerRadius = UDim.new(0.15, 0)
UICorner19.Parent = Marine_Fortress

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
Effect7.Parent = Marine_Fortress

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
Name7.Text = "Marine Fortress"
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

local Skylands = Instance.new("ImageButton")
Skylands.Name = "Skylands"
Skylands.Position = UDim2.new(0.5, 0, 0.27, 0)
Skylands.Size = UDim2.new(0.25, 0, 0.25, 0)
Skylands.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Skylands.BackgroundTransparency = 0.75
Skylands.BorderSizePixel = 0
Skylands.BorderColor3 = Color3.new(0, 0, 0)
Skylands.AnchorPoint = Vector2.new(0.5, 0.5)
Skylands.Transparency = 0.75
Skylands.Image = "rbxassetid://79423382333815"
Skylands.Parent = Sea1

local UIAspectRatioConstraint8 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint8.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint8.Parent = Skylands

local UICorner22 = Instance.new("UICorner")
UICorner22.Name = "UICorner"
UICorner22.CornerRadius = UDim.new(0.15, 0)
UICorner22.Parent = Skylands

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
Effect8.Parent = Skylands

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
Name8.Text = "Skylands"
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

--Load UI Part2
loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Island_UISea1_Part2.lua"))()

local Frame = Sea1
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
