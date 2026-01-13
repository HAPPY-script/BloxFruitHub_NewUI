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

    local function removeFog()
    	local folder = Lighting:FindFirstChild("LightingLayers")
    	if folder then
    		folder:Destroy()
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

    -- helper: cleanup all created rows
    local function cleanupRows()
    	for _, r in ipairs(rows) do
    		-- disconnect connections
    		if r.conns then
    			for _, c in ipairs(r.conns) do
    				if c and type(c.Disconnect) == "function" then
    					c:Disconnect()
    				end
    			end
    		end
    		-- destroy row frame
    		if r.frame and r.frame.Parent then
    			pcall(function() r.frame:Destroy() end)
    		end
    	end
    	rows = {}
    	currentViewedPlayer = nil
    	-- restore camera when closing (if previously changed)
    	if prevCameraSubject then
    		local cam = workspace.CurrentCamera
    		if cam then
    			-- restore subject if possible
    			pcall(function()
    				cam.CameraSubject = prevCameraSubject
    				cam.CameraType = prevCameraType or Enum.CameraType.Custom
    			end)
    		end
    		prevCameraSubject = nil
    		prevCameraType = nil
    	end
    end

    -- helper: update HP bar tween (size + color)
    local function updateHPVisual(hpFrame, ratio)
    	local hpBar = hpFrame:FindFirstChild("HP")
    	if not hpBar then return end
    	ratio = math.clamp(ratio or 0, 0, 1)
    	local goalSize = UDim2.new(ratio, 0, 1, 0)
    	tween(hpBar, {Size = goalSize}, 0.18)
    	-- color interpolate: 1->green, 0->red
    	local color = Color3.fromRGB(255*(1-ratio), 255*ratio, 0)
    	tween(hpBar, {BackgroundColor3 = color}, 0.18)
    end

    -- robust helper: set avatar image on ImageLabel for a Player
    local function setAvatarImage(imageLabel, player)
    	if not imageLabel or not player then return end

    	-- ensure visible
    	pcall(function() imageLabel.Visible = true end)

    	-- try GetUserThumbnailAsync (pcall to avoid runtime error)
    	local ok, thumbUrl = pcall(function()
    		return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48)
    	end)

    	if ok and type(thumbUrl) == "string" and thumbUrl ~= "" then
    		-- Use returned url
    		imageLabel.Image = thumbUrl
    		return
    	end

    	-- fallback: rbxthumb scheme (should work in client)
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

    	-- avatar: find ImageLabel named "Avatar" and set image
    	local avatar = row:FindFirstChild("Avatar", true) or row:FindFirstChild("Avatar")
    	if avatar and avatar:IsA("ImageLabel") then
    		-- immediately set avatar (async within pcall)
    		pcall(setAvatarImage, avatar, targetPlayer)

    		-- optional: if player changes appearance, refresh when character added
    		local cRefresh = targetPlayer.CharacterAdded:Connect(function()
    			-- small delay to let appearance load
    			task.delay(0.5, function()
    				pcall(setAvatarImage, avatar, targetPlayer)
    			end)
    		end)

    		-- keep this connection in connections for cleanup
    		-- we'll add it into connections table below
    		-- (we add it after creating connections table)
    	end

    	-- HP frame
    	local HPFrame = row:FindFirstChild("HPFrame", true) or row:FindFirstChild("HPFrame")
    	if HPFrame then
    		-- initialize to 0 until we read humanoid
    		updateHPVisual(HPFrame, 0)
    	end

    	-- view button
    	local viewBtn = row:FindFirstChild("ViewButton", true) or row:FindFirstChild("ViewButton")
    	if viewBtn and viewBtn:IsA("TextButton") then
    		viewBtn.MouseButton1Click:Connect(function()
    			-- if currently viewing this player -> restore to local
    			if currentViewedPlayer and currentViewedPlayer.UserId == targetPlayer.UserId then
    				-- restore camera
    				local cam = workspace.CurrentCamera
    				if cam and localPlayer.Character and localPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
    					pcall(function()
    						cam.CameraSubject = localPlayer.Character:FindFirstChildWhichIsA("Humanoid")
    						cam.CameraType = Enum.CameraType.Custom
    					end)
    				end
    				currentViewedPlayer = nil
    				-- update visuals (turn off On for this row)
    				for _, rec in ipairs(rows) do
    					setRowViewVisuals(rec.frame, false)
    				end
    			else
    				-- set camera subject to target player's humanoid (if exists)
    				local cam = workspace.CurrentCamera
    				if cam and targetPlayer.Character and targetPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
    					-- save previous subject on first time
    					if not prevCameraSubject then
    						prevCameraSubject = cam.CameraSubject
    						prevCameraType = cam.CameraType
    					end
    					pcall(function()
    						cam.CameraSubject = targetPlayer.Character:FindFirstChildWhichIsA("Humanoid")
    						cam.CameraType = Enum.CameraType.Custom
    					end)
    					currentViewedPlayer = targetPlayer
    					-- update visuals (On visible for this row only)
    					for _, rec in ipairs(rows) do
    						setRowViewVisuals(rec.frame, rec.player.UserId == targetPlayer.UserId)
    					end
    				end
    			end
    		end)
    	end

    	-- Setup HP updates: listen to character/humanoid changes
    	local connections = {}

    	local function bindHumanoid(humanoid)
    		if not humanoid then return end
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
    		-- small delay for humanoid
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

    -- Populate rows for all players (except maybe local player? We'll include others; include local too at end)
    local function populatePlayers()
    	-- clean previously created rows (but keep template RowTemplate hidden)
    	cleanupRows()
    	RowTemplate.Visible = false

    	local allPlayers = Players:GetPlayers()
    	-- build list excluding the PlayerFrame owner? We'll include everyone except the template
    	local idx = 1
    	for _, p in ipairs(allPlayers) do
    		-- skip if template corresponds to local UI or other non-player (no)
    		-- include all players except maybe the local Player? include all except local by default? We'll include all others first, then local at end
    		if p ~= localPlayer then
    			createRowForPlayer(p, idx)
    			idx = idx + 1
    		end
    	end
    	-- put localPlayer at the end (optional)
    	createRowForPlayer(localPlayer, idx)
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
    		cleanupRows()
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

    -- Also, if PlayerFrame gets parented manually or its Visible toggled, we watch that and ensure we populate only when parent == Main
    -- Observe ancestry change to react if someone else moves it
    PlayerFrameTemplate.AncestryChanged:Connect(function()
    	if PlayerFrameTemplate.Parent == Main and not active then
    		-- populate on external show
    		pcall(function()
    			populatePlayers()
    			active = true
    		end)
    	elseif PlayerFrameTemplate.Parent ~= Main and active then
    		-- hidden externally: cleanup
    		pcall(function()
    			cleanupRows()
    			RowTemplate.Visible = true
    			active = false
    		end)
    	end
    end)

    -- When players join/leave while panel is open: update the list (add/remove)
    local playersConn
    playersConn = Players.PlayerAdded:Connect(function(pl)
    	if not active then return end
    	-- simply repopulate (cheap because small list)
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
    	cleanupRows()
    end

    script.Destroying:Connect(onCleanup)
end
