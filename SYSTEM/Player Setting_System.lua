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

    local playerSetting = ScrollingTab:FindFirstChild("Player Setting", true) or ScrollingTab:FindFirstChild("Player Setting")
    if not playerSetting then
        warn("Không tìm thấy Frame 'Player Setting' trong ScrollingTab")
        return
    end

    local BUTTON_NAME = "SpeedButton"
    local BOX_NAME    = "SpeedBox"

    local speedBtn = playerSetting:FindFirstChild(BUTTON_NAME, true)
    local speedBox = playerSetting:FindFirstChild(BOX_NAME, true)

    if not speedBtn then warn("Không tìm thấy SpeedButton") return end
    if not speedBox then warn("Không tìm thấy SpeedBox") return end

    -- ensure ToggleUI initial
    pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)

    -- internal state
    local isActive = false
    local speedValue = tonumber(speedBox.Text) or 3
    if type(speedValue) ~= "number" or speedValue <= 0 then speedValue = 3 end
    speedValue = math.clamp(math.floor(speedValue), 1, 10)

    local distancePerTeleport = 1.5

    -- helper: infer ON from button background color (greenish)
    local function inferToggleOn(btn)
        local bg = nil
        pcall(function() bg = btn.BackgroundColor3 end)
        if not bg then return false end
        if bg.G and bg.G > bg.R and bg.G > bg.B and bg.G > 0.5 then
            return true
        end
        return false
    end

    -- Sync local isActive when ToggleUI updates the button visuals
    local function syncFromButtonColor()
        local on = inferToggleOn(speedBtn)
        if on ~= isActive then
            isActive = on
        end
    end

    -- Watch for property changes (ToggleUI will change BackgroundColor3)
    speedBtn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        -- small defer to allow ToggleUI internal transition finish
        task.delay(0.05, syncFromButtonColor)
    end)

    -- Wire button activation to request ToggleUI change (do NOT set color/text directly)
    local function onButtonActivated()
        local cur = inferToggleOn(speedBtn)
        pcall(function() ToggleUI.Set(BUTTON_NAME, not cur) end)
    end
    if speedBtn.Activated then
        speedBtn.Activated:Connect(onButtonActivated)
    else
        speedBtn.MouseButton1Click:Connect(onButtonActivated)
    end

    -- SpeedBox: validate input on FocusLost
    speedBox.FocusLost:Connect(function(enterPressed)
        local n = tonumber(speedBox.Text)
        if n and n > 0 and n <= 10 then
            speedValue = math.clamp(math.floor(n), 1, 10)
            speedBox.Text = tostring(speedValue)
        else
            -- restore to last valid
            speedBox.Text = tostring(speedValue)
        end
    end)

    -- Teleport helper (one small sub-step)
    local function TeleportStep(character, hrp)
        if not character or not hrp then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local moveDirection = humanoid.MoveDirection or Vector3.zero
        if moveDirection.Magnitude > 0 then
            local newPos = hrp.Position + (moveDirection.Unit * distancePerTeleport)
            hrp.CFrame = CFrame.new(newPos, newPos + moveDirection)
        end
    end

    -- Main RenderStepped loop: execute teleport steps when isActive
    RunService.RenderStepped:Connect(function()
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if isActive then
            for i = 1, math.max(1, speedValue) do
                -- safe pcall to avoid runtime stopping
                pcall(TeleportStep, char, hrp)
            end
        end
    end)

    -- When player dies: ensure toggle is turned off to avoid UI/state drift
    local function onCharacterAdded(newChar)
        local humanoid = newChar:WaitForChild("Humanoid", 5)
        local hrp = newChar:WaitForChild("HumanoidRootPart", 5)
        -- always reset local running and request UI OFF
        isActive = false
        pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)
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
