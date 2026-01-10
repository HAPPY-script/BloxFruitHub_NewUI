if _G.BloxFruit_Hub then
    warn("Script đã chạy! Không thể chạy lại.")
    return
end
_G.BloxFruit_Hub = true

--==================================================================================================================--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- debug switch (set true để xem log)
local DEBUG = false
local function dprint(...)
	if DEBUG then print("[LoadAnim]", ...) end
end

-- locate GUI pieces
local loadGui = playerGui:WaitForChild("LoadAnimationGui", 5)
if not loadGui then
	warn("LoadAnimationGui not found")
	return
end

local LoadWhiteFrame = loadGui:WaitForChild("LoadWhiteFrame", 5)
if not LoadWhiteFrame then
	warn("LoadWhiteFrame not found")
	return
end

-- LoadFrame is child inside LoadWhiteFrame (contains UIGradient)
local LoadFrame = LoadWhiteFrame:FindFirstChild("LoadFrame", true)
if not LoadFrame then
	warn("LoadFrame not found inside LoadWhiteFrame")
	return
end

-- UIGradient inside LoadFrame (we animate its Offset for percent)
local innerGradient = LoadFrame:FindFirstChildOfClass("UIGradient")
if not innerGradient then
	warn("UIGradient not found inside LoadFrame")
	-- continue, but percent gradient won't animate
end

-- star template in Effect folder
local effectFolder = loadGui:FindFirstChild("Effect")
if not effectFolder then
	warn("Effect folder not found in LoadAnimationGui")
	return
end

local StarTemplate = effectFolder:FindFirstChild("StarEffect")
if not StarTemplate or not StarTemplate:IsA("ImageLabel") then
	warn("StarEffect template missing or not ImageLabel")
	return
end

-- config (tweak durations / curvature here)
local GREEN = Color3.fromRGB(0,255,0)
local START_STAR_COLOR = Color3.fromRGB(208,38,255)
local STAR_ENTRY_POS    = UDim2.new(0.5,0,1.5,0) -- initial offscreen
local STAR_MID_POS      = UDim2.new(0.5,0,0.75,0) -- intermediate stop
local STAR_TARGET_POS   = UDim2.new(0.5,0,0.4,0) -- center target of LoadWhiteFrame
local LOADFRAME_ORIGIN  = UDim2.new(0.5,0,0.4,0) -- authoritative origin for shaking & restore

local entryToMidTime = 0.50   -- "not too fast" entry -> mid
local arcTime        = 0.70   -- arc duration (strong curve)
local starFadeTime   = 0.22
local shakeTime      = 0.08
local gradientTweenTime = 0.5
local sizeTweenTime  = 0.28

-- initialization: set LoadWhiteFrame size 0 and invisible, ensure background transparency 0
LoadWhiteFrame.Size = UDim2.new(0,0,0,0)
LoadWhiteFrame.Visible = false
LoadWhiteFrame.BackgroundTransparency = 0

-- ensure star template anchor/pos per instruction (template hidden)
StarTemplate.AnchorPoint = Vector2.new(0.5, 0.5)
StarTemplate.Position = UDim2.new(0.5, 0, 1000, 0) -- keep template offscreen

-- internal progress state
local currentPercent = 0 -- 0..1
local lock = false -- finish lock
local activeStars = 0 -- count of active star clones in-flight
local function clamp01(v) return math.clamp(v or 0, 0, 1) end

-- tween helper
local function tweenObject(obj, props, time, style, dir)
	local info = TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
	local t = TweenService:Create(obj, info, props)
	t:Play()
	return t
end

-- percent -> gradient mapping (0 -> 0.5 ; 1 -> -0.5)
local function percentToOffset(p)
	p = clamp01(p)
	return Vector2.new(0, 0.5 - p * 1.0)
end

local function tweenInnerGradientToPercent(p, ttime)
	if not innerGradient then return end
	local goal = percentToOffset(p)
	local info = TweenInfo.new(ttime or gradientTweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local t = TweenService:Create(innerGradient, info, {Offset = goal})
	t:Play()
	return t
end

-- create stronger arc control point (more negative y => stronger curve)
local function makeArcControlPoint(p0, p2)
	local midx = 0.35 + math.random() * 0.3 -- horizontal jitter
	-- place control well above endpoints for a pronounced curve (more negative)
	local top = math.min(p0.Y, p2.Y) - (0.7 + math.random() * 0.17)
	return Vector2.new(midx, top)
end

-- quadratic bezier driver using RunService.Heartbeat
local function driveArc(star, fromUDim2, toUDim2, duration, onComplete)
	local p0 = Vector2.new(fromUDim2.X.Scale, fromUDim2.Y.Scale)
	local p2 = Vector2.new(toUDim2.X.Scale, toUDim2.Y.Scale)
	local p1 = makeArcControlPoint(p0, p2)
	local startTime = tick()
	local conn
	conn = RunService.Heartbeat:Connect(function()
		local t = (tick() - startTime) / duration
		if t >= 1 then t = 1 end
		local omt = 1 - t
		local bx = omt*omt*p0.X + 2*omt*t*p1.X + t*t*p2.X
		local by = omt*omt*p0.Y + 2*omt*t*p1.Y + t*t*p2.Y
		star.Position = UDim2.new(bx, 0, by, 0)
		star.ImageColor3 = START_STAR_COLOR:Lerp(Color3.new(1,1,1), t)
		if t >= 1 then
			conn:Disconnect()
			star.Position = toUDim2
			if type(onComplete) == "function" then
				pcall(onComplete)
			end
		end
	end)
end

-- initial entry: entry -> mid -> strong arc -> delete + tween size
local function initialEntry()
	if LoadWhiteFrame.Visible then return end
	LoadWhiteFrame.Visible = true

	local star = StarTemplate:Clone()
	star.Parent = loadGui
	star.Visible = true
	star.AnchorPoint = Vector2.new(0.5, 0.5)
	star.Position = STAR_ENTRY_POS
	star.ImageColor3 = START_STAR_COLOR

	-- entry -> mid (not too fast)
	local t1 = tweenObject(star, {Position = STAR_MID_POS}, entryToMidTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	t1.Completed:Wait()

	-- arc mid -> target (strong curvature)
	activeStars = activeStars + 1
	driveArc(star, STAR_MID_POS, STAR_TARGET_POS, arcTime, function()
		-- arrived: delete star immediately
		pcall(function() star:Destroy() end)
		-- simultaneously tween LoadWhiteFrame size from zero -> 50x50
		pcall(function()
			tweenObject(LoadWhiteFrame, {Size = UDim2.new(0,50,0,50)}, sizeTweenTime)
		end)
		activeStars = math.max(0, activeStars - 1)
	end)

	-- ensure inner gradient starts at 0%
	if innerGradient then innerGradient.Offset = percentToOffset(0) end
end

-- small shake that restores exact origin
local function shakeLoadFrame()
	local origin = LOADFRAME_ORIGIN
	local ox = (math.random() - 0.5) * 0.02
	local oy = (math.random() - 0.5) * 0.02
	local shakePos = UDim2.new(origin.X.Scale + ox, 0, origin.Y.Scale + oy, 0)
	local t1 = tweenObject(LoadWhiteFrame, {Position = shakePos}, shakeTime)
	t1.Completed:Wait()
	tweenObject(LoadWhiteFrame, {Position = origin}, shakeTime).Completed:Wait()
	LoadWhiteFrame.Position = origin
end

-- spawn a star that does entry -> mid -> arc -> arrival callback -> destroy
local function spawnStarFly(onArrive)
	activeStars = activeStars + 1
	local star = StarTemplate:Clone()
	star.Parent = loadGui
	star.Visible = true
	star.AnchorPoint = Vector2.new(0.5, 0.5)
	star.Position = STAR_ENTRY_POS
	star.ImageColor3 = START_STAR_COLOR

	-- entry -> mid
	local tmid = tweenObject(star, {Position = STAR_MID_POS}, 0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	tmid.Completed:Wait()

	-- then strong arc into target
	driveArc(star, STAR_MID_POS, STAR_TARGET_POS, arcTime, function()
		-- on arrival: callback then destroy immediately
		pcall(function()
			if type(onArrive) == "function" then onArrive() end
		end)
		pcall(function() star:Destroy() end)
		activeStars = math.max(0, activeStars - 1)
	end)
end

local function runFinalSequence()
	-- 1. Đảm bảo không còn star bay
	while activeStars > 0 do
		task.wait()
	end

	-- 2. Đợi đúng 1s
	task.wait(1)
	
	-- 2.1 Bật visible Button trong BloxFruitHubGui
	local bf = playerGui:FindFirstChild("BloxFruitHubGui")
	if bf then
		local btn = bf:FindFirstChild("Button", true)
		if btn then
			btn.Visible = true
		end
	end

	-- 3. Set màu nền sang xanh
	LoadWhiteFrame.BackgroundColor3 = GREEN

	-- 4. Tắt LoadFrame (phần bên trong)
	LoadFrame.Visible = false

	-- 5. Tween transparency LoadWhiteFrame từ 0 -> 1
	LoadWhiteFrame.BackgroundTransparency = 0
	local tween = TweenService:Create(
		LoadWhiteFrame,
		TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{BackgroundTransparency = 1}
	)
	tween:Play()
	tween.Completed:Wait()

	-- 6. Xóa toàn bộ GUI
	loadGui:Destroy()
end

-- main API: shared.load(amount)
shared.load = shared.load or function(amount)
	if type(amount) ~= "number" then return end
	if lock then return end
	amount = clamp01(amount)
	if amount <= 0 then return end

	local alloc = math.min(amount, 1 - currentPercent)
	if alloc <= 0 then return end

	local count = math.random(3, 7)
	local perStar = alloc / count

	for i = 1, count do
		local delta = perStar
		if i == count then delta = alloc - perStar * (count - 1) end

		spawnStarFly(function()
			-- on arrival
			currentPercent = clamp01(currentPercent + delta)
			dprint("Star arrived; currentPercent=", currentPercent)

			-- shake + tween inner gradient (the one inside LoadFrame) to reflect new percent
			pcall(shakeLoadFrame)
			pcall(function() tweenInnerGradientToPercent(currentPercent, 0.25) end)

			-- finish sequence when reach 100%
			if currentPercent >= 1 and not lock then
				lock = true
				dprint("Reached 100%, locking and spawning final sequence")
				-- run final sequence (safely)
				task.spawn(runFinalSequence)
			end
		end)

		-- small stagger between star spawns
		task.wait(0.06 + math.random() * 0.05)
	end
end

-- entry flow
task.spawn(function()
	LoadWhiteFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	LoadWhiteFrame.Position = LOADFRAME_ORIGIN

	-- start invisible + size=0 already set above
	initialEntry()

	-- initialize inner gradient to 0% (if exists)
	if innerGradient then innerGradient.Offset = percentToOffset(0) end
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/MainUI.lua"))()

print("Main UI 1/10✅")
shared.load(0.025)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Status.lua"))()

print("Status 2/10✅")
shared.load(0.04)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Main.lua"))()

print("Main 3/10✅")
shared.load(0.06)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Raid.lua"))()

print("Raid 4/10✅")
shared.load(0.075)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Fruit.lua"))()

print("Fruit 5/10✅")
shared.load(0.085)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Visual.lua"))()

print("Visual 6/10✅")
shared.load(0.095)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Player%20Setting.lua"))()

print("Player Setting 7/10✅")
shared.load(0.125)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Combat.lua"))()

print("Combat 8/10✅")
shared.load(0.175)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Island.lua"))()

print("Island 9/10✅")
shared.load(0.25)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Order.lua"))()

print("Order 10/10✅")
shared.load(0.3)

print(">================================================================================================<")
--=== UI SYSTEM ============================================================================================================================--

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM_UI/SystemUI.lua"))()

print("UI System 1/2✅")
shared.load(0.35)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM_UI/ToggleUIEffect.lua"))()

print("Toggle UI Effect 2/2✅")
shared.load(0.4)

print(">================================================================================================<")
--=== TAB SYSTEM ============================================================================================================================--

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM/Status_System.lua"))()

print("Status tab System 1/7✅")
shared.load(0.475)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM/Main_System.lua"))()

print("Main tab System 2/7✅")
shared.load(0.65)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM/Raid_System.lua"))()

print("Raid tab System 3/7✅")
shared.load(0.725)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM/Combat_System.lua"))()

print("Combat tab System 4/7✅")
shared.load(0.8)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM/Player%20Setting_System.lua"))()

print("Player Setting tab System 5/7✅")
shared.load(0.85)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM/Island_System.lua"))()

print("Island tab System 6/7✅")
shared.load(0.875)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM/Fruit_System.lua"))()

print("Fruit tab System 7/7✅")
shared.load(0.95)

print("✅COMPLETE✅")

-- se
local BLOX_FRUITS_GAME_ID = 85211729168715
local BLOX_FRUITS_GAME_ID2 = 2753915549

local SECOND_SEA_GAME_ID = 79091703265657
local SECOND_SEA_GAME_ID2 = 4442272183

local THIRD_SEA_GAME_ID = 7449423635
local THIRD_SEA_GAME_ID2 = 100117331123089

local currentGameId = game.PlaceId
if currentGameId == BLOX_FRUITS_GAME_ID or currentGameId == BLOX_FRUITS_GAME_ID2 or currentGameId == SECOND_SEA_GAME_ID or currentGameId == SECOND_SEA_GAME_ID2 or currentGameId == THIRD_SEA_GAME_ID or currentGameId == THIRD_SEA_GAME_ID2 then

    local RunService = game:GetService("RunService")
    local player = game.Players.LocalPlayer

    local blockMain = Instance.new("Part")
    blockMain.Size = Vector3.new(500, 2.1, 500)
    blockMain.Anchored = true
    blockMain.Position = Vector3.new(0, 0, 0)
    blockMain.Transparency = 1
    blockMain.CanCollide = true
    blockMain.Parent = workspace

    local function updateBlockPosition(character)
        local hrp = character:WaitForChild("HumanoidRootPart")
        local humanoid = character:WaitForChild("Humanoid")

        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not character or not hrp then return end

            local playerPos = hrp.Position

            blockMain.Position = Vector3.new(playerPos.X, -5, playerPos.Z)
            local mainSurfaceY = blockMain.Position.Y + (blockMain.Size.Y / 2)

            if hrp.Position.Y < mainSurfaceY and hrp.Position.Y > blockMain.Position.Y - 250 then
                hrp.CFrame = CFrame.new(hrp.Position.X, mainSurfaceY + 5, hrp.Position.Z)
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)

        player.CharacterRemoving:Connect(function()
            if connection then connection:Disconnect() end
        end)
    end

    player.CharacterAdded:Connect(updateBlockPosition)
    if player.Character then
        updateBlockPosition(player.Character)
    end
    
    print("✅✅ Sea Protection Active (Single Layer) ✅✅")

else
    warn("⚠️ Script Sea Protection chỉ hoạt động trong game Blox Fruits.")
end

shared.load(1)
