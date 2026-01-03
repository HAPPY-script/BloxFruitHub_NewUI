local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local ToggleUI = {}

-- ===== CONFIG =====
local TWEEN_TIME = 0.24
local START_AT_DEG = 90 -- start fade of target/icon at 90 degrees
local START_DELAY = TWEEN_TIME * (START_AT_DEG / 360) -- time when 90deg reached

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

function ToggleUI.Refresh()
	scanUI()
end

-- expose to other LocalScripts via _G (client-only)
_G.ToggleUI = ToggleUI

return ToggleUI
