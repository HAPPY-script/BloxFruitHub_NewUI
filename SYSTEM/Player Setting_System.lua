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

--=== JUMP POWER =======================================================================================================--

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    local player = Players.LocalPlayer

    -- Wait for ToggleUI helper (mẫu)
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)

    -- UI paths (theo mẫu)
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

    local BUTTON_NAME = "PowerJumpButton"
    local BOX_NAME    = "JumpBox"

    local powerBtn = playerSetting:FindFirstChild(BUTTON_NAME, true)
    local jumpBox  = playerSetting:FindFirstChild(BOX_NAME, true)

    if not powerBtn then warn("Không tìm thấy PowerJumpButton") return end
    if not jumpBox then warn("Không tìm thấy JumpBox") return end

    -- ===== STATE =====
    local isActive = false
    local jumpValue = nil        -- number do user đặt
    local MIN_JUMP = nil         -- sẽ lưu jumpPower ban đầu
    local MAX_JUMP = 100         -- giới hạn trên cố định

    -- ===== helpers =====
    local function inferToggleOn(btn)
        local bg
        pcall(function() bg = btn.BackgroundColor3 end)
        return bg and bg.G > bg.R and bg.G > bg.B
    end

    local function syncFromButtonColor()
        isActive = inferToggleOn(powerBtn)
    end

    local function clampJump(n)
        if type(n) ~= "number" or n ~= n then return nil end
        if MIN_JUMP then
            if n < MIN_JUMP then n = MIN_JUMP end
        else
            if n < 0 then n = 0 end
        end
        if n > MAX_JUMP then n = MAX_JUMP end
        return n
    end

    local function setJumpBoxText(val)
        pcall(function() if jumpBox and jumpBox:IsA("TextBox") then jumpBox.Text = tostring(val) end end)
    end

    local function applyJumpToHumanoid(humanoid, value)
        if not humanoid or type(value) ~= "number" then return end
        pcall(function() humanoid.JumpPower = value end)
    end

    local function applyToPlayerCurrent(value)
        local char = player.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            applyJumpToHumanoid(humanoid, value)
        end
    end

    -- ===== capture MIN_JUMP when humanoid is available =====
    local function captureMinJumpFromHumanoid(humanoid)
        if not humanoid or MIN_JUMP then return end
        local ok, val = pcall(function() return humanoid.JumpPower end)
        if ok and type(val) == "number" then
            MIN_JUMP = val
        else
            MIN_JUMP = 50 -- fallback an toàn
        end

        -- nếu ô rỗng hoặc không phải số, đặt nó về MIN_JUMP
        if not tonumber(jumpBox.Text) or jumpBox.Text == "" then
            jumpValue = MIN_JUMP
            setJumpBoxText(MIN_JUMP)
        end
    end

    -- CharacterAdded handler
    local function onCharacterAdded(char)
        if not char then return end
        local humanoid = char:WaitForChild("Humanoid", 5)
        if humanoid then
            captureMinJumpFromHumanoid(humanoid)
        end

        -- đảm bảo jumpValue hợp lệ
        if not jumpValue then
            local parsed = tonumber(jumpBox.Text)
            if not parsed then parsed = MIN_JUMP end
            parsed = clampJump(parsed) or (MIN_JUMP or 50)
            jumpValue = parsed
            setJumpBoxText(parsed)
        end

        -- áp dụng theo trạng thái toggle hiện tại
        syncFromButtonColor()
        if isActive then
            applyToPlayerCurrent(jumpValue)
        else
            if MIN_JUMP then applyToPlayerCurrent(MIN_JUMP) end
        end
    end

    -- Nếu humanoid đã tồn tại ngay lúc script chạy, capture MIN_JUMP ngay lập tức
    if player.Character then
        local char = player.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            captureMinJumpFromHumanoid(hum)
            if not tonumber(jumpBox.Text) or jumpBox.Text == "" then
                jumpValue = MIN_JUMP
                setJumpBoxText(MIN_JUMP)
            end
        end
    end
    player.CharacterAdded:Connect(onCharacterAdded)

    -- ===== UI interactions (toggle + box) =====
    powerBtn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        task.delay(0.05, syncFromButtonColor)
    end)

    local function onButtonActivated()
        local cur = inferToggleOn(powerBtn)
        pcall(function() ToggleUI.Set(BUTTON_NAME, not cur) end)
    end

    if powerBtn.Activated then
        powerBtn.Activated:Connect(onButtonActivated)
    else
        powerBtn.MouseButton1Click:Connect(onButtonActivated)
    end

    -- Validate and save when user leaves the textbox
    jumpBox.FocusLost:Connect(function(enterPressed)
        local n = tonumber(jumpBox.Text)
        if not n then
            n = MIN_JUMP or 50
        end

        n = clampJump(n) or (MIN_JUMP or 50)
        jumpValue = n
        setJumpBoxText(n)

        -- nếu đang bật, áp dụng ngay và cho phép chỉnh tiếp
        syncFromButtonColor()
        if isActive then
            applyToPlayerCurrent(n)
        end
    end)

    -- sync state when toggle changed
    local function syncState()
        syncFromButtonColor()
        if isActive then
            if not jumpValue then
                local parsed = tonumber(jumpBox.Text)
                if parsed then jumpValue = parsed else jumpValue = MIN_JUMP or 50 end
            end
            jumpValue = clampJump(jumpValue) or (MIN_JUMP or 50)
            applyToPlayerCurrent(jumpValue)
        else
            if MIN_JUMP then applyToPlayerCurrent(MIN_JUMP) end
        end
    end

    -- ensure ToggleUI initial off (mimic sample)
    pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)

    -- initial sync
    task.delay(0.05, function()
        if MIN_JUMP and (not tonumber(jumpBox.Text) or jumpBox.Text == "") then
            setJumpBoxText(MIN_JUMP)
            jumpValue = MIN_JUMP
        end
        syncState()
    end)

    -- react to visual color change to actually apply state (only when changed)
    powerBtn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        task.delay(0.05, function()
            local prev = isActive
            syncFromButtonColor()
            if isActive ~= prev then
                syncState()
            end
        end)
    end)

    -- ensure textbox has something sensible immediately
    if not jumpBox.Text or jumpBox.Text == "" then
        if MIN_JUMP then
            setJumpBoxText(MIN_JUMP)
        else
            setJumpBoxText(50)
        end
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

    -- ---------- helper: infer on/off bằng màu ----------
    local function inferToggleOn(btn)
        local ok, bg = pcall(function() return btn.BackgroundColor3 end)
        if not ok or not bg then return false end
        -- chỉ khi chính xác (0,255,0) => ON
        local r = math.floor(bg.R * 255 + 0.5)
        local g = math.floor(bg.G * 255 + 0.5)
        local b = math.floor(bg.B * 255 + 0.5)
        return (r == 0 and g == 255 and b == 0)
    end

    -- === NEW INIT LOGIC ===
    -- khi khởi đầu, tạm coi như "bật" (tránh UI nhảy)
    local autoBuso = true
    pcall(function() player:SetAttribute("AutoBuso", autoBuso) end)

    -- Chạy 1 task riêng để chờ playerSetting.Visible == true,
    -- rồi gọi ToggleUI.SetDefault(BUTTON_NAME, true) một lần để set UI chuẩn,
    -- sau đó đồng bộ autoBuso theo màu thực sự và dừng kiểm tra.
    task.spawn(function()
        -- nếu playerSetting không phải GUIObject hoặc không có thuộc tính Visible thì fallback: thử 1 lần delay rồi set default
        local safeVisibleCheck = (type(playerSetting.GetAttribute) ~= "function") -- default false, but we'll check using pcall on Visible
        local attempts = 0
        while true do
            attempts = attempts + 1
            local visOk, visVal = pcall(function() return (playerSetting and playerSetting.Visible) end)
            if visOk and visVal == true then
                -- Frame đã hiển thị -> set default UI và đồng bộ màu
                pcall(function()
                    ToggleUI.SetDefault(BUTTON_NAME, true)
                end)
                -- đợi một chút để ToggleUI có thể cập nhật màu (tweens nếu có)
                task.wait(0.06)
                -- Đồng bộ trạng thái thực tế theo màu nút bây giờ
                local nowOn = inferToggleOn(button)
                autoBuso = nowOn
                pcall(function() player:SetAttribute("AutoBuso", autoBuso) end)
                break
            end

            -- nếu frame chưa hiển thị sau nhiều lần kiểm tra (ví dụ UI chưa load), vẫn giữ mặc định ON
            if attempts > 200 then
                -- đã chờ quá lâu (~20s) -> set default anyway to avoid stuck
                pcall(function()
                    ToggleUI.SetDefault(BUTTON_NAME, true)
                end)
                task.wait(0.06)
                local nowOn = inferToggleOn(button)
                autoBuso = nowOn
                pcall(function() player:SetAttribute("AutoBuso", autoBuso) end)
                break
            end

            task.wait(0.1)
        end
    end)
    -- === END NEW INIT LOGIC ===

    -- khi user bấm -> gửi yêu cầu đổi trạng thái cho ToggleUI (ToggleUI chịu trách nhiệm cập nhật màu)
    local function onButtonActivated()
        local cur = inferToggleOn(button)
        pcall(function() ToggleUI.Set(BUTTON_NAME, not cur) end)
    end
    if button.Activated then
        button.Activated:Connect(onButtonActivated)
    else
        button.MouseButton1Click:Connect(onButtonActivated)
    end

    -- khi màu button thay đổi -> cập nhật state nội bộ + attribute (không phản hồi bằng Set)
    button:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        -- nhỏ delay để ToggleUI hoàn tất tween/màu
        task.delay(0.05, function()
            local nowOn = inferToggleOn(button)
            if nowOn ~= autoBuso then
                autoBuso = nowOn
                pcall(function() player:SetAttribute("AutoBuso", autoBuso) end)
            end
        end)
    end)

    -- ---------- core Buso logic (giữ nguyên) ----------
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

    -- Auto loop: chỉ dựa trên 'autoBuso' (được cập nhật từ màu)
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

    -- Polling legacy shared.AutoBuso (nếu tồn tại) -> điều khiển UI thông qua ToggleUI.Set
    task.spawn(function()
        local lastShared = nil
        while true do
            task.wait(0.15)
            local s = (shared and shared.AutoBuso)
            if s ~= lastShared then
                lastShared = s
                if s ~= nil then
                    -- IMPORTANT: we change the UI via ToggleUI.Set (not by coloring directly)
                    pcall(function() ToggleUI.Set(BUTTON_NAME, s == true) end)
                end
            end
        end
    end)

    -- Expose toggle helper on shared (để các module khác có thể bật/tắt qua ToggleUI)
    shared = shared or {}
    -- NOTE: SetDefault used here so external modules can set the button instantly (no animation) if they want.
    shared.ToggleAutoBuso = function(val)
        pcall(function() ToggleUI.SetDefault(BUTTON_NAME, val == true) end)
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
--[[ HOOK
game.Players.LocalPlayer:SetAttribute("AutoRandomBone", true) -- true/false
]]
