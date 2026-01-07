-- LocalScript (place under PlayerGui > BloxFruitHubGui > Main > ScrollingTab > Island)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local ROOT = script.Parent -- Island Frame

-- ============== SETTINGS (tùy chỉnh) =================
local LUNGE_SPEED = 300
local TELEPORT_HEIGHT = 100
local TELEPORT_SPAM_COUNT = 10
local TELEPORT_SPAM_TIME = 1.5
local ANIM_FPS = 7 -- 7 animations / second
-- ====================================================

-- ============== PLACE DATA (không sửa nếu dùng dữ liệu bạn đã có) =========
local PLACES = {
    Sea1 = {
        ids = { 85211729168715, 2753915549 },
    },
    Sea2 = {
        ids = { 79091703265657, 4442272183 },
    },
    Sea3 = {
        ids = { 7449423635, 100117331123089 },
    },
    Dungeon = {
        ids = { 73902483975735 },
    }
}
-- Lấy folder active theo PlaceId
local function getActiveSeaFolder()
    local pid = game.PlaceId
    for seaName, data in pairs(PLACES) do
        if table.find(data.ids, pid) then
            local folder = ROOT:FindFirstChild(seaName)
            if folder then return folder, seaName end
        end
    end
    -- nếu không khớp, fallback tìm Sea1/Sea2/Sea3 theo tồn tại
    for _, name in ipairs({"Sea1","Sea2","Sea3"}) do
        local f = ROOT:FindFirstChild(name)
        if f then return f, name end
    end
    return nil, nil
end
local ACTIVE_FOLDER, ACTIVE_NAME = getActiveSeaFolder()
if not ACTIVE_FOLDER then
    warn("Không tìm thấy folder Sea1/Sea2/Sea3 trong Island frame.")
    return
end

local ANIMATION_UI_FOLDER = ROOT:FindFirstChild("AnimationUI")
if not ANIMATION_UI_FOLDER then
    warn("Không tìm thấy AnimationUI (ImageLabel Animation1..5).")
    return
end

-- ============== MAPPING BUTTON NAME -> TARGET (bạn sửa tại đây) ==========
-- Ghi chú: key là tên Button (btn.Name). Điền Vector3 tương ứng.
local BUTTON_TARGETS = {
    -- Ví dụ:
    -- ["PointA"] = Vector3.new(-7894.62, 5545.49, -380.29),
    -- ["PointB"] = Vector3.new(-4607.82, 872.54, -1667.56),
    -- Thêm/ sửa ở đây theo tên button trong folder ACTIVE_FOLDER
}
-- ==========================================================================

-- ============== Movement helpers (sử dụng token để cancel) =================
local movementToken = 0

local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function vecDistance(a,b)
    return (a - b).Magnitude
end

-- teleport spam (returns true if completed, false if cancelled)
local function teleportSpam(pos)
    local hrp = getHRP()
    local myToken = movementToken

    local count = 0
    local interval = TELEPORT_SPAM_TIME / math.max(1, TELEPORT_SPAM_COUNT)
    local elapsed = 0
    local done = false

    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if myToken ~= movementToken then
            conn:Disconnect()
            done = true
            return
        end
        elapsed = elapsed + dt
        if elapsed >= interval then
            elapsed = 0
            count = count + 1
            hrp.CFrame = CFrame.new(pos)
            if count >= TELEPORT_SPAM_COUNT then
                conn:Disconnect()
                done = true
            end
        end
    end)

    while not done and myToken == movementToken do
        task.wait()
    end
    return myToken == movementToken
end

-- lungeTo that yields until finished or cancelled
local function lungeTo(targetPos)
    local hrp = getHRP()
    local myToken = movementToken

    local startPos = hrp.Position
    local delta = targetPos - startPos
    local distance = delta.Magnitude
    if distance < 1 then return true end

    local direction = delta.Unit
    local duration = distance / LUNGE_SPEED
    local elapsed = 0
    local finished = false

    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if myToken ~= movementToken then
            conn:Disconnect()
            finished = false
            return
        end

        elapsed = elapsed + dt
        local alpha = math.clamp(elapsed / duration, 0, 1)
        hrp.CFrame = CFrame.new(startPos + direction * (distance * alpha))

        if alpha >= 1 then
            conn:Disconnect()
            finished = true
        end
    end)

    while (not finished) and myToken == movementToken do
        task.wait()
    end

    return myToken == movementToken
end

local function stopMovement()
    movementToken = movementToken + 1
end

-- executes teleport + lunge -> yields until done or cancelled
local function executeMovementTo(targetPos)
    stopMovement() -- ensure previous movement token changed so we reset
    movementToken = movementToken + 0 -- ensure current token is valid for this run
    local myToken = movementToken
    local hrp = getHRP()

    -- Try to pick a nearby teleport point from known TELEPORT_POINTS if you want.
    -- For now this implementation will just spam-teleport to target's XZ with height if desired,
    -- but you may integrate your precomputed TELEPORT_POINTS logic here if you have it.
    -- We'll do a simple teleportSpam to target's X,Z but at TELEPORT_HEIGHT above to avoid collisions.
    local teleportPos = Vector3.new(targetPos.X, targetPos.Y, targetPos.Z)
    local ok = teleportSpam(teleportPos)
    if not ok or myToken ~= movementToken then return false end

    -- small vertical raise then lunge (keeps behaviour similar to original)
    hrp.CFrame = CFrame.new(teleportPos + Vector3.new(0, TELEPORT_HEIGHT, 0))
    task.wait(0.05)
    if myToken ~= movementToken then return false end

    local ok2 = lungeTo(targetPos)
    return ok2 and myToken == movementToken
end
-- ==============================================================================

-- ============== UI helpers ================
local TweenInfoDefault = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local function tween(inst, props, info)
    return TweenService:Create(inst, info or TweenInfoDefault, props)
end

local function setButtonDefaults(btn)
    local effect = btn:FindFirstChild("Effect")
    if not effect then return end
    local loading = effect:FindFirstChild("Loading")
    local loadFrame = loading and loading:FindFirstChild("LoadFrame")
    local cancelBtn = effect:FindFirstChild("CancelButton")
    local nameLabel = effect:FindFirstChild("Name")
    local ratio = effect:FindFirstChild("Ratio")
    local gradient = effect:FindFirstChildOfClass("UIGradient") or effect:FindFirstChild("UIGradient")

    if gradient and gradient:IsA("UIGradient") then
        gradient.Offset = Vector2.new(0, 1)
    end
    if cancelBtn then cancelBtn.Visible = false end
    if nameLabel then nameLabel.TextTransparency = 1 end
    if ratio then ratio.Visible = false; ratio.TextTransparency = 0 end
    if loading then loading.Visible = false end
    if loadFrame then loadFrame.Size = UDim2.new(0,0,1,0) end
end

local function restoreButtonUI(btn)
    -- restore to defaults (animation should be stopped by caller)
    setButtonDefaults(btn)
end

-- safe find child by name or class
local function getEffectParts(btn)
    local effect = btn:FindFirstChild("Effect")
    if not effect then return nil end
    local loading = effect:FindFirstChild("Loading")
    local loadFrame = loading and loading:FindFirstChild("LoadFrame")
    local cancelBtn = effect:FindFirstChild("CancelButton")
    local nameLabel = effect:FindFirstChild("Name")
    local ratio = effect:FindFirstChild("Ratio")
    local gradient = effect:FindFirstChildOfClass("UIGradient") or effect:FindFirstChild("UIGradient")
    return {
        Effect = effect,
        Loading = loading,
        LoadFrame = loadFrame,
        CancelButton = cancelBtn,
        Name = nameLabel,
        Ratio = ratio,
        UIGradient = (gradient and gradient:IsA("UIGradient")) and gradient or nil
    }
end
-- ==========================================

-- ============== Animation loader inside LoadFrame ===========================
local function playAnimationsInLoadFrame(loadFrame, stopFlag)
    -- cycles through Animation1..Animation5 inside ANIMATION_UI_FOLDER at ANIM_FPS
    if not ANIMATION_UI_FOLDER or not loadFrame then return end
    local animCount = 0
    for i = 1,5 do
        if ANIMATION_UI_FOLDER:FindFirstChild("Animation"..i) then animCount = animCount + 1 end
    end
    if animCount == 0 then return end

    local interval = 1 / ANIM_FPS
    local running = true
    -- ensure previous children cleared
    for _,c in ipairs(loadFrame:GetChildren()) do
        if not c:IsA("UIAspectRatioConstraint") then
            c:Destroy()
        end
    end

    spawn(function()
        local idx = 1
        while running and not stopFlag.cancelled do
            local src = ANIMATION_UI_FOLDER:FindFirstChild("Animation"..idx)
            if src then
                -- clone full hierarchy
                for _,c in ipairs(loadFrame:GetChildren()) do
                    if not c:IsA("UIAspectRatioConstraint") then
                        c:Destroy()
                    end
                end

                local clone = src:Clone()
                clone.Parent = loadFrame
                -- fit to loadFrame
                if clone:IsA("GuiObject") then
                    clone.AnchorPoint = Vector2.new(0.5, 0.5)
                    clone.Position = UDim2.new(0.5, 0.5, 0.5, 0)
                    clone.Size = UDim2.new(1,0,1,0)
                end
            end

            idx = idx + 1
            if idx > animCount then idx = 1 end
            local waited = 0
            while waited < interval do
                if stopFlag.cancelled then break end
                task.wait(0.01)
                waited = waited + 0.01
            end
        end

        -- cleanup
        for _,c in ipairs(loadFrame:GetChildren()) do
            if not c:IsA("UIAspectRatioConstraint") then
                c:Destroy()
            end
        end
    end)

    -- return function to stop
    return function()
        running = false
    end
end
-- ============================================================================

-- ============== Main wiring: set defaults and attach events =================
local hoverConnections = {} -- to disconnect later
local interactionLocked = false -- khi true -> disable hover globally

-- initialize defaults for all buttons in ACTIVE_FOLDER
for _, btn in ipairs(ACTIVE_FOLDER:GetChildren()) do
    if btn:IsA("GuiButton") or btn:IsA("ImageButton") or btn:IsA("TextButton") then
        pcall(setButtonDefaults, btn)
    end
end

-- attach hover and click for each button that is a GuiButton
for _, btn in ipairs(ACTIVE_FOLDER:GetChildren()) do
    if not (btn:IsA("GuiButton") or btn:IsA("ImageButton") or btn:IsA("TextButton")) then
        continue
    end

    local parts = getEffectParts(btn)
    if not parts then continue end

    -- hover behavior (both desktop and mobile)
    local enterConn, leaveConn, inputBeganConn, inputEndedConn, clickConn, cancelConn
    local hovering = false

    local function onEnter()
        if interactionLocked then return end
        hovering = true
        if parts.UIGradient then
            tween(parts.UIGradient, {Offset = Vector2.new(0,0)}):Play()
        end
        if parts.Name then
            tween(parts.Name, {TextTransparency = 0}):Play()
        end
    end
    local function onLeave()
        if interactionLocked then return end
        hovering = false
        if parts.UIGradient then
            tween(parts.UIGradient, {Offset = Vector2.new(0,1)}):Play()
        end
        if parts.Name then
            tween(parts.Name, {TextTransparency = 1}):Play()
        end
    end

    -- MouseEnter/MouseLeave
    enterConn = btn.MouseEnter:Connect(onEnter)
    leaveConn = btn.MouseLeave:Connect(onLeave)

    -- Mobile: use InputBegan/Ended and treat Touch begin as "enter" and Touch end as "leave"
    inputBeganConn = btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            onEnter()
        end
    end)
    inputEndedConn = btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            onLeave()
        end
    end)

    -- Click handling
    clickConn = btn.Activated:Connect(function()
        if interactionLocked then return end
        interactionLocked = true

        -- determine target position from BUTTON_TARGETS
        local target = BUTTON_TARGETS[btn.Name]
        if not target then
            warn("TARGET not set for button:", btn.Name)
            interactionLocked = false
            return
        end

        -- disable hover visuals for all buttons
        for _, other in ipairs(ACTIVE_FOLDER:GetChildren()) do
            if (other:IsA("GuiButton") or other:IsA("TextButton") or other:IsA("ImageButton")) then
                local p = getEffectParts(other)
                if p and p.UIGradient then
                    tween(p.UIGradient, {Offset = Vector2.new(0,-1)}, TweenInfo.new(0.12)):Play()
                end
            end
        end

        -- enable loading UI for this button
        if parts.Ratio then
            parts.Ratio.Visible = true
            parts.Ratio.Text = "0%"
        end
        if parts.CancelButton then
            parts.CancelButton.Visible = true
        end
        if parts.Loading then
            parts.Loading.Visible = true
        end
        if parts.LoadFrame then
            -- animate to 0 width first
            parts.LoadFrame.Size = UDim2.new(0,0,1,0)
        end
        if parts.UIGradient then
            tween(parts.UIGradient, {Offset = Vector2.new(0,-1)}, TweenInfo.new(0.12)):Play()
        end

        -- stopFlag used by animation player
        local stopFlag = { cancelled = false }
        local stopAnimFunc = playAnimationsInLoadFrame(parts.LoadFrame, stopFlag)

        -- progress updater
        local totalDist = math.max(0.0001, vecDistance(getHRP().Position, target))
        local myToken = movementToken + 1
        movementToken = myToken

        local progressConn
        progressConn = RunService.Heartbeat:Connect(function()
            if movementToken ~= myToken then
                progressConn:Disconnect()
                return
            end
            local curPos = getHRP().Position
            local prog = 1 - (vecDistance(curPos, target) / totalDist)
            prog = math.clamp(prog, 0, 1)
            local pct = math.floor(prog * 100)
            if parts.Ratio then parts.Ratio.Text = tostring(pct).."%"; parts.Ratio.Visible = true end
            if parts.LoadFrame then
                -- tween loadFrame size smoothly to new width
                pcall(function()
                    tween(parts.LoadFrame, {Size = UDim2.new(prog,0,1,0)}, TweenInfo.new(0.12)):Play()
                end)
            end
        end)

        -- Cancel button handler (only this run)
        local cancelPressed = false
        local function doCancel()
            if cancelPressed then return end
            cancelPressed = true
            -- signal cancel
            stopFlag.cancelled = true
            stopMovement()
            -- cleanup
            if progressConn and progressConn.Connected then progressConn:Disconnect() end
            if stopAnimFunc then stopAnimFunc() end
            -- small delay then restore UI
            task.spawn(function()
                task.wait(0.12)
                restoreButtonUI(btn)
                for _, other in ipairs(ACTIVE_FOLDER:GetChildren()) do
                    if (other:IsA("GuiButton") or other:IsA("TextButton") or other:IsA("ImageButton")) then
                        local p = getEffectParts(other)
                        if p then
                            pcall(function()
                                if p.UIGradient then tween(p.UIGradient, {Offset = Vector2.new(0,1)}):Play() end
                                if p.Name then tween(p.Name, {TextTransparency = 1}):Play() end
                            end)
                        end
                    end
                end
                interactionLocked = false
            end)
        end

        if parts.CancelButton then
            cancelConn = parts.CancelButton.Activated:Connect(function()
                doCancel()
            end)
        end

        -- run the movement (blocks until finished or cancelled)
        local success = executeMovementTo(target)

        -- if cancelled by user or stopped
        stopFlag.cancelled = stopFlag.cancelled or (movementToken ~= myToken) or (not success)
        if stopFlag.cancelled then
            doCancel()
            if cancelConn then cancelConn:Disconnect() end
            return
        end

        -- finished movement normally: wait momentarily, then stop animation and restore UI
        stopFlag.cancelled = true
        if stopAnimFunc then stopAnimFunc() end
        if progressConn and progressConn.Connected then progressConn:Disconnect() end

        task.wait(0.08)

        -- finalize ratio to 100% and fill loadFrame fully
        if parts.Ratio then parts.Ratio.Text = "100%" end
        if parts.LoadFrame then
            tween(parts.LoadFrame, {Size = UDim2.new(1,0,1,0)}, TweenInfo.new(0.12)):Play()
        end

        task.wait(0.15)

        -- cleanup and restore
        restoreButtonUI(btn)
        for _, other in ipairs(ACTIVE_FOLDER:GetChildren()) do
            if (other:IsA("GuiButton") or other:IsA("TextButton") or other:IsA("ImageButton")) then
                local p = getEffectParts(other)
                if p then
                    pcall(function()
                        if p.UIGradient then tween(p.UIGradient, {Offset = Vector2.new(0,1)}):Play() end
                        if p.Name then tween(p.Name, {TextTransparency = 1}):Play() end
                    end)
                end
            end
        end

        interactionLocked = false
        if cancelConn then cancelConn:Disconnect() end
    end)

    -- keep track so we can disconnect later if needed
    hoverConnections[btn] = {
        enter = enterConn,
        leave = leaveConn,
        inputBegan = inputBeganConn,
        inputEnded = inputEndedConn,
        click = clickConn,
    }
end

-- Optional: function to clean up connections if script disabled
local function cleanup()
    for btn, conns in pairs(hoverConnections) do
        for k,v in pairs(conns) do
            if v and v.Connected then pcall(function() v:Disconnect() end) end
        end
    end
end

script.Destroying:Connect(cleanup)

-- Informational
print("Island UI controller initialized for folder:", ACTIVE_NAME)
print("Remember to populate BUTTON_TARGETS table in script with button.Name => Vector3 targets.")
