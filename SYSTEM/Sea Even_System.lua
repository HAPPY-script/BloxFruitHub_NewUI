--=== AUTO BOAT DRIVE =============================================================================================--
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
    local Bar = SEA_FRAME:WaitForChild("ElevationFrame"):WaitForChild("Bar")
    local Fill = Bar:WaitForChild("Fill")
    local Knob = Bar:WaitForChild("Knob")
    local ElevationContainer = SEA_FRAME:WaitForChild("ElevationBox")
    local TOGGLE_BUTTON_NAME = "AutoBoatDriveButton"

    local IntensityBox = SEA_FRAME:WaitForChild("IntensityBox")
    local AutoBoatDriveModeTitle = SEA_FRAME:WaitForChild("AutoBoatDriveModeTitle")
    local AutoDriveBoatModeButton = SEA_FRAME:WaitForChild("AutoDriveBoatModeButton")
    -- ==================================================================

    -- ===== Utility =====
    local function clamp(v, a, b)
        if math.clamp then
            return math.clamp(v, a, b)
        end
        if v < a then return a end
        if v > b then return b end
        return v
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

    local function findTextObject(inst)
        if not inst then return nil end
        if inst:IsA("TextBox") or inst:IsA("TextLabel") or inst:IsA("TextButton") then
            return inst
        end
        return inst:FindFirstChildWhichIsA("TextBox", true)
            or inst:FindFirstChildWhichIsA("TextLabel", true)
            or inst:FindFirstChildWhichIsA("TextButton", true)
    end

    local function findStroke(inst)
        if not inst then return nil end
        for _, v in ipairs(inst:GetDescendants()) do
            if v:IsA("UIStroke") then
                return v
            end
        end
        return nil
    end

    -- ===== Slider range / defaults / colors =====
    local MIN_VAL = 30
    local MAX_VAL = 200 -- slider visual max only
    local DEFAULT_INIT = 200

    local COLOR_MIN = Color3.fromRGB(255, 0, 255)
    local COLOR_MAX = Color3.fromRGB(255, 0, 100)

    -- ===== Wind stream params (STREAM_Y driven by slider/text) =====
    local SPEED = 250
    local STREAM_Y = DEFAULT_INIT
    local STREAM_Z = 635
    local STREAM_ORIGIN_X = -17500
    local ARRIVE_EPS = 1

    _G.DriveMode = _G.DriveMode or "Straight" -- "Straight" / "Oscillate"

    local DRIVE_OSC_AMPLITUDE = 50 -- biên độ sóng
    local TAU = math.pi * 2

    local function getWaveLength()
        return clamp(DRIVE_OSC_AMPLITUDE * 3, 100, 1500)
    end

    local function getDriveMode()
        local mode = tostring(_G.DriveMode or "Straight")
        if mode ~= "Oscillate" and mode ~= "360" then
            return "Straight"
        end
        return mode
    end

    local function getModeDisplayName(mode)
        if mode == "360" then
            return "360°"
        end
        return mode
    end

    local function setIntensityText()
        if not IntensityTextObject then return end

        local mode = getDriveMode()
        local value
        if mode == "Oscillate" then
            value = DRIVE_OSC_AMPLITUDE
        elseif mode == "360" then
            value = DRIVE_360_SPEED
        end

        if value ~= nil then
            pcall(function()
                IntensityTextObject.Text = tostring(value)
            end)
        end
    end

    local applyDriveModeUI
    _G.SetDriveMode = function(mode)
        mode = tostring(mode or "Straight")
        if mode ~= "Oscillate" and mode ~= "360" then
            mode = "Straight"
        end
        if applyDriveModeUI then
            applyDriveModeUI(mode, true)
        else
            _G.DriveMode = mode
        end
    end

    _G.SetDriveAmplitude = function(v)
        v = tonumber(v) or DRIVE_OSC_AMPLITUDE
        DRIVE_OSC_AMPLITUDE = clamp(math.floor(v + 0.5), OSC_MIN, OSC_MAX)
    end

    _G.SetDrive360Speed = function(v)
        v = tonumber(v) or DRIVE_360_SPEED
        DRIVE_360_SPEED = clamp(math.floor(v + 0.5), SPIN_MIN, SPIN_MAX)
    end

    -- ===== Core state for movement =====
    local movementToken = 0
    local running = false
    local terminated = false

    -- ===== Slider core state =====
    local dragging = false
    local draggingInput = nil
    local valueAlpha = 0 -- 0..1
    local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local textboxEditing = false

    -- ===== Find the real text object for elevation =====
    local ElevationTextObject = nil
    do
        local container = ElevationContainer
        if container then
            if container:IsA("TextBox") or container:IsA("TextLabel") then
                ElevationTextObject = container
            else
                ElevationTextObject = container:FindFirstChildWhichIsA("TextBox", true)
                    or container:FindFirstChildWhichIsA("TextLabel", true)
                if not ElevationTextObject then
                    ElevationTextObject = container
                end
            end
        end
    end

    local function alphaToValue(a)
        a = clamp(a, 0, 1)
        return a * (MAX_VAL - MIN_VAL) + MIN_VAL
    end

    local function valueToAlpha(v)
        v = clamp(v, MIN_VAL, MAX_VAL)
        return (v - MIN_VAL) / (MAX_VAL - MIN_VAL)
    end

    local function onSliderValueChanged(num)
        num = tonumber(num) or DEFAULT_INIT
        num = math.floor(num + 0.5)
        STREAM_Y = num
    end

    local function setTextSafe(text)
        if not ElevationTextObject then return end
        if ElevationTextObject:IsA("TextBox") then
            if not textboxEditing then
                pcall(function()
                    ElevationTextObject.Text = tostring(text)
                end)
            end
        else
            pcall(function()
                ElevationTextObject.Text = tostring(text)
            end)
        end
    end

    -- Slider apply: size/knob/color/tween + call value changed
    local function apply(alpha, smooth, displayValue)
        alpha = clamp(alpha, 0, 1)
        valueAlpha = alpha

        local knobHalfX = (Knob.AbsoluteSize and Knob.AbsoluteSize.X) and (Knob.AbsoluteSize.X / 2) or 8
        local knobHalfY = (Knob.AbsoluteSize and Knob.AbsoluteSize.Y) and (Knob.AbsoluteSize.Y / 2) or 8

        local sizeGoal = { Size = UDim2.new(alpha, 0, 1, 0) }
        local posGoal = { Position = UDim2.new(alpha, -knobHalfX, 0.5, -knobHalfY) }

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

        local shown = displayValue
        if shown == nil then
            shown = math.floor(alphaToValue(alpha) + 0.5)
        end
        shown = math.floor(tonumber(shown) or DEFAULT_INIT)

        setTextSafe(shown)
        onSliderValueChanged(shown)
    end

    local function syncElevationValue(num, smooth)
        num = tonumber(num) or DEFAULT_INIT
        num = math.floor(num + 0.5)
        if num < MIN_VAL then
            num = MIN_VAL
        end
        local visual = clamp(num, MIN_VAL, MAX_VAL)
        apply(valueToAlpha(visual), smooth, num)
    end

    local function getAlphaFromScreenX(x)
        local bx = Bar.AbsolutePosition.X
        local bw = Bar.AbsoluteSize.X
        if not bw or bw == 0 then return 0 end
        return (x - bx) / bw
    end

    -- ===== Mode UI helpers =====
    local ModeButtonText = findTextObject(AutoDriveBoatModeButton)
    local ModeButtonStroke = findStroke(AutoDriveBoatModeButton)
    local IntensityTextObject = findTextObject(IntensityBox)

    local MODE_STRAIGHT_COLOR = Color3.fromRGB(0, 255, 200)
    local MODE_OSC_COLOR = Color3.fromRGB(200, 255, 0)
    local MODE_360_COLOR = Color3.fromRGB(100, 0, 255)

    local TITLE_STRAIGHT_SIZE = UDim2.new(0.7, 0, 0.03, 0)
    local TITLE_STRAIGHT_POS = UDim2.new(0.375, 0, 0.13, 0)
    local TITLE_OSC_SIZE = UDim2.new(0.465, 0, 0.03, 0)
    local TITLE_OSC_POS = UDim2.new(0.265, 0, 0.13, 0)

    local OSC_MIN, OSC_MAX = 50, 500
    local SPIN_MIN, SPIN_MAX = 5, 720

    local DRIVE_OSC_AMPLITUDE = OSC_MIN
    local DRIVE_360_SPEED = SPIN_MIN

    local function setIntensityText()
        if IntensityTextObject then
            pcall(function()
                IntensityTextObject.Text = tostring(DRIVE_OSC_AMPLITUDE)
            end)
        end
    end

    local modeTransitioning = false
    local function setModeText(text, tweenIn)
        if not ModeButtonText then return end
        pcall(function()
            ModeButtonText.Text = tostring(text)
        end)
        if tweenIn then
            pcall(function()
                TweenService:Create(ModeButtonText, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextTransparency = 0,
                    TextStrokeTransparency = 0,
                }):Play()
            end)
        else
            pcall(function()
                ModeButtonText.TextTransparency = 0
                ModeButtonText.TextStrokeTransparency = 0
            end)
        end
    end

    applyDriveModeUI = function(mode, animate)
        mode = tostring(mode or "Straight")
        if mode ~= "Oscillate" and mode ~= "360" then
            mode = "Straight"
        end

        _G.DriveMode = mode

        local isOsc = (mode == "Oscillate")
        local is360 = (mode == "360")
        local targetColor = isOsc and MODE_OSC_COLOR or (is360 and MODE_360_COLOR or MODE_STRAIGHT_COLOR)
        local targetText = getModeDisplayName(mode)

        local titleInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local colorInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local fadeInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        if AutoBoatDriveModeTitle then
            pcall(function()
                TweenService:Create(AutoBoatDriveModeTitle, titleInfo, {
                    Size = isOsc and TITLE_OSC_SIZE or TITLE_STRAIGHT_SIZE,
                    Position = isOsc and TITLE_OSC_POS or TITLE_STRAIGHT_POS,
                }):Play()
            end)
        end

        if IntensityBox then
            IntensityBox.Visible = (mode ~= "Straight")
        end

        if mode == "Oscillate" then
            DRIVE_OSC_AMPLITUDE = OSC_MIN
        elseif mode == "360" then
            DRIVE_360_SPEED = SPIN_MIN
        end

        if animate and ModeButtonText then
            modeTransitioning = true

            pcall(function()
                TweenService:Create(ModeButtonText, fadeInfo, {
                    TextTransparency = 1,
                    TextStrokeTransparency = 1,
                }):Play()
            end)

            pcall(function()
                TweenService:Create(AutoDriveBoatModeButton, colorInfo, {
                    BackgroundColor3 = targetColor,
                }):Play()
            end)

            if ModeButtonStroke then
                pcall(function()
                    TweenService:Create(ModeButtonStroke, colorInfo, {
                        Color = targetColor,
                    }):Play()
                end)
            end

            task.delay(0.25, function()
                if not ModeButtonText or not ModeButtonText.Parent then
                    modeTransitioning = false
                    return
                end
                setModeText(targetText, true)
                task.delay(0.25, function()
                    modeTransitioning = false
                end)
            end)
        else
            pcall(function()
                AutoDriveBoatModeButton.BackgroundColor3 = targetColor
            end)
            if ModeButtonStroke then
                pcall(function()
                    ModeButtonStroke.Color = targetColor
                end)
            end
            setModeText(targetText, false)
        end

        setIntensityText()
    end

    -- ===== Slider input wiring (desktop + mobile) =====
    Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            draggingInput = input
        end
    end)

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            draggingInput = input
            local x = (input.UserInputType == Enum.UserInputType.Touch) and input.Position.X or UIS:GetMouseLocation().X
            apply(getAlphaFromScreenX(x), true)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            draggingInput = nil
        elseif input.UserInputType == Enum.UserInputType.Touch then
            if draggingInput and input == draggingInput then
                dragging = false
                draggingInput = nil
            end
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not dragging then return end
        if draggingInput and input == draggingInput and input.UserInputType == Enum.UserInputType.Touch then
            apply(getAlphaFromScreenX(input.Position.X), true)
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging then
            if not draggingInput or draggingInput.UserInputType ~= Enum.UserInputType.Touch then
                apply(getAlphaFromScreenX(UIS:GetMouseLocation().X), true)
            end
        end
    end)

    -- ===== Elevation textbox handling =====
    if ElevationTextObject and ElevationTextObject:IsA("TextBox") then
        ElevationTextObject.Focused:Connect(function()
            textboxEditing = true
        end)

        ElevationTextObject.FocusLost:Connect(function()
            textboxEditing = false
            local raw
            pcall(function() raw = ElevationTextObject.Text end)
            local n = parseIntegerFromString(raw)
            if n then
                syncElevationValue(n, true)
            else
                pcall(function()
                    ElevationTextObject.Text = tostring(STREAM_Y)
                end)
            end
        end)
    end

    -- ===== IntensityBox handling =====
    if IntensityTextObject and IntensityTextObject:IsA("TextBox") then
        IntensityTextObject.FocusLost:Connect(function()
            local raw
            pcall(function() raw = IntensityTextObject.Text end)
            local n = parseIntegerFromString(raw)
            local mode = getDriveMode()

            if mode == "Oscillate" then
                if n then
                    DRIVE_OSC_AMPLITUDE = clamp(n, OSC_MIN, OSC_MAX)
                end
                setIntensityText()
            elseif mode == "360" then
                if n then
                    DRIVE_360_SPEED = clamp(n, SPIN_MIN, SPIN_MAX)
                end
                setIntensityText()
            end
        end)
    end

    -- ===== Slider initialization =====
    do
        local initNum = nil
        if ElevationTextObject then
            local ok, txt = pcall(function() return ElevationTextObject.Text end)
            if ok and txt and tostring(txt) ~= "" then
                local n = parseIntegerFromString(txt)
                if n then
                    initNum = n
                end
            end
        end
        if not initNum then
            initNum = DEFAULT_INIT
        end

        syncElevationValue(initNum, false)
        setTextSafe(initNum)
    end

    -- init mode UI now that everything exists
    applyDriveModeUI(_G.DriveMode, false)

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
                hrp.CFrame = CFrame.lookAt(start, start + dir, Vector3.new(0, 1, 0))
            end
            return true
        end

        local dir = delta.Unit
        local duration = dist / SPEED
        local elapsed = 0
        local done = false

        local conn
        conn = RunService.Heartbeat:Connect(function(dt)
            if myToken ~= movementToken then
                conn:Disconnect()
                return
            end
            elapsed = elapsed + dt
            local a = math.clamp(elapsed / duration, 0, 1)
            local pos = start + dir * dist * a
            hrp.CFrame = CFrame.lookAt(pos, pos + dir, Vector3.new(0, 1, 0))
            if a >= 1 then
                conn:Disconnect()
                done = true
            end
        end)

        while not done and myToken == movementToken do
            task.wait()
        end

        if myToken == movementToken then
            local finalPos = start + dir * dist
            hrp.CFrame = CFrame.lookAt(finalPos, finalPos + dir, Vector3.new(0, 1, 0))
        end

        return myToken == movementToken
    end

    local function nearestPoint(pos)
        local x = math.min(pos.X, STREAM_ORIGIN_X)
        return Vector3.new(x, STREAM_Y, STREAM_Z)
    end

    local runSystem -- forward declare

    local streamAnchorX = nil
    local streamTravel = 0
    local lastStreamMode = nil
    
    local spinAngle = 0
    local spinDir = 1
    local spinTimer = 0
    local spinDirTimer = 0
    
    local function flyAlongStream(myToken)
    	local hrp = getHRP()
    	local hum
    	pcall(function()
    		hum = getHumanoid()
    	end)
    
    	local conn
    	conn = RunService.Heartbeat:Connect(function(dt)
    		if myToken ~= movementToken or not running or terminated then
    			conn:Disconnect()
    			return
    		end
    
    		if not hrp or not hrp.Parent then
    			local ok, hrp2 = pcall(getHRP)
    			if ok then hrp = hrp2 end
    		end
    
    		if not hum or not hum.Parent then
    			local ok, h = pcall(getHumanoid)
    			if ok then hum = h end
    		end
    
    		if not (hum and hum.Sit) then
    			return
    		end
    
    		local mode = getDriveMode()
    
            if mode ~= lastStreamMode then
                lastStreamMode = mode
                streamAnchorX = hrp.Position.X
                streamTravel = 0
                spinAngle = math.random(0, 359)
                spinDir = (math.random(0, 1) == 0) and -1 or 1
                spinTimer = 0
                spinDirTimer = 0
            end
    
            if mode == "Oscillate" then
                local dtStep = SPEED * dt
                streamTravel = streamTravel + dtStep

                local x = streamAnchorX - streamTravel
                local z = STREAM_Z + math.sin((streamTravel / getWaveLength()) * TAU) * DRIVE_OSC_AMPLITUDE

                local nextTravel = streamTravel + dtStep
                local nextX = streamAnchorX - nextTravel
                local nextZ = STREAM_Z + math.sin((nextTravel / getWaveLength()) * TAU) * DRIVE_OSC_AMPLITUDE

                hrp.CFrame = CFrame.lookAt(
                    Vector3.new(x, STREAM_Y, z),
                    Vector3.new(nextX, STREAM_Y, nextZ),
                    Vector3.new(0, 1, 0)
                )

            elseif mode == "360" then
                local dtStep = SPEED * dt
                streamTravel = streamTravel + dtStep

                local x = streamAnchorX - streamTravel
                local pos = Vector3.new(x, STREAM_Y, STREAM_Z)
                local lookTarget = Vector3.new(x - 1, STREAM_Y, STREAM_Z)

                spinTimer = spinTimer + dt
                spinDirTimer = spinDirTimer + dt

                if spinDirTimer >= 1.5 then
                    spinDirTimer = 0
                    spinDir = (math.random(0, 1) == 0) and -1 or 1
                end

                spinAngle = (spinAngle + (DRIVE_360_SPEED * dt * spinDir)) % 360

                local baseCF = CFrame.lookAt(pos, lookTarget, Vector3.new(0, 1, 0))
                hrp.CFrame = baseCF * CFrame.Angles(0, 0, math.rad(spinAngle))

            else
                local newX = hrp.Position.X - SPEED * dt
                local pos = Vector3.new(newX, STREAM_Y, STREAM_Z)
                local lookTarget = pos + Vector3.new(-1, 0, 0)
                hrp.CFrame = CFrame.lookAt(pos, lookTarget, Vector3.new(0, 1, 0))
            end
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
                hrp.CFrame = CFrame.lookAt(approachPos, approachPos + lookDir, Vector3.new(0, 1, 0))
            end
        end

        while running and not terminated do
            hum = getHumanoid()
            if hum and hum.Sit then break end
            if not seat or not seat.Parent then break end
            pcall(function()
                local targetPos = seat.Position + Vector3.new(0, 2, 0)
                hrp.CFrame = CFrame.lookAt(targetPos, seat.Position, Vector3.new(0, 1, 0))
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
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function()
        if ToggleUI.Refresh then ToggleUI.Refresh() end
    end)

    -- find button inside Sea Even
    local toggleButton = SEA_FRAME:FindFirstChild(TOGGLE_BUTTON_NAME, true)
    if not toggleButton then
        warn("AutoBoatDriveButton not found in 'Sea Even' frame")
    else
        local function isButtonOn(btn)
            local ok, c = pcall(function() return btn.BackgroundColor3 end)
            if not ok or not c then return false end
            local r = math.floor(c.R * 255 + 0.5)
            local g = math.floor(c.G * 255 + 0.5)
            local b = math.floor(c.B * 255 + 0.5)
            return (r == 0 and g == 255 and b == 0)
        end

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

        -- ====== allowed PlaceID check & warning tween setup ======
        local ALLOWED_PLACE_IDS = {
            [7449423635] = true,
            [100117331123089] = true,
        }

        local function isPlaceAllowed()
            return ALLOWED_PLACE_IDS[tonumber(game.PlaceId)] == true
        end

        local stroke = findStroke(toggleButton)
        local origBg = toggleButton.BackgroundColor3 or Color3.fromRGB(255, 50, 50)
        local warnColor = Color3.fromRGB(255, 255, 0)
        local clickLock = false
        local animating = false

        local function tweenButtonToColor(targetColor, duration)
            duration = duration or 0.25
            local tweens = {}
            local info = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            table.insert(tweens, TweenService:Create(toggleButton, info, { BackgroundColor3 = targetColor }))
            if stroke then
                table.insert(tweens, TweenService:Create(stroke, info, { Color = targetColor }))
            end
            for _, tw in ipairs(tweens) do
                pcall(function() tw:Play() end)
            end
            task.wait(duration)
        end
        -- ====== END NEW ======

        if toggleButton.Activated then
            toggleButton.Activated:Connect(function()
                if clickLock or animating then return end
                clickLock = true
                task.delay(0.15, function() clickLock = false end)

                local requested = not isButtonOn(toggleButton)
                if requested and (not isPlaceAllowed()) then
                    if animating then return end
                    animating = true
                    task.spawn(function()
                        tweenButtonToColor(warnColor, 0.25)
                        task.wait(1)
                        tweenButtonToColor(origBg, 0.25)
                        animating = false
                    end)
                    return
                end

                pcall(function() ToggleUI.Set(TOGGLE_BUTTON_NAME, requested) end)
            end)
        else
            toggleButton.MouseButton1Click:Connect(function()
                if clickLock or animating then return end
                clickLock = true
                task.delay(0.15, function() clickLock = false end)

                local requested = not isButtonOn(toggleButton)
                if requested and (not isPlaceAllowed()) then
                    if animating then return end
                    animating = true
                    task.spawn(function()
                        tweenButtonToColor(warnColor, 0.25)
                        task.wait(1)
                        tweenButtonToColor(origBg, 0.25)
                        animating = false
                    end)
                    return
                end

                pcall(function() ToggleUI.Set(TOGGLE_BUTTON_NAME, requested) end)
            end)
        end

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

        if isButtonOn(toggleButton) then
            startRunning()
        else
            stopRunning()
        end
    end

    -- ===== Mode toggle button wiring =====
    local modeClickLock = false
    local function toggleDriveMode()
        if modeClickLock then return end
        if modeTransitioning then return end
        modeClickLock = true
        task.delay(0.15, function() modeClickLock = false end)

        local mode = getDriveMode()
        if mode == "Straight" then
            applyDriveModeUI("Oscillate", true)
        elseif mode == "Oscillate" then
            applyDriveModeUI("360", true)
        else
            applyDriveModeUI("Straight", true)
        end
    end

    if AutoDriveBoatModeButton.Activated then
        AutoDriveBoatModeButton.Activated:Connect(toggleDriveMode)
    else
        AutoDriveBoatModeButton.MouseButton1Click:Connect(toggleDriveMode)
    end

    -- expose stop function
    _G.WindStreamStop = function()
        running = false
        stopMovement()
    end

    -- expose a helper to set STREAM_Y programmatically (actual value, no upper limit)
    _G.SetWindStreamY = function(num)
        num = tonumber(num) or DEFAULT_INIT
        num = math.floor(num + 0.5)
        if num < MIN_VAL then
            num = MIN_VAL
        end
        syncElevationValue(num, true)
    end

    setIntensityText()
end

--[[ API wave mode
_G.DriveMode = "Straight"
-- hoặc
_G.DriveMode = "Oscillate"
]]
