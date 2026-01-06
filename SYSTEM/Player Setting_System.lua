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

    -- khai báo ScrollingTab (theo mẫu chuẩn)
    local ScrollingTab = player.PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    -- tìm Frame "Player Setting" trong ScrollingTab (đệ quy)
    local playerSetting = ScrollingTab:FindFirstChild("Player Setting", true) or ScrollingTab:FindFirstChild("Player Setting")
    if not playerSetting then
        warn("Không tìm thấy Frame 'Player Setting' trong ScrollingTab")
        return
    end

    -- controls tên chuẩn trong Player Setting
    local TOGGLE_NAME = "TPKeyPCButton"
    local SELECT_NAME = "SelectTPKeyPCButton"

    local toggleBtn = playerSetting:FindFirstChild(TOGGLE_NAME, true)
    local selectBtn = playerSetting:FindFirstChild(SELECT_NAME, true)

    if not toggleBtn then warn("Không tìm thấy TPKeyPCButton trong Player Setting") return end
    if not selectBtn then warn("Không tìm thấy SelectTPKeyPCButton trong Player Setting") return end

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

    -- Listening logic (CHANGED: during listening we DO NOT ignore gameProcessed so keys already handled elsewhere are still captured)
    local function startListening()
        if listeningForKey then return end
        listeningForKey = true
        setSelectAppearance("waiting")

        local token = {}
        listenCancelToken = token

        local conn
        conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            -- deliberately do NOT bail out on gameProcessed here; allows capturing keys that other scripts/games processed
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
                selectedKey = inputName
                setSelectAppearance("selected", selectedKey)
                listeningForKey = false
                listenCancelToken = nil
                if conn then conn:Disconnect() end
            end
        end)

        task.delay(WAIT_TIMEOUT, function()
            if listenCancelToken == token and listeningForKey then
                listeningForKey = false
                listenCancelToken = nil
                if conn then conn:Disconnect() end
                selectedKey = nil
                setSelectAppearance("none")
            end
        end)
    end

    local function stopListeningCancel()
        if listeningForKey then
            listeningForKey = false
            listenCancelToken = nil
            setSelectAppearance("none")
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
        setSelectAppearance("selected", selectedKey)
    else
        setSelectAppearance("none")
    end
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

    -- initial sync
    task.delay(0.05, syncFromButton)
end

--=== AUTO BUSO =======================================================================================================--

do
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")

    local player = Players.LocalPlayer
    local CHECK_INTERVAL = 3

    -- chờ ToggleUI helper
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)

    -- đường dẫn ScrollingTab chuẩn
    local ScrollingTab = game.Players.LocalPlayer
        .PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    -- tìm Frame "Player Setting" (đệ quy)
    local playerSetting = ScrollingTab:FindFirstChild("Player Setting", true) or ScrollingTab:FindFirstChild("Player Setting")
    if not playerSetting then
        warn("Không tìm thấy Frame 'Player Setting' trong ScrollingTab")
        return
    end

    local BUTTON_NAME = "AutoBusoButton"
    local button = playerSetting:FindFirstChild(BUTTON_NAME, true)
    if not button then
        warn("Không tìm thấy AutoBusoButton trong Player Setting")
        return
    end

    -- internal state (đồng bộ với Attribute "AutoBuso")
    local DEFAULT_AUTOBUSO = true
    local autoBuso = DEFAULT_AUTOBUSO

    -- suppress flags to avoid UI <-> Attribute loops
    local suppressAttrToUI = false
    local suppressUIToAttr = false

    -- helpers (original logic)
    local function getCharacterModel()
        local chars = Workspace:FindFirstChild("Characters")
        return chars and chars:FindFirstChild(player.Name)
    end

    local function isBusoOn()
        local char = getCharacterModel()
        return char and char:FindFirstChild("HasBuso") ~= nil
    end

    local function turnOnBuso()
        pcall(function()
            if ReplicatedStorage and ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_") then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
            end
        end)
    end

    -- init Attribute from existing attribute or default
    do
        local attr = player:GetAttribute("AutoBuso")
        if attr ~= nil then
            autoBuso = (attr == true)
        else
            player:SetAttribute("AutoBuso", autoBuso)
        end

        -- push to ToggleUI (suppress UI->attr while doing this)
        suppressUIToAttr = true
        pcall(function() ToggleUI.Set(BUTTON_NAME, autoBuso) end)
        task.delay(0.05, function() suppressUIToAttr = false end)
    end

    -- Sync UI->Attribute when ToggleUI updates button visuals (observe BackgroundColor3)
    local function inferToggleOn(btn)
        local bg
        pcall(function() bg = btn.BackgroundColor3 end)
        if not bg then return false end
        return bg.G and bg.G > bg.R and bg.G > bg.B and bg.G > 0.5
    end

    button:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        -- small delay to let ToggleUI finish its own tween
        task.delay(0.05, function()
            if suppressUIToAttr then return end
            local isOn = inferToggleOn(button)
            local currentAttr = player:GetAttribute("AutoBuso") == true
            if currentAttr ~= isOn then
                suppressAttrToUI = true
                player:SetAttribute("AutoBuso", isOn)
                task.delay(0.05, function() suppressAttrToUI = false end)
            end
        end)
    end)

    -- When player clicks the UI button -> request ToggleUI.Set(...)
    local function onButtonActivated()
        local cur = inferToggleOn(button)
        pcall(function() ToggleUI.Set(BUTTON_NAME, not cur) end)
    end
    if button.Activated then
        button.Activated:Connect(onButtonActivated)
    else
        button.MouseButton1Click:Connect(onButtonActivated)
    end

    -- Attribute listener: when attribute changes -> update local state and push to ToggleUI
    player:GetAttributeChangedSignal("AutoBuso"):Connect(function()
        local v = player:GetAttribute("AutoBuso")
        autoBuso = (v == true)

        if not suppressAttrToUI then
            suppressUIToAttr = true
            pcall(function() ToggleUI.Set(BUTTON_NAME, autoBuso) end)
            task.delay(0.05, function() suppressUIToAttr = false end)
        end
    end)

    -- Auto loop (giữ nguyên logic)
    task.spawn(function()
        while true do
            if autoBuso then
                if not isBusoOn() then
                    turnOnBuso()
                end
            end
            task.wait(CHECK_INTERVAL)
        end
    end)

    -- Polling lightweight: hỗ trợ legacy shared.AutoBuso = true/false
    task.spawn(function()
        local lastShared = nil
        while true do
            task.wait(0.15)
            local s = (shared and shared.AutoBuso)
            if s ~= lastShared then
                lastShared = s
                if s ~= nil then
                    player:SetAttribute("AutoBuso", s == true)
                end
            end
        end
    end)

    -- Expose toggle helper on shared
    shared = shared or {}
    shared.ToggleAutoBuso = function(val)
        player:SetAttribute("AutoBuso", val == true)
    end
end
    --[[HOOK
game.Players.LocalPlayer:SetAttribute("AutoBuso", true)  -- bật
game.Players.LocalPlayer:SetAttribute("AutoBuso", false) -- tắt
    ]]
--=== AUTO OBSERVE =======================================================================================================--

do
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")

    local player = Players.LocalPlayer
    local INTERVAL = 5 -- 5 giây / lần

    -- chờ ToggleUI helper
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)

    -- đường dẫn ScrollingTab chuẩn
    local ScrollingTab = game.Players.LocalPlayer
        .PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    -- tìm Frame "Player Setting" (đệ quy)
    local playerSetting = ScrollingTab:FindFirstChild("Player Setting", true) or ScrollingTab:FindFirstChild("Player Setting")
    if not playerSetting then
        warn("Không tìm thấy Frame 'Player Setting' trong ScrollingTab")
        return
    end

    local BUTTON_NAME = "AutoObserveButton"
    local button = playerSetting:FindFirstChild(BUTTON_NAME, true)
    if not button then
        warn("Không tìm thấy AutoObserveButton trong Player Setting")
        return
    end

    -- internal state (nguồn chân thực là Attribute)
    local DEFAULT_OBSERVE = false
    local autoObserve = DEFAULT_OBSERVE

    -- suppress flags để tránh loop UI <-> Attribute
    local suppressAttrToUI = false
    local suppressUIToAttr = false

    -- helper: gọi remote an toàn
    local function enableObserve()
        pcall(function()
            if ReplicatedStorage and ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommE") then
                ReplicatedStorage.Remotes.CommE:FireServer("Ken", true)
            end
        end)
    end

    -- init Attribute từ giá trị hiện có hoặc khởi tạo
    do
        local attr = player:GetAttribute("AutoObserve")
        if attr ~= nil then
            autoObserve = (attr == true)
        else
            player:SetAttribute("AutoObserve", autoObserve)
        end

        -- push sang UI (suppress UI->Attr trong khi set)
        suppressUIToAttr = true
        pcall(function() ToggleUI.Set(BUTTON_NAME, autoObserve) end)
        task.delay(0.05, function() suppressUIToAttr = false end)
    end

    -- helper infer toggle từ màu background
    local function inferToggleOn(btn)
        local bg
        pcall(function() bg = btn.BackgroundColor3 end)
        if not bg then return false end
        return bg.G and bg.G > bg.R and bg.G > bg.B and bg.G > 0.5
    end

    -- khi ToggleUI thay đổi visual (BackgroundColor3) -> sync Attribute
    button:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        task.delay(0.05, function()
            if suppressUIToAttr then return end
            local isOn = inferToggleOn(button)
            local curAttr = player:GetAttribute("AutoObserve") == true
            if curAttr ~= isOn then
                suppressAttrToUI = true
                player:SetAttribute("AutoObserve", isOn)
                task.delay(0.05, function() suppressAttrToUI = false end)
            end
        end)
    end)

    -- khi người dùng click button -> request ToggleUI change (không set trực tiếp color/text)
    local function onButtonActivated()
        local cur = inferToggleOn(button)
        pcall(function() ToggleUI.Set(BUTTON_NAME, not cur) end)
    end
    if button.Activated then
        button.Activated:Connect(onButtonActivated)
    else
        button.MouseButton1Click:Connect(onButtonActivated)
    end

    -- Attribute listener: khi attribute thay đổi -> cập nhật local state và sync lên UI
    player:GetAttributeChangedSignal("AutoObserve"):Connect(function()
        local v = player:GetAttribute("AutoObserve")
        autoObserve = (v == true)

        if not suppressAttrToUI then
            suppressUIToAttr = true
            pcall(function() ToggleUI.Set(BUTTON_NAME, autoObserve) end)
            task.delay(0.05, function() suppressUIToAttr = false end)
        end

        -- khi bật, gọi Observe ngay (giữ hành vi cũ)
        if autoObserve then
            enableObserve()
        end
    end)

    -- Auto loop (giữ logic cũ, nhẹ CPU)
    task.spawn(function()
        while true do
            if autoObserve then
                enableObserve()
                task.wait(INTERVAL)
            else
                task.wait(0.3)
            end
        end
    end)

    -- Polling nhẹ: hỗ trợ legacy shared.AutoObserve = true/false
    task.spawn(function()
        local lastShared = nil
        while true do
            task.wait(0.15)
            local s = (shared and shared.AutoObserve)
            if s ~= lastShared then
                lastShared = s
                if s ~= nil then
                    player:SetAttribute("AutoObserve", s == true)
                end
            end
        end
    end)

    -- Optional helper cho script cũ
    shared = shared or {}
    shared.ToggleAutoObserve = function(val)
        player:SetAttribute("AutoObserve", val == true)
    end
end
    --[[HOOK
game.Players.LocalPlayer:SetAttribute("AutoObserve", true)   -- bật
game.Players.LocalPlayer:SetAttribute("AutoObserve", false)  -- tắt
    ]]
--=== AUTO ABILITY & AWAKENING =======================================================================================================--

do
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")

    local player = Players.LocalPlayer
    local INTERVAL = 2
    local MAX_AWAIT = 4 -- timeout for hanging InvokeServer

    -- attempt / busy state (kept from original)
    local awakeningBusy = false
    local awakenAttemptId = 0
    local awakeningStartedAt = 0

    -- wait ToggleUI helper
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)

    -- ScrollingTab -> Player Setting
    local ScrollingTab = game.Players.LocalPlayer
        .PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    local playerSetting = ScrollingTab:FindFirstChild("Player Setting", true) or ScrollingTab:FindFirstChild("Player Setting")
    if not playerSetting then
        warn("Không tìm thấy Frame 'Player Setting' trong ScrollingTab")
        return
    end

    -- find UI buttons (new UI)
    local ABILITY_BTN_NAME = "AutoAbilityButton"
    local AWAKEN_BTN_NAME  = "AutoAwakeningButton"

    local abilityBtn = playerSetting:FindFirstChild(ABILITY_BTN_NAME, true)
    local awakenBtn  = playerSetting:FindFirstChild(AWAKEN_BTN_NAME, true)

    if not abilityBtn then warn("Không tìm thấy AutoAbilityButton trong Player Setting") end
    if not awakenBtn  then warn("Không tìm thấy AutoAwakeningButton trong Player Setting") end

    -- suppress guards to avoid UI <-> Attribute loops
    local suppressAttrToUI = false
    local suppressUIToAttr = false

    -- helpers: infer toggle ON from BackgroundColor3 (green-ish)
    local function inferToggleOn(btn)
        local bg
        pcall(function() bg = btn.BackgroundColor3 end)
        if not bg then return false end
        return bg.G and bg.G > bg.R and bg.G > bg.B and bg.G > 0.5
    end

    -- helpers for ability/awakening actions (keep original behavior)
    local function fireAbility()
        pcall(function()
            if ReplicatedStorage and ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommE") then
                ReplicatedStorage.Remotes.CommE:FireServer("ActivateAbility")
            end
        end)
    end

    local function attemptAwakening()
        if awakeningBusy then return end

        awakenAttemptId = awakenAttemptId + 1
        local myId = awakenAttemptId
        awakeningBusy = true
        awakeningStartedAt = tick()

        task.spawn(function()
            local succeeded = false
            local bp = player:FindFirstChild("Backpack")
            local waited = 0
            while waited < 3 and (not bp or not bp:FindFirstChild("Awakening")) do
                task.wait(0.18)
                waited = waited + 0.18
                bp = player:FindFirstChild("Backpack")
            end

            local awak = bp and bp:FindFirstChild("Awakening")
            if awak then
                local rf = awak:FindFirstChild("RemoteFunction")
                if rf and typeof(rf.InvokeServer) == "function" then
                    local ok, _ = pcall(function() rf:InvokeServer(true) end)
                    if ok then succeeded = true end
                end
            end

            if awakenAttemptId == myId then
                awakeningBusy = false
            end
        end)
    end

    -- initialize attributes and push to ToggleUI (suppress UI->attr while we set)
    do
        local a = player:GetAttribute("AutoAbility")
        local w = player:GetAttribute("AutoAwakening")

        if a == nil then player:SetAttribute("AutoAbility", false) end
        if w == nil then player:SetAttribute("AutoAwakening", false) end

        -- sync UI initial states from attributes
        suppressUIToAttr = true
        pcall(function()
            if abilityBtn then ToggleUI.Set(ABILITY_BTN_NAME, player:GetAttribute("AutoAbility") == true) end
            if awakenBtn  then ToggleUI.Set(AWAKEN_BTN_NAME,  player:GetAttribute("AutoAwakening") == true)  end
        end)
        task.delay(0.05, function() suppressUIToAttr = false end)
    end

    -- Sync UI -> Attribute when ToggleUI updates the button visual
    if abilityBtn then
        abilityBtn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
            task.delay(0.05, function()
                if suppressUIToAttr then return end
                local isOn = inferToggleOn(abilityBtn)
                local curAttr = player:GetAttribute("AutoAbility") == true
                if curAttr ~= isOn then
                    suppressAttrToUI = true
                    player:SetAttribute("AutoAbility", isOn)
                    task.delay(0.05, function() suppressAttrToUI = false end)
                end
            end)
        end)
    end

    if awakenBtn then
        awakenBtn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
            task.delay(0.05, function()
                if suppressUIToAttr then return end
                local isOn = inferToggleOn(awakenBtn)
                local curAttr = player:GetAttribute("AutoAwakening") == true
                if curAttr ~= isOn then
                    suppressAttrToUI = true
                    player:SetAttribute("AutoAwakening", isOn)
                    task.delay(0.05, function() suppressAttrToUI = false end)
                end
            end)
        end)
    end

    -- When user clicks UI -> request ToggleUI change
    local function wireButtonToToggle(btn, name)
        if not btn then return end
        local function requestToggle()
            local cur = inferToggleOn(btn)
            pcall(function() ToggleUI.Set(name, not cur) end)
        end
        if btn.Activated then
            btn.Activated:Connect(requestToggle)
        else
            btn.MouseButton1Click:Connect(requestToggle)
        end
    end

    wireButtonToToggle(abilityBtn, ABILITY_BTN_NAME)
    wireButtonToToggle(awakenBtn,  AWAKEN_BTN_NAME)

    -- Attribute listeners: when attribute changes -> update local logic and push to ToggleUI
    player:GetAttributeChangedSignal("AutoAbility"):Connect(function()
        local v = player:GetAttribute("AutoAbility")
        if not suppressAttrToUI then
            suppressUIToAttr = true
            pcall(function() if abilityBtn then ToggleUI.Set(ABILITY_BTN_NAME, v == true) end end)
            task.delay(0.05, function() suppressUIToAttr = false end)
        end

        -- immediate effect: fire ability now when enabling
        if v == true then
            -- reset ability timer so next automatic happens after interval
            -- we simulate original behavior by immediate fire (Heartbeat loop does the rest)
            pcall(function() fireAbility() end)
        end
    end)

    player:GetAttributeChangedSignal("AutoAwakening"):Connect(function()
        local v = player:GetAttribute("AutoAwakening")
        if not suppressAttrToUI then
            suppressUIToAttr = true
            pcall(function() if awakenBtn then ToggleUI.Set(AWAKEN_BTN_NAME, v == true) end end)
            task.delay(0.05, function() suppressUIToAttr = false end)
        end

        if v == true then
            -- immediate attempt
            task.spawn(function()
                -- attemptAwakening uses internal guards
                attemptAwakening()
            end)
        end
    end)

    -- Heartbeat-driven timer (reads attributes directly)
    local lastAwakenTick = 0
    local lastAbilityTick = 0

    RunService.Heartbeat:Connect(function()
        local enabledAbility = (player:GetAttribute("AutoAbility") == true)
        if enabledAbility then
            if (tick() - lastAbilityTick) >= INTERVAL then
                lastAbilityTick = tick()
                fireAbility()
            end
        else
            lastAbilityTick = tick() - INTERVAL - 0.01
        end

        local enabledAwaken = (player:GetAttribute("AutoAwakening") == true)

        -- watchdog for stuck attempts
        if awakeningBusy and (tick() - awakeningStartedAt) > MAX_AWAIT then
            awakeningBusy = false
            awakenAttemptId = awakenAttemptId + 1
        end

        if enabledAwaken then
            if (tick() - lastAwakenTick) >= INTERVAL and not awakeningBusy then
                lastAwakenTick = tick()
                attemptAwakening()
            end
        else
            lastAwakenTick = tick() - INTERVAL - 0.01
        end
    end)

    -- Respawn/humanoid died: invalidate stuck attempts and update UI from attributes
    local function onCharacter(char)
        awakeningBusy = false
        awakenAttemptId = awakenAttemptId + 1

        -- keep UI in sync with attribute after respawn
        task.delay(0.05, function()
            if not suppressAttrToUI then
                suppressUIToAttr = true
                pcall(function()
                    if abilityBtn then ToggleUI.Set(ABILITY_BTN_NAME, player:GetAttribute("AutoAbility") == true) end
                    if awakenBtn  then ToggleUI.Set(AWAKEN_BTN_NAME,  player:GetAttribute("AutoAwakening") == true) end
                end)
                task.delay(0.05, function() suppressUIToAttr = false end)
            end
        end)

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Died:Connect(function()
                awakeningBusy = false
                awakenAttemptId = awakenAttemptId + 1
            end)
        end
    end

    if player.Character then onCharacter(player.Character) end
    player.CharacterAdded:Connect(onCharacter)

    -- Polling lightweight: support legacy shared flags
    task.spawn(function()
        local lastA, lastW = nil, nil
        while true do
            task.wait(0.15)
            local sa = shared and shared.AutoAbility
            local sw = shared and shared.AutoAwakening

            if sa ~= lastA then
                lastA = sa
                if sa ~= nil then
                    if type(sa) == "string" then
                        local low = string.lower(sa)
                        if low == "on" or low == "true" then
                            player:SetAttribute("AutoAbility", true)
                        elseif low == "off" or low == "false" then
                            player:SetAttribute("AutoAbility", false)
                        end
                    else
                        player:SetAttribute("AutoAbility", sa == true)
                    end
                end
            end

            if sw ~= lastW then
                lastW = sw
                if sw ~= nil then
                    if type(sw) == "string" then
                        local low = string.lower(sw)
                        if low == "on" or low == "true" then
                            player:SetAttribute("AutoAwakening", true)
                        elseif low == "off" or low == "false" then
                            player:SetAttribute("AutoAwakening", false)
                        end
                    else
                        player:SetAttribute("AutoAwakening", sw == true)
                    end
                end
            end
        end
    end)

    -- helper API
    shared = shared or {}
    shared.ToggleAutoAbility = function(v) player:SetAttribute("AutoAbility", v == true) end
    shared.ToggleAutoAwakening = function(v) player:SetAttribute("AutoAwakening", v == true) end
end
    --[[HOOK
game.Players.LocalPlayer:SetAttribute("AutoAbility", true)
game.Players.LocalPlayer:SetAttribute("AutoAwakening", false)
    ]]
--=== CHANCE TEAM =======================================================================================================--

do
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local UserInputService = game:GetService("UserInputService")

    local player = Players.LocalPlayer

    -- TWEEN settings
    local TWEEN_TIME = 0.18
    local DELAY_SECONDS = 10 -- cooldown length
    local BG_VISIBLE_TRANSP = 0.1
    local BG_HIDDEN_TRANSP = 1

    -- wait for GUI path
    local ScrollingTab = player.PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    local playerSetting = ScrollingTab:FindFirstChild("Player Setting", true) or ScrollingTab:FindFirstChild("Player Setting")
    if not playerSetting then
        warn("Không tìm thấy Frame 'Player Setting' trong ScrollingTab")
        return
    end

    local btnMarines = playerSetting:FindFirstChild("MarinesButton", true)
    local btnPirates = playerSetting:FindFirstChild("PiratesButton", true)
    local delayLabel = playerSetting:FindFirstChild("DelayChanceTeam", true)

    if not btnMarines then warn("Không tìm thấy MarinesButton") return end
    if not btnPirates then warn("Không tìm thấy PiratesButton") return end
    if not delayLabel then warn("Không tìm thấy DelayChanceTeam label") return end

    -- ensure delayLabel defaults
    pcall(function()
        delayLabel.BackgroundTransparency = BG_HIDDEN_TRANSP
        delayLabel.Visible = false
    end)

    -- icon handling: find ImageLabel named "Icon" inside each button
    local function findIcon(btn)
        for _, c in ipairs(btn:GetDescendants()) do
            if c:IsA("ImageLabel") and c.Name == "Icon" then
                return c
            end
        end
        return nil
    end

    local iconMar = findIcon(btnMarines)
    local iconPir = findIcon(btnPirates)

    -- positions (UDim2 specs from your note)
    local marHiddenPos = UDim2.new(1, 0, -0.25, 0)
    local marVisiblePos = UDim2.new(1.25, 0, -0.25, 0)
    local pirHiddenPos = UDim2.new(0, 0, -0.25, 0)
    local pirVisiblePos = UDim2.new(-0.25, 0, -0.25, 0)

    -- safe tween helper that cancels previous tween
    local activeTweens = {} -- map obj -> Tween
    local function safeTween(obj, info, props)
        if activeTweens[obj] then
            pcall(function() activeTweens[obj]:Cancel() end)
            activeTweens[obj] = nil
        end
        local tw = TweenService:Create(obj, info, props)
        activeTweens[obj] = tw
        tw:Play()
        -- when completed remove from map
        tw.Completed:Connect(function()
            if activeTweens[obj] == tw then activeTweens[obj] = nil end
        end)
        return tw
    end

    local tweenInfoFast = TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    -- initialize icons to hidden state
    if iconMar then
        pcall(function()
            iconMar.ImageTransparency = 1
            iconMar.Position = marHiddenPos
        end)
    end
    if iconPir then
        pcall(function()
            iconPir.ImageTransparency = 1
            iconPir.Position = pirHiddenPos
        end)
    end

    -- hover handlers (desktop and mobile touch)
    local function hoverIn(icon, visiblePos)
        if not icon then return end
        safeTween(icon, tweenInfoFast, { Position = visiblePos })
        safeTween(icon, tweenInfoFast, { ImageTransparency = 0 })
    end
    local function hoverOut(icon, hiddenPos)
        if not icon then return end
        safeTween(icon, tweenInfoFast, { Position = hiddenPos })
        safeTween(icon, tweenInfoFast, { ImageTransparency = 1 })
    end

    -- wire hover for a button: supports MouseEnter/Leave and InputBegan/InputEnded (Touch)
    local function wireHover(btn, icon, hiddenPos, visiblePos)
        if not icon then return end

        -- MouseEnter / MouseLeave (desktop)
        if btn.MouseEnter then
            btn.MouseEnter:Connect(function()
                hoverIn(icon, visiblePos)
            end)
        end
        if btn.MouseLeave then
            btn.MouseLeave:Connect(function()
                hoverOut(icon, hiddenPos)
            end)
        end

        -- Touch / press support: treat InputBegan Touch as hover in, InputEnded as hover out
        if btn.InputBegan then
            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    hoverIn(icon, visiblePos)
                end
            end)
        end
        if btn.InputEnded then
            btn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    hoverOut(icon, hiddenPos)
                end
            end)
        end
    end

    wireHover(btnMarines, iconMar, marHiddenPos, marVisiblePos)
    wireHover(btnPirates, iconPir, pirHiddenPos, pirVisiblePos)

    -- cooldown state
    local isCooldown = false

    local function setButtonsEnabled(enabled)
        btnMarines.Active = enabled
        btnMarines.AutoButtonColor = enabled
        btnPirates.Active = enabled
        btnPirates.AutoButtonColor = enabled
    end

    -- tween in/out for delayLabel background transparency
    local function showDelayLabel()
        if delayLabel.Visible then return end
        delayLabel.Visible = true
        -- tween backgroundTransparency from 1 -> BG_VISIBLE_TRANSP
        safeTween(delayLabel, tweenInfoFast, { BackgroundTransparency = BG_VISIBLE_TRANSP })
    end
    local function hideDelayLabel()
        if not delayLabel.Visible then return end
        -- tween BG from BG_VISIBLE_TRANSP -> 1 then hide
        local tw = safeTween(delayLabel, tweenInfoFast, { BackgroundTransparency = BG_HIDDEN_TRANSP })
        tw.Completed:Connect(function()
            delayLabel.Visible = false
        end)
    end

    -- cooldown routine (non-blocking)
    local function startCooldown(seconds)
        if isCooldown then return end
        isCooldown = true
        setButtonsEnabled(false)
        -- show label and tween in
        showDelayLabel()

        task.spawn(function()
            for i = seconds, 1, -1 do
                pcall(function() delayLabel.Text = "Wait " .. tostring(i) .. "s" end)
                task.wait(1)
            end
            pcall(function() delayLabel.Text = "" end)
            -- tween out and disable overlay
            hideDelayLabel()
            setButtonsEnabled(true)
            isCooldown = false
        end)
    end

    -- click handlers call remote and start cooldown (guarding rapid clicks)
    local function handleTeamClick(teamName)
        if isCooldown then return end
        local ok, err = pcall(function()
            local remotes = ReplicatedStorage:WaitForChild("Remotes", 2)
            if not remotes then error("Remotes missing") end
            local comm = remotes:WaitForChild("CommF_", 2)
            if not comm then error("CommF_ missing") end
            comm:InvokeServer("SetTeam", teamName)
        end)
        if not ok then
            warn("SetTeam failed:", err)
            return
        end
        startCooldown(DELAY_SECONDS)
    end

    if btnMarines.Activated then
        btnMarines.Activated:Connect(function() handleTeamClick("Marines") end)
    else
        btnMarines.MouseButton1Click:Connect(function() handleTeamClick("Marines") end)
    end

    if btnPirates.Activated then
        btnPirates.Activated:Connect(function() handleTeamClick("Pirates") end)
    else
        btnPirates.MouseButton1Click:Connect(function() handleTeamClick("Pirates") end)
    end
end
