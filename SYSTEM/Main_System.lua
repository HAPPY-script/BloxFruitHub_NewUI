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
    local camera = workspace.CurrentCamera

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

    -- Auto Farm variables & config (giữ logic cũ)
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
            FarmPos = Vector3.new(-1131.05, 40.83, -523.17),
            QuestNPCPos = Vector3.new(-1610.07, 20.89, 130.48),
            QuestName = "JungleQuest",
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
            MaxLevel = 1149,
            MobName = "Horned Warrior",
            FarmPos = Vector3.new(-6265.67, 15.99, -5766.91),
            QuestNPCPos = Vector3.new(-6043.20, 15.99, -4909.17),
            QuestName = "IceSideQuest",
            QuestIndex = 2,
            RewardBeli = 12500
        },
        {
            MinLevel = 1150,
            MaxLevel = 1174,
            MobName = "Magma Ninja",
            FarmPos = Vector3.new(-5293.55, 35.44, -4705.81),
            QuestNPCPos = Vector3.new(-5445.89, 15.99, -5292.91),
            QuestName = "FireSideQuest",
            QuestIndex = 1,
            RewardBeli = 12250
        },
        {
            MinLevel = 1175,
            MaxLevel = 1199,
            MobName = "Lava Pirate",
            FarmPos = Vector3.new(-5524.52, 60.59, -5935.76),
            QuestNPCPos = Vector3.new(-5445.89, 15.99, -5292.91),
            QuestName = "FireSideQuest",
            QuestIndex = 2,
            RewardBeli = 12500
        },
        {
            MinLevel = 1200,
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
            MaxLevel = 1774,
            MobName = "Marine Rear Admiral",
            FarmPos = Vector3.new(3648.25, 123.98, -7042.48),
            QuestNPCPos = Vector3.new(2495.12, 74.27, -6800.91),
            QuestName = "MarineTreeIsland",
            QuestIndex = 2,
            RewardBeli = 15000
        },
        {
            MinLevel = 1775,
            MaxLevel = 1799,
            MobName = "Fishman Raider",
            FarmPos = Vector3.new(-10426.78, 357.46, -8389.51),
            QuestNPCPos = Vector3.new(-10580.99, 331.80, -8764.03),
            QuestName = "DeepForestIsland3",
            QuestIndex = 1,
            RewardBeli = 13000
        },
        {
            MinLevel = 1800,
            MaxLevel = 1824,
            MobName = "Fishman Captain",
            FarmPos = Vector3.new(-11004.37, 355.23, -8940.80),
            QuestNPCPos = Vector3.new(-10580.99, 331.80, -8764.03),
            QuestName = "DeepForestIsland3",
            QuestIndex = 2,
            RewardBeli = 15000
        },
        {
            MinLevel = 1825,
            MaxLevel = 1849,
            MobName = "Forest Pirate",
            FarmPos = Vector3.new(-13415.68, 338.38, -7796.47),
            QuestNPCPos = Vector3.new(-13233.32, 332.42, -7627.81),
            QuestName = "DeepForestIsland",
            QuestIndex = 1,
            RewardBeli = 13000
        },
        {
            MinLevel = 1850,
            MaxLevel = 1899,
            MobName = "Mythological Pirate",
            FarmPos = Vector3.new(-13572.07, 491.16, -6900.90),
            QuestNPCPos = Vector3.new(2495.12, 74.27, -6800.91),
            QuestName = "DeepForestIsland",
            QuestIndex = 2,
            RewardBeli = 13000
        },
        {
            MinLevel = 1900,
            MaxLevel = 1924,
            MobName = "Jungle Pirate",
            FarmPos = Vector3.new(-11981.76, 361.18, -10562.85),
            QuestNPCPos = Vector3.new(-12682.71, 390.90, -9902.72),
            QuestName = "DeepForestIsland2",
            QuestIndex = 1,
            RewardBeli = 13000
        },
        {
            MinLevel = 1925,
            MaxLevel = 1974,
            MobName = "Musketeer Pirate",
            FarmPos = Vector3.new(-13349.61, 421.47, -9797.77),
            QuestNPCPos = Vector3.new(-12682.71, 390.90, -9902.72),
            QuestName = "DeepForestIsland2",
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
            QuestName = "ChocQuest1",
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
            QuestName = "SubmergedQuest1",
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
    local pausedByDeath = false -- NEW: đánh dấu tạm pause do chết
    local lastLevel = 0
    local needsInitialQuest = false -- NEW: khi bật sẽ tự nhận quest 1 lần

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

    -- movement / lunge config
    local LUNGE_SPEED = 300 -- studs/s for lunge
    local STOP_DIST = 4
    local HEIGHT_OFFSET = 6

    -- LOCK config (yêu cầu của bạn)
    local LOCK_DISTANCE = 200   -- nếu <= 200 sẽ "gắn" ổn định
    local LOCK_HEIGHT = 25      -- vị trí cao hơn enemy 25 studs
    -- distanceLimit (dùng cho kiểm tra server-distance)
    local distanceLimit = 2500

    -- movement token for cancelling lunges
    local movementToken = 0
    local function stopMovement()
        movementToken = movementToken + 1
    end

    -- utility safe getters
    local function safeHRP()
        local char = player.Character
        if not char then return nil end
        return char:FindFirstChild("HumanoidRootPart")
    end
    local function safeHumanoid()
        local char = player.Character
        if not char then return nil end
        return char:FindFirstChildOfClass("Humanoid")
    end

    -- get nearest mob by name (from original)
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

    -- ===== unified lunge movement (replaces tweenTo) =====
    local function lungeTo(targetPos)
        local hrp = safeHRP()
        if not hrp or not hrp.Parent then return false end

        -- safety: if target is extremely far (possible invalid request), refuse
        local startPos = hrp.Position
        local delta = targetPos - startPos
        local dist = delta.Magnitude
        if dist < 0.5 then return true end
        if dist > 10000 then return false end

        local dir = delta.Unit
        local duration = math.max(0.01, dist / LUNGE_SPEED)
        local elapsed = 0
        local myToken = movementToken

        -- reset vertical velocity to avoid unexpected physics behaviour
        pcall(function() hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end)

        while elapsed < duration do
            -- cancel if another movement requested or script stopped
            if myToken ~= movementToken then
                return false
            end
            if not running then
                -- if script turned off while lunging -> cancel
                return false
            end

            local dt = RunService.Heartbeat:Wait()
            elapsed = elapsed + dt
            local alpha = math.clamp(elapsed / duration, 0, 1)
            local newPos = startPos + dir * (dist * alpha)
            -- set CFrame directly (preserve orientation)
            hrp.CFrame = CFrame.new(newPos)
        end

        -- final ensure position
        if myToken ~= movementToken then
            return false
        end
        hrp.CFrame = CFrame.new(targetPos)
        return true
    end
    -- ======================================================================

    -- acceptQuest (kept, nhưng dùng lungeTo) -> giờ trả về true/false
    local function acceptQuest(zone)
        if not zone then return false end
        -- go to NPC (a little above)
        local ok = lungeTo(zone.QuestNPCPos + Vector3.new(0, 3, 0))
        if not ok then return false end -- interrupted or couldn't reach, abort accept
        task.wait(1)

        local args = {
            [1] = "StartQuest",
            [2] = zone.QuestName,
            [3] = zone.QuestIndex
        }

        local success, err = pcall(function()
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
        end)
        if not success then
            return false
        end

        currentQuestKills = 0
        currentQuestBeli = player:WaitForChild("Data"):WaitForChild("Beli").Value

        if zone.RewardBeli then
            expectedRewardBeli = zone.RewardBeli
        end

        return true
    end

    -- *** Camera functions turned into NO-OPs to ensure we never change camera ***
    local function saveCameraState() end
    local function restoreCameraToPlayer() end
    local function restoreCameraState() end

    -- followMob: approach enemy; when within LOCK_DISTANCE => "gắn" ổn định vào vị trí trên enemy (LOCK_HEIGHT)
    local function followMob(mob)
        if not mob then return end
        local hrp = safeHRP()
        if not hrp then return end
        if not mob:FindFirstChild("HumanoidRootPart") then return end

        -- Make sure any previous lunges are canceled before starting follow
        stopMovement()

        -- Loop: approach until enemy dead or running false
        while mob and mob.Parent and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid")
            and mob:FindFirstChildOfClass("Humanoid").Health > 0 and running do

            local hrpEnemy = mob.HumanoidRootPart
            if not hrpEnemy then break end

            -- desired position: directly above enemy by LOCK_HEIGHT
            local desiredPos = Vector3.new(hrpEnemy.Position.X, hrpEnemy.Position.Y + LOCK_HEIGHT, hrpEnemy.Position.Z)
            local distToDesired = (hrp.Position - desiredPos).Magnitude
            local distToEnemy = (hrp.Position - hrpEnemy.Position).Magnitude

            if distToEnemy > LOCK_DISTANCE then
                -- too far: lunge to the desired overhead position
                local ok = lungeTo(desiredPos)
                if not ok then
                    -- lunge interrupted / cancelled — exit follow
                    return
                end
                -- once lunge arrives, loop will re-evaluate; if within lock threshold we'll lock next iteration
            else
                -- within LOCK_DISTANCE: lock position above enemy and hold until enemy dies or moves far away
                -- cancel any other movement tokens to ensure stable lock
                stopMovement()
                -- keep setting HRP to lock position each Heartbeat for stability
                while mob and mob.Parent and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid")
                    and mob:FindFirstChildOfClass("Humanoid").Health > 0 and running do

                    local ePos = mob.HumanoidRootPart.Position
                    local lockPos = Vector3.new(ePos.X, ePos.Y + LOCK_HEIGHT, ePos.Z)
                    pcall(function()
                        -- zero velocity and set exact lock CFrame
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.CFrame = CFrame.new(lockPos)
                    end)

                    -- if enemy suddenly far from us (unexpected), break lock to re-lunge
                    local curDistToEnemy = (hrp.Position - ePos).Magnitude
                    if curDistToEnemy > LOCK_DISTANCE + 10 then -- small hysteresis
                        break
                    end

                    RunService.Heartbeat:Wait()
                end
            end
        end
    end

    -- FARM CENTER (replaces part + billboard): Vector3 or nil
    local farmCenter = nil

    local function createFarmCenter(pos)
        -- set/replace farm center position (no Part / no Billboard)
        farmCenter = pos
    end

    local function destroyFarmCenter()
        farmCenter = nil
    end

    -- patrol logic (orbit around farmCenter) using lungeTo
    local patrolActive = false

    local function circlePoint(center, radius, angleRad)
        return Vector3.new(center.X + math.cos(angleRad) * radius, center.Y, center.Z + math.sin(angleRad) * radius)
    end

    local function orbitOnce(center, radiusPercent, zoneMobName)
        if not center then return false end
        if not running then return false end
        local radius = math.max(1, (distanceLimit) * radiusPercent)
        local startAng = math.random() * math.pi * 2
        local steps = 24
        local angStep = (2 * math.pi) / steps

        for s = 0, steps - 1 do
            if not running then return false end
            -- frequently check for enemies (use fixed center)
            if getNearestMob(zoneMobName) then return false end

            local ang = startAng + s * angStep
            local pt = circlePoint(center, radius, ang)

            -- Lunge to patrol point (do NOT modify farmCenter)
            local arrived = lungeTo(pt + Vector3.new(0, 5, 0))
            if not arrived then return false end

            -- tiny smooth pause using Heartbeat
            local pauseTime = 0.03
            local elapsed = 0
            while elapsed < pauseTime do
                if not running then return false end
                if getNearestMob(zoneMobName) then return false end
                elapsed = elapsed + RunService.Heartbeat:Wait()
            end
        end
        return true
    end

    local function startPatrol(zoneMobName)
        if not farmCenter then return end
        if patrolActive then return end
        patrolActive = true

        local radii = {0.10, 0.20, 0.30, 0.40, 0.50, 0.60, 0.70}
        local idx = 1
        local center = farmCenter -- fixed center

        while patrolActive and running do
            local radiusPercent = radii[idx]
            local ang = math.random() * math.pi * 2
            local startPt = circlePoint(center, math.max(1, (distanceLimit) * radiusPercent), ang)

            local ok = lungeTo(startPt + Vector3.new(0, 5, 0))
            if not ok then break end

            local completedOrbit = orbitOnce(center, radiusPercent, zoneMobName)
            if not completedOrbit then break end

            idx = idx + 1
            if idx > #radii then idx = 1 end

            if getNearestMob(zoneMobName) then break end
            -- small idle to avoid busy loop
            local idle = 0.02
            local e = 0
            while e < idle do
                if not running then break end
                e = e + RunService.Heartbeat:Wait()
            end
        end

        patrolActive = false
    end

    -- Auto attack loop (kept)
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

    -- Farm loop (dựa trên biến running) - sử dụng FarmPos as farmCenter
    spawn(function()
        local lastSeen = tick()
        while true do
            task.wait()
            if not running then
                lastSeen = tick()
                continue
            end

            local level = getLevel()
            local zone = getZoneForLevel(level)
            if not zone then continue end

            if level ~= lastLevel then
                lastLevel = level
                acceptQuest(zone)
            end

            -- ensure farmCenter is placed at zone.FarmPos (ngưỡng nhỏ tránh recreate liên tục)
            if not farmCenter or (farmCenter and (farmCenter - zone.FarmPos).Magnitude > 0.1) then
                createFarmCenter(zone.FarmPos)
            end

            -- NEW: Thử tự nhận quest đúng 1 lần khi mới bật
            if needsInitialQuest then
                -- gọi acceptQuest; nếu thành công thì clear flag, nếu thất bại sẽ thử lại sau
                local ok = acceptQuest(zone)
                if ok then
                    needsInitialQuest = false
                else
                    -- nếu không thành công (bị huỷ), đợi vòng lặp sau để thử lại
                    continue
                end
            end

            -- check for nearest mob of this zone
            local mob = getNearestMob(zone.MobName)
            if mob then
                -- cancel any ongoing patrol/movement and follow
                stopMovement()
                patrolActive = false
                followMob(mob)
                currentQuestKills = currentQuestKills + 1
                lastSeen = tick()
                -- after finishing an enemy, immediately continue the loop to search for next enemy
                continue
            else
                -- no mob found: only move to farm area center or start patrol if idle >= 0.5s
                if (tick() - lastSeen) >= 0.5 then
                    -- Move to farm center if too far (> distanceLimit) or just reposition if moderately far
                    local hrp = safeHRP()
                    if hrp and farmCenter then
                        local distToFarm = (hrp.Position - farmCenter).Magnitude
                        if distToFarm > distanceLimit then
                            -- too far: cancel patrols and return to farm center immediately via lunge
                            stopMovement()
                            patrolActive = false
                            lungeTo(farmCenter + Vector3.new(0, 5, 0))
                        elseif distToFarm > 50 then
                            -- minor reposition inside farm area
                            lungeTo(farmCenter + Vector3.new(0, 5, 0))
                        end
                    end

                    -- start patrol if not active
                    if not patrolActive and farmCenter then
                        task.spawn(function()
                            startPatrol(zone.MobName)
                        end)
                    end
                end
            end

            -- quest completion checks
            local newBeli = player:FindFirstChild("Data"):FindFirstChild("Beli").Value
            if newBeli - currentQuestBeli >= expectedRewardBeli then
                acceptQuest(zone)
            elseif currentQuestKills >= maxQuestKills then
                acceptQuest(zone)
            end
        end
    end)

    -- toggle handling & initial state
    local function setRunningFromButtonColor()
        local on = isButtonOn()

        if on and not running then
            running = true
            pausedByDeath = false -- nếu bật lại bằng tay thì clear pause

            _G.BringMobGate2 = true

            lastLevel = getLevel()
            pcall(function()
                player:SetAttribute("FastAttackEnemyMode", "Toggle")
                player:SetAttribute("FastAttackEnemyStyle", "Melee")
                player:SetAttribute("FastAttackEnemy", true)
            end)

            -- NOTE: camera save removed (no-op)
            -- create farmCenter at current zone if available
            local zone = getZoneForLevel(lastLevel)
            if zone then
                createFarmCenter(zone.FarmPos)
            end

            -- NEW: mark that we need to accept quest once at start
            needsInitialQuest = true

        elseif not on and running then
            -- User turned OFF manually: stop and reset
            running = false
            pausedByDeath = false -- user explicitly turned off => clear any death-pause

            _G.BringMobGate2 = false

            -- NOTE: camera restore removed (no-op)

            -- cleanup farmCenter/patrol
            stopMovement()
            patrolActive = false
            destroyFarmCenter()

            -- clear initial quest flag
            needsInitialQuest = false
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
        task.defer(function()
            setRunningFromButtonColor()
        end)
    end)

    -- Khởi tạo trạng thái theo màu hiện tại của button khi script bắt đầu
    setRunningFromButtonColor()

    -- Khi chết: chỉ tạm dừng (pause) — không reset UI về OFF
    local function onDeath()
        if running then
            pausedByDeath = true
            running = false
        end
        -- NOTE: do NOT alter camera
        stopMovement()
        patrolActive = false
        -- giữ farmCenter để khi respawn có thể tiếp tục nhanh
        -- destroyFarmCenter() -- *bị loại bỏ* để không reset vùng làm việc
    end

    -- Kết nối sự kiện chết cho mỗi character
    player.CharacterAdded:Connect(function(char)
        local h = char:WaitForChild("Humanoid", 5)
        if h then
            h.Died:Connect(function()
                onDeath()
            end)
        end

        -- NOTE: do NOT alter camera on respawn

        -- Sau respawn: nếu trước đó bị pause do chết và nút vẫn ON => tự resume
        task.spawn(function()
            -- đợi chút để nhân vật ổn định
            task.wait(0.5)
            if pausedByDeath then
                -- clear paused flag early to avoid race nếu người bấm tắt ngay lập tức
                pausedByDeath = false
                if isButtonOn() then
                    -- bật lại running và các thiết lập
                    running = true
                    _G.BringMobGate2 = true

                    lastLevel = getLevel()
                    pcall(function()
                        player:SetAttribute("FastAttackEnemyMode", "Toggle")
                        player:SetAttribute("FastAttackEnemyStyle", "Melee")
                        player:SetAttribute("FastAttackEnemy", true)
                    end)

                    -- ensure farmCenter exists for current zone
                    local zone = getZoneForLevel(lastLevel)
                    if zone then
                        if not farmCenter or (farmCenter and (farmCenter - zone.FarmPos).Magnitude > 0.1) then
                            createFarmCenter(zone.FarmPos)
                        end
                    end
                else
                    -- nếu người đã tắt nút trong thời gian chết thì không resume
                end
            end
        end)
    end)

    -- Connect if character already exists at script start
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character:FindFirstChild("Humanoid").Died:Connect(function() onDeath() end)
    end
end

--=== AUTO FARM ARENA =====================================================================================================--

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local player = Players.LocalPlayer

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
    local SUPPORT_BTN_NAME = "SupportStyleButton" -- tên nút support mới

    -- find controls (đệ quy)
    local autoBtn = uiMain:FindFirstChild(BUTTON_NAME, true)
    local distanceBox = uiMain:FindFirstChild(BOX_NAME, true)
    local supportBtn = uiMain:FindFirstChild(SUPPORT_BTN_NAME, true)

    if not autoBtn then
        warn("Không tìm thấy button:", BUTTON_NAME)
        return
    end
    if not distanceBox then
        warn("Không tìm thấy textbox:", BOX_NAME)
        return
    end
    if not supportBtn then
        warn("Không tìm thấy SupportStyleButton:", SUPPORT_BTN_NAME, "- tiếp tục nhưng không có UI toggle.")
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
    local distanceLimit = 2500
    local farmPoint = nil
    local farmBillboard = nil
    -- farmCenter will always mirror farmPoint.Position when farmPoint exists
    local farmCenter = nil

    -- Support style config
    local MELEE_COLOR = Color3.fromRGB(0, 200, 255)
    local FRUIT_COLOR = Color3.fromRGB(0, 255, 150)
    local SUPPORT_TEXT = { Melee = "Support: Melee", Fruit = "Support: Fruit" }

    local supportStyle = "Melee" -- mặc định
    local _prevSupportStyle = nil

    -- helper: normalize textbox initial value
    if not distanceBox.Text or distanceBox.Text == "" then
        distanceBox.Text = tostring(distanceLimit)
    else
        local n = tonumber(distanceBox.Text)
        if n and n > 0 then distanceLimit = math.floor(n) else distanceBox.Text = tostring(distanceLimit) end
    end

    -- ===== improved tween management (teleport Y + immediate cancel) =====
    local MOVE_SPEED_OVERRIDE = 300
    local currentTween = nil

    local function cancelCurrentTween()
        if currentTween then
            pcall(function() currentTween:Cancel() end)
            currentTween = nil
        end
    end

    -- Tween to position:
    -- - teleport HRP Y to target Y (keep X/Z) before tween
    -- - create tween moving X/Z to target while Y already set
    -- - support immediate cancel if running == false (or external cancel)
    local function tweenTo(pos)
        if not hrp or not hrp.Parent then return false end

        local dist = (hrp.Position - pos).Magnitude
        if dist > 10000 then return false end

        -- teleport Y only (maintain current X/Z). Reset velocity to avoid physics surprises.
        local cur = hrp.Position
        local targetY = pos.Y
        hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
        hrp.CFrame = CFrame.new(cur.X, targetY, cur.Z)

        -- Build target CFrame with correct Y
        local targetCFrame = CFrame.new(pos.X, targetY, pos.Z)

        -- Cancel any existing tween to avoid overlaps
        cancelCurrentTween()

        -- compute duration based on planar distance
        local planarDistance = (Vector3.new(cur.X, 0, cur.Z) - Vector3.new(pos.X, 0, pos.Z)).Magnitude
        local duration = math.max(0.01, planarDistance / MOVE_SPEED_OVERRIDE)

        local ok, tw = pcall(function()
            return TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
        end)
        if not ok or not tw then return false end

        currentTween = tw
        local completed = false
        local conn
        conn = tw.Completed:Connect(function()
            completed = true
            if conn then conn:Disconnect() end
            if currentTween == tw then
                currentTween = nil
            end
        end)

        tw:Play()

        -- responsive wait loop: allow immediate cancel when running becomes false
        while currentTween == tw do
            if not running then
                pcall(function() tw:Cancel() end)
                currentTween = nil
                if conn then conn:Disconnect() end
                return false
            end
            task.wait(0.01)
        end

        return completed
    end

    -- get nearest enemy that is WITHIN distanceLimit of centerPos,
    -- but prioritized by proximity to the player's hrp.
    local function getNearestEnemy(centerPos)
        if not centerPos then return nil end
        local folder = workspace:FindFirstChild("Enemies")
        if not folder then return nil end

        local candidates = {}
        for _, mob in ipairs(folder:GetChildren()) do
            if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") then
                local hp = mob:FindFirstChildOfClass("Humanoid")
                local part = mob:FindFirstChild("HumanoidRootPart")
                if hp and hp.Health > 0 and part then
                    local distToCenter = (centerPos - part.Position).Magnitude
                    if distToCenter <= (distanceLimit or 0) then
                        table.insert(candidates, {model = mob, part = part, distCenter = distToCenter})
                    end
                end
            end
        end

        if #candidates == 0 then
            return nil
        end

        if hrp and hrp.Parent then
            local best = nil
            local bestDist = nil
            for _, c in ipairs(candidates) do
                local dPlayer = (hrp.Position - c.part.Position).Magnitude
                if not bestDist or dPlayer < bestDist then
                    best = c.model
                    bestDist = dPlayer
                end
            end
            return best
        end

        local nearest = nil
        local nearestDist = nil
        for _, c in ipairs(candidates) do
            if not nearestDist or c.distCenter < nearestDist then
                nearest = c.model
                nearestDist = c.distCenter
            end
        end
        return nearest
    end

    -- highlight helper
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

    -- Beam hiện tại (chỉ 1 beam cùng lúc)
    local currentBeam = nil
    local currentBeamAttachments = {} -- {att0, att1}

    local function destroyCurrentBeam()
        if currentBeam then
            pcall(function() currentBeam:Destroy() end)
            currentBeam = nil
        end
        if currentBeamAttachments then
            for _, att in ipairs(currentBeamAttachments) do
                if att then
                    pcall(function() att:Destroy() end)
                end
            end
            currentBeamAttachments = {}
        end
    end

    local function createBeamBetweenParts(partA, partB)
        if not (partA and partB and partA.Parent and partB.Parent) then return nil end
        destroyCurrentBeam()
        local att0 = Instance.new("Attachment")
        att0.Name = "FastTargetBeam_Att0"
        att0.Parent = partA
        att0.Position = Vector3.new(0, 0.7, 0)

        local att1 = Instance.new("Attachment")
        att1.Name = "FastTargetBeam_Att1"
        att1.Parent = partB
        att1.Position = Vector3.new(0, 1.5, 0)

        local Beam = Instance.new("Beam")
        Beam.Name = "FastTargetBeam"
        Beam.FaceCamera = true
        Beam.Color = ColorSequence.new(Color3.fromRGB(140, 0, 255), Color3.fromRGB(140, 0, 255))
        Beam.Attachment0 = att0
        Beam.Attachment1 = att1
        Beam.Texture = "rbxassetid://78520400570887"
        Beam.TextureLength = 100
        Beam.LightEmission = 1
        Beam.Width0 = 2.0
        Beam.Width1 = 1.6
        Beam.Transparency = NumberSequence.new(0)
        Beam.Parent = workspace

        currentBeam = Beam
        currentBeamAttachments = {att0, att1}

        return Beam
    end

    -- cleanup function dùng chung để stop mọi thứ ngay
    local function cleanupOnStop()
        cancelCurrentTween()
        destroyCurrentBeam()
        if farmPoint and farmPoint.Parent then
            farmPoint:Destroy()
        end
        farmPoint = nil
        farmBillboard = nil
        farmCenter = nil
        -- camera handling removed -> no restore
    end

    -- follow enemy (camera handling removed)
    local function followEnemy(enemy)
        if not enemy then return end
        local hrpEnemy = enemy:FindFirstChild("HumanoidRootPart")
        local humanoidEnemy = enemy:FindFirstChildOfClass("Humanoid")
        if not hrpEnemy or not humanoidEnemy then return end

        -- stop any patrol/tween immediately
        cancelCurrentTween()

        updateHighlight(enemy)

        local function ensureBeamSource()
            if farmPoint and farmPoint.Parent then
                return farmPoint
            end
            return hrp
        end

        local beamSource = ensureBeamSource()
        if beamSource and beamSource.Parent and hrpEnemy and hrpEnemy.Parent then
            createBeamBetweenParts(beamSource, hrpEnemy)
        end

        -- approach
        local dist = (hrp.Position - hrpEnemy.Position).Magnitude
        if dist > 200 then
            -- approach: tweenTo returns true if completed (not cancelled)
            local arrived = tweenTo(hrpEnemy.Position + Vector3.new(0, 5, 0))
            if not arrived or not running then
                -- cancelled or stopped — cleanup and return
                destroyCurrentBeam()
                return
            end
        end

        -- now do in-place follow (player moves around the enemy)
        while humanoidEnemy.Health > 0 and running and hrpEnemy.Parent do
            updateHighlight(enemy)
            local offset = (supportStyle == "Melee") and 25 or 10
            local targetPos = Vector3.new(hrpEnemy.Position.X, hrpEnemy.Position.Y + offset, hrpEnemy.Position.Z)

            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(targetPos), 0.25)

            if not running or not humanoidEnemy.Parent or humanoidEnemy.Health <= 0 or not hrpEnemy.Parent then
                break
            end

            RunService.RenderStepped:Wait()
        end

        destroyCurrentBeam()
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
        farmCenter = farmPoint.Position -- keep fixed; do not update elsewhere
    end

    local function destroyFarmPoint()
        destroyCurrentBeam()
        if farmPoint and farmPoint.Parent then
            farmPoint:Destroy()
        end
        farmPoint = nil
        farmBillboard = nil
        farmCenter = nil
    end

    -- ===== Patrol logic (dynamic radii orbit) =====
    local patrolActive = false

    -- generate circular waypoint at angle and radius (around a fixed center)
    local function circlePoint(center, radius, angleRad)
        return Vector3.new(center.X + math.cos(angleRad) * radius, center.Y, center.Z + math.sin(angleRad) * radius)
    end

    -- orbit one full revolution at given radius percent (center is fixed farmPoint.Position)
    local function orbitOnce(center, radiusPercent)
        if not farmPoint or not farmPoint.Parent then return false end
        if not running then return false end
        local radius = math.max(1, (distanceLimit or 2500) * radiusPercent)
        local startAng = math.random() * math.pi * 2
        local steps = 24
        local angStep = (2 * math.pi) / steps

        for s = 0, steps - 1 do
            if not running then return false end
            -- frequently check for enemies (use fixed center)
            if getNearestEnemy(center) then return false end

            local ang = startAng + s * angStep
            local pt = circlePoint(center, radius, ang)

            -- Tween to patrol point (do NOT modify farmPoint)
            local arrived = tweenTo(pt + Vector3.new(0, 5, 0))
            if not arrived then return false end

            -- tiny pause and re-check
            local pause = tick() + 0.03
            while tick() < pause do
                if not running then return false end
                if getNearestEnemy(center) then return false end
                task.wait(0.01)
            end
        end
        return true
    end

    local function startPatrol()
        if not farmPoint or not farmPoint.Parent then return end
        if patrolActive then return end
        patrolActive = true

        local radii = {0.10, 0.20, 0.30, 0.40, 0.50, 0.60, 0.70}
        local idx = 1
        local center = farmPoint.Position -- fixed center

        while patrolActive and running do
            local radiusPercent = radii[idx]
            -- random start angle and startPt around fixed center
            local ang = math.random() * math.pi * 2
            local startPt = circlePoint(center, math.max(1, (distanceLimit or 2500) * radiusPercent), ang)

            -- Tween to start point
            local ok = tweenTo(startPt + Vector3.new(0, 5, 0))
            if not ok then break end

            -- do orbit at this radius (center fixed)
            local completedOrbit = orbitOnce(center, radiusPercent)
            if not completedOrbit then break end

            -- next radius
            idx = idx + 1
            if idx > #radii then idx = 1 end

            if getNearestEnemy(center) then break end
            task.wait(0.02)
        end

        patrolActive = false
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

    -- onCharacterDied
    local function onCharacterDied()
        if running then
            running = false
            pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)
        end
        cleanupOnStop()
    end

    player.CharacterAdded:Connect(function(newChar)
        character = newChar
        hrp = newChar:WaitForChild("HumanoidRootPart")
        local humanoidNew = newChar:WaitForChild("Humanoid")

        running = false

        pcall(function()
            ToggleUI.Set(BUTTON_NAME, false)
        end)

        cleanupOnStop()

        humanoidNew.Died:Connect(onCharacterDied)
    end)

    -- When user clicks the UI toggle
    if autoBtn then
        local function onToggleActivated()
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

    local function setRunningFromButtonColor()
        if not autoBtn then return end

        local bg = autoBtn.BackgroundColor3
        local isOn = (bg and bg.G and bg.G > bg.R and bg.G > bg.B and bg.G > 0.5)

        if isOn and not running then
            running = true

            _G.BringMobGate2 = true

            pcall(function()
                player:SetAttribute("FastAttackEnemyMode", "Toggle")
                player:SetAttribute("FastAttackEnemyStyle", supportStyle)
                player:SetAttribute("FastAttackEnemy", true)
            end)

            if hrp then
                createFarmPoint(hrp.Position) -- farmPoint created once and stays put
            end

        elseif not isOn and running then
            running = false

            _G.BringMobGate2 = false

            -- cleanup
            cleanupOnStop()
        end
    end

    autoBtn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        task.delay(0.05, setRunningFromButtonColor)
    end)

    -- initial sync
    setRunningFromButtonColor()

    -- update billboard color and farmCenter each frame (farmCenter stays equal farmPoint.Position)
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

                if farmPoint and farmPoint.Parent then
                    farmCenter = farmPoint.Position -- preserve fixed center
                end
            end
        end)
    end

    if humanoid then
        humanoid.Died:Connect(onCharacterDied)
    end

    -- auto farm loop: use farmCenter when available
    task.spawn(function()
        local lastSeen = tick()
        while true do
            task.wait()
            if not running or not hrp then
                lastSeen = tick()
                continue
            end

            local center = (farmPoint and farmPoint.Parent) and farmPoint.Position or hrp.Position
            local target = getNearestEnemy(center)
            if target then
                -- Found an enemy: cancel any tween/patrol and follow immediately
                cancelCurrentTween()
                lastSeen = tick()
                patrolActive = false
                followEnemy(target)
            else
                -- no target
                if (tick() - lastSeen) >= 0.5 then
                    -- start patrol if not already
                    if farmPoint == nil then
                        createFarmPoint(hrp.Position)
                    end
                    if not patrolActive then
                        task.spawn(function()
                            startPatrol()
                        end)
                    end
                end
            end

            if target then
                lastSeen = tick()
            end
        end
    end)

    -- auto attack loop (unchanged)
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

    -- ===== SupportStyleButton handling & visuals =====
    local function getTextHolder(btn)
        if not btn then return nil end
        if btn:IsA("TextButton") or btn:IsA("TextLabel") then
            return btn
        end
        local t = btn:FindFirstChildOfClass("TextLabel") or btn:FindFirstChildOfClass("TextButton")
        return t
    end

    local function getUIStroke(btn)
        if not btn then return nil end
        return btn:FindFirstChildOfClass("UIStroke") or btn:FindFirstChild("UIStroke")
    end

    local function tweenProperty(instance, props, time)
        if not instance then return end
        local ok, t = pcall(function()
            local tw = TweenService:Create(instance, TweenInfo.new(time or 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
            tw:Play()
            return tw
        end)
        if ok then return t end
        return nil
    end

    local function applySupportVisuals(style)
        if not supportBtn then return end
        local targetColor = (style == "Melee") and MELEE_COLOR or FRUIT_COLOR
        pcall(function() tweenProperty(supportBtn, {BackgroundColor3 = targetColor}, 0.5) end)
        local stroke = getUIStroke(supportBtn)
        if stroke then pcall(function() tweenProperty(stroke, {Color = targetColor}, 0.5) end) end

        local textObj = getTextHolder(supportBtn)
        if textObj then
            local t1 = tweenProperty(textObj, {TextTransparency = 1}, 0.5)
            if t1 then t1.Completed:Wait() end
            local newText = SUPPORT_TEXT[style] or ("Support: " .. style)
            pcall(function() textObj.Text = newText end)
            pcall(function()
                local t2 = tweenProperty(textObj, {TextTransparency = 0}, 0.5)
                if t2 then t2.Completed:Wait() end
            end)
        end
    end

    local function setSupportStyle(style)
        if not style then return end
        style = (style == "Fruit") and "Fruit" or "Melee"
        if _prevSupportStyle == style then
            applySupportVisuals(style)
            return
        end

        supportStyle = style
        applySupportVisuals(style)
        _prevSupportStyle = style

        pcall(function()
            player:SetAttribute("FastAttackEnemyStyle", style)
        end)
    end

    if supportBtn then
        local textObj = getTextHolder(supportBtn)
        if textObj then
            pcall(function() textObj.TextTransparency = 0 end)
            pcall(function() textObj.Text = SUPPORT_TEXT[supportStyle] end)
        end
        pcall(function() supportBtn.BackgroundColor3 = MELEE_COLOR end)
        local stroke = getUIStroke(supportBtn)
        if stroke then pcall(function() stroke.Color = MELEE_COLOR end) end

        local function onSupportActivated()
            local nextStyle = (supportStyle == "Melee") and "Fruit" or "Melee"
            setSupportStyle(nextStyle)
        end
        if supportBtn.Activated then
            supportBtn.Activated:Connect(onSupportActivated)
        else
            supportBtn.MouseButton1Click:Connect(onSupportActivated)
        end
    end

    pcall(function() player:SetAttribute("FastAttackEnemyStyle", supportStyle) end)
end

--=== Auto Farm Cake Prince =====================================================================================================--

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local player = Players.LocalPlayer

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
    local BUTTON_NAME = "AutoFarmCakePrinceButton"
    local BOX_NAME    = "AutoFarmArenaBox" -- giữ textbox cũ nếu muốn chỉnh distance thủ công
    local SUPPORT_BTN_NAME = "SupportStyleButton" -- optional

    -- find controls (đệ quy)
    local autoBtn = uiMain:FindFirstChild(BUTTON_NAME, true)
    local distanceBox = uiMain:FindFirstChild(BOX_NAME, true)
    local supportBtn = uiMain:FindFirstChild(SUPPORT_BTN_NAME, true)

    if not autoBtn then
        warn("Không tìm thấy button:", BUTTON_NAME)
        return
    end
    if not distanceBox then
        warn("Không tìm thấy textbox:", BOX_NAME, "- dùng giá trị mặc định.")
    end

    -- ensure ToggleUI state initial
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)
    pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)

    -- lưu màu gốc của button + stroke để tween an toàn
    local function findUIStroke(inst)
        for _, v in ipairs(inst:GetDescendants()) do
            if v:IsA("UIStroke") then return v end
        end
        return nil
    end
    local stroke = findUIStroke(autoBtn)
    local origBg = autoBtn.BackgroundColor3 or Color3.fromRGB(255, 50, 50)
    local origStrokeColor = (stroke and stroke.Color) or Color3.fromRGB(255, 0, 0)
    local warnColor = Color3.fromRGB(255, 255, 0)
    local animating = false

    -- game state
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")
    local running = false
    local ready = false -- chỉ true khi đã tween tới farm pos và ổn định

    -- farm vars (Cake Prince)
    local distanceLimit = 1000
    local farmPoint = nil
    local farmBillboard = nil
    local farmCenter = nil

    -- FARM POS DEFAULTS
    local FARM_POS_DEFAULT = Vector3.new(-2144.48, 71.08, -12327.09)
    local FARM_POS_MIRROR   = Vector3.new(-2036.09, 4670.61, -14804.91)
    local currentFarmPos = FARM_POS_DEFAULT

    -- allowed PlaceIds
    local ALLOWED_PLACEIDS = {
        [7449423635] = true,
        [100117331123089] = true
    }

    -- remote name / safe invoke (2 args form)
    local function safeInvokeRemote(a, b)
        local ok, err = pcall(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if not remotes then error("Remotes folder missing") end
            local comm = remotes:FindFirstChild("CommF_")
            if not comm then error("CommF_ missing") end
            comm:InvokeServer(a, b)
        end)
        if not ok then
            warn("[AutoFarmCakePrince] Remote call failed:", err)
        end
    end

    -- Support style config (kept for compatibility)
    local MELEE_COLOR = Color3.fromRGB(0, 200, 255)
    local FRUIT_COLOR = Color3.fromRGB(0, 255, 150)
    local SUPPORT_TEXT = { Melee = "Support: Melee", Fruit = "Support: Fruit" }

    local supportStyle = "Melee" -- default
    local _prevSupportStyle = nil

    -- ===== tween management (teleport Y + immediate cancel) =====
    local MOVE_SPEED_OVERRIDE = 300
    local currentTween = nil

    local function cancelCurrentTween()
        if currentTween then
            pcall(function() currentTween:Cancel() end)
            currentTween = nil
        end
    end

    local function tweenTo(pos)
        if not hrp or not hrp.Parent then return false end

        -- distance sanity
        local dist = (hrp.Position - pos).Magnitude
        if dist > 10000 then return false end

        -- teleport Y only (so tween is smoother vertically)
        local cur = hrp.Position
        local targetY = pos.Y
        hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
        hrp.CFrame = CFrame.new(cur.X, targetY, cur.Z)

        local targetCFrame = CFrame.new(pos.X, targetY, pos.Z)

        cancelCurrentTween()

        local planarDistance = (Vector3.new(cur.X, 0, cur.Z) - Vector3.new(pos.X, 0, pos.Z)).Magnitude
        local duration = math.max(0.01, planarDistance / MOVE_SPEED_OVERRIDE)

        local ok, tw = pcall(function()
            return TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
        end)
        if not ok or not tw then return false end

        currentTween = tw
        local completed = false
        local conn
        conn = tw.Completed:Connect(function()
            completed = true
            if conn then conn:Disconnect() end
            if currentTween == tw then currentTween = nil end
        end)

        tw:Play()

        while currentTween == tw do
            -- only cancel if user toggled off
            if not running then
                pcall(function() tw:Cancel() end)
                currentTween = nil
                if conn then conn:Disconnect() end
                return false
            end
            task.wait(0.01)
        end

        return completed
    end

    -- simple enemy search (kept in case map has Enemies)
    local function getNearestEnemy(centerPos)
        if not centerPos then return nil end
        local folder = workspace:FindFirstChild("Enemies")
        if not folder then return nil end

        local candidates = {}
        for _, mob in ipairs(folder:GetChildren()) do
            if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") then
                local hp = mob:FindFirstChildOfClass("Humanoid")
                local part = mob:FindFirstChild("HumanoidRootPart")
                if hp and hp.Health > 0 and part then
                    local distToCenter = (centerPos - part.Position).Magnitude
                    if distToCenter <= (distanceLimit or 0) then
                        table.insert(candidates, {model = mob, part = part, distCenter = distToCenter})
                    end
                end
            end
        end

        if #candidates == 0 then return nil end

        if hrp and hrp.Parent then
            local best, bestDist
            for _, c in ipairs(candidates) do
                local dPlayer = (hrp.Position - c.part.Position).Magnitude
                if not bestDist or dPlayer < bestDist then
                    best = c.model
                    bestDist = dPlayer
                end
            end
            return best
        end

        local nearest, nearestDist
        for _, c in ipairs(candidates) do
            if not nearestDist or c.distCenter < nearestDist then
                nearest = c.model
                nearestDist = c.distCenter
            end
        end
        return nearest
    end

    -- highlight + beam helpers (kept)
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

    local currentBeam = nil
    local currentBeamAttachments = {}

    local function destroyCurrentBeam()
        if currentBeam then pcall(function() currentBeam:Destroy() end) end
        currentBeam = nil
        if currentBeamAttachments then
            for _, a in ipairs(currentBeamAttachments) do pcall(function() a:Destroy() end) end
        end
        currentBeamAttachments = {}
    end

    local function createBeamBetweenParts(a,b)
        if not (a and b and a.Parent and b.Parent) then return nil end
        destroyCurrentBeam()
        local att0 = Instance.new("Attachment"); att0.Parent = a; att0.Position = Vector3.new(0,0.7,0)
        local att1 = Instance.new("Attachment"); att1.Parent = b; att1.Position = Vector3.new(0,1.5,0)
        local Beam = Instance.new("Beam")
        Beam.Name = "FastTargetBeam"
        Beam.FaceCamera = true
        Beam.Color = ColorSequence.new(Color3.fromRGB(140,0,255), Color3.fromRGB(140,0,255))
        Beam.Attachment0 = att0
        Beam.Attachment1 = att1
        Beam.Texture = "rbxassetid://78520400570887"
        Beam.TextureLength = 100
        Beam.LightEmission = 1
        Beam.Width0 = 2.0
        Beam.Width1 = 1.6
        Beam.Transparency = NumberSequence.new(0)
        Beam.Parent = workspace
        currentBeam = Beam
        currentBeamAttachments = {att0, att1}
        return Beam
    end

    local function cleanupOnStop()
        cancelCurrentTween()
        destroyCurrentBeam()
        if farmPoint and farmPoint.Parent then farmPoint:Destroy() end
        farmPoint = nil; farmBillboard = nil; farmCenter = nil
        ready = false
    end

    -- follow enemy (keep approach behaviour)
    local function followEnemy(enemy)
        if not enemy then return end
        local hrpEnemy = enemy:FindFirstChild("HumanoidRootPart")
        local humanoidEnemy = enemy:FindFirstChildOfClass("Humanoid")
        if not hrpEnemy or not humanoidEnemy then return end

        cancelCurrentTween()
        updateHighlight(enemy)

        local function beamSource() return (farmPoint and farmPoint.Parent) and farmPoint or hrp end
        local bs = beamSource()
        if bs and bs.Parent and hrpEnemy and hrpEnemy.Parent then createBeamBetweenParts(bs, hrpEnemy) end

        local dist = (hrp.Position - hrpEnemy.Position).Magnitude
        if dist > 200 then
            local arrived = tweenTo(hrpEnemy.Position + Vector3.new(0,5,0))
            if not arrived or not running then destroyCurrentBeam(); return end
        end

        while humanoidEnemy.Health > 0 and running and hrpEnemy.Parent do
            updateHighlight(enemy)
            local offset = (supportStyle == "Melee") and 25 or 10
            local targetPos = Vector3.new(hrpEnemy.Position.X, hrpEnemy.Position.Y + offset, hrpEnemy.Position.Z)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(targetPos), 0.25)
            if not running or not humanoidEnemy.Parent or humanoidEnemy.Health <= 0 or not hrpEnemy.Parent then break end
            RunService.RenderStepped:Wait()
        end

        destroyCurrentBeam()
    end

    -- create farmPoint at a FIXED position (currentFarmPos)
    local function createFarmPointFixed(pos)
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
        bb.Size = UDim2.new(0,120,0,40)
        bb.StudsOffset = Vector3.new(0,2,0)
        bb.AlwaysOnTop = true
        bb.Parent = farmPoint

        local label = Instance.new("TextLabel", bb)
        label.Name = "DistanceLabel"
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.TextScaled = true
        label.Font = Enum.Font.SourceSansBold
        label.Text = "0/" .. tostring(distanceLimit) -- đảm bảo hiển thị 0/1000 ban đầu
        label.TextColor3 = Color3.fromRGB(0,255,0)
        label.TextStrokeTransparency = 0.6

        farmBillboard = { gui = bb, label = label }
        farmCenter = farmPoint.Position
    end

    local function destroyFarmPoint()
        destroyCurrentBeam()
        if farmPoint and farmPoint.Parent then farmPoint:Destroy() end
        farmPoint = nil; farmBillboard = nil; farmCenter = nil
    end

    -- Patrol helpers (unchanged)
    local patrolActive = false
    local function circlePoint(center, radius, angleRad)
        return Vector3.new(center.X + math.cos(angleRad) * radius, center.Y, center.Z + math.sin(angleRad) * radius)
    end

    local function orbitOnce(center, radiusPercent)
        if not farmPoint or not farmPoint.Parent then return false end
        if not running then return false end
        local radius = math.max(1, (distanceLimit or 1000) * radiusPercent)
        local startAng = math.random() * math.pi * 2
        local steps = 24
        local angStep = (2 * math.pi) / steps

        for s = 0, steps - 1 do
            if not running then return false end
            if getNearestEnemy(center) then return false end
            local ang = startAng + s * angStep
            local pt = circlePoint(center, radius, ang)
            local arrived = tweenTo(pt + Vector3.new(0,5,0))
            if not arrived then return false end
            local pause = tick() + 0.03
            while tick() < pause do
                if not running then return false end
                if getNearestEnemy(center) then return false end
                task.wait(0.01)
            end
        end
        return true
    end

    local function startPatrol()
        if not farmPoint or not farmPoint.Parent then return end
        if patrolActive then return end
        patrolActive = true
        local radii = {0.10,0.20,0.30,0.40,0.50,0.60,0.70}
        local idx = 1
        local center = farmPoint.Position
        while patrolActive and running do
            local radiusPercent = radii[idx]
            local ang = math.random() * math.pi * 2
            local startPt = circlePoint(center, math.max(1, (distanceLimit or 1000) * radiusPercent), ang)
            local ok = tweenTo(startPt + Vector3.new(0,5,0))
            if not ok then break end
            local completed = orbitOnce(center, radiusPercent)
            if not completed then break end
            idx = idx + 1
            if idx > #radii then idx = 1 end
            if getNearestEnemy(center) then break end
            task.wait(0.02)
        end
        patrolActive = false
    end

    -- character death handling
    local function onCharacterDied()
        if running then
            running = false
            pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)
        end
        cleanupOnStop()
    end

    player.CharacterAdded:Connect(function(newChar)
        character = newChar
        hrp = newChar:WaitForChild("HumanoidRootPart")
        local humanoidNew = newChar:WaitForChild("Humanoid")
        running = false
        ready = false
        pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)
        cleanupOnStop()
        humanoidNew.Died:Connect(onCharacterDied)
    end)

    -- UI helpers
    local function inferToggleOn(btn)
        local bg
        pcall(function() bg = btn.BackgroundColor3 end)
        if not bg then return false end
        return bg.G and bg.G > bg.R and bg.G > bg.B and bg.G > 0.5
    end

    local function getUIStroke(btn)
        if not btn then return nil end
        return btn:FindFirstChildOfClass("UIStroke") or btn:FindFirstChild("UIStroke")
    end

    local function tweenProperty(instance, props, time)
        if not instance then return end
        local ok, t = pcall(function()
            local tw = TweenService:Create(instance, TweenInfo.new(time or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
            tw:Play()
            return tw
        end)
        if ok then return t end
        return nil
    end

    -- Warning animation when place not allowed (improved, guarded)
    local function playPlaceNotAllowedAnim()
        if animating then return end
        animating = true
        -- create tweens for both bg and stroke, play simultaneously
        local dur = 0.25
        local tweens = {}
        local ok1, tw1 = pcall(function()
            return TweenService:Create(autoBtn, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = warnColor })
        end)
        if ok1 and tw1 then table.insert(tweens, tw1) end

        if stroke then
            local ok2, tw2 = pcall(function()
                return TweenService:Create(stroke, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Color = warnColor })
            end)
            if ok2 and tw2 then table.insert(tweens, tw2) end
        end

        for _, tw in ipairs(tweens) do pcall(function() tw:Play() end) end
        task.wait(dur + 0.02)

        -- hold yellow briefly
        task.wait(1)

        -- tween back to original colors
        local tweens2 = {}
        local ok3, tw3 = pcall(function()
            return TweenService:Create(autoBtn, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = origBg })
        end)
        if ok3 and tw3 then table.insert(tweens2, tw3) end

        if stroke then
            local ok4, tw4 = pcall(function()
                return TweenService:Create(stroke, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Color = origStrokeColor })
            end)
            if ok4 and tw4 then table.insert(tweens2, tw4) end
        end

        for _, tw in ipairs(tweens2) do pcall(function() tw:Play() end) end
        task.wait(dur + 0.02)
        animating = false
    end

    -- Toggle behavior: intercept when place not allowed
    local function onToggleActivated()
        local bg = autoBtn.BackgroundColor3
        local currentlyOn = inferToggleOn(autoBtn)
        local target = not currentlyOn

        if target then
            local pid = game.PlaceId
            if not ALLOWED_PLACEIDS[pid] then
                task.spawn(playPlaceNotAllowedAnim)
                return
            end
        end

        pcall(function() ToggleUI.Set(BUTTON_NAME, target) end)
    end

    if autoBtn.Activated then
        autoBtn.Activated:Connect(onToggleActivated)
    else
        autoBtn.MouseButton1Click:Connect(onToggleActivated)
    end

    -- CORE: when enabling, do a single tween to farm pos (same method as followEnemy uses),
    -- wait for completion; only if tween succeeds set ready=true and begin auto logic.
    local function goToFarmAndSetReady_once()
        if not running then return false end
        cancelCurrentTween()
        local arrived = tweenTo(currentFarmPos + Vector3.new(0,5,0))
        if arrived and running then
            ready = true
            return true
        end

        -- if tween failed, stop (do not teleport). Keep behavior deterministic.
        ready = false
        running = false
        pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)
        cleanupOnStop()
        return false
    end

    -- respond when ToggleUI changes the visual color (same mechanism as before)
    local function setRunningFromButtonColor()
        if not autoBtn then return end

        local bg = autoBtn.BackgroundColor3
        local isOn = (bg and bg.G and bg.G > bg.R and bg.G > bg.B and bg.G > 0.5)

        if isOn and not running then
            if not ALLOWED_PLACEIDS[game.PlaceId] then
                task.spawn(playPlaceNotAllowedAnim)
                pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)
                return
            end

            running = true
            ready = false
            _G.BringMobGate2 = true

            pcall(function()
                player:SetAttribute("FastAttackEnemyMode", "Toggle")
                player:SetAttribute("FastAttackEnemyStyle", supportStyle)
                player:SetAttribute("FastAttackEnemy", true)
            end)

            -- create farmPoint at currentFarmPos (fixed) and ensure billboard shows 0/1000
            createFarmPointFixed(currentFarmPos)

            -- single tween to farm pos, then set ready if succeeded
            task.spawn(function()
                goToFarmAndSetReady_once()
            end)

        elseif not isOn and running then
            running = false
            ready = false
            _G.BringMobGate2 = false
            cleanupOnStop()
        end
    end

    autoBtn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        task.delay(0.05, setRunningFromButtonColor)
    end)

    -- initial sync
    setRunningFromButtonColor()

    -- keep farmBillboard updated each frame
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
                    -- cancel previous tween safely
                    if colorTween then
                        pcall(function() colorTween:Cancel() end)
                        colorTween = nil
                    end
                    local ok, tw = pcall(function()
                        return TweenService:Create(farmBillboard.label, TweenInfo.new(0.12, Enum.EasingStyle.Linear), {TextColor3 = targetColor})
                    end)
                    if ok and tw then
                        colorTween = tw
                        colorTween:Play()
                        -- clear reference after duration so next tween isn't blocked
                        task.delay(0.14, function()
                            if colorTween == tw then colorTween = nil end
                        end)
                    else
                        -- fallback: set immediately
                        pcall(function() farmBillboard.label.TextColor3 = targetColor end)
                    end
                end

                if farmPoint and farmPoint.Parent then farmCenter = farmPoint.Position end
            end
        end)
    end

    if humanoid then humanoid.Died:Connect(onCharacterDied) end

    -- MirrorDimension watcher with 2s stabilization delay
    do
        local lastMirrorState = nil
        local pendingChangeId = 0
    
        task.spawn(function()
            while true do
                task.wait(0.25)
    
                local ok, found = pcall(function()
                    local map = workspace:FindFirstChild("Map")
                    if not map then return false end
                    local md = map:FindFirstChild("MirrorDimension")
                    return (md and md:IsA("Model")) and true or false
                end)
    
                local mirrorPresent = (ok and found) and true or false
                local newState = mirrorPresent and "MIRROR" or "DEFAULT"
    
                -- nếu trạng thái thay đổi thì bắt đầu debounce 2s để "xác nhận"
                if newState ~= lastMirrorState then
                    lastMirrorState = newState
                    pendingChangeId = pendingChangeId + 1
                    local myId = pendingChangeId
    
                    task.delay(2, function()
                        -- nếu trong 2s có thay đổi khác thì hủy
                        if pendingChangeId ~= myId then return end
    
                        -- xác nhận: chọn vị trí tương ứng
                        local newPos = (newState == "MIRROR") and FARM_POS_MIRROR or FARM_POS_DEFAULT
    
                        -- chỉ hành động khi vị trí thực sự thay đổi
                        if currentFarmPos ~= newPos then
                            currentFarmPos = newPos
                            ready = false
    
                            -- cập nhật farmPoint (nếu đang có)
                            if farmPoint and farmPoint.Parent then
                                pcall(function()
                                    farmPoint.Position = currentFarmPos
                                    farmCenter = farmPoint.Position
                                end)
                            end
    
                            -- nếu đang chạy thì cố gắng tween đến vị trí mới
                            if running then
                                task.spawn(function()
                                    pcall(goToFarmAndSetReady_once)
                                end)
                            end
                        end
                    end)
                end
            end
        end)
    end

    -- auto farm loop: includes enemy follow behavior and patrol; also ensures return to farmPos if leaving
    task.spawn(function()
        local lastSeen = tick()
        local lastSpawn = 0
        while true do
            task.wait()
            if not running or not hrp then
                lastSeen = tick()
                continue
            end

            -- wait until we've arrived and stabilized at farm pos
            if not ready then
                task.wait(0.15)
                continue
            end

            -- if the player is farther than distanceLimit from currentFarmPos -> attempt a tween back (no teleport fallback)
            local distToFarm = (hrp.Position - currentFarmPos).Magnitude
            if distToFarm > distanceLimit then
                cancelCurrentTween()
                patrolActive = false
                local ok = tweenTo(currentFarmPos + Vector3.new(0,5,0))
                if not ok then
                    -- leave running true but mark not ready — will require re-tween to resume spawning
                    ready = false
                end
                task.wait(0.2)
            end

            local center = (farmPoint and farmPoint.Parent) and farmPoint.Position or currentFarmPos
            local target = getNearestEnemy(center)
            if target then
                cancelCurrentTween()
                lastSeen = tick()
                patrolActive = false
                followEnemy(target)
            else
                if (tick() - lastSeen) >= 0.5 then
                    if farmPoint == nil then
                        createFarmPointFixed(currentFarmPos)
                    end
                    if not patrolActive then
                        task.spawn(function() startPatrol() end)
                    end
                end
            end

            -- remote call every 3s while running and ready
            if running and ready and (tick() - lastSpawn) >= 3 then
                lastSpawn = tick()
                task.spawn(function()
                    safeInvokeRemote("CakePrinceSpawner", true)
                end)
            end

            if target then lastSeen = tick() end
        end
    end)

    -- keep auto-attack loop (unchanged)
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

    -- SupportStyle visuals (kept unchanged except using existing helpers)
    local function getTextHolder(btn)
        if not btn then return nil end
        if btn:IsA("TextButton") or btn:IsA("TextLabel") then return btn end
        return btn:FindFirstChildOfClass("TextLabel") or btn:FindFirstChildOfClass("TextButton")
    end
    local function applySupportVisuals(style)
        if not supportBtn then return end
        local targetColor = (style == "Melee") and MELEE_COLOR or FRUIT_COLOR
        pcall(function() tweenProperty(supportBtn, {BackgroundColor3 = targetColor}, 0.18) end)
        local stroke2 = getUIStroke(supportBtn)
        if stroke2 then pcall(function() tweenProperty(stroke2, {Color = targetColor}, 0.18) end) end
        local textObj = getTextHolder(supportBtn)
        if textObj then
            local t1 = tweenProperty(textObj, {TextTransparency = 1}, 0.12)
            if t1 then t1.Completed:Wait() end
            local newText = SUPPORT_TEXT[style] or ("Support: " .. style)
            pcall(function() textObj.Text = newText end)
            pcall(function()
                local t2 = tweenProperty(textObj, {TextTransparency = 0}, 0.12)
                if t2 then t2.Completed:Wait() end
            end)
        end
    end
    local function setSupportStyle(style)
        if not style then return end
        style = (style == "Fruit") and "Fruit" or "Melee"
        if _prevSupportStyle == style then
            applySupportVisuals(style); return
        end
        supportStyle = style
        applySupportVisuals(style)
        _prevSupportStyle = style
        pcall(function() player:SetAttribute("FastAttackEnemyStyle", style) end)
    end

    if supportBtn then
        local textObj = getTextHolder(supportBtn)
        if textObj then pcall(function() textObj.TextTransparency = 0 end); pcall(function() textObj.Text = SUPPORT_TEXT[supportStyle] end) end
        pcall(function() supportBtn.BackgroundColor3 = MELEE_COLOR end)
        local stroke3 = getUIStroke(supportBtn); if stroke3 then pcall(function() stroke3.Color = MELEE_COLOR end) end
        local function onSupportActivated()
            local nextStyle = (supportStyle == "Melee") and "Fruit" or "Melee"
            setSupportStyle(nextStyle)
        end
        if supportBtn.Activated then supportBtn.Activated:Connect(onSupportActivated) else supportBtn.MouseButton1Click:Connect(onSupportActivated) end
    end

    pcall(function() player:SetAttribute("FastAttackEnemyStyle", supportStyle) end)
end

--=== BRING MOD =====================================================================================================--

do
    -- ========= SETTINGS =========
    local HITBOX_SIZE = Vector3.new(60, 60, 60)
    local MAX_DISTANCE = 1000
    local MAX_MOVE_FROM_ORIGIN = 180
    local LOOP_DELAY = 0.15
    local IGNORED_ENEMIES = {
        ["Blank Buddy"] = true,
        ["PropHitboxPlaceholder"] = true
    }
    -- ============================

    _G.BringMobGate2 = _G.BringMobGate2 or false

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

    local gate1 = false

    local function updateGate1()
        local bg = ToggleBtn.BackgroundColor3
        gate1 = (bg and bg.G and bg.G > bg.R and bg.G > bg.B) or false
    end

    -- init once
    updateGate1()

    -- listen for future color changes (debounced)
    ToggleBtn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        task.delay(0.05, updateGate1)
    end)

    -- ===== GATE 2 (EXTERNAL CONTROL) =====
    _G.BringMobGate2 = false -- MẶC ĐỊNH

    -- ===== GATE 1: TOGGLE STATE (qua màu) =====
    local function isGate1On()
        local bg = ToggleBtn.BackgroundColor3
        return bg.G > bg.R and bg.G > bg.B
    end

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

            --[[ diagnostic (tạm thời) DEBUG
            local g1 = isGate1On()
            local g2 = _G.BringMobGate2
            if g1 and g2 then
                print("[BringMob] DEBUG: both gates ON -> should run")
            else
                print(string.format("[BringMob] DEBUG: gate1=%s, gate2=%s", tostring(g1), tostring(g2)))
            end ]]-- end

            task.wait(LOOP_DELAY)

            -- 🚪 CHECK 2 CỔNG
            if not (gate1 and _G.BringMobGate2) then
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
                    -- chuẩn bị danh sách origin tương ứng với từng mob trong group
                    local n = #group
                    local originList = {}
                    for i, mob in ipairs(group) do
                        if mob and mob.Parent then
                            local hrp = mob:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                if not InitialPositions[mob] then
                                    InitialPositions[mob] = hrp.Position
                                end
                                originList[i] = InitialPositions[mob]
                            else
                                originList[i] = nil
                            end
                        else
                            originList[i] = nil
                        end
                    end

                    -- build connected components based on origin distances (edge nếu origin_i - origin_j <= MAX_MOVE_FROM_ORIGIN)
                    local visited = {}
                    local components = {}

                    for i = 1, n do
                        if not visited[i] and originList[i] then
                            local stack = { i }
                            visited[i] = true
                            local compIndices = {}

                            while #stack > 0 do
                                local idx = table.remove(stack)
                                table.insert(compIndices, idx)

                                for j = 1, n do
                                    if not visited[j] and originList[j] then
                                        local d = (originList[idx] - originList[j]).Magnitude
                                        if d <= MAX_MOVE_FROM_ORIGIN then
                                            visited[j] = true
                                            table.insert(stack, j)
                                        end
                                    end
                                end
                            end

                            -- convert indices -> actual mobs
                            local comp = {}
                            for _, idx in ipairs(compIndices) do
                                table.insert(comp, group[idx])
                            end
                            table.insert(components, comp)
                        end
                    end

                    -- xử lý từng component (cluster)
                    for _, comp in ipairs(components) do
                        if #comp >= 2 then
                            -- tính centerOrigin = trung bình origin của component
                            local sumOrigin = Vector3.new(0,0,0)
                            local cntOrigin = 0
                            for _, mob in ipairs(comp) do
                                if InitialPositions[mob] then
                                    sumOrigin = sumOrigin + InitialPositions[mob]
                                    cntOrigin = cntOrigin + 1
                                end
                            end
                            if cntOrigin == 0 then
                                continue
                            end
                            local centerOrigin = sumOrigin / cntOrigin

                            -- lọc từng mob: cần thỏa 2 điều kiện:
                            -- 1) origin -> centerOrigin <= MAX_MOVE_FROM_ORIGIN
                            -- 2) currentPos - origin <= MAX_MOVE_FROM_ORIGIN (không đi quá xa so với origin)
                            local finalGroup = {}
                            for _, mob in ipairs(comp) do
                                if mob and mob.Parent then
                                    local hrp = mob:FindFirstChild("HumanoidRootPart")
                                    local hum = mob:FindFirstChild("Humanoid")
                                    local origin = InitialPositions[mob]
                                    if hrp and hum and origin then
                                        local originToCenter = (centerOrigin - origin).Magnitude
                                        local currentDisp = (hrp.Position - origin).Magnitude
                                        if originToCenter <= MAX_MOVE_FROM_ORIGIN and currentDisp <= MAX_MOVE_FROM_ORIGIN then
                                            table.insert(finalGroup, mob)
                                        end
                                    end
                                end
                            end

                            -- nếu đủ thành viên thì bring chúng
                            if #finalGroup >= 2 then
                                local finalSum = Vector3.new(0,0,0)
                                local validCount = 0
                                for _, mob in ipairs(finalGroup) do
                                    local hrp = mob:FindFirstChild("HumanoidRootPart")
                                    if hrp then
                                        finalSum = finalSum + hrp.Position
                                        validCount = validCount + 1
                                    end
                                end
                                if validCount >= 2 then
                                    local centerPos = finalSum / validCount
                                    local centerCFrame = CFrame.new(centerPos)

                                    for _, mob in ipairs(finalGroup) do
                                        if mob and mob.Parent then
                                            local hrp = mob:FindFirstChild("HumanoidRootPart")
                                            local hum = mob:FindFirstChild("Humanoid")
                                            if hrp and hum then
                                                -- apply bring
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

--=== AUTO CHEST =====================================================================================================--

do
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local workspace = game:GetService("Workspace")
    
    -- ========== SETTINGS (theo mẫu) ==========
    local LUNGE_SPEED = 300
    local TELEPORT_HEIGHT = 100
    local TELEPORT_SPAM_COUNT = 60
    local TELEPORT_SPAM_TIME = 1
    local CHEST_REACH_DISTANCE = 6
    local SCAN_INTERVAL = 0.2
    local ARENA_LOOP_DELAY = 0.5
    
    local MID_TELEPORT_THRESHOLD = 200
    -- ==============================
    
    -- ========== Movement token (cancel) ==========
    local movementToken = 0
    local function stopMovement()
        movementToken = movementToken + 1
    end
    
    -- ========== Skip list ==========
    local skippedModels = {}
    local function getModelKey(model)
        if not model then return nil end
        local ok, val = pcall(function() return model:GetAttribute("__AutoChestId") end)
        if ok and type(val) == "string" and #val > 0 then
            return val
        end
        local newId
        pcall(function() newId = HttpService:GenerateGUID(false) end)
        if newId then
            pcall(function() model:SetAttribute("__AutoChestId", newId) end)
            return newId
        end
        return tostring(model)
    end
    
    local function skipModel(modelOrId, duration)
        duration = duration or 120
        if not modelOrId then return end
        local id = (type(modelOrId) == "string") and modelOrId or getModelKey(modelOrId)
        if not id then return end
        skippedModels[id] = tick() + duration
    end
    
    local function isSkipped(modelOrId)
        if not modelOrId then return false end
        local id = (type(modelOrId) == "string") and modelOrId or getModelKey(modelOrId)
        if not id then return false end
        local exp = skippedModels[id]
        if not exp then return false end
        if tick() > exp then
            skippedModels[id] = nil
            return false
        end
        return true
    end
    
    -- ========== Movement helpers ==========
    local function getHRP()
        local char = player.Character or player.CharacterAdded:Wait()
        return char:WaitForChild("HumanoidRootPart")
    end
    
    local function distance(a,b)
        return (a - b).Magnitude
    end
    
    -- ========== Teleport points (from sample) ==========
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
    
    local TELEPORT_POINTS = {}
    do
        local placeId = game.PlaceId
        for _, data in pairs(PLACES) do
            if table.find(data.ids, placeId) then
                TELEPORT_POINTS = data.points
                break
            end
        end
    end
    
    -- ========== Teleport helper (mẫu) ==========
    local function getBestTeleportPoint(fromPos, targetPos)
        if #TELEPORT_POINTS == 0 then return nil end
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
    
    local function teleportSpam(pos, count, time)
        count = count or TELEPORT_SPAM_COUNT
        time  = time  or TELEPORT_SPAM_TIME
        local hrp = getHRP()
        local myToken = movementToken
    
        local done = false
        local sent = 0
        local interval = time / math.max(1, count)
        local elapsed = 0
    
        local conn
        conn = RunService.Heartbeat:Connect(function(dt)
            if myToken ~= movementToken then
                conn:Disconnect()
                done = true
                return
            end
    
            elapsed = elapsed + dt
            if elapsed >= interval then
                elapsed = 0
                sent = sent + 1
                pcall(function() hrp.CFrame = CFrame.new(pos) end)
                if sent >= count then
                    conn:Disconnect()
                    done = true
                end
            end
        end)
    
        while not done and myToken == movementToken do
            task.wait()
        end
    
        return myToken == movementToken
    end
    
    -- ========== Lunge movement (sửa để set Y chỉ khi caller muốn) ==========
    local function lungeTo(targetPos, allowMidTeleport, midTeleportThreshold, alignYOnStart)
        allowMidTeleport = allowMidTeleport == true
        midTeleportThreshold = midTeleportThreshold or MID_TELEPORT_THRESHOLD
        alignYOnStart = (alignYOnStart == nil) and true or alignYOnStart -- default true for backward compatibility
    
        local hrp = getHRP()
        local myToken = movementToken
    
        -- Only align Y if caller requests it (for support flow we will pass false until support finishes)
        if alignYOnStart then
            pcall(function()
                local cur = hrp.Position
                hrp.CFrame = CFrame.new(cur.X, targetPos.Y, cur.Z)
            end)
        end
    
        local startPos = hrp.Position
        local delta = targetPos - startPos
        local dist = delta.Magnitude
        if dist < 0.5 then return true end
    
        local direction = delta.Unit
        local duration = math.max(0.01, dist / LUNGE_SPEED)
        local elapsed = 0
        local finished = false
    
        local conn
        conn = RunService.Heartbeat:Connect(function(dt)
            if myToken ~= movementToken then
                conn:Disconnect()
                finished = false
                return
            end
    
            local curPos = hrp.Position
            local flatRemain = (Vector3.new(curPos.X,0,curPos.Z) - Vector3.new(targetPos.X,0,targetPos.Z)).Magnitude
    
            if allowMidTeleport and flatRemain <= midTeleportThreshold then
                pcall(function()
                    hrp.CFrame = CFrame.new(targetPos)
                end)
                conn:Disconnect()
                finished = true
                return
            end
    
            elapsed = elapsed + dt
            local alpha = math.clamp(elapsed / duration, 0, 1)
            local pos = startPos + direction * (dist * alpha)
            pcall(function() hrp.CFrame = CFrame.new(pos) end)
    
            if alpha >= 1 then
                conn:Disconnect()
                finished = true
            end
        end)
    
        while not finished and myToken == movementToken do
            task.wait()
        end
    
        return myToken == movementToken
    end
    
    -- ========== moveOptimizedTo: (sample behavior) ==========
    local function moveOptimizedTo(targetPos, allowMidTeleport, alignYOnStart)
        allowMidTeleport = allowMidTeleport == true
        alignYOnStart = (alignYOnStart == nil) and true or alignYOnStart
        local myToken = movementToken
        local hrp = getHRP()
        local fromPos = hrp.Position
    
        -- nếu đã tới gần ngang mặt bằng -> done
        if (Vector3.new(targetPos.X,0,targetPos.Z) - Vector3.new(fromPos.X,0,fromPos.Z)).Magnitude <= CHEST_REACH_DISTANCE then
            return true
        end
    
        -- chọn teleport point tối ưu nếu có
        local best = getBestTeleportPoint(fromPos, targetPos)
        if best then
            local ok = teleportSpam(best)
            if not ok or movementToken ~= myToken then return false end
    
            -- teleport lên cao rồi lunge về target
            pcall(function() hrp.CFrame = CFrame.new(best + Vector3.new(0, TELEPORT_HEIGHT, 0)) end)
            task.wait(0.05)
            if movementToken ~= myToken then return false end
    
            -- Lunge but pass alignYOnStart through
            return lungeTo(targetPos, allowMidTeleport, MID_TELEPORT_THRESHOLD, alignYOnStart)
        end
    
        -- fallback: lunge thẳng (and pass alignYOnStart)
        return lungeTo(targetPos, allowMidTeleport, MID_TELEPORT_THRESHOLD, alignYOnStart)
    end
    
    -- wrapper tương thích
    local function executeMovementTo(targetPos, allowMidTeleport, alignYOnStart)
        return moveOptimizedTo(targetPos, allowMidTeleport, alignYOnStart)
    end
    
    -- ========== SupportTween (giữ nguyên nếu dùng các wp có support) ==========
    local SupportTween = nil
    local DoneTween = nil
    local CancelTween = nil
    do
        SupportTween = playerGui:FindFirstChild("SupportTweenToCustom")
        DoneTween = playerGui:FindFirstChild("DoneTweenTo")
        CancelTween = playerGui:FindFirstChild("CancelTweenTo")
    end
    
    local function callSupportAndWait(name, tag, timeout)
        if not SupportTween or not DoneTween then
            return true
        end
    
        local completed = false
        local ok = false
        local conn
        conn = DoneTween.Event:Connect(function(success, doneTag)
            if doneTag == tag then
                completed = true
                ok = success
                conn:Disconnect()
            end
        end)
    
        pcall(function() SupportTween:Fire(name, tag) end)
    
        local t0 = tick()
        while not completed and (tick() - t0) < (timeout or 20) do
            task.wait(0.1)
        end
    
        if conn and conn.Connected then conn:Disconnect() end
        return ok or completed
    end
    
    -- ========== Chest helpers (đảm bảo loại bỏ chest đã skip) ==========
    local function findChestModelsFolder()
        return workspace:FindFirstChild("ChestModels")
    end
    
    local function listChestModels()
        local f = findChestModelsFolder()
        if not f then return {} end
        local out = {}
        for _, v in ipairs(f:GetChildren()) do
            if v:IsA("Model") then
                if not isSkipped(v) then
                    table.insert(out, v)
                end
            end
        end
        return out
    end
    
    local function closestModelToPosition(models, pos)
        local best, bd = nil, math.huge
        for _, m in ipairs(models) do
            if m and m.Parent then
                local primary = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
                if primary then
                    local d = (primary.Position - pos).Magnitude
                    if d < bd then
                        bd = d
                        best = m
                    end
                end
            end
        end
        return best, bd
    end
    
    local function findPushBox(model)
        if not model then return nil end
        for _, obj in ipairs(model:GetDescendants()) do
            if obj.Name == "PushBox" and obj:IsA("BasePart") then
                return obj
            end
        end
        return nil
    end
    
    local function hasTouchInterest(part)
        if not part then return false end
        if part:FindFirstChild("TouchInterest") then return true end
        if part:FindFirstChildOfClass("TouchTransmitter") then return true end
        for _, d in ipairs(part:GetDescendants()) do
            if d.Name == "TouchInterest" or d.ClassName == "TouchTransmitter" then
                return true
            end
        end
        return false
    end
    
    -- ========== Main approach logic (sửa: cho phép mid-teleport khi tới chest) ==========
    local function approachAndProcessModel(model)
        if not model or not model.Parent then return false end
        if isSkipped(model) then return true end -- bỏ qua nếu đã skip
    
        local hrp = getHRP()
        local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
        if not primary then
            skipModel(model, 120)
            return true
        end
    
        local myToken = movementToken
        local d = (hrp.Position - primary.Position).Magnitude
    
        if d > CHEST_REACH_DISTANCE then
            local ok = executeMovementTo(primary.Position, true)
            if not ok or movementToken ~= myToken then return false end
        end
    
        skipModel(model, 120)
    
        if not model.Parent then return true end
    
        local pushBox = findPushBox(model)
        if not pushBox then
            return true
        end
    
        if hasTouchInterest(pushBox) then
            return true
        end
    
        return true
    end
    
    -- ========== scanAndCollectInFolder (giữ logic nhưng listChestModels đã loại skip) ==========
    local movingToWaypoint = false
    
    local function scanAndCollectInFolder()
        local f = findChestModelsFolder()
        if not f then return false end
    
        local hrp = getHRP()
        local iterSafeguard = 0
    
        local myToken = movementToken
        while myToken == movementToken do
            if movingToWaypoint then
                return false
            end
    
            iterSafeguard = iterSafeguard + 1
            if iterSafeguard > 400 then break end
    
            local currentModels = listChestModels()
            for i = #currentModels, 1, -1 do
                local m = currentModels[i]
                if not m or not m.Parent then
                    table.remove(currentModels, i)
                end
            end
    
            if #currentModels == 0 then
                return false
            end
    
            local closest, dist = closestModelToPosition(currentModels, hrp.Position)
            if not closest then return false end
    
            local ok = approachAndProcessModel(closest)
            if not ok then
                return false
            end
    
            task.wait(SCAN_INTERVAL)
        end
    
        return false
    end
    
    -- ========== ARENA waypoints (giữ dữ liệu) ==========
    local function TweenPoint(x,y,z, supportName, supportTag)
        return {
            pos = Vector3.new(x or 0, y or 0, z or 0),
            support = (supportName and tostring(supportName)) or nil,
            supportTag = supportTag
        }
    end
    
    local AREA_DATA = {
        Sea1 = {
            ids = { 85211729168715, 2753915549 },
            arena = {
                TweenPoint(-689.79, 15.52, 1583.28),
                TweenPoint(1038.53, 80.89, 1289.06),
                TweenPoint(-2987.78, 64.65, 2118.18),
                TweenPoint(-1447.33, 62.01, -28.98),
                TweenPoint(-1063.14, 60.27, 4032.97),
                TweenPoint(1131.20, 20.75, 4342.33),
                TweenPoint(1397.80, 88.27, -1344.01),
                TweenPoint(-4937.35, 157.95, 4321.52),
                TweenPoint(-4824.34, 789.57, -2593.36),
                TweenPoint(-7704.47, 5545.65, -811.10),
                TweenPoint(5238.61, 95.83, 744.30),
                TweenPoint(61014.82, 96.51, 1316.77),
                TweenPoint(5706.35, 188.92, 4364.42),
                TweenPoint(-1716.87, 105.53, -3169.11), --14
            }
        },
    
        Sea2 = {
            ids = { 79091703265657, 4442272183 },
            arena = {
                TweenPoint(-380.09, 227.12, 648.07),
                TweenPoint(-2190.19, 201.88, -3226.08),
                TweenPoint(916.50, 181.60, 33320.61),
                TweenPoint(-5635.31, 187.16, -866.97),
                TweenPoint(-6480.40, 305.54, -4733.06),
                TweenPoint(-5167.09, 91.70, -5311.48),
                TweenPoint(-2990.85, 27.13, -9849.51),
                TweenPoint(-3181.70, 298.83, -10547.10),
                TweenPoint(-3711.94, 77.45, -11469.75),
                TweenPoint(3780.60, 119.36, -3499.44),
                TweenPoint(432.57, 401.58, -5442.55),
                TweenPoint(1293.03, 429.58, -5200.26),
                TweenPoint(6561.01, 439.59, -6999.93), -- 13
            
            --TweenPoint(-380.09, 227.12, 648.07, "Cafe", "simpleCall_001"),
            }
        },
    
        Sea3 = {
            ids = { 7449423635, 100117331123089 },
            arena = {
                TweenPoint(-445.27, 108.73, 5929.45),
                TweenPoint(5183.74, 22.43, 76.54),
                TweenPoint(2895.32, 509.45, -7346.18),
                TweenPoint(-12553.24, 459.64, -7496.05),
                TweenPoint(-10990.16, 551.82, -10179.43),
                TweenPoint(-9514.80, 164.14, 5786.82),
                TweenPoint(-1615.79, 87.40, -11072.71),
                TweenPoint(291.32, 28.47, -12711.65),
                TweenPoint(-16560.40, 201.88, 413.13),
                TweenPoint(-5107.22, 443.48, -2967.22),
                --TweenPoint(10582.63, -1955.72, 9603.65, "Submerged Island", "simpleCall_SubmergedIsland"), --10
            }
        },
    
        Dungeon = {
            ids = { 73902483975735 },
            arena = {
                TweenPoint(0, 100, 0),
            }
        }
    }
    
    local ARENA = {}
    local CURRENT_AREA_KEY = nil
    do
        local pid = game.PlaceId
        for areaID, data in pairs(AREA_DATA) do
            if table.find(data.ids, pid) then
                ARENA = data.arena or {}
                CURRENT_AREA_KEY = areaID
                print("[ARENA] Loaded for:", areaID, "#", #ARENA)
                break
            end
        end
    
        if #ARENA == 0 then
            warn("[ARENA] No arena points for this PlaceId:", pid)
        end
    end
    
    -- return number of skip rounds for given areaKey
    local function getSkipRounds(areaKey)
        if areaKey == "Sea1" then
            return 13
        elseif areaKey == "Sea2" then
            return 12
        elseif areaKey == "Sea3" then
            return 8
        else
            return 10 -- fallback default
        end
    end
    
    -- ========== Main automation loop & UI (giữ nguyên) ==========
    local running = false
    local uiToggleButton = nil
    local antiSitEnabled = false
    
    -- ========== Arena waypoint skip control (mới) ==========
    local skippedWaypoints = {}
    
    local function decrementWaypointSkips()
        for idx, v in pairs(skippedWaypoints) do
            skippedWaypoints[idx] = v - 1
            if skippedWaypoints[idx] <= 0 then
                skippedWaypoints[idx] = nil
            end
        end
    end
    
    -- Tìm waypoint gần nhất không bị skip. Nếu không còn cái nào, trả về nearest ignoring skip.
    local function findNearestAvailableWaypoint(fromPos)
        if #ARENA == 0 then return nil end
    
        local bestIdx, bestDist = nil, math.huge
        -- first pass: look for non-skipped
        for i = 1, #ARENA do
            if ARENA[i] and ARENA[i].pos then
                if not skippedWaypoints[i] then
                    local d = (ARENA[i].pos - fromPos).Magnitude
                    if d < bestDist then
                        bestDist = d
                        bestIdx = i
                    end
                end
            end
        end
    
        -- fallback: if all skipped, choose nearest ignoring skip
        if not bestIdx then
            for i = 1, #ARENA do
                if ARENA[i] and ARENA[i].pos then
                    local d = (ARENA[i].pos - fromPos).Magnitude
                    if d < bestDist then
                        bestDist = d
                        bestIdx = i
                    end
                end
            end
        end
    
        return bestIdx, bestDist
    end
    
    -- ================= runner (FIXED support flow) =================
    local function runner()
        while running do
            if not findChestModelsFolder() then
                task.wait(2)
                if not running then break end
            end
    
            local hrp = getHRP()
            local wpIndex, wpDist = findNearestAvailableWaypoint(hrp.Position)
            if not wpIndex then
                task.wait(1)
                -- continue
            else
                local wp = ARENA[wpIndex]
                if wp then
                    -- If waypoint has support, CALL support and WAIT for success BEFORE changing STREAM_Y or moving.
                    local proceedToMove = true
                    if wp.support then
                        local tag = wp.supportTag or ("AutoArena_support_"..tostring(wpIndex).."_"..tostring(tick()))
                        local ok = callSupportAndWait(wp.support, tag, 25)
                        -- If support did not succeed, skip this waypoint (do not set STREAM_Y)
                        if not ok then
                            warn("[ARENA] support failed/timeout for waypoint", wpIndex, wp.support)
                            proceedToMove = false
                        else
                            -- support succeeded -> now set STREAM_Y to waypoint Y
                            STREAM_Y = wp.pos.Y
                            task.wait(0.12)
                        end
                    end
    
                    if not proceedToMove then
                        task.wait(0.2)
                    else
                        stopMovement()
                        movingToWaypoint = true
                        local myToken = movementToken
    
                        -- Move to waypoint (no mid-teleport)
                        local arrived = moveOptimizedTo(wp.pos, false, true) -- alignYOnStart = true now OK because support done
                        movingToWaypoint = false
    
                        if arrived and movementToken == myToken then
                            decrementWaypointSkips()
                            skippedWaypoints[wpIndex] = getSkipRounds(CURRENT_AREA_KEY)
                        end
    
                        if not arrived or movementToken ~= myToken then
                            if not running then break end
                            task.wait(0.2)
                        else
                            -- after arriving, collect chests at that location
                            repeat
                                if not running then break end
                                local any = scanAndCollectInFolder()
                                if any == false then
                                    local modelsNow = listChestModels()
                                    if #modelsNow == 0 then break end
                                end
                                task.wait(0.12)
                            until not running
                            task.wait(ARENA_LOOP_DELAY)
                        end
                    end
                else
                    task.wait(1)
                end
            end
        end
    end
    
    -- ===== Replace old UI with ToggleUI integration (uses _G.ToggleUI, Frame "Main", button "AutoChestButton") =====
    repeat task.wait() until _G.ToggleUI
    local ToggleUI = _G.ToggleUI
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)
    
    local BUTTON_NAME = "AutoChestButton"
    
    local ScrollingTab = player
        .PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")
    
    local MainFrame = ScrollingTab:FindFirstChild("Main", true) or ScrollingTab:WaitForChild("Main", 5)
    if not MainFrame then
        warn("Không tìm thấy Frame 'Main' trong ScrollingTab")
    end
    
    local button = nil
    if MainFrame then
        button = MainFrame:FindFirstChild(BUTTON_NAME, true)
    end
    if not button then
        warn("Không tìm thấy button:", BUTTON_NAME)
    end
    
    pcall(function() if ToggleUI.Refresh then ToggleUI.Refresh() end end)
    pcall(function() ToggleUI.Set(BUTTON_NAME, false) end)
    
    local function isButtonOn()
        if not button then return false end
        local ok, c = pcall(function() return button.BackgroundColor3 end)
        if not ok or not c then return false end
        local r = math.floor(c.R * 255 + 0.5)
        local g = math.floor(c.G * 255 + 0.5)
        local b = math.floor(c.B * 255 + 0.5)
        return (r == 0 and g == 255 and b == 0)
    end
    
    local function safeStartRunner()
        if not running then return end
        if isRunnerActive then return end
        isRunnerActive = true
        task.spawn(function()
            pcall(runner)
            isRunnerActive = false
            running = false
            antiSitEnabled = false
        end)
    end
    
    local function setRunningFromButton()
        local on = isButtonOn()
        if on and (not running) then
            running = true
            antiSitEnabled = true
            safeStartRunner()
        elseif (not on) and running then
            running = false
            antiSitEnabled = false
            stopMovement()
            if CancelTween and CancelTween.Fire then
                pcall(function() CancelTween:Fire() end)
            end
        end
    end
    
    if button then
        if button.Activated then
            button.Activated:Connect(function()
                pcall(function() ToggleUI.Set(BUTTON_NAME, not isButtonOn()) end)
            end)
        else
            button.MouseButton1Click:Connect(function()
                pcall(function() ToggleUI.Set(BUTTON_NAME, not isButtonOn()) end)
            end)
        end
    
        button:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
            task.delay(0.05, function()
                setRunningFromButton()
            end)
        end)
    end
    
    setRunningFromButton()
    
    -- ===== Respawn-safety + Anti-sit (thay thế phần cũ) =====
    local humanoid = nil
    local deathConn = nil
    local pausedForRespawn = false
    local isRunnerActive = false
    
    local function onCharacterAdded(char)
        if deathConn and deathConn.Connected then
            pcall(function() deathConn:Disconnect() end)
        end
    
        local okHum, hum = pcall(function() return char:WaitForChild("Humanoid", 10) end)
        local okHRP, hrp = pcall(function() return char:WaitForChild("HumanoidRootPart", 10) end)
    
        humanoid = (okHum and hum) or nil
    
        if humanoid then
            deathConn = humanoid.Died:Connect(function()
                if running then
                    pausedForRespawn = true
                    stopMovement()
                    antiSitEnabled = false
                end
            end)
        end
    
        task.spawn(function()
            local t0 = tick()
            while (tick() - t0) < 12 do
                if not char.Parent then break end
                local okH, h = pcall(function() return char:FindFirstChildWhichIsA("Humanoid") end)
                local okR, r = pcall(function() return char:FindFirstChild("HumanoidRootPart") end)
                if okH and okR and h and r and h.Health and h.Health > 0 then
                    task.wait(0.9)
                    pausedForRespawn = false
                    antiSitEnabled = running
                    if running and (not isRunnerActive) then
                        safeStartRunner()
                    end
                    return
                end
                task.wait(0.25)
            end
            pausedForRespawn = false
            antiSitEnabled = running
            if running and (not isRunnerActive) then
                safeStartRunner()
            end
        end)
    end
    
    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then
        onCharacterAdded(player.Character)
    end
    
    RunService.Heartbeat:Connect(function()
        if antiSitEnabled and humanoid then
            if humanoid.Sit then
                pcall(function()
                    humanoid.Sit = false
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end)
            end
        end
    end)
    
    -- ========== Cleanup ==========
    local function safeCleanup()
        running = false
        antiSitEnabled = false
        stopMovement()
        if uiToggleButton and uiToggleButton.Parent then
            pcall(function()
                local parent = uiToggleButton.Parent.Parent
                if parent and parent:IsA("ScreenGui") then parent:Destroy() end
            end)
        end
    end
    
    if typeof(script) == "Instance" and script.Destroying then
        pcall(function() script.Destroying:Connect(safeCleanup) end)
    end
    if player and player:FindFirstChild("PlayerGui") then
        local pg = player.PlayerGui
        pcall(function()
            pg.AncestryChanged:Connect(function()
                if not pg:IsDescendantOf(game) then
                    safeCleanup()
                end
            end)
        end)
    end
end
