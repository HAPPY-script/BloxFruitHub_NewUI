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

    -- internal flag
    local collectFruitEnabled = isButtonOn()

    -- click -> request ToggleUI change
    if button.Activated then
        button.Activated:Connect(function() pcall(function() ToggleUI.Set(BUTTON_NAME, not isButtonOn()) end) end)
    else
        button.MouseButton1Click:Connect(function() pcall(function() ToggleUI.Set(BUTTON_NAME, not isButtonOn()) end) end)
    end

    -- ==== PAUSE / MOVEMENT token controller ====
    local movementToken = 0
    local paused = false
    local function stopMovement() movementToken = movementToken + 1 end

    player.CharacterRemoving:Connect(function() paused = true end)
    player.CharacterAdded:Connect(function(char) char:WaitForChild("HumanoidRootPart", 5); paused = false end)

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

    -- ===== movement settings (adjusted per your request) =====
    local LUNGE_SPEED = 300
    local TELEPORT_HEIGHT = 100
    local TELEPORT_SPAM_COUNT = 15   -- 15 times
    local TELEPORT_SPAM_TIME = 1   -- in 1s
    local TP_DIRECT_THRESHOLD = 275  -- if within this distance, teleport straight

    local function getHRP()
        local char = player.Character or player.CharacterAdded:Wait()
        return char:WaitForChild("HumanoidRootPart")
    end

    local function vecDistance(a,b) return (a-b).Magnitude end
    local function toXZ(pos, fixedY) return Vector3.new(pos.X, fixedY, pos.Z) end
    local function xzDistance(a,b) return (Vector3.new(a.X,0,a.Z) - Vector3.new(b.X,0,b.Z)).Magnitude end

    local function getBestTeleportPoint(fromPos, targetPos)
        local bestPoint, bestDist = nil, math.huge
        for _, p in ipairs(teleportPoints) do
            local d = vecDistance(p, targetPos)
            if d < bestDist then bestDist = d; bestPoint = p end
        end
        if not bestPoint then return nil end
        if vecDistance(fromPos, targetPos) <= bestDist then return nil end
        return bestPoint
    end

    local function teleport(pos)
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = CFrame.new(pos) end
    end

    -- teleport spam: teleports to 'pos' TELEPORT_SPAM_COUNT times over TELEPORT_SPAM_TIME.
    -- respects token, paused, and targetRef (if provided). Returns true if completed.
    local function teleportSpam(pos, token, targetRef)
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            local waited = 0
            while not hrp and waited < 5 do
                if token ~= movementToken then return false end
                hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then break end
                task.wait(0.1); waited = waited + 0.1
            end
            if not hrp then return false end
        end

        local interval = TELEPORT_SPAM_TIME / math.max(1, TELEPORT_SPAM_COUNT)
        local count = 0
        local elapsed = 0
        local done = false

        local conn
        conn = RunService.Heartbeat:Connect(function(dt)
            if token ~= movementToken then
                conn:Disconnect(); done = true; return
            end
            if paused then return end
            if targetRef and not targetRef.Parent then conn:Disconnect(); done = true; return end

            elapsed = elapsed + dt
            if elapsed >= interval then
                elapsed = elapsed - interval
                count = count + 1
                local ok, hrpNow = pcall(function() return player.Character and player.Character:FindFirstChild("HumanoidRootPart") end)
                if ok and hrpNow then
                    hrpNow.CFrame = CFrame.new(pos)
                end
                if count >= TELEPORT_SPAM_COUNT then
                    conn:Disconnect(); done = true; return
                end
            end
        end)

        while not done do
            if token ~= movementToken then
                if conn and conn.Connected then conn:Disconnect() end
                return false
            end
            task.wait()
        end

        return token == movementToken
    end

    -- lungeTo: mimic original stable logic but only change X/Z each frame; Y = targetY set immediately.
    -- if remaining (3D) <= TP_DIRECT_THRESHOLD then teleport straight.
    local function lungeTo(targetPos, token, targetRef)
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            local waited = 0
            while (not hrp) and waited < 5 do
                if token ~= movementToken then return false end
                hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then break end
                task.wait(0.1); waited = waited + 0.1
            end
            if not hrp then return false end
        end

        -- immediate Y fix
        local targetY = targetPos.Y
        local fullDist = (targetPos - hrp.Position).Magnitude
        if fullDist <= TP_DIRECT_THRESHOLD then
            -- teleport straight if within threshold
            local ok, hrpNow = pcall(function() return player.Character and player.Character:FindFirstChild("HumanoidRootPart") end)
            if ok and hrpNow then hrpNow.CFrame = CFrame.new(targetPos) end
            return token == movementToken
        end

        -- compute initial dir unit (XZ movement)
        local dirXZ = Vector3.new(targetPos.X - hrp.Position.X, 0, targetPos.Z - hrp.Position.Z)
        local distXZ = dirXZ.Magnitude
        if distXZ == 0 then
            local ok2, hrpNow2 = pcall(function() return player.Character and player.Character:FindFirstChild("HumanoidRootPart") end)
            if ok2 and hrpNow2 then hrpNow2.CFrame = CFrame.new(targetPos.X, targetY, targetPos.Z) end
            return token == movementToken
        end

        local lungeSpeed = LUNGE_SPEED
        local last = tick()

        while true do
            if token ~= movementToken then return false end
            if not collectFruitEnabled then return false end
            if targetRef and not targetRef.Parent then return false end
            if paused then
                -- wait until resume
                while paused do
                    if token ~= movementToken then return false end
                    task.wait(0.05)
                end
                last = tick()
            end

            -- recalc direction to avoid drift
            local hrpNow = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not hrpNow then return false end
            local curPos = hrpNow.Position
            local remaining3 = (targetPos - curPos).Magnitude
            if remaining3 <= TP_DIRECT_THRESHOLD then
                hrpNow.CFrame = CFrame.new(targetPos)
                return token == movementToken
            end

            local dirNow = Vector3.new(targetPos.X - curPos.X, 0, targetPos.Z - curPos.Z)
            local distNow = dirNow.Magnitude
            if distNow == 0 then
                hrpNow.CFrame = CFrame.new(targetPos.X, targetY, targetPos.Z)
                return token == movementToken
            end

            local dt = RunService.Heartbeat:Wait()
            local move = lungeSpeed * dt
            if move >= distNow then
                hrpNow.CFrame = CFrame.new(targetPos.X, targetY, targetPos.Z)
                return token == movementToken
            else
                local step = dirNow.Unit * move
                local nx = curPos.X + step.X
                local nz = curPos.Z + step.Z
                hrpNow.CFrame = CFrame.new(nx, targetY, nz)
            end
        end
    end

    local function calculateDistance(a,b) return (a-b).Magnitude end

    local function findNearestTeleportPoint(fruitPos)
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            local waited = 0
            while not hrp and waited < 3 do
                if paused then
                    local t = 0
                    while paused do
                        task.wait(0.05)
                        t = t + 0.05
                        if t > 5 then break end
                    end
                end
                hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then break end
                task.wait(0.05); waited = waited + 0.05
            end
            if not hrp then return nil, math.huge, math.huge end
        end

        local myPos = hrp.Position
        local closestPoint, closestDist = nil, math.huge
        for _, tpPos in pairs(teleportPoints) do
            local dist = calculateDistance(tpPos, fruitPos)
            if dist < closestDist then closestDist = dist; closestPoint = tpPos end
        end
        return closestPoint, closestDist, calculateDistance(myPos, fruitPos)
    end

    -- goToFruit orchestration
    local function goToFruit(fruit)
        if not collectFruitEnabled then return end
        if not fruit or not fruit.Parent then return end

        local fruitPart = fruit:FindFirstChild("Handle") or fruit:FindFirstChild("Main")
            or fruit:FindFirstChild("Part") or fruit:FindFirstChildWhichIsA("BasePart")
        if not fruitPart then return end

        local fruitPos = fruitPart.Position
        local tpPos, tpToFruitDist, playerToFruitDist = findNearestTeleportPoint(fruitPos)
        if not tpPos then tpToFruitDist = math.huge end

        -- new token for this job
        movementToken = movementToken + 1
        local myToken = movementToken

        -- choose path
        if playerToFruitDist < tpToFruitDist or #teleportPoints == 0 then
            -- direct lunge (will set Y = fruit Y each step; will teleport if within TP_DIRECT_THRESHOLD)
            lungeTo(fruitPos, myToken, fruit)
        else
            -- teleport spam to tpPos (15 times in 1.5s)
            local ok = teleportSpam(tpPos, myToken, fruit)
            if not ok or movementToken ~= myToken then return end

            -- teleport up quickly to avoid obstacles
            teleport(tpPos + Vector3.new(0, TELEPORT_HEIGHT, 0))
            task.wait(0.03)
            if movementToken ~= myToken then return end

            -- after arrival, we DO NOT immediately set Y to target; we only set Y during lunge step per requirement.
            -- perform lunge from current position (current HRP pos) to fruit; lungeTo will set Y = fruitY each frame.
            lungeTo(fruitPos, myToken, fruit)
        end
    end

    -- main loop: scan & collect
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

    -- helper from earlier scripts
    function isFruit(obj)
        return obj:IsA("Model") and obj.Name:lower():find("fruit")
    end
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
