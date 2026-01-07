local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ================= SETTINGS =================
local LUNGE_SPEED = 300
local TELEPORT_HEIGHT = 100

local TELEPORT_POINTS = {
    Vector3.new(-5073.83, 314.51, -3152.52),
    Vector3.new(-4607.82, 872.54, -1667.56),
    Vector3.new(-286.99, 306.18, 597.75)
}

local TARGET_POSITION = Vector3.new(-4992.52, 357.78, -3051.24)
-- ============================================

local movementToken = 0 -- dùng để hủy chuyển động

local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function distance(a, b)
    return (a - b).Magnitude
end

-- 🔹 Chọn teleport point tốt nhất
local function getBestTeleportPoint(fromPos, targetPos)
    local bestPoint, bestDist = nil, math.huge

    for _, p in ipairs(TELEPORT_POINTS) do
        local d = distance(p, targetPos)
        if d < bestDist then
            bestDist = d
            bestPoint = p
        end
    end

    if not bestPoint then return nil end

    -- nếu teleport không lợi hơn đứng tại chỗ → bỏ
    if distance(fromPos, targetPos) <= bestDist then
        return nil
    end

    return bestPoint
end

-- 🔹 Teleport tức thì
local function teleport(pos)
    local hrp = getHRP()
    hrp.CFrame = CFrame.new(pos)
end

-- 🔹 Lướt – có thể hủy
local function lungeTo(targetPos)
    local hrp = getHRP()
    local myToken = movementToken

    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if myToken ~= movementToken then
            conn:Disconnect()
            return
        end

        local dir = targetPos - hrp.Position
        local dist = dir.Magnitude

        if dist < 2 then
            conn:Disconnect()
            return
        end

        hrp.CFrame += dir.Unit * math.min(LUNGE_SPEED * dt, dist)
    end)
end

-- 🔹 Stop toàn bộ di chuyển
local function stopMovement()
    movementToken += 1
end

-- ================= MAIN LOGIC =================
local function executeMovement()
    stopMovement() -- hủy mọi chuyển động cũ

    local hrp = getHRP()
    local currentPos = hrp.Position

    local bestTeleport = getBestTeleportPoint(currentPos, TARGET_POSITION)

    if bestTeleport then
        teleport(bestTeleport)
        teleport(bestTeleport + Vector3.new(0, TELEPORT_HEIGHT, 0))
        task.wait(0.05)
    end

    lungeTo(TARGET_POSITION)
end

-- Chạy
executeMovement()

-- Ví dụ ngưng giữa chừng:
-- stopMovement()
