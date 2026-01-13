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
