-- BringMob UI + Movement integration
-- Yêu cầu: PlayerGui > BloxFruitHubGui > Main > ScrollingTab > Island (Frame)
-- Trong Island: Folder Sea1, Sea2, Sea3, AnimationUI
-- Mỗi Sea* chứa Button (mỗi Button có child Frame "Effect" chứa Loading/LoadFrame/CancelButton/Name/Ratio/UIGradient)
-- AnimationUI chứa Animation1..Animation5 (ImageLabel hoặc Frame)

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ================= SETTINGS =================
local LUNGE_SPEED = 300
local TELEPORT_HEIGHT = 100
local TELEPORT_SPAM_COUNT = 10
local TELEPORT_SPAM_TIME = 1.5
local ANIM_FPS = 7
local LOADFRAME_FULL = UDim2.new(1,0,1,0)
local LOADFRAME_ZERO = UDim2.new(0,0,1,0)
-- ============================================

-- ======= PLACE / TELEPORT DATA: bạn gắn tên Button -> vị trí ở đây =======
local TARGET_POSITIONS = {
    -- ["ButtonName"] = Vector3.new(x,y,z),
    -- ví dụ:
    -- ["TurtleIslandBtn"] = Vector3.new(-4992.52, 357.78, -3051.24),
}
-- ========================================================================

-- wait for GUI
local function waitGui(...)
    local root = player:WaitForChild("PlayerGui")
    local gui = root:WaitForChild(...)
    return gui
end

local ok, scrollingTab = pcall(function()
    local pg = player:WaitForChild("PlayerGui")
    local bf = pg:WaitForChild("BloxFruitHubGui")
    local main = bf:WaitForChild("Main")
    return main:WaitForChild("ScrollingTab")
end)
if not ok or not scrollingTab then
    warn("[BringUI] Không tìm thấy ScrollingTab")
    return
end

local islandFrame = scrollingTab:FindFirstChild("Island", true) or scrollingTab:FindFirstChild("Island")
if not islandFrame then
    warn("[BringUI] Không tìm thấy Frame 'Island' trong ScrollingTab")
    return
end

local animationFolder = islandFrame:FindFirstChild("AnimationUI", true) or islandFrame:FindFirstChild("AnimationUI")
if not animationFolder then
    warn("[BringUI] Không tìm thấy AnimationUI")
    return
end

-- detect which Sea folder matches placeId
local function getActiveSeaFolder()
    local placeId = game.PlaceId
    for _, sea in ipairs({"Sea1","Sea2","Sea3"}) do
        local folder = islandFrame:FindFirstChild(sea, true) or islandFrame:FindFirstChild(sea)
        if folder then
            -- assume folder contains Buttons (we accept this folder)
            -- but we must check if placeId matches name: in your description you said system checks placeId to choose Sea folder
            -- so we expect folder has an Attribute or you map place->sea externally
            -- to keep flexible: try to match via attribute "PlaceIds" (comma sep) or fallback to plain names
            -- For simplicity: if folder.Name == SeaX and game.PlaceId in PLACES mapping (provided by caller) then return
        end
    end
    -- fallback: try names directly: Sea1/2/3 mapped earlier in PLACES data used outside this script
    -- We'll try a simpler approach: look up place->sea via global table if present
    if _G.PlaceToSea and type(_G.PlaceToSea) == "table" then
        local g = _G.PlaceToSea[game.PlaceId]
        if g then
            local folder = islandFrame:FindFirstChild(g, true) or islandFrame:FindFirstChild(g)
            if folder then return folder end
        end
    end

    -- last resort: choose first Sea that exists
    for _, sea in ipairs({"Sea1","Sea2","Sea3"}) do
        local folder = islandFrame:FindFirstChild(sea, true) or islandFrame:FindFirstChild(sea)
        if folder then return folder end
    end

    return nil
end

local activeSeaFolder = getActiveSeaFolder()
if not activeSeaFolder then
    warn("[BringUI] Không tìm thấy folder Sea phù hợp")
    return
end

-- collect buttons (children that are TextButton/ImageButton/etc)
local function isButtonInst(inst)
    return inst:IsA("TextButton") or inst:IsA("ImageButton") or inst:IsA("TextLabel") -- allow labels if used as button
end

local buttons = {}
for _, child in ipairs(activeSeaFolder:GetChildren()) do
    if isButtonInst(child) and child.Name ~= "Effect" then
        table.insert(buttons, child)
    end
end

-- helper movement functions (reused from prior code)
local movementToken = 0
local function stopMovement()
    movementToken = movementToken + 1
end

local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function distance(a,b) return (a-b).Magnitude end

-- teleport spam function (Cancelable)
local function teleportSpam(pos, count, totalTime)
    count = count or TELEPORT_SPAM_COUNT
    totalTime = totalTime or TELEPORT_SPAM_TIME
    local hrp = getHRP()
    local myToken = movementToken

    local interval = totalTime / math.max(1, count)
    local elapsed = 0
    local performed = 0
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
            elapsed = elapsed - interval
            performed = performed + 1
            hrp.CFrame = CFrame.new(pos)
            if performed >= count then
                conn:Disconnect()
                done = true
            end
        end
    end)

    -- wait until done or canceled
    while not done and myToken == movementToken do
        task.wait()
    end

    return myToken == movementToken
end

-- lunge thẳng theo quỹ đạo cố định (Cancelable)
local function lungeStraightTo(targetPos)
    local hrp = getHRP()
    local myToken = movementToken

    local startPos = hrp.Position
    local delta = targetPos - startPos
    local totalDist = delta.Magnitude
    if totalDist < 1 then return true end

    local direction = delta.Unit
    local duration = totalDist / LUNGE_SPEED
    local elapsed = 0

    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if myToken ~= movementToken then
            conn:Disconnect()
            return
        end

        elapsed = elapsed + dt
        local alpha = math.clamp(elapsed / duration, 0, 1)
        local newPos = startPos + direction * (totalDist * alpha)
        hrp.CFrame = CFrame.new(newPos)

        if alpha >= 1 then
            conn:Disconnect()
        end
    end)

    -- wait until finished or canceled
    while movementToken == myToken and elapsed < duration do
        task.wait()
    end
    return movementToken == myToken
end

-- ========== UI helpers & states ==========
local TweenInfoShort = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TweenInfoFast = TweenInfo.new(0.12, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

-- store per-button hover connections to disable later
local hoverConns = {}
local inputConns = {}

local function setDefaultEffectState(effect)
    -- effect: Frame "Effect" under a button
    if not effect then return end
    local uiGrad = effect:FindFirstChildOfClass("UIGradient")
    local cancelBtn = effect:FindFirstChild("CancelButton")
    local nameLbl = effect:FindFirstChild("Name")
    local ratioLbl = effect:FindFirstChild("Ratio")
    local loading = effect:FindFirstChild("Loading")
    local loadFrame = loading and loading:FindFirstChild("LoadFrame")

    if uiGrad then
        -- try set Offset to NumberRange(0,1) if property exists
        pcall(function() uiGrad.Offset = NumberRange.new(0,1) end)
    end
    if cancelBtn then cancelBtn.Visible = false end
    if nameLbl then nameLbl.TextTransparency = 1 end
    if ratioLbl then ratioLbl.Visible = false; ratioLbl.TextTransparency = 0 end
    if loading then loading.Visible = false end
    if loadFrame then loadFrame.Size = LOADFRAME_ZERO end
end

local function tweenGradientOffset(uiGrad, fromLow, fromHigh, toLow, toHigh, time)
    if not uiGrad then return end
    local ok, _ = pcall(function()
        -- attempt to tween Offset as NumberRange property
        TweenService:Create(uiGrad, TweenInfo.new(time or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Offset = NumberRange.new(toLow, toHigh) }):Play()
    end)
    if not ok then
        -- fallback: try tweening Rotation slightly to simulate effect
        pcall(function()
            TweenService:Create(uiGrad, TweenInfo.new(time or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Rotation = (toLow - toHigh) * 180 }):Play()
        end)
    end
end

-- enable hover for a button (mouse enter/leave + touch)
local function enableHover(button, effect)
    if not button or not effect then return end
    local uiGrad = effect:FindFirstChildOfClass("UIGradient")
    local nameLbl = effect:FindFirstChild("Name")
    local active = true

    local function onEnter()
        if not active then return end
        tweenGradientOffset(uiGrad, 0,1, 0,0, 0.18)
        if nameLbl then TweenService:Create(nameLbl, TweenInfoShort, { TextTransparency = 0 }):Play() end
    end
    local function onLeave()
        if not active then return end
        tweenGradientOffset(uiGrad, 0,0, 0,1, 0.18)
        if nameLbl then TweenService:Create(nameLbl, TweenInfoShort, { TextTransparency = 1 }):Play() end
    end

    -- MouseEnter / MouseLeave (desktop)
    local enterConn, leaveConn = nil, nil
    if button.MouseEnter then
        enterConn = button.MouseEnter:Connect(onEnter)
        leaveConn = button.MouseLeave:Connect(onLeave)
    end

    -- Touch / Input (mobile)
    local ibegin, iend
    ibegin = button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            onEnter()
        end
    end)
    iend = button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            onLeave()
        end
    end)

    hoverConns[button] = { enterConn, leaveConn }
    inputConns[button] = { ibegin, iend }

    -- return a function to disable hover for this button
    return function()
        active = false
        if enterConn then enterConn:Disconnect() end
        if leaveConn then leaveConn:Disconnect() end
        if ibegin then ibegin:Disconnect() end
        if iend then iend:Disconnect() end
    end
end

-- reset all buttons to default and (re)enable hover
local hoverDisablers = {}
local function resetAllButtons()
    -- clear previous disablers
    for _, d in pairs(hoverDisablers) do if type(d) == "function" then d() end end
    hoverDisablers = {}

    for _, btn in ipairs(buttons) do
        local effect = btn:FindFirstChild("Effect")
        setDefaultEffectState(effect)
        local dis = enableHover(btn, effect)
        table.insert(hoverDisablers, dis)
    end
end

-- call once to init states
resetAllButtons()

-- ========== Animation cycling helper ==========
local function playAnimationCycle(loadFrame, animFolder, stopSignal)
    -- loadFrame: destination (Frame)
    -- animFolder: folder containing Animation1..Animation5 children (ImageLabel or Frame)
    -- stopSignal: function() -> boolean (true when should stop)
    local anims = {}
    for i=1,999 do
        local name = "Animation"..i
        local a = animFolder:FindFirstChild(name)
        if not a then break end
        table.insert(anims, a)
    end
    if #anims == 0 then return end

    local idx = 1
    local interval = 1 / ANIM_FPS
    local running = true

    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if stopSignal() then
            conn:Disconnect()
            return
        end
    end)

    -- main cycle (use task.spawn to control creation timing)
    task.spawn(function()
        while not stopSignal() do
            -- clear previous children
            for _, c in ipairs(loadFrame:GetChildren()) do
                c:Destroy()
            end
            -- clone current anim element into loadFrame
            local src = anims[idx]
            if src then
                local clone = src:Clone()
                clone.Parent = loadFrame
                clone.AnchorPoint = Vector2.new(0.5,0.5)
                clone.Position = UDim2.new(0.5,0.5,0.5,0)
                clone.Size = UDim2.new(1,0,1,0)
            end

            task.wait(interval)
            idx = idx + 1
            if idx > #anims then idx = 1 end
        end
        -- cleanup
        for _, c in ipairs(loadFrame:GetChildren()) do c:Destroy() end
    end)
end

-- ========== Core click handler ==========
local function handleButtonClick(button)
    -- disable all hovers
    for _, dis in ipairs(hoverDisablers) do if type(dis) == "function" then dis() end end
    hoverDisablers = {}

    -- find effect elements
    local effect = button:FindFirstChild("Effect")
    if not effect then
        warn("Button thiếu Effect:", button.Name)
        resetAllButtons()
        return
    end
    local cancelBtn = effect:FindFirstChild("CancelButton")
    local nameLbl = effect:FindFirstChild("Name")
    local ratioLbl = effect:FindFirstChild("Ratio")
    local loading = effect:FindFirstChild("Loading")
    local loadFrame = loading and loading:FindFirstChild("LoadFrame")
    local uiGrad = effect:FindFirstChildOfClass("UIGradient")

    -- pick target from mapping
    local target = TARGET_POSITIONS[button.Name]
    if not target then
        warn("Chưa định nghĩa TARGET_POSITION cho button:", button.Name)
        resetAllButtons()
        return
    end

    -- prepare UI: set gradient to out-of-view (Offset -> 0,-1), show Ratio, Cancel, Loading visible
    pcall(function()
        tweenGradientOffset(uiGrad, 0,0, 0,-1, 0.18)
        if nameLbl then TweenService:Create(nameLbl, TweenInfoShort, { TextTransparency = 0 }):Play() end
        if ratioLbl then ratioLbl.Visible = true end
        if cancelBtn then cancelBtn.Visible = true end
        if loading then loading.Visible = true end
    end)

    -- ensure loadFrame start at zero
    if loadFrame then loadFrame.Size = LOADFRAME_ZERO end

    -- cancel handler
    local cancelled = false
    local function doCancel()
        cancelled = true
        stopMovement()
    end
    if cancelBtn then
        local conn
        conn = cancelBtn.Activated:Connect(function()
            doCancel()
            if conn then conn:Disconnect() end
        end)
    end

    -- movement + progress logic
    stopMovement()
    local hrp = getHRP()
    local startPos = hrp.Position
    local totalDist = math.max(0.0001, distance(startPos, target))

    -- decide teleport
    local bestTeleport = nil
    if TELEPORT_POINTS and #TELEPORT_POINTS > 0 then
        -- choose best teleport point (reuse earlier logic)
        local bestDist, bestP = math.huge, nil
        for _, p in ipairs(TELEPORT_POINTS) do
            local d = distance(p, target)
            if d < bestDist then bestDist = d; bestP = p end
        end
        if bestP and distance(startPos, target) > bestDist then
            bestTeleport = bestP
        end
    end

    local token = movementToken

    -- function to update progress UI given progress in [0,1]
    local function updateProgress(alpha)
        if loadFrame then
            local size = UDim2.new(alpha,0,1,0)
            TweenService:Create(loadFrame, TweenInfo.new(0.08, Enum.EasingStyle.Linear), { Size = size }):Play()
        end
        if ratioLbl then
            local pct = math.floor(alpha * 100 + 0.5)
            ratioLbl.Text = tostring(pct).."%"
        end
    end

    -- run animation cycling concurrently; stopSignal checks cancelled or movementToken changed
    local function stopSignal()
        return cancelled or movementToken ~= token
    end
    if loading and loadFrame then
        -- start animation cycle
        playAnimationCycle(loadFrame, animationFolder, stopSignal)
    end

    -- if have teleport, do teleportSpam; each teleport spam step may change remaining distance -> update progress accordingly
    if bestTeleport and not cancelled then
        -- teleport spam
        local succeeded = teleportSpam(bestTeleport, TELEPORT_SPAM_COUNT, TELEPORT_SPAM_TIME)
        if not succeeded then
            -- cancelled during teleport
            cancelled = true
        else
            -- after spam, teleport above
            if not cancelled then
                getHRP().CFrame = CFrame.new(bestTeleport + Vector3.new(0, TELEPORT_HEIGHT, 0))
            end
        end
    end

    -- update baseline after any teleport
    if cancelled then
        -- restore UI and return
        stopMovement()
        task.delay(0.05, resetAllButtons)
        return
    end

    -- start lunge but while lunge runs update progress based on remaining distance
    -- We'll run lunge in a cancellable manner and concurrently update progress in RenderStepped
    stopMovement() -- ensure clear
    token = movementToken
    local hr = getHRP()
    local startPos2 = hr.Position
    local initialDist = math.max(0.0001, distance(startPos2, target))

    -- spawn progress updater
    local progressConn
    progressConn = RunService.RenderStepped:Connect(function()
        if movementToken ~= token then
            progressConn:Disconnect()
            return
        end
        local rem = distance(hr.Position, target)
        local alpha = math.clamp(1 - (rem / initialDist), 0, 1)
        updateProgress(alpha)
    end)

    -- perform lunge (blocking until done or cancelled)
    local lungeOk = lungeStraightTo(target)
    -- ensure progress final
    updateProgress(1)

    if progressConn and progressConn.Connected then progressConn:Disconnect() end

    -- done or cancelled -> cleanup and restore UI
    task.delay(0.05, function()
        -- stop animation (playAnimationCycle checks movementToken)
        stopMovement() -- bump token to ensure anim stops
        -- small delay to allow animation loop cleanup
        task.wait(0.05)
        -- restore UI state for this button
        setDefaultEffectState(effect)
        -- re-enable hovers for all buttons
        resetAllButtons()
    end)
end

-- attach click handlers to all buttons
for _, btn in ipairs(buttons) do
    -- ensure effect exists and default state
    local effect = btn:FindFirstChild("Effect")
    setDefaultEffectState(effect)
    -- enable hover
    local dis = enableHover(btn, effect)
    table.insert(hoverDisablers, dis)

    -- click
    btn.Activated:Connect(function()
        handleButtonClick(btn)
    end)
end

-- done
print("[BringUI] Ready. Buttons count:", #buttons)
