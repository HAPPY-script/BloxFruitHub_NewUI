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
        local c = button.BackgroundColor3
        -- chính xác so sánh RGB 0,255,0 là ON; mọi màu khác là OFF
        return (math.floor(c.R * 255) == 0 and math.floor(c.G * 255) == 255 and math.floor(c.B * 255) == 0)
    end

    -- trạng thái hoạt động thật của script (đồng bộ với button màu)
    local collectFruitEnabled = isButtonOn()

    -- khi user bấm → gửi yêu cầu cho hệ thống UI đổi trạng thái
    button.Activated:Connect(function()
        ToggleUI.Set(BUTTON_NAME, not isButtonOn())
    end)

    -- khi UI đổi màu → cập nhật trạng thái script; nếu tắt → hủy chuyển động
    button:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        local was = collectFruitEnabled
        collectFruitEnabled = isButtonOn()
        if was and not collectFruitEnabled then
            -- tắt giữa chừng => cancel
            -- cancelMotion được định nghĩa bên dưới, dùng global motionId
            -- nhưng để tránh forward reference, ta sẽ hoán vị khai báo motion trước (tiếp theo)
        end
    end)

    -- ==== MOTION CONTROLLER ====
    local motionId = 0
    local function cancelMotion()
        motionId = motionId + 1
    end

    -- update: khi respawn => hủy motion
    player.CharacterAdded:Connect(function()
        cancelMotion()
    end)

    -- we re-connect BackgroundColor3 handler to cancel properly (ensure cancelMotion available)
    -- Remove previous connection? Simpler: add another listener that cancels on OFF
    button:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        if not isButtonOn() then cancelMotion() end
    end)

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

    -- ==== LOGIC AUTO COLLECT ====

    local function calculateDistance(a, b)
        return (a - b).Magnitude
    end

    -- teleportRepeatedly:
    -- - chỉ tween X/Z (Y giữ nguyên trong quá trình tween)
    -- - nếu opts.setYAfter và opts.targetY thì sau opts.setYAfter giây sẽ set Y = targetY (nếu motionId không đổi)
    local function teleportRepeatedly(pos, duration, opts)
        opts = opts or {}
        local myId = motionId
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then hrp = player.CharacterAdded:Wait():WaitForChild("HumanoidRootPart") end

        local t0 = tick()
        local startPos = hrp.Position
        local startXZ = Vector3.new(startPos.X, 0, startPos.Z)
        local targetXZ = Vector3.new(pos.X, 0, pos.Z)

        -- guard
        if duration <= 0 then
            if myId ~= motionId then return end
            if not collectFruitEnabled then return end
            local newPos = Vector3.new(targetXZ.X, hrp.Position.Y, targetXZ.Z)
            hrp.CFrame = CFrame.new(newPos)
        else
            while true do
                if myId ~= motionId then return end
                if not collectFruitEnabled then return end
                local elapsed = tick() - t0
                local alpha = elapsed / duration
                if alpha >= 1 then
                    local finalPos = Vector3.new(targetXZ.X, hrp.Position.Y, targetXZ.Z)
                    hrp.CFrame = CFrame.new(finalPos)
                    break
                else
                    -- linear interpolate XZ only
                    local nx = startXZ.X + (targetXZ.X - startXZ.X) * alpha
                    local nz = startXZ.Z + (targetXZ.Z - startXZ.Z) * alpha
                    local newPos = Vector3.new(nx, hrp.Position.Y, nz)
                    hrp.CFrame = CFrame.new(newPos)
                    RunService.Heartbeat:Wait()
                end
            end
        end

        -- if requested, set Y after given delay (e.g., 2s)
        if opts.setYAfter and type(opts.targetY) == "number" then
            local setAfter = opts.setYAfter
            local thisId = motionId
            task.delay(setAfter, function()
                -- only apply if motion not canceled and still same original motion
                if thisId ~= motionId then return end
                if not collectFruitEnabled then return end
                local hrp2 = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if not hrp2 then return end
                local cur = hrp2.Position
                hrp2.CFrame = CFrame.new(cur.X, opts.targetY, cur.Z)
            end)
        end
    end

    -- performLunge:
    -- - di chuyển hướng tới mục tiêu
    -- - chỉ tween X/Z; giữ Y = targetY (set ngay từ đầu)
    -- - cancelable via motionId
    local function performLunge(targetPos)
        local myId = motionId
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        -- target Y assigned immediately
        local targetY = targetPos.Y

        local lungeSpeed = 300
        local tpThreshold = 300

        -- loop bằng frame, mỗi bước chỉ sửa X,Z, set Y = targetY
        while true do
            if myId ~= motionId then return end
            if not collectFruitEnabled then return end

            local curPos = hrp.Position
            local dirVec = Vector3.new(targetPos.X - curPos.X, 0, targetPos.Z - curPos.Z)
            local distXZ = dirVec.Magnitude
            -- nếu gần trong XZ <= threshold (tính theo 3D khoảng cách tới mục tiêu)
            local fullDist = (Vector3.new(targetPos.X, targetY, targetPos.Z) - Vector3.new(curPos.X, targetY, curPos.Z)).Magnitude
            if fullDist <= tpThreshold then
                -- set đúng vị trí mục tiêu (bao gồm Y)
                hrp.CFrame = CFrame.new(targetPos)
                return
            end

            if distXZ == 0 then
                -- tránh chia cho 0
                hrp.CFrame = CFrame.new(targetPos.X, targetY, targetPos.Z)
                return
            end

            local dt = RunService.Heartbeat:Wait()
            local move = lungeSpeed * dt
            if move >= distXZ then
                -- sẽ tới
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
        local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not myPos then
            myPos = player.CharacterAdded:Wait():WaitForChild("HumanoidRootPart")
        end
        myPos = myPos.Position

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
        if not collectFruitEnabled then return end
        local fruitPart =
            fruit:FindFirstChild("Handle")
            or fruit:FindFirstChild("Main")
            or fruit:FindFirstChild("Part")
            or fruit:FindFirstChildWhichIsA("BasePart")

        if not fruitPart then return end

        local fruitPos = fruitPart.Position
        local tpPos, tpToFruitDist, playerToFruitDist = findNearestTeleportPoint(fruitPos)

        -- bump motion token for this new job
        cancelMotion()
        local myJobId = motionId

        if playerToFruitDist < tpToFruitDist or #teleportPoints == 0 then
            -- lướt thẳng (performLunge will set Y = fruit Y immediately)
            performLunge(fruitPos)
        else
            -- dùng đường tắt: tween XZ đến tpPos, không đổi Y; sau 2s set Y = fruitY; rồi tween lên tpPos+ (0,100,0) then lunge
            -- first tween to tpPos (XZ only), request Y set after 2s to fruitPos.Y
            teleportRepeatedly(tpPos, 1, { setYAfter = 2, targetY = fruitPos.Y })

            -- then tween up (tpPos + 0,100,0)
            teleportRepeatedly(tpPos + Vector3.new(0, 100, 0), 0.3)

            task.wait(0.1)

            -- if still same job and enabled => lunge to fruit
            if myJobId == motionId and collectFruitEnabled then
                performLunge(fruitPos)
            end
        end
    end

    -- main loop: scan and collect
    task.spawn(function()
        while true do
            if collectFruitEnabled then
                for _, obj in pairs(workspace:GetChildren()) do
                    if isFruit(obj) then
                        goToFruit(obj)
                        break
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end
