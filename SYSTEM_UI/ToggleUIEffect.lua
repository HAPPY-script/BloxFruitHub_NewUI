local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local ToggleUI = {}

--// CONFIG =====================================================

local TWEEN_TIME = 0.24
local START_AT_DEG = 90
local START_DELAY = TWEEN_TIME * (START_AT_DEG / 360)

local DEFAULT_ON_LIST = {
	"AutoBusoButton",
}

local X_ON = 0.75
local X_OFF = 0.25

local COLOR_ON = Color3.fromRGB(0, 255, 0)
local COLOR_OFF = Color3.fromRGB(255, 0, 0)

local REPAIR_INTERVAL = 0.75
local STUCK_ICON_TIMEOUT = TWEEN_TIME * 2.5

--// UI ROOT ====================================================

local ScrollingTab = Players.LocalPlayer
	.PlayerGui
	:WaitForChild("BloxFruitHubGui")
	:WaitForChild("Main")
	:WaitForChild("ScrollingTab")

--// CACHE ======================================================

local buttonMap = {}

--// UTILS ======================================================

local function normalizeRotation(v)
	local n = tonumber(v) or 0
	n %= 360
	if n < 0 then
		n += 360
	end
	return n
end

local function safeFindIcon(dot, name)
	if not dot then
		return nil
	end

	local icon = dot:FindFirstChild(name)
	if icon and icon:IsA("ImageLabel") then
		return icon
	end

	return nil
end

local function tween(obj, props, info)
	if not obj then
		return nil
	end

	local ok, t = pcall(function()
		return TweenService:Create(
			obj,
			info or TweenInfo.new(
				TWEEN_TIME,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.Out
			),
			props
		)
	end)

	if not ok or not t then
		return nil
	end

	pcall(function()
		t:Play()
	end)

	return t
end

local function cancelTweens(data)
	if not data then
		return
	end

	data._token += 1

	if data._tweens then
		for _, t in ipairs(data._tweens) do
			if t then
				pcall(function()
					t:Cancel()
				end)
			end
		end
	end

	data._tweens = {}
	data._animating = false
end

local function getIcons(data)
	local onIcon = safeFindIcon(data.Dot, "OnIcon")
	local offIcon = safeFindIcon(data.Dot, "OffIcon")
	return onIcon, offIcon
end

local function setIconState(icon, visible)
	if not icon then
		return
	end

	pcall(function()
		icon.Rotation = 0
		icon.ImageTransparency = visible and 0 or 1
	end)
end

local function syncVisuals(data, isOn, force)
	if not data then
		return
	end

	local targetX = isOn and X_ON or X_OFF
	local color = isOn and COLOR_ON or COLOR_OFF
	local base = data.BasePos

	pcall(function()
		data.Dot.Position = UDim2.new(
			targetX,
			base.X.Offset,
			base.Y.Scale,
			base.Y.Offset
		)
	end)

	pcall(function()
		data.Button.BackgroundColor3 = color
	end)

	pcall(function()
		data.Stroke.Color = color
	end)

	local onIcon, offIcon = getIcons(data)
	setIconState(onIcon, isOn)
	setIconState(offIcon, not isOn)

	if force then
		data.State = isOn
	end
end

local function isIconMismatch(data)
	local onIcon, offIcon = getIcons(data)
	if not onIcon or not offIcon then
		return false
	end

	local okOnT, onT = pcall(function()
		return onIcon.ImageTransparency
	end)
	local okOffT, offT = pcall(function()
		return offIcon.ImageTransparency
	end)

	if not okOnT or not okOffT then
		return true
	end

	local expectedOn = data.State and 0 or 1
	local expectedOff = data.State and 1 or 0

	if math.abs((onT or 1) - expectedOn) > 0.03 then
		return true
	end

	if math.abs((offT or 1) - expectedOff) > 0.03 then
		return true
	end

	return false
end

local function repairData(data)
	if not data then
		return
	end

	local alive = true
	pcall(function()
		if not data.Button or not data.Button.Parent then
			alive = false
		end
	end)

	if not alive then
		return
	end

	local now = os.clock()
	local elapsed = now - (data._lastChange or 0)

	-- Nếu đang animating quá lâu, coi như bị kẹt và ép về state cuối cùng.
	if data._animating and elapsed > STUCK_ICON_TIMEOUT then
		cancelTweens(data)
		syncVisuals(data, data.State, true)
		return
	end

	-- Nếu không animating nhưng icon bị lệch, tự sửa lại.
	if (not data._animating) and isIconMismatch(data) then
		syncVisuals(data, data.State, true)
	end
end

--// HARD APPLY =================================================

local function applyInstant(data, isOn)
	cancelTweens(data)
	data._lastChange = os.clock()
	syncVisuals(data, isOn, true)
end

--// ANIMATION ==================================================

local function animateSwap(data, isOn)
	cancelTweens(data)

	data._animating = true
	data._lastChange = os.clock()

	local token = data._token
	local base = data.BasePos

	local targetX = isOn and X_ON or X_OFF
	local color = isOn and COLOR_ON or COLOR_OFF

	local onIcon, offIcon = getIcons(data)

	local dotTween = tween(data.Dot, {
		Position = UDim2.new(
			targetX,
			base.X.Offset,
			base.Y.Scale,
			base.Y.Offset
		)
	})

	local bgTween = tween(data.Button, {
		BackgroundColor3 = color
	})

	local strokeTween = tween(data.Stroke, {
		Color = color
	})

	if dotTween then table.insert(data._tweens, dotTween) end
	if bgTween then table.insert(data._tweens, bgTween) end
	if strokeTween then table.insert(data._tweens, strokeTween) end

	if isOn then
		if offIcon then
			local startRot = normalizeRotation(offIcon.Rotation)
			offIcon.Rotation = startRot

			local t = tween(
				offIcon,
				{
					Rotation = startRot + 360,
					ImageTransparency = 1
				},
				TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Linear)
			)

			if t then
				table.insert(data._tweens, t)
			end
		end

		if onIcon then
			local startRot = normalizeRotation(onIcon.Rotation)
			onIcon.Rotation = startRot

			task.delay(START_DELAY, function()
				if token ~= data._token then
					return
				end

				local t = tween(
					onIcon,
					{
						Rotation = startRot + 360,
						ImageTransparency = 0
					},
					TweenInfo.new(TWEEN_TIME - START_DELAY, Enum.EasingStyle.Linear)
				)

				if t then
					table.insert(data._tweens, t)
				end
			end)
		end
	else
		if onIcon then
			local startRot = normalizeRotation(onIcon.Rotation)
			onIcon.Rotation = startRot

			local t = tween(
				onIcon,
				{
					Rotation = startRot - 360,
					ImageTransparency = 1
				},
				TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Linear)
			)

			if t then
				table.insert(data._tweens, t)
			end
		end

		if offIcon then
			local startRot = normalizeRotation(offIcon.Rotation)
			offIcon.Rotation = startRot

			task.delay(START_DELAY, function()
				if token ~= data._token then
					return
				end

				local t = tween(
					offIcon,
					{
						Rotation = startRot - 360,
						ImageTransparency = 0
					},
					TweenInfo.new(TWEEN_TIME - START_DELAY, Enum.EasingStyle.Linear)
				)

				if t then
					table.insert(data._tweens, t)
				end
			end)
		end
	end

	task.delay(TWEEN_TIME + 0.05, function()
		if token ~= data._token then
			return
		end

		syncVisuals(data, isOn, true)
		data._animating = false
	end)

	-- Failsafe: nếu lag làm tween final không tới, watchdog sẽ sửa.
	data.State = isOn
end

--// SCAN =======================================================

local function scanUI()
	table.clear(buttonMap)

	for _, frame in ipairs(ScrollingTab:GetChildren()) do
		if frame:IsA("Frame") then
			for _, btn in ipairs(frame:GetChildren()) do
				if btn:IsA("TextButton") or btn:IsA("ImageButton") then
					local dot = btn:FindFirstChild("Dot")
					local stroke = btn:FindFirstChildOfClass("UIStroke")

					if dot and dot:IsA("Frame") and stroke then
						local data = {
							Button = btn,
							Dot = dot,
							Stroke = stroke,
							BasePos = dot.Position,
							State = false,
							_token = 0,
							_tweens = {},
							_animating = false,
							_lastChange = 0,
						}

						buttonMap[btn.Name] = data
						applyInstant(data, false)
					end
				end
			end
		end
	end
end

scanUI()

--// PUBLIC =====================================================

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

	if data.State == isOn and not data._animating then
		repairData(data)
		return
	end

	animateSwap(data, isOn)
end

function ToggleUI.SetDefault(buttonName, isOn)
	local data = buttonMap[buttonName]

	if not data then
		scanUI()
		data = buttonMap[buttonName]
		if not data then
			warn("[ToggleUI] Button not found:", buttonName)
			return
		end
	end

	applyInstant(data, isOn)
end

function ToggleUI.IsOn(buttonName)
	local data = buttonMap[buttonName]
	if not data then
		return false
	end
	return data.State == true
end

function ToggleUI.Refresh()
	scanUI()

	for name in pairs(buttonMap) do
		ToggleUI.SetDefault(name, false)
	end

	for _, name in ipairs(DEFAULT_ON_LIST) do
		if buttonMap[name] then
			ToggleUI.SetDefault(name, true)
		end
	end
end

task.spawn(function()
	while true do
		task.wait(REPAIR_INTERVAL)
		for _, data in pairs(buttonMap) do
			repairData(data)
		end
	end
end)

ToggleUI.Refresh()
_G.ToggleUI = ToggleUI

return ToggleUI

--[[ GUIDE ===========================================================================================--

local CLICK_LOCK = false
local ENABLED = false
local LAST_ENABLED = false

repeat task.wait() until _G.ToggleUI
local ToggleUI = _G.ToggleUI

pcall(function()
	if ToggleUI.Refresh then
		ToggleUI.Refresh()
	end
end)

--==============================================================
-- CONFIG
--==============================================================

local TOGGLE_BUTTON_NAME = "YourButtonName"
local ToggleButton = YourButtonReference

--==============================================================
-- ON ENABLE
--==============================================================

local function ON_ENABLE()

	print("SYSTEM ENABLE")

end

--==============================================================
-- ON DISABLE
--==============================================================

local function ON_DISABLE()

	print("SYSTEM DISABLE")

end

--==============================================================
-- SYNC STATE
--==============================================================

local function syncSystemState()

	ENABLED = ToggleUI.IsOn(TOGGLE_BUTTON_NAME)

	if LAST_ENABLED and not ENABLED then

		ON_DISABLE()

	elseif (not LAST_ENABLED) and ENABLED then

		ON_ENABLE()

	end

	LAST_ENABLED = ENABLED
end

--==============================================================
-- TOGGLE
--==============================================================

local function toggleSystem()

	if CLICK_LOCK then
		return
	end

	CLICK_LOCK = true

	task.delay(0.08,function()
		CLICK_LOCK = false
	end)

	local requested = not ToggleUI.IsOn(TOGGLE_BUTTON_NAME)

	pcall(function()
		ToggleUI.Set(
			TOGGLE_BUTTON_NAME,
			requested
		)
	end)

	task.delay(0.03,syncSystemState)
end

--==============================================================
-- CONNECT
--==============================================================

if ToggleButton.Activated then
	ToggleButton.Activated:Connect(toggleSystem)
else
	ToggleButton.MouseButton1Click:Connect(toggleSystem)
end

--==============================================================
-- AUTO SYNC
--==============================================================

ToggleButton:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()

	task.delay(0.03,syncSystemState)

end)

--==============================================================
-- FIRST LOAD
--==============================================================

syncSystemState()

]]
