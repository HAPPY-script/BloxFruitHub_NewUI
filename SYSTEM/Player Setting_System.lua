--=== SPEED =======================================================================================================--

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    local player = Players.LocalPlayer

    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)

    local ScrollingTab = player.PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    local playerSetting = ScrollingTab:FindFirstChild("Player Setting", true)
        or ScrollingTab:FindFirstChild("Player Setting")

    if not playerSetting then
        warn("Không tìm thấy Frame 'Player Setting'")
        return
    end

    local BUTTON_NAME = "SpeedButton"
    local BOX_NAME    = "SpeedBox"

    local speedBtn = playerSetting:FindFirstChild(BUTTON_NAME, true)
    local speedBox = playerSetting:FindFirstChild(BOX_NAME, true)

    if not speedBtn then warn("Không tìm thấy SpeedButton") return end
    if not speedBox then warn("Không tìm thấy SpeedBox") return end

    -- ===== DEFAULT =====
    local DEFAULT_SPEED = 3
    local MIN_SPEED = 0.1
    local MAX_SPEED = 10

    speedBox.Text = tostring(DEFAULT_SPEED)

    -- ensure ToggleUI initial
    pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)

    -- internal state
    local isActive = false
    local speedValue = DEFAULT_SPEED
    local distancePerTeleport = 1.5

    -- ===== helper: detect toggle state via color =====
    local function inferToggleOn(btn)
        local bg
        pcall(function() bg = btn.BackgroundColor3 end)
        return bg and bg.G > bg.R and bg.G > bg.B
    end

    local function syncFromButtonColor()
        isActive = inferToggleOn(speedBtn)
    end

    speedBtn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        task.delay(0.05, syncFromButtonColor)
    end)

    -- Toggle button
    local function onButtonActivated()
        local cur = inferToggleOn(speedBtn)
        pcall(function()
            ToggleUI.Set(BUTTON_NAME, not cur)
        end)
    end

    if speedBtn.Activated then
        speedBtn.Activated:Connect(onButtonActivated)
    else
        speedBtn.MouseButton1Click:Connect(onButtonActivated)
    end

    -- ===== SpeedBox validate (FIX CHÍNH Ở ĐÂY) =====
    speedBox.FocusLost:Connect(function()
        local n = tonumber(speedBox.Text)

        if not n then
            n = DEFAULT_SPEED
        end

        if n > MAX_SPEED then
            n = MAX_SPEED
        elseif n <= 0 then
            n = MIN_SPEED
        end

        speedValue = n
        speedBox.Text = tostring(n)
    end)

    -- ===== Teleport logic =====
    local function TeleportStep(character, hrp)
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        local dir = humanoid.MoveDirection
        if dir.Magnitude > 0 then
            local newPos = hrp.Position + (dir.Unit * distancePerTeleport)
            hrp.CFrame = CFrame.new(newPos, newPos + dir)
        end
    end

    RunService.RenderStepped:Connect(function()
        if not isActive then return end

        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local steps = math.max(1, math.floor(speedValue))
        for _ = 1, steps do
            pcall(TeleportStep, char, hrp)
        end
    end)

    -- ===== Reset on respawn =====
    local function onCharacterAdded(char)
        isActive = false
        pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)

        local humanoid = char:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid.Died:Connect(function()
                isActive = false
                pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)
            end)
        end
    end

    if player.Character then
        onCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)

    task.delay(0.05, syncFromButtonColor)
end

--=== NO CLIP =======================================================================================================--

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    local player = Players.LocalPlayer

    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)

    local ScrollingTab = player.PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    local BUTTON_NAME = "NoClipButton"

    local noclipButton = ScrollingTab:FindFirstChild(BUTTON_NAME, true)
    if not noclipButton then
        warn("Không tìm thấy NoClipButton")
        return
    end

    -- ensure initial OFF
    pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)

    -- internal state
    local noclipEnabled = false
    local stepConnection

    -- ===== helpers =====
    local function inferToggleOn(btn)
        local bg
        pcall(function() bg = btn.BackgroundColor3 end)
        return bg and bg.G > bg.R and bg.G > bg.B
    end

    local function applyNoclip(character, state)
        if not character then return end
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state
            end
        end
    end

    local function startNoclip()
        if stepConnection then stepConnection:Disconnect() end
        stepConnection = RunService.Stepped:Connect(function()
            if not noclipEnabled then return end
            local char = player.Character
            if char then
                applyNoclip(char, true)
            end
        end)
    end

    local function stopNoclip()
        if stepConnection then
            stepConnection:Disconnect()
            stepConnection = nil
        end
        local char = player.Character
        if char then
            applyNoclip(char, false)
        end
    end

    -- ===== sync from ToggleUI (qua màu button) =====
    local function syncFromButton()
        local on = inferToggleOn(noclipButton)
        if on == noclipEnabled then return end

        noclipEnabled = on
        if noclipEnabled then
            startNoclip()
        else
            stopNoclip()
        end
    end

    noclipButton:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        task.delay(0.05, syncFromButton)
    end)

    -- ===== button click: request ToggleUI change =====
    local function onButtonActivated()
        local cur = inferToggleOn(noclipButton)
        pcall(function()
            ToggleUI.Set(BUTTON_NAME, not cur)
        end)
    end

    if noclipButton.Activated then
        noclipButton.Activated:Connect(onButtonActivated)
    else
        noclipButton.MouseButton1Click:Connect(onButtonActivated)
    end

    -- ===== reset on respawn / death =====
    local function onCharacterAdded(char)
        noclipEnabled = false
        stopNoclip()
        pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)

        local humanoid = char:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid.Died:Connect(function()
                noclipEnabled = false
                stopNoclip()
                pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)
            end)
        end
    end

    if player.Character then
        onCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)

    -- initial sync
    task.delay(0.05, syncFromButton)
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

    -- tìm ScrollingTab -> Raid
    local ScrollingTab = player.PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    local raidFrame = ScrollingTab:FindFirstChild("Raid", true) or ScrollingTab:FindFirstChild("Raid")
    if not raidFrame then
        warn("Không tìm thấy Frame 'Raid' trong ScrollingTab")
        return
    end

    -- controls tên chuẩn
    local TOGGLE_NAME = "TPKeyPCButton"
    local SELECT_NAME = "SelectTPKeyPCButton"

    local toggleBtn = raidFrame:FindFirstChild(TOGGLE_NAME, true)
    local selectBtn = raidFrame:FindFirstChild(SELECT_NAME, true)

    if not toggleBtn then warn("Không tìm thấy TPKeyPCButton") return end
    if not selectBtn then warn("Không tìm thấy SelectTPKeyPCButton") return end

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
        -- cancel if another animation on this btn flagged cancelled? we'll use lock object
        if animLocks[btn] then
            -- mark cancel; the running animation should check this (we will implement by returning early if lock changed)
            animLocks[btn].cancel = true
        end
        local lock = { cancel = false }
        animLocks[btn] = lock

        -- fade out
        local twOut = tweenTextTransparency(btn, 1, TWEEN_TEXT_TIME)
        twOut.Completed:Wait()
        if lock.cancel then
            animLocks[btn] = nil
            return
        end

        -- set text
        pcall(function() btn.Text = newText end)

        -- fade in
        local twIn = tweenTextTransparency(btn, 0, TWEEN_TEXT_TIME)
        twIn.Completed:Wait()
        -- final cleanup
        if animLocks[btn] == lock then animLocks[btn] = nil end
    end

    -- Set select button appearance for states: "none", "waiting", "selected"
    local function setSelectAppearance(state, keyName)
        -- state: "none" | "waiting" | "selected"
        if state == "none" then
            -- color -> red, text -> "None"
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

    -- initial select button default: red + "None"
    pcall(function()
        selectBtn.BackgroundColor3 = COLOR_RED
        if selectStroke then selectStroke.Color = COLOR_RED end
        selectBtn.Text = selectedKey and tostring(selectedKey) or "None"
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

    -- Listening logic
    local function stopListening(cancelled)
        listeningForKey = false
        listenCancelToken = nil
        if cancelled then
            -- revert to None
            selectedKey = nil
            setSelectAppearance("none")
        else
            if selectedKey then
                setSelectAppearance("selected", selectedKey)
            else
                setSelectAppearance("none")
            end
        end
    end

    local function startListening()
        if listeningForKey then return end
        listeningForKey = true
        -- show waiting visuals
        setSelectAppearance("waiting")

        -- create cancel token
        local token = {}
        listenCancelToken = token

        -- connect temporary InputBegan to catch one key
        local conn
        conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if not listeningForKey then return end
            -- determine name
            local inputName = nil
            if input.UserInputType == Enum.UserInputType.Keyboard then
                inputName = input.KeyCode.Name
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                inputName = "MouseButton1"
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                inputName = "MouseButton2"
            elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
                inputName = "MouseButton3"
            end

            if inputName then
                -- store and finish listening
                selectedKey = inputName
                -- apply selected visuals (green + text)
                setSelectAppearance("selected", selectedKey)
                listeningForKey = false
                -- cancel timeout by clearing token
                listenCancelToken = nil
                -- disconnect
                if conn then conn:Disconnect() end
            end
        end)

        -- timeout after WAIT_TIMEOUT seconds
        task.delay(WAIT_TIMEOUT, function()
            -- if token still valid and listening -> time out
            if listenCancelToken == token and listeningForKey then
                -- stop listening and revert to None
                listeningForKey = false
                listenCancelToken = nil
                if conn then conn:Disconnect() end
                selectedKey = nil
                setSelectAppearance("none")
            end
        end)
    end

    -- clicking selectBtn toggles listening: if already listening -> cancel and revert None; else start
    local function onSelectActivated()
        if listeningForKey then
            -- cancel
            listeningForKey = false
            listenCancelToken = nil
            setSelectAppearance("none")
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

        -- distance limit XZ
        local dx = hrp.Position.X - pos.X
        local dz = hrp.Position.Z - pos.Z
        if (dx*dx + dz*dz) ^ 0.5 > 250 then return end

        local yOffset = 4
        hrp.CFrame = CFrame.new(pos.X, pos.Y + yOffset, pos.Z)
        playTpAnim(character)
    end

    -- Input handler for performing teleport when toggle ON
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if listeningForKey then
            -- selection handler will consume this (startListening installed its own InputBegan)
            return
        end
        if not teleportEnabled then return end
        if not selectedKey then return end

        local inputName = nil
        if input.UserInputType == Enum.UserInputType.Keyboard then
            inputName = input.KeyCode.Name
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
    -- ensure selectBtn text shows selectedKey if exists
    if selectedKey then
        setSelectAppearance("selected", selectedKey)
    else
        setSelectAppearance("none")
    end

    -- ensure toggle off on respawn for safety (also keep selectedKey)
    local function onCharacterAdded(char)
        -- ask ToggleUI to set off to avoid drift
        pcall(function() ToggleUI.Set(TOGGLE_NAME, false) end)
    end
    if player.Character then onCharacterAdded(player.Character) end
    player.CharacterAdded:Connect(onCharacterAdded)
end

--=== IFN JUMP =======================================================================================================--

do
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")

    local player = Players.LocalPlayer

    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)

    local ScrollingTab = player.PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    local BUTTON_NAME = "IFNJumpButton"

    local jumpButton = ScrollingTab:FindFirstChild(BUTTON_NAME, true)
    if not jumpButton then
        warn("Không tìm thấy IFNJumpButton")
        return
    end

    -- ensure initial OFF
    pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)

    -- internal state
    local infiniteJumpEnabled = false

    -- ===== helper: detect toggle via color =====
    local function inferToggleOn(btn)
        local bg
        pcall(function() bg = btn.BackgroundColor3 end)
        return bg and bg.G > bg.R and bg.G > bg.B
    end

    local function syncFromButton()
        infiniteJumpEnabled = inferToggleOn(jumpButton)
    end

    jumpButton:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        task.delay(0.05, syncFromButton)
    end)

    -- ===== button click → request ToggleUI =====
    local function onButtonActivated()
        local cur = inferToggleOn(jumpButton)
        pcall(function()
            ToggleUI.Set(BUTTON_NAME, not cur)
        end)
    end

    if jumpButton.Activated then
        jumpButton.Activated:Connect(onButtonActivated)
    else
        jumpButton.MouseButton1Click:Connect(onButtonActivated)
    end

    -- ===== Infinite Jump logic =====
    UserInputService.JumpRequest:Connect(function()
        if not infiniteJumpEnabled then return end

        local char = player.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    -- ===== reset on respawn =====
    local function onCharacterAdded()
        infiniteJumpEnabled = false
        pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)
    end

    if player.Character then
        onCharacterAdded()
    end
    player.CharacterAdded:Connect(onCharacterAdded)

    -- initial sync
    task.delay(0.05, syncFromButton)
end
