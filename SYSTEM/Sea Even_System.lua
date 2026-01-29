--=== AUTO BOAT DRIVE =======================================================================================================================--
do
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")
    
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local ScrollingTab = playerGui:WaitForChild("BloxFruitHubGui"):WaitForChild("Main"):WaitForChild("ScrollingTab")
    
    -- ================= CONFIG (UI paths - must exist) =================
    local SEA_FRAME = ScrollingTab:WaitForChild("Sea Even")
    local Bar        = SEA_FRAME:WaitForChild("ElevationFrame"):WaitForChild("Bar")
    local Fill       = Bar:WaitForChild("Fill")
    local Knob       = Bar:WaitForChild("Knob")
    local ElevationContainer = SEA_FRAME:WaitForChild("ElevationBox")
    local TOGGLE_BUTTON_NAME = "AutoBoatDriveButton" -- name to find inside Sea Even
    -- ==================================================================
    
    -- ===== Slider range / defaults / colors =====
    local MIN_VAL = 30
    local MAX_VAL = 200
    local DEFAULT_INIT = 125
    
    local COLOR_MIN = Color3.fromRGB(255, 0, 255)
    local COLOR_MAX = Color3.fromRGB(255, 0, 100)
    
    -- ===== Wind stream params (STREAM_Y driven by slider) =====
    local SPEED = 250
    local STREAM_Y = DEFAULT_INIT
    local STREAM_Z = 635
    local STREAM_ORIGIN_X = -17500
    local ARRIVE_EPS = 1
    
    -- ===== Core state for movement =====
    local movementToken = 0
    local running = false
    local terminated = false
    
    -- ===== Slider core state =====
    local dragging = false
    local valueAlpha = 0 -- 0..1
    local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local textboxEditing = false
    
    -- ===== Utility =====
    local function clamp(v, a, b) return math.clamp and math.clamp(v, a, b) or (v < a and a or (v > b and b or v)) end
    local function alphaToValue(a) a = clamp(a,0,1); return a * (MAX_VAL - MIN_VAL) + MIN_VAL end
    local function valueToAlpha(v) v = clamp(v, MIN_VAL, MAX_VAL); return (v - MIN_VAL) / (MAX_VAL - MIN_VAL) end
    
    -- ===== Find the real text object for elevation =====
    local ElevationTextObject = nil
    do
    	local container = ElevationContainer
    	if container then
    		if container:IsA("TextBox") or container:IsA("TextLabel") then
    			ElevationTextObject = container
    		else
    			ElevationTextObject = container:FindFirstChildWhichIsA("TextBox", true) or container:FindFirstChildWhichIsA("TextLabel", true)
    			if not ElevationTextObject then ElevationTextObject = container end
    		end
    	end
    end
    
    local function parseIntegerFromString(s)
    	if not s then return nil end
    	local str = tostring(s)
    	local numstr = str:match("%-?%d+")
    	if not numstr then return nil end
    	local n = tonumber(numstr)
    	if not n then return nil end
    	return math.floor(n + 0.5)
    end
    
    local function lerpColor(c1, c2, t)
    	return Color3.new(
    		c1.R + (c2.R - c1.R) * t,
    		c1.G + (c2.G - c1.G) * t,
    		c1.B + (c2.B - c1.B) * t
    	)
    end
    
    -- Callback when slider numeric value changes (value = number in MIN..MAX)
    local function onSliderValueChanged(num)
    	STREAM_Y = num
    	-- you can expose or use STREAM_Y elsewhere if needed
    end
    
    -- safe set text (avoid overwriting while typing)
    local function setTextSafe(text)
    	if not ElevationTextObject then return end
    	if ElevationTextObject:IsA("TextBox") then
    		if not textboxEditing then
    			pcall(function() ElevationTextObject.Text = tostring(text) end)
    		end
    	else
    		pcall(function() ElevationTextObject.Text = tostring(text) end)
    	end
    end
    
    -- Slider apply: size/knob/color/tween + call value changed
    local function apply(alpha, smooth)
    	alpha = clamp(alpha, 0, 1)
    	valueAlpha = alpha
    
    	local knobHalfX = (Knob.AbsoluteSize and Knob.AbsoluteSize.X) and (Knob.AbsoluteSize.X/2) or 8
    	local knobHalfY = (Knob.AbsoluteSize and Knob.AbsoluteSize.Y) and (Knob.AbsoluteSize.Y/2) or 8
    
    	local sizeGoal = { Size = UDim2.new(alpha, 0, 1, 0) }
    	local posGoal  = { Position = UDim2.new(alpha, -knobHalfX, 0.5, -knobHalfY) }
    
    	local targetColor = lerpColor(COLOR_MIN, COLOR_MAX, alpha)
    	local colorGoal = { BackgroundColor3 = targetColor }
    
    	if smooth then
    		pcall(function()
    			TweenService:Create(Fill, tweenInfo, sizeGoal):Play()
    			TweenService:Create(Knob, tweenInfo, posGoal):Play()
    			TweenService:Create(Fill, tweenInfo, colorGoal):Play()
    		end)
    	else
    		pcall(function()
    			Fill.Size = sizeGoal.Size
    			Knob.Position = posGoal.Position
    			Fill.BackgroundColor3 = targetColor
    		end)
    	end
    
    	local valNum = math.floor(alphaToValue(alpha) + 0.5)
    	setTextSafe(valNum)
    	onSliderValueChanged(valNum)
    end
    
    local function getAlphaFromMouse(x)
    	local bx = Bar.AbsolutePosition.X
    	local bw = Bar.AbsoluteSize.X
    	if not bw or bw == 0 then return 0 end
    	return (x - bx) / bw
    end
    
    -- ===== Slider input wiring =====
    Knob.InputBegan:Connect(function(i)
    	if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    
    Bar.InputBegan:Connect(function(i)
    	if i.UserInputType == Enum.UserInputType.MouseButton1 then
    		dragging = true
    		apply(getAlphaFromMouse(UIS:GetMouseLocation().X), true)
    	end
    end)
    
    UIS.InputEnded:Connect(function(i)
    	if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    
    RunService.RenderStepped:Connect(function()
    	if dragging then
    		apply(getAlphaFromMouse(UIS:GetMouseLocation().X), true)
    	end
    end)
    
    -- ===== Elevation textbox handling =====
    if ElevationTextObject and ElevationTextObject:IsA("TextBox") then
    	ElevationTextObject.Focused:Connect(function() textboxEditing = true end)
    	ElevationTextObject.FocusLost:Connect(function(enterPressed)
    		textboxEditing = false
    		local raw
    		pcall(function() raw = ElevationTextObject.Text end)
    		local n = parseIntegerFromString(raw)
    		if n then
    			local clamped = clamp(n, MIN_VAL, MAX_VAL)
    			apply(valueToAlpha(clamped), true)
    			pcall(function() ElevationTextObject.Text = tostring(clamped) end)
    		else
    			local cur = math.floor(alphaToValue(valueAlpha) + 0.5)
    			pcall(function() ElevationTextObject.Text = tostring(cur) end)
    		end
    	end)
    end
    
    -- ===== Slider initialization =====
    do
    	local initAlpha = nil
    	-- prefer numeric text if present
    	if ElevationTextObject then
    		local ok, txt = pcall(function() return ElevationTextObject.Text end)
    		if ok and txt and tostring(txt) ~= "" then
    			local n = parseIntegerFromString(txt)
    			if n then initAlpha = valueToAlpha(n) end
    		end
    	end
    	-- otherwise force default
    	if not initAlpha then initAlpha = valueToAlpha(DEFAULT_INIT) end
    
    	apply(initAlpha, false)
    	-- ensure text shows exact initial
    	setTextSafe(math.floor(alphaToValue(initAlpha) + 0.5))
    end
    
    -- ================= WindStream movement functions =================
    
    local function getHRP()
    	local char = player.Character or player.CharacterAdded:Wait()
    	return char:WaitForChild("HumanoidRootPart")
    end
    
    local function stopMovement()
    	movementToken = movementToken + 1
    end
    
    local function getHumanoid()
    	local char = player.Character or player.CharacterAdded:Wait()
    	return char:WaitForChild("Humanoid")
    end
    
    local function isSitting()
    	local hum = getHumanoid()
    	return hum and hum.Sit
    end
    
    local function lungeTo(targetPos)
    	local hrp = getHRP()
    	local myToken = movementToken
    
    	local start = hrp.Position
    	local delta = targetPos - start
    	local dist = delta.Magnitude
    	if dist < ARRIVE_EPS then
    		if dist > 0 then
    			local dir = delta.Unit
    			hrp.CFrame = CFrame.lookAt(start, start + dir, Vector3.new(0,1,0))
    		end
    		return true
    	end
    
    	local dir = delta.Unit
    	local duration = dist / SPEED
    	local elapsed = 0
    	local done = false
    
    	local conn
    	conn = RunService.Heartbeat:Connect(function(dt)
    		if myToken ~= movementToken then conn:Disconnect(); return end
    		elapsed = elapsed + dt
    		local a = math.clamp(elapsed / duration, 0, 1)
    		local pos = start + dir * dist * a
    		hrp.CFrame = CFrame.lookAt(pos, pos + dir, Vector3.new(0,1,0))
    		if a >= 1 then conn:Disconnect(); done = true end
    	end)
    
    	while not done and myToken == movementToken do task.wait() end
    
    	if myToken == movementToken then
    		local finalPos = start + dir * dist
    		hrp.CFrame = CFrame.lookAt(finalPos, finalPos + dir, Vector3.new(0,1,0))
    	end
    
    	return myToken == movementToken
    end
    
    local function nearestPoint(pos)
    	local x = math.min(pos.X, STREAM_ORIGIN_X)
    	return Vector3.new(x, STREAM_Y, STREAM_Z)
    end
    
    local runSystem -- forward declare
    
    local function flyAlongStream(myToken)
    	local hrp = getHRP()
    	local hum
    	pcall(function() hum = getHumanoid() end)
    
    	local conn
    	conn = RunService.Heartbeat:Connect(function(dt)
    		if myToken ~= movementToken or not running or terminated then conn:Disconnect(); return end
    
    		if not hum or not hum.Parent then
    			local ok, h = pcall(function() return getHumanoid() end)
    			if ok then hum = h end
    		end
    
    		-- if not sitting -> stop and restart runSystem
    		if not (hum and hum.Sit) then
    			movementToken = movementToken + 1
    			conn:Disconnect()
    			if type(runSystem) == "function" then task.spawn(runSystem) end
    			return
    		end
    
    		local p = hrp.Position
    		local newX = p.X - SPEED * dt
    		local pos = Vector3.new(newX, STREAM_Y, STREAM_Z)
    		local lookTarget = pos + Vector3.new(-1, 0, 0)
    		hrp.CFrame = CFrame.lookAt(pos, lookTarget, Vector3.new(0,1,0))
    	end)
    end
    
    -- ============== Auto-boat helpers ==============
    local BoatsFolder = workspace:WaitForChild("Boats")
    local BOAT_RADIUS = 2500
    local SEAT_APPROACH_DIST = 100
    local SEAT_TP_INTERVAL = 1.5
    
    local function findNearestBoat()
    	local hrp = getHRP()
    	local nearest, nearestDist
    	for _, boat in ipairs(BoatsFolder:GetChildren()) do
    		if boat:IsA("Model") then
    			local ref = boat.PrimaryPart or boat:FindFirstChildWhichIsA("BasePart")
    			if ref then
    				local d = (ref.Position - hrp.Position).Magnitude
    				if d <= BOAT_RADIUS and (not nearestDist or d < nearestDist) then
    					nearest = boat
    					nearestDist = d
    				end
    			end
    		end
    	end
    	return nearest
    end
    
    local function findVehicleSeat(boat)
    	for _, obj in ipairs(boat:GetChildren()) do
    		if obj:IsA("VehicleSeat") then return obj end
    	end
    end
    
    local function tryEnterSeat(seat)
    	local hrp = getHRP()
    	local hum = getHumanoid()
    
    	local dir = (seat.Position - hrp.Position)
    	if dir.Magnitude > SEAT_APPROACH_DIST then
    		local approachPos = seat.Position - dir.Unit * SEAT_APPROACH_DIST
    		if lungeTo(approachPos) then
    			local lookDir = (seat.Position - approachPos).Unit
    			hrp.CFrame = CFrame.lookAt(approachPos, approachPos + lookDir, Vector3.new(0,1,0))
    		end
    	end
    
    	while running and not terminated do
    		hum = getHumanoid()
    		if hum and hum.Sit then break end
    		if not seat or not seat.Parent then break end
    		pcall(function()
    			local targetPos = seat.Position + Vector3.new(0,2,0)
    			hrp.CFrame = CFrame.lookAt(targetPos, seat.Position, Vector3.new(0,1,0))
    		end)
    		task.wait(SEAT_TP_INTERVAL)
    	end
    end
    
    local function autoBoatLoop()
    	task.spawn(function()
    		while running and not terminated do
    			if not isSitting() then
    				local boat = findNearestBoat()
    				if boat then
    					local seat = findVehicleSeat(boat)
    					if seat then tryEnterSeat(seat) end
    				end
    			end
    			task.wait(0.4)
    		end
    	end)
    end
    
    -- main runSystem
    runSystem = function()
    	local myToken = movementToken
    
    	autoBoatLoop()
    
    	-- wait until sitting
    	while running and not terminated do
    		if isSitting() then break end
    		task.wait(0.2)
    	end
    
    	if not running or terminated or myToken ~= movementToken then return end
    
    	local hrp = getHRP()
    	local entry = nearestPoint(hrp.Position)
    	if (hrp.Position - entry).Magnitude > ARRIVE_EPS then
    		if not lungeTo(entry) or myToken ~= movementToken then return end
    	end
    
    	flyAlongStream(myToken)
    end
    
    -- ================= ToggleUI integration (use existing AutoBoatDriveButton) =================
    -- wait for ToggleUI helper
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)
    
    -- find button inside Sea Even
    local toggleButton = SEA_FRAME:FindFirstChild(TOGGLE_BUTTON_NAME, true)
    if not toggleButton then
    	warn("AutoBoatDriveButton not found in 'Sea Even' frame")
    else
    	-- helper: exact color check (0,255,0 => ON)
    	local function isButtonOn(btn)
    		local ok, c = pcall(function() return btn.BackgroundColor3 end)
    		if not ok or not c then return false end
    		local r = math.floor(c.R * 255 + 0.5)
    		local g = math.floor(c.G * 255 + 0.5)
    		local b = math.floor(c.B * 255 + 0.5)
    		return (r == 0 and g == 255 and b == 0)
    	end
    
    	-- initialize ToggleUI state: ensure Set exists; do not force SetDefault
    	pcall(function() ToggleUI.Set(TOGGLE_BUTTON_NAME, false) end)
    
    	local function startRunning()
    		if terminated then return end
    		if not running then
    			running = true
    			movementToken = movementToken + 1
    			task.spawn(runSystem)
    		end
    	end
    
    	local function stopRunning()
    		if running then
    			running = false
    			stopMovement()
    		end
    	end
    
    	-- connect button activation to request ToggleUI change
    	if toggleButton.Activated then
    		toggleButton.Activated:Connect(function() pcall(function() ToggleUI.Set(TOGGLE_BUTTON_NAME, not isButtonOn(toggleButton)) end) end)
    	else
    		toggleButton.MouseButton1Click:Connect(function() pcall(function() ToggleUI.Set(TOGGLE_BUTTON_NAME, not isButtonOn(toggleButton)) end) end)
    	end
    
    	-- when color changes, update running state after small delay to allow ToggleUI tween
    	toggleButton:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
    		task.delay(0.05, function()
    			local on = isButtonOn(toggleButton)
    			if on and (not running) then
    				startRunning()
    			elseif (not on) and running then
    				stopRunning()
    			end
    		end)
    	end)
    
    	-- initialize running according to current color
    	if isButtonOn(toggleButton) then
    		startRunning()
    	else
    		stopRunning()
    	end
    end
    
    -- expose stop function
    _G.WindStreamStop = function()
    	running = false
    	stopMovement()
    end
    
    -- expose a helper to set STREAM_Y programmatically (value in MIN..MAX)
    _G.SetWindStreamY = function(num)
    	num = tonumber(num) or DEFAULT_INIT
    	num = clamp(num, MIN_VAL, MAX_VAL)
    	apply(valueToAlpha(num), true)
    end
end
