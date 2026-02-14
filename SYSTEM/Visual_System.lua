--=== Remove fog =====================================================================================================--

do
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")
    local Players = game:GetService("Players")

    local player = Players.LocalPlayer

    local Frame = player.PlayerGui
    	:WaitForChild("BloxFruitHubGui")
    	:WaitForChild("Main")
    	:WaitForChild("ScrollingTab")
    	:WaitForChild("Visual")

    local button = Frame:WaitForChild("Remove fog")

    local uiStroke = button:FindFirstChildOfClass("UIStroke")
    local uiGradient = button:FindFirstChildOfClass("UIGradient")

    local firstClick = true

    local function lockIntensityZero(intensity)
    	if intensity.Value ~= 0 then
    		intensity.Value = 0
    	end
    
    	intensity.Changed:Connect(function(v)
    		if v ~= 0 then
    			intensity.Value = 0
    		end
    	end)
    end
    
    local function removeFog()
    	local folder = Lighting:FindFirstChild("LightingLayers")
    	if not folder then return end
    
    	for _, child in ipairs(folder:GetChildren()) do
    		if child.Name == "DarkFog" then
    			local intensity = child:FindFirstChild("Intensity", true)
    			if intensity and intensity:IsA("NumberValue") then
    				lockIntensityZero(intensity)
    			end
    		else
    			child:Destroy()
    		end
    	end
    end

    button.MouseButton1Click:Connect(function()
    	removeFog()

    	if not firstClick then return end
    	firstClick = false

    	local info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    	-- Button background -> xanh
    	TweenService:Create(button, info, {
    		BackgroundColor3 = Color3.fromRGB(0,255,0)
    	}):Play()

    	-- Text -> trắng
    	TweenService:Create(button, info, {
    		TextColor3 = Color3.fromRGB(255,255,255)
    	}):Play()

    	-- UIStroke -> trắng
    	if uiStroke then
    		TweenService:Create(uiStroke, info, {
    			Color = Color3.new(1,1,1)
    		}):Play()
    	end

    	-- UIGradient tween mượt thật sự
    	if uiGradient then
    		local startColor = Color3.fromRGB(52,52,52)
    		local endColor = Color3.fromRGB(255,255,255)

    		local alpha = Instance.new("NumberValue")
    		alpha.Value = 0

    		local tween = TweenService:Create(alpha, info, {Value = 1})
    		tween:Play()

    		alpha.Changed:Connect(function(v)
    			local c = startColor:Lerp(endColor, v)
    			uiGradient.Color = ColorSequence.new({
    				ColorSequenceKeypoint.new(0, c),
    				ColorSequenceKeypoint.new(1, c),
    			})
    		end)

    		tween.Completed:Connect(function()
    			alpha:Destroy()
    		end)
    	end
    end)
end

--=== CHECK PLAYERS =====================================================================================================--

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")

    local localPlayer = Players.LocalPlayer
    local playerGui = localPlayer:WaitForChild("PlayerGui")

    -- Locate UI pieces (will error early if missing)
    local Visual = playerGui:WaitForChild("BloxFruitHubGui"):WaitForChild("Main"):WaitForChild("ScrollingTab"):WaitForChild("Visual")
    local UIPlayersFolder = Visual:WaitForChild("UIPlayers") -- folder that contains PlayerFrame template
    local PlayerFrameTemplate = UIPlayersFolder:WaitForChild("PlayerFrame")
    local toggleButton = Visual:WaitForChild("CheckPlayersButton")

    -- The Main container to parent PlayerFrame into when enabled
    local Main = playerGui:WaitForChild("BloxFruitHubGui"):WaitForChild("Main")

    -- Template row inside PlayerFrameTemplate
    local RowTemplate = PlayerFrameTemplate:FindFirstChild("Player1")
    if not RowTemplate then
    	warn("Player1 template not found inside PlayerFrame")
    	return
    end

    -- config (positions)
    local ROW_START_Y = 0.02
    local ROW_STEP = 0.03

    -- state
    local active = false
    local rows = {} -- list of created row records {player, frame, conns = {...}}
    local prevCameraSubject = nil
    local prevCameraType = nil
    local currentViewedPlayer = nil

    -- helper: safe tween
    local function tween(obj, props, time)
    	local info = TweenService:Create(obj, TweenInfo.new(time or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    	info:Play()
    	return info
    end

    -- helper: set row visuals for view toggle
    local function setRowViewVisuals(rowFrame, isOn)
    	local viewBtn = rowFrame:FindFirstChild("ViewButton")
    	if not viewBtn then return end
    	local OnImg = viewBtn:FindFirstChild("On")
    	local OffImg = viewBtn:FindFirstChild("Off")
    	if OnImg then OnImg.Visible = isOn end
    	if OffImg then OffImg.Visible = not isOn end
    end

    -- helper: restore camera to local player's humanoid immediately
    local function restoreCameraToLocal()
    	local cam = workspace.CurrentCamera
    	if cam and localPlayer and localPlayer.Character then
    		local localHum = localPlayer.Character:FindFirstChildWhichIsA("Humanoid")
    		if localHum then
    			pcall(function()
    				cam.CameraSubject = localHum
    				cam.CameraType = Enum.CameraType.Custom
    			end)
    		end
    	end
    	-- clear view state
    	prevCameraSubject = nil
    	prevCameraType = nil
    	currentViewedPlayer = nil
    	-- turn off visuals on all rows
    	for _, rec in ipairs(rows) do
    		pcall(setRowViewVisuals, rec.frame, false)
    	end
    end

    -- helper: cleanup all created rows
    -- preserveView = true sẽ giữ currentViewedPlayer & prevCameraSubject (dùng khi repopulate)
    local function cleanupRows(preserveView)
    	for _, r in ipairs(rows) do
    		-- disconnect connections
    		if r.conns then
    			for _, c in ipairs(r.conns) do
    				if c and type(c.Disconnect) == "function" then
    					pcall(function() c:Disconnect() end)
    				end
    			end
    		end
    		-- destroy row frame
    		if r.frame and r.frame.Parent then
    			pcall(function() r.frame:Destroy() end)
    		end
    	end
    	rows = {}

    	-- restore camera when closing (if previously changed) only if NOT preserving view
    	if not preserveView then
    		currentViewedPlayer = nil
    		if prevCameraSubject then
    			local cam = workspace.CurrentCamera
    			if cam then
    				pcall(function()
    					cam.CameraSubject = prevCameraSubject
    					cam.CameraType = prevCameraType or Enum.CameraType.Custom
    				end)
    			end
    			prevCameraSubject = nil
    			prevCameraType = nil
    		end
    	end
    end

    -- helper: update HP bar tween (size + color)
    local function updateHPVisual(hpFrame, ratio)
    	local hpBar = hpFrame and hpFrame:FindFirstChild("HP")
    	if not hpBar then return end
    	ratio = math.clamp(ratio or 0, 0, 1)
    	local goalSize = UDim2.new(ratio, 0, 1, 0)
    	tween(hpBar, {Size = goalSize}, 0.18)
    	-- color interpolate: 1->green, 0->red
    	local rC = math.clamp(math.floor(255*(1-ratio)),0,255)
    	local gC = math.clamp(math.floor(255*ratio),0,255)
    	local color = Color3.fromRGB(rC, gC, 0)
    	tween(hpBar, {BackgroundColor3 = color}, 0.18)
    end

    -- robust helper: set avatar image on ImageLabel for a Player
    local function setAvatarImage(imageLabel, player)
    	if not imageLabel or not player then return end
    	pcall(function() imageLabel.Visible = true end)
    	local ok, thumbUrl = pcall(function()
    		return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48)
    	end)
    	if ok and type(thumbUrl) == "string" and thumbUrl ~= "" then
    		imageLabel.Image = thumbUrl
    		return
    	end
    	local fallback = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(player.UserId) .. "&w=48&h=48"
    	imageLabel.Image = fallback
    end

    -- create a row for a player (clones template)
    local function createRowForPlayer(targetPlayer, index)
    	-- clone template
    	local row = RowTemplate:Clone()
    	row.Name = "Player_" .. tostring(targetPlayer.UserId)
    	row.Visible = true
    	row.Parent = PlayerFrameTemplate

    	-- set position
    	local y = ROW_START_Y + (index - 1) * ROW_STEP
    	row.Position = UDim2.new(0.5, 0, y, 0)

    	-- fill name
    	local nameLabel = row:FindFirstChild("Name", true) or row:FindFirstChild("Name")
    	if nameLabel and nameLabel:IsA("TextLabel") then
    		nameLabel.Text = targetPlayer.Name
    	end

    	-- prepare connections table early
    	local connections = {}

    	-- avatar: find ImageLabel named "Avatar" and set image
    	local avatar = row:FindFirstChild("Avatar", true) or row:FindFirstChild("Avatar")
    	if avatar and avatar:IsA("ImageLabel") then
    		pcall(setAvatarImage, avatar, targetPlayer)
    		-- refresh avatar on character added (appearance change)
    		local cRefresh = targetPlayer.CharacterAdded:Connect(function()
    			task.delay(0.5, function()
    				pcall(setAvatarImage, avatar, targetPlayer)
    			end)
    		end)
    		table.insert(connections, cRefresh)
    	end

    	-- HP frame
    	local HPFrame = row:FindFirstChild("HPFrame", true) or row:FindFirstChild("HPFrame")
    	if HPFrame then
    		updateHPVisual(HPFrame, 0)
    	end

    	-- view button
    	local viewBtn = row:FindFirstChild("ViewButton", true) or row:FindFirstChild("ViewButton")
    	if viewBtn and viewBtn:IsA("TextButton") then
    		local btnConn = viewBtn.MouseButton1Click:Connect(function()
    			-- if currently viewing this player -> restore to local
    			if currentViewedPlayer and currentViewedPlayer.UserId == targetPlayer.UserId then
    				local cam = workspace.CurrentCamera
    				if cam and localPlayer.Character and localPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
    					pcall(function()
    						cam.CameraSubject = localPlayer.Character:FindFirstChildWhichIsA("Humanoid")
    						cam.CameraType = Enum.CameraType.Custom
    					end)
    				end
    				currentViewedPlayer = nil
    				for _, rec in ipairs(rows) do
    					setRowViewVisuals(rec.frame, false)
    				end
    			else
    				local cam = workspace.CurrentCamera
    				local targetHum = targetPlayer.Character and targetPlayer.Character:FindFirstChildWhichIsA("Humanoid")
    				if cam and targetHum then
    					-- save previous subject on first time
    					if not prevCameraSubject then
    						prevCameraSubject = cam.CameraSubject
    						prevCameraType = cam.CameraType
    					end
    					pcall(function()
    						cam.CameraSubject = targetHum
    						cam.CameraType = Enum.CameraType.Custom
    					end)
    					currentViewedPlayer = targetPlayer
    					for _, rec in ipairs(rows) do
    						setRowViewVisuals(rec.frame, rec.player.UserId == targetPlayer.UserId)
    					end
    				end
    			end
    		end)
    		table.insert(connections, btnConn)
    	end

    	-- Setup HP updates: listen to character/humanoid changes
    	local function bindHumanoid(humanoid)
    		if not humanoid or not HPFrame then return end
    		-- initial set
    		local health = humanoid.Health or 0
    		local maxHealth = humanoid.MaxHealth or 1
    		updateHPVisual(HPFrame, (maxHealth > 0) and (health / maxHealth) or 0)

    		-- health changed
    		local c1 = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
    			local h = humanoid.Health or 0
    			local mh = humanoid.MaxHealth or 1
    			updateHPVisual(HPFrame, (mh > 0) and (h / mh) or 0)
    		end)
    		table.insert(connections, c1)

    		-- maxhealth changed
    		local c2 = humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(function()
    			local h = humanoid.Health or 0
    			local mh = humanoid.MaxHealth or 1
    			updateHPVisual(HPFrame, (mh > 0) and (h / mh) or 0)
    		end)
    		table.insert(connections, c2)
    	end

    	-- character added / removed
    	local cChar = targetPlayer.CharacterAdded:Connect(function(ch)
    		local humanoid = ch:WaitForChild("Humanoid", 2)
    		if humanoid then
    			bindHumanoid(humanoid)
    		end
    	end)
    	table.insert(connections, cChar)

    	-- if character exists now, bind
    	if targetPlayer.Character then
    		local humanoid = targetPlayer.Character:FindFirstChildWhichIsA("Humanoid")
    		if humanoid then
    			bindHumanoid(humanoid)
    		end
    	end

    	-- store record
    	table.insert(rows, {
    		player = targetPlayer,
    		frame = row,
    		conns = connections,
    	})

    	-- default view visuals: Off visible, On not visible
    	setRowViewVisuals(row, currentViewedPlayer and currentViewedPlayer.UserId == targetPlayer.UserId)
    end

    -- Populate rows for all players (preserve current view if possible)
    local function populatePlayers()
    	-- remember who is currently viewed (by UserId)
    	local viewedId = currentViewedPlayer and currentViewedPlayer.UserId

    	-- clean previously created rows but preserve view state
    	cleanupRows(true)
    	RowTemplate.Visible = false

    	local allPlayers = Players:GetPlayers()
    	local idx = 1
    	for _, p in ipairs(allPlayers) do
    		if p ~= localPlayer then
    			createRowForPlayer(p, idx)
    			idx = idx + 1
    		end
    	end
    	-- put localPlayer at the end (optional)
    	createRowForPlayer(localPlayer, idx)

    	-- try to restore view if viewed player still present
    	if viewedId then
    		local restored = false
    		for _, rec in ipairs(rows) do
    			if rec.player and rec.player.UserId == viewedId then
    				-- try set camera subject (if humanoid exists)
    				local cam = workspace.CurrentCamera
    				local hum = rec.player.Character and rec.player.Character:FindFirstChildWhichIsA("Humanoid")
    				if cam and hum then
    					-- prevCameraSubject should already be saved from first view
    					pcall(function()
    						cam.CameraSubject = hum
    						cam.CameraType = Enum.CameraType.Custom
    					end)
    					currentViewedPlayer = rec.player
    					-- update visuals
    					for _, r2 in ipairs(rows) do
    						setRowViewVisuals(r2.frame, r2.player.UserId == viewedId)
    					end
    					restored = true
    				end
    				break
    			end
    		end

    		-- if couldn't restore (player left or no humanoid), restore original camera subject
    		if not restored and prevCameraSubject then
    			local cam = workspace.CurrentCamera
    			if cam then
    				pcall(function()
    					cam.CameraSubject = prevCameraSubject
    					cam.CameraType = prevCameraType or Enum.CameraType.Custom
    				end)
    			end
    			prevCameraSubject = nil
    			prevCameraType = nil
    			currentViewedPlayer = nil
    		end
    	end
    end

    -- Toggle PlayerFrame parent between UIPlayers folder and Main
    local function enablePlayerFrame()
    	if PlayerFrameTemplate.Parent ~= Main then
    		-- move out to Main
    		PlayerFrameTemplate.Parent = Main
    		PlayerFrameTemplate.Visible = true
    		-- populate and start (only when visible)
    		populatePlayers()
    		active = true
    	else
    		-- move back to folder and cleanup
    		-- ensure camera returns to local immediately
    		restoreCameraToLocal()
    		cleanupRows(false)
    		RowTemplate.Visible = true
    		PlayerFrameTemplate.Parent = UIPlayersFolder
    		PlayerFrameTemplate.Visible = false -- keep hidden in folder
    		active = false
    	end
    end

    -- Connect toggle button
    toggleButton.MouseButton1Click:Connect(function()
    	pcall(enablePlayerFrame)
    end)

    -- Observe ancestry change (external show/hide)
    PlayerFrameTemplate.AncestryChanged:Connect(function()
    	if PlayerFrameTemplate.Parent == Main and not active then
    		pcall(function()
    			populatePlayers()
    			active = true
    		end)
    	elseif PlayerFrameTemplate.Parent ~= Main and active then
    		pcall(function()
    			-- when hidden externally, restore camera too
    			restoreCameraToLocal()
    			cleanupRows(false)
    			RowTemplate.Visible = true
    			active = false
    		end)
    	end
    end)

    -- When players join/leave while panel is open: update the list (add/remove)
    local playersConn
    playersConn = Players.PlayerAdded:Connect(function(pl)
    	if not active then return end
    	pcall(populatePlayers)
    end)
    local playersRemovedConn
    playersRemovedConn = Players.PlayerRemoving:Connect(function(pl)
    	if not active then return end
    	pcall(populatePlayers)
    end)

    -- ensure cleanup on script end / player leaving
    local function onCleanup()
    	if playersConn then playersConn:Disconnect() end
    	if playersRemovedConn then playersRemovedConn:Disconnect() end
    	cleanupRows(false)
    end

    -- Safe cleanup hookup: prefer script.Destroying, fall back to GUI/player removal detection
    local function safeHookCleanup()
        -- prefer script.Destroying if available (normal LocalScript case)
        if typeof(script) == "Instance" and script.Destroying then
            pcall(function() script.Destroying:Connect(onCleanup) end)
            return
        end
    
        -- Fallback A: watch the Visual Frame parent — when it's removed, call cleanup
        if typeof(Frame) == "Instance" then
            local frameConn
            frameConn = Frame:GetPropertyChangedSignal("Parent"):Connect(function()
                if not Frame.Parent then
                    pcall(onCleanup)
                    if frameConn and frameConn.Connected then
                        pcall(function() frameConn:Disconnect() end)
                    end
                end
            end)
        end
    
        -- Fallback B: watch PlayerGui ancestry — when PlayerGui leaves the DataModel, call cleanup
        if player and player:FindFirstChild("PlayerGui") then
            local pg = player.PlayerGui
            local pgConn
            pgConn = pg.AncestryChanged:Connect(function()
                if not pg:IsDescendantOf(game) then
                    pcall(onCleanup)
                    if pgConn and pgConn.Connected then
                        pcall(function() pgConn:Disconnect() end)
                    end
                end
            end)
        end
    
        -- Last resort: try BindToClose (best-effort on client)
        if type(game.BindToClose) == "function" then
            pcall(function()
                game:BindToClose(function()
                    pcall(onCleanup)
                end)
            end)
        end
    end
    
    safeHookCleanup()
end

--=== ANTI LAG =====================================================================================================--

do
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")
    
    local player = Players.LocalPlayer
    
    -- === cấu hình tween màu ===
    local FROM_BG = Color3.fromRGB(175, 0, 30)
    local TO_BG   = Color3.fromRGB(175, 100, 175)
    
    local FROM_STROKE = Color3.fromRGB(255, 255, 255)
    local TO_STROKE   = Color3.fromRGB(100, 255, 150)
    
    local TWEEN_TIME = 0.28
    
    -- === cờ tránh chạy lại ===
    local ranOnce = false
    
    -- === tìm Frame / Button ===
    local ok, VisualFrame = pcall(function()
    	return player.PlayerGui
    		:WaitForChild("BloxFruitHubGui")
    		:WaitForChild("Main")
    		:WaitForChild("ScrollingTab")
    		:WaitForChild("Visual")
    end)
    if not ok or not VisualFrame then
    	warn("AntiLag: không tìm thấy Visual frame trong PlayerGui")
    	return
    end
    
    local button = VisualFrame:WaitForChild("AntiLagButton", 5)
    if not button then
    	warn("AntiLag: không tìm thấy AntiLagButton")
    	return
    end
    
    -- helper: tìm UIStroke trong button (first descendant)
    local function findStroke(inst)
    	for _, c in ipairs(inst:GetDescendants()) do
    		if c:IsA("UIStroke") then
    			return c
    		end
    	end
    	return nil
    end
    
    local stroke = findStroke(button)
    
    -- helper: tạo tween an toàn
    local function playTween(instance, props, time)
    	local info = TweenInfo.new(time or TWEEN_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    	local ok, tw = pcall(function() return TweenService:Create(instance, info, props) end)
    	if ok and tw then
    		tw:Play()
    		return tw
    	end
    	return nil
    end
    
    -- === Anti-lag routine (ONE TIME) ===
    local function runOneTimeAntiLag()
    	-- nếu đã chạy thì bỏ
    	if ranOnce then return end
    	ranOnce = true
    
    	-- SETTINGS (theo yêu cầu)
    	local REMOVE_PARTICLES   = true
    	local REMOVE_TRAILS      = true
    	local REMOVE_BEAMS       = true
    	local REMOVE_EXPLOSIONS  = true
    	local REMOVE_DECALS      = true
    	local REMOVE_MESHES      = true
    
    	local EFFECT_NAMES = {
    		"Effects", "Effect", "Particles", "VFX", "Debris", "Explosion", "Smoke",
    	}
    
    	-- LIGHTING OPTIMIZATION (1 lần)
    	pcall(function()
    		Lighting.GlobalShadows = false
    		Lighting.FogEnd = 9e9
    		Lighting.Brightness = 1
    
    		for _, v in ipairs(Lighting:GetChildren()) do
    			if v:IsA("BloomEffect")
    			or v:IsA("BlurEffect")
    			or v:IsA("ColorCorrectionEffect")
    			or v:IsA("SunRaysEffect")
    			or v:IsA("DepthOfFieldEffect") then
    				v.Enabled = false
    			end
    		end
    	end)
    
    	-- object optimizer (1 lần)
    	local function optimizeObject(obj)
    		if not obj then return end
    
    		if REMOVE_PARTICLES and obj:IsA("ParticleEmitter") then
    			pcall(function() obj:Destroy() end)
    			return
    		end
    
    		if REMOVE_TRAILS and obj:IsA("Trail") then
    			pcall(function() obj:Destroy() end)
    			return
    		end
    
    		if REMOVE_BEAMS and obj:IsA("Beam") then
    			pcall(function() obj:Destroy() end)
    			return
    		end
    
    		if REMOVE_EXPLOSIONS and obj:IsA("Explosion") then
    			pcall(function() obj:Destroy() end)
    			return
    		end
    
    		if REMOVE_DECALS and (obj:IsA("Decal") or obj:IsA("Texture")) then
    			pcall(function() obj:Destroy() end)
    			return
    		end
    
    		if REMOVE_MESHES and obj:IsA("MeshPart") then
    			pcall(function() obj.Material = Enum.Material.Plastic end)
    		end
    
    		if obj:IsA("BasePart") then
    			pcall(function()
    				obj.Material = Enum.Material.Plastic
    				obj.Reflectance = 0
    			end)
    		end
    
    		-- remove floating damage GUIs once
    		if obj:IsA("BillboardGui") then
    			pcall(function() obj:Destroy() end)
    		end
    	end
    
    	-- ONE-TIME full cleanup (may spike briefly depending on map size)
    	task.spawn(function()
    		-- iterate descendants once
    		for _, obj in ipairs(Workspace:GetDescendants()) do
    			-- protect from long blocking by yielding occasionally
    			if coroutine.running() and (os.clock() % 0.1) < 0.001 then
    				task.wait()
    			end
    			pcall(function() optimizeObject(obj) end)
    		end
    
    		-- clear common effect folders once (safe pcall)
    		for _, folderName in ipairs(EFFECT_NAMES) do
    			local f = Workspace:FindFirstChild(folderName, true)
    			if f then
    				pcall(function() f:ClearAllChildren() end)
    			end
    		end
    
    		-- done
    		pcall(function() print("✅ ONE-TIME ULTRA ANTI LAG DONE!") end)
    	end)
    end
    
    -- handler khi bấm button
    local function onActivated()
    	-- disable để tránh double-run
    	if ranOnce then
    		-- nhỏ thông báo hoặc âm thanh nếu muốn
    		return
    	end
    
    	-- play color tweens
    	pcall(function()
    		-- đặt start màu về giá trị ban đầu (an toàn)
    		button.BackgroundColor3 = FROM_BG
    		if stroke then stroke.Color = FROM_STROKE end
    
    		local bgTween = playTween(button, { BackgroundColor3 = TO_BG }, TWEEN_TIME)
    		if stroke then
    			local stTween = playTween(stroke, { Color = TO_STROKE }, TWEEN_TIME)
    		end
    	end)
    
    	-- set button non-interactable
    	pcall(function()
    		if button:IsA("TextButton") then
    			button.AutoButtonColor = false
    		end
    		button.Active = false
    	end)
    
    	-- run anti-lag (one-time)
    	runOneTimeAntiLag()
    end
    
    -- bind event (supports both Activated and MouseButton1Click)
    if button.Activated then
    	button.Activated:Connect(onActivated)
    else
    	button.MouseButton1Click:Connect(onActivated)
    end
end
