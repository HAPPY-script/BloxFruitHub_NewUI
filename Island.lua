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

local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint.Parent = Animation2

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

local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint2.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint2.Parent = Animation3

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

local UIAspectRatioConstraint3 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint3.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint3.Parent = Animation4

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

local UIAspectRatioConstraint4 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint4.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint4.Parent = Animation5

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

local UIAspectRatioConstraint5 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint5.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint5.Parent = Animation1

--========================================================================================================================--
-- LOAD UI
--========================================================================================================================--
--Sea1
loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Island_UISea1.lua"))()

--Sea2
loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Island_UISea2.lua"))()

--Sea3
loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Island_UISea3.lua"))()
