local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local ToggleUI = {}

-- ===== CONFIG =====
local TWEEN_TIME = 0.24
local START_AT_DEG = 90 -- start fade of target/icon at 90 degrees
local START_DELAY = TWEEN_TIME * (START_AT_DEG / 360) -- time when 90deg reached

local DEFAULT_ON_LIST = {
	"AutoBusoButton",
}

local X_ON  = 0.75
local X_OFF = 0.25

local COLOR_ON  = Color3.fromRGB(0, 255, 0)
local COLOR_OFF = Color3.fromRGB(255, 0, 0)

-- ===== GET UI ROOT =====
local ScrollingTab = Players.LocalPlayer
	.PlayerGui
	:WaitForChild("BloxFruitHubGui")
	:WaitForChild("Main")
	:WaitForChild("ScrollingTab")

-- ===== Cache buttons =====
-- [ButtonName] = {
--   Button,
--   Dot,
--   Stroke,
--   BasePos (UDim2),
--   State (bool),
--   _iconTweens = { Tween, ... },
--   _swapId = number,
--   _animating = bool
-- }
local buttonMap = {}

local function safeFindIcon(dot, name)
	if not dot then return nil end
	local i = dot:FindFirstChild(name)
	if i and i:IsA("ImageLabel") then return i end
	return nil
end

local function normalizeRotation(v)
	-- return value in range [0, 360)
	local n = tonumber(v) or 0
	n = n % 360
	if n < 0 then n = n + 360 end
	return n
end

local function cancelIconTweens(data)
	if not data then return end
	-- bump swapId to invalidate delayed tasks
	data._swapId = (data._swapId or 0) + 1

	-- cancel active tweens
	if data._iconTweens then
		for _, t in ipairs(data._iconTweens) do
			if t and type(t.Cancel) == "function" then
				pcall(function() t:Cancel() end)
			end
		end
		data._iconTweens = nil
	end
	data._animating = false

	-- Normalize rotations and transparencies to a consistent final state
	local onIcon = safeFindIcon(data.Dot, "OnIcon")
	local offIcon = safeFindIcon(data.Dot, "OffIcon")

	-- normalize rotation to nearest upright orientation (0)
	if onIcon then
		onIcon.Rotation = normalizeRotation(onIcon.Rotation)
		-- set to 0 to avoid any tilt left from partial rotation
		onIcon.Rotation = 0
	end
	if offIcon then
		offIcon.Rotation = normalizeRotation(offIcon.Rotation)
		offIcon.Rotation = 0
	end

	-- set transparencies according to current saved State (if true => ON)
	if data.State then
		if onIcon then onIcon.ImageTransparency = 0 end
		if offIcon then offIcon.ImageTransparency = 1 end
	else
		if onIcon then onIcon.ImageTransparency = 1 end
		if offIcon then offIcon.ImageTransparency = 0 end
	end
end

local function scanUI()
	buttonMap = {}

	for _, frame in ipairs(ScrollingTab:GetChildren()) do
		if frame:IsA("Frame") then
			for _, btn in ipairs(frame:GetChildren()) do
				if btn:IsA("TextButton") or btn:IsA("ImageButton") then
					local dot = btn:FindFirstChild("Dot")
					local stroke = btn:FindFirstChildOfClass("UIStroke")

					if dot and dot:IsA("Frame") and stroke then
						buttonMap[btn.Name] = {
							Button = btn,
							Dot = dot,
							Stroke = stroke,
							BasePos = dot.Position,
							State = false,
							_iconTweens = nil,
							_swapId = 0,
							_animating = false
						}

						-- init icons if exist
						local data = buttonMap[btn.Name]
						local onIcon = safeFindIcon(dot, "OnIcon")
						local offIcon = safeFindIcon(dot, "OffIcon")
						if onIcon and offIcon then
							offIcon.ImageTransparency = 0
							onIcon.ImageTransparency = 1
							onIcon.Rotation = normalizeRotation(onIcon.Rotation)
							offIcon.Rotation = normalizeRotation(offIcon.Rotation)
						end
					end
				end
			end
		end
	end
end

scanUI()

-- ===== Tween helper =====
local function tween(obj, props, info)
	local ti = info or TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local ok, t = pcall(function() return TweenService:Create(obj, ti, props) end)
	if not ok or not t then return nil end
	pcall(function() t:Play() end)
	return t
end

-- animate icons swap with spam-safety
-- clockwise: true => +360, false => -360
local function animateIconSwap(data, fromIcon, toIcon, clockwise)
	if not data then return end
	-- cancel existing tweens and bump swap token
	cancelIconTweens(data)
	data._iconTweens = {}
	data._animating = true
	local myId = (data._swapId or 0) + 1
	data._swapId = myId

	local ROT = clockwise and 360 or -360

	-- ensure starting transparencies (from visible, to hidden)
	if fromIcon then
		fromIcon.ImageTransparency = fromIcon.ImageTransparency or 0
	end
	if toIcon then
		toIcon.ImageTransparency = toIcon.ImageTransparency or 1
	end

	-- normalize starting rotations to [0,360) then use as base
	local baseFrom = fromIcon and normalizeRotation(fromIcon.Rotation) or 0
	local baseTo = toIcon and normalizeRotation(toIcon.Rotation) or 0

	-- set normalized values explicitly to avoid drift
	if fromIcon then fromIcon.Rotation = baseFrom end
	if toIcon then toIcon.Rotation = baseTo end

	-- create rotation tweens (linear)
	local rotTweens = {}
	if fromIcon then
		local t = tween(fromIcon, { Rotation = baseFrom + ROT }, TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Linear))
		if t then table.insert(data._iconTweens, t); table.insert(rotTweens, t) end
	end
	if toIcon then
		local t = tween(toIcon, { Rotation = baseTo + ROT }, TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Linear))
		if t then table.insert(data._iconTweens, t); table.insert(rotTweens, t) end
	end

	-- fade OUT fromIcon over START_DELAY (0 -> START_DELAY)
	if fromIcon then
		local t = tween(fromIcon, { ImageTransparency = 1 }, TweenInfo.new(START_DELAY, Enum.EasingStyle.Linear))
		if t then table.insert(data._iconTweens, t) end
	end

	-- schedule fade IN toIcon starting at START_DELAY until end
	local capturedId = myId
	task.delay(START_DELAY, function()
		-- if invalidated by a newer swap, do nothing
		if data._swapId ~= capturedId then return end
		if toIcon then
			local t = tween(toIcon, { ImageTransparency = 0 }, TweenInfo.new(TWEEN_TIME - START_DELAY, Enum.EasingStyle.Linear))
			if t then
				if not data._iconTweens then data._iconTweens = {} end
				table.insert(data._iconTweens, t)
			end
		end
	end)

	-- Wait for rotation tweens to finish
	local need = #rotTweens
	if need == 0 then
		data._animating = false
		data._iconTweens = nil
		return
	end

	local done = 0
	for _, rt in ipairs(rotTweens) do
		rt.Completed:Once(function()
			done = done + 1
			if done >= need then
				-- ensure still the same swap
				if data._swapId ~= myId then
					data._animating = false
					data._iconTweens = nil
					return
				end

				-- finalize visuals deterministically:
				-- set final transparencies and force upright rotation = 0
				if fromIcon then fromIcon.ImageTransparency = 1 end
				if toIcon then toIcon.ImageTransparency = 0 end

				if fromIcon then fromIcon.Rotation = 0 end
				if toIcon then toIcon.Rotation = 0 end

				data._animating = false
				data._iconTweens = nil
			end
		end)
	end
end

-- ===== PUBLIC API =====
function ToggleUI.Set(buttonName, isOn)
	local data = buttonMap[buttonName]
	if not data then
		scanUI()
		data = buttonMap[buttonName]
		if not data then
			warn("[ToggleUI] Button not found:", buttonName)
			return
		end
	end

	-- compute
	local base = data.BasePos
	local targetX = isOn and X_ON or X_OFF
	local color = isOn and COLOR_ON or COLOR_OFF

	-- cancel any pending icon tweens (so we start clean)
	cancelIconTweens(data)

	-- Dot movement (only X scale change)
	tween(data.Dot, {
		Position = UDim2.new(
			targetX,
			base.X.Offset,
			base.Y.Scale,
			base.Y.Offset
		)
	})

	-- Button color + stroke
	tween(data.Button, { BackgroundColor3 = color })
	tween(data.Stroke, { Color = color })

	-- Icons swap logic
	local onIcon = safeFindIcon(data.Dot, "OnIcon")
	local offIcon = safeFindIcon(data.Dot, "OffIcon")
	local currentState = data.State or false

	if isOn ~= currentState then
		if isOn then
			-- OFF -> ON : clockwise
			if offIcon and onIcon then
				animateIconSwap(data, offIcon, onIcon, true)
			end
		else
			-- ON -> OFF : counter-clockwise
			if onIcon and offIcon then
				animateIconSwap(data, onIcon, offIcon, false)
			end
		end
	end

	-- update desired state immediately (keeps logic consistent for next calls)
	data.State = isOn
end

-- ===== NEW: SetDefault (robust, retry until fully applied) =====
function ToggleUI.SetDefault(buttonName, isOn)
	local data = buttonMap[buttonName]
	if not data then
		scanUI()
		data = buttonMap[buttonName]
		if not data then
			warn("[ToggleUI] Button not found (SetDefault):", buttonName)
			return
		end
	end

	-- cancel/normalize any running animations first
	cancelIconTweens(data)

	-- compute targets
	local base = data.BasePos
	local targetX = isOn and X_ON or X_OFF
	local color = isOn and COLOR_ON or COLOR_OFF

	-- bump token so any prior SetDefault loop is invalidated
	data._setDefaultId = (data._setDefaultId or 0) + 1
	local myId = data._setDefaultId

	-- helper equality checks
	local function near(a,b,eps)
		eps = eps or 0.005
		return math.abs(a - b) <= eps
	end
	local function colorNear(a,b)
		local eps = 6/255 -- allow small color diff
		return near(a.R, b.R, eps) and near(a.G, b.G, eps) and near(a.B, b.B, eps)
	end

	-- run async retry loop (non-blocking)
	task.spawn(function()
		-- quick initial apply to reduce visible flicker
		pcall(function()
			data.Dot.Position = UDim2.new(targetX, base.X.Offset, base.Y.Scale, base.Y.Offset)
			data.Button.BackgroundColor3 = color
			data.Stroke.Color = color
		end)

		-- icons references (may be nil)
		local onIcon = safeFindIcon(data.Dot, "OnIcon")
		local offIcon = safeFindIcon(data.Dot, "OffIcon")

		-- We'll loop until all checks pass or a new SetDefault invalidates us
		while data._setDefaultId == myId do
			-- Re-apply deterministic values (instant)
			pcall(function()
				data.Dot.Position = UDim2.new(targetX, base.X.Offset, base.Y.Scale, base.Y.Offset)
				data.Button.BackgroundColor3 = color
				data.Stroke.Color = color
			end)

			-- set icons deterministically
			if onIcon then
				pcall(function()
					onIcon.Rotation = 0
					onIcon.ImageTransparency = isOn and 0 or 1
				end)
			end
			if offIcon then
				pcall(function()
					offIcon.Rotation = 0
					offIcon.ImageTransparency = isOn and 1 or 0
				end)
			end

			-- verification: all pieces must match expected
			local ok = true

			-- verify dot X scale
			local okPos, curPos = pcall(function() return data.Dot.Position end)
			if not okPos or not curPos or not near(curPos.X.Scale, targetX, 0.006) then
				ok = false
			end

			-- verify button color & stroke color
			local okBtnCol, curBtnCol = pcall(function() return data.Button.BackgroundColor3 end)
			if not okBtnCol or not colorNear(curBtnCol, color) then ok = false end
			local okStrokeCol, curStrokeCol = pcall(function() return data.Stroke.Color end)
			if not okStrokeCol or not colorNear(curStrokeCol, color) then ok = false end

			-- verify icons
			if onIcon then
				local okOn, rotOn = pcall(function() return onIcon.Rotation end)
				local okOnT, transOn = pcall(function() return onIcon.ImageTransparency end)
				if (not okOn) or (not okOnT) or (not near((rotOn or 0) % 360, 0, 0.5)) or (not near(transOn or 1, (isOn and 0 or 1), 0.03)) then
					ok = false
				end
			end
			if offIcon then
				local okOff, rotOff = pcall(function() return offIcon.Rotation end)
				local okOffT, transOff = pcall(function() return offIcon.ImageTransparency end)
				if (not okOff) or (not okOffT) or (not near((rotOff or 0) % 360, 0, 0.5)) or (not near(transOff or 1, (isOn and 1 or 0), 0.03)) then
					ok = false
				end
			end

			-- if everything matches -> success; normalize then exit
			if ok then
				data.State = isOn
				cancelIconTweens(data)
				return
			end

			-- else: brief wait and retry (allows other tweens to finish or properties to settle)
			task.wait(0.06)
		end
		-- if invalidated by another call, simply exit
	end)
end

function ToggleUI.Refresh()
	scanUI()

	-- Đặt tất cả OFF trước (mặc định chung)
	for name, _ in pairs(buttonMap) do
		-- gọi SetDefault để đảm bảo mọi thuộc tính được áp dụng "cứng"
		ToggleUI.SetDefault(name, false)
	end

	-- Sau đó bật các button nằm trong danh sách DEFAULT_ON_LIST
	for _, name in ipairs(DEFAULT_ON_LIST) do
		if buttonMap[name] then
			ToggleUI.SetDefault(name, true)
		end
	end
end

ToggleUI.Refresh()

-- expose to other LocalScripts via _G (client-only)
_G.ToggleUI = ToggleUI

return ToggleUI

--[[HOOK
_G.ToggleUI.Set("ButtonName", true)   -- tween + animation
_G.ToggleUI.Set("ButtonName", false)  -- tween + animation

_G.ToggleUI.SetDefault("ButtonName", true)   -- bật ngay lập tức
_G.ToggleUI.SetDefault("ButtonName", false)  -- tắt ngay lập tức
]]
