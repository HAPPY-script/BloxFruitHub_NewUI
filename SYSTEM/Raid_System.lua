local ScrollingTab = game.Players.LocalPlayer.PlayerGui:WaitForChild("BloxFruitHubGui"):WaitForChild("Main"):WaitForChild("ScrollingTab")

--=== RAID ===================================================================================================================--
do
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")

    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    -- LẤY UI MỚI: ScrollingTab -> tìm Frame "Raid" -> trong đó tìm "AutoRaidButton"
    local ScrollingTab = player
        .PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    local raidFrame = ScrollingTab:FindFirstChild("Raid", true)
    if not raidFrame then
        warn("Không tìm thấy Frame 'Raid' trong ScrollingTab")
        return
    end

    local BUTTON_NAME = "AutoRaidButton"
    local toggleRaid = raidFrame:FindFirstChild(BUTTON_NAME, true)
    if not toggleRaid then
        warn("Không tìm thấy Button:", BUTTON_NAME)
        return
    end

    -- colors
    local COLOR_RED = Color3.fromRGB(255, 0, 0)
    local COLOR_GREEN = Color3.fromRGB(0, 255, 0)
    local COLOR_YELLOW = Color3.fromRGB(255, 255, 0)

    -- helper: tìm UIStroke bên trong button (nếu có)
    local function findStroke(instance)
        for _, c in ipairs(instance:GetChildren()) do
            if c:IsA("UIStroke") then return c end
        end
        for _, c in ipairs(instance:GetDescendants()) do
            if c:IsA("UIStroke") then return c end
        end
        return nil
    end

    local stroke = findStroke(toggleRaid)

    -- trạng thái điều khiển
    local running = false
    local autoClicking = false
    local isClearingIsland = false

    -- bảo vệ spam click & animation
    local clickDebounce = false
    local animatingNoIsland = false

    -- helper set visual state của button (ON/OFF)
    local function setToggleVisual(on)
        running = on
        autoClicking = on
        if on then
            pcall(function() toggleRaid.Text = "ON" end)
            pcall(function() toggleRaid.BackgroundColor3 = COLOR_GREEN end)
        else
            pcall(function() toggleRaid.Text = "OFF" end)
            pcall(function() toggleRaid.BackgroundColor3 = COLOR_RED end)
        end
    end

    -- reset về OFF (không gọi ToggleUI)
    local function resetRaidButton()
        running = false
        autoClicking = false
        pcall(function() toggleRaid.Text = "OFF" end)
        pcall(function() toggleRaid.BackgroundColor3 = COLOR_RED end)
    end

    -- kiểm tra đảo gần
    local function hasIslandNearby()
        local map = workspace:FindFirstChild("Map")
        if not map then return false end
        local raidMap = map:FindFirstChild("RaidMap")
        if not raidMap then return false end

        for _, island in ipairs(raidMap:GetChildren()) do
            if island:IsA("Model") then
                local root = island.PrimaryPart or island:FindFirstChildWhichIsA("BasePart")
                if root then
                    if (hrp.Position - root.Position).Magnitude <= 4000 then
                        return true
                    end
                end
            end
        end

        return false
    end

    -- FLASH khi không có island: tween → vàng (2s) → tween về đỏ (2s)
    local function flashNoIsland()
        if animatingNoIsland then return end
        animatingNoIsland = true

        local origBg = toggleRaid.BackgroundColor3 or COLOR_RED
        local origStrokeColor = stroke and stroke.Color or nil

        -- tween to yellow (2s)
        local t1 = TweenService:Create(toggleRaid, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = COLOR_YELLOW })
        local strokeTween1
        if stroke then
            strokeTween1 = TweenService:Create(stroke, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Color = COLOR_YELLOW })
            strokeTween1:Play()
        end
        t1:Play()
        t1.Completed:Wait()

        -- tween back to red (2s)
        local t2 = TweenService:Create(toggleRaid, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = COLOR_RED })
        local strokeTween2
        if stroke then
            strokeTween2 = TweenService:Create(stroke, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Color = origStrokeColor or COLOR_RED })
            strokeTween2:Play()
        end
        t2:Play()
        t2.Completed:Wait()

        pcall(function() toggleRaid.Text = "OFF" end)
        animatingNoIsland = false
    end

    -- Event handler: khi bấm nút (Activated ưu tiên)
    local function onToggleClicked()
        if clickDebounce then return end
        clickDebounce = true
        task.delay(0.20, function() clickDebounce = false end) -- short debounce to avoid spam

        -- nếu muốn bật mà không có island -> flash và KHÔNG bật
        if not running and not hasIslandNearby() then
            if not animatingNoIsland then
                pcall(function() toggleRaid.Text = "NO ISLAND" end)
                task.spawn(function()
                    flashNoIsland()
                end)
            end
            return
        end

        -- toggle thực sự (KHÔNG liên quan tới ToggleUI cũ)
        local newState = not running
        setToggleVisual(newState)

        if running then
            pcall(function()
                player:SetAttribute("FastAttackEnemyMode", "Toggle")
                player:SetAttribute("FastAttackEnemy", true)
            end)
        else
            pcall(function()
                player:SetAttribute("FastAttackEnemy", false)
            end)
        end
    end

    if toggleRaid.Activated then
        toggleRaid.Activated:Connect(onToggleClicked)
    else
        toggleRaid.MouseButton1Click:Connect(onToggleClicked)
    end

    -- phần auto click remote (giữ nguyên logic của bạn)
    task.spawn(function()
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

    -- Các hàm liên quan tới di chuyển, tìm island, getEnemiesNear, followEnemy, highlight...
    -- ensureAnchor
    local anchor = nil
    local function ensureAnchor()
        if not anchor or not anchor.Parent then
            anchor = Instance.new("Part")
            anchor.Anchored = true
            anchor.CanCollide = false
            anchor.Transparency = 1
            anchor.Size = Vector3.new(1, 1, 1)
            anchor.CFrame = hrp.CFrame
            anchor.Parent = workspace
        end
        return anchor
    end

    -- tweenCloseTo
    local function tweenCloseTo(targetPos, stopDist, isEnemy)
        if not hrp then return end
        stopDist = stopDist or 40
        local currentPos = hrp.Position

        local targetY = targetPos.Y
        if isEnemy then
            targetY = targetPos.Y + 100
        end

        hrp.CFrame = CFrame.new(currentPos.X, targetY, currentPos.Z)

        local horizontalDist = (Vector2.new(currentPos.X, currentPos.Z)
                               - Vector2.new(targetPos.X, targetPos.Z)).Magnitude

        if horizontalDist > stopDist then
            local direction = (Vector2.new(targetPos.X, targetPos.Z)
                             - Vector2.new(hrp.Position.X, hrp.Position.Z)).Unit

            local targetXZ = Vector2.new(targetPos.X, targetPos.Z) - direction * stopDist
            local targetPoint = Vector3.new(targetXZ.X, targetY, targetXZ.Y)

            local time = horizontalDist / 300

            local tween = TweenService:Create(
                hrp,
                TweenInfo.new(time, Enum.EasingStyle.Linear),
                { CFrame = CFrame.new(targetPoint) }
            )
            tween:Play()
            tween.Completed:Wait()
        end
    end

    -- getHighestPriorityIsland
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
                        if dist <= 3500 then
                            if index > bestPriority then
                                bestPriority = index
                                bestIsland = island
                            end
                        end
                    end
                end
            end
        end

        return bestIsland
    end

    -- getEnemiesNear
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

    -- updateHighlight
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

    -- followEnemy
    local function followEnemy(enemy)
        if not enemy or not enemy.Parent then return end

        isClearingIsland = true

        local hrpEnemy = enemy:FindFirstChild("HumanoidRootPart")
        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
        if not hrpEnemy or not humanoid then return end

        updateHighlight(enemy)
        local anchor = ensureAnchor()
        local camera = workspace.CurrentCamera

        camera.CameraType = Enum.CameraType.Custom
        camera.CameraSubject = anchor

        while humanoid.Health > 0 and running do
            if not hrp then break end

            updateHighlight(enemy)

            local anchorY = hrpEnemy.Position.Y + 25
            local targetPos = Vector3.new(hrpEnemy.Position.X, anchorY, hrpEnemy.Position.Z)

            anchor.Position = anchor.Position:Lerp(targetPos, 0.15)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(targetPos), 0.25)

            RunService.RenderStepped:Wait()
        end

        if hrp then
            camera.CameraSubject = hrp
        end

        isClearingIsland = false
    end

    -- reset khi respawn
    player.CharacterAdded:Connect(function(newChar)
        character = newChar
        hrp = character:WaitForChild("HumanoidRootPart")
        resetRaidButton()
    end)

    -- vòng lặp chính Auto RAID (giữ logic gốc, chỉ dùng biến 'running')
    task.spawn(function()
        while true do
            RunService.Heartbeat:Wait()
            if not hrp then continue end

            if running and hrp.Position.Y < -1 then
                hrp.CFrame = hrp.CFrame + Vector3.new(0, 200, 0)
            end

            if running and not hasIslandNearby() then
                resetRaidButton()
                continue
            end

            if not running then continue end

            local island = getHighestPriorityIsland()
            if island and not isClearingIsland then
                local root = island:FindFirstChild("PrimaryPart") or island:FindFirstChildWhichIsA("BasePart")
                if root then
                    local islandCenter = (function(m)
                        if not m then return nil end
                        local cf, size = m:GetBoundingBox()
                        local center = cf.Position
                        center = center + Vector3.new(0, size.Y/2, 0)
                        return center
                    end)(island)

                    tweenCloseTo(islandCenter, 1)
                    RunService.RenderStepped:Wait()

                    local timer = 0
                    while timer < 1 do
                        if #getEnemiesNear(hrp) > 0 then
                            break
                        end
                        timer += task.wait(1)
                    end
                end
            end

            local enemies = getEnemiesNear(hrp)
            if #enemies > 0 then
                for _, enemy in ipairs(enemies) do
                    local enemyHRP = enemy:FindFirstChild("HumanoidRootPart")
                    if enemyHRP then
                        tweenCloseTo(enemyHRP.Position, 250, true)
                    end

                    followEnemy(enemy)
                    if not running then break end
                end
            end
        end
    end)
end

--=== BUY MICROPCHIP ===================================================================================================================--

