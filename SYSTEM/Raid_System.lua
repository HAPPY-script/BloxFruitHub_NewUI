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

                task.wait(2)

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

        if running then
            -- same attribute behavior as trước
            player:SetAttribute("FastAttackEnemyMode", "Toggle")
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
