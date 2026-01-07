local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ================= SETTINGS =================
local LUNGE_SPEED = 300
local TELEPORT_HEIGHT = 100

local TARGET_POSITION = Vector3.new(-4992.52, 357.78, -3051.24)

local TELEPORT_SPAM_COUNT = 10
local TELEPORT_SPAM_TIME = 1.5
-- ============================================

-- ================= PLACE DATA =================
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

-- 🔹 Lấy teleportPoints theo PlaceId
local TELEPORT_POINTS = {}

do
    local placeId = game.PlaceId

    for _, data in pairs(PLACES) do
        if table.find(data.ids, placeId) then
            TELEPORT_POINTS = data.points
            break
        end
    end

    if #TELEPORT_POINTS == 0 then
        warn("PlaceID không thuộc Sea1 / Sea2 / Sea3 / Dungeon")
    end
end
-- ============================================

local movementToken = 0

local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function distance(a, b)
    return (a - b).Magnitude
end

-- 🔹 Chọn teleport point tối ưu
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
    if distance(fromPos, targetPos) <= bestDist then
        return nil
    end

    return bestPoint
end

local function teleport(pos)
    getHRP().CFrame = CFrame.new(pos)
end

local function lungeTo(targetPos)
    local hrp = getHRP()
    local myToken = movementToken

    local startPos = hrp.Position
    local delta = targetPos - startPos
    local distance = delta.Magnitude
    if distance < 1 then return end

    local direction = delta.Unit
    local duration = distance / LUNGE_SPEED
    local elapsed = 0

    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if myToken ~= movementToken then
            conn:Disconnect()
            return
        end

        elapsed += dt
        local alpha = math.clamp(elapsed / duration, 0, 1)

        -- 🔒 vị trí lướt tuyệt đối, không physics
        hrp.CFrame = CFrame.new(startPos + direction * (distance * alpha))

        if alpha >= 1 then
            conn:Disconnect()
        end
    end)
end

local function stopMovement()
    movementToken += 1
end

local function teleportSpam(pos)
    local hrp = getHRP()
    local myToken = movementToken

    local done = false
    local count = 0
    local interval = TELEPORT_SPAM_TIME / TELEPORT_SPAM_COUNT
    local elapsed = 0

    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if myToken ~= movementToken then
            conn:Disconnect()
            done = true
            return
        end

        elapsed += dt
        if elapsed >= interval then
            elapsed = 0
            count += 1
            hrp.CFrame = CFrame.new(pos)

            if count >= TELEPORT_SPAM_COUNT then
                conn:Disconnect()
                done = true
            end
        end
    end)

    -- chờ teleport spam xong hoặc bị hủy
    while not done and myToken == movementToken do
        task.wait()
    end

    return myToken == movementToken
end

-- ================= MAIN =================
local function executeMovement()
    stopMovement()

    local hrp = getHRP()
    local bestTeleport = getBestTeleportPoint(hrp.Position, TARGET_POSITION)

    if bestTeleport then
        local ok = teleportSpam(bestTeleport)
        if not ok then return end

        teleport(bestTeleport + Vector3.new(0, TELEPORT_HEIGHT, 0))
        task.wait(0.05)
    end

    lungeTo(TARGET_POSITION)
end

-- Chạy
executeMovement()

-- Có thể gọi bất cứ lúc nào:
-- stopMovement()
