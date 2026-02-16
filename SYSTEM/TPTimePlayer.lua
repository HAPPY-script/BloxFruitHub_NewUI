--// HAPPY Script - Follow TP UI (StarterPlayerScripts)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer

--================ UI CREATE ================--

local gui = Instance.new("ScreenGui")
gui.Name = "FollowTP_UI"
gui.ResetOnSpawn = false
gui.Parent = lp:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local drag = Instance.new("UIDragDetector")
drag.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundTransparency = 1
title.Text = "TP Follow"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = frame

-- Close Button (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -28, 0, 0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = frame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- TextBox nhập tên
local box = Instance.new("TextBox")
box.Size = UDim2.new(0.9, 0, 0, 28)
box.Position = UDim2.new(0.05, 0, 0.25, 0)
box.PlaceholderText = "Enter name (min 3 letters)"
box.Text = ""
box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
box.TextColor3 = Color3.new(1, 1, 1)
box.Font = Enum.Font.Gotham
box.TextSize = 13
box.Parent = frame
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

-- TextBox nhập time
local timeBox = Instance.new("TextBox")
timeBox.Size = UDim2.new(0.9, 0, 0, 28)
timeBox.Position = UDim2.new(0.05, 0, 0.47, 0)
timeBox.PlaceholderText = "Time (sec) blank = infinite"
timeBox.Text = ""
timeBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
timeBox.TextColor3 = Color3.new(1, 1, 1)
timeBox.Font = Enum.Font.Gotham
timeBox.TextSize = 13
timeBox.Parent = frame
Instance.new("UICorner", timeBox).CornerRadius = UDim.new(0, 8)

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 30)
toggleBtn.Position = UDim2.new(0.05, 0, 0.72, 0)
toggleBtn.Text = "OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.Parent = frame
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

--================ LOGIC ================--

local running = false
local conn

-- Hàm tìm player theo 3+ ký tự đầu
local function findPlayer(partialName)
	if #partialName < 3 then return nil end
	partialName = partialName:lower()

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= lp and plr.Name:lower():sub(1, #partialName) == partialName then
			return plr
		end
	end
	return nil
end

-- Stop teleport
local function stopTP()
	running = false
	toggleBtn.Text = "OFF"
	toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)

	if conn then
		conn:Disconnect()
		conn = nil
	end
end

-- Start teleport
local function startTP()
	local target = findPlayer(box.Text)

	if not target then
		toggleBtn.Text = "NOT FOUND"
		task.wait(0.7)
		toggleBtn.Text = "OFF"
		return
	end

	running = true
	toggleBtn.Text = "ON"
	toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 80)

	-- Nếu có nhập time thì auto stop sau X giây
	local t = tonumber(timeBox.Text)
	if t and t > 0 then
		task.delay(t, function()
			if running then
				stopTP()
			end
		end)
	end

	-- Teleport 60 lần/s
	conn = RunService.RenderStepped:Connect(function()
		if not running then return end

		local char = lp.Character
		local tChar = target.Character
		if not (char and tChar) then return end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		local tHrp = tChar:FindFirstChild("HumanoidRootPart")
		if hrp and tHrp then
			hrp.CFrame = tHrp.CFrame * CFrame.new(0, 0, 2)
		end
	end)
end

-- Toggle click
toggleBtn.MouseButton1Click:Connect(function()
	if running then
		stopTP()
	else
		startTP()
	end
end)

-- Close button
closeBtn.MouseButton1Click:Connect(function()
	stopTP()
	gui:Destroy()
end)
