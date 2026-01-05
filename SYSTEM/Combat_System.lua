--=== FOLLOW PLAYER =========================================================================================--

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")

    local player = Players.LocalPlayer

    -- chờ ToggleUI helper
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)

    -- ScrollingTab -> Combat
    local ScrollingTab = player.PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    local combatFrame = ScrollingTab:FindFirstChild("Combat", true) or ScrollingTab:FindFirstChild("Combat")
    if not combatFrame then
        warn("Không tìm thấy Frame 'Combat' trong ScrollingTab")
        return
    end

    local followBtn = combatFrame:FindFirstChild("FollowPlayerButton", true)
    local nameBox   = combatFrame:FindFirstChild("FollowPlayerBox", true)

    if not followBtn then warn("Không tìm thấy FollowPlayerButton trong Combat") return end
    if not nameBox then   warn("Không tìm thấy FollowPlayerBox trong Combat")   return end

    -- helper tìm UIStroke (first)
    local function findStroke(inst)
        for _, c in ipairs(inst:GetDescendants()) do
            if c:IsA("UIStroke") then return c end
        end
        return nil
    end
    local followStroke = findStroke(followBtn)

    -- tween helper
    local function tween(obj, props, t)
        local info = TweenInfo.new(t or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tw = TweenService:Create(obj, info, props)
        tw:Play()
        return tw
    end

    -- warn animation (yellow -> back red). Không thay text.
    local warnLock = false
    local WARN_COLOR = Color3.fromRGB(255,255,0)
    local RED_COLOR  = Color3.fromRGB(255,0,0)
    local function playWarn()
        if warnLock then return end
        warnLock = true
        pcall(function()
            tween(followBtn, { BackgroundColor3 = WARN_COLOR }, 0.18)
            if followStroke then tween(followStroke, { Color = WARN_COLOR }, 0.18) end
        end)
        task.delay(1, function()
            pcall(function()
                tween(followBtn, { BackgroundColor3 = RED_COLOR }, 0.18)
                if followStroke then tween(followStroke, { Color = RED_COLOR }, 0.18) end
            end)
            warnLock = false
        end)
    end

    -- infer toggle on (prefer ToggleUI.Get when available)
    local function getToggleOnByName(name, btn)
        local ok, val = pcall(function() if ToggleUI.Get then return ToggleUI.Get(name) end end)
        if ok and type(val) == "boolean" then return val end
        local bg
        pcall(function() bg = btn.BackgroundColor3 end)
        if bg and bg.G and bg.G > bg.R and bg.G > bg.B and bg.G > 0.5 then return true end
        return false
    end

    -- internal state
    local followEnabled = false
    local targetPlayer = nil
    local followLoopActive = false
    local disabledDueLowHP = false

    -- helpers to access player's parts safe
    local function safeHRP(pl)
        if not pl then return nil end
        local c = pl.Character
        if not c then return nil end
        return c:FindFirstChild("HumanoidRootPart")
    end
    local function safeHumanoid(pl)
        if not pl then return nil end
        local c = pl.Character
        if not c then return nil end
        return c:FindFirstChildOfClass("Humanoid")
    end

    -- pick target by partial name (case-insensitive), return player object or nil
    local function pickTargetFromName(txt)
        if not txt or txt == "" then return nil end
        local k = tostring(txt):lower()
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= player and pl.Name:lower():find(k,1,true) then
                return pl
            end
        end
        return nil
    end

    -- follow behaviour (mang nguyên logic cũ, nhưng đảm bảo an toàn respawn)
    local function followLoop()
        if followLoopActive then return end
        followLoopActive = true

        -- platform stand / autorotate nếu cần
        local function enablePlatformStand()
            local hum = safeHumanoid(player)
            if hum then
                pcall(function()
                    hum.PlatformStand = true
                    hum.AutoRotate = false
                end)
            end
        end
        local function disablePlatformStand()
            local hum = safeHumanoid(player)
            if hum then
                pcall(function()
                    hum.PlatformStand = false
                    hum.AutoRotate = true
                end)
            end
        end

        enablePlatformStand()

        while true do
            if not followEnabled then break end
            if not targetPlayer then
                -- target lost, request toggle off
                pcall(function() ToggleUI.Set("FollowPlayerButton", false) end)
                break
            end

            local hrp = safeHRP(player)
            local thrp = safeHRP(targetPlayer)
            local thum = safeHumanoid(targetPlayer)
            local myHum = safeHumanoid(player)

            if not hrp or not thrp or not thum then
                -- if target died / lost, stop follow and request toggle off
                pcall(function() ToggleUI.Set("FollowPlayerButton", false) end)
                break
            end

            -- HP safeguard: if local low HP then drop out (and request UI off)
            if myHum and myHum.Health and myHum.MaxHealth and myHum.Health / myHum.MaxHealth * 100 < 20 then
                -- immediate emergency teleport up (preserve original behaviour)
                if hrp then
                    pcall(function()
                        hrp.CFrame = hrp.CFrame + Vector3.new(0, 5000, 0)
                    end)
                end
                disabledDueLowHP = true
                pcall(function() ToggleUI.Set("FollowPlayerButton", false) end)
                break
            end

            -- simple follow: lerp towards target; keep a safe offset above
            local targetPos = thrp.Position + Vector3.new(0, 6, 0)
            local dist = (hrp.Position - targetPos).Magnitude

            -- choose simple behaviour: if far -> CFrame:Lerp towards target with some smoothing
            if dist > 100 then
                -- fast fly: set CFrame closer
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(targetPos), 0.5)
            else
                -- tight follow
                hrp.CFrame = CFrame.new(targetPos)
            end

            RunService.Heartbeat:Wait()
        end

        disablePlatformStand()
        followLoopActive = false
    end

    -- sync local followEnabled when toggle button color changes (ToggleUI will update visuals)
    local function syncFollowFromButton()
        local on = getToggleOnByName("FollowPlayerButton", followBtn)
        if followEnabled == on then return end
        followEnabled = on

        if not followEnabled then
            -- stop following, clear target
            targetPlayer = nil
            -- disabledDueLowHP remains as-is
        else
            -- when turned ON externally (ToggleUI), try to resolve nameBox -> set target and start loop
            local t = pickTargetFromName(nameBox.Text)
            if not t then
                -- requested ON but no valid target -> refuse / restore UI OFF with warn
                -- play warn then force ToggleUI.Set(false)
                playWarn()
                task.delay(1.1, function()
                    pcall(function() ToggleUI.Set("FollowPlayerButton", false) end)
                end)
                return
            else
                targetPlayer = t
                -- start follow loop
                task.spawn(function()
                    -- small defer to ensure followEnabled is true
                    task.wait(0.05)
                    if followEnabled then
                        followLoop()
                    end
                end)
            end
        end
    end

    followBtn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        task.delay(0.05, syncFollowFromButton)
    end)

    -- user clicked follow button -> request ToggleUI change (but validate before request)
    local function onFollowActivated()
        local cur = getToggleOnByName("FollowPlayerButton", followBtn)
        local wantOn = not cur
        if wantOn then
            -- validate nameBox
            local nameTxt = tostring(nameBox.Text or "")
            if nameTxt == "" or #nameTxt < 1 then
                playWarn()
                return
            end
            local t = pickTargetFromName(nameTxt)
            if not t then
                playWarn()
                return
            end
            -- request UI on; follow will start when ToggleUI updates and syncFollowFromButton runs
            pcall(function() ToggleUI.Set("FollowPlayerButton", true) end)
        else
            -- request off
            pcall(function() ToggleUI.Set("FollowPlayerButton", false) end)
        end
    end

    if followBtn.Activated then
        followBtn.Activated:Connect(onFollowActivated)
    else
        followBtn.MouseButton1Click:Connect(onFollowActivated)
    end

    -- when nameBox text changes while following -> switch target (or turn off if not found)
    nameBox:GetPropertyChangedSignal("Text"):Connect(function()
        -- allow instant changes even if followEnabled false (only act when following)
        if not followEnabled then return end

        local newName = tostring(nameBox.Text or "")
        if newName == "" then
            -- no name -> turn off
            pcall(function() ToggleUI.Set("FollowPlayerButton", false) end)
            return
        end

        local t = pickTargetFromName(newName)
        if t then
            targetPlayer = t
            -- if follow loop not active, try start
            if not followLoopActive and followEnabled then
                task.spawn(function()
                    task.wait(0.05)
                    if followEnabled then followLoop() end
                end)
            end
        else
            -- target not found -> disable follow
            pcall(function() ToggleUI.Set("FollowPlayerButton", false) end)
        end
    end)

    -- ensure ToggleUI initial state OFF
    pcall(function() ToggleUI.Set("FollowPlayerButton", false) end)
    -- initial sync
    task.delay(0.05, syncFollowFromButton)

    -- when target player dies or leaves, ensure follow is turned off
    Players.PlayerRemoving:Connect(function(p)
        if p == targetPlayer then
            pcall(function() ToggleUI.Set("FollowPlayerButton", false) end)
        end
    end)
    Players.PlayerAdded:Connect(function(_) end) -- placeholder

    -- when target's humanoid dies we also stop (connect when we set target)
    -- to keep things simple: monitor periodically and auto-off if target invalid
    task.spawn(function()
        while true do
            task.wait(0.5)
            if followEnabled and targetPlayer then
                local thr = safeTargetHRP and safeTargetHRP() or nil
                local thum = safeHumanoid(targetPlayer)
                if (not targetPlayer.Character) or (thum and thum.Health and thum.Health <= 0) then
                    pcall(function() ToggleUI.Set("FollowPlayerButton", false) end)
                end
            end
        end
    end)
end

--=== AIMBOT KEY PLAYER =========================================================================================--

do
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")

    local player = Players.LocalPlayer

    -- chờ ToggleUI helper theo chuẩn của hệ thống mới
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)

    -- đường dẫn cố định tới ScrollingTab -> Combat
    local ScrollingTab = player.PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    local combatFrame = ScrollingTab:FindFirstChild("Combat", true) or ScrollingTab:FindFirstChild("Combat")
    if not combatFrame then
        warn("Không tìm thấy Frame 'Combat' trong ScrollingTab")
        return
    end

    local aimbotBtn = combatFrame:FindFirstChild("AimbotButton", true)
    local keyBtn    = combatFrame:FindFirstChild("KeyAimbotButton", true)

    if not aimbotBtn then warn("Không tìm thấy AimbotButton trong Combat") return end
    if not keyBtn then warn("Không tìm thấy KeyAimbotButton trong Combat") return end

    local TweenTimeColor = 0.25
    local TweenTimeText  = 0.16
    local WaitTimeout    = 5

    local WARN_COLOR_FULL = Color3.fromRGB(255,255,0) -- khi bật mà chưa chọn key
    local WAIT_COLOR      = Color3.fromRGB(255,200,0) -- khi đang chờ chọn key
    local OK_COLOR        = Color3.fromRGB(0,255,0)   -- khi key đã chọn
    local RED_COLOR       = Color3.fromRGB(255,0,0)   -- mặc định none

    -- helper: tìm UIStroke đầu tiên trong descendants
    local function findStroke(inst)
        for _, v in ipairs(inst:GetDescendants()) do
            if v:IsA("UIStroke") then return v end
        end
        return nil
    end

    local aimbotStroke = findStroke(aimbotBtn)
    local keyBtnStroke = findStroke(keyBtn)

    -- tween helpers
    local function tween(obj, props, time)
        local info = TweenInfo.new(time or TweenTimeColor, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local t = TweenService:Create(obj, info, props)
        t:Play()
        return t
    end

    local function tweenTextTransparency(btn, target, time)
        local info = TweenInfo.new(time or TweenTimeText, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tw = TweenService:Create(btn, info, { TextTransparency = target })
        tw:Play()
        return tw
    end

    -- safe text setter with fade and reentrancy guard
    local animLocks = setmetatable({}, { __mode = "k" }) -- weak keys
    local function safeSetText(btn, newText)
        if not (btn and btn.Parent) then return end
        -- cancel previous on this btn
        if animLocks[btn] then
            animLocks[btn].cancel = true
        end
        local lock = { cancel = false }
        animLocks[btn] = lock

        -- fade out
        local out = tweenTextTransparency(btn, 1, TweenTimeText)
        out.Completed:Wait()
        if lock.cancel then
            if animLocks[btn] == lock then animLocks[btn] = nil end
            return
        end

        pcall(function() btn.Text = newText end)

        local inn = tweenTextTransparency(btn, 0, TweenTimeText)
        inn.Completed:Wait()
        if animLocks[btn] == lock then animLocks[btn] = nil end
    end

    -- internal state
    local aimModEnabled = false
    local selectedKeyName = nil -- string name of key, nil => None
    local listeningForKey = false
    local listenToken = nil
    local aimbotAnimLock = false -- prevent multiple warn anims
    local keyAnimLock = false

    -- helper to detect toggle state: prefer ToggleUI.Get if available
    local function getToggleOnByName(name, btn)
        local ok, val = pcall(function()
            if ToggleUI.Get then return ToggleUI.Get(name) end
            return nil
        end)
        if ok and type(val) == "boolean" then return val end
        -- fallback to color heuristic
        local bg = nil
        pcall(function() bg = btn.BackgroundColor3 end)
        if bg and bg.G and bg.G > bg.R and bg.G > bg.B and bg.G > 0.5 then return true end
        return false
    end

    -- sync local aimModEnabled when button color changes (ToggleUI will change the color)
    local function syncAimbotFromButton()
        local on = getToggleOnByName("AimbotButton", aimbotBtn)
        aimModEnabled = on
    end
    aimbotBtn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        task.delay(0.05, syncAimbotFromButton)
    end)

    -- warn animation when trying to enable without key selected
    local function playAimbotNoKeyWarn()
        if aimbotAnimLock then return end
        aimbotAnimLock = true
        -- tween to warn color quickly
        tween(aimbotBtn, { BackgroundColor3 = WARN_COLOR_FULL }, TweenTimeColor)
        if aimbotStroke then tween(aimbotStroke, { Color = WARN_COLOR_FULL }, TweenTimeColor) end
        task.delay(1, function()
            -- return to red
            tween(aimbotBtn, { BackgroundColor3 = RED_COLOR }, TweenTimeColor)
            if aimbotStroke then tween(aimbotStroke, { Color = RED_COLOR }, TweenTimeColor) end
            aimbotAnimLock = false
        end)
    end

    -- handle aimbot toggle via ToggleUI pattern
    local function onAimbotActivated()
        local cur = getToggleOnByName("AimbotButton", aimbotBtn)
        local requested = not cur
        -- if requesting ON but no key selected -> show warn and don't toggle
        if requested and not selectedKeyName then
            playAimbotNoKeyWarn()
            return
        end
        pcall(function() ToggleUI.Set("AimbotButton", requested) end)
    end

    if aimbotBtn.Activated then
        aimbotBtn.Activated:Connect(onAimbotActivated)
    else
        aimbotBtn.MouseButton1Click:Connect(onAimbotActivated)
    end

    -- helper to set key button appearance states
    local function setKeyBtnState(state, keyName)
        -- state: "none" | "waiting" | "selected"
        if state == "none" then
            -- immediate color set via tween to RED
            tween(keyBtn, { BackgroundColor3 = RED_COLOR }, TweenTimeColor)
            if keyBtnStroke then tween(keyBtnStroke, { Color = RED_COLOR }, TweenTimeColor) end
            safeSetText(keyBtn, "None")
        elseif state == "waiting" then
            tween(keyBtn, { BackgroundColor3 = WAIT_COLOR }, TweenTimeColor)
            if keyBtnStroke then tween(keyBtnStroke, { Color = WAIT_COLOR }, TweenTimeColor) end
            safeSetText(keyBtn, "Waiting...")
        elseif state == "selected" then
            tween(keyBtn, { BackgroundColor3 = OK_COLOR }, TweenTimeColor)
            if keyBtnStroke then tween(keyBtnStroke, { Color = OK_COLOR }, TweenTimeColor) end
            safeSetText(keyBtn, tostring(keyName or "None"))
        end
    end

    -- initialize key button to default None (red)
    pcall(function()
        keyBtn.BackgroundColor3 = RED_COLOR
        if keyBtnStroke then keyBtnStroke.Color = RED_COLOR end
        keyBtn.Text = "None"
    end)

    -- listening logic for key selection
    local function stopListening(cancelled)
        listeningForKey = false
        listenToken = nil
        if cancelled then
            selectedKeyName = nil
            setKeyBtnState("none")
        else
            if selectedKeyName then
                setKeyBtnState("selected", selectedKeyName)
            else
                setKeyBtnState("none")
            end
        end
    end

    local function startListeningForKey()
        if listeningForKey then return end
        listeningForKey = true
        setKeyBtnState("waiting")

        local token = {}
        listenToken = token

        local conn
        -- NOTE: purposely DO NOT ignore gameProcessed here so we can capture keys that other scripts or the game handled
        conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not listeningForKey then return end

            local inputName = nil
            if input.UserInputType == Enum.UserInputType.Keyboard then
                inputName = input.KeyCode and input.KeyCode.Name
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                inputName = "MouseButton1"
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                inputName = "MouseButton2"
            elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
                inputName = "MouseButton3"
            end

            if inputName and inputName ~= "" then
                selectedKeyName = inputName
                -- apply selected visuals (green + text)
                setKeyBtnState("selected", selectedKeyName)
                listeningForKey = false
                listenToken = nil
                if conn then conn:Disconnect() end
            end
        end)

        -- timeout
        task.delay(WaitTimeout, function()
            if listenToken == token and listeningForKey then
                -- timed out -> cancel and revert to None
                listeningForKey = false
                listenToken = nil
                if conn then conn:Disconnect() end
                selectedKeyName = nil
                setKeyBtnState("none")
            end
        end)
    end

    -- clicking keyBtn toggles listening (click again cancels)
    local function onKeyBtnActivated()
        if listeningForKey then
            -- cancel listening and revert to None (per earlier pattern)
            listeningForKey = false
            listenToken = nil
            selectedKeyName = nil
            setKeyBtnState("none")
            return
        end
        startListeningForKey()
    end

    if keyBtn.Activated then
        keyBtn.Activated:Connect(onKeyBtnActivated)
    else
        keyBtn.MouseButton1Click:Connect(onKeyBtnActivated)
    end

    -- Input handlers to set 'isKeyHeld' for aiming — compare against selectedKeyName
    local isKeyHeld = false
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        -- we intentionally process regardless of gameProcessed so keys captured elsewhere are still usable
        if listeningForKey then return end
        if not selectedKeyName then return end

        local inputName = nil
        if input.UserInputType == Enum.UserInputType.Keyboard then
            inputName = input.KeyCode and input.KeyCode.Name
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            inputName = "MouseButton1"
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            inputName = "MouseButton2"
        elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
            inputName = "MouseButton3"
        end

        if inputName == selectedKeyName then
            isKeyHeld = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        -- same: process regardless of gameProcessed
        if not selectedKeyName then return end
        local inputName = nil
        if input.UserInputType == Enum.UserInputType.Keyboard then
            inputName = input.KeyCode and input.KeyCode.Name
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            inputName = "MouseButton1"
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            inputName = "MouseButton2"
        elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
            inputName = "MouseButton3"
        end

        if inputName == selectedKeyName then
            isKeyHeld = false
        end
    end)

    -- Aim implementation: use camera lookAt when enabled AND key held
    local camera = workspace.CurrentCamera
    local function getClosestPlayerHead()
        local cross = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
        local best, bestDist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                local sp, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local pos2 = Vector2.new(sp.X, sp.Y)
                    local d = (pos2 - cross).Magnitude
                    if d < bestDist and d <= 200 then
                        best = head
                        bestDist = d
                    end
                end
            end
        end
        return best
    end

    local function AimAtTarget()
        -- sync aimbot enabled from ToggleUI each frame is not necessary; sync via propertyChanged earlier
        if not aimModEnabled then return end
        if not isKeyHeld then return end
        local h = getClosestPlayerHead()
        if h then
            camera.CFrame = CFrame.new(camera.CFrame.Position, h.Position)
        end
    end

    -- keep aimModEnabled in sync at start
    task.delay(0.05, syncAimbotFromButton)

    -- RenderStepped aim
    RunService.RenderStepped:Connect(AimAtTarget)

    -- IMPORTANT: do not auto-reset on respawn — user requested persistent selection + toggle only off via UI
    -- but keep button sync when UI changes after respawn (ToggleUI may update visual). We'll resync color->state.
    player.CharacterAdded:Connect(function()
        -- do not clear selectedKeyName or toggle state
        -- resync aimModEnabled from button color shortly after respawn
        task.delay(0.2, syncAimbotFromButton)
    end)
end

--=== FAST ATTACK ENEMY & PLAYER =========================================================================================--

do
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
    local EnemiesFolder = workspace:WaitForChild("Enemies")
    local LocalPlayer = Players.LocalPlayer
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")

    local TWEEN_TIME = 0.18
    local modeAnimating = {}

    local COLOR_TOGGLE = Color3.fromRGB(255,125,0)
    local COLOR_HOLD   = Color3.fromRGB(255,255,0)

    local function getUIStroke(btn)
    	for _, c in ipairs(btn:GetChildren()) do
    		if c:IsA("UIStroke") then
    			return c
    		end
    	end
    end

    local function tween(props, time)
    	local info = TweenInfo.new(time or TWEEN_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    	local t = TweenService:Create(props.obj, info, props.goal)
    	t:Play()
    	return t
    end

    local function animateModeButton(btn, isHold)
    	if not btn:IsA("TextButton") and not btn:IsA("TextLabel") then return end

    	-- cancel animation cũ
    	if modeAnimating[btn] then
    		modeAnimating[btn].cancelled = true
    	end

    	local anim = { cancelled = false }
    	modeAnimating[btn] = anim

    	local stroke = getUIStroke(btn)
    	local targetColor = isHold and COLOR_HOLD or COLOR_TOGGLE
    	local targetText  = "Mode: " .. (isHold and "Hold" or "Toggle")

    	-- Fade out
    	local t1 = tween({
    		obj = btn,
    		goal = { TextTransparency = 1 }
    	})
    	t1.Completed:Wait()
    	if anim.cancelled then return end

    	-- Set text
    	btn.Text = targetText

    	-- Fade in
    	tween({
    		obj = btn,
    		goal = { TextTransparency = 0 }
    	})

    	-- Background
    	tween({
    		obj = btn,
    		goal = { BackgroundColor3 = targetColor }
    	})

    	-- Stroke
    	if stroke then
    		tween({
    			obj = stroke,
    			goal = { Color = targetColor }
    		})
    	end
    end

    -- wait ToggleUI
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)

    -- ScrollingTab (bạn đã khởi tạo trước đó)
    local ScrollingTab = LocalPlayer.PlayerGui:WaitForChild("BloxFruitHubGui"):WaitForChild("Main"):WaitForChild("ScrollingTab")

    -- tìm Frame "Combat" trực tiếp trong ScrollingTab (hoặc descendants)
    local combatFrame = ScrollingTab:FindFirstChild("Combat") or ScrollingTab:FindFirstChild("Combat", true) or ScrollingTab:WaitForChild("Combat", 5)
    if not combatFrame then
        warn("Không tìm thấy Frame 'Combat' trong ScrollingTab")
        return
    end

    -- tìm controls mới
    local btnFastAttackEnemy = combatFrame:FindFirstChild("FastAttackEnemyButton", true)
    local btnAttackPlayer    = combatFrame:FindFirstChild("FastAttackPlayerButton", true)
    local btnModeEnemy       = combatFrame:FindFirstChild("ModeFastAttackEnemyButton", true)
    local btnModePlayer      = combatFrame:FindFirstChild("ModeFastAttackPlayerButton", true)

    if not btnFastAttackEnemy or not btnAttackPlayer or not btnModeEnemy or not btnModePlayer then
        warn("Không tìm đủ controls trong Combat (FastAttackEnemyButton / FastAttackPlayerButton / ModeFastAttackEnemyButton / ModeFastAttackPlayerButton)")
        return
    end

    -- ensure ToggleUI initial state OFF for toggles
    pcall(function() ToggleUI.Set("FastAttackEnemyButton", false) end)
    pcall(function() ToggleUI.Set("FastAttackPlayerButton", false) end)

    -- internal state
    local isFastAttackEnemyEnabled = false
    local isAttackPlayerEnabled = false
    local enemyHoldMode = false   -- false = Toggle, true = Hold
    local playerHoldMode = false
    local enemyActive = false
    local playerActive = false

    local radius = 100
    local delay = 0.01
    local maxhit = 5

    -- suppress flags to avoid attribute <-> UI loops
    local suppressAttrToUI = false
    local suppressUIToAttr = false

    -- helper: get ToggleUI state reliably (prefer ToggleUI.Get, fallback to color check)
    local function getToggleOnByName(name, btn)
        local ok, val = pcall(function()
            if ToggleUI.Get then return ToggleUI.Get(name) end
            return nil
        end)
        if ok and type(val) == "boolean" then return val end
        -- fallback color heuristic
        local bg = btn.BackgroundColor3
        if bg and bg.G and bg.G > bg.R and bg.G > bg.B and bg.G > 0.5 then return true end
        return false
    end

    -- When UI button clicked -> request ToggleUI.Set(name, not current)
    local function wireToggleButton(btn, name)
        local function onActivated()
            local cur = getToggleOnByName(name, btn)
            pcall(function() ToggleUI.Set(name, not cur) end)
        end
        if btn.Activated then
            btn.Activated:Connect(onActivated)
        else
            btn.MouseButton1Click:Connect(onActivated)
        end

        -- when UI color changes (ToggleUI likely changed), sync attribute
        btn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
            task.delay(0.05, function()
                if suppressUIToAttr then return end
                local isOn = getToggleOnByName(name, btn)
                local attrName = (name == "FastAttackEnemyButton") and "FastAttackEnemy" or "FastAttackPlayer"
                -- only set attribute if different
                if LocalPlayer:GetAttribute(attrName) ~= isOn then
                    suppressAttrToUI = true
                    LocalPlayer:SetAttribute(attrName, isOn)
                    suppressAttrToUI = false
                end
            end)
        end)
    end

    -- wire both toggle buttons
    wireToggleButton(btnFastAttackEnemy, "FastAttackEnemyButton")
    wireToggleButton(btnAttackPlayer,    "FastAttackPlayerButton")

    -- mode buttons: toggle attribute between Toggle/Hold and update text
    local function toggleModeAttribute(attrName, modeBtn)
        local cur = LocalPlayer:GetAttribute(attrName) or "Toggle"
        local nextMode = (tostring(cur) == "Hold") and "Toggle" or "Hold"
        LocalPlayer:SetAttribute(attrName, nextMode)
    end

    if btnModeEnemy.Activated then
        btnModeEnemy.Activated:Connect(function() toggleModeAttribute("FastAttackEnemyMode", btnModeEnemy) end)
    else
        btnModeEnemy.MouseButton1Click:Connect(function() toggleModeAttribute("FastAttackEnemyMode", btnModeEnemy) end)
    end

    if btnModePlayer.Activated then
        btnModePlayer.Activated:Connect(function() toggleModeAttribute("FastAttackPlayerMode", btnModePlayer) end)
    else
        btnModePlayer.MouseButton1Click:Connect(function() toggleModeAttribute("FastAttackPlayerMode", btnModePlayer) end)
    end

    -- Attribute listeners (sync local state -> optionally update UI via ToggleUI.Set)
    LocalPlayer:GetAttributeChangedSignal("FastAttackEnemy"):Connect(function()
        local v = LocalPlayer:GetAttribute("FastAttackEnemy") == true
        isFastAttackEnemyEnabled = v
        -- sync UI if necessary
        if not suppressAttrToUI then
            suppressUIToAttr = true
            pcall(function() ToggleUI.Set("FastAttackEnemyButton", v) end)
            -- small delay then release
            task.delay(0.05, function() suppressUIToAttr = false end)
        end
    end)

    LocalPlayer:GetAttributeChangedSignal("FastAttackPlayer"):Connect(function()
        local v = LocalPlayer:GetAttribute("FastAttackPlayer") == true
        isAttackPlayerEnabled = v
        if not suppressAttrToUI then
            suppressUIToAttr = true
            pcall(function() ToggleUI.Set("FastAttackPlayerButton", v) end)
            task.delay(0.05, function() suppressUIToAttr = false end)
        end
    end)

    LocalPlayer:GetAttributeChangedSignal("FastAttackEnemyMode"):Connect(function()
    	local v = LocalPlayer:GetAttribute("FastAttackEnemyMode")
    	enemyHoldMode = (tostring(v) == "Hold")
    	enemyActive = false

    	animateModeButton(btnModeEnemy, enemyHoldMode)
    end)

    LocalPlayer:GetAttributeChangedSignal("FastAttackPlayerMode"):Connect(function()
    	local v = LocalPlayer:GetAttribute("FastAttackPlayerMode")
    	playerHoldMode = (tostring(v) == "Hold")
    	playerActive = false

    	animateModeButton(btnModePlayer, playerHoldMode)
    end)

    do
        local v = LocalPlayer:GetAttribute("FastAttackEnemy") == true
        isFastAttackEnemyEnabled = v
        suppressUIToAttr = true
        pcall(function() ToggleUI.Set("FastAttackEnemyButton", v) end)
        task.delay(0.05, function() suppressUIToAttr = false end)

        local vm = LocalPlayer:GetAttribute("FastAttackEnemyMode") or "Toggle"
        enemyHoldMode = (tostring(vm) == "Hold")
        pcall(function() if btnModeEnemy:IsA("TextButton") or btnModeEnemy:IsA("TextLabel") then btnModeEnemy.Text = "Mode: " .. (enemyHoldMode and "Hold" or "Toggle") end end)

        local v2 = LocalPlayer:GetAttribute("FastAttackPlayer") == true
        isAttackPlayerEnabled = v2
        suppressUIToAttr = true
        pcall(function() ToggleUI.Set("FastAttackPlayerButton", v2) end)
        task.delay(0.05, function() suppressUIToAttr = false end)

        local vm2 = LocalPlayer:GetAttribute("FastAttackPlayerMode") or "Toggle"
        playerHoldMode = (tostring(vm2) == "Hold")
        pcall(function() if btnModePlayer:IsA("TextButton") or btnModePlayer:IsA("TextLabel") then btnModePlayer.Text = "Mode: " .. (playerHoldMode and "Hold" or "Toggle") end end)
    end

    -- shared poll (preserve behavior)
    task.spawn(function()
        local lastSharedEnemy, lastSharedPlayer = nil, nil
        while true do
            task.wait(0.15)
            local sEnemy = (shared and shared.FastAttackEnemy)
            local sPlayer = (shared and shared.FastAttackPlayer)

            if sEnemy ~= lastSharedEnemy then
                lastSharedEnemy = sEnemy
                if sEnemy ~= nil then
                    if type(sEnemy) == "string" then
                        local low = string.lower(sEnemy)
                        if low == "hold" then
                            LocalPlayer:SetAttribute("FastAttackEnemy", true)
                            LocalPlayer:SetAttribute("FastAttackEnemyMode", "Hold")
                        elseif low == "toggle" then
                            LocalPlayer:SetAttribute("FastAttackEnemy", true)
                            LocalPlayer:SetAttribute("FastAttackEnemyMode", "Toggle")
                        elseif low == "off" then
                            LocalPlayer:SetAttribute("FastAttackEnemy", false)
                        end
                    else
                        LocalPlayer:SetAttribute("FastAttackEnemy", sEnemy == true)
                    end
                end
            end

            if sPlayer ~= lastSharedPlayer then
                lastSharedPlayer = sPlayer
                if sPlayer ~= nil then
                    if type(sPlayer) == "string" then
                        local low = string.lower(sPlayer)
                        if low == "hold" then
                            LocalPlayer:SetAttribute("FastAttackPlayer", true)
                            LocalPlayer:SetAttribute("FastAttackPlayerMode", "Hold")
                        elseif low == "toggle" then
                            LocalPlayer:SetAttribute("FastAttackPlayer", true)
                            LocalPlayer:SetAttribute("FastAttackPlayerMode", "Toggle")
                        elseif low == "off" then
                            LocalPlayer:SetAttribute("FastAttackPlayer", false)
                        end
                    else
                        LocalPlayer:SetAttribute("FastAttackPlayer", sPlayer == true)
                    end
                end
            end
        end
    end)

    -- genid
    local function genid()
        local c = "0123456789abcdef"
        local s = ""
        for i=1,8 do
            s = s..c:sub(math.random(1,16),math.random(1,16))
        end
        return s
    end

    -- targets: keep original logic
    local function getTargetsEnemies(pos)
        local t = {}
        for _, enemy in pairs(EnemiesFolder:GetChildren()) do
            if enemy:IsA("Model") then
                local part = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("UpperTorso") or enemy:FindFirstChild("Torso")
                local hum = enemy:FindFirstChildOfClass("Humanoid")
                if part and hum and hum.Health > 0 then
                    local d = (part.Position - pos).Magnitude
                    if d <= radius then
                        table.insert(t, {model = enemy, part = part, dist = d})
                    end
                end
            end
        end
        table.sort(t, function(a,b) return a.dist < b.dist end)
        local r = {}
        for i=1, math.min(#t, maxhit) do table.insert(r, t[i]) end
        return r
    end

    local function getTargetsPlayers(pos)
        local t = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Torso") or p.Character:FindFirstChild("Head")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local d = (hrp.Position - pos).Magnitude
                    if d <= radius then
                        table.insert(t, {model = p.Character, part = hrp, dist = d})
                    end
                end
            end
        end
        table.sort(t, function(a,b) return a.dist < b.dist end)
        local r = {}
        for i=1, math.min(#t, maxhit) do table.insert(r, t[i]) end
        return r
    end

    -- remotes lazy ensure
    local atkrem, hitrem
    local function ensureRemotes()
        if atkrem and hitrem then return true end
        local s1, r1 = pcall(function() return ReplicatedStorage:WaitForChild("Modules",1):WaitForChild("Net",1):WaitForChild("RE/RegisterAttack",1) end)
        local s2, r2 = pcall(function() return ReplicatedStorage:WaitForChild("Modules",1):WaitForChild("Net",1):WaitForChild("RE/RegisterHit",1) end)
        if s1 and s2 then atkrem, hitrem = r1, r2 return true end
        return false
    end

    local lastEnemyHit = 0
    local lastPlayerHit = 0

    -- attack runner (Heartbeat)
    RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- ENEMY section
        local shouldEnemyBeActive = false
        if enemyHoldMode then
            if isFastAttackEnemyEnabled and enemyActive then shouldEnemyBeActive = true end
        else
            if isFastAttackEnemyEnabled then shouldEnemyBeActive = true end
        end

        if shouldEnemyBeActive and (tick() - lastEnemyHit) >= delay then
            lastEnemyHit = tick()
            if ensureRemotes() then
                pcall(function() atkrem:FireServer() end)
                local targets = getTargetsEnemies(hrp.Position)
                if #targets > 0 then
                    local mt = {}
                    local fp = nil
                    for _,info in ipairs(targets) do
                        local p = info.part
                        if p then
                            if not fp then fp = p end
                            table.insert(mt, {info.model, p})
                        end
                    end
                    if fp and #mt > 0 then
                        pcall(function() hitrem:FireServer(fp, mt, nil, genid()) end)
                    end
                end
            end
        end

        -- PLAYER section
        local shouldPlayerBeActive = false
        if playerHoldMode then
            if isAttackPlayerEnabled and playerActive then shouldPlayerBeActive = true end
        else
            if isAttackPlayerEnabled then shouldPlayerBeActive = true end
        end

        if shouldPlayerBeActive and (tick() - lastPlayerHit) >= delay then
            lastPlayerHit = tick()
            if ensureRemotes() then
                pcall(function() atkrem:FireServer() end)
                local targets = getTargetsPlayers(hrp.Position)
                if #targets > 0 then
                    local mt = {}
                    local fp = nil
                    for _,info in ipairs(targets) do
                        local p = info.part
                        if p then
                            if not fp then fp = p end
                            table.insert(mt, {info.model, p})
                        end
                    end
                    if fp and #mt > 0 then
                        pcall(function() hitrem:FireServer(fp, mt, nil, genid()) end)
                    end
                end
            end
        end
    end)

    -- Hold input on the UI buttons (if mode is Hold, pressing the button area toggles active)
    if btnFastAttackEnemy.InputBegan then
        btnFastAttackEnemy.InputBegan:Connect(function(input)
            if not enemyHoldMode then return end
            if not isFastAttackEnemyEnabled then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                enemyActive = true
            end
        end)
        btnFastAttackEnemy.InputEnded:Connect(function(input)
            if not enemyHoldMode then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                enemyActive = false
            end
        end)
    end

    if btnAttackPlayer.InputBegan then
        btnAttackPlayer.InputBegan:Connect(function(input)
            if not playerHoldMode then return end
            if not isAttackPlayerEnabled then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                playerActive = true
            end
        end)
        btnAttackPlayer.InputEnded:Connect(function(input)
            if not playerHoldMode then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                playerActive = false
            end
        end)
    end

    -- Global hold anywhere
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            if enemyHoldMode and isFastAttackEnemyEnabled then enemyActive = true end
            if playerHoldMode and isAttackPlayerEnabled then playerActive = true end
        end
    end)
    UIS.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            if enemyHoldMode then enemyActive = false end
            if playerHoldMode then playerActive = false end
        end
    end)
end
