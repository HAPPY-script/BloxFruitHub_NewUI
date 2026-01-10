-- ========================
-- SERVICES & BASE REFERENCES
-- ========================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local GUI_NAME = "BloxFruitHubGui"
local gui = playerGui:WaitForChild(GUI_NAME)

-- Main GUI parts (shared)
local Main = gui:WaitForChild("Main")
local White = gui:WaitForChild("White")
local Gradient = White:WaitForChild("UIGradient")
local ToggleButton = gui:WaitForChild("Button")           -- button to open/close main

local TopButton = Main:WaitForChild("TopButton")         -- top scroll-to-top button
local ScrollingTab = Main:WaitForChild("ScrollingTab")   -- content area
local ScrollingSelectTab = Main:WaitForChild("ScrollingSelectTab") -- select buttons area
local TabNameLabel = Main:FindFirstChild("TabName")      -- optional

-- ========================
-- TIP: Section A - EffectOpen/CloseMain (toggle Main with White + Gradient)
-- ========================
local OpenClose = {}
do
	-- CONFIG
	OpenClose.DRAG_SPEED = 0.12
	OpenClose.FADE_TIME = 0.25
	OpenClose.GRAD_TIME = 0.3
	OpenClose.GRAD_START = Vector2.new(0, -2.5)
	OpenClose.GRAD_END = Vector2.new(0, 2.5)

	-- STATE
	OpenClose.opened = false
	OpenClose.busy = false
	OpenClose.mainDragDetector = nil
	OpenClose.moved = false
	OpenClose.dragging = false
	OpenClose.dragStart = nil
	OpenClose.startPos = nil

	-- DRAG for ToggleButton
	local function tweenToggleButton(pos)
		TweenService:Create(ToggleButton, TweenInfo.new(OpenClose.DRAG_SPEED, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Position = pos }):Play()
	end
	local function updateToggleDrag(input)
		local delta = input.Position - OpenClose.dragStart
		tweenToggleButton(UDim2.new(
			OpenClose.startPos.X.Scale,
			OpenClose.startPos.X.Offset + delta.X,
			OpenClose.startPos.Y.Scale,
			OpenClose.startPos.Y.Offset + delta.Y
			))
	end

	-- Hook toggle drag input
	ToggleButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			OpenClose.dragging = true
			OpenClose.moved = false
			OpenClose.dragStart = input.Position
			OpenClose.startPos = ToggleButton.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					OpenClose.dragging = false
				end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if OpenClose.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			OpenClose.moved = true
			updateToggleDrag(input)
		end
	end)

	-- attach/detach drag detector on Main
	function OpenClose.attachMainDrag()
		if not OpenClose.mainDragDetector then
			OpenClose.mainDragDetector = Instance.new("UIDragDetector")
			OpenClose.mainDragDetector.Parent = Main
		end
	end
	function OpenClose.detachMainDrag()
		if OpenClose.mainDragDetector then
			OpenClose.mainDragDetector:Destroy()
			OpenClose.mainDragDetector = nil
		end
	end

	-- OPEN sequence
	function OpenClose.openMain()
		OpenClose.busy = true
		White.Position = Main.Position
		White.BackgroundTransparency = 1
		Gradient.Offset = OpenClose.GRAD_START

		TweenService:Create(White, TweenInfo.new(OpenClose.FADE_TIME), { BackgroundTransparency = 0 }):Play()
		task.wait(OpenClose.FADE_TIME)

		Main.Visible = true

		TweenService:Create(Gradient, TweenInfo.new(OpenClose.GRAD_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Offset = OpenClose.GRAD_END }):Play()
		task.wait(OpenClose.GRAD_TIME)

		OpenClose.attachMainDrag()
		OpenClose.opened = true
		OpenClose.busy = false
	end

	-- CLOSE sequence (detach drag FIRST per your fix)
	function OpenClose.closeMain()
		OpenClose.busy = true

		-- detach immediately
		OpenClose.detachMainDrag()

		White.Position = Main.Position

		TweenService:Create(Gradient, TweenInfo.new(OpenClose.GRAD_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Offset = OpenClose.GRAD_START }):Play()
		task.wait(OpenClose.GRAD_TIME)

		Main.Visible = false

		TweenService:Create(White, TweenInfo.new(OpenClose.FADE_TIME), { BackgroundTransparency = 1 }):Play()
		task.wait(OpenClose.FADE_TIME)

		OpenClose.opened = false
		OpenClose.busy = false
	end

	-- toggle function
	function OpenClose.toggleMain()
		if OpenClose.busy then return end
		if OpenClose.opened then
			OpenClose.closeMain()
		else
			OpenClose.openMain()
		end
	end

	-- connect click
	ToggleButton.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if not OpenClose.moved then
				OpenClose.toggleMain()
			end
		end
	end)

	-- init
	Main.Visible = false
	White.BackgroundTransparency = 1
	Gradient.Offset = OpenClose.GRAD_START
end

-- ========================
-- TIP: Section B - TopButtonSystem (scroll to top, show/hide on scroll)
-- ========================
local TopSystem = {}
do
	TopSystem.TWEEN_TIME = 0.25
	TopSystem.OPEN_STATE = {
		Position = UDim2.new(0.5, 0, 1.125, 0),
		ImageTransparency = 0,
		BackgroundTransparency = 0.25,
	}
	TopSystem.CLOSE_STATE = {
		Position = UDim2.new(0.5, 0, 1.085, 0),
		ImageTransparency = 1,
		BackgroundTransparency = 1,
	}
	TopSystem.opened = false
	TopSystem.btnTween = nil
	TopSystem.scrollTween = nil

	local function tweenButton(state)
		if TopSystem.btnTween then TopSystem.btnTween:Cancel() end
		TopSystem.btnTween = TweenService:Create(TopButton, TweenInfo.new(TopSystem.TWEEN_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), state)
		TopSystem.btnTween:Play()
	end

	function TopSystem.openButton()
		if TopSystem.opened then return end
		TopSystem.opened = true
		tweenButton(TopSystem.OPEN_STATE)
	end
	function TopSystem.closeButton()
		if not TopSystem.opened then return end
		TopSystem.opened = false
		tweenButton(TopSystem.CLOSE_STATE)
	end

	-- init
	TopButton.Position = TopSystem.CLOSE_STATE.Position
	TopButton.ImageTransparency = TopSystem.CLOSE_STATE.ImageTransparency
	TopButton.BackgroundTransparency = TopSystem.CLOSE_STATE.BackgroundTransparency

	-- show/hide based on scroll Y
	RunService.RenderStepped:Connect(function()
		if ScrollingTab.CanvasPosition.Y > 0 then
			TopSystem.openButton()
		else
			TopSystem.closeButton()
		end
	end)

	-- click to tween to top
	TopButton.InputEnded:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		if TopSystem.scrollTween then TopSystem.scrollTween:Cancel() end
		TopSystem.scrollTween = TweenService:Create(ScrollingTab, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { CanvasPosition = Vector2.new(0, 0) })
		TopSystem.scrollTween:Play()
	end)
end

-- ========================
-- TIP: Section C - EffectSelectTab (hover color on select buttons, mobile swipe)
-- ========================
local SelectEffects = {}
do
	SelectEffects.HOVER_COLOR = Color3.fromRGB(255, 0, 255)
	SelectEffects.NORMAL_COLOR = Color3.fromRGB(255, 255, 255)
	SelectEffects.TWEEN_TIME = 0.12
	SelectEffects.EASING = Enum.EasingStyle.Quad
	SelectEffects.DIR = Enum.EasingDirection.Out

	local buttonState = {} -- [button] = { hovering = bool, currentTween = Tween | nil }

	local function ensureState(btn)
		if not buttonState[btn] then buttonState[btn] = { hovering = false, currentTween = nil } end
		return buttonState[btn]
	end

	local function playColorTween(btn, targetColor)
		if not btn or not btn.Parent then return end
		local st = ensureState(btn)
		if st.currentTween then st.currentTween:Cancel(); st.currentTween = nil end
		local ti = TweenInfo.new(SelectEffects.TWEEN_TIME, SelectEffects.EASING, SelectEffects.DIR)
		local tween = TweenService:Create(btn, ti, { ImageColor3 = targetColor })
		st.currentTween = tween
		tween:Play()
		tween.Completed:Connect(function()
			if st.currentTween == tween then st.currentTween = nil end
		end)
	end

	local function setHover(btn, hover)
		local st = ensureState(btn)
		if hover then
			if st.hovering then return end
			st.hovering = true
			playColorTween(btn, SelectEffects.HOVER_COLOR)
		else
			if not st.hovering then return end
			st.hovering = false
			playColorTween(btn, SelectEffects.NORMAL_COLOR)
		end
	end

	local function setupSelectButton(btn)
		if not btn or not (btn:IsA("ImageButton") or btn:IsA("TextButton")) then return end
		btn.ImageColor3 = SelectEffects.NORMAL_COLOR
		ensureState(btn)
		btn.MouseEnter:Connect(function() setHover(btn, true) end)
		btn.MouseLeave:Connect(function() setHover(btn, false) end)
		btn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch then setHover(btn, true) end end)
		btn.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch then setHover(btn, false) end end)
		btn.AncestryChanged:Connect(function(child, parent) if not parent then buttonState[btn] = nil end end)
	end

	-- apply to existing and future select buttons
	for _, obj in ipairs(ScrollingSelectTab:GetDescendants()) do
		if obj:IsA("ImageButton") or obj:IsA("TextButton") then
			setupSelectButton(obj)
		end
	end
	ScrollingSelectTab.DescendantAdded:Connect(function(obj)
		if obj:IsA("ImageButton") or obj:IsA("TextButton") then
			task.wait()
			setupSelectButton(obj)
		end
	end)

	-- global touch handlers for swipe hover
	UserInputService.TouchMoved:Connect(function(input, gameProcessed)
		local pos = input.Position
		for btn, _ in pairs(buttonState) do
			if btn and btn.Parent then
				local posAbs = btn.AbsolutePosition
				local size = btn.AbsoluteSize
				local inside = pos.X >= posAbs.X and pos.X <= posAbs.X + size.X and pos.Y >= posAbs.Y and pos.Y <= posAbs.Y + size.Y
				if inside then setHover(btn, true) else setHover(btn, false) end
			else
				buttonState[btn] = nil
			end
		end
	end)
	UserInputService.TouchEnded:Connect(function()
		for btn, _ in pairs(buttonState) do
			if btn and btn.Parent then setHover(btn, false) else buttonState[btn] = nil end
		end
	end)
end

-- ========================
-- TIP: Section D - EffectButton (UIStroke hover for main ToggleButton)
-- ========================
local StrokeEffect = {}
do
	StrokeEffect.TWEEN_TIME = 0.15
	StrokeEffect.SHOW = 0
	StrokeEffect.HIDE = 1

	-- get stroke (ensure exists)
	local function ensureStroke(obj)
		local s = obj:FindFirstChildOfClass("UIStroke") or obj:FindFirstChild("UIStroke")
		if not s then
			s = Instance.new("UIStroke")
			s.Parent = obj
		end
		return s
	end

	local stroke = ensureStroke(ToggleButton)
	stroke.Transparency = StrokeEffect.HIDE

	local currentStrokeTween = nil
	local function playStrokeTween(value)
		if currentStrokeTween then currentStrokeTween:Cancel() end
		currentStrokeTween = TweenService:Create(stroke, TweenInfo.new(StrokeEffect.TWEEN_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = value })
		currentStrokeTween:Play()
	end

	-- PC
	ToggleButton.MouseEnter:Connect(function() playStrokeTween(StrokeEffect.SHOW) end)
	ToggleButton.MouseLeave:Connect(function() playStrokeTween(StrokeEffect.HIDE) end)
	-- Mobile
	ToggleButton.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch then playStrokeTween(StrokeEffect.SHOW) end end)
	ToggleButton.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch then playStrokeTween(StrokeEffect.HIDE) end end)
end

-- ========================
-- TIP: Section E - ScrollingTabSystem (tab switching, strokes, bg color, TabName typing)
-- ========================
local TabSystem = {}
do
	-- CONFIG
	TabSystem.STROKE_TWEEN_TIME = 0.18
	TabSystem.BG_TWEEN_TIME = 0.25
	TabSystem.TEXT_ANIM_TOTAL = 0.5
	TabSystem.TEXT_ERASE_TIME = TabSystem.TEXT_ANIM_TOTAL * 0.5
	TabSystem.TEXT_TYPE_TIME = TabSystem.TEXT_ANIM_TOTAL * 0.5

	-- STATE
	local activeButton = nil
	local activeFrame = nil
	local strokeTweens = {}
	local currentTextAnimId = 0
	local btnDebounce = {}

	-- helpers
	local function ensureUIStroke(btn)
		local stroke = btn:FindFirstChildOfClass("UIStroke") or btn:FindFirstChild("UIStroke")
		if not stroke then
			stroke = Instance.new("UIStroke")
			stroke.Parent = btn
		end
		pcall(function() stroke.Transparency = 1 end)
		return stroke
	end

	local function tweenStrokeTo(btn, targetTransparency)
		local stroke = ensureUIStroke(btn)
		if strokeTweens[btn] then strokeTweens[btn]:Cancel(); strokeTweens[btn] = nil end
		local tw = TweenService:Create(stroke, TweenInfo.new(TabSystem.STROKE_TWEEN_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = targetTransparency })
		strokeTweens[btn] = tw
		tw:Play()
		tw.Completed:Connect(function() if strokeTweens[btn] == tw then strokeTweens[btn] = nil end end)
	end

	local function setFrameVisibleByName(name)
		for _, obj in ipairs(ScrollingTab:GetChildren()) do
			if obj:IsA("Frame") then
				local visible = (obj.Name == name)
				obj.Visible = visible
				if visible then activeFrame = obj end
			end
		end
	end

	local function tweenContentBgToColor(targetColor)
		if not ScrollingTab then return end
		local ok = pcall(function() assert(ScrollingTab.BackgroundColor3) end)
		if not ok then return end
		local tw = TweenService:Create(ScrollingTab, TweenInfo.new(TabSystem.BG_TWEEN_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = targetColor })
		tw:Play()
	end

	local function animateTabName(newText)
		if not TabNameLabel then return end
		currentTextAnimId = currentTextAnimId + 1
		local myId = currentTextAnimId

		-- erase phase
		local old = TabNameLabel.Text or ""
		local lenOld = #old
		if lenOld > 0 and TabSystem.TEXT_ERASE_TIME > 0 then
			local interval = TabSystem.TEXT_ERASE_TIME / lenOld
			for i = lenOld, 1, -1 do
				if myId ~= currentTextAnimId then return end
				TabNameLabel.Text = string.sub(old, 1, i - 1)
				task.wait(interval)
			end
		else
			TabNameLabel.Text = ""
		end

		-- type phase
		local lenNew = #newText
		if lenNew > 0 and TabSystem.TEXT_TYPE_TIME > 0 then
			local interval = TabSystem.TEXT_TYPE_TIME / lenNew
			for i = 1, lenNew do
				if myId ~= currentTextAnimId then return end
				TabNameLabel.Text = string.sub(newText, 1, i)
				task.wait(interval)
			end
		else
			TabNameLabel.Text = newText
		end
	end

	local function selectTabByButton(btn)
		if not btn or not btn.Name then return end
		local name = btn.Name
		if activeButton == btn then return end

		-- strokes: selected -> 0, others -> 1
		for _, child in ipairs(ScrollingSelectTab:GetDescendants()) do
			if child:IsA("ImageButton") or child:IsA("TextButton") then
				local st = ensureUIStroke(child)
				if child == btn then
					tweenStrokeTo(child, 0)
				else
					tweenStrokeTo(child, 1)
				end
			end
		end

		-- frames
		setFrameVisibleByName(name)

		-- content bg color
		local frameObj = ScrollingTab:FindFirstChild(name)
		if frameObj and frameObj:IsA("Frame") then
			local ok, col = pcall(function() return frameObj.BackgroundColor3 end)
			if ok and col then tweenContentBgToColor(col) end
		end

		-- animate TabName
		task.spawn(function() animateTabName(name) end)

		activeButton = btn
	end

	local function setupTabButton(btn)
		if not btn then return end
		if not (btn:IsA("ImageButton") or btn:IsA("TextButton")) then return end
		ensureUIStroke(btn)
		if btn:GetAttribute("TabSwitcherBound") then return end
		btn:SetAttribute("TabSwitcherBound", true)

		local function onActivated()
			if btnDebounce[btn] then return end
			btnDebounce[btn] = true
			selectTabByButton(btn)
			task.delay(0.15, function() btnDebounce[btn] = nil end)
		end

		btn.Activated:Connect(onActivated)
		if btn.MouseButton1Click then btn.MouseButton1Click:Connect(onActivated) end
	end

	-- initialize: strokes = 1, hide frames, bind buttons, default Status
	local function initialize()
		for _, child in ipairs(ScrollingSelectTab:GetDescendants()) do
			if child:IsA("ImageButton") or child:IsA("TextButton") then
				local st = ensureUIStroke(child)
				pcall(function() st.Transparency = 1 end)
			end
		end

		for _, f in ipairs(ScrollingTab:GetChildren()) do
			if f:IsA("Frame") then f.Visible = false end
		end

		for _, child in ipairs(ScrollingSelectTab:GetDescendants()) do
			if child:IsA("ImageButton") or child:IsA("TextButton") then setupTabButton(child) end
		end

		-- default "Status"
		local defaultBtn = ScrollingSelectTab:FindFirstChild("Status", true)
		if not defaultBtn then
			for _, child in ipairs(ScrollingSelectTab:GetDescendants()) do
				if child:IsA("ImageButton") or child:IsA("TextButton") then defaultBtn = child; break end
			end
		end

		if defaultBtn then
			activeButton = nil
			for _, child in ipairs(ScrollingSelectTab:GetDescendants()) do
				if child:IsA("ImageButton") or child:IsA("TextButton") then
					local st = ensureUIStroke(child)
					if child == defaultBtn then pcall(function() st.Transparency = 0 end) else pcall(function() st.Transparency = 1 end) end
				end
			end

			setFrameVisibleByName(defaultBtn.Name)
			local frameObj = ScrollingTab:FindFirstChild(defaultBtn.Name)
			if frameObj and frameObj:IsA("Frame") then pcall(function() ScrollingTab.BackgroundColor3 = frameObj.BackgroundColor3 end) end
			if TabNameLabel then TabNameLabel.Text = defaultBtn.Name end
			activeButton = defaultBtn
		end
	end

	-- dynamic binding for new buttons
	ScrollingSelectTab.DescendantAdded:Connect(function(obj)
		if obj:IsA("ImageButton") or obj:IsA("TextButton") then task.wait(); setupTabButton(obj) end
	end)

	-- run init
	initialize()
end

-- ========================
-- END of CombinedUIController
-- ========================
