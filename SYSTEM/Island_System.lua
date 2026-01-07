-- UI + Movement integrated controller
-- Đặt file này vào nơi chạy client; yêu cầu GUI cấu trúc theo mô tả:
-- PlayerGui > BloxFruitHubGui > Main > ScrollingTab > Island
-- Trong Island: Folder Sea1, Sea2, Sea3, AnimationUI( chứa Animation1..5 image labels )
-- Trong mỗi SeaX folder: nhiều Button; mỗi Button có child "Effect" theo mô tả

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ================= SETTINGS (chỉnh ở đây) =================
local LUNGE_SPEED = 300
local TELEPORT_HEIGHT = 100
local TELEPORT_SPAM_COUNT = 10
local TELEPORT_SPAM_TIME = 1.5
local ANIMATION_FPS = 7               -- 7 animation changes / second
local LOADFRAME_FULL_SIZE = UDim2.new(1,0,1,0)
local LOADFRAME_EMPTY_SIZE = UDim2.new(0,0,1,0)

-- Map ButtonName -> target Vector3 (bạn sửa/ thêm ở đây)
local BUTTON_TARGETS = {
    ["ButtonA"] = Vector3.new(-4992.52, 357.78, -3051.24),
    -- ["YourButtonName"] = Vector3.new(x,y,z),
}

-- Place -> points (giữ nguyên hoặc sửa)
local PLACES = {
    Sea1 = { ids = {85211729168715,2753915549}, points = { } },
    Sea2 = { ids = {79091703265657,4442272183}, points = { } },
    Sea3 = { ids = {7449423635,100117331123089}, points = { } },
    Dungeon = { ids = {73902483975735}, points = { } },
}
-- ================= end settings =================

-- movement token để hủy mọi tiến trình
local movementToken = 0

-- ---------- helpers movement (tái sử dụng từ module trước) ----------
local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function distance(a,b) return (a-b).Magnitude end

-- teleport spam (cancellable)
local function teleportSpam(pos)
    local hrp = getHRP()
    local myToken = movementToken

    local count = 0
    local interval = TELEPORT_SPAM_TIME / math.max(1, TELEPORT_SPAM_COUNT)
    local elapsed = 0
    local done = false

    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if myToken ~= movementToken then conn:Disconnect(); done = true; return end
        elapsed += dt
        if elapsed >= interval then
            elapsed = elapsed - interval
            count += 1
            hrp.CFrame = CFrame.new(pos)
            if count >= TELEPORT_SPAM_COUNT then conn:Disconnect(); done = true; end
        end
    end)

    -- wait for completion or cancellation
    while not done and myToken == movementToken do task.wait() end
    return myToken == movementToken
end

-- teleport instant
local function teleport(pos)
    getHRP().CFrame = CFrame.new(pos)
end

-- lunge straight (fixed direction from start), cancellable
local function lungeTo(targetPos)
    local hrp = getHRP()
    local myToken = movementToken

    local startPos = hrp.Position
    local delta = targetPos - startPos
    local dist = delta.Magnitude
    if dist <= 1 then return true end

    local dir = delta.Unit
    local duration = dist / LUNGE_SPEED
    if duration <= 0 then return true end

    local elapsed = 0
    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if myToken ~= movementToken then conn:Disconnect(); return end
        elapsed += dt
        local alpha = math.clamp(elapsed / duration, 0, 1)
        hrp.CFrame = CFrame.new(startPos + dir * (dist * alpha))
        if alpha >= 1 then conn:Disconnect() end
    end)

    -- wait until finish or canceled
    while conn.Connected and myToken == movementToken do task.wait() end
    return myToken == movementToken
end

local function stopMovement()
    movementToken = movementToken + 1
end

-- ---------- UI helpers ----------
local function findDescendantByName(parent, name)
    for _,v in ipairs(parent:GetDescendants()) do
        if v.Name == name then return v end
    end
    return nil
end

local function tween(obj, props, t, style, dir)
    local info = TweenService:Create(obj, TweenInfo.new(t or 0.25, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
    info:Play()
    return info
end

-- ---------- locate GUI ----------
local ok, islandRoot = pcall(function()
    return player.PlayerGui:WaitForChild("BloxFruitHubGui",5):WaitForChild("Main",5):WaitForChild("ScrollingTab",5):WaitForChild("Island",1)
end)
if not ok or not islandRoot then
    warn("Không tìm thấy Island Frame trong GUI")
    return
end

local animationFolder = islandRoot:FindFirstChild("AnimationUI", true)
local seaFolders = {}
for _,name in ipairs({"Sea1","Sea2","Sea3"}) do
    local f = islandRoot:FindFirstChild(name, true)
    if f then seaFolders[name] = f end
end

-- map PlaceId -> active folder (Sea1/2/3)
local function getActiveSeaFolder()
    local pid = game.PlaceId
    for name, data in pairs(PLACES) do
        for _, id in ipairs(data.ids) do
            if id == pid then
                return seaFolders[name], name
            end
        end
    end
    -- fallback: pick first existing Sea folder
    for name,f in pairs(seaFolders) do return f, name end
    return nil, nil
end

local activeFolder, activeGroupName = getActiveSeaFolder()
if not activeFolder then warn("Không tìm thấy Sea folder tương ứng") end

-- Build a map of button -> target pos
local BUTTON_TARGETS = {} -- will be filled by user targets merged with defaults
for btnName, pos in pairs(BUTTON_TARGETS) do -- keep user-provided (if any)
    BUTTON_TARGETS[btnName] = pos
end
-- We also allow the earlier global BUTTON_TARGETS (from settings) — if user filled both, they can adjust.

-- collect buttons in activeFolder
local buttons = {}
for _, child in ipairs(activeFolder:GetDescendants()) do
    if child:IsA("TextButton") or child:IsA("ImageButton") then
        table.insert(buttons, child)
    end
end

-- default-initialize each button's effect children
local hoverConnections = {} -- store connections for possible disconnect
local function setDefaultsForButton(btn)
    local effect = btn:FindFirstChild("Effect")
    if not effect then return end

    local uiGrad = effect:FindFirstChildOfClass("UIGradient")
    local loading = effect:FindFirstChild("Loading")
    local cancelBtn = effect:FindFirstChild("CancelButton")
    local nameLbl = effect:FindFirstChild("Name")
    local ratioLbl = effect:FindFirstChild("Ratio")
    local loadFrame = loading and loading:FindFirstChild("LoadFrame")

    -- default states requested
    if uiGrad then uiGrad.Offset = NumberRange.new(0,1) end
    if cancelBtn then cancelBtn.Visible = false end
    if nameLbl then nameLbl.TextTransparency = 1 end
    if ratioLbl then ratioLbl.Visible = false; ratioLbl.TextTransparency = 0 end
    if loading then loading.Visible = false end
    if loadFrame then loadFrame.Size = LOADFRAME_EMPTY_SIZE end
end

for _,b in ipairs(buttons) do setDefaultsForButton(b) end

-- helper to clone animation content into a container (deep clone of ImageLabel and its children)
local function cloneAnimation(label)
    if not label then return nil end
    local copy = label:Clone()
    copy.Parent = nil
    -- ensure it's clean sized to fit
    copy.Size = UDim2.new(1,0,1,0)
    copy.Position = UDim2.new(0,0,0,0)
    return copy
end

-- load animation references (Animation1..5 ImageLabels)
local animationTemplates = {}
if animationFolder then
    for i=1,5 do
        local name = "Animation"..tostring(i)
        local template = animationFolder:FindFirstChild(name, true) or animationFolder:FindFirstChild(name)
        if template and template:IsA("ImageLabel") then
            animationTemplates[#animationTemplates+1] = template
        end
    end
end

-- hover behavior (supports mouse + touch via InputBegan/Ended)
local function attachHoverHandlers(btn)
    local effect = btn:FindFirstChild("Effect")
    if not effect then return end
    local uiGrad = effect:FindFirstChildOfClass("UIGradient")
    local nameLbl = effect:FindFirstChild("Name")

    local active = true -- allow disabling hover during click
    local c1, c2

    local function onEnter()
        if not active then return end
        if uiGrad then tween(uiGrad, { Offset = NumberRange.new(0,0) }, 0.18) end
        if nameLbl then tween(nameLbl, { TextTransparency = 0 }, 0.18) end
    end
    local function onLeave()
        if not active then return end
        if uiGrad then tween(uiGrad, { Offset = NumberRange.new(0,1) }, 0.18) end
        if nameLbl then tween(nameLbl, { TextTransparency = 1 }, 0.18) end
    end

    -- InputBegan/Ended covers mouse and touch (touch InputBegan = Touch)
    c1 = btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            onEnter()
        end
    end)
    c2 = btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            onLeave()
        end
    end)

    hoverConnections[btn] = { enter = c1, leave = c2, disable = function() active = false end, enable = function() active = true end }
end

for _,b in ipairs(buttons) do attachHoverHandlers(b) end

-- cleanup animation children in loadFrame
local function clearLoadFrame(loadFrame)
    if not loadFrame then return end
    for _,c in ipairs(loadFrame:GetChildren()) do
        c:Destroy()
    end
end

-- animate load + progress + animation cycling; cancellable via movementToken
-- returns true if completed (not canceled), false if canceled
local function runLoadingSequence(effect, startDist, targetPos)
    if not effect then return false end
    local loading = effect:FindFirstChild("Loading")
    local loadFrame = loading and loading:FindFirstChild("LoadFrame")
    local ratioLbl = effect:FindFirstChild("Ratio")
    local cancelBtn = effect:FindFirstChild("CancelButton")
    local uiGrad = effect:FindFirstChildOfClass("UIGradient")
    local nameLbl = effect:FindFirstChild("Name")

    if not loading or not loadFrame or not ratioLbl or not cancelBtn then return false end

    -- show UI elements
    loading.Visible = true
    cancelBtn.Visible = true
    ratioLbl.Visible = true
    if uiGrad then tween(uiGrad, { Offset = NumberRange.new(0,-1) }, 0.25) end
    if nameLbl then tween(nameLbl, { TextTransparency = 0 }, 0.25) end

    -- animation cycling: clone templates into loadFrame one at a time at ANIMATION_FPS
    local animInterval = 1 / ANIMATION_FPS
    local animIndex = 1
    local animCount = #animationTemplates

    -- prepare timing for progress calculation
    local hrp = getHRP()
    local myToken = movementToken
    local initDist = startDist
    if initDist <= 0 then initDist = 1 end

    -- start a heartbeat loop to update progress and swap animations
    local done = false
    local canceled = false
    local animElapsed = 0
    local elapsed = 0

    -- ensure loadFrame empty initially
    clearLoadFrame(loadFrame)
    loadFrame.Size = LOADFRAME_EMPTY_SIZE

    -- show first animation immediately if exists
    if animCount > 0 then
        local tpl = animationTemplates[animIndex]
        local add = cloneAnimation(tpl)
        add.Parent = loadFrame
    end

    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if myToken ~= movementToken then
            canceled = true
            conn:Disconnect()
            return
        end

        -- update animation swap
        animElapsed += dt
        if animElapsed >= animInterval and animCount > 0 then
            animElapsed = animElapsed - animInterval
            animIndex = animIndex + 1
            if animIndex > animCount then animIndex = 1 end
            clearLoadFrame(loadFrame)
            local add = cloneAnimation(animationTemplates[animIndex])
            if add then add.Parent = loadFrame end
        end

        -- update progress ratio based on remaining distance to target
        local curDist = distance(hrp.Position, targetPos)
        local ratio = math.clamp(1 - (curDist / initDist), 0, 1)
        if ratioLbl then ratioLbl.Text = tostring(math.floor(ratio * 100)) .. "%" end

        -- tween loadFrame size smoothly toward ratio
        local targetSize = UDim2.new(ratio, 0, 1, 0)
        -- do a short tween every frame for smoothness (or set LERP)
        loadFrame.Size = loadFrame.Size:Lerp(targetSize, math.clamp(dt * 10, 0, 1))

        -- finish condition: near target
        if curDist <= 2 then
            done = true
            conn:Disconnect()
            return
        end
    end)

    -- wait until done or canceled
    while not done and not canceled and myToken == movementToken do
        task.wait()
    end

    -- cleanup
    clearLoadFrame(loadFrame)
    loading.Visible = false
    cancelBtn.Visible = false
    ratioLbl.Visible = false
    -- restore gradient and name
    if uiGrad then tween(uiGrad, { Offset = NumberRange.new(0,1) }, 0.18) end
    if nameLbl then tween(nameLbl, { TextTransparency = 1 }, 0.18) end

    return not canceled
end

-- When click a button: run full process for its target
local function onButtonActivated(btn)
    -- find effect and children
    local effect = btn:FindFirstChild("Effect")
    if not effect then return end
    local cancelBtn = effect:FindFirstChild("CancelButton")
    local ratioLbl = effect:FindFirstChild("Ratio")
    local loading = effect:FindFirstChild("Loading")

    -- get target pos from mapping (user must add to BUTTON_TARGETS)
    local targetPos = BUTTON_TARGETS[btn.Name]
    if not targetPos then
        warn("No target assigned for button:", btn.Name)
        return
    end

    -- disable hover for this button while active
    local h = hoverConnections[btn]
    if h and h.disable then h.disable() end

    -- stop previous movements
    stopMovement()

    -- compute start distance
    local hrp = getHRP()
    local startDist = distance(hrp.Position, targetPos)

    -- pick best teleport (reuse TELEPORT_POINTS selection)
    -- simple heuristic: find teleport nearest to target from TELEPORT_POINTS (if any)
    local bestTeleport = nil
    local bestDist = math.huge
    if PLACES and type(PLACES) == "table" then
        -- find active place's teleport list (we used earlier TELEPORT_POINTS concept)
        -- here we search islandRoot folders for points not defined; for simplicity assume global TELEPORT_POINTS not used
        -- So we fallback to no teleport if none provided
    end
    -- You can populate TELEPORT_POINTS table in settings scope if you want teleport support here.
    -- For now we only perform lunge if no teleport chosen.

    -- If there's a teleport system available (global TELEPORT_POINTS), pick best:
    if rawget(_G, "TELEPORT_POINTS") and type(_G.TELEPORT_POINTS) == "table" and #_G.TELEPORT_POINTS > 0 then
        for _,p in ipairs(_G.TELEPORT_POINTS) do
            local d = distance(p, targetPos)
            if d < bestDist then bestDist = d; bestTeleport = p end
        end
        if bestTeleport and distance(hrp.Position, targetPos) <= bestDist then
            bestTeleport = nil
        end
    end

    -- If user wants the built-in behavior where TELEPORT_POINTS local variable used:
    if bestTeleport == nil and _G and rawget(_G, "TELEPORT_POINTS_LOCAL") then
        local tpts = _G.TELEPORT_POINTS_LOCAL
        if type(tpts) == "table" and #tpts>0 then
            for _,p in ipairs(tpts) do
                local d = distance(p, targetPos)
                if d < bestDist then bestDist = d; bestTeleport = p end
            end
            if bestTeleport and distance(hrp.Position, targetPos) <= bestDist then bestTeleport = nil end
        end
    end

    -- If found teleport, perform teleport spam then teleport up
    if bestTeleport then
        local ok = teleportSpam(bestTeleport)
        if not ok then
            -- canceled
            if h and h.enable then h.enable() end
            return
        end
        teleport(bestTeleport + Vector3.new(0, TELEPORT_HEIGHT, 0))
        task.wait(0.05)
    end

    -- Now run loading sequence which shows progress and animations and also watches for cancel
    -- Hook CancelButton
    local cancelConn
    local userCanceled = false
    if cancelBtn then
        cancelConn = cancelBtn.Activated:Connect(function()
            userCanceled = true
            stopMovement()
        end)
    end

    local finished = runLoadingSequence(effect, startDist, targetPos)

    if cancelConn then
        cancelConn:Disconnect()
    end

    if not finished then
        -- canceled
        if h and h.enable then h.enable() end
        return
    end

    -- finally perform lunge (cancellable)
    local ok = lungeTo(targetPos)
    -- restore hover
    if h and h.enable then h.enable() end
    return ok
end

-- wire button Activated handlers
for _,btn in ipairs(buttons) do
    -- ensure default
    setDefaultsForButton(btn)

    -- connect click
    btn.Activated:Connect(function()
        -- guard: if already in progress for this button, ignore (optional)
        onButtonActivated(btn)
    end)
end

-- END OF SCRIPT
