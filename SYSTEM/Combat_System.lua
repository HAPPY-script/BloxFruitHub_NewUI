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
                        for i = 2, 60 do
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
    -- Services & locals
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local UIS = game:GetService("UserInputService")
    
    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then return end
    
    -- UI / module refs (wait for ToggleUI global)
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)
    
    -- Find Combat UI
    local function findCombatFrame()
        local g = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("BloxFruitHubGui", 5)
        if not g then return nil end
        local main = g:FindFirstChild("Main") or g:WaitForChild("Main", 1)
        if not main then return nil end
        local scrolling = main:FindFirstChild("ScrollingTab") or main:WaitForChild("ScrollingTab", 1)
        if not scrolling then return nil end
        local combat = scrolling:FindFirstChild("Combat") or scrolling:FindFirstChild("Combat", true)
        return combat
    end
    
    local combatFrame = findCombatFrame()
    if not combatFrame then
        warn("FastAttack core: Không tìm thấy Combat frame trong UI.")
        return
    end
    
    local btnFastAttackEnemy = combatFrame:FindFirstChild("FastAttackEnemyButton", true)
    local btnAttackPlayer    = combatFrame:FindFirstChild("FastAttackPlayerButton", true)
    local btnModeEnemy       = combatFrame:FindFirstChild("ModeFastAttackEnemyButton", true)
    local btnModePlayer      = combatFrame:FindFirstChild("ModeFastAttackPlayerButton", true)
    local btnStyleEnemy      = combatFrame:FindFirstChild("StyleFastAttackEnemyButton", true)
    local btnStylePlayer     = combatFrame:FindFirstChild("StyleFastAttackPlayerButton", true)
    
    if not btnFastAttackEnemy or not btnAttackPlayer or not btnModeEnemy or not btnModePlayer then
        warn("FastAttack core: thiếu controls cần thiết trong Combat UI.")
        return
    end
    
    -- TWEENS / UI helpers
    local TWEEN_TIME = 0.18
    local modeAnimating = {}
    local function getUIStroke(btn)
        for _, c in ipairs(btn:GetChildren()) do if c:IsA("UIStroke") then return c end end
    end
    local function tween(props, time)
        local info = TweenService:Create(props.obj, TweenInfo.new(time or TWEEN_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props.goal)
        info:Play()
        return info
    end
    
    local COLOR_TOGGLE = Color3.fromRGB(255,125,0)
    local COLOR_HOLD   = Color3.fromRGB(255,255,0)
    
    local STYLE_MELEE_COLOR = Color3.fromRGB(0,200,255)
    local STYLE_FRUIT_COLOR = Color3.fromRGB(0,255,150)
    local STYLE_MF_COLOR    = Color3.fromRGB(255,0,100)
    
    local STYLE_MELEE_TEXT  = "Style: Melee"
    local STYLE_FRUIT_TEXT  = "Style: Fruit"
    local STYLE_MF_TEXT     = "Style: Melee & Fruit"
    
    local function animateModeButton(btn, isHold)
        if not btn or (not btn:IsA("TextButton") and not btn:IsA("TextLabel")) then return end
        if modeAnimating[btn] then modeAnimating[btn].cancelled = true end
        local anim = { cancelled = false }
        modeAnimating[btn] = anim
        local stroke = getUIStroke(btn)
        local targetColor = isHold and COLOR_HOLD or COLOR_TOGGLE
        local targetText  = "Mode: " .. (isHold and "Hold" or "Toggle")
    
        local t1 = tween({ obj = btn, goal = { TextTransparency = 1 } })
        t1.Completed:Wait()
        if anim.cancelled then return end
    
        btn.Text = targetText
        tween({ obj = btn, goal = { TextTransparency = 0 } })
        tween({ obj = btn, goal = { BackgroundColor3 = targetColor } })
        if stroke then tween({ obj = stroke, goal = { Color = targetColor } }) end
    end
    
    -- animateStyleButton now accepts style string: "Melee" / "Fruit" / "M&F"
    local function animateStyleButton(btn, style)
        if not btn or (not btn:IsA("TextButton") and not btn:IsA("TextLabel")) then return end
        if modeAnimating[btn] then modeAnimating[btn].cancelled = true end
        local anim = { cancelled = false }
        modeAnimating[btn] = anim
        local stroke = getUIStroke(btn)
    
        local targetColor, targetText
        if style == "Fruit" then
            targetColor = STYLE_FRUIT_COLOR
            targetText = STYLE_FRUIT_TEXT
        elseif style == "M&F" then
            targetColor = STYLE_MF_COLOR
            targetText = STYLE_MF_TEXT
        else
            targetColor = STYLE_MELEE_COLOR
            targetText = STYLE_MELEE_TEXT
        end
    
        local t1 = tween({ obj = btn, goal = { TextTransparency = 1 } })
        t1.Completed:Wait()
        if anim.cancelled then return end
    
        btn.Text = targetText
        tween({ obj = btn, goal = { TextTransparency = 0 } })
        tween({ obj = btn, goal = { BackgroundColor3 = targetColor } })
        if stroke then tween({ obj = stroke, goal = { Color = targetColor } }) end
    end
    
    -- === State ===
    local isFastAttackEnemyEnabled = false
    local isAttackPlayerEnabled = false
    local enemyHoldMode = false   -- false = Toggle, true = Hold
    local playerHoldMode = false
    local enemyActive = false
    local playerActive = false
    local enemyStyle = "Melee"
    local playerStyle = "Melee"
    
    local radius = 5000
    local delay = 0.01
    local maxhit = 5
    
    local suppressAttrToUI = false
    local suppressUIToAttr = false
    
    -- Strict green check
    local GREEN = Color3.fromRGB(0,255,0)
    local function colorEqual(a,b)
        if not a or not b then return false end
        local eps = 1e-5
        return math.abs(a.R - b.R) <= eps and math.abs(a.G - b.G) <= eps and math.abs(a.B - b.B) <= eps
    end
    local function isButtonOn(btn)
        local bg = btn and btn.BackgroundColor3
        if not bg then return false end
        return colorEqual(bg, GREEN)
    end
    
    local function getToggleOnByName(name, btn)
        local ok, val = pcall(function() if ToggleUI.Get then return ToggleUI.Get(name) end end)
        if ok and type(val) == "boolean" then return val end
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
    
    -- toggleStyleAttribute cycles: Melee -> Fruit -> M&F -> Melee
    local function toggleStyleAttribute(attrName, styleBtn)
        local cur = LocalPlayer:GetAttribute(attrName) or "Melee"
        local nextStyle
        if tostring(cur) == "Melee" then
            nextStyle = "Fruit"
        elseif tostring(cur) == "Fruit" then
            nextStyle = "M&F"
        else
            nextStyle = "Melee"
        end
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
    
    -- Attribute change handlers
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
    LocalPlayer:GetAttributeChangedSignal("FastAttackEnemyStyle"):Connect(function()
        local v = LocalPlayer:GetAttribute("FastAttackEnemyStyle")
        local s = tostring(v or "Melee")
        -- accept "Melee", "Fruit", "M&F" (case-sensitive expectation); fallback to Melee
        if s ~= "Melee" and s ~= "Fruit" and s ~= "M&F" then s = "Melee" end
        enemyStyle = s
        enemyActive = false
        if btnStyleEnemy then animateStyleButton(btnStyleEnemy, enemyStyle) end
    end)
    LocalPlayer:GetAttributeChangedSignal("FastAttackPlayerStyle"):Connect(function()
        local v = LocalPlayer:GetAttribute("FastAttackPlayerStyle")
        local s = tostring(v or "Melee")
        if s ~= "Melee" and s ~= "Fruit" and s ~= "M&F" then s = "Melee" end
        playerStyle = s
        playerActive = false
        if btnStylePlayer then animateStyleButton(btnStylePlayer, playerStyle) end
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
    
        -- styles (support M&F)
        local sEnemy = LocalPlayer:GetAttribute("FastAttackEnemyStyle") or "Melee"
        if sEnemy ~= "Melee" and sEnemy ~= "Fruit" and sEnemy ~= "M&F" then sEnemy = "Melee" end
        enemyStyle = sEnemy
        if btnStyleEnemy then
            pcall(function() if btnStyleEnemy:IsA("TextButton") or btnStyleEnemy:IsA("TextLabel") then
                local text, color
                if enemyStyle == "Fruit" then text = STYLE_FRUIT_TEXT; color = STYLE_FRUIT_COLOR
                elseif enemyStyle == "M&F" then text = STYLE_MF_TEXT; color = STYLE_MF_COLOR
                else text = STYLE_MELEE_TEXT; color = STYLE_MELEE_COLOR
                end
                btnStyleEnemy.Text = text
                btnStyleEnemy.BackgroundColor3 = color
                local stroke = getUIStroke(btnStyleEnemy)
                if stroke then stroke.Color = btnStyleEnemy.BackgroundColor3 end
            end end)
        end
    
        local sPlayer = LocalPlayer:GetAttribute("FastAttackPlayerStyle") or "Melee"
        if sPlayer ~= "Melee" and sPlayer ~= "Fruit" and sPlayer ~= "M&F" then sPlayer = "Melee" end
        playerStyle = sPlayer
        if btnStylePlayer then
            pcall(function() if btnStylePlayer:IsA("TextButton") or btnStylePlayer:IsA("TextLabel") then
                local text, color
                if playerStyle == "Fruit" then text = STYLE_FRUIT_TEXT; color = STYLE_FRUIT_COLOR
                elseif playerStyle == "M&F" then text = STYLE_MF_TEXT; color = STYLE_MF_COLOR
                else text = STYLE_MELEE_TEXT; color = STYLE_MELEE_COLOR
                end
                btnStylePlayer.Text = text
                btnStylePlayer.BackgroundColor3 = color
                local stroke = getUIStroke(btnStylePlayer)
                if stroke then stroke.Color = btnStylePlayer.BackgroundColor3 end
            end end)
        end
    end
    
    -- ---------------- Remotes / Proxy / Seed caching (from sample)
    local PROXY_CACHE_TIME = 5
    local SEED_CACHE_TIME = 3
    local cachedProxy = nil
    local cachedSeed = nil
    local lastProxyUpdate = 0
    local lastSeedUpdate = 0
    local attackRemote, hitRemote = nil, nil
    
    local function genid()
        local c = "0123456789abcdef"
        local s = ""
        for i=1,8 do
            s = s .. c:sub(math.random(1,16), math.random(1,16))
        end
        return s
    end
    
    local function encodeName(remoteName)
        local ok, serverTime = pcall(function() return workspace:GetServerTimeNow() end)
        local seed = ok and serverTime or tick()
        local key = math.floor(seed / 10 % 10) + 1
        local encoded = {}
        for i = 1, #remoteName do
            encoded[#encoded+1] = string.char(bit32.bxor(string.byte(remoteName, i), key))
        end
        return table.concat(encoded)
    end
    
    local function findProxyRemote()
        local now = tick()
        if cachedProxy and (now - lastProxyUpdate < PROXY_CACHE_TIME) then return cachedProxy end
        local folders = {"Util", "Remotes", "Assets", "Common", "FX", "Modules"}
        for _, folderName in ipairs(folders) do
            local folder = ReplicatedStorage:FindFirstChild(folderName)
            if folder then
                for _, obj in ipairs(folder:GetChildren()) do
                    if obj:IsA("RemoteEvent") and tonumber(obj.Name) and obj:GetAttribute("Id") then
                        cachedProxy = obj
                        lastProxyUpdate = now
                        return obj
                    end
                end
            end
        end
        cachedProxy = nil
        return nil
    end
    
    local function getSeed()
        local now = tick()
        if cachedSeed and (now - lastSeedUpdate < SEED_CACHE_TIME) then return cachedSeed end
        local success, mod = pcall(function() return ReplicatedStorage:FindFirstChild("Modules") end)
        if success and mod and mod:FindFirstChild("Net") then
            local net = mod:FindFirstChild("Net")
            local seedRemote = net:FindFirstChild("seed")
            if seedRemote and seedRemote:IsA("RemoteFunction") then
                local ok, val = pcall(function() return seedRemote:InvokeServer() end)
                if ok and val then
                    cachedSeed = tonumber(val)
                    lastSeedUpdate = now
                    return cachedSeed
                end
            end
        end
        return cachedSeed
    end
    
    -- ensure direct remotes
    local function ensureDirectRemotes()
        if attackRemote and hitRemote then return true end
        local ok, mod = pcall(function() return ReplicatedStorage:FindFirstChild("Modules") end)
        if ok and mod and mod:FindFirstChild("Net") then
            local net = mod:FindFirstChild("Net")
            attackRemote = net:FindFirstChild("RE/RegisterAttack")
            hitRemote = net:FindFirstChild("RE/RegisterHit")
            return attackRemote and hitRemote
        end
        return false
    end
    
    -- ---------------- Targeting helpers (enemies & players)
    local EnemiesFolder = workspace:FindFirstChild("Enemies")
    
    local function getTargetsEnemies(pos)
        local t = {}
        local folders = {}
        local f1 = workspace:FindFirstChild("Enemies")
        if f1 and f1:IsA("Folder") or f1 and f1:IsA("Model") then table.insert(folders, f1) end
        local f2 = workspace:FindFirstChild("SeaBeasts")
        if f2 and (f2:IsA("Folder") or f2:IsA("Model")) then table.insert(folders, f2) end
        if #folders == 0 then return t end
    
        for _, folder in ipairs(folders) do
            for _, enemy in ipairs(folder:GetChildren()) do
                if enemy:IsA("Model") then
                    local hrp = enemy:FindFirstChild("HumanoidRootPart")
                    local part = hrp or enemy:FindFirstChild("UpperTorso") or enemy:FindFirstChild("Torso") or enemy:FindFirstChild("Head")
                    local hum = enemy:FindFirstChildOfClass("Humanoid")
                    if part and hum and hum.Health > 0 then
                        local d = (part.Position - pos).Magnitude
                        if d <= radius then
                            table.insert(t, {model = enemy, part = part, dist = d})
                        end
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
        for _, p in ipairs(Players:GetPlayers()) do
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
    
    -- ---------------- Tool detection & cached mouse
    local currentTool = nil
    local currentToolRemote = nil
    local currentToolIsFruit = false
    
    local function updateCurrentTool()
        currentTool = nil
        currentToolRemote = nil
        currentToolIsFruit = false
        local char = LocalPlayer.Character
        if char then
            for _, t in ipairs(char:GetChildren()) do
                if t:IsA("Tool") then
                    local lr = t:FindFirstChild("LeftClickRemote")
                    if lr then currentTool = t; currentToolRemote = lr; currentToolIsFruit = true; return end
                end
            end
        end
        for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if t:IsA("Tool") then
                local lr = t:FindFirstChild("LeftClickRemote")
                if lr then currentTool = t; currentToolRemote = lr; currentToolIsFruit = true; return end
            end
        end
    end
    
    updateCurrentTool()
    
    LocalPlayer.CharacterAdded:Connect(function(c)
        task.defer(function()
            updateCurrentTool()
            c.ChildAdded:Connect(function(child) if child:IsA("Tool") then updateCurrentTool() end end)
            c.ChildRemoved:Connect(function(child) if child:IsA("Tool") then task.delay(0.01, updateCurrentTool) end end)
        end)
    end)
    
    LocalPlayer.Backpack.ChildAdded:Connect(function(child) if child:IsA("Tool") then task.delay(0.01, updateCurrentTool) end end)
    LocalPlayer.Backpack.ChildRemoved:Connect(function(child) if child:IsA("Tool") then task.delay(0.01, updateCurrentTool) end end)
    
    local function attachToolSignals(tool)
        if not tool or not tool:IsA("Tool") then return end
        tool.Equipped:Connect(function() task.delay(0.01, updateCurrentTool) end)
        tool.Unequipped:Connect(function() task.delay(0.01, updateCurrentTool) end)
    end
    for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do attachToolSignals(t) end
    if LocalPlayer.Character then for _, t in ipairs(LocalPlayer.Character:GetChildren()) do attachToolSignals(t) end end
    LocalPlayer.Backpack.ChildAdded:Connect(attachToolSignals)
    LocalPlayer.CharacterAdded:Connect(function(c) c.ChildAdded:Connect(attachToolSignals) end)
    
    local mouse = LocalPlayer:GetMouse()
    
    -- Fruit usage config
    local FruitConfig = {
        Enabled = true,
        SpamDelay = delay,
        Skills = {true,true,true,true}
    }
    
    -- ---------------- Attack runner
    local lastEnemyHit = 0
    local lastPlayerHit = 0
    
    RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
    
        -- decide enemy active
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
                -- If style includes Fruit, perform fruit attacks (if tool available)
                if (enemyStyle == "Fruit" or enemyStyle == "M&F") then
                    if FruitConfig.Enabled and currentToolIsFruit and currentToolRemote then
                        local fp = targets[1].part
                        local aimDir
                        if fp and fp.Position and hrp.Position then
                            local dir = (fp.Position - hrp.Position)
                            aimDir = (dir.Magnitude > 0) and dir.Unit or ((mouse.Hit and mouse.Hit.LookVector) or hrp.CFrame.LookVector)
                        else
                            aimDir = (mouse.Hit and mouse.Hit.LookVector) or hrp.CFrame.LookVector
                        end
                        for i=1,4 do
                            if FruitConfig.Skills[i] then
                                pcall(function()
                                    currentToolRemote:FireServer(aimDir, i, true)
                                end)
                            end
                        end
                    end
                end
    
                -- If style includes Melee, perform melee path
                if (enemyStyle == "Melee" or enemyStyle == "M&F") then
                    if ensureDirectRemotes() then
                        pcall(function() attackRemote:FireServer() end)
                        local mt = {}
                        local fp = nil
                        for _, info in ipairs(targets) do
                            local model = info.model
                            if model then
                                local chosen = model:FindFirstChild("HumanoidRootPart") or info.part
                                if chosen then
                                    if not fp then fp = chosen end
                                    table.insert(mt, {model, chosen})
                                end
                            end
                        end
                        if fp and #mt > 0 then
                            pcall(function() hitRemote:FireServer(fp, mt, nil, genid()) end)
                        end
                    end
                end
            end
        end
    
        -- decide player active
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
                if (playerStyle == "Fruit" or playerStyle == "M&F") then
                    if FruitConfig.Enabled and currentToolIsFruit and currentToolRemote then
                        local fp = targets[1].part
                        local aimDir
                        if fp and fp.Position and hrp.Position then
                            local dir = (fp.Position - hrp.Position)
                            aimDir = (dir.Magnitude > 0) and dir.Unit or ((mouse.Hit and mouse.Hit.LookVector) or hrp.CFrame.LookVector)
                        else
                            aimDir = (mouse.Hit and mouse.Hit.LookVector) or hrp.CFrame.LookVector
                        end
                        for i=1,4 do
                            if FruitConfig.Skills[i] then
                                pcall(function()
                                    currentToolRemote:FireServer(aimDir, i, true)
                                end)
                            end
                        end
                    end
                end
    
                if (playerStyle == "Melee" or playerStyle == "M&F") then
                    if ensureDirectRemotes() then
                        pcall(function() attackRemote:FireServer() end)
                        local mt = {}
                        local fp = nil
                        for _, info in ipairs(targets) do
                            local model = info.model
                            if model then
                                local chosen = model:FindFirstChild("HumanoidRootPart") or info.part
                                if chosen then
                                    if not fp then fp = chosen end
                                    table.insert(mt, {model, chosen})
                                end
                            end
                        end
                        if fp and #mt > 0 then
                            pcall(function() hitRemote:FireServer(fp, mt, nil, genid()) end)
                        end
                    end
                end
            end
        end
    end)
    
    -- Hold button handlers (UI)
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
    UIS.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if enemyHoldMode and isButtonOn(btnFastAttackEnemy) then enemyActive = true end
            if playerHoldMode and isButtonOn(btnAttackPlayer) then playerActive = true end
        end
    end)
    UIS.InputEnded:Connect(function(input, processed)
        if processed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if enemyHoldMode then enemyActive = false end
            if playerHoldMode then playerActive = false end
        end
    end)
    
    -- Shared `shared` poll (keep compatibility)
    task.spawn(function()
        local lastSharedEnemy, lastSharedPlayer = nil, nil
        while task.wait(0.15) do
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
    
    -- Warm up caches once
    task.spawn(function()
        task.wait(1)
        findProxyRemote()
        getSeed()
        ensureDirectRemotes()
    end)
    
    -- Backwards-compatible: expose some internals if needed
    local exported = {
        GenID = genid,
        FindProxy = findProxyRemote,
        GetSeed = getSeed,
        EnsureRemotes = ensureDirectRemotes
    }
    pcall(function() _G.FastAttackCore = exported end)
end

--[[ HOOK
player:SetAttribute("FastAttackEnemy", true) -- false/true
player:SetAttribute("FastAttackPlayer", true) -- false/true

player:SetAttribute("FastAttackEnemyMode", "Toggle") -- Toggle/Hold
player:SetAttribute("FastAttackPlayerMode", "Toggle") -- Toggle/Hold

player:SetAttribute("FastAttackEnemyStyle", "Melee") -- Melee/Fruit/M&F
player:SetAttribute("FastAttackPlayerStyle", "Melee") -- Melee/Fruit/M&F
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

--=== TP KEY =======================================================================================================--

do
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")

    local player = Players.LocalPlayer

    -- chờ ToggleUI helper theo chuẩn
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)

    -- khai báo ScrollingTab (theo mẫu chuẩn)
    local ScrollingTab = player.PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    -- CHANGED: tìm CombatFrame thay vì Player Setting
    local combatFrame = ScrollingTab:FindFirstChild("Combat", true) or ScrollingTab:FindFirstChild("Combat")
    if not combatFrame then
        warn("Không tìm thấy Frame 'Combat' trong ScrollingTab")
        return
    end

    -- controls tên chuẩn trong CombatFrame
    local TOGGLE_NAME = "TPKeyPCButton"
    local SELECT_NAME = "SelectTPKeyPCButton"

    local toggleBtn = combatFrame:FindFirstChild(TOGGLE_NAME, true)
    local selectBtn = combatFrame:FindFirstChild(SELECT_NAME, true)

    if not toggleBtn then warn("Không tìm thấy TPKeyPCButton trong Combat") return end
    if not selectBtn then warn("Không tìm thấy SelectTPKeyPCButton trong Combat") return end

    -- helper: tìm UIStroke first descendant
    local function findStroke(inst)
        for _, c in ipairs(inst:GetDescendants()) do
            if c:IsA("UIStroke") then return c end
        end
        return nil
    end

    local selectStroke = findStroke(selectBtn)

    -- constants
    local TWEEN_COLOR_TIME = 0.25
    local TWEEN_TEXT_TIME  = 0.18
    local WAIT_TIMEOUT     = 5 -- giây để chờ phím
    local COLOR_RED   = Color3.fromRGB(255,0,0)
    local COLOR_YELLOW= Color3.fromRGB(255,200,0)
    local COLOR_GREEN = Color3.fromRGB(0,255,0)

    -- internal state
    local teleportEnabled = false
    local selectedKey = nil
    local listeningForKey = false
    local listenCancelToken = nil
    local animLocks = {} -- khóa animation theo object

    -- ==== TPKeyBindings registry setup ====
    -- global registry so other scripts can see which keys are taken.
    _G.TPKeyBindings = _G.TPKeyBindings or {}
    local OWNER_ID = ("TPKeySample_%s"):format(tostring(math.random(1000000,9999999)))

    -- If re-run and owner already had a registration, restore it
    if _G.TPKeyBindings[OWNER_ID] then
        selectedKey = _G.TPKeyBindings[OWNER_ID]
    end

    -- Tween helpers
    local function tweenGui(obj, props, time)
        local info = TweenInfo.new(time or TWEEN_COLOR_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tw = TweenService:Create(obj, info, props)
        tw:Play()
        return tw
    end

    local function tweenTextTransparency(btn, target, time)
        local info = TweenInfo.new(time or TWEEN_TEXT_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tw = TweenService:Create(btn, info, { TextTransparency = target })
        tw:Play()
        return tw
    end

    -- Safe text change with lock to prevent race
    local function safeSetText(btn, newText)
        if animLocks[btn] then animLocks[btn].cancel = true end
        local lock = { cancel = false }
        animLocks[btn] = lock

        local twOut = tweenTextTransparency(btn, 1, TWEEN_TEXT_TIME)
        twOut.Completed:Wait()
        if lock.cancel then animLocks[btn] = nil return end

        pcall(function() btn.Text = newText end)

        local twIn = tweenTextTransparency(btn, 0, TWEEN_TEXT_TIME)
        twIn.Completed:Wait()
        if animLocks[btn] == lock then animLocks[btn] = nil end
    end

    -- Set select button appearance for states: "none", "waiting", "selected"
    local function setSelectAppearance(state, keyName)
        if state == "none" then
            tweenGui(selectBtn, { BackgroundColor3 = COLOR_RED }, TWEEN_COLOR_TIME)
            if selectStroke then tweenGui(selectStroke, { Color = COLOR_RED }, TWEEN_COLOR_TIME) end
            safeSetText(selectBtn, "None")
        elseif state == "waiting" then
            tweenGui(selectBtn, { BackgroundColor3 = COLOR_YELLOW }, TWEEN_COLOR_TIME)
            if selectStroke then tweenGui(selectStroke, { Color = COLOR_YELLOW }, TWEEN_COLOR_TIME) end
            safeSetText(selectBtn, "Waiting...")
        elseif state == "selected" then
            tweenGui(selectBtn, { BackgroundColor3 = COLOR_GREEN }, TWEEN_COLOR_TIME)
            if selectStroke then tweenGui(selectStroke, { Color = COLOR_GREEN }, TWEEN_COLOR_TIME) end
            safeSetText(selectBtn, tostring(keyName or "None"))
        end
    end

    -- initial select button default: red + "None" (or restore selection)
    pcall(function()
        if selectedKey then
            selectBtn.BackgroundColor3 = COLOR_GREEN
            if selectStroke then selectStroke.Color = COLOR_GREEN end
            selectBtn.Text = tostring(selectedKey)
        else
            selectBtn.BackgroundColor3 = COLOR_RED
            if selectStroke then selectStroke.Color = COLOR_RED end
            selectBtn.Text = "None"
        end
    end)

    -- ToggleUI setup for teleport toggle
    pcall(function() ToggleUI.Set(TOGGLE_NAME, false) end)

    -- helper infer toggle on from BG (same pattern)
    local function inferToggleOn(btn)
        local bg
        pcall(function() bg = btn.BackgroundColor3 end)
        if not bg then return false end
        return bg.G and bg.G > bg.R and bg.G > bg.B and bg.G > 0.5
    end

    local function syncToggleFromBtn()
        local on = inferToggleOn(toggleBtn)
        if teleportEnabled == on then return end
        teleportEnabled = on
    end

    toggleBtn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        task.delay(0.05, syncToggleFromBtn)
    end)

    local function requestToggle()
        local cur = inferToggleOn(toggleBtn)
        pcall(function() ToggleUI.Set(TOGGLE_NAME, not cur) end)
    end

    if toggleBtn.Activated then
        toggleBtn.Activated:Connect(requestToggle)
    else
        toggleBtn.MouseButton1Click:Connect(requestToggle)
    end

    -- Listening logic (CHANGED: during listening we DO NOT ignore gameProcessed so keys already handled elsewhere are still captured)
    local function startListening()
        if listeningForKey then return end
        listeningForKey = true

        -- create token so other functions can cancel/disconnect
        local token = {}
        listenCancelToken = token

        -- set UI to waiting asynchronously so this function is not blocked by tweens
        task.spawn(function()
            -- only show waiting if still this token
            if listenCancelToken == token then
                setSelectAppearance("waiting")
            end
        end)

        local conn
        conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            -- deliberately do NOT bail out on gameProcessed here; allows capturing keys that other scripts/games processed
            if listenCancelToken ~= token or not listeningForKey then return end

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
                -- check registry to see if other owner already has this key
                local taken = false
                for owner, k in pairs(_G.TPKeyBindings) do
                    if owner ~= OWNER_ID and k == inputName then
                        taken = true
                        break
                    end
                end

                -- Stop listening IMMEDIATELY, disconnect connection, clear token
                listeningForKey = false
                -- disconnect first to avoid any further events
                if conn then
                    conn:Disconnect()
                    conn = nil
                end
                -- clear the global token reference so timeout won't act
                listenCancelToken = nil

                if taken then
                    -- show "Taken" briefly then revert to previous state
                    task.spawn(function()
                        safeSetText(selectBtn, "Taken")
                        task.wait(0.7)
                        if selectedKey then
                            setSelectAppearance("selected", selectedKey)
                        else
                            setSelectAppearance("none")
                        end
                    end)
                    return
                end

                -- set selectedKey immediately and register in global table
                selectedKey = inputName
                _G.TPKeyBindings[OWNER_ID] = selectedKey

                -- run UI update asynchronously so we don't block InputBegan handler
                task.spawn(function()
                    setSelectAppearance("selected", selectedKey)
                end)
            end
        end)

        -- attach conn reference to token so external canceller can disconnect
        token.conn = conn

        -- timeout handler
        task.delay(WAIT_TIMEOUT, function()
            if listenCancelToken == token and listeningForKey then
                -- cancel listening
                listeningForKey = false
                -- disconnect conn if exists
                if token.conn then
                    pcall(function() token.conn:Disconnect() end)
                    token.conn = nil
                end
                listenCancelToken = nil
                -- unregister any temporary binding
                if _G.TPKeyBindings[OWNER_ID] then _G.TPKeyBindings[OWNER_ID] = nil end
                selectedKey = nil
                -- update UI asynchronously
                task.spawn(function() setSelectAppearance("none") end)
            end
        end)
    end

    local function stopListeningCancel()
        if listeningForKey then
            listeningForKey = false
            -- if there's an active token with a connection, disconnect it
            if listenCancelToken and listenCancelToken.conn then
                pcall(function() listenCancelToken.conn:Disconnect() end)
                listenCancelToken.conn = nil
            end
            listenCancelToken = nil
            -- unregister binding associated with this owner (if any)
            if _G.TPKeyBindings[OWNER_ID] then _G.TPKeyBindings[OWNER_ID] = nil end
            -- update UI asynchronously (do not block caller)
            task.spawn(function() setSelectAppearance("none") end)
        end
    end

    local function onSelectActivated()
        if listeningForKey then
            stopListeningCancel()
            return
        end
        startListening()
    end

    if selectBtn.Activated then
        selectBtn.Activated:Connect(onSelectActivated)
    else
        selectBtn.MouseButton1Click:Connect(onSelectActivated)
    end

    -- Teleport logic (copied/adapted)
    local TP_ANIM_ID = "17555632156"
    local function playTpAnim(character)
        if not character or not character.Parent then character = player.Character end
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local anim = Instance.new("Animation")
        anim.Name = "TP_Anim"
        anim.AnimationId = "rbxassetid://" .. TP_ANIM_ID

        local ok, track = pcall(function()
            local animator = humanoid:FindFirstChildOfClass("Animator")
            if animator then return animator:LoadAnimation(anim) else return humanoid:LoadAnimation(anim) end
        end)

        if ok and track then
            pcall(function() track.Priority = Enum.AnimationPriority.Action end)
            track:Play()
            delay(8, function()
                pcall(function() if track.IsPlaying then track:Stop() end anim:Destroy() end)
            end)
        else
            pcall(function() anim:Destroy() end)
        end
    end

    local function teleportToMouse()
        if not teleportEnabled or not selectedKey then return end
        local character = player.Character
        if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local mouse = player:GetMouse()
        local pos = mouse.Hit.Position

        local dx = hrp.Position.X - pos.X
        local dz = hrp.Position.Z - pos.Z
        if (dx*dx + dz*dz) ^ 0.5 > 250 then return end

        local yOffset = 4
        hrp.CFrame = CFrame.new(pos.X, pos.Y + yOffset, pos.Z)
        playTpAnim(character)
    end

    -- Input handler for performing teleport when toggle ON
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        -- NOTE: deliberately do NOT return on gameProcessed; this lets the teleport trigger even if another handler consumed the input.
        if listeningForKey then return end
        if not teleportEnabled then return end
        if not selectedKey then return end

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

        if inputName == selectedKey then
            teleportToMouse()
        end
    end)

    -- Keep toggle state in sync and ensure initial states
    task.delay(0.05, syncToggleFromBtn)
    if selectedKey then
        task.spawn(function() setSelectAppearance("selected", selectedKey) end)
    else
        task.spawn(function() setSelectAppearance("none") end)
    end
end

--=== TP KEY AIM =======================================================================================================--

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local mouse = LocalPlayer:GetMouse()
    
    -- core constants
    local MOUSE_RADIUS = 225
    local ROTATE_SPEED = 60
    local MAX_HORIZONTAL_DIST = 300
    
    -- core state
    local currentTarget = nil
    local currentGui = nil
    local aim1Ref, aim2Ref = nil, nil
    
    -- UI / feature state
    local teleportEnabled = false     -- controlled by TPKeyAimPCButton
    local selectedKey = nil           -- nil until player selects
    local listeningForKey = false
    local listenCancelToken = nil
    local animLocks = {}
    
    -- BG toggle for aim gui
    local aimGuiEnabled = true        -- BG button default ON per your spec
    
    -- global registry to avoid duplicate key usage
    _G.TPKeyBindings = _G.TPKeyBindings or {}
    local OWNER_ID = ("AimCore_%s"):format(tostring(math.random(1,999999)))
    
    -- helpers
    local function horizontalDistance(a, b)
    	local dx = a.X - b.X
    	local dz = a.Z - b.Z
    	return math.sqrt(dx*dx + dz*dz)
    end
    
    local TWEEN_COLOR_TIME = 0.25
    local TWEEN_TEXT_TIME  = 0.18
    local COLOR_RED   = Color3.fromRGB(255,0,0)
    local COLOR_YELLOW= Color3.fromRGB(255,200,0)
    local COLOR_GREEN = Color3.fromRGB(0,255,0)
    
    local function tweenGui(obj, props, time)
    	local info = TweenInfo.new(time or TWEEN_COLOR_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    	local tw = TweenService:Create(obj, info, props)
    	tw:Play()
    	return tw
    end
    
    local function tweenTextTransparency(btn, target, time)
    	local info = TweenInfo.new(time or TWEEN_TEXT_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    	local tw = TweenService:Create(btn, info, { TextTransparency = target })
    	tw:Play()
    	return tw
    end
    
    local function safeSetText(btn, newText)
    	if animLocks[btn] then animLocks[btn].cancel = true end
    	local lock = { cancel = false }
    	animLocks[btn] = lock
    
    	local twOut = tweenTextTransparency(btn, 1, TWEEN_TEXT_TIME)
    	twOut.Completed:Wait()
    	if lock.cancel then animLocks[btn] = nil return end
    
    	pcall(function() btn.Text = newText end)
    
    	local twIn = tweenTextTransparency(btn, 0, TWEEN_TEXT_TIME)
    	twIn.Completed:Wait()
    	if animLocks[btn] == lock then animLocks[btn] = nil end
    end
    
    local function findStroke(inst)
    	for _, c in ipairs(inst:GetDescendants()) do
    		if c:IsA("UIStroke") then return c end
    	end
    	return nil
    end
    
    -- update visibility: aim GUI should be visible ONLY when both BG ON and Toggle ON
    local function updateAimGuiVisibility()
    	local visible = aimGuiEnabled and teleportEnabled
    	if currentGui then
    		pcall(function() currentGui.Enabled = visible end)
    	end
    end
    
    -- create aim gui
    local function makeAimGui(parentPart)
    	local BillboardAimTPGui = Instance.new("BillboardGui")
    	BillboardAimTPGui.Name = "BillboardAimTPGui"
    	BillboardAimTPGui.Active = true
    	BillboardAimTPGui.ResetOnSpawn = false
    	BillboardAimTPGui.LightInfluence = 1
    	BillboardAimTPGui.AlwaysOnTop = true
    	BillboardAimTPGui.Size = UDim2.new(0,100,0,100)
    	BillboardAimTPGui.ClipsDescendants = true
    	BillboardAimTPGui.MaxDistance = math.huge
    	BillboardAimTPGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    	BillboardAimTPGui.Parent = parentPart
    	BillboardAimTPGui.Enabled = (aimGuiEnabled and teleportEnabled)
    
    	local Aim1 = Instance.new("ImageLabel")
    	Aim1.Name = "Aim1"
    	Aim1.Image = "rbxassetid://15963047755"
    	Aim1.ImageColor3 = Color3.new(1,0,0)
    	Aim1.BackgroundTransparency = 1
    	Aim1.BorderSizePixel = 0
    	Aim1.AnchorPoint = Vector2.new(0.5,0.5)
    	Aim1.Position = UDim2.new(0.5,0,0.5,0)
    	Aim1.ImageTransparency = 1
    	Aim1.Size = UDim2.new(1.5,0,1.5,0)
    	Aim1.Parent = BillboardAimTPGui
    
    	local Aim2 = Instance.new("ImageLabel")
    	Aim2.Name = "Aim2"
    	Aim2.Image = "rbxassetid://17408339324"
    	Aim2.BackgroundTransparency = 1
    	Aim2.BorderSizePixel = 0
    	Aim2.AnchorPoint = Vector2.new(0.5,0.5)
    	Aim2.Position = UDim2.new(0.5,0,0.5,0)
    	Aim2.ImageTransparency = 1
    	Aim2.Size = UDim2.new(1.5,0,1.5,0)
    	Aim2.Rotation = 45
    	Aim2.Parent = BillboardAimTPGui
    
    	local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    	TweenService:Create(Aim1, tweenInfo, { ImageTransparency = 0, Size = UDim2.new(1,0,1,0) }):Play()
    	TweenService:Create(Aim2, tweenInfo, { ImageTransparency = 0.25, Size = UDim2.new(1,0,1,0) }):Play()
    
    	aim1Ref = Aim1
    	aim2Ref = Aim2
    
    	return BillboardAimTPGui
    end
    
    -- find nearest player to mouse
    local function getNearestPlayerToMouse()
    	local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    	if not localHRP then return nil end
    
    	local bestPlayer = nil
    	local bestDist = math.huge
    
    	for _, pl in ipairs(Players:GetPlayers()) do
    		if pl ~= LocalPlayer then
    			local char = pl.Character
    			local hrp = char and char:FindFirstChild("HumanoidRootPart")
    			if hrp then
    				local horiz = horizontalDistance(localHRP.Position, hrp.Position)
    				if horiz <= MAX_HORIZONTAL_DIST then
    					local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
    					if onScreen then
    						local dx = mouse.X - screenPos.X
    						local dy = mouse.Y - screenPos.Y
    						local dist = math.sqrt(dx*dx + dy*dy)
    						if dist <= MOUSE_RADIUS and dist < bestDist then
    							bestDist = dist
    							bestPlayer = pl
    						end
    					end
    				end
    			end
    		end
    	end
    
    	return bestPlayer
    end
    
    -- clear target
    local function clearCurrent()
    	if currentGui then
    		currentGui:Destroy()
    	end
    	currentGui = nil
    	currentTarget = nil
    	aim1Ref = nil
    	aim2Ref = nil
    end
    
    -- ===== teleport core (immediate camera set, no tween) =====
    local function teleportToTarget()
    	if not currentTarget then return end
    
    	local myChar = LocalPlayer.Character
    	local targetChar = currentTarget.Character
    	if not myChar or not targetChar then return end
    
    	local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    	local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    	if not myHRP or not targetHRP then return end
    
    	-- teleport behind & face the target
    	local behindOffset = targetHRP.CFrame.LookVector * -7
    	local tpPos = targetHRP.Position + behindOffset
    	myHRP.CFrame = CFrame.new(tpPos, targetHRP.Position)
    
    	-- ensure the character CFrame applied before moving camera
    	RunService.RenderStepped:Wait()
    
    	-- camera: place directly behind the player and look at the target (no tween)
    	local cameraOffset = myHRP.CFrame.LookVector * -8 + Vector3.new(0, 3, 0)
    	local camPos = myHRP.Position + cameraOffset
    	local camGoal = CFrame.new(camPos, targetHRP.Position)
    
    	-- set camera immediately
    	Camera.CFrame = camGoal
    end

    -- main loop
    RunService.RenderStepped:Connect(function(dt)
    	if aim1Ref and aim2Ref then
    		aim1Ref.Rotation += ROTATE_SPEED * dt
    		aim2Ref.Rotation -= ROTATE_SPEED * dt
    	end
    
    	local nearest = getNearestPlayerToMouse()
    	if nearest ~= currentTarget then
    		clearCurrent()
    		if nearest then
    			local hrp = nearest.Character and nearest.Character:FindFirstChild("HumanoidRootPart")
    			if hrp then
    				currentTarget = nearest
    				currentGui = makeAimGui(hrp)
    			end
    		end
    	end
    
    	if currentTarget and currentTarget.Character then
    		local hrp = currentTarget.Character:FindFirstChild("HumanoidRootPart")
    		local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    		if not hrp or not localHRP then clearCurrent() return end
    
    		local horiz = horizontalDistance(localHRP.Position, hrp.Position)
    		if horiz > MAX_HORIZONTAL_DIST then clearCurrent() return end
    
    		local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
    		if not onScreen then clearCurrent() return end
    		local dx = mouse.X - screenPos.X
    		local dy = mouse.Y - screenPos.Y
    		local dist = math.sqrt(dx*dx + dy*dy)
    		if dist > MOUSE_RADIUS then clearCurrent() end
    
    		if currentGui and hrp and currentGui.Parent ~= hrp then
    			currentGui.Parent = hrp
    			currentGui.Enabled = (aimGuiEnabled and teleportEnabled)
    		end
    	end
    end)
    
    Players.PlayerRemoving:Connect(function(pl)
    	if pl == currentTarget then clearCurrent() end
    end)
    
    -- UI binding
    task.spawn(function()
    	repeat task.wait() until LocalPlayer:FindFirstChild("PlayerGui")
    	repeat task.wait() until _G.ToggleUI or true
    	local ToggleUI = _G.ToggleUI
    
    	local ok, ScrollingTab = pcall(function()
    		return LocalPlayer.PlayerGui:WaitForChild("BloxFruitHubGui"):WaitForChild("Main"):WaitForChild("ScrollingTab")
    	end)
    	if not ok or not ScrollingTab then
    		warn("TP Aim UI: unable to find ScrollingTab - skipping UI binding")
    		return
    	end
    
    	local combatFrame = ScrollingTab:FindFirstChild("Combat", true) or ScrollingTab:FindFirstChild("Combat")
    	if not combatFrame then warn("TP Aim UI: Combat frame not found") return end
    
    	local TOGGLE_NAME = "TPKeyAimPCButton"
    	local SELECT_NAME = "SelectTPKeyAimPCButton"
    	local BG_NAME = "BGTPKeyAimButton"
    
    	local toggleBtn = combatFrame:FindFirstChild(TOGGLE_NAME, true)
    	local selectBtn = combatFrame:FindFirstChild(SELECT_NAME, true)
    	local bgBtn = combatFrame:FindFirstChild(BG_NAME, true)
    
    	if not toggleBtn then warn("TP Aim UI: toggleBtn not found") end
    	if not selectBtn then warn("TP Aim UI: selectBtn not found") end
    	if not bgBtn then warn("TP Aim UI: bgBtn not found") end
    
    	local selectStroke = selectBtn and findStroke(selectBtn)
    	local bgStroke = bgBtn and findStroke(bgBtn)
    
    	-- select appearance helper
    	local function setSelectAppearance(state, keyName)
    		if not selectBtn then return end
    		if state == "none" then
    			tweenGui(selectBtn, { BackgroundColor3 = COLOR_RED }, TWEEN_COLOR_TIME)
    			if selectStroke then tweenGui(selectStroke, { Color = COLOR_RED }, TWEEN_COLOR_TIME) end
    			safeSetText(selectBtn, "None")
    		elseif state == "waiting" then
    			tweenGui(selectBtn, { BackgroundColor3 = COLOR_YELLOW }, TWEEN_COLOR_TIME)
    			if selectStroke then tweenGui(selectStroke, { Color = COLOR_YELLOW }, TWEEN_COLOR_TIME) end
    			safeSetText(selectBtn, "Waiting...")
    		elseif state == "selected" then
    			tweenGui(selectBtn, { BackgroundColor3 = COLOR_GREEN }, TWEEN_COLOR_TIME)
    			if selectStroke then tweenGui(selectStroke, { Color = COLOR_GREEN }, TWEEN_COLOR_TIME) end
    			safeSetText(selectBtn, tostring(keyName or "None"))
    		end
    	end
    
    	-- BG appearance with tweened text and color
    	local function setBGAppearance(on)
    		if not bgBtn then return end
    		local out = tweenTextTransparency(bgBtn, 1, TWEEN_TEXT_TIME)
    		out.Completed:Wait()
    		bgBtn.Text = on and "Aim gui: ON" or "Aim gui: OFF"
    		local toColor = on and COLOR_GREEN or COLOR_RED
    		tweenGui(bgBtn, { BackgroundColor3 = toColor }, TWEEN_COLOR_TIME)
    		if bgStroke then tweenGui(bgStroke, { Color = toColor }, TWEEN_COLOR_TIME) end
    		local inn = tweenTextTransparency(bgBtn, 0, TWEEN_TEXT_TIME)
    		inn.Completed:Wait()
    	end
    
    	-- init select button (none)
    	if selectBtn then
    		pcall(function()
    			selectBtn.BackgroundColor3 = COLOR_RED
    			if selectStroke then selectStroke.Color = COLOR_RED end
    			selectBtn.Text = "None"
    		end)
    	end
    
    	-- init BG button default ON
    	if bgBtn then
    		pcall(function()
    			bgBtn.BackgroundColor3 = COLOR_GREEN
    			if bgStroke then bgStroke.Color = COLOR_GREEN end
    			bgBtn.Text = "Aim gui: ON"
    		end)
    		aimGuiEnabled = true
    	end
    
    	-- ToggleUI setup
    	if toggleBtn and ToggleUI and ToggleUI.Set then
    		pcall(function() ToggleUI.Set(TOGGLE_NAME, false) end)
    	end
    
    	local function inferToggleOn(btn)
    		local bg
    		pcall(function() bg = btn.BackgroundColor3 end)
    		if not bg then return false end
    		return bg.G and bg.G > bg.R and bg.G > bg.B and bg.G > 0.5
    	end
    
    	local function syncToggleFromBtn()
    		if not toggleBtn then return end
    		local on = inferToggleOn(toggleBtn)
    		if teleportEnabled == on then return end
    		teleportEnabled = on
    		-- whenever teleportEnabled changes, update aim GUI visibility
    		updateAimGuiVisibility()
    	end
    
    	if toggleBtn then
    		toggleBtn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
    			task.delay(0.05, syncToggleFromBtn)
    		end)
    
    		local function requestToggle()
    			local cur = inferToggleOn(toggleBtn)
    			if ToggleUI and ToggleUI.Set then
    				pcall(function() ToggleUI.Set(TOGGLE_NAME, not cur) end)
    			else
    				local target = not cur
    				local targetColor = target and COLOR_GREEN or COLOR_RED
    				tweenGui(toggleBtn, { BackgroundColor3 = targetColor }, TWEEN_COLOR_TIME)
    				-- also update internal state after small delay
    				task.delay(0.06, syncToggleFromBtn)
    			end
    		end
    
    		if toggleBtn.Activated then
    			toggleBtn.Activated:Connect(requestToggle)
    		else
    			toggleBtn.MouseButton1Click:Connect(requestToggle)
    		end
    	end
    
    	-- Select key logic
    	local WAIT_TIMEOUT = 5
    	local function startListening()
    		if listeningForKey then return end
    		listeningForKey = true
    		local token = {}
    		listenCancelToken = token
    
    		task.spawn(function()
    			if listenCancelToken == token then
    				setSelectAppearance("waiting")
    			end
    		end)
    
    		local conn
    		conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    			if listenCancelToken ~= token or not listeningForKey then return end
    
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
    				-- check registry
    				local taken = false
    				for owner, k in pairs(_G.TPKeyBindings) do
    					if owner ~= OWNER_ID and k == inputName then
    						taken = true
    						break
    					end
    				end
    
    				-- finish listening
    				listeningForKey = false
    				if conn then conn:Disconnect(); conn = nil end
    				listenCancelToken = nil
    
    				if taken then
    					task.spawn(function()
    						safeSetText(selectBtn, "Taken")
    						wait(0.7)
    						setSelectAppearance(selectedKey and "selected" or "none", selectedKey)
    					end)
    					return
    				end
    
    				-- set selection and register
    				selectedKey = inputName
    				_G.TPKeyBindings[OWNER_ID] = selectedKey
    
    				task.spawn(function() setSelectAppearance("selected", selectedKey) end)
    			end
    		end)
    
    		token.conn = conn
    
    		task.delay(WAIT_TIMEOUT, function()
    			if listenCancelToken == token and listeningForKey then
    				listeningForKey = false
    				if token.conn then pcall(function() token.conn:Disconnect() end); token.conn = nil end
    				listenCancelToken = nil
    				_G.TPKeyBindings[OWNER_ID] = nil
    				selectedKey = nil
    				task.spawn(function() setSelectAppearance("none") end)
    			end
    		end)
    	end
    
    	local function stopListeningCancel()
    		if listeningForKey then
    			listeningForKey = false
    			if listenCancelToken and listenCancelToken.conn then
    				pcall(function() listenCancelToken.conn:Disconnect() end)
    				listenCancelToken.conn = nil
    			end
    			listenCancelToken = nil
    			_G.TPKeyBindings[OWNER_ID] = nil
    			task.spawn(function() setSelectAppearance("none") end)
    		end
    	end
    
    	local function onSelectActivated()
    		if not selectBtn then return end
    		if listeningForKey then
    			stopListeningCancel()
    			return
    		end
    		startListening()
    	end
    
    	if selectBtn then
    		if selectBtn.Activated then
    			selectBtn.Activated:Connect(onSelectActivated)
    		else
    			selectBtn.MouseButton1Click:Connect(onSelectActivated)
    		end
    	end
    
    	-- init select appearance
    	if selectBtn then
    		if selectedKey then
    			task.spawn(function() setSelectAppearance("selected", selectedKey) end)
    		else
    			task.spawn(function() setSelectAppearance("none") end)
    		end
    	end
    
    	-- BG button handling
    	if bgBtn then
    		local function toggleBg()
    			aimGuiEnabled = not aimGuiEnabled
    			-- update any current GUI
    			updateAimGuiVisibility()
    			setBGAppearance(aimGuiEnabled)
    		end
    
    		local function onBgActivated()
    			toggleBg()
    		end
    
    		if bgBtn.Activated then
    			bgBtn.Activated:Connect(onBgActivated)
    		else
    			bgBtn.MouseButton1Click:Connect(onBgActivated)
    		end
    	end
    
    	-- Input handler to perform teleport when toggle ON (do NOT return on gameProcessed)
    	UserInputService.InputBegan:Connect(function(input, gameProcessed)
    		if listeningForKey then return end
    		if not teleportEnabled then return end
    		if not selectedKey then return end
    
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
    
    		if inputName == selectedKey then
    			-- run teleport logic if target exists & within horizontal limit
    			if not currentTarget then return end
    			local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    			local hrp = currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart")
    			if not localHRP or not hrp then return end
    			local dx = localHRP.Position.X - hrp.Position.X
    			local dz = localHRP.Position.Z - hrp.Position.Z
    			if (dx*dx + dz*dz) ^ 0.5 > 300 then return end
    
    			teleportToTarget()
    		end
    	end)
    
    	-- initial sync of toggle state
    	task.delay(0.05, syncToggleFromBtn)
    end)
end

--=== SILENT AIM =========================================================================================--

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local workspace = game:GetService("Workspace")

    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then return end

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

    local Notification = combatFrame:FindFirstChild("NotificationBlackTitle", true)
        or combatFrame:FindFirstChild("NotificationBlackTitle")
    local function setNotificationVisible(state)
        if Notification and typeof(Notification) == "Instance" then
            pcall(function() Notification.Visible = state end)
        end
    end

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

    local SilentAimButton = combatFrame:FindFirstChild("SilentAimButton", true) or combatFrame:FindFirstChild("SilentAimButton")
    local ModeButton = combatFrame:FindFirstChild("360ModeButton", true) or combatFrame:FindFirstChild("360ModeButton")
    local RadiusBox = combatFrame:FindFirstChild("SilentAimBox", true) or combatFrame:FindFirstChild("SilentAimBox")
    local ModeTitle = combatFrame:FindFirstChild("SilentAimModeTitle", true) or combatFrame:FindFirstChild("SilentAimModeTitle")

    if not (SilentAimButton and ModeButton and RadiusBox and ModeTitle) then
        warn("Thiếu UI: SilentAimButton/360ModeButton/SilentAimBox/SilentAimModeTitle required")
        return
    end

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
            local targetPos = (mode == "Limit") and UDim2.new(0.275,0,0.5,0) or UDim2.new(0.375,0,0.5,0)
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

    local Camera = workspace.CurrentCamera
    local CACHE_INTERVAL = 0.05
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

    local Mouse
    local okMouse, resMouse = pcall(function() return LocalPlayer:GetMouse() end)
    if okMouse then Mouse = resMouse end
    if not Mouse then
        warn("[SilentAim] Không lấy được Mouse -> dừng.")
        setNotificationVisible(true)
        if cacheConn then cacheConn:Disconnect() end
        return
    end

    -- ===== Mobile touch support =====
    local touching = false
    local touchPos = Vector2.new(0,0)
    local activeTouchId = nil

    UserInputService.TouchStarted:Connect(function(input, processed)
        if processed then return end
        touching = true
        activeTouchId = input.UserInputState and input.UserInputState or (input and input.UserInputType and input.UserInputType)
        -- use input.Position
        if input and input.Position then
            touchPos = Vector2.new(input.Position.X, input.Position.Y)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input and input.UserInputType == Enum.UserInputType.Touch then
            if activeTouchId == nil or input.UserInputState == nil or true then
                -- track last touch regardless; some phones don't provide consistent IDs
                touchPos = Vector2.new(input.Position.X, input.Position.Y)
            end
        end
    end)

    UserInputService.TouchEnded:Connect(function(input, processed)
        if processed then return end
        touching = false
        activeTouchId = nil
    end)

    -- helper: lấy điểm xuất phát (ưu tiên HRP, fallback Camera)
    local function getLocalOrigin()
        local ok, pos = pcall(function()
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp and hrp.Position then return hrp.Position end
            end
            if Camera and Camera.CFrame then return Camera.CFrame.Position end
            return nil
        end)
        return ok and pos
    end

    local oldIndex
    local okHook, hookErr = pcall(function()
        oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
            if not checkcaller() and silentEnabled and self == Mouse then
                local target = nil
                if _G and _G.SilentAimMode == "Static" and _G._SilentAimTarget then
                    target = _G._SilentAimTarget
                else
                    local char = cachedTarget
                    if char then
                        target = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                    end
                end

                -- If user is touching but we still have no target, we will fallback to touch-based hit
                if target then
                    -- If Hit requested -> extended CFrame through target
                    if key == "Hit" then
                        local targetPos = nil
                        if typeof(target) == "Vector3" then
                            targetPos = target
                        elseif typeof(target) == "Instance" then
                            if target:IsA("BasePart") then
                                targetPos = target.Position
                            elseif target:IsA("Model") and target.PrimaryPart then
                                targetPos = target.PrimaryPart.Position
                            elseif target.Position then
                                targetPos = target.Position
                            elseif target.CFrame then
                                targetPos = target.CFrame.Position
                            end
                        end

                        if targetPos then
                            local origin = getLocalOrigin() or (Camera and Camera.CFrame and Camera.CFrame.Position) or Vector3.new(0,0,0)
                            local dir = targetPos - origin
                            local dirMag = dir.Magnitude
                            local finalDir
                            if dirMag > 0.0001 then
                                finalDir = dir.Unit
                            else
                                finalDir = (Camera and Camera.CFrame and Camera.CFrame.LookVector) or Vector3.new(0,0,-1)
                            end
                            local extendedPoint = origin + finalDir * (dirMag + 100)
                            return CFrame.new(extendedPoint)
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
                else
                    -- no cached target; if user is touching, provide touch-based Hit/X/Y
                    if touching then
                        if key == "Hit" then
                            -- build world ray from screen touch and return a distant point as CFrame
                            if Camera and touchPos then
                                local ok, ray = pcall(function() return Camera:ScreenPointToRay(touchPos.X, touchPos.Y) end)
                                if ok and ray then
                                    local origin = ray.Origin
                                    local dir = ray.Direction.Unit
                                    local farPoint = origin + dir * 1000
                                    return CFrame.new(farPoint)
                                end
                            end
                        elseif key == "X" then
                            return touchPos.X
                        elseif key == "Y" then
                            return touchPos.Y
                        elseif key == "Target" then
                            -- no instance target to return
                            return nil
                        end
                    end
                end
            end

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
