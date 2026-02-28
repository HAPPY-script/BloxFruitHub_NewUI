--=== RAID ===================================================================================================================--
do
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")

    local player = Players.LocalPlayer

    -- WAIT for ToggleUI
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)

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

    -- tìm Support & Mode UI buttons (optional)
    local supportBtn = raidFrame:FindFirstChild("SupportStyleRaidButton", true)
    local modeBtn = raidFrame:FindFirstChild("ModeRaidButton", true)

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

    -- core refs
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
                local hum = mob:FindFirstChildOfClass("Humanoid")
                if dist <= 2500 and hum and hum.Health > 0 then
                    table.insert(enemies, { model = mob, dist = dist })
                end
            end
        end
        -- sort by distance ascending for predictable nearest behavior
        table.sort(enemies, function(a,b) return a.dist < b.dist end)
        local out = {}
        for _, t in ipairs(enemies) do table.insert(out, t.model) end
        return out
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
            task.wait(duration)
        end
    end

    -- BUTTON click behavior with spam-safe guards and animation for NO-ISLAND
    -- ========= START: Style variable & init from attribute =========
    local Style = "Melee" -- default "Melee" or "Fruit"
    -- if player already has attribute saved, use it
    pcall(function()
        local existing = player:GetAttribute("FastAttackEnemyStyle")
        if existing == "Fruit" then
            Style = "Fruit"
        elseif existing == "Melee" then
            Style = "Melee"
        end
    end)

    local function enableSetAttributesOnStart()
        -- ensure attribute for style matches current Style variable (no hardcode)
        pcall(function() player:SetAttribute("FastAttackEnemyStyle", Style) end)
        pcall(function() player:SetAttribute("FastAttackEnemyMode", "Toggle") end)
        pcall(function() player:SetAttribute("FastAttackEnemy", true) end)
    end
    -- ========= END: Style variable & init from attribute =========

    if button.Activated then
        button.Activated:Connect(function()
            if clickLock or animating then return end
            clickLock = true
            task.delay(0.15, function() clickLock = false end)

            if not running and not hasIslandNearby() then
                if animating then return end
                animating = true
                task.spawn(function()
                    tweenButtonToColor(warnColor, 0.25)
                    task.wait(1)
                    tweenButtonToColor(origBg, 0.25)
                    animating = false
                end)
                return
            end

            local requested = not running
            pcall(function() ToggleUI.Set(BUTTON_NAME, requested) end)
            running = requested
            autoClicking = running
            _G.BringMobGate2 = running

            if running then
                -- send current style attribute (reads Style variable, not hardcoded)
                enableSetAttributesOnStart()
            else
                player:SetAttribute("FastAttackEnemy", false)
            end
        end)
    else
        button.MouseButton1Click:Connect(function()
            if clickLock or animating then return end
            clickLock = true
            task.delay(0.15, function() clickLock = false end)

            if not running and not hasIslandNearby() then
                if animating then return end
                animating = true
                task.spawn(function()
                    tweenButtonToColor(warnColor, 0.25)
                    task.wait(1)
                    tweenButtonToColor(origBg, 0.25)
                    animating = false
                end)
                return
            end

            local requested = not running
            pcall(function() ToggleUI.Set(BUTTON_NAME, requested) end)
            running = requested
            autoClicking = running
            _G.BringMobGate2 = running

            if running then
                enableSetAttributesOnStart()
            else
                player:SetAttribute("FastAttackEnemy", false)
            end
        end)
    end

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

    -- other helper functions from original: tweenCloseTo, updateHighlight, etc.
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

    -- ========== NEW: Support & Mode state and UI handling ==========
    -- local Style = "Melee" -- moved above and initialized from attribute
    local MODE_NEAREST = "Nearest"
    local MODE_RANDOM = "Random"
    local raidMode = MODE_NEAREST
    local markedEnemies = {} -- map: enemyInstance -> true
    local currentTarget = nil -- track current enemy being followed (or visited)

    local STYLE_MELEE_COLOR = Color3.fromRGB(0,200,255)
    local STYLE_FRUIT_COLOR = Color3.fromRGB(0,255,150)
    local MODE_NEAREST_COLOR = Color3.fromRGB(50,255,120)
    local MODE_RANDOM_COLOR  = Color3.fromRGB(168,85,247)

    local function pruneMarked(center)
        -- remove marked enemies that are dead, destroyed, or out of 2500 range
        for e,_ in pairs(markedEnemies) do
            local success, shouldRemove = pcall(function()
                if not e or not e.Parent then return true end
                local hum = e:FindFirstChildOfClass("Humanoid")
                local hr = e:FindFirstChild("HumanoidRootPart")
                if not hum or hum.Health <= 0 then return true end
                if not hr then return true end
                if center and (center - hr.Position).Magnitude > 2500 then return true end
                return false
            end)
            if success and shouldRemove then
                markedEnemies[e] = nil
            elseif not success then
                markedEnemies[e] = nil
            end
        end
    end

    local function anyAliveEnemies(center)
        local folder = workspace:FindFirstChild("Enemies")
        if not folder then return false end
        for _, mob in ipairs(folder:GetChildren()) do
            if mob:IsA("Model") and mob:FindFirstChildOfClass("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                local hum = mob:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local dist = (center - mob.HumanoidRootPart.Position).Magnitude
                    if dist <= 2500 then return true end
                end
            end
        end
        return false
    end

    -- UI helpers
    local function getTextHolder(btn)
        if not btn then return nil end
        if btn:IsA("TextButton") or btn:IsA("TextLabel") then return btn end
        return btn:FindFirstChildOfClass("TextLabel") or btn:FindFirstChildOfClass("TextButton")
    end

    local function tweenProperty(inst, props, t)
        if not inst then return end
        local ok, tw = pcall(function()
            local info = TweenInfo.new(t or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            return TweenService:Create(inst, info, props)
        end)
        if ok and tw then tw:Play(); return tw end
        return nil
    end

    local function applySupportVisuals(style)
        if not supportBtn then return end
        local targetColor = (style == "Melee") and STYLE_MELEE_COLOR or STYLE_FRUIT_COLOR
        pcall(function() tweenProperty(supportBtn, { BackgroundColor3 = targetColor }, 0.18) end)
        local stroke = findStroke(supportBtn)
        if stroke then pcall(function() tweenProperty(stroke, { Color = targetColor }, 0.18) end) end
        local t = getTextHolder(supportBtn)
        if t then
            local out = tweenProperty(t, { TextTransparency = 1 }, 0.12)
            if out then out.Completed:Wait() end
            pcall(function() t.Text = "Support: " .. style end)
            local inn = tweenProperty(t, { TextTransparency = 0 }, 0.12)
            if inn then inn.Completed:Wait() end
        end
    end

    local function applyModeVisuals(mode)
        if not modeBtn then return end
        local color = (mode == MODE_NEAREST) and MODE_NEAREST_COLOR or MODE_RANDOM_COLOR
        pcall(function() tweenProperty(modeBtn, { BackgroundColor3 = color }, 0.18) end)
        local stroke = findStroke(modeBtn)
        if stroke then pcall(function() tweenProperty(stroke, { Color = color }, 0.18) end) end
        local t = getTextHolder(modeBtn)
        if t then
            local out = tweenProperty(t, { TextTransparency = 1 }, 0.12)
            if out then out.Completed:Wait() end
            pcall(function() t.Text = "Mode: " .. (mode == MODE_NEAREST and "Nearest" or "Random") end)
            local inn = tweenProperty(t, { TextTransparency = 0 }, 0.12)
            if inn then inn.Completed:Wait() end
        end
    end

    -- support button wiring
    if supportBtn then
        -- initialize visuals using current Style (may have been read from attribute)
        applySupportVisuals(Style)
        local strokeBtn = findStroke(supportBtn)
        if strokeBtn then pcall(function() strokeBtn.Color = (Style == "Melee" and STYLE_MELEE_COLOR or STYLE_FRUIT_COLOR) end) end
        local t = getTextHolder(supportBtn)
        if t then pcall(function() t.Text = "Support: " .. Style end) end

        local function toggleSupport()
            -- toggle and persist to attribute
            Style = (Style == "Melee") and "Fruit" or "Melee"
            applySupportVisuals(Style)
            pcall(function() player:SetAttribute("FastAttackEnemyStyle", Style) end)
            -- If running and currently following a target, update anchor/player height immediately
            if running and anchor and currentTarget then
                local hrpEnemy = currentTarget:FindFirstChild("HumanoidRootPart")
                if hrpEnemy and hrp then
                    local newOffset = (Style == "Melee") and 35 or 10
                    local newPos = Vector3.new(hrpEnemy.Position.X, hrpEnemy.Position.Y + newOffset, hrpEnemy.Position.Z)
                    pcall(function()
                        anchor.Position = newPos
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.CFrame = CFrame.new(newPos)
                    end)
                end
            end
        end

        if supportBtn.Activated then
            supportBtn.Activated:Connect(toggleSupport)
        else
            supportBtn.MouseButton1Click:Connect(toggleSupport)
        end
    end

    -- mode button wiring
    if modeBtn then
        pcall(function() modeBtn.BackgroundColor3 = MODE_NEAREST_COLOR end)
        local strokeM = findStroke(modeBtn)
        if strokeM then pcall(function() strokeM.Color = MODE_NEAREST_COLOR end) end
        local t = getTextHolder(modeBtn)
        if t then pcall(function() t.Text = "Mode: Nearest" end) end

        local function toggleMode()
            raidMode = (raidMode == MODE_NEAREST) and MODE_RANDOM or MODE_NEAREST
            if raidMode == MODE_NEAREST then
                markedEnemies = {}
            end
            applyModeVisuals(raidMode)
            pcall(function() player:SetAttribute("DungeonMode", raidMode) end)
        end

        if modeBtn.Activated then
            modeBtn.Activated:Connect(toggleMode)
        else
            modeBtn.MouseButton1Click:Connect(toggleMode)
        end
    else
        -- no UI: still expose attribute
        pcall(function() player:SetAttribute("DungeonMode", raidMode) end)
    end

    -- ========== Modified followEnemy (support + random behaviors) ==========
    local function followEnemy(enemy)
        if not enemy or not enemy.Parent then return end
        local hrpEnemy = enemy:FindFirstChild("HumanoidRootPart")
        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
        if not hrpEnemy or not humanoid then return end

        currentTarget = enemy
        updateHighlight(enemy)
        local anc = ensureAnchor()
        local camera = workspace.CurrentCamera
        camera.CameraType = Enum.CameraType.Custom
        camera.CameraSubject = anc

        -- If Random mode: compute offset now, mark and perform brief visit then release
        if raidMode == MODE_RANDOM then
            local anchorOffset = (Style == "Melee") and 35 or 10
            local targetPos = Vector3.new(hrpEnemy.Position.X, hrpEnemy.Position.Y + anchorOffset, hrpEnemy.Position.Z)

            -- mark
            pcall(function() markedEnemies[enemy] = true end)

            -- do a short visit: place anchor near and teleport/lerp player there quickly
            pcall(function()
                anc.Position = targetPos
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = CFrame.new(targetPos)
            end)

            -- small pause to allow "visit"
            task.wait(0.18)

            -- restore camera subject to player if possible
            if hrp then
                camera.CameraSubject = hrp
            end

            currentTarget = nil
            return
        end

        -- Nearest mode behavior: follow until dead or conditions break
        while humanoid.Health > 0 and running do
            if not hrp then break end
            updateHighlight(enemy)
            -- compute offset each loop so style changes apply immediately
            local anchorOffset = (Style == "Melee") and 35 or 10
            local anchorY = hrpEnemy.Position.Y + anchorOffset
            local curTargetPos = Vector3.new(hrpEnemy.Position.X, anchorY, hrpEnemy.Position.Z)
            anc.Position = anc.Position:Lerp(curTargetPos, 0.15)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(curTargetPos), 0.25)
            RunService.RenderStepped:Wait()
        end

        if hrp then
            camera.CameraSubject = hrp
        end

        currentTarget = nil
    end

    -- main loop (giữ logic cũ, nhưng thêm Random selection + prune marks)
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

            -- prune marked enemies periodically (use current center)
            pruneMarked(hrp.Position)

            local enemies = getEnemiesNear(hrp)
            if #enemies > 0 then
                if raidMode == MODE_RANDOM then
                    -- build candidate list excluding marked
                    local candidates = {}
                    for _, enemy in ipairs(enemies) do
                        if not markedEnemies[enemy] then
                            table.insert(candidates, enemy)
                        end
                    end

                    if #candidates == 0 then
                        -- if there are alive enemies but all marked, reset marks and continue
                        if anyAliveEnemies(hrp.Position) then
                            markedEnemies = {}
                            -- recompute enemies next tick
                            continue
                        end
                    else
                        -- pick random candidate and visit it
                        local chosen = candidates[ math.random(1, #candidates) ]
                        if chosen then
                            -- approach quickly then call followEnemy (which will mark and visit)
                            local enemyHRP = chosen:FindFirstChild("HumanoidRootPart")
                            if enemyHRP then
                                tweenCloseTo(enemyHRP.Position, 250, true)
                            end
                            followEnemy(chosen)
                            if not running then break end
                        end
                    end
                else
                    -- Nearest mode: iterate normally (sorted by distance)
                    for _, enemy in ipairs(enemies) do
                        local enemyHRP = enemy:FindFirstChild("HumanoidRootPart")
                        if enemyHRP then tweenCloseTo(enemyHRP.Position, 250, true) end
                        followEnemy(enemy)
                        if not running then break end
                    end
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
    local MODE_BTN_NAME = "ModeDungeonButton"

    local autoBtn = raidFrame:FindFirstChild(BUTTON_NAME, true)
    local supportBtn = raidFrame:FindFirstChild(SUPPORT_BTN_NAME, true)
    local modeBtn = raidFrame:FindFirstChild(MODE_BTN_NAME, true)

    if not autoBtn then
        warn("Không tìm thấy Button:", BUTTON_NAME)
        return
    end
    if not supportBtn then
        warn("Không tìm thấy SupportStyleDungeonButton:", SUPPORT_BTN_NAME, "- tiếp tục nhưng không có UI support.")
    end
    if not modeBtn then
        warn("Không tìm thấy ModeDungeonButton:", MODE_BTN_NAME, "- chế độ sẽ mặc định Nearest (nhưng không có UI để đổi).")
    end

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

    -- Mode config (Nearest default)
    local MODE_NEAREST = "Nearest"
    local MODE_RANDOM = "Random"
    local dungeonMode = MODE_NEAREST -- mặc định
    -- colors & texts for mode button
    local MODE_NEAREST_COLOR = Color3.fromRGB(50, 255, 120)
    local MODE_RANDOM_COLOR = Color3.fromRGB(168, 85, 247)
    local MODE_TEXT = {
        [MODE_NEAREST] = "Mode: Nearest",
        [MODE_RANDOM] = "Mode: Random"
    }

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

    -- marked table for Random mode
    local markedEnemies = {} -- keys: enemy instance -> true

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

    -- enemy finders (giữ nguyên logic, nhưng getNearestEnemy bỏ qua marked khi mode Random)
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
                -- skip marked if Random mode
                if dungeonMode == MODE_RANDOM and markedEnemies[mob] then
                    continue
                end

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

    -- helper: check if there exists any alive non-priority enemy (ignoring marks)
    local function anyAliveNonPriorityEnemies(centerPos)
        local folder = workspace:FindFirstChild("Enemies")
        if not folder then return false end
        for _, mob in ipairs(folder:GetChildren()) do
            if mob:IsA("Model") and not isIgnoredEnemy(mob) and mob:FindFirstChild("HumanoidRootPart") then
                local hp = mob:FindFirstChildOfClass("Humanoid")
                if hp and hp.Health > 0 then
                    -- ensure not priority
                    if mob.Name ~= "PropHitboxPlaceholder" then
                        local dist = (centerPos - mob.HumanoidRootPart.Position).Magnitude
                        if dist <= DISTANCE_LIMIT then
                            return true
                        end
                    end
                end
            end
        end
        return false
    end

    local function getNearestDungeonModel()
        local map = workspace:FindFirstChild("Map")
        if not map then return nil end
        local dungeon = map:FindFirstChild("Dungeon")
        if not dungeon then return nil end

        local nearest, nearestDist
        local myPos = (hrp and hrp.Position) or Vector3.new(0,0,0)
        for _, mdl in ipairs(dungeon:GetChildren()) do
            if mdl:IsA("Model") then
                local pos
                if mdl.PrimaryPart then
                    pos = mdl.PrimaryPart.Position
                else
                    local ok, pivot = pcall(function() return mdl:GetPivot().Position end)
                    pos = ok and pivot or nil
                end
                if pos then
                    local d = (myPos - pos).Magnitude
                    if not nearestDist or d < nearestDist then
                        nearest = mdl
                        nearestDist = d
                    end
                end
            end
        end
        return nearest
    end

    local function checkDungeonExitOnModel(mdl)
        if not mdl then return nil end
        local exit = mdl:FindFirstChild("ExitTeleporter", true)
        if not exit then return nil end
        local root = exit:FindFirstChild("Root")
        if not root or not root:IsA("BasePart") then return nil end
        local hasTouch = root:FindFirstChild("TouchInterest") or root:FindFirstChildOfClass("TouchTransmitter")
        if hasTouch then return root end
        return nil
    end

    -- follow and root handlers (giữ logic cũ với điều chỉnh cho Random mode)
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

        -- NEW: Random mode behavior: mark immediately and stop following non-priority enemies,
        -- so scanning can pick next unmarked enemy. Priority enemies unaffected.
        if dungeonMode == MODE_RANDOM and not isPriorityTarget then
            -- mark this enemy now
            pcall(function() markedEnemies[enemy] = true end)

            -- release follow immediately (we already moved to its position), allow scanning to choose next
            followLock = false
            currentTarget = nil
            return
        end

        -- original loop (Nearest behavior or priority enemy in Random mode)
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

    -- main scanning loop
    task.spawn(function()
        while true do
            task.wait(SCAN_INTERVAL)
            if not autoDungeon then continue end
            if not hrp or not hrp.Parent then continue end
            if pauseForExit then continue end

            farmCenter = hrp.Position

            local priorityEnemy = getNearestPriorityEnemy(farmCenter)
            if priorityEnemy then
                task.spawn(function() pcall(function() followEnemy(priorityEnemy) end) end)
                continue
            end

            local enemy = getNearestEnemy(farmCenter)
            if enemy then
                task.spawn(function() pcall(function() followEnemy(enemy) end) end)
                continue
            end

            -- If in Random mode and there are alive non-priority enemies but none returned because all are marked,
            -- then reset markedEnemies so we can repeat the cycle.
            if dungeonMode == MODE_RANDOM then
                local anyNonPriority = anyAliveNonPriorityEnemies(farmCenter)
                if anyNonPriority then
                    -- none returned but some exist -> likely all are marked; reset marks
                    markedEnemies = {}
                    -- continue loop to pick targets again
                    continue
                end
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

    -- ========== ModeDungeonButton handling & visuals ==========
    local function applyModeVisuals(mode)
        if not modeBtn then return end
        local color = (mode == MODE_NEAREST) and MODE_NEAREST_COLOR or MODE_RANDOM_COLOR
        -- instant set (no flicker) to match user spec
        pcall(function() modeBtn.BackgroundColor3 = color end)
        if modeStroke then pcall(function() modeStroke.Color = color end) end
        local textObj = getTextHolder(modeBtn)
        if textObj then
            pcall(function() textObj.TextTransparency = 0 end)
            pcall(function() textObj.Text = MODE_TEXT[mode] or ("Mode: " .. mode) end)
        end
    end

    local function toggleDungeonMode()
        dungeonMode = (dungeonMode == MODE_NEAREST) and MODE_RANDOM or MODE_NEAREST
        -- when switching back to Nearest, clear marks to avoid stale marks
        if dungeonMode == MODE_NEAREST then
            markedEnemies = {}
        end
        applyModeVisuals(dungeonMode)
        pcall(function() player:SetAttribute("DungeonMode", dungeonMode) end)
    end

    -- initialize mode visuals (default Nearest)
    if modeBtn then
        applyModeVisuals(dungeonMode)

        local function onModeActivated()
            toggleDungeonMode()
        end
        if modeBtn.Activated then
            modeBtn.Activated:Connect(onModeActivated)
        else
            modeBtn.MouseButton1Click:Connect(onModeActivated)
        end
    else
        -- no modeBtn found: still set attribute for scripts reading it
        pcall(function() player:SetAttribute("DungeonMode", dungeonMode) end)
    end

end

--=== SELECT BUFF DUNGEON ===================================================================================================================--

do
    loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM_UI/Dungeon_SelectBuff_UI.lua"))()
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
