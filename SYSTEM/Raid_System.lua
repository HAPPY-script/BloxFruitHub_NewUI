local ScrollingTab = game.Players.LocalPlayer.PlayerGui:WaitForChild("BloxFruitHubGui"):WaitForChild("Main"):WaitForChild("ScrollingTab")

--=== RAID ===================================================================================================================--

do
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local player = Players.LocalPlayer

    -- ======= UI NEW: wait ToggleUI và tìm nút trong ScrollingTab -> Raid -> AutoRaidButton
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI

    local BUTTON_NAME = "AutoRaidButton"

    -- gọi an toàn Refresh / Set nếu có
    if ToggleUI and type(ToggleUI.Refresh) == "function" then
        pcall(function() ToggleUI.Refresh() end)
    end
    if ToggleUI and type(ToggleUI.Set) == "function" then
        pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)
    end

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

    local raidBtn = raidFrame:FindFirstChild(BUTTON_NAME, true)
    if not raidBtn then
        warn("Không tìm thấy Button:", BUTTON_NAME)
        return
    end

    -- tìm UIStroke (nếu có) trong button (kiểm tra an toàn và gọi đúng)
    local btnStroke = nil
    if raidBtn.FindFirstChildWhichIsA then
        -- FindFirstChildWhichIsA nhận string class name, second arg recursive (true)
        pcall(function()
            btnStroke = raidBtn:FindFirstChildWhichIsA("UIStroke", true)
        end)
    end
    if not btnStroke then
        btnStroke = raidBtn:FindFirstChild("UIStroke")
    end

    -- màu dùng
    local COLOR_OFF       = Color3.fromRGB(255, 0, 0)     -- trở về ban đầu
    local COLOR_ON        = Color3.fromRGB(0, 255, 0)
    local COLOR_WARNING   = Color3.fromRGB(255, 255, 0)   -- tween sang vàng theo yêu cầu

    -- ======= trạng thái của hệ thống
    local running = false
    local autoClicking = false

    -- khóa để tránh re-entrance / spam
    local clickLock = false        -- khoá ngắn cho toggle bình thường
    local blockedAnim = false      -- khoá khi đang chạy animation NO-ISLAND (vàng->đỏ)
    local shortDebounceTime = 0.12

    -- helper: an toàn cancel tween cũ (không bắt buộc)
    local function safeCancel(t)
        if t and type(t.Cancel) == "function" then
            pcall(function() t:Cancel() end)
        end
    end

    -- cập nhật giao diện nút theo trạng thái running
    local function applyButtonState()
        if running then
            pcall(function()
                raidBtn.Text = "ON"
                raidBtn.BackgroundColor3 = COLOR_ON
                if btnStroke then pcall(function() btnStroke.Color = COLOR_ON end) end
            end)
        else
            pcall(function()
                raidBtn.Text = "OFF"
                raidBtn.BackgroundColor3 = COLOR_OFF
                if btnStroke then pcall(function() btnStroke.Color = COLOR_OFF end) end
            end)
        end
    end

    -- reset khi tắt / respawn
    local function resetRaidButton()
        running = false
        autoClicking = false
        applyButtonState()
    end

    -- hàm check island gần (giữ nguyên logic)
    local function hasIslandNearby()
        local map = workspace:FindFirstChild("Map")
        if not map then return false end
        local raidMap = map:FindFirstChild("RaidMap")
        if not raidMap then return false end

        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end

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

    -- khi spam click và không có island: tween sang vàng 2s rồi tween về đỏ 2s
    local function flashNoIslandAnimation()
        if blockedAnim then return end
        blockedAnim = true

        local tInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local bgToYellow = TweenService:Create(raidBtn, tInfo, { BackgroundColor3 = COLOR_WARNING })
        local strokeToYellow = btnStroke and TweenService:Create(btnStroke, tInfo, { Color = COLOR_WARNING }) or nil

        local bgToRed = TweenService:Create(raidBtn, tInfo, { BackgroundColor3 = COLOR_OFF })
        local strokeToRed = btnStroke and TweenService:Create(btnStroke, tInfo, { Color = COLOR_OFF }) or nil

        task.spawn(function()
            pcall(function()
                bgToYellow:Play()
                if strokeToYellow then strokeToYellow:Play() end
                bgToYellow.Completed:Wait()
            end)
            task.wait(0.03)
            pcall(function()
                bgToRed:Play()
                if strokeToRed then strokeToRed:Play() end
                bgToRed.Completed:Wait()
            end)
            blockedAnim = false
        end)
    end

    -- Kết nối nút (Activated ưu tiên)
    local function onButtonClick()
        if clickLock then return end
        clickLock = true
        task.delay(shortDebounceTime, function() clickLock = false end)

        if blockedAnim then return end

        if not running and not hasIslandNearby() then
            flashNoIslandAnimation()
            return
        end

        running = not running
        autoClicking = running

        -- gửi lệnh cho ToggleUI để đồng bộ, gọi an toàn
        if ToggleUI and type(ToggleUI.Set) == "function" then
            pcall(function() ToggleUI.Set(BUTTON_NAME, running) end)
        end

        applyButtonState()

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

    if raidBtn.Activated then
        raidBtn.Activated:Connect(onButtonClick)
    else
        raidBtn.MouseButton1Click:Connect(onButtonClick)
    end

    -- ======= Phần logic Auto RAID giữ nguyên (chỉ chuyển các tham chiếu toggleRaid -> raidBtn)
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
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

    local function getIslandCenter(model)
        if not model then return nil end
        local cf, size = model:GetBoundingBox()
        local center = cf.Position
        center = center + Vector3.new(0, size.Y/2, 0)
        return center
    end

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

    local function getEnemiesNear(origin)
        local enemies = {}
        local folder = workspace:FindFirstChild("Enemies")
        if not folder then return enemies end
        for _, mob in ipairs(folder:GetChildren()) do
            if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") then
                local dist = (origin.Position - mob.HumanoidRootPart.Position).Magnitude
                if dist <= 2500 and mob:FindFirstChildOfClass("Humanoid").Health > 0 then
                    table.insert(enemies, mob)
                end
            end
        end
        return enemies
    end

    local isClearingIsland = false

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
        isClearingIsland = true

        local hrpEnemy = enemy:FindFirstChild("HumanoidRootPart")
        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
        if not hrpEnemy or not humanoid then
            isClearingIsland = false
            return
        end

        updateHighlight(enemy)
        local anchorPart = ensureAnchor()
        local camera = workspace.CurrentCamera

        camera.CameraType = Enum.CameraType.Custom
        camera.CameraSubject = anchorPart

        while humanoid.Health > 0 and running do
            if not hrp then break end
            updateHighlight(enemy)
            local anchorY = hrpEnemy.Position.Y + 25
            local targetPos = Vector3.new(hrpEnemy.Position.X, anchorY, hrpEnemy.Position.Z)

            anchorPart.Position = anchorPart.Position:Lerp(targetPos, 0.15)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(targetPos), 0.25)

            RunService.RenderStepped:Wait()
        end

        if hrp then
            camera.CameraSubject = hrp
        end

        isClearingIsland = false
    end

    -- Auto click remote (giữ nguyên)
    task.spawn(function()
        while true do
            task.wait(0.4)
            if running then
                pcall(function()
                    local args = { 0.4000000059604645 }
                    ReplicatedStorage
                        :WaitForChild("Modules")
                        :WaitForChild("Net")
                        :WaitForChild("RE/RegisterAttack")
                        :FireServer(unpack(args))
                end)
            end
        end
    end)

    -- Reset khi respawn
    player.CharacterAdded:Connect(function(newChar)
        character = newChar
        hrp = character:WaitForChild("HumanoidRootPart")
        resetRaidButton()
    end)

    -- Vòng lặp chính Auto RAID
    task.spawn(function()
        while true do
            RunService.Heartbeat:Wait()
            if not hrp then continue end

            -- Anti fall
            if running and hrp.Position.Y < -1 then
                hrp.CFrame = hrp.CFrame + Vector3.new(0, 200, 0)
            end

            -- tự tắt khi không còn island
            if running and not hasIslandNearby() then
                resetRaidButton()
                continue
            end

            if not running then continue end

            local island = getHighestPriorityIsland()
            if island and not isClearingIsland then
                local root = island.PrimaryPart or island:FindFirstChildWhichIsA("BasePart")
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
                    if enemyHRP then
                        tweenCloseTo(enemyHRP.Position, 250, true)
                    end
                    followEnemy(enemy)
                    if not running then break end
                end
            end
        end
    end)

    -- Áp dụng trạng thái ban đầu (OFF)
    resetRaidButton()
end

--=== BUY MICROPCHIP ===================================================================================================================--

