--=== AUTO FRUIT COLLECTION =====================================================================================================--

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
    pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)

    -- helper: exact green check
    local function isButtonOn()
        local ok, c = pcall(function() return button.BackgroundColor3 end)
        if not ok or not c then return false end
        local r = math.floor(c.R * 255 + 0.5)
        local g = math.floor(c.G * 255 + 0.5)
        local b = math.floor(c.B * 255 + 0.5)
        return (r == 0 and g == 255 and b == 0)
    end

    -- internal flag (driven by color)
    local collectFruitEnabled = isButtonOn()

    -- toggle request (do not change color directly)
    if button.Activated then
        button.Activated:Connect(function()
            pcall(function() ToggleUI.Set(BUTTON_NAME, not isButtonOn()) end)
        end)
    else
        button.MouseButton1Click:Connect(function()
            pcall(function() ToggleUI.Set(BUTTON_NAME, not isButtonOn()) end)
        end)
    end

    -- ==== PAUSE / MOTION CONTROL ====
    local motionId = 0          -- bump to cancel permanently
    local paused = false        -- true while respawning (pause, not cancel)
    local function cancelMotion() motionId = motionId + 1 end

    -- pause on respawn start, resume after HRP ready
    player.CharacterRemoving:Connect(function()
        paused = true
    end)
    player.CharacterAdded:Connect(function(char)
        -- wait HRP ready, then resume
        char:WaitForChild("HumanoidRootPart", 5)
        paused = false
    end)

    -- when UI turns OFF -> cancel jobs and set internal flag false
    button:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        local on = isButtonOn()
        if not on then
            cancelMotion()            -- permanent cancel
            collectFruitEnabled = false
        else
            collectFruitEnabled = true
        end
    end)

    -- ensure internal initial flag
    collectFruitEnabled = isButtonOn()

    -- ==== PLACES ====
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

    -- waitWhilePaused: returns true if still valid to continue, false if canceled or disabled
    local function waitWhilePaused(myId)
        while paused do
            if myId ~= motionId then return false end
            if not collectFruitEnabled then return false end
            RunService.Heartbeat:Wait()
        end
        return (myId == motionId) and collectFruitEnabled
    end

    -- teleportRepeatedly: mimic original: set hrp.CFrame = pos each frame for duration
    -- opts: { setYAfter = number (s), targetRef = instance (optional), targetY = number (optional) }
    local function teleportRepeatedly(pos, duration, opts)
        opts = opts or {}
        local myId = motionId

        -- get hrp (may pause until available)
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            if not waitWhilePaused(myId) then return end
            hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
        end

        local t0 = tick()
        while tick() - t0 < (duration or 0) do
            if myId ~= motionId then return end
            if not collectFruitEnabled then return end
            if opts.targetRef and (not opts.targetRef.Parent) then return end
            if paused then
                if not waitWhilePaused(myId) then return end
                -- resume; continue loop
            end

            -- teleport like original (full pos)
            if hrp and hrp.Parent then
                pcall(function()
                    hrp.CFrame = CFrame.new(pos)
                end)
            else
                -- try refresh hrp
                hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then
                    if not waitWhilePaused(myId) then return end
                    hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                end
            end

            RunService.Heartbeat:Wait()
        end

        -- setYAfter: wait respecting paused and cancellation, then set Y to targetY if still valid
        if opts.setYAfter and type(opts.targetY) == "number" then
            local total = opts.setYAfter
            local myTimerId = motionId
            local elapsed = 0
            local lastT = tick()
            while elapsed < total do
                if myTimerId ~= motionId then return end
                if not collectFruitEnabled then return end
                if opts.targetRef and (not opts.targetRef.Parent) then return end
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

            -- apply Y set if still valid
            if myTimerId == motionId and collectFruitEnabled then
                local hrp2 = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp2 and (not opts.targetRef or opts.targetRef.Parent) then
                    local cur = hrp2.Position
                    pcall(function()
                        hrp2.CFrame = CFrame.new(cur.X, opts.targetY, cur.Z)
                    end)
                end
            end
        end
    end

    -- performLunge: imitation of original lunge with pause/resume and target existence check
    -- targetPos: Vector3, targetRef: optional (Model)
    local function performLunge(targetPos, targetRef)
        -- abort if target removed
        if targetRef and (not targetRef.Parent) then return end

        local myId = motionId
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        -- compute initial dir and distance (like original)
        local dir = (targetPos - hrp.Position).Unit
        local dist = (targetPos - hrp.Position).Magnitude
        local lungeSpeed = 300
        local tpThreshold = 300
        local t0 = tick()

        -- loop until time passes or reached (we'll also check remaining each iter)
        while true do
            if myId ~= motionId then return end
            if not collectFruitEnabled then return end
            if targetRef and (not targetRef.Parent) then return end
            if paused then
                if not waitWhilePaused(myId) then return end
                -- refresh hrp and continue (keep same dir since original computed once)
                character = player.Character or player.CharacterAdded:Wait()
                hrp = character:WaitForChild("HumanoidRootPart")
            end

            local remaining = (targetPos - hrp.Position).Magnitude
            if remaining <= tpThreshold then
                pcall(function() hrp.CFrame = CFrame.new(targetPos) end)
                return
            end

            -- move along dir by speed * dt, but set Y to targetPos.Y each step
            local dt = RunService.Heartbeat:Wait()
            local moveDist = lungeSpeed * dt
            -- recompute hrp in case of respawn during Wait
            hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then
                if not waitWhilePaused(myId) then return end
                hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
            end

            -- compute new position
            local cur = hrp.Position
            -- if moveDist >= remaining, finish
            if moveDist >= remaining then
                pcall(function() hrp.CFrame = CFrame.new(targetPos) end)
                return
            else
                local step = dir * moveDist
                local nx = cur.X + step.X
                local nz = cur.Z + step.Z
                pcall(function() hrp.CFrame = CFrame.new(nx, targetPos.Y, nz) end)
            end

            -- safeguard: if too long running (> dist/lungeSpeed * 3) break (prevents infinite loops)
            if tick() - t0 > (dist / lungeSpeed) * 3 + 5 then
                return
            end
        end
    end

    -- fruit check
    local function isFruit(obj)
        return obj and obj:IsA("Model") and obj.Name:lower():find("fruit")
    end

    -- findNearestTeleportPoint (returns tpPos, tpToFruitDist, playerToFruitDist)
    local function findNearestTeleportPoint(fruitPos)
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            if paused then
                local tmpId = motionId
                if not waitWhilePaused(tmpId) then return nil, math.huge, math.huge end
                hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            else
                hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            end
        end
        if not hrp then return nil, math.huge, math.huge end
        local myPos = hrp.Position
        local closestPoint, closestDist = nil, math.huge
        for _, tpPos in pairs(teleportPoints) do
            local d = calculateDistance(tpPos, fruitPos)
            if d < closestDist then
                closestPoint = tpPos
                closestDist = d
            end
        end
        return closestPoint, closestDist, calculateDistance(myPos, fruitPos)
    end

    -- goToFruit: orchestration (like original) but pause-aware and target-existence-aware
    local function goToFruit(fruit)
        if not collectFruitEnabled then return end
        if not fruit or not fruit.Parent then return end

        local fruitPart = fruit:FindFirstChild("Handle") or fruit:FindFirstChild("Main") or fruit:FindFirstChild("Part") or fruit:FindFirstChildWhichIsA("BasePart")
        if not fruitPart then return end

        local fruitPos = fruitPart.Position
        local tpPos, tpToFruitDist, playerToFruitDist = findNearestTeleportPoint(fruitPos)
        if tpPos == nil then tpToFruitDist = math.huge end

        -- new job token (but do not cancel on respawn)
        cancelMotion()
        local myJobId = motionId

        if playerToFruitDist < tpToFruitDist or #teleportPoints == 0 then
            -- direct lunge (targetRef so we can abort if fruit removed)
            performLunge(fruitPos, fruit)
        else
            -- use teleport route (teleport like original)
            teleportRepeatedly(tpPos, 1, { setYAfter = 2, targetY = fruitPos.Y, targetRef = fruit })

            -- then teleport up
            teleportRepeatedly(tpPos + Vector3.new(0, 100, 0), 0.3, { targetRef = fruit })

            task.wait(0.1)

            if myJobId == motionId and collectFruitEnabled and fruit and fruit.Parent then
                performLunge(fruitPos, fruit)
            end
        end
    end

    -- main scan loop (mimic original scanAndCollect)
    task.spawn(function()
        while true do
            collectFruitEnabled = isButtonOn()
            if collectFruitEnabled then
                for _, obj in pairs(workspace:GetChildren()) do
                    if isFruit(obj) then
                        -- if paused/respawn, wait until resumed but do not cancel the job unless target gone
                        if paused then
                            local tmp = motionId
                            if not waitWhilePaused(tmp) then break end
                            if not isButtonOn() then break end
                        end

                        -- double-check fruit still exists before starting
                        if obj and obj.Parent and isButtonOn() then
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
