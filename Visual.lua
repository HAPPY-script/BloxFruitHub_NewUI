local ScrollingTab = game.Players.LocalPlayer.PlayerGui:WaitForChild("BloxFruitHubGui"):WaitForChild("Main"):WaitForChild("ScrollingTab")

local Visual = Instance.new("Frame")
Visual.Name = "Visual"
Visual.Size = UDim2.new(1, 0, 1, 0)
Visual.BackgroundColor3 = Color3.new(0.882353, 0, 1)
Visual.BackgroundTransparency = 1
Visual.BorderSizePixel = 0
Visual.BorderColor3 = Color3.new(0, 0, 0)
Visual.Transparency = 1
Visual.Parent = ScrollingTab

local Remove_fog = Instance.new("TextButton")
Remove_fog.Name = "Remove fog"
Remove_fog.Position = UDim2.new(0.5, 0, 0.03, 0)
Remove_fog.Size = UDim2.new(0.9, 0, 0.03, 0)
Remove_fog.BackgroundColor3 = Color3.new(1, 1, 1)
Remove_fog.BorderSizePixel = 0
Remove_fog.BorderColor3 = Color3.new(0, 0, 0)
Remove_fog.ZIndex = 2
Remove_fog.AnchorPoint = Vector2.new(0.5, 0.5)
Remove_fog.Text = "Remove fog"
Remove_fog.TextColor3 = Color3.new(0.243137, 0.243137, 0.243137)
Remove_fog.TextSize = 14
Remove_fog.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Remove_fog.TextScaled = true
Remove_fog.TextWrapped = true
Remove_fog.Parent = Visual

local UIStroke = Instance.new("UIStroke")
UIStroke.Name = "UIStroke"
UIStroke.Color = Color3.new(1, 1, 1)
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = Remove_fog

local UIGradient = Instance.new("UIGradient")
UIGradient.Name = "UIGradient"
UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(0.203922, 0.203922, 0.203922)), ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.new(0.203922, 0.203922, 0.203922))})
UIGradient.Parent = Remove_fog

local UIPlayers = Instance.new("Folder")
UIPlayers.Name = "UIPlayers"

UIPlayers.Parent = Visual

local PlayerFrame = Instance.new("ScrollingFrame")
PlayerFrame.Name = "PlayerFrame"
PlayerFrame.Position = UDim2.new(1.2, 0, 0.5, 0)
PlayerFrame.Size = UDim2.new(0.4, 0, 1, 0)
PlayerFrame.BackgroundColor3 = Color3.new(0.156863, 0, 0.235294)
PlayerFrame.BorderSizePixel = 0
PlayerFrame.BorderColor3 = Color3.new(0, 0, 0)
PlayerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
PlayerFrame.Active = true
PlayerFrame.CanvasSize = UDim2.new(0, 0, 7, 0)
PlayerFrame.ScrollBarImageColor3 = Color3.new(1, 0, 1)
PlayerFrame.ScrollBarThickness = 7
PlayerFrame.Parent = UIPlayers

local UICorner = Instance.new("UICorner")
UICorner.Name = "UICorner"
UICorner.CornerRadius = UDim.new(0.025, 0)
UICorner.Parent = PlayerFrame

local UIStroke2 = Instance.new("UIStroke")
UIStroke2.Name = "UIStroke"
UIStroke2.Color = Color3.new(1, 0, 1)
UIStroke2.Thickness = 2
UIStroke2.Transparency = 0.75
UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke2.Parent = PlayerFrame

local Player1 = Instance.new("Frame")
Player1.Name = "Player1"
Player1.Position = UDim2.new(0.5, 0, 0.02, 0)
Player1.Size = UDim2.new(0.9, 0, 0.025, 0)
Player1.BackgroundColor3 = Color3.new(0.298039, 0, 0.560784)
Player1.BorderSizePixel = 0
Player1.BorderColor3 = Color3.new(0, 0, 0)
Player1.AnchorPoint = Vector2.new(0.5, 0.5)
Player1.Parent = PlayerFrame

local UIStroke3 = Instance.new("UIStroke")
UIStroke3.Name = "UIStroke"
UIStroke3.Color = Color3.new(1, 0, 1)
UIStroke3.Thickness = 2
UIStroke3.Transparency = 0.75
UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke3.Parent = Player1

local UICorner2 = Instance.new("UICorner")
UICorner2.Name = "UICorner"
UICorner2.CornerRadius = UDim.new(0.025, 0)
UICorner2.Parent = Player1

local Avatar = Instance.new("ImageLabel")
Avatar.Name = "Avatar"
Avatar.Position = UDim2.new(0.15, 0, 0.5, 0)
Avatar.Size = UDim2.new(1, 0, 1, 0)
Avatar.BackgroundColor3 = Color3.new(1, 1, 1)
Avatar.BackgroundTransparency = 1
Avatar.BorderSizePixel = 0
Avatar.BorderColor3 = Color3.new(0, 0, 0)
Avatar.AnchorPoint = Vector2.new(0.5, 0.5)
Avatar.Transparency = 1
Avatar.Image = "rbxassetid://117259180607823"
Avatar.Parent = Player1

local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint.Parent = Avatar

local UICorner3 = Instance.new("UICorner")
UICorner3.Name = "UICorner"
UICorner3.CornerRadius = UDim.new(0.1, 0)
UICorner3.Parent = Avatar

local Name = Instance.new("TextLabel")
Name.Name = "Name"
Name.Position = UDim2.new(0.65, 0, 0.25, 0)
Name.Size = UDim2.new(0.65, 0, 0.5, 0)
Name.BackgroundColor3 = Color3.new(1, 1, 1)
Name.BackgroundTransparency = 1
Name.BorderSizePixel = 0
Name.BorderColor3 = Color3.new(0, 0, 0)
Name.AnchorPoint = Vector2.new(0.5, 0.5)
Name.Transparency = 1
Name.Text = "Username"
Name.TextColor3 = Color3.new(1, 1, 1)
Name.TextSize = 14
Name.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Name.TextScaled = true
Name.TextWrapped = true
Name.Parent = Player1

local ViewButton = Instance.new("TextButton")
ViewButton.Name = "ViewButton"
ViewButton.Position = UDim2.new(0.93, 0, 0.75, 0)
ViewButton.Size = UDim2.new(0.5, 0, 0.5, 0)
ViewButton.BackgroundColor3 = Color3.new(1, 0, 1)
ViewButton.BackgroundTransparency = 0.5
ViewButton.BorderSizePixel = 0
ViewButton.BorderColor3 = Color3.new(0, 0, 0)
ViewButton.AnchorPoint = Vector2.new(0.5, 0.5)
ViewButton.Transparency = 0.5
ViewButton.Text = ""
ViewButton.TextColor3 = Color3.new(0, 0, 0)
ViewButton.TextSize = 14
ViewButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
ViewButton.Parent = Player1

local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint2.Name = "UIAspectRatioConstraint"

UIAspectRatioConstraint2.Parent = ViewButton

local On = Instance.new("ImageLabel")
On.Name = "On"
On.Size = UDim2.new(1, 0, 1, 0)
On.BackgroundColor3 = Color3.new(1, 1, 1)
On.BackgroundTransparency = 1
On.BorderSizePixel = 0
On.BorderColor3 = Color3.new(0, 0, 0)
On.Visible = false
On.Transparency = 1
On.Image = "rbxassetid://16960977433"
On.Parent = ViewButton

local UICorner4 = Instance.new("UICorner")
UICorner4.Name = "UICorner"
UICorner4.CornerRadius = UDim.new(0.15, 0)
UICorner4.Parent = On

local Off = Instance.new("ImageLabel")
Off.Name = "Off"
Off.Size = UDim2.new(1, 0, 1, 0)
Off.BackgroundColor3 = Color3.new(0.0980392, 0.101961, 0.121569)
Off.BorderSizePixel = 0
Off.BorderColor3 = Color3.new(0, 0, 0)
Off.Image = "rbxassetid://7035631382"
Off.Parent = ViewButton

local UICorner5 = Instance.new("UICorner")
UICorner5.Name = "UICorner"
UICorner5.CornerRadius = UDim.new(0.15, 0)
UICorner5.Parent = Off

local UICorner6 = Instance.new("UICorner")
UICorner6.Name = "UICorner"
UICorner6.CornerRadius = UDim.new(0.15, 0)
UICorner6.Parent = ViewButton

local HPFrame = Instance.new("Frame")
HPFrame.Name = "HPFrame"
HPFrame.Position = UDim2.new(0.568, 0, 0.75, 0)
HPFrame.Size = UDim2.new(0.55, 0, 0.15, 0)
HPFrame.BackgroundColor3 = Color3.new(0.160784, 0, 0.317647)
HPFrame.BorderSizePixel = 0
HPFrame.BorderColor3 = Color3.new(0, 0, 0)
HPFrame.AnchorPoint = Vector2.new(0.5, 0.5)
HPFrame.Parent = Player1

local HP = Instance.new("Frame")
HP.Name = "HP"
HP.Size = UDim2.new(1, 0, 1, 0)
HP.BackgroundColor3 = Color3.new(0, 1, 0)
HP.BorderSizePixel = 0
HP.BorderColor3 = Color3.new(0, 0, 0)
HP.Parent = HPFrame

local CheckPlayersButton = Instance.new("TextButton")
CheckPlayersButton.Name = "CheckPlayersButton"
CheckPlayersButton.Position = UDim2.new(0.5, 0, 0.08, 0)
CheckPlayersButton.Size = UDim2.new(0.9, 0, 0.03, 0)
CheckPlayersButton.BackgroundColor3 = Color3.new(0, 0.666667, 0.392157)
CheckPlayersButton.BorderSizePixel = 0
CheckPlayersButton.BorderColor3 = Color3.new(0, 0, 0)
CheckPlayersButton.ZIndex = 2
CheckPlayersButton.AnchorPoint = Vector2.new(0.5, 0.5)
CheckPlayersButton.Text = "Check the players"
CheckPlayersButton.TextColor3 = Color3.new(1, 1, 1)
CheckPlayersButton.TextSize = 14
CheckPlayersButton.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
CheckPlayersButton.TextScaled = true
CheckPlayersButton.TextWrapped = true
CheckPlayersButton.Parent = Visual

local UIStroke4 = Instance.new("UIStroke")
UIStroke4.Name = "UIStroke"
UIStroke4.Color = Color3.new(1, 1, 1)
UIStroke4.Thickness = 2
UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke4.Parent = CheckPlayersButton

local AntiLagButton = Instance.new("TextButton")
AntiLagButton.Name = "AntiLagButton"
AntiLagButton.Position = UDim2.new(0.5, 0, 0.13, 0)
AntiLagButton.Size = UDim2.new(0.9, 0, 0.03, 0)
AntiLagButton.BackgroundColor3 = Color3.new(0.686275, 0, 0.117647)
AntiLagButton.BorderSizePixel = 0
AntiLagButton.BorderColor3 = Color3.new(0, 0, 0)
AntiLagButton.ZIndex = 2
AntiLagButton.AnchorPoint = Vector2.new(0.5, 0.5)
AntiLagButton.Text = "Anti lag"
AntiLagButton.TextColor3 = Color3.new(1, 1, 1)
AntiLagButton.TextSize = 14
AntiLagButton.FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AntiLagButton.TextScaled = true
AntiLagButton.TextWrapped = true
AntiLagButton.Parent = Visual

local UIStroke5 = Instance.new("UIStroke")
UIStroke5.Name = "UIStroke"
UIStroke5.Color = Color3.new(1, 1, 1)
UIStroke5.Thickness = 2
UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke5.Parent = AntiLagButton

local Frame = Visual
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
