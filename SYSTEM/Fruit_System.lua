--=== Auto Fruit Collection =====================================================================================================--

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local player = Players.LocalPlayer

    -- ==== UI NEW SYSTEM ====
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI

    local BUTTON_NAME = "AutoFruitCollectionButton"

    local ScrollingTab = player
        .PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    local FruitFrame = ScrollingTab:WaitForChild("Fruit")
    local button = FruitFrame:FindFirstChild(BUTTON_NAME, true)

    if not button then
        warn("Không tìm thấy button:", BUTTON_NAME)
        return
    end

    ToggleUI.Refresh()
    ToggleUI.Set(BUTTON_NAME, false)

    -- đọc màu để xác định trạng thái
    local function isButtonOn()
        local ok, c = pcall(function() return button.BackgroundColor3 end)
        if not ok or not c then return false end
        return (math.floor(c.R * 255 + 0.5) == 0 and math.floor(c.G * 255 + 0.5) == 255 and math.floor(c.B * 255 + 0.5) == 0)
    end

    -- trạng thái hoạt động (đồng bộ theo màu)
    local collectFruitEnabled = isButtonOn()

    -- khi user bấm → gửi yêu cầu cho hệ thống UI đổi trạng thái
    if button.Activated then
        button.Activated:Connect(function()
            pcall(function() ToggleUI.Set(BUTTON_NAME, not isButtonOn()) end)
        end)
    else
        button.MouseButton1Click:Connect(function()
            pcall(function() ToggleUI.Set(BUTTON_NAME, not isButtonOn()) end)
        end)
    end

    -- ==== MOTION / PAUSE CONTROLLER ====
    local motionId = 0        -- bump to cancel job
    local paused = false      -- true while respawning
    local function cancelMotion() motionId = motionId + 1 end

    -- pause on character removing (respawn process)
    player.CharacterRemoving:Connect(function()
        paused = true
    end)
    -- resume when new character added and HRP ready
    player.CharacterAdded:Connect(function(char)
        -- ensure HRP ready
        char:WaitForChild("HumanoidRootPart", 5)
        paused = false
    end)

    -- when UI turns OFF, we must cancel any job (stop permanently until color is green again)
    button:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        local on = isButtonOn()
        if not on then
            -- stop current motion immediately; do not change UI here
            cancelMotion()
            collectFruitEnabled = false
        else
            -- if turned on, update internal flag
            collectFruitEnabled = true
        end
    end)

    -- ensure internal flag initially matches color
    collectFruitEnabled = isButtonOn()

    -- ==== PLACES -> teleportPoints selection ====
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

    local teleportPoints = {}
    do
        local placeId = game.PlaceId
        for _, data in pairs(PLACES) do
            if table.find(data.ids, placeId) then
                teleportPoints = data.points
                break
            end
        end
        if #teleportPoints == 0 then
            warn("PlaceID không thuộc Sea1 / Sea2 / Sea3 / Dungeon")
        end
    end

    -- helpers
    local function calculateDistance(a, b) return (a - b).Magnitude end

    -- helper: wait while paused/resume but also abort if motion changed or collect disabled
    local function waitWhilePaused(myId)
        while paused do
            if myId ~= motionId then return false end
            if not collectFruitEnabled then return false end
            RunService.Heartbeat:Wait()
        end
        return (myId == motionId) and collectFruitEnabled
    end

    -- teleportRepeatedly:
    -- pos: Vector3 target
    -- duration: seconds
    -- opts = { setYAfter = number (s), targetRef = object (optional) , targetY = number (optional) }
    local function teleportRepeatedly(pos, duration, opts)
        opts = opts or {}
        local myId = motionId

        -- initial HRP fetch
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            if not waitWhilePaused(myId) then return end
            hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then
                -- can't get HRP -> cancel
                return
            end
        end

        local t0 = tick()
        local startPos = hrp.Position
        local startXZ = Vector3.new(startPos.X, 0, startPos.Z)
        local targetXZ = Vector3.new(pos.X, 0, pos.Z)

        if duration <= 0 then
            if myId ~= motionId or not collectFruitEnabled then return end
            -- check target existence if provided
            if opts.targetRef and (not opts.targetRef.Parent) then return end
            local newPos = Vector3.new(targetXZ.X, hrp.Position.Y, targetXZ.Z)
            hrp.CFrame = CFrame.new(newPos)
        else
            while true do
                if myId ~= motionId then return end
                if not collectFruitEnabled then return end
                -- if there's a specific targetRef (fruit) and it no longer exists, stop job
                if opts.targetRef and not opts.targetRef.Parent then return end
                if paused then
                    if not waitWhilePaused(myId) then return end
                    -- after resume, refresh hrp and start positions to avoid jump
                    hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    -- recalc start positions so that tween continues from current pos
                    startPos = hrp.Position
                    startXZ = Vector3.new(startPos.X, 0, startPos.Z)
                    -- adjust t0 to reflect time already spent before pause:
                    t0 = tick()
                end

                local elapsed = tick() - t0
                local alpha = elapsed / duration
                if alpha >= 1 then
                    local finalPos = Vector3.new(targetXZ.X, hrp.Position.Y, targetXZ.Z)
                    hrp.CFrame = CFrame.new(finalPos)
                    break
                else
                    local nx = startXZ.X + (targetXZ.X - startXZ.X) * alpha
                    local nz = startXZ.Z + (targetXZ.Z - startXZ.Z) * alpha
                    local newPos = Vector3.new(nx, hrp.Position.Y, nz)
                    hrp.CFrame = CFrame.new(newPos)
                    RunService.Heartbeat:Wait()
                end
            end
        end

        -- custom setYAfter that respects pause and motionId and target existence
        if opts.setYAfter and type(opts.targetY) == "number" then
            local total = opts.setYAfter
            local myTimerId = motionId
            local elapsed = 0
            local lastT = tick()
            while elapsed < total do
                if myTimerId ~= motionId then return end
                if not collectFruitEnabled then return end
                if opts.targetRef and not opts.targetRef.Parent then return end
                if paused then
                    if not waitWhilePaused(myTimerId) then return end
                    lastT = tick()
                else
                    local now = tick()
                    elapsed = elapsed + (now - lastT)
                    lastT = now
                    RunService.Heartbeat:Wait()
                end
            end
            -- final application if still valid
            if myTimerId == motionId and collectFruitEnabled then
                local hrp2 = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp2 and (not opts.targetRef or opts.targetRef.Parent) then
                    local cur = hrp2.Position
                    hrp2.CFrame = CFrame.new(cur.X, opts.targetY, cur.Z)
                end
            end
        end
    end

    -- performLunge:
    -- targetPos: Vector3, targetRef: optional model (for existence check)
    local function performLunge(targetPos, targetRef)
        local myId = motionId

        -- if targetRef provided but gone already => abort
        if targetRef and not targetRef.Parent then return end

        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        local targetY = targetPos.Y
        local lungeSpeed = 300
        local tpThreshold = 300

        while true do
            if myId ~= motionId then return end
            if not collectFruitEnabled then return end
            if targetRef and not targetRef.Parent then return end
            if paused then
                if not waitWhilePaused(myId) then return end
                -- refresh hrp after resume
                character = player.Character or player.CharacterAdded:Wait()
                hrp = character:WaitForChild("HumanoidRootPart")
            end

            local curPos = hrp.Position
            local dirVec = Vector3.new(targetPos.X - curPos.X, 0, targetPos.Z - curPos.Z)
            local distXZ = dirVec.Magnitude
            local fullDist = (Vector3.new(targetPos.X, targetY, targetPos.Z) - Vector3.new(curPos.X, targetY, curPos.Z)).Magnitude
            if fullDist <= tpThreshold then
                -- set đúng vị trí mục tiêu (bao gồm Y)
                hrp.CFrame = CFrame.new(targetPos)
                return
            end

            if distXZ == 0 then
                hrp.CFrame = CFrame.new(targetPos.X, targetY, targetPos.Z)
                return
            end

            local dt = RunService.Heartbeat:Wait()
            local move = lungeSpeed * dt
            if move >= distXZ then
                hrp.CFrame = CFrame.new(targetPos.X, targetY, targetPos.Z)
                return
            else
                local step = dirVec.Unit * move
                local nx = curPos.X + step.X
                local nz = curPos.Z + step.Z
                hrp.CFrame = CFrame.new(nx, targetY, nz)
            end
        end
    end

    local function isFruit(obj)
        return obj:IsA("Model") and obj.Name:lower():find("fruit")
    end

    local function findNearestTeleportPoint(fruitPos)
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            if paused then
                -- wait until resume
                local tmpId = motionId
                if not waitWhilePaused(tmpId) then return nil, nil, math.huge end
                hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            else
                hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            end
        end
        if not hrp then return nil, math.huge, math.huge end
        local myPos = hrp.Position

        local closestPoint, closestDist = nil, math.huge
        for _, tpPos in pairs(teleportPoints) do
            local dist = calculateDistance(tpPos, fruitPos)
            if dist < closestDist then
                closestPoint = tpPos
                closestDist = dist
            end
        end
        return closestPoint, closestDist, calculateDistance(myPos, fruitPos)
    end

    local function goToFruit(fruit)
        -- do not start if UI is off
        if not collectFruitEnabled then return end
        if not fruit or not fruit.Parent then return end

        local fruitPart =
            fruit:FindFirstChild("Handle")
            or fruit:FindFirstChild("Main")
            or fruit:FindFirstChild("Part")
            or fruit:FindFirstChildWhichIsA("BasePart")

        if not fruitPart then return end

        local fruitPos = fruitPart.Position
        local tpPos, tpToFruitDist, playerToFruitDist = findNearestTeleportPoint(fruitPos)
        -- if nearest teleport point couldn't be determined -> treat as no teleportPoints
        if tpPos == nil then tpToFruitDist = math.huge end

        -- start a new job (bump motion token)
        cancelMotion()
        local myJobId = motionId

        -- attempt pathing
        if playerToFruitDist < tpToFruitDist or #teleportPoints == 0 then
            -- direct lunge (targetRef passed so we can abort if fruit removed)
            performLunge(fruitPos, fruit)
        else
            -- use teleport path: tween XZ to tpPos (no Y change),
            -- schedule setYAfter = 2 with respect to pause/resume and target existence
            teleportRepeatedly(tpPos, 1, { setYAfter = 2, targetY = fruitPos.Y, targetRef = fruit })

            -- then tween up
            teleportRepeatedly(tpPos + Vector3.new(0, 100, 0), 0.3, { targetRef = fruit })

            -- small wait
            task.wait(0.1)

            -- if still same job and UI still on and fruit exists -> lunge
            if myJobId == motionId and collectFruitEnabled and fruit and fruit.Parent then
                performLunge(fruitPos, fruit)
            end
        end
    end

    -- main loop: scan and collect
    task.spawn(function()
        while true do
            -- refresh internal enabled flag from color (in case external UI changed it)
            collectFruitEnabled = isButtonOn()
            if collectFruitEnabled then
                for _, obj in pairs(workspace:GetChildren()) do
                    if isFruit(obj) then
                        -- only goToFruit if fruit still exists and UI green
                        if isButtonOn() then
                            goToFruit(obj)
                        end
                        break
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end
