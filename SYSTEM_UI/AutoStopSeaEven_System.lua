loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM_UI/AutoStopSeaEven_UI.lua"))()

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM_UI/AutoStopSeaEven_Effect.lua"))()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

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
local selectedPickButtons = {}

local isOpen = false
local isToggling = false
local lastAppliedKey = nil
local currentAnySeen = false

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
	lastAppliedKey = nil
end

local function toggleTarget(targetKey, pickButton)
	if selectedTargets[targetKey] then
		selectedTargets[targetKey] = nil
		selectedPickButtons[targetKey] = nil
		setImageAlpha(pickButton, 1, false)
	else
		selectedTargets[targetKey] = true
		selectedPickButtons[targetKey] = pickButton
		setImageAlpha(pickButton, 0, false)
	end

	lastAppliedKey = nil
end

local function applySystem(anySeen)
	if not _G.AutoStopSEvenSystem then
		if _G.PauseSEven then
			_G.PauseSEven = false
		end
		lastAppliedKey = nil
		return
	end

	local anySelected = next(selectedTargets) ~= nil
	local key = tostring(anySelected) .. ":" .. tostring(anySeen) .. ":" .. selectedMode
	if key == lastAppliedKey then
		return
	end
	lastAppliedKey = key

	if not anySelected or not anySeen then
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
		toggleTarget(targetKey, inst)
		applySystem(currentAnySeen)
	end)
end

for _, obj in ipairs(selectFrame:GetDescendants()) do
	setupPickButton(obj)
end

selectFrame.DescendantAdded:Connect(setupPickButton)

-- =========================
-- OPTIMIZED TARGET CACHE
-- =========================

local modelPartCache = setmetatable({}, { __mode = "k" })
local folderStates = {}
local mapCache = {}
local folderConnByKey = {}

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

local modelPartCache = setmetatable({}, { __mode = "k" }) -- fallback part cache
local modelHasPrimaryCache = setmetatable({}, { __mode = "k" }) -- bool cache

local function getModelPosition(model)
	if not model or not model.Parent then
		return nil
	end

	local pp = model.PrimaryPart
	if pp and pp.Parent then
		modelHasPrimaryCache[model] = true
		return pp.Position
	end

	if modelHasPrimaryCache[model] == true then
		return nil
	end

	local part = modelPartCache[model]
	if part == nil then
		part = model:FindFirstChildWhichIsA("BasePart", true)
		modelPartCache[model] = part or false
	end

	if part and part ~= false and part.Parent then
		return part.Position
	end

	return nil
end

local function withinRange(a, b, range)
	local d = a - b
	return (d.X * d.X + d.Y * d.Y + d.Z * d.Z) <= (range * range)
end

local function refreshMapCache(targetKey)
	local cfg = TARGETS[targetKey]
	local map = workspace:FindFirstChild("Map")
	if not map then
		mapCache[targetKey] = nil
		return
	end

	mapCache[targetKey] = map:FindFirstChild(cfg.objectName, true)
end

local function bindFolderTarget(targetKey)
	local cfg = TARGETS[targetKey]
	if not isFolderTarget(cfg) then
		return
	end

	local folder = workspace:FindFirstChild(cfg.folderName)
	if not folder then
		return
	end

	local state = folderStates[targetKey]
	if not state then
		state = {
			models = setmetatable({}, { __mode = "k" }),
			conns = {},
		}
		folderStates[targetKey] = state
	else
		for _, c in ipairs(state.conns) do
			c:Disconnect()
		end
		table.clear(state.conns)
		table.clear(state.models)
	end

	for _, obj in ipairs(folder:GetDescendants()) do
		if obj:IsA("Model") and matchModelName(cfg, obj.Name) then
			state.models[obj] = true
		end
	end

	state.conns[#state.conns + 1] = folder.DescendantAdded:Connect(function(obj)
		if obj:IsA("Model") and matchModelName(cfg, obj.Name) then
			folderStates[targetKey].models[obj] = true
		end
	end)

	state.conns[#state.conns + 1] = folder.DescendantRemoving:Connect(function(obj)
		if obj:IsA("Model") then
			local s = folderStates[targetKey]
			if s then
				s.models[obj] = nil
			end
		end
	end)
end

for key, cfg in pairs(TARGETS) do
	if cfg.kind == "map" then
		refreshMapCache(key)
	elseif isFolderTarget(cfg) then
		bindFolderTarget(key)
	end
end

workspace.ChildAdded:Connect(function(child)
	if child.Name == "Map" then
		for key, cfg in pairs(TARGETS) do
			if cfg.kind == "map" then
				refreshMapCache(key)
			end
		end
	end

	for key, cfg in pairs(TARGETS) do
		if isFolderTarget(cfg) and child.Name == cfg.folderName then
			bindFolderTarget(key)
		end
	end
end)

local function evaluateAnySeen()
	if not _G.AutoStopSEvenSystem then
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
					refreshMapCache(targetKey)
					obj = mapCache[targetKey]
				end

				if obj then
					local pos = getModelPosition(obj)
					if pos and withinRange(rootPos, pos, cfg.range or 2500) then
						return true
					end
				end
			else
				local state = folderStates[targetKey]
				if state then
					for model in pairs(state.models) do
						if not model or not model.Parent then
							state.models[model] = nil
						else
							local pos = getModelPosition(model)
							if pos and withinRange(rootPos, pos, cfg.range or 2500) then
								return true
							end
						end
					end
				end
			end
		end
	end

	return false
end

task.spawn(function()
	while task.wait(0.2) do
		currentAnySeen = evaluateAnySeen()
		applySystem(currentAnySeen)
	end
end)
