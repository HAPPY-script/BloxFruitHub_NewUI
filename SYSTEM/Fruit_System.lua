--=== AUTO FRUIT COLLECTION =====================================================================================================--

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")

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
    pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)

    local function isButtonOn()
        local ok, c = pcall(function() return button.BackgroundColor3 end)
        if not ok or not c then return false end
        return (math.floor(c.R * 255 + 0.5) == 0 and math.floor(c.G * 255 + 0.5) == 255 and math.floor(c.B * 255 + 0.5) == 0)
    end

    -- internal flag driven by color
    local collectFruitEnabled = isButtonOn()

    -- click -> request ToggleUI change
    if button.Activated then
        button.Activated:Connect(function() pcall(function() ToggleUI.Set(BUTTON_NAME, not isButtonOn()) end) end)
    else
        button.MouseButton1Click:Connect(function() pcall(function() ToggleUI.Set(BUTTON_NAME, not isButtonOn()) end) end)
    end

    -- ==== PAUSE / MOVEMENT token controller ====
    -- We'll use movementToken like the sample (increment to cancel).
    local movementToken = 0
    local paused = false

    local function stopMovement()
        movementToken = movementToken + 1
    end

    -- pause while character removed; resume when added and HRP ready
    player.CharacterRemoving:Connect(function()
        paused = true
    end)
    player.CharacterAdded:Connect(function(char)
        char:WaitForChild("HumanoidRootPart", 5)
        paused = false
    end)

    -- when UI turned off -> permanently cancel current job(s)
    button:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        local on = isButtonOn()
        if not on then
            stopMovement()
            collectFruitEnabled = false
        else
            collectFruitEnabled = true
        end
    end)

    collectFruitEnabled = isButtonOn()

    -- ===== PLACES (unchanged) =====
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

    -- ===== movement settings (from sample) =====
    local LUNGE_SPEED = 300
    local TELEPORT_HEIGHT = 100
    local TELEPORT_SPAM_COUNT = 10
    local TELEPORT_SPAM_TIME = 1.5

    local function getHRP()
        local char = player.Character or player.CharacterAdded:Wait()
        return char:WaitForChild("HumanoidRootPart")
    end

    local function vecDistance(a,b) return (a-b).Magnitude end

    local function toXZ(pos, fixedY)
        return Vector3.new(pos.X, fixedY, pos.Z)
    end

    local function xzDistance(a, b)
        return (Vector3.new(a.X,0,a.Z) - Vector3.new(b.X,0,b.Z)).Magnitude
    end

    -- find best teleport as in sample
    local function getBestTeleportPoint(fromPos, targetPos)
        local bestPoint, bestDist = nil, math.huge
        for _, p in ipairs(teleportPoints) do
            local d = vecDistance(p, targetPos)
            if d < bestDist then
                bestDist = d
                bestPoint = p
            end
        end
        if not bestPoint then return nil end
        if vecDistance(fromPos, targetPos) <= bestDist then
            return nil
        end
        return bestPoint
    end

    -- teleport (instant)
    local function teleport(pos)
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = CFrame.new(pos) end
    end

    -- teleport spam: return true if completed; respects pause and token and targetRef
    local function teleportSpam(pos, token, targetRef)
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            -- if paused, wait for resume; else try to wait briefly
            local waited = 0
            while not hrp and waited < 5 do
                if token ~= movementToken then return false end
                hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then break end
                task.wait(0.1)
                waited = waited + 0.1
            end
            if not hrp then return false end
        end

        local count = 0
        local interval = TELEPORT_SPAM_TIME / math.max(1, TELEPORT_SPAM_COUNT)
        local elapsed = 0
        local done = false

        local conn
        conn = RunService.Heartbeat:Connect(function(dt)
            if token ~= movementToken then
                conn:Disconnect()
                done = true
                return
            end
            -- if paused or target gone: just skip doing teleports but keep token valid (we should pause)
            if paused then return end
            if targetRef and not targetRef.Parent then
                conn:Disconnect()
                done = true
                return
            end

            elapsed = elapsed + dt
            if elapsed >= interval then
                elapsed = elapsed - interval
                count = count + 1
                local ok, hrpNow = pcall(function()
                    return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                end)
                if ok and hrpNow then
                    hrpNow.CFrame = CFrame.new(pos)
                end
                if count >= TELEPORT_SPAM_COUNT then
                    conn:Disconnect()
                    done = true
                    return
                end
            end
        end)

        -- wait until finished or cancelled
        while not done do
            if token ~= movementToken then
                if conn and conn.Connected then conn:Disconnect() end
                return false
            end
            task.wait()
        end

        return token == movementToken
    end

    -- lungeTo (sample-style): yields until finished or cancelled; respects paused and targetRef
    local function lungeTo(targetPos, token, targetRef)
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            -- wait until HRP available or cancelled
            local waited = 0
            while (not hrp) and waited < 5 do
                if token ~= movementToken then return false end
                hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then break end
                task.wait(0.1)
                waited = waited + 0.1
            end
            if not hrp then return false end
        end

        -- Fix Y immediately to targetY
        local fixedY = targetPos.Y
        local startPos = toXZ(hrp.Position, fixedY)
        local endPos = toXZ(targetPos, fixedY)

        -- place hrp exactly at start XZ (keeps behavior stable)
        hrp.CFrame = CFrame.new(startPos)

        local delta = endPos - startPos
        local distance = xzDistance(startPos, endPos)
        if distance < 0.001 then
            hrp.CFrame = CFrame.new(targetPos)
            return token == movementToken
        end

        local direction = delta.Unit
        local duration = distance / LUNGE_SPEED
        local elapsed = 0
        local finished = false

        local conn
        conn = RunService.Heartbeat:Connect(function(dt)
            if token ~= movementToken then
                conn:Disconnect()
                finished = false
                return
            end
            if paused then return end
            if targetRef and not targetRef.Parent then
                conn:Disconnect()
                finished = false
                return
            end

            elapsed = elapsed + dt
            local alpha = math.clamp(elapsed / duration, 0, 1)

            local pos = startPos + direction * (distance * alpha)
            -- place hrp with fixed Y
            local put = Vector3.new(pos.X, fixedY, pos.Z)
            local hrpNow = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrpNow then hrpNow.CFrame = CFrame.new(put) end

            if alpha >= 1 then
                conn:Disconnect()
                finished = true
            end
        end)

        while not finished do
            if token ~= movementToken then
                if conn and conn.Connected then conn:Disconnect() end
                return false
            end
            task.wait()
        end

        -- final set
        if token == movementToken then
            local hrpNow = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrpNow and (not targetRef or targetRef.Parent) then
                hrpNow.CFrame = CFrame.new(targetPos)
            end
        end

        return token == movementToken
    end

    -- executeMovementTo (caller should increment movementToken before calling)
    local function executeMovementTo(targetPos, targetRef)
        local myToken = movementToken
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            -- wait up to short period (pause handled separately)
            local waited = 0
            while not hrp and waited < 5 do
                if myToken ~= movementToken then return false end
                hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                task.wait(0.1)
                waited = waited + 0.1
            end
            if not hrp then return false end
        end

        local bestTeleport = getBestTeleportPoint(hrp.Position, targetPos)
        if bestTeleport then
            -- spam teleports to bestTeleport
            local ok = teleportSpam(bestTeleport, myToken, targetRef)
            if not ok or movementToken ~= myToken then return false end

            -- teleport up and wait briefly (replicate sample)
            teleport(bestTeleport + Vector3.new(0, TELEPORT_HEIGHT, 0))
            task.wait(0.05)
            if movementToken ~= myToken then return false end

            -- after teleport path, we may want to set Y to exact targetY after 2s (caller handles this)
        end

        -- then lunge to target
        local ok2 = lungeTo(targetPos, myToken, targetRef)
        return ok2 and movementToken == myToken
    end

    -- ===== core helper functions =====
    local function isFruit(obj)
        return obj:IsA("Model") and obj.Name:lower():find("fruit")
    end

    local function calculateDistance(a,b) return (a-b).Magnitude end

    local function findNearestTeleportPoint(fruitPos)
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            -- short wait if paused
            local waited = 0
            while (not hrp) and waited < 3 do
                if paused then
                    -- wait longer if paused until resume
                    local t = 0
                    while paused do
                        task.wait(0.05)
                        t = t + 0.05
                        if t > 5 then break end
                    end
                end
                hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then break end
                task.wait(0.05)
                waited = waited + 0.05
            end
            if not hrp then return nil, math.huge, math.huge end
        end

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

    -- goToFruit: orchestration using movementToken + executeMovementTo + setYAfter
    local function goToFruit(fruit)
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
        if tpPos == nil then tpToFruitDist = math.huge end

        -- create new token for this job
        movementToken = movementToken + 1
        local myToken = movementToken

        -- path selection
        if playerToFruitDist < tpToFruitDist or #teleportPoints == 0 then
            -- direct lunge
            local ok = lungeTo(fruitPos, myToken, fruit)
            -- finished or cancelled; no further action
        else
            -- use teleport path
            local ok = teleportSpam(tpPos, myToken, fruit)
            if not ok or movementToken ~= myToken then return end

            -- after arriving at tpPos, teleport up
            teleport(tpPos + Vector3.new(0, TELEPORT_HEIGHT, 0))
            task.wait(0.05)
            if movementToken ~= myToken then return end

            -- set Y after 2s but respect pause/resume and target exist
            local total = 2
            local acc = 0
            local lastt = tick()
            while acc < total do
                if movementToken ~= myToken then return end
                if not collectFruitEnabled then return end
                if not fruit or not fruit.Parent then return end
                if paused then
                    -- wait until resume
                    local ok2 = true
                    while paused do
                        if movementToken ~= myToken then ok2 = false; break end
                        task.wait(0.05)
                    end
                    if not ok2 then return end
                    lastt = tick()
                else
                    local now = tick()
                    acc = acc + (now - lastt)
                    lastt = now
                    RunService.Heartbeat:Wait()
                end
            end

            if movementToken ~= myToken or not collectFruitEnabled or not fruit or not fruit.Parent then return end
            -- set target Y
            local hrpNow = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrpNow then
                local cur = hrpNow.Position
                hrpNow.CFrame = CFrame.new(cur.X, fruitPos.Y, cur.Z)
            end

            -- then lunge from current position to fruit
            if movementToken ~= myToken then return end
            lungeTo(fruitPos, myToken, fruit)
        end
    end

    -- main loop: scan and collect (like original)
    task.spawn(function()
        while true do
            collectFruitEnabled = isButtonOn()
            if collectFruitEnabled then
                for _, obj in pairs(workspace:GetChildren()) do
                    if isFruit(obj) then
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

--=== ESP FRUIT =====================================================================================================--

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")

    local player = Players.LocalPlayer
    local camera = workspace.CurrentCamera

    -- wait for ToggleUI helper
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)

    local BUTTON_NAME = "ESPFruitButton"

    -- ScrollingTab path (same as other scripts)
    local ScrollingTab = player
        .PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    -- find Fruit frame and button (search descendants)
    local FruitFrame = ScrollingTab:FindFirstChild("Fruit", true) or ScrollingTab:WaitForChild("Fruit", 5)
    if not FruitFrame then
        warn("Không tìm thấy Frame 'Fruit' trong ScrollingTab")
        return
    end

    local button = FruitFrame:FindFirstChild(BUTTON_NAME, true)
    if not button then
        warn("Không tìm thấy button:", BUTTON_NAME)
        return
    end

    -- ensure ToggleUI state exists (start OFF)
    ToggleUI.Refresh()
    pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)

    -- helper: exact color check (0,255,0 => ON; everything else => OFF)
    local function isButtonOn()
        local ok, c = pcall(function() return button.BackgroundColor3 end)
        if not ok or not c then return false end
        local r = math.floor(c.R * 255 + 0.5)
        local g = math.floor(c.G * 255 + 0.5)
        local b = math.floor(c.B * 255 + 0.5)
        return (r == 0 and g == 255 and b == 0)
    end

    -- internal state (driven by color only)
    local fruitESPEnabled = isButtonOn()
    -- map model -> {billboard=Instance, conn=RBXScriptConnection}
    local fruitESPObjects = {}

    -- safe create/destroy helpers
    local function removeESPFor(model)
        if not model then return end
        local key = model
        local entry = fruitESPObjects[key]
        if not entry then return end
        if entry.conn and entry.conn.Disconnect then
            pcall(function() entry.conn:Disconnect() end)
        elseif entry.conn and type(entry.conn) == "RBXScriptConnection" then
            pcall(function() entry.conn:Disconnect() end)
        end
        if entry.billboard and entry.billboard.Destroy then
            pcall(function() entry.billboard:Destroy() end)
        end
        fruitESPObjects[key] = nil
    end

    local function createFruitESP(model)
        if not model or not model.Parent then return end
        if fruitESPObjects[model] then return end -- already exists

        local part = model:FindFirstChild("Handle") or model:FindFirstChild("Main") or model:FindFirstChild("Part") or model:FindFirstChildWhichIsA("BasePart")
        if not part then return end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "FruitESP"
        billboard.Adornee = part
        billboard.Size = UDim2.new(0, 120, 0, 44)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        -- parent to part to ensure it follows; BillboardGui must be descendant of PlayerGui or workspace object with Adornee
        billboard.Parent = part

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(0, 255, 0)
        label.Font = Enum.Font.SourceSansBold
        label.TextScaled = true
        label.Text = ""
        label.Parent = billboard

        -- RenderStepped updater (store connection so we can disconnect)
        local conn
        conn = RunService.RenderStepped:Connect(function()
            -- cleanup if model/part removed
            if not model or not model.Parent or not part or not part.Parent then
                if conn then conn:Disconnect() end
                if billboard and billboard.Parent then
                    pcall(function() billboard:Destroy() end)
                end
                fruitESPObjects[model] = nil
                return
            end

            -- update text
            local dist = math.floor((camera.CFrame.Position - part.Position).Magnitude)
            label.Text = model.Name .. "\nDist: " .. tostring(dist) .. "m"
        end)

        fruitESPObjects[model] = { billboard = billboard, conn = conn }
    end

    local function scanFruitsAndCreate()
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:IsA("Model") and obj.Name:lower():find("fruit") and not obj:IsA("Folder") then
                createFruitESP(obj)
            end
        end
    end

    local function clearAllESP()
        for model, _ in pairs(fruitESPObjects) do
            removeESPFor(model)
        end
        fruitESPObjects = {}
    end

    -- persistent ChildAdded listener: only creates new ESP when enabled
    Workspace.ChildAdded:Connect(function(child)
        -- small delay to allow object to settle
        task.wait(0.2)
        if not fruitESPEnabled then return end
        if child:IsA("Model") and child.Name:lower():find("fruit") and not child:IsA("Folder") then
            createFruitESP(child)
        end
    end)

    -- button activation: request ToggleUI change (do not change color directly)
    if button.Activated then
        button.Activated:Connect(function()
            pcall(function() ToggleUI.Set(BUTTON_NAME, not isButtonOn()) end)
        end)
    else
        button.MouseButton1Click:Connect(function()
            pcall(function() ToggleUI.Set(BUTTON_NAME, not isButtonOn()) end)
        end)
    end

    -- when color changes: update internal flag and start/stop ESP accordingly
    button:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        -- small delay to allow ToggleUI tweens
        task.delay(0.05, function()
            local was = fruitESPEnabled
            fruitESPEnabled = isButtonOn()
            if fruitESPEnabled and (not was) then
                -- enabled now
                scanFruitsAndCreate()
            elseif (not fruitESPEnabled) and was then
                -- disabled now
                clearAllESP()
            end
        end)
    end)

    -- initialize according to current color
    if fruitESPEnabled then
        scanFruitsAndCreate()
    else
        clearAllESP()
    end
end

--=== RANDOM FRUIT =====================================================================================================--

do
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local StarterGui = game:GetService("StarterGui")

    local player = Players.LocalPlayer

    -- ==== UI NEW SYSTEM ====
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)

    local BUTTON_NAME = "RandomFruitButton"

    local ScrollingTab = player
        .PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    local FruitFrame = ScrollingTab:FindFirstChild("Fruit", true)
    if not FruitFrame then
        warn("Không tìm thấy Frame 'Fruit'")
        return
    end

    local button = FruitFrame:FindFirstChild(BUTTON_NAME, true)
    if not button then
        warn("Không tìm thấy button:", BUTTON_NAME)
        return
    end

    -- ==== LOGIC RANDOM FRUIT ====
    local function randomFruit()
        local ok = pcall(function()
            ReplicatedStorage
                :WaitForChild("Remotes")
                :WaitForChild("CommF_")
                :InvokeServer("Cousin", "Buy")
        end)

        if not ok then
            StarterGui:SetCore("SendNotification", {
                Title = "🔔Random Fruit🔔";
                Text = "Currently unavailable, please try again later.";
                Duration = 5;
            })
        end
    end

    if button.Activated then
        button.Activated:Connect(randomFruit)
    else
        button.MouseButton1Click:Connect(randomFruit)
    end
end
