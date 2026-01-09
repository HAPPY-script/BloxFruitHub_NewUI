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

local Upper_Skylands = Instance.new("ImageButton")
Upper_Skylands.Name = "Upper Skylands"
Upper_Skylands.Position = UDim2.new(0.8, 0, 0.27, 0)
Upper_Skylands.Size = UDim2.new(0.25, 0, 0.25, 0)
Upper_Skylands.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Upper_Skylands.BackgroundTransparency = 0.75
Upper_Skylands.BorderSizePixel = 0
Upper_Skylands.BorderColor3 = Color3.new(0, 0, 0)
Upper_Skylands.AnchorPoint = Vector2.new(0.5, 0.5)
Upper_Skylands.Transparency = 0.75
Upper_Skylands.Image = "rbxassetid://91542601134525"
Upper_Skylands.Parent = Sea1

local UIAspectRatioConstraint9 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint9.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint9.Parent = Upper_Skylands

local UICorner25 = Instance.new("UICorner")
UICorner25.Name = "UICorner"
UICorner25.CornerRadius = UDim.new(0.15, 0)
UICorner25.Parent = Upper_Skylands

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
Effect9.Parent = Upper_Skylands

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
Name9.Text = "Upper Skylands"
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

local Prison = Instance.new("ImageButton")
Prison.Name = "Prison"
Prison.Position = UDim2.new(0.2, 0, 0.375, 0)
Prison.Size = UDim2.new(0.25, 0, 0.25, 0)
Prison.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Prison.BackgroundTransparency = 0.75
Prison.BorderSizePixel = 0
Prison.BorderColor3 = Color3.new(0, 0, 0)
Prison.AnchorPoint = Vector2.new(0.5, 0.5)
Prison.Transparency = 0.75
Prison.Image = "rbxassetid://139374216712924"
Prison.Parent = Sea1

local UIAspectRatioConstraint10 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint10.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint10.Parent = Prison

local UICorner28 = Instance.new("UICorner")
UICorner28.Name = "UICorner"
UICorner28.CornerRadius = UDim.new(0.15, 0)
UICorner28.Parent = Prison

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
Effect10.Parent = Prison

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
Name10.Text = "Prison"
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

local Magma_Village = Instance.new("ImageButton")
Magma_Village.Name = "Magma Village"
Magma_Village.Position = UDim2.new(0.5, 0, 0.375, 0)
Magma_Village.Size = UDim2.new(0.25, 0, 0.25, 0)
Magma_Village.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Magma_Village.BackgroundTransparency = 0.75
Magma_Village.BorderSizePixel = 0
Magma_Village.BorderColor3 = Color3.new(0, 0, 0)
Magma_Village.AnchorPoint = Vector2.new(0.5, 0.5)
Magma_Village.Transparency = 0.75
Magma_Village.Image = "rbxassetid://97921767625218"
Magma_Village.Parent = Sea1

local UIAspectRatioConstraint11 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint11.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint11.Parent = Magma_Village

local UICorner31 = Instance.new("UICorner")
UICorner31.Name = "UICorner"
UICorner31.CornerRadius = UDim.new(0.15, 0)
UICorner31.Parent = Magma_Village

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
Effect11.Parent = Magma_Village

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
Name11.Text = "Magma Village"
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

local Whirlpool = Instance.new("ImageButton")
Whirlpool.Name = "Whirlpool"
Whirlpool.Position = UDim2.new(0.8, 0, 0.375, 0)
Whirlpool.Size = UDim2.new(0.25, 0, 0.25, 0)
Whirlpool.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Whirlpool.BackgroundTransparency = 0.75
Whirlpool.BorderSizePixel = 0
Whirlpool.BorderColor3 = Color3.new(0, 0, 0)
Whirlpool.AnchorPoint = Vector2.new(0.5, 0.5)
Whirlpool.Transparency = 0.75
Whirlpool.Image = "rbxassetid://83575462133763"
Whirlpool.Parent = Sea1

local UIAspectRatioConstraint12 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint12.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint12.Parent = Whirlpool

local UICorner34 = Instance.new("UICorner")
UICorner34.Name = "UICorner"
UICorner34.CornerRadius = UDim.new(0.15, 0)
UICorner34.Parent = Whirlpool

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
Effect12.Parent = Whirlpool

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
Name12.Text = "Whirlpool"
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

local Underwater_City = Instance.new("ImageButton")
Underwater_City.Name = "Underwater City"
Underwater_City.Position = UDim2.new(0.2, 0, 0.48, 0)
Underwater_City.Size = UDim2.new(0.25, 0, 0.25, 0)
Underwater_City.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Underwater_City.BackgroundTransparency = 0.75
Underwater_City.BorderSizePixel = 0
Underwater_City.BorderColor3 = Color3.new(0, 0, 0)
Underwater_City.AnchorPoint = Vector2.new(0.5, 0.5)
Underwater_City.Transparency = 0.75
Underwater_City.Image = "rbxassetid://136936692003005"
Underwater_City.Parent = Sea1

local UIAspectRatioConstraint13 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint13.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint13.Parent = Underwater_City

local UICorner37 = Instance.new("UICorner")
UICorner37.Name = "UICorner"
UICorner37.CornerRadius = UDim.new(0.15, 0)
UICorner37.Parent = Underwater_City

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
Effect13.Parent = Underwater_City

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
Name13.Text = "Underwater City"
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

local Fountain_City = Instance.new("ImageButton")
Fountain_City.Name = "Fountain City"
Fountain_City.Position = UDim2.new(0.5, 0, 0.48, 0)
Fountain_City.Size = UDim2.new(0.25, 0, 0.25, 0)
Fountain_City.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Fountain_City.BackgroundTransparency = 0.75
Fountain_City.BorderSizePixel = 0
Fountain_City.BorderColor3 = Color3.new(0, 0, 0)
Fountain_City.AnchorPoint = Vector2.new(0.5, 0.5)
Fountain_City.Transparency = 0.75
Fountain_City.Image = "rbxassetid://102327847281543"
Fountain_City.Parent = Sea1

local UIAspectRatioConstraint14 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint14.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint14.Parent = Fountain_City

local UICorner40 = Instance.new("UICorner")
UICorner40.Name = "UICorner"
UICorner40.CornerRadius = UDim.new(0.15, 0)
UICorner40.Parent = Fountain_City

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
Effect14.Parent = Fountain_City

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
Name14.Text = "Fountain City"
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

local Colosseum = Instance.new("ImageButton")
Colosseum.Name = "Colosseum"
Colosseum.Position = UDim2.new(0.8, 0, 0.48, 0)
Colosseum.Size = UDim2.new(0.25, 0, 0.25, 0)
Colosseum.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Colosseum.BackgroundTransparency = 0.75
Colosseum.BorderSizePixel = 0
Colosseum.BorderColor3 = Color3.new(0, 0, 0)
Colosseum.AnchorPoint = Vector2.new(0.5, 0.5)
Colosseum.Transparency = 0.75
Colosseum.Image = "rbxassetid://129933660344344"
Colosseum.Parent = Sea1

local UIAspectRatioConstraint15 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint15.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint15.Parent = Colosseum

local UICorner43 = Instance.new("UICorner")
UICorner43.Name = "UICorner"
UICorner43.CornerRadius = UDim.new(0.15, 0)
UICorner43.Parent = Colosseum

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
Effect15.Parent = Colosseum

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
Name15.Text = "Colosseum"
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

local Middle_Town = Instance.new("ImageButton")
Middle_Town.Name = "Middle Town"
Middle_Town.Position = UDim2.new(0.2, 0, 0.585, 0)
Middle_Town.Size = UDim2.new(0.25, 0, 0.25, 0)
Middle_Town.BackgroundColor3 = Color3.new(1, 0.227451, 0.792157)
Middle_Town.BackgroundTransparency = 0.75
Middle_Town.BorderSizePixel = 0
Middle_Town.BorderColor3 = Color3.new(0, 0, 0)
Middle_Town.AnchorPoint = Vector2.new(0.5, 0.5)
Middle_Town.Transparency = 0.75
Middle_Town.Image = "rbxassetid://138263703099476"
Middle_Town.Parent = Sea1

local UIAspectRatioConstraint16 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint16.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint16.Parent = Middle_Town

local UICorner46 = Instance.new("UICorner")
UICorner46.Name = "UICorner"
UICorner46.CornerRadius = UDim.new(0.15, 0)
UICorner46.Parent = Middle_Town

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
Effect16.Parent = Middle_Town

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
Name16.Text = "Middle Town"
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
