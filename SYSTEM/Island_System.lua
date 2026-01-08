local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- ===== GET UI ROOT SAFELY (StarterPlayerScripts safe) =====
local playerGui = player:WaitForChild("PlayerGui")

local ROOT = playerGui
    :WaitForChild("BloxFruitHubGui")
    :WaitForChild("Main")
    :WaitForChild("ScrollingTab")
    :WaitForChild("Island")

-- ============== SETTINGS (tùy chỉnh) =================
local LUNGE_SPEED = 300
local TELEPORT_HEIGHT = 100
local TELEPORT_SPAM_COUNT = 10
local TELEPORT_SPAM_TIME = 1.5
local ANIM_FPS = 7 -- 7 animations / second
-- ====================================================

-- ============== PLACE DATA (kế thừa từ script cũ) =========
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

-- 🔹 Lấy teleportPoints theo PlaceId (giữ giống script cũ)
local TELEPORT_POINTS = {}

do
    local placeId = game.PlaceId

    for _, data in pairs(PLACES) do
        if table.find(data.ids, placeId) then
            TELEPORT_POINTS = data.points or {}
            break
        end
    end

    if #TELEPORT_POINTS == 0 then
        warn("PlaceID không thuộc Sea1 / Sea2 / Sea3 / Dungeon (hoặc không có points).")
    end
end
-- ============================================

-- ====== FILTER UI FOLDERS THEME-BASED ON PlaceId ======

local function detectPlaceKey()
    local pid = game.PlaceId
    for key, data in pairs(PLACES) do
        if table.find(data.ids, pid) then
            return key -- "Sea1" / "Sea2" / "Sea3" / "Dungeon"
        end
    end
    return nil
end

local PLACE_KEY = detectPlaceKey()

-- Nếu PLACE_KEY nil -> không xóa gì
if PLACE_KEY then
    local toRemove = {}

    if PLACE_KEY == "Sea1" then
        toRemove = { "Sea2", "Sea3" }
    elseif PLACE_KEY == "Sea2" then
        toRemove = { "Sea1", "Sea3" }
    elseif PLACE_KEY == "Sea3" then
        toRemove = { "Sea1", "Sea2" }
    elseif PLACE_KEY == "Dungeon" then
        toRemove = { "Sea1", "Sea2", "Sea3" }
    end

    for _, name in ipairs(toRemove) do
        local f = ROOT:FindFirstChild(name)
        if f and f.Parent then
            -- pcall để tránh lỗi nếu bị thay đổi trong runtime
            pcall(function() f:Destroy() end)
        end
    end
end
-- =======================================================

-- ============== UI selection (giữ như hiện tại) =================
local function getActiveSeaFolder()
    local pid = game.PlaceId
    for seaName, data in pairs(PLACES) do
        if table.find(data.ids, pid) then
            local folder = ROOT:FindFirstChild(seaName)
            if folder then return folder, seaName end
        end
    end
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
    warn("Không tìm thấy AnimationUI (Animation1..Animation5).")
    return
end

-- ============== MAPPING BUTTON NAME ==========
local BUTTON_TARGETS = {
    ["Port Town"] = Vector3.new(-444.92, 108.57, 5926.82),
    ["Hydra Island"] = Vector3.new(5293.66, 1032.16, 368.10),
    ["Great Tree"] = Vector3.new(2850.98, 513.49, -7228.15),
    ["Mansion"] = Vector3.new(-12540.31, 381.95, -7516.82),
    ["Haunted Castle"] = Vector3.new(-9516.39, 153.77, 5510.51),
    ["IcecreamLand"] = Vector3.new(-740.71, 212.90, -10947.48),
    ["CakeLand"] = Vector3.new(-2101.58, 69.98, -12113.61),
    ["CandyLand"] = Vector3.new(-1093.69, 62.86, -14508.86),
    ["Tiki Outpost"] = Vector3.new(-16230.67, 10, 436.11),
    ["Submerged Island"] = Vector3.new(11520.80, -2125.80, 9829.51),
    ["Temple of Time"] = Vector3.new(28388.48, 14903.01, 104.86),
    ["Dojo"] = Vector3.new(5705.36, 1207.08, 916.71),
    ["Castle on the Sea"] = Vector3.new(-4992.52, 357.78, -3051.24),
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

-- 🔹 Chọn teleport point tối ưu (theo script cũ)
local function getBestTeleportPoint(fromPos, targetPos)
    local bestPoint, bestDist = nil, math.huge

    for _, p in ipairs(TELEPORT_POINTS) do
        local d = vecDistance(p, targetPos)
        if d < bestDist then
            bestDist = d
            bestPoint = p
        end
    end

    if not bestPoint then return nil end
    if vecDistance(fromPos, targetPos) <= bestDist then
        return nil
    end

    return bestPoint
end

local function teleport(pos)
    getHRP().CFrame = CFrame.new(pos)
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

local function toXZ(pos, fixedY)
    return Vector3.new(pos.X, fixedY, pos.Z)
end

local function xzDistance(a, b)
    return (Vector3.new(a.X, 0, a.Z) - Vector3.new(b.X, 0, b.Z)).Magnitude
end

-- lungeTo that yields until finished or cancelled (giữ như cũ)
local function lungeTo(targetPos)
    local hrp = getHRP()
    local myToken = movementToken

    -- FIX Y ngay lập tức
    local fixedY = targetPos.Y
    local startPos = toXZ(hrp.Position, fixedY)
    local endPos = toXZ(targetPos, fixedY)

    hrp.CFrame = CFrame.new(startPos)

    local delta = endPos - startPos
    local distance = xzDistance(startPos, endPos)
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

        elapsed += dt
        local alpha = math.clamp(elapsed / duration, 0, 1)

        local pos = startPos + direction * (distance * alpha)
        hrp.CFrame = CFrame.new(pos)

        if alpha >= 1 then
            conn:Disconnect()
            finished = true
        end
    end)

    while not finished and myToken == movementToken do
        task.wait()
    end

    return myToken == movementToken
end

local function stopMovement()
    movementToken = movementToken + 1
end

-- executes teleport + lunge -> yields until done or cancelled
-- NOTE: caller should set movementToken to a new token before calling (so cancellation works predictably)
local function executeMovementTo(targetPos)
    -- do not call stopMovement() here — caller will create the token
    local myToken = movementToken
    local hrp = getHRP()

    -- pick best teleport point if available
    local bestTeleport = getBestTeleportPoint(hrp.Position, targetPos)
    if bestTeleport then
        local ok = teleportSpam(bestTeleport)
        if not ok or movementToken ~= myToken then return false end

        teleport(bestTeleport + Vector3.new(0, TELEPORT_HEIGHT, 0))
        task.wait(0.05)
        if movementToken ~= myToken then return false end
    end

    -- if no bestTeleport found, we will lunge directly
    local ok2 = lungeTo(targetPos)
    return ok2 and movementToken == myToken
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

local function colorFromProgress(p)
    return Color3.fromRGB(
        math.floor(255 * (1 - p)),
        math.floor(255 * p),
        0
    )
end

-- ============== Animation loader inside LoadFrame ===========================
local function playAnimationsInLoadFrame(loadFrame, stopFlag)
    if not ANIMATION_UI_FOLDER or not loadFrame then return end

    local animations = {}
    for i = 1, 5 do
        local anim = ANIMATION_UI_FOLDER:FindFirstChild("Animation"..i)
        if anim then
            table.insert(animations, anim)
        end
    end
    if #animations == 0 then return end

    local interval = 1 / ANIM_FPS
    local running = true

    -- clear loadFrame (giữ constraint của chính LoadFrame nếu có)
    for _, c in ipairs(loadFrame:GetChildren()) do
        c:Destroy()
    end

    task.spawn(function()
        local idx = 1
        while running and not stopFlag.cancelled do
            -- clear frame
            for _, c in ipairs(loadFrame:GetChildren()) do
                c:Destroy()
            end

            local src = animations[idx]
            local clone = src:Clone()
            clone.Parent = loadFrame

            idx += 1
            if idx > #animations then idx = 1 end

            local t = 0
            while t < interval do
                if stopFlag.cancelled then break end
                task.wait(0.01)
                t += 0.01
            end
        end

        -- cleanup
        for _, c in ipairs(loadFrame:GetChildren()) do
            c:Destroy()
        end
    end)

    return function()
        running = false
    end
end
-- ============================================================================

-- ============== Main wiring: set defaults and attach events =================
local hoverConnections = {}
local interactionLocked = false

for _, btn in ipairs(ACTIVE_FOLDER:GetChildren()) do
    if btn:IsA("GuiButton") or btn:IsA("ImageButton") or btn:IsA("TextButton") then
        pcall(setButtonDefaults, btn)
    end
end

for _, btn in ipairs(ACTIVE_FOLDER:GetChildren()) do
    if not (btn:IsA("GuiButton") or btn:IsA("ImageButton") or btn:IsA("TextButton")) then
        continue
    end

    local parts = getEffectParts(btn)
    if not parts then continue end

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

    enterConn = btn.MouseEnter:Connect(onEnter)
    leaveConn = btn.MouseLeave:Connect(onLeave)

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

    clickConn = btn.Activated:Connect(function()
        if interactionLocked then return end
        interactionLocked = true

        if parts.Name then
            parts.Name.TextTransparency = 1
        end

        local target = BUTTON_TARGETS[btn.Name]
        if not target then
            warn("TARGET not set for button:", btn.Name)
            interactionLocked = false
            return
        end

        for _, other in ipairs(ACTIVE_FOLDER:GetChildren()) do
            if (other:IsA("GuiButton") or other:IsA("TextButton") or other:IsA("ImageButton")) then
                local p = getEffectParts(other)
                if p and p.UIGradient then
                    tween(p.UIGradient, {Offset = Vector2.new(0,-1)}, TweenInfo.new(0.12)):Play()
                end
            end
        end

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
            parts.LoadFrame.Size = UDim2.new(0,0,1,0)
        end
        if parts.UIGradient then
            tween(parts.UIGradient, {Offset = Vector2.new(0,-1)}, TweenInfo.new(0.12)):Play()
        end

        local stopFlag = { cancelled = false }
        local stopAnimFunc = playAnimationsInLoadFrame(parts.LoadFrame, stopFlag)

        -- create a fresh token for this run
        local myToken = movementToken + 1
        movementToken = myToken

        local fixedY = target.Y
        local startXZ = toXZ(getHRP().Position, fixedY)
        local targetXZ = toXZ(target, fixedY)

        local totalDist = math.max(0.0001, xzDistance(startXZ, targetXZ))


        local progressConn
        progressConn = RunService.Heartbeat:Connect(function()
            if movementToken ~= myToken then
                progressConn:Disconnect()
                return
            end
            local curXZ = toXZ(getHRP().Position, fixedY)
            local prog = 1 - (xzDistance(curXZ, targetXZ) / totalDist)
            prog = math.clamp(prog, 0, 1)
            local pct = math.floor(prog * 100)
                    
            if parts.Ratio then
                parts.Ratio.Visible = true
                parts.Ratio.Text = pct .. "%"

                local targetColor = colorFromProgress(prog)
                TweenService:Create(
                    parts.Ratio,
                    TweenInfo.new(0.15, Enum.EasingStyle.Linear),
                    { TextColor3 = targetColor }
                ):Play()
            end
                    
            if parts.LoadFrame then
                pcall(function()
                    tween(parts.LoadFrame, {Size = UDim2.new(prog,0,1,0)}, TweenInfo.new(0.12)):Play()
                end)
            end
        end)

        local cancelPressed = false
        local function doCancel()
            if cancelPressed then return end
            cancelPressed = true
            stopFlag.cancelled = true
            stopMovement()
            if progressConn and progressConn.Connected then progressConn:Disconnect() end
            if stopAnimFunc then stopAnimFunc() end
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

        -- run movement using TELEPORT_POINTS logic
        local success = executeMovementTo(target)

        stopFlag.cancelled = stopFlag.cancelled or (movementToken ~= myToken) or (not success)
        if stopFlag.cancelled then
            doCancel()
            if cancelConn then cancelConn:Disconnect() end
            return
        end

        -- finished normally
        stopFlag.cancelled = true
        if stopAnimFunc then stopAnimFunc() end
        if progressConn and progressConn.Connected then progressConn:Disconnect() end

        task.wait(0.08)

        if parts.Ratio then
            parts.Ratio.Text = "100%"
            TweenService:Create(
                parts.Ratio,
                TweenInfo.new(0.15),
                { TextColor3 = Color3.fromRGB(0,255,0) }
            ):Play()
        end

        if parts.LoadFrame then
            tween(parts.LoadFrame, {Size = UDim2.new(1,0,1,0)}, TweenInfo.new(0.12)):Play()
        end

        task.wait(0.15)

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

    hoverConnections[btn] = {
        enter = enterConn,
        leave = leaveConn,
        inputBegan = inputBeganConn,
        inputEnded = inputEndedConn,
        click = clickConn,
    }
end

local function cleanup()
    for btn, conns in pairs(hoverConnections) do
        for k,v in pairs(conns) do
            if v and v.Connected then pcall(function() v:Disconnect() end) end
        end
    end
end

script.Destroying:Connect(cleanup)

print("Island UI controller initialized for folder:", ACTIVE_NAME)
print("Remember to populate BUTTON_TARGETS table in script with button.Name => Vector3 targets.")
