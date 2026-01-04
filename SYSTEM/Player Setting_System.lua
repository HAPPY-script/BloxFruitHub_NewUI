--=== SPEED =======================================================================================================--

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    local player = Players.LocalPlayer

    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)

    local ScrollingTab = player.PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    local playerSetting = ScrollingTab:FindFirstChild("Player Setting", true)
        or ScrollingTab:FindFirstChild("Player Setting")

    if not playerSetting then
        warn("Không tìm thấy Frame 'Player Setting'")
        return
    end

    local BUTTON_NAME = "SpeedButton"
    local BOX_NAME    = "SpeedBox"

    local speedBtn = playerSetting:FindFirstChild(BUTTON_NAME, true)
    local speedBox = playerSetting:FindFirstChild(BOX_NAME, true)

    if not speedBtn then warn("Không tìm thấy SpeedButton") return end
    if not speedBox then warn("Không tìm thấy SpeedBox") return end

    -- ===== DEFAULT =====
    local DEFAULT_SPEED = 3
    local MIN_SPEED = 0.1
    local MAX_SPEED = 10

    speedBox.Text = tostring(DEFAULT_SPEED)

    -- ensure ToggleUI initial
    pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)

    -- internal state
    local isActive = false
    local speedValue = DEFAULT_SPEED
    local distancePerTeleport = 1.5

    -- ===== helper: detect toggle state via color =====
    local function inferToggleOn(btn)
        local bg
        pcall(function() bg = btn.BackgroundColor3 end)
        return bg and bg.G > bg.R and bg.G > bg.B
    end

    local function syncFromButtonColor()
        isActive = inferToggleOn(speedBtn)
    end

    speedBtn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        task.delay(0.05, syncFromButtonColor)
    end)

    -- Toggle button
    local function onButtonActivated()
        local cur = inferToggleOn(speedBtn)
        pcall(function()
            ToggleUI.Set(BUTTON_NAME, not cur)
        end)
    end

    if speedBtn.Activated then
        speedBtn.Activated:Connect(onButtonActivated)
    else
        speedBtn.MouseButton1Click:Connect(onButtonActivated)
    end

    -- ===== SpeedBox validate (FIX CHÍNH Ở ĐÂY) =====
    speedBox.FocusLost:Connect(function()
        local n = tonumber(speedBox.Text)

        if not n then
            n = DEFAULT_SPEED
        end

        if n > MAX_SPEED then
            n = MAX_SPEED
        elseif n <= 0 then
            n = MIN_SPEED
        end

        speedValue = n
        speedBox.Text = tostring(n)
    end)

    -- ===== Teleport logic =====
    local function TeleportStep(character, hrp)
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        local dir = humanoid.MoveDirection
        if dir.Magnitude > 0 then
            local newPos = hrp.Position + (dir.Unit * distancePerTeleport)
            hrp.CFrame = CFrame.new(newPos, newPos + dir)
        end
    end

    RunService.RenderStepped:Connect(function()
        if not isActive then return end

        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local steps = math.max(1, math.floor(speedValue))
        for _ = 1, steps do
            pcall(TeleportStep, char, hrp)
        end
    end)

    -- ===== Reset on respawn =====
    local function onCharacterAdded(char)
        isActive = false
        pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)

        local humanoid = char:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid.Died:Connect(function()
                isActive = false
                pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)
            end)
        end
    end

    if player.Character then
        onCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)

    task.delay(0.05, syncFromButtonColor)
end
