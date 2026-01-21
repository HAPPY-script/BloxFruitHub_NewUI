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
    -- TELEPORT POINTS
    -----------------------------------------------------
    local PLACES = {
        Sea1 = {
            ids = { 85211729168715, 2753915549 },
            points = {
                Vector3.new(-7894.62, 5545.49, -380.29),
                Vector3.new(-4607.82, 872.54, -1667.56),
                Vector3.new(61163.85, 5.30, 1819.78),
                Vector3.new(3864.69, 5.37, -1926.21)
            }
        },

        Sea2 = {
            ids = { 79091703265657, 4442272183 },
            points = {
                Vector3.new(-286.99, 306.18, 597.75),
                Vector3.new(-6508.56, 83.24, -132.84),
                Vector3.new(923.21, 125.11, 32852.83),
                Vector3.new(2284.91, 15.20, 905.62)
            }
        },

        Sea3 = {
            ids = { 7449423635, 100117331123089 },
            points = {
                Vector3.new(-12463.61, 374.91, -7549.53),
                Vector3.new(-5073.83, 314.51, -3152.52),
                Vector3.new(5661.53, 1013.04, -334.96),
                Vector3.new(28286.36, 14896.56, 102.62)
            }
        },

        Dungeon = {
            ids = { 73902483975735 },
            points = {
                Vector3.new(0, 100000, 0)
            }
        }
    }

    local teleportPoints = {}

    do
        local placeId = game.PlaceId

        for _, data in pairs(PLACES) do
            if table.find(data.ids, placeId) then
                teleportPoints = data.points
                break
            end
        end

        if #teleportPoints == 0 then
            warn("PlaceID không thuộc Sea1 / Sea2 / Sea3 / Dungeon")
        end
    end

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
        if not hrp then return false end
    
        -- dùng CONFIG.FLY_SPEED nếu bạn đã có CONFIG, fallback = 320
        local speed = (type(CONFIG) == "table" and CONFIG.FLY_SPEED) or 320
        local finalOffset = 3
    
        -- nếu mục tiêu là player động -> align Y ban đầu giống target
        local thrp_init = safeTargetHRP()
        if thrp_init then
            local p = hrp.Position
            hrp.CFrame = CFrame.new(p.X, thrp_init.Position.Y, p.Z)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            RunService.Heartbeat:Wait()
        end
    
        -- helper planar
        local function planar(v) return Vector3.new(v.X, 0, v.Z) end
        local function planarMag(v) return math.sqrt(v.X*v.X + v.Z*v.Z) end
    
        local prevPlanarDist = math.huge
    
        -- main loop: mỗi frame cập nhật vị trí mục tiêu và tiến tới nó (không "cứng" vào một điểm cố định)
        while followEnabled do
            hrp = safeHRP()
            if not hrp then break end
    
            -- vị trí mục tiêu hiện tại (nếu có targetPlayer thì lấy vị trí động)
            local thrp = safeTargetHRP()
            local currentTargetPos = thrp and (thrp.Position + Vector3.new(0, HEIGHT_OFFSET, 0)) or targetPos
    
            -- đảm bảo Y của HRP khớp target Y (tránh rơi)
            local targetY = currentTargetPos.Y
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z)
    
            local curXZ = planar(hrp.Position)
            local tgtXZ = planar(currentTargetPos)
    
            local planarDist = (curXZ - tgtXZ).Magnitude
            if planarDist <= STOP_DIST then
                return true
            end
    
            -- safety: nếu khoảng cách tăng đột biến so với trước -> abort
            if planarDist > prevPlanarDist + 10 then
                break
            end
            prevPlanarDist = planarDist
    
            -- hướng planar tới mục tiêu
            local dirXZ = tgtXZ - curXZ
            local dirMag = planarMag(dirXZ)
            if dirMag < 0.0001 then
                -- gần như ở trên nhau, chờ frame tiếp
                RunService.Heartbeat:Wait()
                continue
            end
            local dirUnit = Vector3.new(dirXZ.X/dirMag, 0, dirXZ.Z/dirMag)
    
            -- adjusted target (đứng trước mục tiêu một chút)
            local adjustedXZ = tgtXZ - dirUnit * finalOffset
            local toAdjusted = adjustedXZ - curXZ
            local distToAdjusted = planarMag(toAdjusted)
    
            -- dt
            local dt = RunService.Heartbeat:Wait()
            if not followEnabled then break end
    
            -- move amount dựa trên speed * dt (không vượt quá khoảng cách còn lại)
            local moveDist = math.min(speed * dt, distToAdjusted)
            local newPosXZ = curXZ + Vector3.new(dirUnit.X * moveDist, 0, dirUnit.Z * moveDist)
    
            local newPos = Vector3.new(newPosXZ.X, targetY, newPosXZ.Z)
    
            -- đặt CFrame nhìn về mục tiêu (orientation mượt)
            hrp.CFrame = CFrame.new(newPos, currentTargetPos)
        end
    
        return false
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

    -- style colors & labels
    local STYLE_MELEE_COLOR = Color3.fromRGB(0,200,255)
    local STYLE_FRUIT_COLOR = Color3.fromRGB(0,255,150)
    local STYLE_MELEE_TEXT  = "Style: Melee"
    local STYLE_FRUIT_TEXT  = "Style: Fruit"

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
        if not btn or (not btn:IsA("TextButton") and not btn:IsA("TextLabel")) then return end

        if modeAnimating[btn] then
            modeAnimating[btn].cancelled = true
        end

        local anim = { cancelled = false }
        modeAnimating[btn] = anim

        local stroke = getUIStroke(btn)
        local targetColor = isHold and COLOR_HOLD or COLOR_TOGGLE
        local targetText  = "Mode: " .. (isHold and "Hold" or "Toggle")

        local t1 = tween({
            obj = btn,
            goal = { TextTransparency = 1 }
        })
        t1.Completed:Wait()
        if anim.cancelled then return end

        btn.Text = targetText

        tween({ obj = btn, goal = { TextTransparency = 0 } })
        tween({ obj = btn, goal = { BackgroundColor3 = targetColor } })
        if stroke then
            tween({ obj = stroke, goal = { Color = targetColor } })
        end
    end

    local function animateStyleButton(btn, isFruit)
        if not btn or (not btn:IsA("TextButton") and not btn:IsA("TextLabel")) then return end

        if modeAnimating[btn] then
            modeAnimating[btn].cancelled = true
        end

        local anim = { cancelled = false }
        modeAnimating[btn] = anim

        local stroke = getUIStroke(btn)
        local targetColor = isFruit and STYLE_FRUIT_COLOR or STYLE_MELEE_COLOR
        local targetText  = isFruit and STYLE_FRUIT_TEXT or STYLE_MELEE_TEXT

        local t1 = tween({
            obj = btn,
            goal = { TextTransparency = 1 }
        })
        t1.Completed:Wait()
        if anim.cancelled then return end

        btn.Text = targetText

        tween({ obj = btn, goal = { TextTransparency = 0 } })
        tween({ obj = btn, goal = { BackgroundColor3 = targetColor } })
        if stroke then
            tween({ obj = stroke, goal = { Color = targetColor } })
        end
    end

    -- wait ToggleUI
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)

    local ScrollingTab = LocalPlayer.PlayerGui:WaitForChild("BloxFruitHubGui"):WaitForChild("Main"):WaitForChild("ScrollingTab")
    local combatFrame = ScrollingTab:FindFirstChild("Combat") or ScrollingTab:FindFirstChild("Combat", true) or ScrollingTab:WaitForChild("Combat", 5)
    if not combatFrame then
        warn("Không tìm thấy Frame 'Combat' trong ScrollingTab")
        return
    end

    local btnFastAttackEnemy = combatFrame:FindFirstChild("FastAttackEnemyButton", true)
    local btnAttackPlayer    = combatFrame:FindFirstChild("FastAttackPlayerButton", true)
    local btnModeEnemy       = combatFrame:FindFirstChild("ModeFastAttackEnemyButton", true)
    local btnModePlayer      = combatFrame:FindFirstChild("ModeFastAttackPlayerButton", true)

    -- new style buttons
    local btnStyleEnemy      = combatFrame:FindFirstChild("StyleFastAttackEnemyButton", true)
    local btnStylePlayer     = combatFrame:FindFirstChild("StyleFastAttackPlayerButton", true)

    if not btnFastAttackEnemy or not btnAttackPlayer or not btnModeEnemy or not btnModePlayer then
        warn("Không tìm đủ controls trong Combat (FastAttackEnemyButton / FastAttackPlayerButton / ModeFastAttackEnemyButton / ModeFastAttackPlayerButton)")
        return
    end

    if not btnStyleEnemy or not btnStylePlayer then
        warn("Không tìm thấy StyleFastAttack buttons, thêm chúng vào UI để sử dụng tính năng style.")
        -- continue without style buttons (backward compatible)
    end

    pcall(function() ToggleUI.Set("FastAttackEnemyButton", false) end)
    pcall(function() ToggleUI.Set("FastAttackPlayerButton", false) end)

    -- internal state
    local isFastAttackEnemyEnabled = false
    local isAttackPlayerEnabled = false
    local enemyHoldMode = false   -- false = Toggle, true = Hold
    local playerHoldMode = false
    local enemyActive = false
    local playerActive = false

    -- style state: "Melee" or "Fruit"
    local enemyStyle = "Melee"
    local playerStyle = "Melee"

    local radius = 5000
    local delay = 0.01
    local maxhit = 5

    local suppressAttrToUI = false
    local suppressUIToAttr = false

    -- === NEW: strict green check (user requirement) ===
    local GREEN = Color3.fromRGB(0,255,0)
    local function colorEqual(a,b)
        if not a or not b then return false end
        local eps = 1e-5
        return math.abs(a.R - b.R) <= eps and math.abs(a.G - b.G) <= eps and math.abs(a.B - b.B) <= eps
    end

    local function isButtonOn(btn)
        local bg = btn and btn.BackgroundColor3
        if not bg then return false end
        -- authoritative: only exact green counts as ON
        return colorEqual(bg, GREEN)
    end
    -- === end NEW ===

    local function getToggleOnByName(name, btn)
        local ok, val = pcall(function()
            if ToggleUI.Get then return ToggleUI.Get(name) end
            return nil
        end)
        if ok and type(val) == "boolean" then return val end
        -- Use strict green-check instead of fuzzy G>R/B
        return isButtonOn(btn)
    end

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

        btn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
            task.delay(0.05, function()
                if suppressUIToAttr then return end
                local isOn = getToggleOnByName(name, btn)
                local attrName = (name == "FastAttackEnemyButton") and "FastAttackEnemy" or "FastAttackPlayer"
                if LocalPlayer:GetAttribute(attrName) ~= isOn then
                    suppressAttrToUI = true
                    LocalPlayer:SetAttribute(attrName, isOn)
                    suppressAttrToUI = false
                end
            end)
        end)
    end

    wireToggleButton(btnFastAttackEnemy, "FastAttackEnemyButton")
    wireToggleButton(btnAttackPlayer,    "FastAttackPlayerButton")

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

    -- wire style buttons (if present)
    local function toggleStyleAttribute(attrName, styleBtn)
        local cur = LocalPlayer:GetAttribute(attrName) or "Melee"
        local nextStyle = (tostring(cur) == "Fruit") and "Melee" or "Fruit"
        LocalPlayer:SetAttribute(attrName, nextStyle)
    end

    if btnStyleEnemy then
        if btnStyleEnemy.Activated then
            btnStyleEnemy.Activated:Connect(function() toggleStyleAttribute("FastAttackEnemyStyle", btnStyleEnemy) end)
        else
            btnStyleEnemy.MouseButton1Click:Connect(function() toggleStyleAttribute("FastAttackEnemyStyle", btnStyleEnemy) end)
        end
    end

    if btnStylePlayer then
        if btnStylePlayer.Activated then
            btnStylePlayer.Activated:Connect(function() toggleStyleAttribute("FastAttackPlayerStyle", btnStylePlayer) end)
        else
            btnStylePlayer.MouseButton1Click:Connect(function() toggleStyleAttribute("FastAttackPlayerStyle", btnStylePlayer) end)
        end
    end

    -- attribute change handlers
    LocalPlayer:GetAttributeChangedSignal("FastAttackEnemy"):Connect(function()
        local v = LocalPlayer:GetAttribute("FastAttackEnemy") == true
        isFastAttackEnemyEnabled = v
        if not suppressAttrToUI then
            suppressUIToAttr = true
            pcall(function() ToggleUI.Set("FastAttackEnemyButton", v) end)
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

    -- style attribute change handlers
    LocalPlayer:GetAttributeChangedSignal("FastAttackEnemyStyle"):Connect(function()
        local v = LocalPlayer:GetAttribute("FastAttackEnemyStyle")
        enemyStyle = (tostring(v) == "Fruit") and "Fruit" or "Melee"
        -- reset active flags to avoid hold leaks
        enemyActive = false
        if btnStyleEnemy then animateStyleButton(btnStyleEnemy, enemyStyle == "Fruit") end
    end)

    LocalPlayer:GetAttributeChangedSignal("FastAttackPlayerStyle"):Connect(function()
        local v = LocalPlayer:GetAttribute("FastAttackPlayerStyle")
        playerStyle = (tostring(v) == "Fruit") and "Fruit" or "Melee"
        playerActive = false
        if btnStylePlayer then animateStyleButton(btnStylePlayer, playerStyle == "Fruit") end
    end)

    -- initialize from attributes / UI
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

        -- styles
        local sEnemy = LocalPlayer:GetAttribute("FastAttackEnemyStyle") or "Melee"
        enemyStyle = (tostring(sEnemy) == "Fruit") and "Fruit" or "Melee"
        if btnStyleEnemy then
            pcall(function() if btnStyleEnemy:IsA("TextButton") or btnStyleEnemy:IsA("TextLabel") then
                btnStyleEnemy.Text = (enemyStyle == "Fruit") and STYLE_FRUIT_TEXT or STYLE_MELEE_TEXT
                btnStyleEnemy.BackgroundColor3 = (enemyStyle == "Fruit") and STYLE_FRUIT_COLOR or STYLE_MELEE_COLOR
                local stroke = getUIStroke(btnStyleEnemy)
                if stroke then stroke.Color = btnStyleEnemy.BackgroundColor3 end
            end end)
        end

        local sPlayer = LocalPlayer:GetAttribute("FastAttackPlayerStyle") or "Melee"
        playerStyle = (tostring(sPlayer) == "Fruit") and "Fruit" or "Melee"
        if btnStylePlayer then
            pcall(function() if btnStylePlayer:IsA("TextButton") or btnStylePlayer:IsA("TextLabel") then
                btnStylePlayer.Text = (playerStyle == "Fruit") and STYLE_FRUIT_TEXT or STYLE_MELEE_TEXT
                btnStylePlayer.BackgroundColor3 = (playerStyle == "Fruit") and STYLE_FRUIT_COLOR or STYLE_MELEE_COLOR
                local stroke = getUIStroke(btnStylePlayer)
                if stroke then stroke.Color = btnStylePlayer.BackgroundColor3 end
            end end)
        end
    end

    -- shared poll (unchanged)
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

    -- targets: original logic preserved
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

    -- remotes lazy ensure (for non-fruit attacks)
    local atkrem, hitrem
    local function ensureRemotes()
        if atkrem and hitrem then return true end
        local s1, r1 = pcall(function() return ReplicatedStorage:WaitForChild("Modules",1):WaitForChild("Net",1):WaitForChild("RE/RegisterAttack",1) end)
        local s2, r2 = pcall(function() return ReplicatedStorage:WaitForChild("Modules",1):WaitForChild("Net",1):WaitForChild("RE/RegisterHit",1) end)
        if s1 and s2 then atkrem, hitrem = r1, r2 return true end
        return false
    end

    -- last hit trackers
    local lastEnemyHit = 0
    local lastPlayerHit = 0

    -- ---------- NEW: Tool watcher & cached mouse ----------
    local currentTool = nil
    local currentToolRemote = nil
    local currentToolIsFruit = false -- true if LeftClickRemote detected

    local function updateCurrentTool()
        currentTool = nil
        currentToolRemote = nil
        currentToolIsFruit = false

        local char = LocalPlayer.Character
        if char then
            for _, t in ipairs(char:GetChildren()) do
                if t:IsA("Tool") then
                    local lr = t:FindFirstChild("LeftClickRemote")
                    if lr then
                        currentTool = t
                        currentToolRemote = lr
                        currentToolIsFruit = true
                        return
                    end
                end
            end
        end

        for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if t:IsA("Tool") then
                local lr = t:FindFirstChild("LeftClickRemote")
                if lr then
                    currentTool = t
                    currentToolRemote = lr
                    currentToolIsFruit = true
                    return
                end
            end
        end
    end

    -- set initial
    updateCurrentTool()

    -- connect listeners to update cache only on changes (no full scan every frame)
    LocalPlayer.CharacterAdded:Connect(function(c)
        task.defer(function()
            updateCurrentTool()
            -- watch character children for tool changes
            c.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then
                    updateCurrentTool()
                end
            end)
            c.ChildRemoved:Connect(function(child)
                if child:IsA("Tool") then
                    task.delay(0.01, updateCurrentTool)
                end
            end)
        end)
    end)

    -- watch backpack
    LocalPlayer.Backpack.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            task.delay(0.01, updateCurrentTool)
        end
    end)
    LocalPlayer.Backpack.ChildRemoved:Connect(function(child)
        if child:IsA("Tool") then
            task.delay(0.01, updateCurrentTool)
        end
    end)

    -- also watch equipped change (Tool.Equipped / Unequipped)
    local function attachToolSignals(tool)
        if not tool or not tool:IsA("Tool") then return end
        tool.Equipped:Connect(function()
            task.delay(0.01, updateCurrentTool)
        end)
        tool.Unequipped:Connect(function()
            task.delay(0.01, updateCurrentTool)
        end)
    end
    -- attach for existing
    for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do attachToolSignals(t) end
    if LocalPlayer.Character then for _, t in ipairs(LocalPlayer.Character:GetChildren()) do attachToolSignals(t) end end
    LocalPlayer.Backpack.ChildAdded:Connect(attachToolSignals)
    LocalPlayer.CharacterAdded:Connect(function(c)
        c.ChildAdded:Connect(attachToolSignals)
    end)

    -- cache mouse (only once)
    local mouse = LocalPlayer:GetMouse()

    -- CONFIG for fruit spam (you can expose to UI later)
    local FruitConfig = {
        Enabled = true, -- allow fruit usage when detected
        SpamDelay = 0.01, -- per-enemy/player cooldown (same as existing delay used)
        Skills = {true, true, true, true} -- which fruit 'click' indices to fire (1..4)
    }

    -- ----------
    -- Attack runner (Heartbeat)
    -- - For each tick we decide whether to attack enemies and/or players.
    -- - Attack method chosen strictly by the corresponding style (Melee vs Fruit).
    -- - If style == Fruit but no fruit equipped -> skip (do not fallback to melee).
    -- - If style == Melee but remotes not ready -> skip.
    -- ----------

    RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- ENEMY section: decide active
        local shouldEnemyBeActive = false
        if enemyHoldMode then
            if isFastAttackEnemyEnabled and enemyActive then shouldEnemyBeActive = true end
        else
            if isFastAttackEnemyEnabled then shouldEnemyBeActive = true end
        end

        if shouldEnemyBeActive and (tick() - lastEnemyHit) >= delay then
            lastEnemyHit = tick()

            local targets = getTargetsEnemies(hrp.Position)
            if #targets > 0 then
                -- Choose method based on enemyStyle
                if enemyStyle == "Fruit" then
                    -- Only use fruit method
                    if FruitConfig.Enabled and currentToolIsFruit and currentToolRemote then
                        local fp = targets[1].part
                        local aimDir
                        if fp and fp.Position and hrp.Position then
                            local dir = (fp.Position - hrp.Position)
                            if dir.Magnitude > 0 then
                                aimDir = dir.Unit
                            else
                                aimDir = (mouse.Hit and mouse.Hit.LookVector) or hrp.CFrame.LookVector
                            end
                        else
                            aimDir = (mouse.Hit and mouse.Hit.LookVector) or hrp.CFrame.LookVector
                        end

                        for i = 1, 4 do
                            if FruitConfig.Skills[i] then
                                pcall(function()
                                    currentToolRemote:FireServer(aimDir, i, true)
                                end)
                            end
                        end
                    end
                else
                    -- Melee path only
                    if ensureRemotes() then
                        pcall(function() atkrem:FireServer() end)
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
        end

        -- PLAYER section: decide active
        local shouldPlayerBeActive = false
        if playerHoldMode then
            if isAttackPlayerEnabled and playerActive then shouldPlayerBeActive = true end
        else
            if isAttackPlayerEnabled then shouldPlayerBeActive = true end
        end

        if shouldPlayerBeActive and (tick() - lastPlayerHit) >= delay then
            lastPlayerHit = tick()

            local targets = getTargetsPlayers(hrp.Position)
            if #targets > 0 then
                if playerStyle == "Fruit" then
                    if FruitConfig.Enabled and currentToolIsFruit and currentToolRemote then
                        local fp = targets[1].part
                        local aimDir
                        if fp and fp.Position and hrp.Position then
                            local dir = (fp.Position - hrp.Position)
                            if dir.Magnitude > 0 then
                                aimDir = dir.Unit
                            else
                                aimDir = (mouse.Hit and mouse.Hit.LookVector) or hrp.CFrame.LookVector
                            end
                        else
                            aimDir = (mouse.Hit and mouse.Hit.LookVector) or hrp.CFrame.LookVector
                        end

                        for i = 1, 4 do
                            if FruitConfig.Skills[i] then
                                pcall(function()
                                    currentToolRemote:FireServer(aimDir, i, true)
                                end)
                            end
                        end
                    end
                else
                    -- Melee path only for players
                    if ensureRemotes() then
                        pcall(function() atkrem:FireServer() end)
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
        end
    end)

    -- Hold input on the UI buttons (if mode is Hold)
    if btnFastAttackEnemy.InputBegan then
        btnFastAttackEnemy.InputBegan:Connect(function(input)
            if not enemyHoldMode then return end
            if not isButtonOn(btnFastAttackEnemy) then return end
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
            if not isButtonOn(btnAttackPlayer) then return end
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
            if enemyHoldMode and isButtonOn(btnFastAttackEnemy) then enemyActive = true end
            if playerHoldMode and isButtonOn(btnAttackPlayer) then playerActive = true end
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

--[[ HOOK
player:SetAttribute("FastAttackEnemy", true) -- false/true
player:SetAttribute("FastAttackPlayer", true) -- false/true

player:SetAttribute("FastAttackEnemyMode", "Toggle") -- Toggle/Hold
player:SetAttribute("FastAttackPlayerMode", "Toggle") -- Toggle/Hold

player:SetAttribute("FastAttackEnemyStyle", "Melee") -- Melee/Fruit
player:SetAttribute("FastAttackPlayerStyle", "Melee") -- Melee/Fruit
]]
--=== AUTO ESCAPE =========================================================================================--

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")

    local player = Players.LocalPlayer

    -- ===== ToggleUI =====
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() ToggleUI.Refresh() end)

    -- ===== UI ROOT (CỐ ĐỊNH) =====
    local ScrollingTab = player.PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    local Frame = ScrollingTab:FindFirstChild("Combat", true)
    if not Frame then return warn("Không tìm thấy Combat Frame") end

    local ToggleBtn = Frame:FindFirstChild("AutoEscapeButton", true)
    local ReturnBtn = Frame:FindFirstChild("ReturnYButton", true)
    local Box = Frame:FindFirstChild("AutoEscapeBox", true)

    if not ToggleBtn or not ReturnBtn or not Box then
        return warn("Thiếu UI AutoEscape")
    end

    local Stroke = ReturnBtn:FindFirstChildOfClass("UIStroke")

    -- ===== DEFAULT =====
    local DEFAULT_THRESHOLD = 35
    Box.Text = tostring(DEFAULT_THRESHOLD)
    pcall(function() ToggleUI.Set("AutoEscapeButton", false) end)

    -- ===== STATE =====
    local escapeThreshold = DEFAULT_THRESHOLD
    local isEscaping = false
    local safeTimer = 0
    local initialY = 0

    -- ===== COLOR =====
    local RED    = Color3.fromRGB(255, 0, 0)
    local GREEN  = Color3.fromRGB(0, 255, 0)
    local YELLOW = Color3.fromRGB(255, 255, 0)

    local function tweenReturnColor(color)
        TweenService:Create(ReturnBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = color
        }):Play()

        if Stroke then
            TweenService:Create(Stroke, TweenInfo.new(0.2), {
                Color = color
            }):Play()
        end
    end

    -- ===== TOGGLE STATE (qua màu) =====
    local function isToggleOn()
        local bg = ToggleBtn.BackgroundColor3
        return bg.G > bg.R and bg.G > bg.B
    end
    
    -- ===== TOGGLE BUTTON CLICK =====
    local function onToggleActivated()
        local cur = isToggleOn()
        pcall(function()
            ToggleUI.Set("AutoEscapeButton", not cur)
        end)
    end

    -- ===== SYNC UI KHI TOGGLE ĐỔI =====
    ToggleBtn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        task.delay(0.05, function()
            if not isToggleOn() then
                tweenReturnColor(RED)
            end
        end)
    end)
    
    if ToggleBtn.Activated then
        ToggleBtn.Activated:Connect(onToggleActivated)
    else
        ToggleBtn.MouseButton1Click:Connect(onToggleActivated)
    end

    -- ===== RETURN BUTTON INIT =====
    ReturnBtn.Text = "Y=0"
    tweenReturnColor(RED)

    -- ===== BOX VALIDATE =====
    Box.FocusLost:Connect(function()
        local n = tonumber(Box.Text)
        if not n then n = DEFAULT_THRESHOLD end
        n = math.clamp(n, 0.1, 100)
        escapeThreshold = n
        Box.Text = tostring(n)
    end)

    -- ===== RETURN Y CLICK =====
    ReturnBtn.Activated:Connect(function()
        if not isToggleOn() then return end
        if isEscaping then return end

        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        root.CFrame = CFrame.new(root.Position.X, initialY, root.Position.Z)
    end)

    -- ===== AUTO ESCAPE LOGIC =====
    RunService.Heartbeat:Connect(function(dt)
        if not isToggleOn() then
            isEscaping = false
            safeTimer = 0
            tweenReturnColor(RED)
            return
        end

        local char = player.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root then return end

        local hp = humanoid.Health
        local percent = (hp / humanoid.MaxHealth) * 100

        if percent < escapeThreshold then
            if not isEscaping then
                initialY = root.Position.Y
                ReturnBtn.Text = "Y=" .. math.floor(initialY)
            end

            isEscaping = true
            safeTimer = 0
            tweenReturnColor(YELLOW)

            root.CFrame += Vector3.new(0, 200, 0)
        else
            if isEscaping then
                safeTimer += dt
                if safeTimer >= 1 then
                    isEscaping = false
                end
            end

            if not isEscaping then
                tweenReturnColor(GREEN)
            end
        end
    end)
end
--=== SILENT AIM =========================================================================================--

do
    -- SilentAim (ổn định, tránh attempt to index nil with 'Destroying', default 360)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")

    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then return end

    -- Lấy ScrollingTab + Combat frame
    local ScrollingTab = LocalPlayer.PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    local combatFrame = ScrollingTab:FindFirstChild("Combat", true)
        or ScrollingTab:FindFirstChild("Combat")

    if not combatFrame then
        warn("Không tìm thấy Combat frame trong ScrollingTab")
        return
    end

    -- Notification helper
    local Notification = combatFrame:FindFirstChild("NotificationBlackTitle", true)
        or combatFrame:FindFirstChild("NotificationBlackTitle")
    local function setNotificationVisible(state)
        if Notification and typeof(Notification) == "Instance" then
            pcall(function() Notification.Visible = state end)
        end
    end

    -- Kiểm tra hook capability
    local function clientSupports()
        return type(hookmetamethod) == "function" and type(newcclosure) == "function"
    end

    if not clientSupports() then
        setNotificationVisible(true)
        warn("[SilentAim] Exploid không hỗ trợ hook")
        return
    else
        setNotificationVisible(false)
    end

    -- UI refs
    local SilentAimButton = combatFrame:FindFirstChild("SilentAimButton", true) or combatFrame:FindFirstChild("SilentAimButton")
    local ModeButton = combatFrame:FindFirstChild("360ModeButton", true) or combatFrame:FindFirstChild("360ModeButton")
    local RadiusBox = combatFrame:FindFirstChild("SilentAimBox", true) or combatFrame:FindFirstChild("SilentAimBox")
    local ModeTitle = combatFrame:FindFirstChild("SilentAimModeTitle", true) or combatFrame:FindFirstChild("SilentAimModeTitle")

    if not (SilentAimButton and ModeButton and RadiusBox and ModeTitle) then
        warn("Thiếu UI: SilentAimButton/360ModeButton/SilentAimBox/SilentAimModeTitle required")
        return
    end

    -- ToggleUI setup (theo chuẩn hub)
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    local BUTTON_NAME = SilentAimButton.Name
    ToggleUI.Refresh()
    pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)

    local function isButtonOn()
        local ok, c = pcall(function() return SilentAimButton.BackgroundColor3 end)
        if not ok or not c then return false end
        local r = math.floor(c.R * 255 + 0.5)
        local g = math.floor(c.G * 255 + 0.5)
        local b = math.floor(c.B * 255 + 0.5)
        return (r == 0 and g == 255 and b == 0)
    end

    local silentEnabled = isButtonOn()

    if SilentAimButton.Activated then
        SilentAimButton.Activated:Connect(function()
            pcall(function() ToggleUI.Set(BUTTON_NAME, not isButtonOn()) end)
        end)
    else
        SilentAimButton.MouseButton1Click:Connect(function()
            pcall(function() ToggleUI.Set(BUTTON_NAME, not isButtonOn()) end)
        end)
    end

    SilentAimButton:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        task.delay(0.05, function()
            silentEnabled = isButtonOn()
        end)
    end)

    -- Mode visuals (default 360)
    local COLOR_360 = Color3.fromRGB(0,255,255)
    local COLOR_LIMIT = Color3.fromRGB(144,0,255)
    local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local mode = "360"

    local function setModeVisuals(newMode)
        mode = newMode or mode
        local targetColor = (mode == "360") and COLOR_360 or COLOR_LIMIT
        pcall(function()
            TweenService:Create(ModeButton, tweenInfo, {BackgroundColor3 = targetColor}):Play()
            local stroke = ModeButton:FindFirstChildOfClass("UIStroke") or ModeButton:FindFirstChild("UIStroke", true)
            if stroke then TweenService:Create(stroke, tweenInfo, {Color = targetColor}):Play() end
            TweenService:Create(ModeButton, TweenInfo.new(0.12), {TextTransparency = 1}):Play()
            task.delay(0.13, function()
                if ModeButton and ModeButton.Parent then
                    ModeButton.Text = (mode == "360") and "Mode:\n360°" or "Mode:\nLimit"
                    TweenService:Create(ModeButton, TweenInfo.new(0.12), {TextTransparency = 0}):Play()
                end
            end)
            local targetPos = (mode == "Limit") and UDim2.new(0.275,0,0.4,0) or UDim2.new(0.375,0,0.4,0)
            local targetSize = (mode == "Limit") and UDim2.new(0.5,0,0.03,0) or UDim2.new(0.7,0,0.03,0)
            if ModeTitle and ModeTitle.Parent then
                TweenService:Create(ModeTitle, tweenInfo, {Position = targetPos, Size = targetSize}):Play()
            end
        end)
    end
    setModeVisuals(mode)
    ModeButton.Activated:Connect(function()
        setModeVisuals((mode == "360") and "Limit" or "360")
    end)

    -- Radius box safe
    local function safeGetText(box)
        local ok, t = pcall(function() return box and box.Text end)
        return ok and t or nil
    end
    local function getRadius()
        local txt = safeGetText(RadiusBox)
        local n = tonumber(txt)
        if not n or n <= 0 then return 100 end
        return math.clamp(math.floor(n), 10, 10000)
    end
    RadiusBox.FocusLost:Connect(function()
        local n = tonumber(safeGetText(RadiusBox))
        if not n then RadiusBox.Text = "100" else RadiusBox.Text = tostring(getRadius()) end
    end)
    if not tonumber(safeGetText(RadiusBox)) then RadiusBox.Text = "100" end

    -- Drawing FOV (optional)
    local FOVCircle
    if typeof(Drawing) == "table" and type(Drawing.new) == "function" then
        local ok, circ = pcall(function() return Drawing.new("Circle") end)
        if ok and circ then
            FOVCircle = circ
            FOVCircle.Thickness = 2
            FOVCircle.NumSides = 64
            FOVCircle.Filled = false
            FOVCircle.Transparency = 1
            FOVCircle.Color = Color3.new(1,1,1)
            FOVCircle.Visible = false
        end
    end

    -- ===== Cached target (update OUTSIDE hook, giống code mẫu) =====
    local Camera = workspace.CurrentCamera
    local CACHE_INTERVAL = 0.12
    local cachedTarget = nil
    local cachedAt = 0

    local function isInFOV_screen(screenPos, radius)
        if not screenPos or not Camera then return false end
        local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        return (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude <= radius
    end

    local function updateNearest()
        if not Camera then
            cachedTarget = nil
            return
        end

        local camPos = Camera.CFrame and Camera.CFrame.Position or Vector3.new(0,0,0)
        local bestD2 = math.huge
        local bestChar = nil

        local playersList = Players:GetPlayers()
        for i = 1, #playersList do
            local pl = playersList[i]
            if pl and pl ~= LocalPlayer then
                local ch = pl.Character
                if ch then
                    local hrp = ch:FindFirstChild("HumanoidRootPart")
                    local hum = ch:FindFirstChildOfClass("Humanoid")
                    if hrp and hum and hum.Health and hum.Health > 0 then
                        local consider = false
                        if mode == "360" then
                            consider = true
                        else
                            local ok, screenV3, onScreen = pcall(function()
                                local v, vis = Camera:WorldToScreenPoint(hrp.Position)
                                return v, vis
                            end)
                            if ok and screenV3 and onScreen and isInFOV_screen(screenV3, getRadius()) then
                                consider = true
                            end
                        end

                        if consider then
                            local dx,dy,dz = hrp.Position.X - camPos.X, hrp.Position.Y - camPos.Y, hrp.Position.Z - camPos.Z
                            local d2 = dx*dx + dy*dy + dz*dz
                            if d2 < bestD2 then
                                bestD2 = d2
                                bestChar = ch
                            end
                        end
                    end
                end
            end
        end

        cachedTarget = bestChar
    end

    local cacheConn = RunService.Heartbeat:Connect(function()
        local now = tick()
        if (now - cachedAt) >= CACHE_INTERVAL then
            cachedAt = now
            pcall(updateNearest)
        end
    end)

    -- Mouse safe
    local Mouse
    local okMouse, resMouse = pcall(function() return LocalPlayer:GetMouse() end)
    if okMouse then Mouse = resMouse end
    if not Mouse then
        warn("[SilentAim] Không lấy được Mouse -> dừng.")
        setNotificationVisible(true)
        if cacheConn then cacheConn:Disconnect() end
        return
    end

    -- ===== Hook __index trên Mouse (giống code mẫu, an toàn) =====
    local oldIndex
    local okHook, hookErr = pcall(function()
        oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
            -- chỉ can thiệp khi không phải gọi bởi chúng ta và feature bật, và đối tượng là Mouse
            if not checkcaller() and silentEnabled and self == Mouse then
                -- tìm target (theo cachedTarget) giống code mẫu
                local target = nil
                if _G and _G.SilentAimMode == "Static" and _G._SilentAimTarget then
                    -- nếu có static target (global) dùng luôn (cần tương thích nếu bạn đang dùng _G)
                    target = _G._SilentAimTarget
                else
                    local char = cachedTarget
                    if char then
                        target = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                    end
                end

                if target then
                    -- xử lý các key cần override
                    if key == "Hit" then
                        if typeof(target) == "Vector3" then
                            return CFrame.new(target)
                        elseif typeof(target) == "Instance" then
                            -- trả CFrame (nhiều game mong CFrame cho Hit)
                            return (target.CFrame or CFrame.new(target.Position))
                        end
                    elseif key == "Target" then
                        if typeof(target) == "Instance" then
                            return target
                        end
                    elseif key == "X" or key == "Y" then
                        if typeof(target) == "Vector3" then
                            local ok, sp, onScreen = pcall(function() return Camera:WorldToScreenPoint(target) end)
                            if ok and sp then
                                return (key == "X") and sp.X or sp.Y
                            end
                        elseif typeof(target) == "Instance" then
                            local pos = target.Position or (target.CFrame and target.CFrame.Position)
                            if pos then
                                local ok, sp, onScreen = pcall(function() return Camera:WorldToScreenPoint(pos) end)
                                if ok and sp then
                                    return (key == "X") and sp.X or sp.Y
                                end
                            end
                        end
                    end
                end
            end

            -- fallback an toàn: trả kết quả __index gốc (đóng gói bằng pcall)
            local ok, res = pcall(oldIndex, self, key)
            if ok then return res end
            return nil
        end))
    end)

    if not okHook or type(oldIndex) ~= "function" then
        setNotificationVisible(true)
        warn("[SilentAim] Hook __index không thành công -> dừng. Lỗi:", hookErr)
        if cacheConn then cacheConn:Disconnect() end
        return
    else
        setNotificationVisible(false)
    end

    -- Render update (Heartbeat)
    local renderConn = RunService.Heartbeat:Connect(function()
        if FOVCircle and Camera then
            if mode == "Limit" then
                pcall(function()
                    FOVCircle.Visible = true
                    FOVCircle.Radius = getRadius()
                    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                end)
            else
                pcall(function() FOVCircle.Visible = false end)
            end
        end
    end)
end
