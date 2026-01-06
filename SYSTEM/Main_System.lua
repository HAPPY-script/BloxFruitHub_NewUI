--=== AUTO HOLD TOOL =====================================================================================================--

do
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")

    local player = Players.LocalPlayer

    -- đường dẫn ScrollingTab do bạn cung cấp
    local ScrollingTab = Players.LocalPlayer
        .PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    -- tìm Frame "Main" trong ScrollingTab (đệ quy)
    local uiMain = ScrollingTab:FindFirstChild("Main", true)
    if not uiMain then
        warn("Không tìm thấy Frame 'Main' trong ScrollingTab")
        return
    end

    -- tên các nút UI bạn đã đặt
    local BUTTON_NAME = "AutoHoldToolButton" -- nút toggle
    local CHECK_NAME  = "CheckToolButton"    -- nút check tool

    -- tìm nút trong uiMain (đệ quy)
    local autoHoldBtn = uiMain:FindFirstChild(BUTTON_NAME, true)
    local checkBtn    = uiMain:FindFirstChild(CHECK_NAME, true)

    if not autoHoldBtn then
        warn("Không tìm thấy AutoHoldToolButton:", BUTTON_NAME)
        return
    end
    if not checkBtn then
        warn("Không tìm thấy CheckToolButton:", CHECK_NAME)
        return
    end

    -- chờ ToggleUI helper (mẫu do bạn cung cấp)
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)
    -- đảm bảo khởi tạo OFF
    pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)

    -- màu trạng thái
    local COLOR_NONE = Color3.fromRGB(255, 0, 0)
    local COLOR_WAIT = Color3.fromRGB(255, 200, 0)
    local COLOR_OK   = Color3.fromRGB(50, 255, 50)

    -- nội trạng
    local loopEquip = false
    local wasLoopRunning = false
    local savedToolName = nil
    local equipThread = nil

    -- trạng thái check
    local checkInProgress = false

    -- helper: tìm UIStroke nếu có
    local function findStroke(instance)
        for _, c in ipairs(instance:GetChildren()) do
            if c:IsA("UIStroke") then return c end
        end
        return nil
    end

    local checkStroke = findStroke(checkBtn)

    -- cập nhật giao diện cho checkBtn theo trạng thái
    local function updateCheckAppearance(state)
        -- state: "none" | "waiting" | "selected"
        if state == "none" then
            checkBtn.BackgroundColor3 = COLOR_NONE
            if checkStroke then checkStroke.Color = COLOR_NONE end
        elseif state == "waiting" then
            checkBtn.BackgroundColor3 = COLOR_WAIT
            if checkStroke then checkStroke.Color = COLOR_WAIT end
        elseif state == "selected" then
            checkBtn.BackgroundColor3 = COLOR_OK
            if checkStroke then checkStroke.Color = COLOR_OK end
        end
    end

    -- tìm tool theo tên (character hoặc backpack)
    local function findTool(name)
        if not name then return nil end
        local char = player.Character
        if char then
            local t = char:FindFirstChild(name)
            if t and t:IsA("Tool") then return t end
        end
        local bp = player:FindFirstChildOfClass("Backpack")
        if bp then
            local t = bp:FindFirstChild(name)
            if t and t:IsA("Tool") then return t end
        end
        return nil
    end

    -- tìm tool hiện đang cầm (trong Character)
    local function findCurrentlyEquippedTool()
        local char = player.Character
        if not char then return nil end
        for _, c in ipairs(char:GetChildren()) do
            if c:IsA("Tool") then return c end
        end
        return nil
    end

    -- vòng lặp giữ/equip tool (nhanh, interruptible)
    local function startLoop()
        if equipThread or not savedToolName then return end
        loopEquip = true
        equipThread = task.spawn(function()
            while loopEquip do
                local tool = findTool(savedToolName)
                if tool and player.Character then
                    if tool.Parent ~= player.Character then
                        -- giữ tool trong character
                        tool.Parent = player.Character
                    end
                end
                task.wait(0.5)
            end
            -- thread kết thúc
            equipThread = nil
        end)
    end

    local function stopLoop()
        -- đảm bảo đặt flag false để thread thoát, và chờ thread hoàn thành an toàn
        loopEquip = false
        if equipThread then
            local tstart = tick()
            -- chờ tối đa 0.6s để thread kết thúc
            while equipThread and tick() - tstart < 0.6 do
                task.wait(0.02)
            end
            -- nếu thread vẫn chưa nil, ta vẫn để equipThread như cũ (không ép cancel)
        end
    end

    -- tween helper cho text transparency (0->1 or 1->0)
    local function tweenTextTransparency(btn, target, time)
        time = time or 0.18
        local info = TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local props = { TextTransparency = target }
        local tw = TweenService:Create(btn, info, props)
        tw:Play()
        tw.Completed:Wait()
    end

    -- set displayed text with tween animation
    local function animatedSetText(btn, newText)
        -- ensure text starts visible (0)
        pcall(function() btn.TextTransparency = 0 end)
        tweenTextTransparency(btn, 1, 0.16) -- fade out
        btn.Text = newText
        tweenTextTransparency(btn, 0, 0.16) -- fade in
    end

    -- Reliable check: try ToggleUI.Get(BUTTON_NAME), fallback to color check
    local function getToggleOn()
        -- try ToggleUI.Get if exists
        local ok, val = pcall(function()
            if ToggleUI.Get then
                return ToggleUI.Get(BUTTON_NAME)
            end
            return nil
        end)
        if ok and type(val) == "boolean" then
            return val
        end
        -- fallback to infer from color (existing heuristic)
        local bg = autoHoldBtn.BackgroundColor3
        if bg and bg.G and bg.G > bg.R and bg.G > bg.B and bg.G > 0.5 then
            return true
        end
        return false
    end

    -- Hàm xử lý CheckToolButton logic
    local function handleCheckOnce()
        if checkInProgress then return end
        checkInProgress = true
        checkBtn.Active = false

        -- BEFORE selecting: stop any active equip loop so selection behaves
        stopLoop()

        local function markSelected(name)
            savedToolName = name
            updateCheckAppearance("selected")
            animatedSetText(checkBtn, "Selected: "..tostring(name))

            -- nếu toggle đang ON thì start loop ngay
            if getToggleOn() then
                startLoop()
            end
        end

        local function markNone()
            savedToolName = nil
            updateCheckAppearance("none")
            animatedSetText(checkBtn, "None")
            -- đảm bảo loop dừng nếu user chọn None
            stopLoop()
        end

        -- 1) if currently holding a tool — accept it immediately (with tween)
        local current = findCurrentlyEquippedTool()
        if current then
            markSelected(current.Name)
            checkInProgress = false
            checkBtn.Active = true
            return
        end

        -- 2) else go into Waiting mode for up to 3s, polling for a tool
        updateCheckAppearance("waiting")
        tweenTextTransparency(checkBtn, 1, 0.12)
        checkBtn.Text = "Waiting..."
        tweenTextTransparency(checkBtn, 0, 0.12)

        local waited = 0
        local found = nil
        local pollInterval = 0.15
        while waited < 3 do
            task.wait(pollInterval)
            waited = waited + pollInterval
            local cur = findCurrentlyEquippedTool()
            if cur then
                found = cur
                break
            end
        end

        if found then
            markSelected(found.Name)
        else
            -- no tool after waiting -> set None
            markNone()
        end

        -- small debounce to prevent immediate re-click spam
        task.delay(0.2, function()
            checkInProgress = false
            checkBtn.Active = true
        end)
    end

    -- Hook Check button (use Activated if available, fallback to MouseButton1Click)
    if checkBtn.Activated then
        checkBtn.Activated:Connect(function()
            handleCheckOnce()
        end)
    else
        checkBtn.MouseButton1Click:Connect(function()
            handleCheckOnce()
        end)
    end

    -- khi nhấn nút toggle: gửi lệnh cho ToggleUI (theo mẫu)
    autoHoldBtn.Activated:Connect(function()
        -- try to get current state reliably, prefer ToggleUI.Get
        local currentOn = getToggleOn()
        local target = not currentOn
        pcall(function() ToggleUI.Set(BUTTON_NAME, target) end)
    end)

    -- Sync local loopEquip with button color changes (similar to earlier pattern)
    local function setLoopFromButtonColor()
        -- infer ON from green-ish background
        local bg = autoHoldBtn.BackgroundColor3
        local isOn = false
        if bg and bg.G and bg.G > bg.R and bg.G > bg.B and bg.G > 0.5 then
            isOn = true
        end

        if isOn and not loopEquip then
            loopEquip = true
            -- start loop if we have a saved tool
            if savedToolName then
                startLoop()
            end
        elseif not isOn and loopEquip then
            loopEquip = false
            stopLoop()
        end
    end

    autoHoldBtn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        -- small defer to let ToggleUI internal update finish
        task.delay(0.05, setLoopFromButtonColor)
    end)

    -- Khởi tạo trạng thái theo màu hiện tại của button
    setLoopFromButtonColor()

    -- Nếu savedToolName thay đổi (ban đầu none) => cập nhật appearance
    if savedToolName then
        updateCheckAppearance("selected")
        checkBtn.Text = "Selected: "..savedToolName
    else
        updateCheckAppearance("none")
        checkBtn.Text = "None"
    end

    -- Khi user respawn / die: nhớ trạng thái, ngắt loop
    local function onCharacter(char)
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            hum.Died:Connect(function()
                wasLoopRunning = loopEquip
                loopEquip = false
                stopLoop()
            end)
        end
    end

    if player.Character then onCharacter(player.Character) end
    player.CharacterAdded:Connect(function(char)
        onCharacter(char)
        -- chờ rootpart load
        char:WaitForChild("HumanoidRootPart", 5)
        task.wait(0.5)
        -- nếu trước đó đang chạy và có savedToolName thì auto-equip
        if wasLoopRunning and savedToolName then
            loopEquip = true
            startLoop()
        end
    end)
end

--=== AUTO FARM LVL =====================================================================================================--

do
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local player = Players.LocalPlayer

    -- CHỈNH Ở ĐÂY: tên button UI (khớp với tên trong GUI của bạn)
    local BUTTON_NAME = "AutoFarmLvlButton"

    -- Đường dẫn tới ScrollingTab như bạn yêu cầu
    local ScrollingTab = Players.LocalPlayer
        .PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    -- Tìm Frame "Main" bên trong ScrollingTab (tìm đệ quy)
    local uiMain = ScrollingTab:FindFirstChild("Main", true)
    if not uiMain then
        warn("Không tìm thấy Frame 'Main' trong ScrollingTab")
        return
    end

    -- Tìm Button toggle trong Frame Main (tìm đệ quy)
    local toggleBtn = uiMain:FindFirstChild(BUTTON_NAME, true)
    if not toggleBtn then
        warn("Không tìm thấy Button:", BUTTON_NAME)
        return
    end

    -- Chờ ToggleUI helper (theo mẫu bạn đưa)
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    if ToggleUI and ToggleUI.Refresh then
        pcall(ToggleUI.Refresh)
    end

    -- Helpers: so sánh màu với ngưỡng
    local function colorEquals(c, r, g, b)
        local cr, cg, cb = c.R * 255, c.G * 255, c.B * 255
        local tol = 2 -- ngưỡng nhỏ để tránh sai số
        return math.abs(cr - r) <= tol and math.abs(cg - g) <= tol and math.abs(cb - b) <= tol
    end

    local function isButtonOn()
        return colorEquals(toggleBtn.BackgroundColor3, 0, 255, 0)
    end

    -- Auto Farm variables & config (giữ nguyên logic cũ)
    local currentQuestBeli = 0
    local currentQuestKills = 0
    local maxQuestKills = 9
    local expectedRewardBeli = 500000

local FarmZones = {
        {
            MinLevel = 0,
            MaxLevel = 9,
            MobName = "Trainee",
            FarmPos = Vector3.new(-2839.79, 41.05, 2153.06),
            QuestNPCPos = Vector3.new(-2721.94, 24.56, 2101.26),
            QuestName = "MarineQuest",
            QuestIndex = 1,
            RewardBeli = 350
        },
        {
            MinLevel = 10,
            MaxLevel = 14,
            MobName = "Monkey",
            FarmPos = Vector3.new(-1609.02, 20.89, 146.93),
            QuestNPCPos = Vector3.new(-1610.07, 20.89, 130.48),
            QuestName = "JungleQuest",
            QuestIndex = 1,
            RewardBeli = 800
        },
        {
            MinLevel = 15,
            MaxLevel = 29,
            MobName = "Gorilla",
            FarmPos = Vector3.new(-1307.42, 18.66, -401.41),
            QuestNPCPos = Vector3.new(-1610.07, 20.89, 130.48),
            QuestName = "Area2Quest",
            QuestIndex = 2,
            RewardBeli = 1200
        },
        {
            MinLevel = 30,
            MaxLevel = 39,
            MobName = "Pirate",
            FarmPos = Vector3.new(-1147.27, 55.41, 3983.74),
            QuestNPCPos = Vector3.new(-1121.64, 4.79, 3842.47),
            QuestName = "BuggyQuest1",
            QuestIndex = 1,
            RewardBeli = 3000
        },
        {
            MinLevel = 40,
            MaxLevel = 59,
            MobName = "Brute",
            FarmPos = Vector3.new(-1147.27, 55.41, 3983.74),
            QuestNPCPos = Vector3.new(-1121.64, 4.79, 3842.47),
            QuestName = "BuggyQuest1",
            QuestIndex = 2,
            RewardBeli = 3500
        },
        {
            MinLevel = 60,
            MaxLevel = 74,
            MobName = "Desert Bandit",
            FarmPos = Vector3.new(929.86, 6.47, 4271.35),
            QuestNPCPos = Vector3.new(914.87, 6.47, 4399.57),
            QuestName = "DesertQuest",
            QuestIndex = 1,
            RewardBeli = 4000
        },
        {
            MinLevel = 75,
            MaxLevel = 89,
            MobName = "Desert Officer",
            FarmPos = Vector3.new(1565.94, 11.12, 4389.14),
            QuestNPCPos = Vector3.new(914.87, 6.47, 4399.57),
            QuestName = "DesertQuest",
            QuestIndex = 2,
            RewardBeli = 4500
        },
        {
            MinLevel = 90,
            MaxLevel = 99,
            MobName = "Snow Bandit",
            FarmPos = Vector3.new(1376.77, 104.43, -1411.01),
            QuestNPCPos = Vector3.new(1375.02, 87.31, -1313.90),
            QuestName = "SnowQuest",
            QuestIndex = 1,
            RewardBeli = 5000
        },
        {
            MinLevel = 100,
            MaxLevel = 119,
            MobName = "Snowman",
            FarmPos = Vector3.new(1205.99, 105.81, -1522.20),
            QuestNPCPos = Vector3.new(1375.02, 87.31, -1313.90),
            QuestName = "SnowQuest",
            QuestIndex = 2,
            RewardBeli = 5500
        },
        {
            MinLevel = 120,
            MaxLevel = 149,
            MobName = "Chief Petty Officer",
            FarmPos = Vector3.new(-4715.38, 31.96, 4191.34),
            QuestNPCPos = Vector3.new(-5014.49, 22.49, 4324.33),
            QuestName = "MarineQuest2",
            QuestIndex = 1,
            RewardBeli = 6000
        },
        {
            MinLevel = 150,
            MaxLevel = 174,
            MobName = "Sky Bandit",
            FarmPos = Vector3.new(-4992.65, 278.10, -2856.87),
            QuestNPCPos = Vector3.new(-4860.68, 717.71, -2626.04),
            QuestName = "SkyQuest",
            QuestIndex = 1,
            RewardBeli = 7000
        },
        {
            MinLevel = 175,
            MaxLevel = 189,
            MobName = "Dark Master",
            FarmPos = Vector3.new(-5251.88, 388.69, -2257.42),
            QuestNPCPos = Vector3.new(-4860.68, 717.71, -2626.04),
            QuestName = "SkyQuest",
            QuestIndex = 2,
            RewardBeli = 7500
        },
        {
            MinLevel = 190,
            MaxLevel = 209,
            MobName = "Prisoner",
            FarmPos = Vector3.new(5325.13, 88.70, 715.62),
            QuestNPCPos = Vector3.new(5292.71, 1.69, 474.49),
            QuestName = "PrisonerQuest",
            QuestIndex = 1,
            RewardBeli = 7000
        },
        {
            MinLevel = 210,
            MaxLevel = 299,
            MobName = "Dangerous Prisoner",
            FarmPos = Vector3.new(5325.13, 88.70, 715.62),
            QuestNPCPos = Vector3.new(5292.71, 1.69, 474.49),
            QuestName = "PrisonerQuest",
            QuestIndex = 2,
            RewardBeli = 7500
        },
        {
            MinLevel = 220,
            MaxLevel = 299,
            MobName = "Warden",
            FarmPos = Vector3.new(5325.13, 88.70, 715.62),
            QuestNPCPos = Vector3.new(5183.75, 3.57, 705.09),
            QuestName = "ImpelQuest",
            QuestIndex = 1,
            RewardBeli = 6000
        },
        {
            MinLevel = 230,
            MaxLevel = 299,
            MobName = "Chief Warden",
            FarmPos = Vector3.new(5325.13, 88.70, 715.62),
            QuestNPCPos = Vector3.new(5183.75, 3.57, 705.09),
            QuestName = "ImpelQuest",
            QuestIndex = 2,
            RewardBeli = 10000
        },
        {
            MinLevel = 300,
            MaxLevel = 324,
            MobName = "Military Soldier",
            FarmPos = Vector3.new(-5404.68, 25.73, 8522.42),
            QuestNPCPos = Vector3.new(-5321.87, 8.63, 8502.13),
            QuestName = "MagmaQuest",
            QuestIndex = 1,
            RewardBeli = 8250
        },
        {
            MinLevel = 325,
            MaxLevel = 374,
            MobName = "Military Spy",
            FarmPos = Vector3.new(-5799.55, 98.00, 8781.13),
            QuestNPCPos = Vector3.new(-5321.87, 8.63, 8502.13),
            QuestName = "MagmaQuest",
            QuestIndex = 2,
            RewardBeli = 8500
        },
        {
            MinLevel = 375,
            MaxLevel = 399,
            MobName = "Fishman Warrior",
            FarmPos = Vector3.new(60941.54, 48.71, 1513.80),
            QuestNPCPos = Vector3.new(61113.66, 18.51, 1544.92),
            QuestName = "FishmanQuest",
            QuestIndex = 1,
            RewardBeli = 8750
        },
        {
            MinLevel = 400,
            MaxLevel = 449,
            MobName = "Fishman Commando",
            FarmPos = Vector3.new(61892.86, 18.52, 1481.29),
            QuestNPCPos = Vector3.new(61113.66, 18.51, 1544.92),
            QuestName = "FishmanQuest",
            QuestIndex = 2,
            RewardBeli = 9000
        },
        {
            MinLevel = 450,
            MaxLevel = 474,
            MobName = "God's Guard",
            FarmPos = Vector3.new(-4629.25, 849.94, -1941.40),
            QuestNPCPos = Vector3.new(-4718.40, 854.12, -1939.54),
            QuestName = "SkyExp1Quest",
            QuestIndex = 1,
            RewardBeli = 8750
        },
        {
            MinLevel = 475,
            MaxLevel = 524,
            MobName = "Shanda",
            FarmPos = Vector3.new(-7683.37, 5565.10, -437.47),
            QuestNPCPos = Vector3.new(-7845.91, 5558.07, -392.70),
            QuestName = "SkyExp1Quest",
            QuestIndex = 2,
            RewardBeli = 9000
        },
        {
            MinLevel = 525,
            MaxLevel = 549,
            MobName = "Royal Squad",
            FarmPos = Vector3.new(-7647.08, 5606.91, -1454.96),
            QuestNPCPos = Vector3.new(-7888.37, 5636.00, -1409.92),
            QuestName = "SkyExp2Quest",
            QuestIndex = 1,
            RewardBeli = 9500
        },
        {
            MinLevel = 550,
            MaxLevel = 624,
            MobName = "Royal Soldier",
            FarmPos = Vector3.new(-7859.01, 5626.31, -1709.91),
            QuestNPCPos = Vector3.new(-7888.37, 5636.00, -1409.92),
            QuestName = "SkyExp2Quest",
            QuestIndex = 2,
            RewardBeli = 9750
        },
        {
            MinLevel = 625,
            MaxLevel = 649,
            MobName = "Galley Pirate",
            FarmPos = Vector3.new(5575.72, 38.54, 3927.25),
            QuestNPCPos = Vector3.new(5261.02, 38.54, 4034.20),
            QuestName = "FountainQuest",
            QuestIndex = 1,
            RewardBeli = 10000
        },
        {
            MinLevel = 650,
            MaxLevel = 699,
            MobName = "Galley Captain",
            FarmPos = Vector3.new(5680.94, 51.82, 4865.71),
            QuestNPCPos = Vector3.new(5261.02, 38.54, 4034.20),
            QuestName = "FountainQuest",
            QuestIndex = 2,
            RewardBeli = 10000
        }, --------------------SEA 1-----------------------------------------------
        {  --------------------SEA 2-----------------------------------------------
            MinLevel = 700,
            MaxLevel = 724,
            MobName = "Raider",
            FarmPos = Vector3.new(-128.45, 39.00, 2284.68),
            QuestNPCPos = Vector3.new(-440.17, 77.54, 1851.46),
            QuestName = "Area1Quest",
            QuestIndex = 1,
            RewardBeli = 10250
        },
        {
            MinLevel = 725,
            MaxLevel = 774,
            MobName = "Mercenary",
            FarmPos = Vector3.new(-990.28, 73.05, 1402.77),
            QuestNPCPos = Vector3.new(-440.17, 77.54, 1851.46),
            QuestName = "Area1Quest",
            QuestIndex = 2,
            RewardBeli = 10500
        },
        {
            MinLevel = 775,
            MaxLevel = 799,
            MobName = "Swan Pirate",
            FarmPos = Vector3.new(842.49, 121.62, 1243.63),
            QuestNPCPos = Vector3.new(637.54, 73.15, 934.80),
            QuestName = "Area2Quest",
            QuestIndex = 1,
            RewardBeli = 10750
        },
        {
            MinLevel = 800,
            MaxLevel = 874,
            MobName = "Factory Staff",
            FarmPos = Vector3.new(327.91, 73.00, -19.81),
            QuestNPCPos = Vector3.new(637.54, 73.15, 934.80),
            QuestName = "Area2Quest",
            QuestIndex = 2,
            RewardBeli = 11000
        },
        {
            MinLevel = 875,
            MaxLevel = 899,
            MobName = "Marine Lieutenant",
            FarmPos = Vector3.new(-2866.94, 73.00, -3003.71),
            QuestNPCPos = Vector3.new(-2435.19, 73.20, -3232.76),
            QuestName = "MarineQuest3",
            QuestIndex = 1,
            RewardBeli = 11250
        },
        {
            MinLevel = 900,
            MaxLevel = 949,
            MobName = "Marine Captain",
            FarmPos = Vector3.new(-1956.02, 73.20, -3236.77),
            QuestNPCPos = Vector3.new(-2435.19, 73.20, -3232.76),
            QuestName = "MarineQuest3",
            QuestIndex = 2,
            RewardBeli = 11500
        },
        {
            MinLevel = 950,
            MaxLevel = 974,
            MobName = "Zombie",
            FarmPos = Vector3.new(-5624.78, 48.52, -711.50),
            QuestNPCPos = Vector3.new(-5506.25, 48.52, -811.98),
            QuestName = "ZombieQuest",
            QuestIndex = 1,
            RewardBeli = 11750
        },
        {
            MinLevel = 975,
            MaxLevel = 999,
            MobName = "Vampire",
            FarmPos = Vector3.new(-6017.56, 6.44, -1305.21),
            QuestNPCPos = Vector3.new(-5506.25, 48.52, -811.98),
            QuestName = "ZombieQuest",
            QuestIndex = 2,
            RewardBeli = 12000
        },
        {
            MinLevel = 1000,
            MaxLevel = 1049,
            MobName = "Snow Trooper",
            FarmPos = Vector3.new(558.35, 401.46, -5424.40),
            QuestNPCPos = Vector3.new(602.76, 401.46, -5356.61),
            QuestName = "SnowMountainQuest",
            QuestIndex = 1,
            RewardBeli = 12250
        },
        {
            MinLevel = 1050,
            MaxLevel = 1099,
            MobName = "Winter Warrior",
            FarmPos = Vector3.new(1176.49, 429.46, -5231.42),
            QuestNPCPos = Vector3.new(602.76, 401.46, -5356.61),
            QuestName = "SnowMountainQuest",
            QuestIndex = 2,
            RewardBeli = 12500
        },
        {
            MinLevel = 1100,
            MaxLevel = 1124,
            MobName = "Lab Subordinate",
            FarmPos = Vector3.new(-5778.44, 15.99, -4479.97),
            QuestNPCPos = Vector3.new(-6043.20, 15.99, -4909.17),
            QuestName = "IceSideQuest",
            QuestIndex = 1,
            RewardBeli = 12250
        },
        {
            MinLevel = 1125,
            MaxLevel = 1174,
            MobName = "Horned Warrior",
            FarmPos = Vector3.new(-6265.67, 15.99, -5766.91),
            QuestNPCPos = Vector3.new(-6043.20, 15.99, -4909.17),
            QuestName = "IceSideQuest",
            QuestIndex = 2,
            RewardBeli = 12500
        },
        {
            MinLevel = 1175,
            MaxLevel = 1199,
            MobName = "Lava Pirate",
            FarmPos = Vector3.new(-5293.55, 35.44, -4705.81),
            QuestNPCPos = Vector3.new(-5445.89, 15.99, -5292.91),
            QuestName = "FireSideQuest",
            QuestIndex = 1,
            RewardBeli = 12250
        },
        {
            MinLevel = 1200,
            MaxLevel = 1249,
            MobName = "Magma Ninja",
            FarmPos = Vector3.new(-5524.52, 60.59, -5935.76),
            QuestNPCPos = Vector3.new(-5445.89, 15.99, -5292.91),
            QuestName = "FireSideQuest",
            QuestIndex = 2,
            RewardBeli = 12500
        },
        {
            MinLevel = 1250,
            MaxLevel = 1274,
            MobName = "Ship Deckhand",
            FarmPos = Vector3.new(914.82, 125.99, 33128.67),
            QuestNPCPos = Vector3.new(1028.28, 125.09, 32922.51),
            QuestName = "ShipQuest1",
            QuestIndex = 1,
            RewardBeli = 12250
        },
        {
            MinLevel = 1275,
            MaxLevel = 1299,
            MobName = "Ship Engineer",
            FarmPos = Vector3.new(950.61, 44.09, 32968.16),
            QuestNPCPos = Vector3.new(1028.28, 125.09, 32922.51),
            QuestName = "ShipQuest1",
            QuestIndex = 2,
            RewardBeli = 12500
        },
        {
            MinLevel = 1300,
            MaxLevel = 1324,
            MobName = "Ship Steward",
            FarmPos = Vector3.new(918.42, 127.03, 33425.64),
            QuestNPCPos = Vector3.new(962.09, 125.09, 33269.21),
            QuestName = "ShipQuest2",
            QuestIndex = 1,
            RewardBeli = 12250
        },
        {
            MinLevel = 1325,
            MaxLevel = 1349,
            MobName = "Ship Officer",
            FarmPos = Vector3.new(921.45, 181.09, 33348.12),
            QuestNPCPos = Vector3.new(962.09, 125.09, 33269.21),
            QuestName = "ShipQuest2",
            QuestIndex = 2,
            RewardBeli = 12500
        },
        {
            MinLevel = 1350,
            MaxLevel = 1374,
            MobName = "Arctic Warrior",
            FarmPos = Vector3.new(5988.11, 28.40, -6229.00),
            QuestNPCPos = Vector3.new(5694.20, 28.40, -6489.64),
            QuestName = "FrostQuest",
            QuestIndex = 1,
            RewardBeli = 12250
        },
        {
            MinLevel = 1375,
            MaxLevel = 1424,
            MobName = "Snow Lurker",
            FarmPos = Vector3.new(5565.94, 34.94, -6798.41),
            QuestNPCPos = Vector3.new(5694.20, 28.40, -6489.64),
            QuestName = "FrostQuest",
            QuestIndex = 2,
            RewardBeli = 12500
        },
        {
            MinLevel = 1425,
            MaxLevel = 1449,
            MobName = "Sea Soldier",
            FarmPos = Vector3.new(-3051.46, 131.67, -9816.88),
            QuestNPCPos = Vector3.new(-3078.13, 239.68, -10138.27),
            QuestName = "ForgottenQuest",
            QuestIndex = 1,
            RewardBeli = 12250
        },
        {
            MinLevel = 1450,
            MaxLevel = 1499,
            MobName = "Water Fighter",
            FarmPos = Vector3.new(-3417.38, 238.88, -10514.25),
            QuestNPCPos = Vector3.new(-3078.13, 239.68, -10138.27),
            QuestName = "ForgottenQuest",
            QuestIndex = 2,
            RewardBeli = 12500
        },  --------------------SEA 2------------------------------------------
        {   --------------------SEA 3------------------------------------------
            MinLevel = 1500,
            MaxLevel = 1524,
            MobName = "Pirate Millionaire",
            FarmPos = Vector3.new(-716.74, 86.13, 5821.20),
            QuestNPCPos = Vector3.new(-446.33, 108.61, 5934.46),
            QuestName = "PiratePortQuest",
            QuestIndex = 1,
            RewardBeli = 13000
        },
        {
            MinLevel = 1525,
            MaxLevel = 1624,
            MobName = "Pistol Billionaire",
            FarmPos = Vector3.new(-137.76, 86.13, 5906.20),
            QuestNPCPos = Vector3.new(-446.33, 108.61, 5934.46),
            QuestName = "PiratePortQuest",
            QuestIndex = 2,
            RewardBeli = 15000
        },
        {
            MinLevel = 1625,
            MaxLevel = 1649,
            MobName = "Hydra Enforcer",
            FarmPos = Vector3.new(4516.00, 1002.26, 430.23),
            QuestNPCPos = Vector3.new(5196.71, 1004.10, 756.85),
            QuestName = "VenomCrewQuest",
            QuestIndex = 1,
            RewardBeli = 13000
        },
        {
            MinLevel = 1650,
            MaxLevel = 1699,
            MobName = "Venomous Assailant",
            FarmPos = Vector3.new(4521.05, 1158.85, 837.77),
            QuestNPCPos = Vector3.new(5196.71, 1004.10, 756.85),
            QuestName = "VenomCrewQuest",
            QuestIndex = 2,
            RewardBeli = 15000
        },
        {
            MinLevel = 1700,
            MaxLevel = 1724,
            MobName = "Marine Commodore",
            FarmPos = Vector3.new(2835.74, 115.52, -7780.65),
            QuestNPCPos = Vector3.new(2495.12, 74.27, -6800.91),
            QuestName = "MarineTreeIsland",
            QuestIndex = 1,
            RewardBeli = 13000
        },
        {
            MinLevel = 1725,
            MaxLevel = 1974,
            MobName = "Marine Rear Admiral",
            FarmPos = Vector3.new(3648.25, 123.98, -7042.48),
            QuestNPCPos = Vector3.new(2495.12, 74.27, -6800.91),
            QuestName = "MarineTreeIsland",
            QuestIndex = 2,
            RewardBeli = 15000
        },
        {
            MinLevel = 1975,
            MaxLevel = 1999,
            MobName = "Reborn Skeleton",
            FarmPos = Vector3.new(-8783.82, 142.14, 6028.49),
            QuestNPCPos = Vector3.new(-9475.78, 142.14, 5586.67),
            QuestName = "HauntedQuest1",
            QuestIndex = 1,
            RewardBeli = 13000
        },
        {
            MinLevel = 2000,
            MaxLevel = 2024,
            MobName = "Living Zombie",
            FarmPos = Vector3.new(-10049.56, 141.36, 5837.81),
            QuestNPCPos = Vector3.new(-9475.78, 142.14, 5586.67),
            QuestName = "HauntedQuest1",
            QuestIndex = 2,
            RewardBeli = 13250
        },
        {
            MinLevel = 2025,
            MaxLevel = 2049,
            MobName = "Demonic Soul",
            FarmPos = Vector3.new(-9506.13, 172.14, 6157.09),
            QuestNPCPos = Vector3.new(-9517.62, 172.14, 6091.13),
            QuestName = "HauntedQuest2",
            QuestIndex = 1,
            RewardBeli = 13500
        },
        {
            MinLevel = 2050,
            MaxLevel = 2074,
            MobName = "Posessed Mummy",
            FarmPos = Vector3.new(-9591.54, 5.83, 6211.81),
            QuestNPCPos = Vector3.new(-9517.62, 172.14, 6091.13),
            QuestName = "HauntedQuest2",
            QuestIndex = 2,
            RewardBeli = 13750
        },
        {
            MinLevel = 2075,
            MaxLevel = 2099,
            MobName = "Peanut Scout",
            FarmPos = Vector3.new(-2105.39, 38.14, -10122.31),
            QuestNPCPos = Vector3.new(-2120.49, 39.92, -10189.19),
            QuestName = "NutsIslandQuest",
            QuestIndex = 1,
            RewardBeli = 14000
        },
        {
            MinLevel = 2100,
            MaxLevel = 2124,
            MobName = "Peanut President",
            FarmPos = Vector3.new(-2120.99, 79.08, -10462.72),
            QuestNPCPos = Vector3.new(-2120.49, 39.92, -10189.19),
            QuestName = "NutsIslandQuest",
            QuestIndex = 2,
            RewardBeli = 14100
        },
        {
            MinLevel = 2125,
            MaxLevel = 2149,
            MobName = "Ice Cream Chef",
            FarmPos = Vector3.new(-747.29, 65.85, -11002.71),
            QuestNPCPos = Vector3.new(-829.21, 65.85, -10960.83),
            QuestName = "IceCreamIslandQuest",
            QuestIndex = 1,
            RewardBeli = 14200
        },
        {
            MinLevel = 2150,
            MaxLevel = 2199,
            MobName = "Ice Cream Commander",
            FarmPos = Vector3.new(-625.10, 126.91, -11176.10),
            QuestNPCPos = Vector3.new(-829.21, 65.85, -10960.83),
            QuestName = "IceCreamIslandQuest",
            QuestIndex = 2,
            RewardBeli = 14300
        },
        {
            MinLevel = 2200,
            MaxLevel = 2224,
            MobName = "Cookie Crafter",
            FarmPos = Vector3.new(-2369.50, 37.83, -12124.49),
            QuestNPCPos = Vector3.new(-2039.86, 37.83, -12032.57),
            QuestName = "CakeQuest1",
            QuestIndex = 1,
            RewardBeli = 14200
        },
        {
            MinLevel = 2225,
            MaxLevel = 2249,
            MobName = "Cake Guard",
            FarmPos = Vector3.new(-1599.10, 43.83, -12247.68),
            QuestNPCPos = Vector3.new(-2039.86, 37.83, -12032.57),
            QuestName = "CakeQuest1",
            QuestIndex = 2,
            RewardBeli = 14300
        },
        {
            MinLevel = 2250,
            MaxLevel = 2274,
            MobName = "Baking Staff",
            FarmPos = Vector3.new(-1865.02, 37.83, -12985.24),
            QuestNPCPos = Vector3.new(-1929.10, 37.83, -12854.16),
            QuestName = "CakeQuest2",
            QuestIndex = 1,
            RewardBeli = 14400
        },
        {
            MinLevel = 2275,
            MaxLevel = 2299,
            MobName = "Head Baker",
            FarmPos = Vector3.new(-2211.77, 53.54, -12874.58),
            QuestNPCPos = Vector3.new(-1929.10, 37.83, -12854.16),
            QuestName = "CakeQuest2",
            QuestIndex = 2,
            RewardBeli = 14500
        },
        {
            MinLevel = 2300,
            MaxLevel = 2324,
            MobName = "Cocoa Warrior",
            FarmPos = Vector3.new(32.86, 24.77, -12223.83),
            QuestNPCPos = Vector3.new(232.58, 24.77, -12185.34),
            QuestName = "ChocQuest1e",
            QuestIndex = 1,
            RewardBeli = 14600
        },
        {
            MinLevel = 2325,
            MaxLevel = 2349,
            MobName = "Chocolate Bar Battler",
            FarmPos = Vector3.new(681.76, 24.77, -12583.60),
            QuestNPCPos = Vector3.new(232.58, 24.77, -12185.34),
            QuestName = "ChocQuest1",
            QuestIndex = 2,
            RewardBeli = 14700
        },
        {
            MinLevel = 2350,
            MaxLevel = 2374,
            MobName = "Sweet Thief",
            FarmPos = Vector3.new(48.88, 24.83, -12623.41),
            QuestNPCPos = Vector3.new(135.77, 24.83, -12776.10),
            QuestName = "ChocQuest2",
            QuestIndex = 1,
            RewardBeli = 14800
        },
        {
            MinLevel = 2375,
            MaxLevel = 2399,
            MobName = "Candy Rebel",
            FarmPos = Vector3.new(95.06, 24.83, -12935.54),
            QuestNPCPos = Vector3.new(135.77, 24.83, -12776.10),
            QuestName = "ChocQuest2",
            QuestIndex = 2,
            RewardBeli = 14900
        },
        {
            MinLevel = 2400,
            MaxLevel = 2424,
            MobName = "Candy Pirate",
            FarmPos = Vector3.new(-1359.20, 32.08, -14547.01),
            QuestNPCPos = Vector3.new(-1164.43, 60.97, -14506.08),
            QuestName = "CandyQuest1",
            QuestIndex = 1,
            RewardBeli = 14950
        },
        {
            MinLevel = 2425,
            MaxLevel = 2449,
            MobName = "Snow Demon",
            FarmPos = Vector3.new(-823.14, 13.18, -14539.29),
            QuestNPCPos = Vector3.new(-1164.43, 60.97, -14506.08),
            QuestName = "CandyQuest1",
            QuestIndex = 2,
            RewardBeli = 15000
        },
        {
            MinLevel = 2450,
            MaxLevel = 2474,
            MobName = "Isle Outlaw",
            FarmPos = Vector3.new(-16283.74, 21.71, -191.98),
            QuestNPCPos = Vector3.new(-16550.60, 55.73, -184.48),
            QuestName = "TikiQuest1",
            QuestIndex = 1,
            RewardBeli = 15100
        },
        {
            MinLevel = 2475,
            MaxLevel = 2499,
            MobName = "Island Boy",
            FarmPos = Vector3.new(-16825.98, 21.71, -195.33),
            QuestNPCPos = Vector3.new(-16550.60, 55.73, -184.48),
            QuestName = "TikiQuest1",
            QuestIndex = 2,
            RewardBeli = 15200
        },
        {
            MinLevel = 2500,
            MaxLevel = 2524,
            MobName = "Sun-kissed Warrior",
            FarmPos = Vector3.new(-16241.96, 21.71, 1067.87),
            QuestNPCPos = Vector3.new(-16536.19, 55.73, 1063.75),
            QuestName = "TikiQuest2",
            QuestIndex = 1,
            RewardBeli = 15250
        },
        {
            MinLevel = 2525,
            MaxLevel = 2549,
            MobName = "Isle Champion",
            FarmPos = Vector3.new(-16821.18, 21.71, 1036.77),
            QuestNPCPos = Vector3.new(-16536.19, 55.73, 1063.75),
            QuestName = "TikiQuest2",
            QuestIndex = 2,
            RewardBeli = 15500
        },
        {
            MinLevel = 2550,
            MaxLevel = 2574,
            MobName = "Serpent Hunter",
            FarmPos = Vector3.new(-16538.62, 106.28, 1487.51),
            QuestNPCPos = Vector3.new(-16654.62, 105.88, 1590.55),
            QuestName = "TikiQuest3",
            QuestIndex = 1,
            RewardBeli = 15750
        },
        {
            MinLevel = 2575,
            MaxLevel = 2599,
            MobName = "Skull Slayer",
            FarmPos = Vector3.new(-16843.12, 71.28, 1643.89),
            QuestNPCPos = Vector3.new(-16654.62, 105.88, 1590.55),
            QuestName = "TikiQuest3",
            QuestIndex = 2,
            RewardBeli = 16000
        },
        {
            MinLevel = 2600,
            MaxLevel = 2624,
            MobName = "Reef Bandit",
            FarmPos = Vector3.new(10984.98, -2024.68, 9170.98),
            QuestNPCPos = Vector3.new(10780.76, -2083.79, 9260.74),
            QuestName = "SubmergedQuest1",
            QuestIndex = 1,
            RewardBeli = 15450
        },
        {
            MinLevel = 2625,
            MaxLevel = 2649,
            MobName = "Coral Pirate",
            FarmPos = Vector3.new(10749.90, -2078.04, 9471.10),
            QuestNPCPos = Vector3.new(10780.76, -2083.79, 9260.74),
            QuestName = "SubmergedQuest1",
            QuestIndex = 2,
            RewardBeli = 15500
        },
        {
            MinLevel = 2650,
            MaxLevel = 2674,
            MobName = "Sea Chanter",
            FarmPos = Vector3.new(10697.05, -2052.69, 9993.14),
            QuestNPCPos = Vector3.new(10883.67, -2082.30, 10034.12),
            QuestName = "SubmergedQuest2",
            QuestIndex = 1,
            RewardBeli = 15550
        },
        {
            MinLevel = 2675,
            MaxLevel = 2699,
            MobName = "Ocean Prophet",
            FarmPos = Vector3.new(10985.31, -2047.34, 10188.33),
            QuestNPCPos = Vector3.new(10883.67, -2082.30, 10034.12),
            QuestName = "SubmergedQuest3",
            QuestIndex = 2,
            RewardBeli = 15600
        },
        {
            MinLevel = 2700,
            MaxLevel = 2724,
            MobName = "High Disciple",
            FarmPos = Vector3.new(9807.89, -1989.81, 9674.30),
            QuestNPCPos = Vector3.new(9637.59, -1988.38, 9616.68),
            QuestName = "SubmergedQuest3",
            QuestIndex = 1,
            RewardBeli = 15650
        },
        {
            MinLevel = 2725,
            MaxLevel = 99999,
            MobName = "Grand Devotee",
            FarmPos = Vector3.new(9577.99, -1928.17, 9935.49),
            QuestNPCPos = Vector3.new(9637.59, -1988.38, 9616.68),
            QuestName = "SubmergedQuest3",
            QuestIndex = 2,
            RewardBeli = 15700
        }
    }

    local running = false
    local lastLevel = 0

    local function getLevel()
        local d = player:FindFirstChild("Data")
        return d and d:FindFirstChild("Level") and d.Level.Value or 0
    end

    local function getZoneForLevel(level)
        for _, zone in ipairs(FarmZones) do
            if level >= zone.MinLevel and level <= zone.MaxLevel then
                return zone
            end
        end
        return nil
    end

    local MOVE_SPEED = 275 -- units per second

    -- Interruptible movement function (returns true if arrived, false if interrupted)
    local function tweenTo(pos)
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

        if not hrp or not hrp.Parent then return false end

        local distance = (hrp.Position - pos).Magnitude
        if distance < 5 then return true end
        if distance > 15000 then return true end

        -- Move towards pos manually so we can interrupt anytime by changing 'running'
        local arrived = false
        while hrp and hrp.Parent do
            -- abort if running was set to false
            if not running then
                return false
            end

            local currentPos = hrp.Position
            local toTarget = pos - currentPos
            local distNow = toTarget.Magnitude
            if distNow <= 1 then
                arrived = true
                break
            end

            local dt = RunService.Heartbeat:Wait()
            -- step distance this frame
            local step = math.min(distNow, MOVE_SPEED * dt)
            -- avoid NaN if toTarget is zero
            local dir = toTarget.Unit
            local newPos = currentPos + dir * step

            -- zero velocity and set new CFrame (smoother than setting Velocity)
            if hrp and hrp.Parent then
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                hrp.CFrame = CFrame.new(newPos)
            else
                break
            end
        end

        return arrived
    end

    local function acceptQuest(zone)
        if not zone then return end
        local ok = tweenTo(zone.QuestNPCPos + Vector3.new(0, 3, 0))
        if not ok then return end -- interrupted or couldn't reach, abort accept
        task.wait(1)

        local args = {
            [1] = "StartQuest",
            [2] = zone.QuestName,
            [3] = zone.QuestIndex
        }

        pcall(function()
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
        end)

        currentQuestKills = 0
        currentQuestBeli = player:WaitForChild("Data"):WaitForChild("Beli").Value

        if zone.RewardBeli then
            expectedRewardBeli = zone.RewardBeli
        end
    end

    -- Auto attack loop (giữ như cũ, bật khi running = true)
    spawn(function()
        while true do
            task.wait(0.4)
            if running then
                pcall(function()
                    local args = { 0.4000000059604645 }
                    ReplicatedStorage
                        :WaitForChild("Modules")
                        :WaitForChild("Net")
                        :WaitForChild("RE/RegisterAttack")
                        :FireServer(unpack(args))
                end)
            end
        end
    end)

    -- Tìm quái
    local function getNearestMob(name)
        local enemies = workspace:FindFirstChild("Enemies")
        if not enemies then return nil end

        local closest = nil
        local minDist = math.huge
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
        local hrpPos = char.HumanoidRootPart.Position

        for _, mob in pairs(enemies:GetChildren()) do
            if mob.Name == name and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") then
                local dist = (hrpPos - mob.HumanoidRootPart.Position).Magnitude
                if mob:FindFirstChildOfClass("Humanoid").Health > 0 and dist < minDist then
                    closest = mob
                    minDist = dist
                end
            end
        end
        return closest
    end

    -- Theo quái (giữ logic cũ; dừng nếu running = false)
    local function followMob(mob)
        if not mob then return end
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local camera = workspace.CurrentCamera

        local anchor = Instance.new("Part")
        anchor.Anchored = true
        anchor.CanCollide = false
        anchor.Transparency = 1
        anchor.Size = Vector3.new(1, 1, 1)
        anchor.CFrame = hrp.CFrame
        anchor.Parent = workspace

        camera.CameraType = Enum.CameraType.Custom
        camera.CameraSubject = anchor

        local anchorY = mob.HumanoidRootPart.Position.Y + 25
        local lastUpdate = tick()

        while mob and mob.Parent and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid")
            and mob:FindFirstChildOfClass("Humanoid").Health > 0 and running do

            local hrpEnemy = mob:FindFirstChild("HumanoidRootPart")
            if not hrpEnemy then break end

            if (tick() - lastUpdate) > 2 or math.abs(anchorY - hrpEnemy.Position.Y) > 15 then
                anchorY = hrpEnemy.Position.Y + 25
                lastUpdate = tick()
            end

            local targetPos = Vector3.new(hrpEnemy.Position.X, anchorY, hrpEnemy.Position.Z)
            anchor.Position = anchor.Position:Lerp(targetPos, 0.15)
            if hrp and hrp.Parent then
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(targetPos), 0.25)
            end

            RunService.RenderStepped:Wait()
        end

        -- restore camera and cleanup
        if char and char:FindFirstChild("HumanoidRootPart") then
            camera.CameraType = Enum.CameraType.Custom
            camera.CameraSubject = hrp
        end
        if anchor and anchor.Parent then
            anchor:Destroy()
        end
    end

    -- Farm loop (dựa trên biến running)
    spawn(function()
        while true do
            task.wait()
            if not running then continue end

            local level = getLevel()
            local zone = getZoneForLevel(level)
            if not zone then continue end

            if level ~= lastLevel then
                lastLevel = level
                acceptQuest(zone)
            end

            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp and (hrp.Position - zone.FarmPos).Magnitude > 1000 then
                -- if movement aborted, we'll just continue the loop and re-evaluate
                tweenTo(zone.FarmPos + Vector3.new(0, 3, 0))
            end

            local mob = getNearestMob(zone.MobName)
            if mob then
                followMob(mob)
                currentQuestKills += 1
            end

            local newBeli = player:FindFirstChild("Data"):FindFirstChild("Beli").Value
            if newBeli - currentQuestBeli >= expectedRewardBeli then
                acceptQuest(zone)
            elseif currentQuestKills >= maxQuestKills then
                acceptQuest(zone)
            end
        end
    end)

    -- sync trạng thái 'running' theo màu của button UI
    local function setRunningFromButtonColor()
        local on = isButtonOn()
        if on and not running then
            running = true
            lastLevel = getLevel()
            -- bật các attribute cần thiết khi start
            pcall(function()
                player:SetAttribute("FastAttackEnemyMode", "Toggle")
                player:SetAttribute("FastAttackEnemy", true)
            end)
        elseif not on and running then
            running = false
        end
    end

    -- Khi người dùng click vào button UI: gửi lệnh cho ToggleUI (theo mẫu bạn đưa)
    toggleBtn.Activated:Connect(function()
        if ToggleUI and ToggleUI.Set then
            local target = not isButtonOn()
            pcall(ToggleUI.Set, BUTTON_NAME, target)
        end
    end)

    -- Nếu màu nền button thay đổi => cập nhật running
    toggleBtn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        -- nhỏ delay để UI nội bộ có thể cập nhật màu trước khi chúng ta đọc
        task.defer(function()
            setRunningFromButtonColor()
        end)
    end)

    -- Khởi tạo trạng thái theo màu hiện tại của button khi script bắt đầu
    setRunningFromButtonColor()

    -- Khi chết: dừng ngay lập tức và reset UI về OFF (yêu cầu của bạn)
    local function onDeath()
        if running then
            running = false
        end
        -- gửi yêu cầu tắt UI (an toàn dùng pcall)
        if ToggleUI and ToggleUI.Set then
            pcall(ToggleUI.Set, BUTTON_NAME, false)
        end
    end

    -- Kết nối sự kiện chết cho mỗi character
    player.CharacterAdded:Connect(function(char)
        -- nếu có humanoid hiện hữu, connect Died
        local h = char:WaitForChild("Humanoid", 5)
        if h then
            h.Died:Connect(function()
                onDeath()
            end)
        end
        -- KHÔNG tự động khởi động lại khi respawn (theo yêu cầu)
    end)

    -- Nếu đã có character lúc chạy script, cũng cần gắn listener
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.Died:Connect(function() onDeath() end)
    end
end

--=== AUTO FARM ARENA =====================================================================================================--

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local player = Players.LocalPlayer
    local camera = workspace.CurrentCamera

    -- chờ ToggleUI helper (theo mẫu của bạn)
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI

    -- đường dẫn tới ScrollingTab -> tìm Main bên trong
    local ScrollingTab = Players.LocalPlayer
        .PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    local uiMain = ScrollingTab:FindFirstChild("Main", true)
    if not uiMain then
        warn("Không tìm thấy Frame 'Main' trong ScrollingTab")
        return
    end

    -- tên UI do bạn đặt
    local BUTTON_NAME = "AutoFarmArenaButton"
    local BOX_NAME    = "AutoFarmArenaBox"

    -- find controls (đệ quy)
    local autoBtn = uiMain:FindFirstChild(BUTTON_NAME, true)
    local distanceBox = uiMain:FindFirstChild(BOX_NAME, true)

    if not autoBtn then
        warn("Không tìm thấy button:", BUTTON_NAME)
        return
    end
    if not distanceBox then
        warn("Không tìm thấy textbox:", BOX_NAME)
        return
    end

    -- ensure ToggleUI state initial
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)
    pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)

    -- game state
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")
    local running = false

    -- farm vars
    local distanceLimit = 5000
    local farmPoint = nil
    local farmBillboard = nil
    local farmCenter = nil

    -- anchor/camera follow
    local anchor = nil
    local anchorY = nil
    local lastAnchorUpdate = 0
    local anchorUpdateInterval = 1

    local function onCharacterDied()
    	if running then
    		running = false

    		-- tắt UI toggle
    		pcall(function()
    			ToggleUI.Set(BUTTON_NAME, false)
    		end)

    		-- cleanup an toàn
    		camera.CameraType = Enum.CameraType.Custom
    		camera.CameraSubject = hrp
    		destroyFarmPoint()

    		if anchor and anchor.Parent then
    			anchor:Destroy()
    		end
    		anchor = nil
    	end
    end

    if humanoid then
    	humanoid.Died:Connect(onCharacterDied)
    end

    -- helper: normalize textbox initial value
    if not distanceBox.Text or distanceBox.Text == "" then
        distanceBox.Text = tostring(distanceLimit)
    else
        local n = tonumber(distanceBox.Text)
        if n and n > 0 then distanceLimit = math.floor(n) else distanceBox.Text = tostring(distanceLimit) end
    end

    -- ensure anchor part for camera subject
    local function ensureAnchor()
        if not anchor or not anchor.Parent then
            anchor = Instance.new("Part")
            anchor.Anchored = true
            anchor.CanCollide = false
            anchor.Transparency = 1
            anchor.Size = Vector3.new(1,1,1)
            anchor.Name = "CameraAnchor"
            if hrp and hrp:IsDescendantOf(workspace) then
                anchor.Position = hrp.Position
            else
                anchor.Position = Vector3.new(0,10,0)
            end
            anchor.Parent = workspace
        end
        return anchor
    end

    -- tweenTo (giữ như bản gốc)
    local MOVE_SPEED_OVERRIDE = 300
    local function tweenTo(pos)
        if not hrp then return end
        local dist = (hrp.Position - pos).Magnitude
        if dist > 10000 then return end
        local tween = TweenService:Create(hrp, TweenInfo.new(dist / MOVE_SPEED_OVERRIDE, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos)})
        tween:Play()
        tween.Completed:Wait()
    end

    -- get nearest enemy within distanceLimit around centerPos
    local function getNearestEnemy(centerPos)
        local folder = workspace:FindFirstChild("Enemies")
        if not folder then return nil end
        local nearest, nearestDist
        for _, mob in ipairs(folder:GetChildren()) do
            if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") then
                local hp = mob:FindFirstChildOfClass("Humanoid")
                if hp and hp.Health > 0 then
                    local dist = (centerPos - mob.HumanoidRootPart.Position).Magnitude
                    if dist <= (distanceLimit or 0) then
                        if not nearestDist or dist < nearestDist then
                            nearest = mob
                            nearestDist = dist
                        end
                    end
                end
            end
        end
        return nearest
    end

    -- highlight helper (gốc)
    local function updateHighlight(enemy)
        if not enemy then return end
        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        if not enemy:FindFirstChild("HomeHighlight") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "HomeHighlight"
            highlight.FillTransparency = 0.2
            highlight.OutlineTransparency = 0.9
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = enemy
            highlight.Parent = enemy
        end

        local highlight = enemy:FindFirstChild("HomeHighlight")
        local conn
        conn = RunService.RenderStepped:Connect(function()
            if not running or not humanoid.Parent or humanoid.Health <= 0 or not highlight or highlight.Parent ~= enemy then
                if highlight then highlight:Destroy() end
                conn:Disconnect()
                return
            end

            local percent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
            highlight.FillColor = Color3.fromRGB(255 * (1 - percent), 255 * percent, 0)
        end)
    end

    -- follow enemy (giữ logic)
    local function followEnemy(enemy)
        if not enemy then return end
        local hrpEnemy = enemy:FindFirstChild("HumanoidRootPart")
        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
        if not hrpEnemy or not humanoid then return end

        updateHighlight(enemy)
        local anchorLocal = ensureAnchor()

        if not anchorY or (tick() - lastAnchorUpdate) > anchorUpdateInterval then
            anchorY = hrpEnemy.Position.Y + 25
            lastAnchorUpdate = tick()
        end

        camera.CameraType = Enum.CameraType.Custom
        camera.CameraSubject = anchorLocal

        local dist = (hrp.Position - hrpEnemy.Position).Magnitude
        if dist > 200 then
            tweenTo(hrpEnemy.Position + Vector3.new(0, 5, 0))
        else
            while humanoid.Health > 0 and running do
                updateHighlight(enemy)
                anchorY = hrpEnemy.Position.Y + 25
                local targetPos = Vector3.new(hrpEnemy.Position.X, anchorY, hrpEnemy.Position.Z)
                anchorLocal.Position = anchorLocal.Position:Lerp(targetPos, 0.15)

                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(targetPos), 0.25)
                RunService.RenderStepped:Wait()
            end
        end
    end

    -- create farm point + billboard
    local function createFarmPoint(pos)
        if farmPoint and farmPoint.Parent then
            farmPoint:Destroy()
            farmPoint = nil
            farmBillboard = nil
        end

        farmPoint = Instance.new("Part")
        farmPoint.Name = "FarmPoint"
        farmPoint.Size = Vector3.new(1,1,1)
        farmPoint.Anchored = true
        farmPoint.CanCollide = false
        farmPoint.Transparency = 1
        farmPoint.Position = pos
        farmPoint.Parent = workspace

        local bb = Instance.new("BillboardGui")
        bb.Name = "FarmDistanceUI"
        bb.Adornee = farmPoint
        bb.Size = UDim2.new(0, 120, 0, 40)
        bb.StudsOffset = Vector3.new(0, 2, 0)
        bb.AlwaysOnTop = true
        bb.Parent = farmPoint

        local label = Instance.new("TextLabel", bb)
        label.Name = "DistanceLabel"
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.TextScaled = true
        label.Font = Enum.Font.SourceSansBold
        label.Text = "0/" .. tostring(distanceLimit)
        label.TextColor3 = Color3.fromRGB(0,255,0)
        label.TextStrokeTransparency = 0.6

        farmBillboard = { gui = bb, label = label }
        farmCenter = farmPoint.Position
    end

    local function destroyFarmPoint()
        if farmPoint and farmPoint.Parent then farmPoint:Destroy() end
        farmPoint = nil
        farmBillboard = nil
        farmCenter = nil
    end

    -- TextBox change (commit on FocusLost)
    if distanceBox then
        distanceBox.FocusLost:Connect(function(enterPressed)
            local val = tonumber(distanceBox.Text)
            if val and val > 0 then
                distanceLimit = math.floor(val)
            else
                distanceBox.Text = tostring(distanceLimit)
            end
            if farmBillboard and farmBillboard.label then
                farmBillboard.label.Text = "0/" .. tostring(distanceLimit)
            end
        end)
    end

    player.CharacterAdded:Connect(function(newChar)
    	character = newChar
    	hrp = newChar:WaitForChild("HumanoidRootPart")
    	local humanoid = newChar:WaitForChild("Humanoid")

    	running = false

    	-- force UI OFF khi respawn
    	pcall(function()
    		ToggleUI.Set(BUTTON_NAME, false)
    	end)

    	if anchor and anchor.Parent then anchor:Destroy() end
    	anchor = nil
    	destroyFarmPoint()

    	camera.CameraType = Enum.CameraType.Custom
    	camera.CameraSubject = hrp

    	-- reconnect died event
    	humanoid.Died:Connect(onCharacterDied)
    end)

    -- When user clicks the UI toggle: call ToggleUI.Set like mẫu
    if autoBtn then
        -- handle either Activated or MouseButton1Click
        local function onToggleActivated()
            -- infer current on from background color (greenish -> on)
            local bg = autoBtn.BackgroundColor3
            local currentOn = (bg and bg.G and bg.G > bg.R and bg.G > bg.B and bg.G > 0.5)
            local target = not currentOn
            pcall(function() ToggleUI.Set(BUTTON_NAME, target) end)
        end
        if autoBtn.Activated then
            autoBtn.Activated:Connect(onToggleActivated)
        else
            autoBtn.MouseButton1Click:Connect(onToggleActivated)
        end
    end

    -- Sync running state from button color changes (ToggleUI will change color)
    local function setRunningFromButtonColor()
        if not autoBtn then return end
        local bg = autoBtn.BackgroundColor3
        local isOn = (bg and bg.G and bg.G > bg.R and bg.G > bg.B and bg.G > 0.5)
        if isOn and not running then
            running = true
            -- ensure FastAttackEnemy turned on when starting (only set true)
            pcall(function()
                player:SetAttribute("FastAttackEnemyMode", "Toggle")
                player:SetAttribute("FastAttackEnemy", true)
            end)
            -- create farmPoint at current hrp position
            if hrp then createFarmPoint(hrp.Position) end
        elseif not isOn and running then
            running = false
            -- stop and cleanup
            camera.CameraType = Enum.CameraType.Custom
            camera.CameraSubject = hrp
            destroyFarmPoint()
            if anchor and anchor.Parent then anchor:Destroy() end
            anchor = nil
            -- (We DO NOT set FastAttackEnemy = false here — keep non-destructive behavior)
        end
    end

    autoBtn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        -- let ToggleUI update internally first, small delay
        task.delay(0.05, setRunningFromButtonColor)
    end)

    -- initial sync
    setRunningFromButtonColor()

    -- update billboard color and farmCenter each frame
    do
        local lastRatio = -1
        local colorTween = nil
        RunService.RenderStepped:Connect(function()
            if farmPoint and farmPoint.Parent and farmBillboard and farmBillboard.label and hrp then
                local rawDist = (hrp.Position - farmPoint.Position).Magnitude
                local clamped = math.clamp(rawDist, 0, distanceLimit)
                local display = math.floor(clamped + 0.5)
                farmBillboard.label.Text = tostring(display) .. "/" .. tostring(distanceLimit)

                local ratio = distanceLimit > 0 and (clamped / distanceLimit) or 0
                if math.abs(ratio - lastRatio) > 0.01 then
                    lastRatio = ratio
                    local r = math.floor(255 * ratio)
                    local g = math.floor(255 * (1 - ratio))
                    local targetColor = Color3.fromRGB(r, g, 0)
                    if colorTween then
                        pcall(function() colorTween:Cancel() end)
                    end
                    colorTween = TweenService:Create(farmBillboard.label, TweenInfo.new(0.12, Enum.EasingStyle.Linear), {TextColor3 = targetColor})
                    colorTween:Play()
                end

                farmCenter = farmPoint.Position
            end
        end)
    end

    -- auto farm loop: use farmCenter when available
    task.spawn(function()
        while true do
            task.wait()
            if not running or not hrp then continue end
            local center = farmCenter or hrp.Position
            local target = getNearestEnemy(center)
            if target then
                followEnemy(target)
            end
        end
    end)

    -- auto attack loop (giữ nguyên)
    task.spawn(function()
        while true do
            task.wait(0.4)
            if running then
                pcall(function()
                    ReplicatedStorage
                        :WaitForChild("Modules")
                        :WaitForChild("Net")
                        :WaitForChild("RE/RegisterAttack")
                        :FireServer(0.4)
                end)
            end
        end
    end)
end

--=== BRING MOD =====================================================================================================--

do
    -- ========= SETTINGS =========
    local HITBOX_SIZE = Vector3.new(60, 60, 60)
    local MAX_DISTANCE = 1000
    local MAX_MOVE_FROM_ORIGIN = 200
    local LOOP_DELAY = 0.15
    local IGNORED_ENEMIES = {
        ["Blank Buddy"] = true,
        ["PropHitboxPlaceholder"] = true
    }
    -- ============================

    local Workspace = game:GetService("Workspace")
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    local Enemies = Workspace:WaitForChild("Enemies")
    local LocalPlayer = Players.LocalPlayer

    -- ===== ToggleUI =====
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() ToggleUI.Refresh() end)

    -- ===== UI ROOT (CỐ ĐỊNH) =====
    local ScrollingTab = LocalPlayer.PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    local Frame = ScrollingTab:FindFirstChild("Main", true)
    if not Frame then return warn("Không tìm thấy Frame Main") end

    local ToggleBtn = Frame:FindFirstChild("BringModButton", true)
    if not ToggleBtn then return warn("Không tìm thấy BringModButton") end

    -- ===== GATE 2 (EXTERNAL CONTROL) =====
    _G.BringMobGate2 = false -- MẶC ĐỊNH

    -- ===== GATE 1: TOGGLE STATE (qua màu) =====
    local function isGate1On()
        local bg = ToggleBtn.BackgroundColor3
        return bg.G > bg.R and bg.G > bg.B
    end

    -- ===== SET DEFAULT: GATE 1 = TRUE =====
    pcall(function()
        ToggleUI.Set("BringModButton", true)
    end)

    -- ===== TOGGLE BUTTON CLICK =====
    local function onToggleActivated()
        local cur = isGate1On()
        pcall(function()
            ToggleUI.Set("BringModButton", not cur)
        end)
    end

    if ToggleBtn.Activated then
        ToggleBtn.Activated:Connect(onToggleActivated)
    else
        ToggleBtn.MouseButton1Click:Connect(onToggleActivated)
    end

    -- ===== SIMULATION RADIUS =====
    if sethiddenproperty then
        pcall(function()
            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
        end)
    end

    local function getRoot(model)
        return model and model:FindFirstChild("HumanoidRootPart")
    end

    -- 🔹 Lưu vị trí ban đầu của từng enemy
    local InitialPositions = {}

    -- ===== MAIN LOOP =====
    task.spawn(function()
        while true do
            task.wait(LOOP_DELAY)

            -- 🚪 CHECK 2 CỔNG
            if not (isGate1On() and _G.BringMobGate2) then
                continue
            end

            local char = LocalPlayer.Character
            local playerRoot = getRoot(char)
            if not playerRoot then
                continue
            end

            local mobGroups = {}

            for _, mob in ipairs(Enemies:GetChildren()) do
                if IGNORED_ENEMIES[mob.Name] then
                    continue
                end

                local hrp = getRoot(mob)
                local hum = mob:FindFirstChild("Humanoid")

                if hrp and hum then
                    if not InitialPositions[mob] then
                        InitialPositions[mob] = hrp.Position
                    end

                    if (hrp.Position - playerRoot.Position).Magnitude <= MAX_DISTANCE then
                        mobGroups[mob.Name] = mobGroups[mob.Name] or {}
                        table.insert(mobGroups[mob.Name], mob)
                    end
                end
            end

            for _, group in pairs(mobGroups) do
                if #group >= 2 then
                    local sumPos = Vector3.zero
                    for _, mob in ipairs(group) do
                        sumPos += mob.HumanoidRootPart.Position
                    end
                    local centerPos = sumPos / #group

                    local finalGroup = {}

                    for _, mob in ipairs(group) do
                        local originPos = InitialPositions[mob]
                        if originPos and (centerPos - originPos).Magnitude <= MAX_MOVE_FROM_ORIGIN then
                            table.insert(finalGroup, mob)
                        end
                    end

                    if #finalGroup >= 2 then
                        local finalSum = Vector3.zero
                        for _, mob in ipairs(finalGroup) do
                            finalSum += mob.HumanoidRootPart.Position
                        end
                        local centerCFrame = CFrame.new(finalSum / #finalGroup)

                        for _, mob in ipairs(finalGroup) do
                            local hrp = mob.HumanoidRootPart
                            local hum = mob.Humanoid

                            hrp.CFrame = centerCFrame
                            hrp.Size = HITBOX_SIZE
                            hrp.Transparency = 1
                            hrp.CanCollide = false

                            hum.WalkSpeed = 0
                            hum.JumpPower = 0
                        end
                    end
                end
            end
        end
    end)
end
--[[ HOOK
_G.BringMobGate2 = true   -- ON
_G.BringMobGate2 = false  -- OFF
]]
