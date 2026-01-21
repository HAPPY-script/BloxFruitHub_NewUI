--=== BUY / RANDOM RACE ===================================================================================================================--

do
    local Players = game:GetService("Players")
	local TweenService = game:GetService("TweenService")
	local Rep = game:GetService("ReplicatedStorage")
	
	local player = Players.LocalPlayer
	local PlayerGui = player:WaitForChild("PlayerGui")
	
	local Main = PlayerGui
		:WaitForChild("BloxFruitHubGui")
		:WaitForChild("Main")
	
	local Order = Main
		:WaitForChild("ScrollingTab")
		:WaitForChild("Order")
	
	--------------------------------------------------------
	-- BUY SYSTEM
	--------------------------------------------------------
	
	local CommF
	task.spawn(function()
		local remotes = Rep:FindFirstChild("Remotes")
		if remotes then
			CommF = remotes:FindFirstChild("CommF_")
		end
	
		if not CommF then
			warn("[Order] CommF_ remote not found, Buy system disabled.")
		end
	end)
	
	local GhoulBtn  = Order:WaitForChild("GhoulRace")
	local CyborgBtn = Order:WaitForChild("CyborgRace")
	local RandomBtn = Order:WaitForChild("RandomRaceFrame"):WaitForChild("RandomButton")
	
	local function safeInvoke(...)
		if not CommF then
			warn("[Order] Remote unavailable, skipping invoke.")
			return
		end
	
		local args = {...}
		local ok, err = pcall(function()
			CommF:InvokeServer(table.unpack(args))
		end)
	
		if not ok then
			warn("❌ Remote failed:", err)
		end
	end
	
	GhoulBtn.MouseButton1Click:Connect(function()
		safeInvoke("Ectoplasm", "Change", 4)
	end)
	
	CyborgBtn.MouseButton1Click:Connect(function()
		safeInvoke("CyborgTrainer", "Buy")
	end)
	
	RandomBtn.MouseButton1Click:Connect(function()
		safeInvoke("BlackbeardReward", "Reroll", "2")
	end)
	
	--------------------------------------------------------
	-- HOVER EFFECT (GhoulRace / CyborgRace)
	--------------------------------------------------------
	local tweenInfoHover = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local DEFAULT_OFFSET = Vector2.new(0, 1)
	local HOVER_OFFSET = Vector2.new(0, -0.15)
	
	local function setupHover(btn)
		local label = btn:FindFirstChildOfClass("TextLabel")
		local grad = btn:FindFirstChildOfClass("UIGradient")
	
		if not (label and grad) then
			warn("Missing TextLabel/UIGradient in", btn:GetFullName())
			return
		end
	
		label.TextTransparency = 1
		grad.Offset = DEFAULT_OFFSET
	
		local tweenG, tweenT
	
		local function tweenTo(offset, transparency)
			if tweenG then tweenG:Cancel() end
			if tweenT then tweenT:Cancel() end
	
			tweenG = TweenService:Create(grad, tweenInfoHover, {Offset = offset})
			tweenT = TweenService:Create(label, tweenInfoHover, {TextTransparency = transparency})
	
			tweenG:Play()
			tweenT:Play()
		end
	
		btn.MouseEnter:Connect(function()
			tweenTo(HOVER_OFFSET, 0)
		end)
	
		btn.MouseLeave:Connect(function()
			tweenTo(DEFAULT_OFFSET, 1)
		end)
	
		btn.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch then
				tweenTo(HOVER_OFFSET, 0)
			end
		end)
	
		btn.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch then
				tweenTo(DEFAULT_OFFSET, 1)
			end
		end)
	end
	
	setupHover(GhoulBtn)
	setupHover(CyborgBtn)
	
	--------------------------------------------------------
	-- RANDOM RACE EFFECT
	--------------------------------------------------------
	local frame = Order:WaitForChild("RandomRaceFrame")
	
	local imgs = {
		frame:WaitForChild("Human"),
		frame:WaitForChild("Angel"),
		frame:WaitForChild("Shark"),
		frame:WaitForChild("Rabbit")
	}
	
	local roles = {
		Begin = {
			Position = UDim2.new(0.15,0,0.7,0),
			Size = UDim2.new(0.5,0,0.5,0),
			ImageTransparency = 0.5,
			ZIndex = 4
		},
		Display = {
			Position = UDim2.new(0.5,0,0.5,0),
			Size = UDim2.new(0.8,0,0.8,0),
			ImageTransparency = 0,
			ZIndex = 3
		},
		Hide = {
			Position = UDim2.new(0.85,0,0.7,0),
			Size = UDim2.new(0.5,0,0.5,0),
			ImageTransparency = 0.5,
			ZIndex = 2
		},
		Hidden = {
			Position = UDim2.new(0.5,0,0.5,0),
			Size = UDim2.new(0.5,0,0.5,0),
			ImageTransparency = 1,
			ZIndex = 1
		}
	}
	
	local orderFlow = {"Begin", "Display", "Hide", "Hidden"}
	local tweenInfo = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	local function shuffle(t)
		for i = #t, 2, -1 do
			local j = math.random(i)
			t[i], t[j] = t[j], t[i]
		end
	end
	
	shuffle(imgs)
	
	local assigned = {}
	for i, img in ipairs(imgs) do
		assigned[img] = orderFlow[i]
	end
	
	local function apply(img, role, prevRole)
		local cfg = roles[role]
	
		local tween = TweenService:Create(img, tweenInfo, {
			Position = cfg.Position,
			Size = cfg.Size,
			ImageTransparency = cfg.ImageTransparency
		})
	
		if prevRole == "Hidden" and role == "Begin" then
			tween.Completed:Once(function()
				img.ZIndex = cfg.ZIndex
			end)
		else
			img.ZIndex = cfg.ZIndex
		end
	
		tween:Play()
	end
	
	for img, role in pairs(assigned) do
		apply(img, role)
	end
	
	task.spawn(function()
		while true do
			task.wait(2)
	
			if not (Order.Visible and Main.Visible) then
				repeat task.wait() until (Order.Visible and Main.Visible)
			end
	
			for img, role in pairs(assigned) do
				local idx = table.find(orderFlow, role)
				local nextRole = orderFlow[(idx % #orderFlow) + 1]
				assigned[img] = nextRole
				apply(img, nextRole, role)
			end
		end
	end)
end

--=== AUTO RANDOM BONE ===================================================================================================================--

do
	local Players = game:GetService("Players")
	local Rep = game:GetService("ReplicatedStorage")

	local player = Players.LocalPlayer
	local INTERVAL = 2

	-- chờ ToggleUI
	repeat task.wait() until _G.ToggleUI
	local ToggleUI = _G.ToggleUI
	pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)

	-- PATH chuẩn tới Order
	local Order = player.PlayerGui
		:WaitForChild("BloxFruitHubGui")
		:WaitForChild("Main")
		:WaitForChild("ScrollingTab")
		:WaitForChild("Order")

	-- Button
	local BUTTON_NAME = "RandomBoneButton"
	local button = Order:FindFirstChild(BUTTON_NAME, true)
	if not button then
		warn("Không tìm thấy RandomBoneButton trong Order")
		return
	end

	-- Remote (an toàn)
	local CommF
	task.spawn(function()
		local remotes = Rep:FindFirstChild("Remotes")
		if remotes then
			CommF = remotes:FindFirstChild("CommF_")
		end
		if not CommF then
			warn("[RandomBone] CommF_ not found")
		end
	end)

	-- State
	local ATTR = "AutoRandomBone"
	local auto = false
	local suppressAttrToUI = false
	local suppressUIToAttr = false

	-- Gọi remote
	local function buyBone()
		if not CommF then return end
		pcall(function()
			CommF:InvokeServer("Bones", "Buy", 1, 1)
		end)
	end

	-- Init Attribute
	do
		local attr = player:GetAttribute(ATTR)
		if attr ~= nil then
			auto = attr == true
		else
			player:SetAttribute(ATTR, auto)
		end

		suppressUIToAttr = true
		pcall(function() ToggleUI.Set(BUTTON_NAME, auto) end)
		task.delay(0.05, function() suppressUIToAttr = false end)
	end

	-- detect bật/tắt từ màu
	local function inferToggle(btn)
		local bg
		pcall(function() bg = btn.BackgroundColor3 end)
		if not bg then return false end
		return bg.G > bg.R and bg.G > bg.B and bg.G > 0.5
	end

	-- UI → Attribute
	button:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
		task.delay(0.05, function()
			if suppressUIToAttr then return end
			local isOn = inferToggle(button)
			if player:GetAttribute(ATTR) ~= isOn then
				suppressAttrToUI = true
				player:SetAttribute(ATTR, isOn)
				task.delay(0.05, function() suppressAttrToUI = false end)
			end
		end)
	end)

	-- Click → ToggleUI
	local function onClick()
		local cur = inferToggle(button)
		pcall(function() ToggleUI.Set(BUTTON_NAME, not cur) end)
	end
	if button.Activated then
		button.Activated:Connect(onClick)
	else
		button.MouseButton1Click:Connect(onClick)
	end

	-- Attribute → UI + logic
	player:GetAttributeChangedSignal(ATTR):Connect(function()
		auto = player:GetAttribute(ATTR) == true

		if not suppressAttrToUI then
			suppressUIToAttr = true
			pcall(function() ToggleUI.Set(BUTTON_NAME, auto) end)
			task.delay(0.05, function() suppressUIToAttr = false end)
		end

		if auto then
			buyBone()
		end
	end)

	-- Loop chính
	task.spawn(function()
		while true do
			if auto then
				buyBone()
				task.wait(INTERVAL)
			else
				task.wait(0.3)
			end
		end
	end)

	-- Legacy shared support
	shared = shared or {}
	shared.ToggleRandomBone = function(v)
		player:SetAttribute(ATTR, v == true)
	end
end
