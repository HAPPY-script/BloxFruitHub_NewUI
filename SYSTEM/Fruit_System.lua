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

    -- trạng thái hoạt động thật của script
    local collectFruitEnabled = false

    -- ==== MOTION CONTROLLER ====
    local motionId = 0

    local function cancelMotion()
        motionId += 1
    end

    -- nếu respawn → hủy toàn bộ chuyển động đang chạy
    player.CharacterAdded:Connect(function()
        cancelMotion()
    end)

    -- nếu tắt toggle → cũng hủy
    button:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        collectFruitEnabled = isButtonOn()
        if not collectFruitEnabled then
            cancelMotion()
        end
    end)

    -- đọc màu để xác định trạng thái
    local function isButtonOn()
        local c = button.BackgroundColor3
        return (math.floor(c.R * 255) == 0 and math.floor(c.G * 255) == 255 and math.floor(c.B * 255) == 0)
    end

    -- lắng nghe khi UI đổi màu → cập nhật trạng thái script
    button:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        collectFruitEnabled = isButtonOn()
    end)

    -- khi user bấm → gửi yêu cầu cho hệ thống UI đổi trạng thái
    button.Activated:Connect(function()
        ToggleUI.Set(BUTTON_NAME, not isButtonOn())
    end)

    -- ==== LOGIC AUTO COLLECT (giữ nguyên) ====

    local teleportPoints = {
        Vector3.new(-286.99, 306.18, 597.75),
        Vector3.new(-6508.56, 83.24, -132.84),
        Vector3.new(923.21, 125.11, 32852.83),
        Vector3.new(2284.91, 15.20, 905.62)
    }

    local function calculateDistance(a, b)
        return (a - b).Magnitude
    end

    local function teleportRepeatedly(pos, duration)
        local myId = motionId
        local hrp = player.Character:WaitForChild("HumanoidRootPart")
        local t0 = tick()

        while tick() - t0 < duration do
            if myId ~= motionId then return end
            if not collectFruitEnabled then return end

            hrp.CFrame = CFrame.new(pos)
            RunService.Heartbeat:Wait()
        end
    end


    local function performLunge(targetPos, delayY)
        local myId = motionId
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        local lungeSpeed = 300
        local tpThreshold = 50

        local startTime = tick()
        local allowY = (delayY ~= true) -- nếu không phải teleport → Y update ngay

        while true do
            if myId ~= motionId then return end
            if not collectFruitEnabled then return end

            if delayY and not allowY and tick() - startTime >= 2 then
                allowY = true
            end

            local currentPos = hrp.Position
            local targetY = allowY and targetPos.Y or currentPos.Y

            local flatTarget = Vector3.new(targetPos.X, targetY, targetPos.Z)
            local delta = flatTarget - currentPos
            local dist = delta.Magnitude

            if dist <= tpThreshold then
                hrp.CFrame = CFrame.new(targetPos)
                return
            end

            local step = delta.Unit * (lungeSpeed * RunService.Heartbeat:Wait())
            hrp.CFrame = CFrame.new(currentPos + step)
        end
    end

    local function isFruit(obj)
        return obj:IsA("Model") and obj.Name:lower():find("fruit")
    end

    local function findNearestTeleportPoint(fruitPos)
        local myPos = player.Character:WaitForChild("HumanoidRootPart").Position
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
        local fruitPart =
            fruit:FindFirstChild("Handle")
            or fruit:FindFirstChild("Main")
            or fruit:FindFirstChild("Part")
            or fruit:FindFirstChildWhichIsA("BasePart")

        if not fruitPart then return end

        local fruitPos = fruitPart.Position
        local tpPos, tpToFruitDist, playerToFruitDist = findNearestTeleportPoint(fruitPos)

        if playerToFruitDist < tpToFruitDist then
            performLunge(fruitPos, false) -- đi trực tiếp → Y theo fruit luôn
        else
            teleportRepeatedly(tpPos, 1)
            teleportRepeatedly(tpPos + Vector3.new(0, 100, 0), 0.3)
            task.wait(0.1)
            performLunge(fruitPos, true) -- đi từ teleport → delay Y 2s
        end
    end

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
