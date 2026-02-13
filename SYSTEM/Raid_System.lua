print("🟢🔴UPD AUTO DUNGEON P5🔴🟢")
--=== RAID ===================================================================================================================--

do
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")

    local player = Players.LocalPlayer

    -- WAIT for ToggleUI
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    ToggleUI.Refresh()

    local BUTTON_NAME = "AutoRaidButton"

    -- Find the new UI button: ScrollingTab -> Raid -> AutoRaidButton
    local ScrollingTab = player.PlayerGui:WaitForChild("BloxFruitHubGui"):WaitForChild("Main"):WaitForChild("ScrollingTab")
    local raidFrame = ScrollingTab:FindFirstChild("Raid", true)
    if not raidFrame then
        warn("Không tìm thấy Frame 'Raid' trong ScrollingTab")
        return
    end

    local button = raidFrame:FindFirstChild(BUTTON_NAME, true)
    if not button then
        warn("Không tìm thấy Button:", BUTTON_NAME)
        return
    end

    -- đảm bảo UI toggle khởi tạo OFF (gọi ToggleUI, không set trực tiếp)
    pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)

    -- helper: tìm UIStroke trong descendants
    local function findStroke(inst)
        for _, v in ipairs(inst:GetDescendants()) do
            if v:IsA("UIStroke") then return v end
        end
        return nil
    end

    local stroke = findStroke(button)

    -- màu mặc định (dự đoán red là trạng thái mặc định)
    local origBg = button.BackgroundColor3 or Color3.fromRGB(255, 50, 50)
    local origStroke = (stroke and stroke.Color) or Color3.fromRGB(255, 0, 0)
    local warnColor = Color3.fromRGB(255, 255, 0)

    -- trạng thái nội bộ
    local running = false
    local autoClicking = false
    _G.BringMobGate2 = false

    -- khóa/guard để chống spam
    local clickLock = false
    local animating = false

    -- các hàm từ script cũ (giữ lại logic xử lý raid)
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local anchor = nil
    local function ensureAnchor()
        if not anchor or not anchor.Parent then
            anchor = Instance.new("Part")
            anchor.Anchored = true
            anchor.CanCollide = false
            anchor.Transparency = 1
            anchor.Size = Vector3.new(1,1,1)
            anchor.CFrame = hrp.CFrame
            anchor.Parent = workspace
        end
        return anchor
    end

    local function getIslandCenter(model)
        if not model then return nil end
        local cf, size = model:GetBoundingBox()
        local center = cf.Position + Vector3.new(0, size.Y/2, 0)
        return center
    end

    local function hasIslandNearby()
        local map = workspace:FindFirstChild("Map")
        if not map then return false end
        local raidMap = map:FindFirstChild("RaidMap")
        if not raidMap then return false end

        for _, island in ipairs(raidMap:GetChildren()) do
            if island:IsA("Model") then
                local root = island.PrimaryPart or island:FindFirstChildWhichIsA("BasePart")
                if root and hrp then
                    if (hrp.Position - root.Position).Magnitude <= 4000 then
                        return true
                    end
                end
            end
        end
        return false
    end

    local function getHighestPriorityIsland()
        local map = workspace:FindFirstChild("Map")
        if not map then return nil end
        local raidMap = map:FindFirstChild("RaidMap")
        if not raidMap then return nil end

        local bestIsland = nil
        local bestPriority = -1

        for _, island in ipairs(raidMap:GetChildren()) do
            if island:IsA("Model") then
                local index = tonumber(island.Name:match("RaidIsland(%d+)"))
                if index then
                    local root = island.PrimaryPart or island:FindFirstChildWhichIsA("BasePart")
                    if root then
                        local dist = (hrp.Position - root.Position).Magnitude
                        if dist <= 3500 and index > bestPriority then
                            bestPriority = index
                            bestIsland = island
                        end
                    end
                end
            end
        end

        return bestIsland
    end

    local function getEnemiesNear(origin)
        local enemies = {}
        local folder = workspace:FindFirstChild("Enemies")
        if not folder then return enemies end
        for _, mob in ipairs(folder:GetChildren()) do
            if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") then
                local dist = (origin.Position - mob.HumanoidRootPart.Position).Magnitude
                if dist <= 2500 and mob.Humanoid.Health > 0 then
                    table.insert(enemies, mob)
                end
            end
        end
        return enemies
    end

    -- auto attack loop (giữ nguyên)
    spawn(function()
        while true do
            task.wait(0.4)
            if running then
                pcall(function()
                    local args = { 0.4000000059604645 }
                    game:GetService("ReplicatedStorage")
                        :WaitForChild("Modules")
                        :WaitForChild("Net")
                        :WaitForChild("RE/RegisterAttack")
                        :FireServer(unpack(args))
                end)
            end
        end
    end)

    -- reset phải gọi ToggleUI.Set(false) chứ không set trực tiếp UI
    local function resetRaidButton()
        running = false
        autoClicking = false
        _G.BringMobGate2 = false
        pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)
    end

    -- tween helper cho màu (sẽ tween cả BG và stroke nếu có)
    local function tweenButtonToColor(targetColor, duration)
        local tweens = {}
        local info = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        table.insert(tweens, TweenService:Create(button, info, { BackgroundColor3 = targetColor }))
        if stroke then
            table.insert(tweens, TweenService:Create(stroke, info, { Color = targetColor }))
        end
        for _, tw in ipairs(tweens) do tw:Play() end
        if #tweens > 0 then
            -- wait all to finish by waiting the duration (safe and simple)
            task.wait(duration)
        end
    end

    -- BUTTON click behavior with spam-safe guards and animation for NO-ISLAND
    button.Activated:Connect(function()
        if clickLock or animating then return end
        clickLock = true
        task.delay(0.15, function() clickLock = false end) -- small debounce to avoid double clicks

        -- If attempting to enable but no island -> animate warn and do not toggle
        if not running and not hasIslandNearby() then
            if animating then return end
            animating = true

            -- Tween to yellow over 2s, then back to original (2s). Do NOT call ToggleUI.Set(true).
            task.spawn(function()

                tweenButtonToColor(warnColor, 0.25)

                task.wait(1)

                tweenButtonToColor(origBg, 0.25)

                animating = false
            end)

            return
        end

        -- Otherwise toggle requested state and send via ToggleUI
        local requested = not running
        pcall(function() ToggleUI.Set(BUTTON_NAME, requested) end)
        running = requested
        autoClicking = running

        -- ===== Gate 2 control =====
        _G.BringMobGate2 = running

        if running then
            -- same attribute behavior as trước
            player:SetAttribute("FastAttackEnemyMode", "Toggle")
            player:SetAttribute("FastAttackEnemyStyle", "Melee")
            player:SetAttribute("FastAttackEnemy", true)
        else
            -- đảm bảo attribute tắt khi off
            player:SetAttribute("FastAttackEnemy", false)
        end
    end)

    -- respawn: tắt
    player.CharacterAdded:Connect(function(newChar)
        character = newChar
        hrp = character:WaitForChild("HumanoidRootPart")
        resetRaidButton()
    end)

    -- keep hrp reference if changed (if script started before character fully present)
    if player.Character then
        character = player.Character
        hrp = character:FindFirstChild("HumanoidRootPart") or hrp
    end

    -- other helper functions from original: tweenCloseTo, followEnemy, updateHighlight
    local function tweenCloseTo(targetPos, stopDist, isEnemy)
        if not hrp then return end
        stopDist = stopDist or 40
        local currentPos = hrp.Position

        local targetY = targetPos.Y
        if isEnemy then targetY = targetPos.Y + 100 end

        hrp.CFrame = CFrame.new(currentPos.X, targetY, currentPos.Z)

        local horizontalDist = (Vector2.new(currentPos.X, currentPos.Z) - Vector2.new(targetPos.X, targetPos.Z)).Magnitude

        if horizontalDist > stopDist then
            local direction = (Vector2.new(targetPos.X, targetPos.Z) - Vector2.new(hrp.Position.X, hrp.Position.Z)).Unit
            local targetXZ = Vector2.new(targetPos.X, targetPos.Z) - direction * stopDist
            local targetPoint = Vector3.new(targetXZ.X, targetY, targetXZ.Y)
            local time = horizontalDist / 300
            local tw = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), { CFrame = CFrame.new(targetPoint) })
            tw:Play()
            tw.Completed:Wait()
        end
    end

    local function updateHighlight(enemy)
        if not enemy then return end
        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        if not enemy:FindFirstChild("RaidHighlight") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "RaidHighlight"
            highlight.FillTransparency = 0.2
            highlight.OutlineTransparency = 0.9
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = enemy
            highlight.Parent = enemy
        end
        local highlight = enemy:FindFirstChild("RaidHighlight")
        local conn
        conn = RunService.RenderStepped:Connect(function()
            if not running or not humanoid.Parent or humanoid.Health <= 0 or not highlight or highlight.Parent ~= enemy then
                if highlight then highlight:Destroy() end
                conn:Disconnect()
                return
            end
            local percent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
            highlight.FillColor = Color3.fromRGB(255 * (1 - percent), 255 * percent, 0)
        end)
    end

    local function followEnemy(enemy)
        if not enemy or not enemy.Parent then return end
        local isClearingIsland = true
        local hrpEnemy = enemy:FindFirstChild("HumanoidRootPart")
        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
        if not hrpEnemy or not humanoid then return end
        updateHighlight(enemy)
        local anc = ensureAnchor()
        local camera = workspace.CurrentCamera
        camera.CameraType = Enum.CameraType.Custom
        camera.CameraSubject = anc

        while humanoid.Health > 0 and running do
            if not hrp then break end
            updateHighlight(enemy)
            local anchorY = hrpEnemy.Position.Y + 25
            local targetPos = Vector3.new(hrpEnemy.Position.X, anchorY, hrpEnemy.Position.Z)
            anc.Position = anc.Position:Lerp(targetPos, 0.15)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(targetPos), 0.25)
            RunService.RenderStepped:Wait()
        end

        if hrp then
            camera.CameraSubject = hrp
        end
        isClearingIsland = false
    end

    -- main loop (giữ logic cũ, nhưng khi auto tắt do hết đảo -> gọi resetRaidButton)
    task.spawn(function()
        while true do
            RunService.Heartbeat:Wait()
            if not hrp then continue end

            -- Anti fall
            if running and hrp.Position.Y < -1 then
                hrp.CFrame = hrp.CFrame + Vector3.new(0,200,0)
            end

            -- nếu đang bật nhưng không còn đảo -> tắt thông qua ToggleUI
            if running and not hasIslandNearby() then
                resetRaidButton()
                continue
            end

            if not running then continue end

            local island = getHighestPriorityIsland()
            if island then
                local root = island:FindFirstChild("PrimaryPart") or island:FindFirstChildWhichIsA("BasePart")
                if root then
                    local islandCenter = getIslandCenter(island)
                    tweenCloseTo(islandCenter, 1)
                    RunService.RenderStepped:Wait()
                    local timer = 0
                    while timer < 1 do
                        if #getEnemiesNear(hrp) > 0 then break end
                        timer += task.wait(1)
                    end
                end
            end

            local enemies = getEnemiesNear(hrp)
            if #enemies > 0 then
                for _, enemy in ipairs(enemies) do
                    local enemyHRP = enemy:FindFirstChild("HumanoidRootPart")
                    if enemyHRP then tweenCloseTo(enemyHRP.Position, 250, true) end
                    followEnemy(enemy)
                    if not running then break end
                end
            end
        end
    end)
end

--=== BUY MICROPCHIP ===================================================================================================================--

do
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")

    local player = Players.LocalPlayer

    -- ScrollingTab -> Raid
    local ScrollingTab = player.PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    local raidFrame = ScrollingTab:FindFirstChild("Raid", true)
    if not raidFrame then
        warn("Không tìm thấy Frame 'Raid'")
        return
    end

    -- controls
    local buyBtn    = raidFrame:FindFirstChild("BuyMicrochipButton", true)
    local selectBtn = raidFrame:FindFirstChild("SelectMicrochipButton", true)

    if not buyBtn or not selectBtn then
        warn("Thiếu BuyMicrochipButton hoặc SelectMicrochipButton")
        return
    end

    local listFrame = selectBtn:FindFirstChild("List", true)
    if not listFrame then
        warn("Không tìm thấy List trong SelectMicrochipButton")
        return
    end

    -- UIStroke helper
    local function findStroke(inst)
        for _, c in ipairs(inst:GetDescendants()) do
            if c:IsA("UIStroke") then return c end
        end
    end

    local buyStroke = findStroke(buyBtn)

    -- constants
    local TWEEN_TIME = 0.18
    local COLOR_RED   = Color3.fromRGB(255, 0, 0)
    local COLOR_GREEN = Color3.fromRGB(0, 255, 0)

    -- state
    local selectedChip = nil
    local listOpen = false
    local animating = false

    -- init list closed
    listFrame.Visible = false
    listFrame.Size = UDim2.new(1, 0, 0, 0)
    listFrame.ClipsDescendants = true

    -- tween helper
    local function tweenGui(obj, props)
        local tw = TweenService:Create(
            obj,
            TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            props
        )
        tw:Play()
        return tw
    end

    -- buy button color
    local function updateBuy(canBuy)
        local col = canBuy and COLOR_GREEN or COLOR_RED
        buyBtn.BackgroundColor3 = col
        if buyStroke then buyStroke.Color = col end
    end

    updateBuy(false)

    -- open / close list
    local function openList()
        if listOpen or animating then return end
        animating = true
        listFrame.Visible = true
        tweenGui(listFrame, { Size = UDim2.new(1, 0, 5, 0) })
            .Completed:Wait()
        listOpen = true
        animating = false
    end

    local function closeList()
        if not listOpen or animating then return end
        animating = true
        tweenGui(listFrame, { Size = UDim2.new(1, 0, 0, 0) })
            .Completed:Wait()
        listFrame.Visible = false
        listOpen = false
        animating = false
    end

    -- toggle list by clicking select button
    if selectBtn.Activated then
        selectBtn.Activated:Connect(function()
            if listOpen then closeList() else openList() end
        end)
    else
        selectBtn.MouseButton1Click:Connect(function()
            if listOpen then closeList() else openList() end
        end)
    end

    -- wire chip buttons
    local defaultChips = {
        "Flame","Ice","Quake","Light","Dark",
        "Spider","Rumble","Magma","Buddha","Sand"
    }

    local function wireChip(btn, chipName)
        btn.MouseButton1Click:Connect(function()
            selectedChip = chipName
            selectBtn.Text = "Microchip: " .. chipName
            updateBuy(true)
            closeList()
        end)
    end

    local found = false
    for _, c in ipairs(listFrame:GetChildren()) do
        if c:IsA("ImageButton") then
            found = true
            wireChip(c, c.Name)
        end
    end

    if not found then
        local h = 30
        for i, name in ipairs(defaultChips) do
            local b = Instance.new("ImageButton")
            b.Name = name
            b.Size = UDim2.new(1, 0, 0, h)
            b.Position = UDim2.new(0, 0, 0, (i-1)*h)
            b.BackgroundColor3 = Color3.fromRGB(45,45,45)
            b.Parent = listFrame
            wireChip(b, name)
        end
    end

    -- buy action
    local function buy()
        if not selectedChip then return end
        pcall(function()
            game:GetService("ReplicatedStorage")
                :WaitForChild("Remotes")
                :WaitForChild("CommF_")
                :InvokeServer("RaidsNpc", "Select", selectedChip)
        end)
    end

    if buyBtn.Activated then
        buyBtn.Activated:Connect(buy)
    else
        buyBtn.MouseButton1Click:Connect(buy)
    end
end

--=== AUTO DUNGEON ===================================================================================================================--

-- Full adjusted script with robust Random-mode list & patrol
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local player = Players.LocalPlayer

    -- chờ ToggleUI helper
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)

    -- TÌM button trong ScrollingTab -> Raid -> AutoDungeonButton
    local ScrollingTab = player.PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    local raidFrame = ScrollingTab:FindFirstChild("Raid", true) or ScrollingTab:FindFirstChild("Raid")
    if not raidFrame then
        warn("Không tìm thấy Frame 'Raid' trong ScrollingTab")
        return
    end

    local BUTTON_NAME = "AutoDungeonButton"
    local SUPPORT_BTN_NAME = "SupportStyleDungeonButton"
    local autoBtn = raidFrame:FindFirstChild(BUTTON_NAME, true)
    local supportBtn = raidFrame:FindFirstChild(SUPPORT_BTN_NAME, true)

    if not autoBtn then
        warn("Không tìm thấy Button:", BUTTON_NAME)
        return
    end
    if not supportBtn then
        warn("Không tìm thấy SupportStyleDungeonButton", "- tiếp tục nhưng không có UI support.")
    end

    -- NEW: find ModeDungeonButton (mode toggle)
    local MODE_BTN_NAME = "ModeDungeonButton"
    local modeBtn = raidFrame:FindFirstChild(MODE_BTN_NAME, true) or raidFrame:FindFirstChild(MODE_BTN_NAME)

    -- helper: tìm UIStroke descendant đầu tiên
    local function findStroke(inst)
        for _, v in ipairs(inst:GetDescendants()) do
            if v:IsA("UIStroke") then return v end
        end
        return nil
    end
    local btnStroke = findStroke(autoBtn)
    local supportStroke = supportBtn and findStroke(supportBtn) or nil
    local modeStroke = modeBtn and findStroke(modeBtn) or nil

    -- tween helper
    local function tweenGui(obj, props, time, style, dir)
        local info = TweenInfo.new(time or 0.25, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
        local tw = TweenService:Create(obj, info, props)
        tw:Play()
        return tw
    end

    -- settings từ script gốc
    local DISTANCE_LIMIT = 900
    local SCAN_INTERVAL = 0.08
    local MOVE_SPEED = 600
    local FOLLOW_HEIGHT = 35 -- mặc định Melee
    local ATTACK_INTERVAL = 0.5

    local ALLOWED_PLACE = 73902483975735

    -- Support style config
    local MELEE_COLOR = Color3.fromRGB(0, 200, 255)
    local FRUIT_COLOR = Color3.fromRGB(0, 255, 150)
    local SUPPORT_TEXT = { Melee = "Support: Melee", Fruit = "Support: Fruit" }

    local supportStyle = "Melee" -- mặc định
    local _prevSupportStyle = nil

    -- internal state
    local autoDungeon = false
    local pauseForExit = false
    local lastEquippedToolName = nil
    local toolTrackConn = nil

    local farmCenter = nil
    local movementLock = false
    local followLock = false
    local currentTarget = nil

    local IGNORED_ENEMIES = { ["Blank Buddy"] = true }
    local function isIgnoredEnemy(m) return IGNORED_ENEMIES[m.Name] == true end

    -- Mode control (Nearest / Random)
    local MODE_NEAREST = "Nearest"
    local MODE_RANDOM  = "Random"
    local mode = MODE_NEAREST -- default

    -- Mode colors/text
    local MODE_NEAREST_COLOR = Color3.fromRGB(50, 255, 120)
    local MODE_RANDOM_COLOR  = Color3.fromRGB(168, 85, 247)

    -- character refs
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")

    local function refreshCharacterRefs(newChar)
        character = newChar or player.Character
        if character then
            hrp = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")
        else
            hrp = nil
        end
    end

    -- tool tracking
    local function hookToolTracking(char)
        if toolTrackConn then
            pcall(function() toolTrackConn:Disconnect() end)
            toolTrackConn = nil
        end
        if not char then return end

        local existing = char:FindFirstChildOfClass("Tool")
        if existing and autoDungeon then
            lastEquippedToolName = existing.Name
        end

        toolTrackConn = char.ChildAdded:Connect(function(obj)
            if obj and obj:IsA("Tool") and autoDungeon then
                lastEquippedToolName = obj.Name
            end
        end)
    end

    -- movement helper (interruptible)
    local function moveToPositionInterruptible(targetPos, interruptFn)
        if not hrp or not hrp.Parent then return false end
        movementLock = true
        local arrived = false

        while hrp and hrp.Parent do
            local pos = hrp.Position
            local dir = (targetPos - pos)
            local dist = dir.Magnitude
            if dist <= 1 then
                arrived = true
                break
            end
            if interruptFn and interruptFn() then break end
            local dt = RunService.Heartbeat:Wait()
            local step = math.min(dist, MOVE_SPEED * dt)
            local newPos = pos + dir.Unit * step
            hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
            hrp.CFrame = CFrame.new(newPos)
        end

        movementLock = false
        return arrived
    end

    -- enemy finders (giữ nguyên logic, thêm helper lấy tất cả enemy trong range)
    local function getNearestPriorityEnemy(centerPos)
        local folder = workspace:FindFirstChild("Enemies")
        if not folder then return nil end
        local best, bestDist
        for _, mob in ipairs(folder:GetChildren()) do
            if mob:IsA("Model")
                and mob.Name == "PropHitboxPlaceholder"
                and not isIgnoredEnemy(mob)
                and mob:FindFirstChild("HumanoidRootPart") then

                local hp = mob:FindFirstChildOfClass("Humanoid")
                if hp and hp.Health > 0 then
                    local dist = (centerPos - mob.HumanoidRootPart.Position).Magnitude
                    if dist <= DISTANCE_LIMIT then
                        if not bestDist or dist < bestDist then
                            best = mob
                            bestDist = dist
                        end
                    end
                end
            end
        end
        return best
    end

    local function getNearestEnemy(centerPos)
        local folder = workspace:FindFirstChild("Enemies")
        if not folder then return nil end
        local nearest, nearestDist
        for _, mob in ipairs(folder:GetChildren()) do
            if mob:IsA("Model") and not isIgnoredEnemy(mob) and mob:FindFirstChild("HumanoidRootPart") then
                local hp = mob:FindFirstChildOfClass("Humanoid")
                if hp and hp.Health > 0 then
                    local dist = (centerPos - mob.HumanoidRootPart.Position).Magnitude
                    if dist <= DISTANCE_LIMIT then
                        if not nearestDist or dist < nearestDist then
                            nearest = mob
                            nearestDist = dist
                        end
                    end
                end
            end
        end
        return nearest
    end

    -- NEW: enemy list management for Random mode
    local enemyList = {} -- keys = mob model, value = { visited = bool }

    local function addEnemyToList(mob)
        if not mob or not mob:IsA("Model") then return end
        if isIgnoredEnemy(mob) then return end
        if mob.Name == "PropHitboxPlaceholder" then return end -- exclude priority from random-list
        if enemyList[mob] then return end
        local hrpM = mob:FindFirstChild("HumanoidRootPart")
        local hum = mob:FindFirstChildOfClass("Humanoid")
        if not hrpM or not hum or hum.Health <= 0 then return end
        if not hrp then return end
        local dist = (hrp.Position - hrpM.Position).Magnitude
        if dist > DISTANCE_LIMIT then return end
        enemyList[mob] = { visited = false }
    end

    local function removeEnemyFromList(mob)
        if enemyList[mob] then
            enemyList[mob] = nil
        end
    end

    local function refreshEnemyList()
        -- add new enemies
        local folder = workspace:FindFirstChild("Enemies")
        if folder then
            for _, mob in ipairs(folder:GetChildren()) do
                if mob:IsA("Model") then
                    -- only non-priority, non-ignored are in random list
                    if not isIgnoredEnemy(mob) and mob.Name ~= "PropHitboxPlaceholder" and mob:FindFirstChild("HumanoidRootPart") then
                        local hum = mob:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            if hrp then
                                local dist = (hrp.Position - mob.HumanoidRootPart.Position).Magnitude
                                if dist <= DISTANCE_LIMIT then
                                    if not enemyList[mob] then
                                        enemyList[mob] = { visited = false }
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        -- remove dead/out-of-range/invalid from list
        for mob, info in pairs(enemyList) do
            local ok = pcall(function() return mob.Parent end)
            if not ok or not mob or not mob.Parent then
                enemyList[mob] = nil
            else
                local hum = mob:FindFirstChildOfClass("Humanoid")
                local hrpM = mob:FindFirstChild("HumanoidRootPart")
                if not hum or not hrpM or hum.Health <= 0 then
                    enemyList[mob] = nil
                else
                    if hrp then
                        local d = (hrp.Position - hrpM.Position).Magnitude
                        if d > DISTANCE_LIMIT then
                            enemyList[mob] = nil
                        end
                    else
                        enemyList[mob] = nil
                    end
                end
            end
        end
    end

    local function anyUnvisitedExists()
        for mob, info in pairs(enemyList) do
            if info and info.visited == false then
                return true
            end
        end
        return false
    end

    local function pickRandomUnvisited()
        refreshEnemyList()
        local candidates = {}
        for mob, info in pairs(enemyList) do
            if info and info.visited == false then
                -- ensure still valid
                local hrpM = mob:FindFirstChild("HumanoidRootPart")
                local hum = mob:FindFirstChildOfClass("Humanoid")
                if mob and hrpM and hum and hum.Health > 0 and hrp then
                    local d = (hrp.Position - hrpM.Position).Magnitude
                    if d <= DISTANCE_LIMIT then
                        table.insert(candidates, mob)
                    else
                        enemyList[mob] = nil -- prune out of range
                    end
                else
                    enemyList[mob] = nil -- prune dead/invalid
                end
            end
        end

        if #candidates == 0 then
            -- if empty and there are entries, reset flags and try again
            local any = false
            for mob, info in pairs(enemyList) do
                any = true
                info.visited = false
            end
            if any then
                -- rebuild candidates
                for mob, info in pairs(enemyList) do
                    if info and info.visited == false then
                        local hrpM = mob:FindFirstChild("HumanoidRootPart")
                        local hum = mob:FindFirstChildOfClass("Humanoid")
                        if mob and hrpM and hum and hum.Health > 0 and hrp then
                            local d = (hrp.Position - hrpM.Position).Magnitude
                            if d <= DISTANCE_LIMIT then
                                table.insert(candidates, mob)
                            else
                                enemyList[mob] = nil
                            end
                        else
                            enemyList[mob] = nil
                        end
                    end
                end
            end
        end

        if #candidates == 0 then return nil end
        return candidates[ math.random(1, #candidates) ]
    end

    -- randomPatrol: continuously visit unvisited enemies in enemyList until stopped / priority appears
    local randomPatrolToken = nil
    local function startRandomPatrol()
        if followLock then return end
        followLock = true
        currentTarget = nil
        local token = {}
        randomPatrolToken = token

        task.spawn(function()
            -- make sure list is initially populated
            refreshEnemyList()
            while autoDungeon and not pauseForExit and randomPatrolToken == token do
                -- if priority appears, break so priority handler takes over
                if getNearestPriorityEnemy(hrp.Position) then
                    break
                end

                -- refresh list
                refreshEnemyList()

                -- pick next unvisited
                local target = pickRandomUnvisited()
                if not target then
                    -- no candidates -> small wait and loop again
                    task.wait(SCAN_INTERVAL)
                    continue
                end

                -- validate target
                if not target or not target.Parent then
                    enemyList[target] = nil
                    task.wait(0.05)
                    continue
                end

                local hum = target:FindFirstChildOfClass("Humanoid")
                local hrpEnemy = target:FindFirstChild("HumanoidRootPart")
                if not hum or not hrpEnemy or hum.Health <= 0 then
                    enemyList[target] = nil
                    task.wait(0.05)
                    continue
                end

                if not hrp or not hrp.Parent then break end
                currentTarget = target

                -- compute high pos
                local highPos = hrpEnemy.Position + Vector3.new(0, FOLLOW_HEIGHT, 0)

                -- interrupt if priority appears or autoDungeon off
                local function interruptIfPriorityOrCancel()
                    if not autoDungeon then return true end
                    if getNearestPriorityEnemy(hrp.Position) then return true end
                    -- also if this target died or left range, interrupt
                    local ok, valid = pcall(function()
                        return target and target.Parent and target:FindFirstChildOfClass("Humanoid") and target:FindFirstChild("HumanoidRootPart")
                    end)
                    if not ok or not valid then return true end
                    local h = target:FindFirstChildOfClass("Humanoid")
                    local mhrp = target:FindFirstChild("HumanoidRootPart")
                    if not h or not mhrp or h.Health <= 0 then return true end
                    local d = (hrp.Position - mhrp.Position).Magnitude
                    if d > DISTANCE_LIMIT then return true end
                    return false
                end

                -- move to target highPos
                local arrived = moveToPositionInterruptible(highPos, interruptIfPriorityOrCancel)

                -- if arrived and still valid, mark visited
                local stillValid = (target and target.Parent and target:FindFirstChildOfClass("Humanoid") and target:FindFirstChild("HumanoidRootPart"))
                if arrived and stillValid and autoDungeon and not pauseForExit then
                    -- mark visited
                    if enemyList[target] then enemyList[target].visited = true end

                    -- small dwell so "we reached it"
                    task.wait(0.05)
                    -- immediately continue loop to pick next
                    -- loop will pick next unvisited (or reset visited flags when all done)
                    -- Also allow a tiny yield to let refresh happen
                    task.wait(0.01)
                    -- continue to next iteration
                else
                    -- didn't arrive or invalid -> remove target from list if invalid
                    if not stillValid then enemyList[target] = nil end
                    -- tiny wait to avoid busy loop
                    task.wait(0.05)
                end

                -- allow short break to check conditions
                task.wait(0.01)
            end

            -- cleanup on exit
            followLock = false
            currentTarget = nil
            -- clear token only if same
            if randomPatrolToken == token then randomPatrolToken = nil end
        end)
    end

    local function stopRandomPatrol()
        -- stopping will just change token; the coroutine will exit naturally on next checks
        randomPatrolToken = nil
        -- followLock will be reset by patrol itself
    end

    -- follow and root handlers (chỉnh để hỗ trợ mode Random)
    local function followEnemy(enemy)
        local isPriorityTarget = (enemy and enemy.Name == "PropHitboxPlaceholder")
        if followLock then return end
        followLock = true
        currentTarget = enemy

        if not enemy or not enemy.Parent or not hrp then
            followLock = false
            currentTarget = nil
            return
        end

        local hrpEnemy = enemy:FindFirstChild("HumanoidRootPart")
        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
        if not hrpEnemy or not humanoid then
            followLock = false
            currentTarget = nil
            return
        end

        local highPos = hrpEnemy.Position + Vector3.new(0, FOLLOW_HEIGHT, 0)

        local function interruptIfBetterEnemy()
            if not autoDungeon then return true end
            local center = hrp.Position
            local pri = getNearestPriorityEnemy(center)
            if pri and pri ~= enemy then return true end
            if isPriorityTarget then return false end
            local newNearest = getNearestEnemy(center)
            if newNearest and newNearest ~= enemy then
                local newDist = (center - newNearest.HumanoidRootPart.Position).Magnitude
                local curDist = (center - hrpEnemy.Position).Magnitude
                if newDist + 1 < curDist then return true end
            end
            return false
        end

        moveToPositionInterruptible(highPos, interruptIfBetterEnemy)

        if not autoDungeon or not hrp or not hrp.Parent then
            followLock = false
            currentTarget = nil
            return
        end

        -- For Random mode the randomPatrol handles switching; here we keep behavior similar to original
        local startTick = tick()
        local RANDOM_DWELL = 0.2

        while autoDungeon and not pauseForExit and humanoid and humanoid.Health > 0 and hrp and hrp.Parent do
            local center = hrp.Position
            local priNow = getNearestPriorityEnemy(center)
            if priNow and priNow ~= enemy then break end

            if not isPriorityTarget then
                local newNearest = getNearestEnemy(center)
                if newNearest and newNearest ~= enemy and newNearest:FindFirstChild("HumanoidRootPart") then
                    local newDist = (center - newNearest.HumanoidRootPart.Position).Magnitude
                    local curDist = (center - hrpEnemy.Position).Magnitude
                    if newDist + 1 < curDist then break end
                end
            end

            -- If mode is Random, we don't use the original random switching inside followEnemy,
            -- because randomPatrol is responsible for list-based visiting.
            if mode == MODE_RANDOM then
                -- just hover around current target until something forces us out
                local targetPos = Vector3.new(hrpEnemy.Position.X, hrpEnemy.Position.Y + FOLLOW_HEIGHT, hrpEnemy.Position.Z)
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(targetPos), 0.5)
                RunService.RenderStepped:Wait()
                continue
            end

            -- original nearest-mode movement
            local targetPos = Vector3.new(hrpEnemy.Position.X, hrpEnemy.Position.Y + FOLLOW_HEIGHT, hrpEnemy.Position.Z)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(targetPos), 0.5)
            RunService.RenderStepped:Wait()
        end

        followLock = false
        currentTarget = nil
    end

    local function handleDungeonRoot(rootPart)
        if movementLock then return end
        pauseForExit = true

        local waited = 0
        while waited < 2 do
            if not autoDungeon then
                pauseForExit = false
                return
            end
            if not hrp or not hrp.Parent then
                pauseForExit = false
                return
            end
            if getNearestPriorityEnemy(hrp.Position) or getNearestEnemy(hrp.Position) then
                pauseForExit = false
                return
            end
            task.wait(0.1)
            waited = waited + 0.1
        end

        local target = rootPart.Position + Vector3.new(0, 3, 0)
        local function interruptIfEnemyAppears()
            if not autoDungeon then return true end
            if getNearestPriorityEnemy(hrp.Position) then return true end
            return getNearestEnemy(hrp.Position) ~= nil
        end

        local arrived = moveToPositionInterruptible(target, interruptIfEnemyAppears)
        if not arrived then
            pauseForExit = false
            return
        end

        local waitedTouch = 0
        while waitedTouch < 3 and pauseForExit and rootPart and rootPart.Parent do
            local stillTouch = rootPart:FindFirstChild("TouchInterest")
                or rootPart:FindFirstChildOfClass("TouchTransmitter")
            if not stillTouch then break end
            if getNearestPriorityEnemy(hrp.Position) then break end
            if getNearestEnemy(hrp.Position) then break end
            task.wait(0.25)
            waitedTouch = waitedTouch + 0.25
        end

        pauseForExit = false
    end

    -- attack loop
    task.spawn(function()
        while true do
            task.wait(ATTACK_INTERVAL)
            if autoDungeon and not pauseForExit then
                pcall(function()
                    ReplicatedStorage
                        :WaitForChild("Modules")
                        :WaitForChild("Net")
                        :WaitForChild("RE/RegisterAttack")
                        :FireServer(ATTACK_INTERVAL)
                end)
            end
        end
    end)

    -- main scanning loop (adjusted: if mode == Random use list/patrol)
    task.spawn(function()
        while true do
            task.wait(SCAN_INTERVAL)
            if not autoDungeon then continue end
            if not hrp or not hrp.Parent then continue end
            if pauseForExit then continue end

            farmCenter = hrp.Position

            local priorityEnemy = getNearestPriorityEnemy(farmCenter)
            if priorityEnemy then
                -- stop any random patrol and prioritize this
                stopRandomPatrol()
                task.spawn(function() pcall(function() followEnemy(priorityEnemy) end) end)
                continue
            end

            if mode == MODE_RANDOM then
                -- ensure enemy list maintained
                refreshEnemyList()

                -- if not currently following/patrolling, start patrol
                if not followLock then
                    startRandomPatrol()
                end

                continue
            end

            -- MODE_NEAREST (fallback)
            local enemy = getNearestEnemy(farmCenter)
            if enemy then
                -- stop random patrol if somehow running
                stopRandomPatrol()
                task.spawn(function() pcall(function() followEnemy(enemy) end) end)
                continue
            end

            local nearestDungeonModel = getNearestDungeonModel()
            if nearestDungeonModel then
                local rootPart = checkDungeonExitOnModel(nearestDungeonModel)
                if rootPart then
                    task.spawn(function() pcall(function() handleDungeonRoot(rootPart) end) end)
                    continue
                end
            end
        end
    end)

    -- respawn handling
    player.CharacterAdded:Connect(function(newChar)
        refreshCharacterRefs(newChar)
        hookToolTracking(newChar)
        pauseForExit = true
        movementLock = false
        followLock = false
        currentTarget = nil
        enemyList = {} -- clear list on respawn (will repopulate)

        task.delay(0.5, function()
            pauseForExit = false
            if autoDungeon and lastEquippedToolName then
                task.wait(0.2)
                if newChar and not newChar:FindFirstChildOfClass("Tool") then
                    local bp = player:FindFirstChild("Backpack")
                    local tool = bp and bp:FindFirstChild(lastEquippedToolName)
                    if tool then
                        pcall(function() tool.Parent = newChar end)
                    end
                end
            end
        end)
    end)

    -- initial hook
    hookToolTracking(character)

    -- ---------- UI integration with ToggleUI ----------
    -- ensure initial OFF (via ToggleUI; will update visuals)
    pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)

    -- helper infer on/off from background color
    local function inferToggleOnFromColor(btn)
        local bg
        pcall(function() bg = btn.BackgroundColor3 end)
        if not bg then return false end
        return bg.G and bg.G > bg.R and bg.G > bg.B and bg.G > 0.5
    end

    -- sync local autoDungeon when ToggleUI changes visual of button
    local function syncFromButtonColor()
        local on = inferToggleOnFromColor(autoBtn)
        if on == autoDungeon then return end
        autoDungeon = on

        _G.BringMobGate2 = autoDungeon

        if autoDungeon then
            -- when turned on: hook and set attributes (non-destructive)
            hookToolTracking(character)
            pcall(function()
                player:SetAttribute("FastAttackEnemyMode", "Toggle")
                player:SetAttribute("FastAttackEnemyStyle", supportStyle) -- dùng style hiện tại
                player:SetAttribute("FastAttackEnemy", true)

                player:SetAttribute("AutoBuso", true)
                player:SetAttribute("AutoObserve", true)
                player:SetAttribute("AutoAbility", true)
                player:SetAttribute("AutoAwakening", true)
            end)
            if hrp and hrp.Parent then
                farmCenter = hrp.Position
            end
        else
            -- when turned off: allow loops to stop gracefully
            pauseForExit = false
            -- stop any running random patrol
            stopRandomPatrol()
        end
    end

    autoBtn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        -- small defer to let ToggleUI internal transition finish
        task.delay(0.05, syncFromButtonColor)
    end)

    -- blocked animation guard
    local blockedAnim = false
    local function animateBlockedWarning()
        if blockedAnim then return end
        blockedAnim = true
        local origBg = autoBtn.BackgroundColor3 or Color3.fromRGB(255,50,50)
        local origStroke = (btnStroke and btnStroke.Color) or Color3.fromRGB(255,0,0)
        local warnColor = Color3.fromRGB(255,255,0)

        -- tween to warn
        tweenGui(autoBtn, { BackgroundColor3 = warnColor }, 0.25)
        if btnStroke then tweenGui(btnStroke, { Color = warnColor }, 0.25) end

        -- wait 1s then tween back to original red (or whatever current bg is)
        task.delay(1, function()
            tweenGui(autoBtn, { BackgroundColor3 = origBg }, 0.25)
            if btnStroke then tweenGui(btnStroke, { Color = origStroke }, 0.25) end
            blockedAnim = false
        end)
    end

    -- click handler: request ToggleUI.Set unless blocked by PlaceId
    local function onButtonActivated()
        -- infer current ON state from color and flip
        local currentOn = inferToggleOnFromColor(autoBtn)
        local requested = not currentOn

        if requested then
            -- trying to enable: check PlaceId
            if game.PlaceId ~= ALLOWED_PLACE then
                -- animate yellow -> red and do NOT call ToggleUI.Set
                animateBlockedWarning()
                return
            end
        end

        -- allowed: request ToggleUI change (ToggleUI will change visuals -> propertyChanged will sync autoDungeon)
        pcall(function() ToggleUI.Set(BUTTON_NAME, requested) end)
    end

    if autoBtn.Activated then
        autoBtn.Activated:Connect(onButtonActivated)
    else
        autoBtn.MouseButton1Click:Connect(onButtonActivated)
    end

    -- small initial sync after UI settled
    task.delay(0.05, syncFromButtonColor)

    -- ========== SupportStyleDungeonButton handling & visuals ==========
    local function getTextHolder(btn)
        if not btn then return nil end
        if btn:IsA("TextButton") or btn:IsA("TextLabel") then
            return btn
        end
        local t = btn:FindFirstChildOfClass("TextLabel") or btn:FindFirstChildOfClass("TextButton")
        return t
    end

    local function tweenProperty(instance, props, time)
        if not instance then return end
        local ok, t = pcall(function()
            local tw = TweenService:Create(instance, TweenInfo.new(time or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
            tw:Play()
            return tw
        end)
        if ok then return t end
        return nil
    end

    local function applySupportVisuals(style)
        if not supportBtn then return end
        local targetColor = (style == "Melee") and MELEE_COLOR or FRUIT_COLOR
        -- tween background
        pcall(function() tweenProperty(supportBtn, {BackgroundColor3 = targetColor}, 0.18) end)
        -- tween UIStroke.Color if exists
        if supportStroke then
            pcall(function() tweenProperty(supportStroke, {Color = targetColor}, 0.18) end)
        end
        -- text tween: fade out -> change -> fade in
        local textObj = getTextHolder(supportBtn)
        if textObj then
            local t1 = tweenProperty(textObj, {TextTransparency = 1}, 0.12)
            if t1 then t1.Completed:Wait() end
            local newText = SUPPORT_TEXT[style] or ("Support: " .. style)
            pcall(function() textObj.Text = newText end)
            local t2 = tweenProperty(textObj, {TextTransparency = 0}, 0.12)
            if t2 then t2.Completed:Wait() end
        end
    end

    local function setSupportStyle(style)
        if not style then return end
        style = (style == "Fruit") and "Fruit" or "Melee"
        if _prevSupportStyle == style then
            -- đồng bộ visuals nếu vẫn giống
            applySupportVisuals(style)
            return
        end

        supportStyle = style
        -- cập nhật FOLLOW_HEIGHT tương ứng
        if style == "Melee" then
            FOLLOW_HEIGHT = 35
        else
            FOLLOW_HEIGHT = 10
        end

        applySupportVisuals(style)
        _prevSupportStyle = style

        -- gọi SetAttribute cho chế độ hiện tại 1 lần
        pcall(function()
            player:SetAttribute("FastAttackEnemyStyle", style)
        end)
    end

    -- khởi tạo supportBtn visuals mặc định Melee
    if supportBtn then
        -- ensure initial text transparency is 0 (hiển thị)
        local textObj = getTextHolder(supportBtn)
        if textObj then
            pcall(function() textObj.TextTransparency = 0 end)
            pcall(function() textObj.Text = SUPPORT_TEXT[supportStyle] end)
        end
        -- set initial background & stroke instantly
        pcall(function() supportBtn.BackgroundColor3 = MELEE_COLOR end)
        if supportStroke then pcall(function() supportStroke.Color = MELEE_COLOR end) end

        -- connect click to toggle
        local function onSupportActivated()
            local nextStyle = (supportStyle == "Melee") and "Fruit" or "Melee"
            setSupportStyle(nextStyle)
        end
        if supportBtn.Activated then
            supportBtn.Activated:Connect(onSupportActivated)
        else
            supportBtn.MouseButton1Click:Connect(onSupportActivated)
        end
    end

    -- ensure attribute initial value set to default supportStyle (một lần)
    pcall(function() player:SetAttribute("FastAttackEnemyStyle", supportStyle) end)

    -- ========== NEW: ModeDungeonButton handling ==========
    local function setModeAppearance(newMode)
        if not modeBtn then return end
        local out = tweenProperty(modeBtn:FindFirstChildOfClass("TextLabel") or modeBtn, {TextTransparency = 1}, 0.12)
        if out then out.Completed:Wait() end

        if newMode == MODE_NEAREST then
            pcall(function() tweenGui(modeBtn, { BackgroundColor3 = MODE_NEAREST_COLOR }, 0.18) end)
            if modeStroke then pcall(function() tweenGui(modeStroke, { Color = MODE_NEAREST_COLOR }, 0.18) end) end
            pcall(function()
                local textObj = modeBtn:FindFirstChildOfClass("TextLabel") or modeBtn
                if textObj then textObj.Text = "Mode: Nearest" end
            end)
        else
            pcall(function() tweenGui(modeBtn, { BackgroundColor3 = MODE_RANDOM_COLOR }, 0.18) end)
            if modeStroke then pcall(function() tweenGui(modeStroke, { Color = MODE_RANDOM_COLOR }, 0.18) end) end
            pcall(function()
                local textObj = modeBtn:FindFirstChildOfClass("TextLabel") or modeBtn
                if textObj then textObj.Text = "Mode: Random" end
            end)
        end

        local inn = tweenProperty(modeBtn:FindFirstChildOfClass("TextLabel") or modeBtn, {TextTransparency = 0}, 0.12)
        if inn then inn.Completed:Wait() end
    end

    if modeBtn then
        -- initialize visuals (Nearest default)
        pcall(function() modeBtn.BackgroundColor3 = MODE_NEAREST_COLOR end)
        if modeStroke then pcall(function() modeStroke.Color = MODE_NEAREST_COLOR end) end
        pcall(function()
            local textObj = modeBtn:FindFirstChildOfClass("TextLabel") or modeBtn
            if textObj then textObj.Text = "Mode: Nearest" end
        end)

        local function toggleMode()
            mode = (mode == MODE_NEAREST) and MODE_RANDOM or MODE_NEAREST
            setModeAppearance(mode)
            -- if switched to Random and autoDungeon currently on, clear & start patrol
            if mode == MODE_RANDOM then
                enemyList = {}
                if autoDungeon then
                    startRandomPatrol()
                end
            else
                -- switching to Nearest: stop patrol
                stopRandomPatrol()
            end
        end

        if modeBtn.Activated then
            modeBtn.Activated:Connect(toggleMode)
        else
            modeBtn.MouseButton1Click:Connect(toggleMode)
        end
    end
end

--=== SELECT BUFF DUNGEON ===================================================================================================================--

do
    loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BLOX_FRUIT/refs/heads/main/UISelectBuffDungeon.lua"))()
    -- CONFIG
    local SCAN_INTERVAL = 2
    local MIN_SG_REQUIRED = 3

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local player = Players.LocalPlayer

    -- chờ ToggleUI helper
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)

    -- path tới ScrollingTab -> tìm Raid frame
    local ScrollingTab = player.PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    local raidFrame = ScrollingTab:FindFirstChild("Raid", true)

    -- NAMES (theo bạn cung cấp)
    local BUTTON_NAME = "AutoSelectBuffButton"       -- tên dùng cho ToggleUI.Set(...)
    local TOGGLE_BTN_NAME = "AutoSelectBuffButton"  -- nút toggle trong UI (cùng tên)
    local SETTING_BTN_NAME = "SettingAutoBuffButton" -- nút gọi game.ReplicatedStorage.BuffUIEvent:Fire("toggle")
    local TARGET_GUI_NAME = "AutoBuffSelectionGui"
    local EXEC_PATH = {"Main", "Execution"}

    -- tìm nút toggle và nút setting trong Raid frame (nếu không found -> warn)
    local toggleBtn = nil
    local settingBtn = nil
    if raidFrame then
        toggleBtn = raidFrame:FindFirstChild(TOGGLE_BTN_NAME, true)
        settingBtn = raidFrame:FindFirstChild(SETTING_BTN_NAME, true)
    end

    if not toggleBtn then
        warn("AutoSelect: Không tìm thấy nút toggle (AutoSelectBuffButton) trong Raid. Tạo nút tạm trên HomeFrame nếu có.")
        -- fallback: tạo nút tạm (nếu HomeFrame tồn tại)
        if typeof(HomeFrame) ~= "nil" and HomeFrame then
            toggleBtn = Instance.new("TextButton", HomeFrame)
            toggleBtn.Size = UDim2.new(0, 90, 0, 30)
            toggleBtn.Position = UDim2.new(0, 240, 0, 160)
            toggleBtn.Text = "OFF"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            toggleBtn.TextColor3 = Color3.new(1,1,1)
            toggleBtn.Font = Enum.Font.SourceSansBold
            toggleBtn.TextScaled = true
            toggleBtn.Name = TOGGLE_BTN_NAME
        else
            warn("AutoSelect: Không có HomeFrame để tạo nút fallback. Script sẽ không thể toggle.")
        end
    end

    if not settingBtn then
        warn("AutoSelect: Không tìm thấy nút SettingAutoBuffButton trong Raid (nút gọi BuffUIEvent). Nếu cần, tạo riêng.")
    end

    -- ===== helpers từ mẫu/phiên bản trước (normalize, safe find, click, build exec keys...) =====

    local function normalizeText(txt)
        if not txt then return "" end
        local s = tostring(txt):gsub("<[^>]+>", "")
        s = s:match("^%s*(.-)%s*$") or s
        return s:lower()
    end

    local function safeFindGui(parent, name)
        if not parent then return nil end
        local ok, res = pcall(function() return parent:FindFirstChild(name) end)
        if ok then return res end
        return nil
    end

    local function clickButtonVirt(btn)
        if not btn or not btn.Parent then return false end
        local ok, res = pcall(function()
            local pos = btn.AbsolutePosition
            local size = btn.AbsoluteSize
            local x = pos.X + size.X / 2
            local y = pos.Y + size.Y / 2
            if VirtualInputManager and VirtualInputManager.SendMouseButtonEvent then
                VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
                task.wait()
                VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
                return true
            else
                if btn.Activate then
                    btn:Activate()
                    return true
                end
            end
            return false
        end)
        return ok and res
    end

    local function execSortKey(guiObject)
        if not guiObject then return math.huge end
        local ok, y = pcall(function() return guiObject.AbsolutePosition.Y end)
        if ok and type(y) == "number" then return y end
        if guiObject.Position and guiObject.Position.Y then
            return (guiObject.Position.Y.Scale or 0) + ((guiObject.Position.Y.Offset or 0) / 100000)
        end
        return math.huge
    end

    local function buildExecutionKeys(execFrame)
        local result = {}
        if not execFrame then return result end

        for _, child in ipairs(execFrame:GetChildren()) do
            if child:IsA("GuiObject") then
                local nameText
                local label = child:FindFirstChild("DisplayName")
                if label and label:IsA("TextLabel") and label.Text ~= "" then
                    nameText = label.Text
                elseif child:IsA("TextButton") and tostring(child.Text or "") ~= "" then
                    nameText = tostring(child.Text)
                else
                    for _, sub in ipairs(child:GetDescendants()) do
                        if sub:IsA("TextLabel") and tostring(sub.Text or "") ~= "" then
                            nameText = tostring(sub.Text)
                            break
                        end
                    end
                end

                if nameText and nameText ~= "" then
                    local key = normalizeText(nameText)
                    local y = execSortKey(child)
                    table.insert(result, { key = key, obj = child, y = y })
                end
            end
        end

        table.sort(result, function(a, b)
            if a.y == b.y then return a.key < b.key end
            return a.y < b.y
        end)
        return result
    end

    local function scanValidScreenGuis(pg)
        local valid = {}
        if not pg then return valid end

        for _, sg in ipairs(pg:GetChildren()) do
            if sg:IsA("ScreenGui") and sg.Name == "ScreenGui" and sg.Enabled then
                local frame = safeFindGui(sg, "1")
                if frame and frame:IsA("Frame") then
                    local btn = safeFindGui(frame, "2")
                    if btn and btn:IsA("TextButton") and btn.Visible and btn.Active then
                        local label = safeFindGui(btn, "DisplayName")
                        if label and label:IsA("TextLabel") and tostring(label.Text) ~= "" then
                            table.insert(valid, {
                                sg = sg,
                                btn = btn,
                                label = label,
                                key = normalizeText(label.Text)
                            })
                        end
                    end
                end
            end
        end

        return valid
    end

    local function findExecIndex(execList, key)
        if not key then return nil end
        for i, e in ipairs(execList) do
            if e.key == key then return i end
        end
        return nil
    end

    local function chooseTopMost(entries)
        if not entries or #entries == 0 then return nil end
        local best = entries[1]
        local bestY = (best.btn and best.btn.AbsolutePosition and best.btn.AbsolutePosition.Y) or math.huge
        for i = 2, #entries do
            local v = entries[i]
            local y = (v.btn and v.btn.AbsolutePosition and v.btn.AbsolutePosition.Y) or math.huge
            if y < bestY then
                best = v
                bestY = y
            end
        end
        return best
    end

    -- processSelection: trả về true nếu đã click
    local function processSelection(validSGs, execList)
        if #validSGs == 0 then return false end
        if #execList == 0 then
            -- fallback random
            clickButtonVirt(validSGs[math.random(1, #validSGs)].btn)
            return true
        end

        local candidates = {}
        for _, v in ipairs(validSGs) do
            local idx = findExecIndex(execList, v.key)
            if idx then table.insert(candidates, { sg = v, idx = idx }) end
        end

        if #candidates > 0 then
            local bestIdx = math.huge
            for _, c in ipairs(candidates) do
                if c.idx < bestIdx then bestIdx = c.idx end
            end

            local bestCandidates = {}
            for _, c in ipairs(candidates) do
                if c.idx == bestIdx then table.insert(bestCandidates, c.sg) end
            end

            local chosen = chooseTopMost(bestCandidates)
            if chosen then
                clickButtonVirt(chosen.btn)
                return true
            end
        end

        -- fallback random
        clickButtonVirt(validSGs[math.random(1, #validSGs)].btn)
        return true
    end

    -- ===== CORE =====
    local lastScan = 0
    local lastClickTime = 0
    local running = false

    local function tryProcess()
        if not running then return end
        if os.clock() - lastClickTime < SCAN_INTERVAL then return end

        local pg = player:FindFirstChild("PlayerGui")
        if not pg then return end
        local targetGui = safeFindGui(pg, TARGET_GUI_NAME)
        if not targetGui then return end

        local execFrame = targetGui
        for _, part in ipairs(EXEC_PATH) do
            execFrame = safeFindGui(execFrame, part)
            if not execFrame then break end
        end
        if not execFrame or not execFrame:IsA("ScrollingFrame") then return end

        local validSGs = scanValidScreenGuis(pg)
        if #validSGs < MIN_SG_REQUIRED then return end

        local execList = buildExecutionKeys(execFrame)
        local clicked = processSelection(validSGs, execList)
        if clicked then lastClickTime = os.clock() end
    end

    RunService.Heartbeat:Connect(function(dt)
        if os.clock() - lastScan >= SCAN_INTERVAL then
            lastScan = os.clock()
            pcall(tryProcess)
        end
    end)

    -- ===== ToggleUI integration (mẫu) =====
    local function inferToggleOn(btn)
        local bg
        pcall(function() bg = btn and btn.BackgroundColor3 end)
        return bg and bg.G > bg.R and bg.G > bg.B
    end

    local function syncFromButton()
        if not toggleBtn then return end

        local on = inferToggleOn(toggleBtn)
        if on == running then return end

        running = on

        if running then
            lastClickTime = 0
        end
    end

    -- kết nối thay đổi màu (ToggleUI thay đổi màu) -> sync
    if toggleBtn then
        toggleBtn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
            task.delay(0.05, syncFromButton)
        end)
    end

    -- khi người dùng kích vào nút -> gọi ToggleUI.Set
    local function onButtonActivated()
        if not toggleBtn then return end
        local cur = inferToggleOn(toggleBtn)
        pcall(function() ToggleUI.Set(BUTTON_NAME, not cur) end)
    end

    if toggleBtn then
        if toggleBtn.Activated then
            toggleBtn.Activated:Connect(onButtonActivated)
        else
            toggleBtn.MouseButton1Click:Connect(onButtonActivated)
        end
    end

    -- Setting button: gọi BuffUIEvent:Fire("toggle") khi click
    if settingBtn then
        local function onSettingActivated()
            pcall(function()
                if ReplicatedStorage and ReplicatedStorage:FindFirstChild("BuffUIEvent") then
                    ReplicatedStorage:FindFirstChild("BuffUIEvent"):Fire("toggle")
                else
                    -- fallback: try direct access (some setups use global path)
                    if game.ReplicatedStorage and game.ReplicatedStorage:FindFirstChild("BuffUIEvent") then
                        game.ReplicatedStorage.BuffUIEvent:Fire("toggle")
                    end
                end
            end)
        end
        if settingBtn.Activated then
            settingBtn.Activated:Connect(onSettingActivated)
        else
            settingBtn.MouseButton1Click:Connect(onSettingActivated)
        end
    end

    task.delay(0.05, syncFromButton)
end
