local LoadAnimationGui = Instance.new("ScreenGui")
LoadAnimationGui.Name = "LoadAnimationGui"
LoadAnimationGui.ResetOnSpawn = false
LoadAnimationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LoadAnimationGui.DisplayOrder = 150
LoadAnimationGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local LoadWhiteFrame = Instance.new("Frame")
LoadWhiteFrame.Name = "LoadWhiteFrame"
LoadWhiteFrame.Position = UDim2.new(0.5, 0, 0.4, 0)
LoadWhiteFrame.BackgroundColor3 = Color3.new(1, 1, 1)
LoadWhiteFrame.BorderSizePixel = 0
LoadWhiteFrame.BorderColor3 = Color3.new(0, 0, 0)
LoadWhiteFrame.AnchorPoint = Vector2.new(0.5, 0.5)
LoadWhiteFrame.Parent = LoadAnimationGui

local UICorner = Instance.new("UICorner")
UICorner.Name = "UICorner"
UICorner.CornerRadius = UDim.new(0.15, 0)
UICorner.Parent = LoadWhiteFrame

local LoadFrame = Instance.new("Frame")
LoadFrame.Name = "LoadFrame"
LoadFrame.Size = UDim2.new(1, 0, 1, 0)
LoadFrame.BackgroundColor3 = Color3.new(0, 1, 0)
LoadFrame.BorderSizePixel = 0
LoadFrame.BorderColor3 = Color3.new(0, 0, 0)
LoadFrame.Parent = LoadWhiteFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Name = "UIGradient"
UIGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(0.5, 0, 0), NumberSequenceKeypoint.new(0.501, 1, 0), NumberSequenceKeypoint.new(1, 1, 0)})
UIGradient.Rotation = -90
UIGradient.Offset = Vector2.new(0, 0.5)
UIGradient.Parent = LoadFrame

local UICorner2 = Instance.new("UICorner")
UICorner2.Name = "UICorner"
UICorner2.CornerRadius = UDim.new(0.15, 0)
UICorner2.Parent = LoadFrame

local Effect = Instance.new("Folder")
Effect.Name = "Effect"

Effect.Parent = LoadAnimationGui

local StarEffect = Instance.new("ImageLabel")
StarEffect.Name = "StarEffect"
StarEffect.Position = UDim2.new(0.5, 0, 1000, 0)
StarEffect.Size = UDim2.new(0.05, 0, 0.05, 0)
StarEffect.BackgroundColor3 = Color3.new(1, 1, 1)
StarEffect.BackgroundTransparency = 1
StarEffect.BorderSizePixel = 0
StarEffect.BorderColor3 = Color3.new(0, 0, 0)
StarEffect.AnchorPoint = Vector2.new(0.5, 0.5)
StarEffect.Transparency = 1
StarEffect.Image = "rbxassetid://5946093983"
StarEffect.ImageColor3 = Color3.new(0.815686, 0.14902, 1)
StarEffect.Parent = Effect

local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint.Parent = StarEffect

