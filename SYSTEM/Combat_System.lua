--=== FOLLOW PLAYER =========================================================================================--

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")

    local player = Players.LocalPlayer

    -- đợi ToggleUI framework
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)

    -- TÌM UI: ScrollingTab -> Frame "Combat"
    local ScrollingTab = player.PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    local combatFrame = ScrollingTab:FindFirstChild("Combat", true)
        or ScrollingTab:FindFirstChild("Combat")

    if not combatFrame then
        warn("Không tìm thấy Frame 'Combat'")
        return
    end

    local BUTTON_NAME = "FollowPlayerButton"
    local BOX_NAME    = "FollowPlayerBox"

    local followBtn = combatFrame:FindFirstChild(BUTTON_NAME, true)
    local nameBox = combatFrame:FindFirstChild(BOX_NAME, true)

    if not followBtn then warn("Không tìm thấy FollowPlayerButton") return end
    if not nameBox then warn("Không tìm thấy FollowPlayerBox") return end

    -- INTERNAL STATE
    local followEnabled = false
    local targetPlayer = nil
    local disabledDueLowHP = false
    local isFollowCoroutineRunning = false

    -- prevent overlapping invalid tweens
    local invalidTweenRunning = false

    -----------------------------------------------------
    -- TELEPORT POINTS (giữ nguyên)
    -----------------------------------------------------
    local teleportPoints = {
        Vector3.new(-12463.61, 374.91, -7549.53),
        Vector3.new(-5073.83, 314.51, -3152.52),
        Vector3.new(5661.53, 1013.04, -334.96),
        Vector3.new(28286.36, 14896.56, 102.62)
    }

    -----------------------------------------------------
    -- Utility (giữ nguyên + helper UIStroke)
    -----------------------------------------------------
    local function safeHRP()
        local char = player.Character
        if not char then return end
        return char:FindFirstChild("HumanoidRootPart")
    end
    local function safeHumanoid()
        local char = player.Character
        if not char then return end
        return char:FindFirstChildOfClass("Humanoid")
    end

    local function safeTargetHRP()
        if not targetPlayer then return end
        local char = targetPlayer.Character
        if not char then return end
        return char:FindFirstChild("HumanoidRootPart")
    end
    local function safeTargetHumanoid()
        if not targetPlayer then return end
        local char = targetPlayer.Character
        if not char then return end
        return char:FindFirstChildOfClass("Humanoid")
    end

    local function distance(a,b)
        return (a-b).Magnitude
    end

    local function findNearestTP(targetPos)
        local best = nil
        local bestDist = math.huge
        for _,p in pairs(teleportPoints) do
            local d = distance(p, targetPos)
            if d < bestDist then
                bestDist = d
                best = p
            end
        end
        return best, bestDist
    end

    -- tìm UIStroke (nếu có) trong descendants
    local function getUIStroke(inst)
        if not inst then return nil end
        for _, desc in ipairs(inst:GetDescendants()) do
            if desc:IsA("UIStroke") then
                return desc
            end
        end
        -- fallback: immediate children
        return inst:FindFirstChildOfClass("UIStroke")
    end

    -----------------------------------------------------
    -- Movement params (giữ nguyên)
    -----------------------------------------------------
    local STOP_DIST = 4
    local HEIGHT_OFFSET = 6

    local function resetMovement()
        local hrp = safeHRP()
        local hum = safeHumanoid()

        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end

        if hum then
            pcall(function()
                hum.PlatformStand = false
                hum.AutoRotate = true
            end)
        end
    end

    local function instantTeleport(pos)
        local hrp = safeHRP()
        if not hrp then return end
        hrp.CFrame = CFrame.new(pos + Vector3.new(0,60,0))
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        RunService.Heartbeat:Wait()
        hrp.CFrame += Vector3.new(0,3,0)
    end

    -----------------------------------------------------
    -- SmoothFlyTo: giữ nguyên logic gốc
    -----------------------------------------------------
    local function SmoothFlyTo(targetPos)
        local hrp = safeHRP()
        local myHum = safeHumanoid()
        if not hrp then return end

        local targetHRP = safeTargetHRP()
        if targetHRP then
            local p = hrp.Position
            hrp.CFrame = CFrame.new(p.X, targetHRP.Position.Y, p.Z)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            RunService.Heartbeat:Wait()
        end

        local startPos = hrp.Position
        local dist = (startPos - targetPos).Magnitude
        if dist <= STOP_DIST then return end

        local duration = math.max(0.05, dist / 320)
        local t = 0

        local dir = (targetPos - startPos).Unit
        local finalOffset = 3
        local adjustedTarget = targetPos - dir * finalOffset
        if adjustedTarget.Y < targetPos.Y - 10 then
            adjustedTarget = Vector3.new(adjustedTarget.X, targetPos.Y + 2, adjustedTarget.Z)
        end

        local prevDist = (hrp.Position - targetPos).Magnitude

        while t < 1 and followEnabled do
            hrp = safeHRP()
            if not hrp then break end

            local curDist = (hrp.Position - targetPos).Magnitude
            if curDist <= STOP_DIST then break end

            if curDist > prevDist + 10 then
                break
            end
            prevDist = curDist

            t += RunService.Heartbeat:Wait() / duration
            if t > 1 then t = 1 end

            local newPos = startPos:Lerp(adjustedTarget, t)
            hrp.CFrame = CFrame.new(newPos, targetPos)
        end
    end

    -----------------------------------------------------
    -- FOLLOW LOOP (đảm bảo chỉ chạy 1 coroutine)
    -----------------------------------------------------
    local function followLoop()
        if isFollowCoroutineRunning then return end
        isFollowCoroutineRunning = true

        local hum = safeHumanoid()
        if hum then
            hum.PlatformStand = true
            hum.AutoRotate = false
        end

        while followEnabled do
            local hrp = safeHRP()
            local thrp = safeTargetHRP()
            local thum = safeTargetHumanoid()
            local myHum = safeHumanoid()

            if not hrp or not thrp or not thum or not myHum then
                break
            end

            if myHum and myHum.Health / myHum.MaxHealth * 100 < 25 then
                local cur = hrp.Position
                instantTeleport(Vector3.new(cur.X, cur.Y + 5000, cur.Z))

                followEnabled = false
                disabledDueLowHP = true
                targetPlayer = nil

                pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)

                break
            end

            if thum.Health <= 0 then
                followEnabled = false
                targetPlayer = nil
                pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)
                break
            end

            local targetPos = thrp.Position + Vector3.new(0, HEIGHT_OFFSET, 0)
            local myPos = hrp.Position
            local dist = distance(myPos, targetPos)

            local nearest, ndist = findNearestTP(targetPos)
            if nearest then
                local d_tp_to_target = distance(nearest, targetPos)
                local d_direct = distance(myPos, targetPos)

                if d_tp_to_target < d_direct then
                    local hrp_inner = safeHRP()
                    if hrp_inner then
                        for i = 1, 20 do
                            hrp_inner.CFrame = CFrame.new(nearest + Vector3.new(0,60,0))
                            hrp_inner.AssemblyLinearVelocity = Vector3.zero
                            hrp_inner.AssemblyAngularVelocity = Vector3.zero
                            RunService.Heartbeat:Wait()
                        end

                        hrp_inner.CFrame = hrp_inner.CFrame + Vector3.new(0, 100, 0)
                        RunService.Heartbeat:Wait()
                    end

                    SmoothFlyTo(targetPos)
                    continue
                end
            end

            if dist < 100 then
                while followEnabled do
                    local hrp_inner = safeHRP()
                    local thrp_inner = safeTargetHRP()
                    local thum_inner = safeTargetHumanoid()
                    local myHum_inner = safeHumanoid()
                    if not hrp_inner or not thrp_inner or not thum_inner or not myHum_inner then break end

                    if myHum_inner.Health / myHum_inner.MaxHealth * 100 < 20 then
                        local c = hrp_inner.Position
                        instantTeleport(Vector3.new(c.X, c.Y+5000, c.Z))
                        followEnabled = false
                        disabledDueLowHP = true
                        targetPlayer = nil

                        pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)
                        break
                    end

                    if thum_inner.Health <= 0 then
                        followEnabled = false
                        targetPlayer = nil
                        pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)
                        break
                    end

                    hrp_inner.CFrame = thrp_inner.CFrame * CFrame.new(0,0,1)
                    RunService.Heartbeat:Wait()
                end

                RunService.Heartbeat:Wait()
                continue
            end

            SmoothFlyTo(targetPos)
        end

        resetMovement()
        isFollowCoroutineRunning = false

        if followEnabled then
            followEnabled = false
            targetPlayer = nil
            pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)
        end
    end

    -----------------------------------------------------
    -- PICK TARGET: yêu cầu chính xác theo 3 ký tự đầu
    -----------------------------------------------------
    local function pickTargetFromName(txt)
        if not txt then return nil end
        txt = txt:lower()
        if #txt < 3 then return nil end
        local prefix = txt:sub(1,3)

        for _,pl in pairs(Players:GetPlayers()) do
            if pl ~= player then
                local name = pl.Name:lower()
                local head = name:sub(1,3)
                if head == prefix then
                    return pl
                end
            end
        end
        return nil
    end

    local function invalidFeedback()
        -- tránh chạy chồng
        if invalidTweenRunning then
            -- vẫn đảm bảo toggle off (trường hợp bất thường) nhưng không làm ngay nếu đang tween
            return
        end
        invalidTweenRunning = true

        local stroke = getUIStroke(followBtn)
        local yellow = Color3.fromRGB(255,255,0)
        local red = Color3.fromRGB(255,0,0)

        local info = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        -- tween sang vàng (feedback)
        pcall(function()
            local t1 = TweenService:Create(followBtn, info, {BackgroundColor3 = yellow})
            t1:Play()
            if stroke then
                local t1s = TweenService:Create(stroke, info, {Color = yellow})
                t1s:Play()
            end
        end)

        -- Sau 1s -> tween về đỏ, rồi mới yêu cầu ToggleUI tắt (để tránh ghi đè tween)
        task.delay(1, function()
            pcall(function()
                local t2 = TweenService:Create(followBtn, info, {BackgroundColor3 = red})
                t2:Play()
                if stroke then
                    local t2s = TweenService:Create(stroke, info, {Color = red})
                    t2s:Play()
                end
            end)

            -- đợi tween trả về đỏ hoàn tất trước khi cho phép feedback tiếp theo và tắt toggle UI
            task.delay(0.25, function()
                pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)
                invalidTweenRunning = false
            end)
        end)
    end

    -----------------------------------------------------
    -- Button click: QUẢN LÝ NỘI BỘ, KHÔNG DỰA VÀO MÀU
    -----------------------------------------------------
    local function onButtonActivated()
        if disabledDueLowHP then return end

        if followEnabled then
            followEnabled = false
            targetPlayer = nil
            pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)
            return
        end

        local hum = safeHumanoid()
        if hum and hum.Health / hum.MaxHealth * 100 < 20 then
            disabledDueLowHP = true
            return
        end

        local txt = nameBox.Text
        local t = pickTargetFromName(txt)
        if not t then
            invalidFeedback()
            return
        end

        targetPlayer = t
        followEnabled = true
        pcall(function() ToggleUI.Set(BUTTON_NAME, true) end)
        coroutine.wrap(followLoop)()
    end

    if followBtn.Activated then
        followBtn.Activated:Connect(onButtonActivated)
    else
        followBtn.MouseButton1Click:Connect(onButtonActivated)
    end

    -----------------------------------------------------
    -- Khi đổi tên trong TextBox (FocusLost): xử lý chuyển mục tiêu hoặc tự tắt
    -----------------------------------------------------
    nameBox.FocusLost:Connect(function(enterPressed)
        local txt = nameBox.Text
        if not txt or txt == "" then
            if followEnabled then
                followEnabled = false
                targetPlayer = nil
                pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)
            end
            return
        end

        local newTarget = pickTargetFromName(txt)
        if followEnabled then
            if newTarget then
                targetPlayer = newTarget
            else
                followEnabled = false
                targetPlayer = nil
                pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)
                -- show feedback when user changes to invalid name
                invalidFeedback()
            end
        else
            -- nếu chưa follow, không auto bật; chỉ chuẩn bị sẵn tên
            if enterPressed then
                -- cho phép nhấn Enter để thử bật ngay
                onButtonActivated()
            end
        end
    end)

    -----------------------------------------------------
    -- CLEAR LOW-HP LOCK WHEN HEALED (giữ logic)
    -----------------------------------------------------
    spawn(function()
        while true do
            local hum = safeHumanoid()
            if hum and disabledDueLowHP then
                if hum.Health / hum.MaxHealth * 100 >= 20 then
                    disabledDueLowHP = false
                end
            end
            wait(1)
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
