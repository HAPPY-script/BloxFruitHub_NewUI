do
	loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM_UI/AutoStopSeaEven_UI.lua"))()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM_UI/AutoStopSeaEven_Effect.lua"))()

	local Players = game:GetService("Players")
	local TweenService = game:GetService("TweenService")
	local RunService = game:GetService("RunService")

	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local function getCharacter()
		return player.Character
	end

	local character = getCharacter()
	local rootPart

	_G.AutoStopSEvenSystem = (_G.AutoStopSEvenSystem ~= false)
	_G.PauseSEven = _G.PauseSEven or false

	local gui = playerGui:FindFirstChild("AutoStopSEvenGui") or playerGui:WaitForChild("AutoStopSEvenGui", 10)
	if not gui then
		return warn("AutoStopSEvenGui not found")
	end

	local main = gui:WaitForChild("Main")
	local modeFrame = main:WaitForChild("ModeFrame")
	local stopButton = modeFrame:WaitForChild("StopButton")
	local pauseButton = modeFrame:WaitForChild("PauseButton")
	local selectFrame = main:WaitForChild("SelectEvenFrame")

	local OPEN_POS = UDim2.new(0.5, 0, 0.5, 0)
	local CLOSE_POS = UDim2.new(0.5, 0, 1.5, 0)

	local TWEEN_MAIN = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local TWEEN_FAST = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	local TARGETS = {
		Leviathan = {
			kind = "map",
			objectName = "LeviathanGate",
		},

		Prehistoric = {
			kind = "map",
			objectName = "PrehistoricIsland",
		},

		SeaBeast = {
			kind = "folder_match",
			folderName = "SeaBeasts",
			range = 2500,
			match = function(name)
				return name:find("SeaBeast", 1, true) ~= nil
			end,
		},

		ShipRaid = {
			kind = "folder_match_any",
			folderName = "Enemies",
			range = 2500,
			matches = {
				"PirateGrandBrigade",
				"PirateBrigade",
			},
		},

		HauntedShipRaid = {
			kind = "folder_match_any",
			folderName = "Enemies",
			range = 2500,
			matches = {
				"FishBoat",
				"Fish Crew Member",
			},
		},

		TerrorShark = {
			kind = "folder_match_any",
			folderName = "Enemies",
			range = 2500,
			matches = {
				"Terrorshark",
			},
		},

		Piranha = {
			kind = "folder_match",
			folderName = "Enemies",
			range = 2500,
			match = function(name)
				return name == "Piranha"
			end,
		},
	}

	local activeTweens = setmetatable({}, { __mode = "k" })
	local pickCache = {}
	local modeCache = {}

	local selectedMode = "Stop"
	local selectedTargets = {}
	local selectedCount = 0
	local selectedPickButtons = {}

	local isOpen = false
	local isToggling = false
	local currentAnySeen = false

	local lastAppliedEnabled = nil
	local lastAppliedSeen = nil
	local lastAppliedMode = nil
	local lastAppliedHasTarget = nil

	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.Position = CLOSE_POS
	main.Visible = false

	local function tween(obj, info, props)
		local old = activeTweens[obj]
		if old then
			old:Cancel()
		end

		local tw = TweenService:Create(obj, info, props)
		activeTweens[obj] = tw

		tw.Completed:Once(function()
			if activeTweens[obj] == tw then
				activeTweens[obj] = nil
			end
		end)

		tw:Play()
		return tw
	end

	local function setImageAlpha(obj, alpha, instant)
		if not obj or not (obj:IsA("ImageButton") or obj:IsA("ImageLabel")) then
			return
		end

		if instant then
			obj.ImageTransparency = alpha
		else
			tween(obj, TWEEN_FAST, { ImageTransparency = alpha })
		end
	end

	local function updateCharacter(char)
		character = char
		rootPart = nil
		if char then
			rootPart = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
		end
	end

	updateCharacter(player.Character)
	player.CharacterAdded:Connect(updateCharacter)

	local function fireStop()
		if type(_G.StopSEven) == "function" then
			pcall(_G.StopSEven)
		end
	end

	local function setMode(mode)
		if selectedMode == mode then
			return
		end

		selectedMode = mode
		tween(stopButton, TWEEN_FAST, { ImageTransparency = mode == "Stop" and 0 or 1 })
		tween(pauseButton, TWEEN_FAST, { ImageTransparency = mode == "Pause" and 0 or 1 })
		lastAppliedMode = nil
	end

	local function applySystem(anySeen)
		local enabled = _G.AutoStopSEvenSystem
		local hasTarget = selectedCount > 0

		if not enabled then
			if _G.PauseSEven then
				_G.PauseSEven = false
			end
			lastAppliedEnabled = false
			lastAppliedSeen = false
			lastAppliedMode = selectedMode
			lastAppliedHasTarget = hasTarget
			return
		end

		if lastAppliedEnabled == true
			and lastAppliedSeen == anySeen
			and lastAppliedMode == selectedMode
			and lastAppliedHasTarget == hasTarget then
			return
		end

		lastAppliedEnabled = true
		lastAppliedSeen = anySeen
		lastAppliedMode = selectedMode
		lastAppliedHasTarget = hasTarget

		if not hasTarget or not anySeen then
			if _G.PauseSEven then
				_G.PauseSEven = false
			end
			return
		end

		if selectedMode == "Stop" then
			_G.PauseSEven = false
			fireStop()
		elseif selectedMode == "Pause" then
			_G.PauseSEven = true
		end
	end

	local function setMain(state)
		if isToggling or isOpen == state then
			return
		end

		isToggling = true
		isOpen = state

		if state then
			main.Visible = true
			main.Position = CLOSE_POS

			local tw = tween(main, TWEEN_MAIN, { Position = OPEN_POS })
			tw.Completed:Once(function()
				isToggling = false
			end)
		else
			local tw = tween(main, TWEEN_MAIN, { Position = CLOSE_POS })
			tw.Completed:Once(function()
				main.Visible = false
				isToggling = false
			end)
		end
	end

	function _G.AutoStopSEvenGui()
		setMain(not isOpen)
	end

	local function setupModeButton(btn, modeName)
		if modeCache[btn] then
			return
		end
		modeCache[btn] = true

		setImageAlpha(btn, modeName == selectedMode and 0 or 1, true)

		btn.Activated:Connect(function()
			setMode(modeName)
			currentAnySeen = false
			currentAnySeen = currentAnySeen or false
			applySystem(currentAnySeen)
		end)
	end

	setupModeButton(stopButton, "Stop")
	setupModeButton(pauseButton, "Pause")

	local function findTargetOwner(pickButton)
		local current = pickButton.Parent
		while current and current ~= selectFrame do
			if current:IsA("GuiButton") and TARGETS[current.Name] then
				return current.Name, current
			end
			current = current.Parent
		end
		return nil, nil
	end

	local function setupPickButton(inst)
		if not inst:IsA("ImageButton") or inst.Name ~= "PickButton" then
			return
		end

		if pickCache[inst] then
			return
		end

		local targetKey, ownerButton = findTargetOwner(inst)
		if not targetKey then
			return
		end

		pickCache[inst] = true
		setImageAlpha(inst, 1, true)

		if ownerButton then
			ownerButton.Active = false
			ownerButton.AutoButtonColor = false
		end

		inst.Activated:Connect(function()
			if selectedTargets[targetKey] then
				selectedTargets[targetKey] = nil
				selectedCount = math.max(0, selectedCount - 1)
				selectedPickButtons[targetKey] = nil
				setImageAlpha(inst, 1, false)
			else
				selectedTargets[targetKey] = true
				selectedCount += 1
				selectedPickButtons[targetKey] = inst
				setImageAlpha(inst, 0, false)
			end

			currentAnySeen = false
			currentAnySeen = currentAnySeen or false
			applySystem(currentAnySeen)
		end)
	end

	for _, obj in ipairs(selectFrame:GetDescendants()) do
		setupPickButton(obj)
	end

	selectFrame.DescendantAdded:Connect(setupPickButton)

	-- =========================
	-- TARGET CACHE / RESOLVER
	-- =========================

	local modelPartCache = setmetatable({}, { __mode = "k" })
	local folderStates = {}
	local mapCache = {}

	local mapConns = {}

	local function isFolderTarget(cfg)
		return cfg.kind == "folder_match" or cfg.kind == "folder_match_any"
	end

	local function matchModelName(cfg, name)
		if cfg.kind == "folder_match" then
			return cfg.match and cfg.match(name) or false
		end

		if cfg.kind == "folder_match_any" then
			cfg._matchSet = cfg._matchSet or (function()
				local set = {}
				for _, n in ipairs(cfg.matches or {}) do
					set[n] = true
				end
				return set
			end)()
			return cfg._matchSet[name] == true
		end

		return false
	end

	local function disconnectList(list)
		for i = #list, 1, -1 do
			local c = list[i]
			if c then
				pcall(function()
					c:Disconnect()
				end)
			end
			list[i] = nil
		end
	end

	local function getWorldPosition(inst)
		if not inst or not inst.Parent then
			return nil
		end

		if inst:IsA("BasePart") then
			return inst.Position
		end

		if inst:IsA("Model") then
			local pp = inst.PrimaryPart
			if pp and pp.Parent then
				return pp.Position
			end

			local part = modelPartCache[inst]
			if part == nil then
				local found = inst:FindFirstChildWhichIsA("BasePart", true)
				modelPartCache[inst] = found or false
				part = modelPartCache[inst]
			end

			if part and part ~= false and part.Parent then
				return part.Position
			end
		end

		return nil
	end

	local function withinRange(rootPos, inst, range)
		local pos = getWorldPosition(inst)
		if not pos then
			return false
		end

		local d = rootPos - pos
		return (d.X * d.X + d.Y * d.Y + d.Z * d.Z) <= (range * range)
	end

	local function refreshMapCache()
		local map = workspace:FindFirstChild("Map")
		if not map then
			for key, cfg in pairs(TARGETS) do
				if cfg.kind == "map" then
					mapCache[key] = nil
				end
			end
			return
		end

		for key, cfg in pairs(TARGETS) do
			if cfg.kind == "map" then
				mapCache[key] = map:FindFirstChild(cfg.objectName, true)
			end
		end
	end

	local function bindMapWatchers()
		disconnectList(mapConns)

		local map = workspace:FindFirstChild("Map")
		if not map then
			refreshMapCache()
			return
		end

		refreshMapCache()

		mapConns[#mapConns + 1] = map.DescendantAdded:Connect(function(obj)
			for key, cfg in pairs(TARGETS) do
				if cfg.kind == "map" and obj.Name == cfg.objectName then
					mapCache[key] = obj
				end
			end
		end)

		mapConns[#mapConns + 1] = map.DescendantRemoving:Connect(function(obj)
			for key, cfg in pairs(TARGETS) do
				if cfg.kind == "map" and mapCache[key] == obj then
					mapCache[key] = nil
				end
			end
		end)
	end

	local function clearFolderTarget(targetKey)
		local state = folderStates[targetKey]
		if not state then
			return
		end

		disconnectList(state.conns)
		table.clear(state.models)
		folderStates[targetKey] = nil
	end

	local function bindFolderTarget(targetKey)
		local cfg = TARGETS[targetKey]
		if not isFolderTarget(cfg) then
			return
		end

		local folder = workspace:FindFirstChild(cfg.folderName)
		if not folder then
			clearFolderTarget(targetKey)
			return
		end

		local old = folderStates[targetKey]
		if old and old.folder == folder then
			return
		end

		clearFolderTarget(targetKey)

		local state = {
			folder = folder,
			models = setmetatable({}, { __mode = "k" }),
			conns = {},
		}
		folderStates[targetKey] = state

		local function addIfMatch(obj)
			if obj:IsA("Model") and matchModelName(cfg, obj.Name) then
				state.models[obj] = true
			end
		end

		for _, obj in ipairs(folder:GetDescendants()) do
			addIfMatch(obj)
		end

		state.conns[#state.conns + 1] = folder.DescendantAdded:Connect(addIfMatch)
		state.conns[#state.conns + 1] = folder.DescendantRemoving:Connect(function(obj)
			if obj:IsA("Model") then
				state.models[obj] = nil
			end
		end)
	end

	for key, cfg in pairs(TARGETS) do
		if cfg.kind == "map" then
			-- handled by bindMapWatchers()
		elseif isFolderTarget(cfg) then
			bindFolderTarget(key)
		end
	end

	bindMapWatchers()

	workspace.ChildAdded:Connect(function(child)
		if child.Name == "Map" then
			bindMapWatchers()
		end

		for key, cfg in pairs(TARGETS) do
			if isFolderTarget(cfg) and child.Name == cfg.folderName then
				bindFolderTarget(key)
			end
		end
	end)

	workspace.ChildRemoved:Connect(function(child)
		if child.Name == "Map" then
			disconnectList(mapConns)
			for key, cfg in pairs(TARGETS) do
				if cfg.kind == "map" then
					mapCache[key] = nil
				end
			end
		end

		for key, cfg in pairs(TARGETS) do
			if isFolderTarget(cfg) and child.Name == cfg.folderName then
				clearFolderTarget(key)
			end
		end
	end)

	local function evaluateAnySeen()
		if not _G.AutoStopSEvenSystem then
			return false
		end

		if selectedCount <= 0 then
			return false
		end

		if not rootPart or not rootPart.Parent then
			return false
		end

		local rootPos = rootPart.Position

		for targetKey in pairs(selectedTargets) do
			local cfg = TARGETS[targetKey]
			if cfg then
				if cfg.kind == "map" then
					local obj = mapCache[targetKey]
					if not obj or not obj.Parent then
						refreshMapCache()
						obj = mapCache[targetKey]
					end

					if obj and withinRange(rootPos, obj, cfg.range or 2500) then
						return true
					end
				else
					local state = folderStates[targetKey]
					if state then
						for model in pairs(state.models) do
							if not model or not model.Parent then
								state.models[model] = nil
							elseif withinRange(rootPos, model, cfg.range or 2500) then
								return true
							end
						end
					end
				end
			end
		end

		return false
	end

	task.spawn(function()
		while true do
			if _G.AutoStopSEvenSystem and selectedCount > 0 then
				currentAnySeen = evaluateAnySeen()
				applySystem(currentAnySeen)
				task.wait(0.2)
			else
				currentAnySeen = false
				applySystem(false)
				task.wait(0.8)
			end
		end
	end)
end
