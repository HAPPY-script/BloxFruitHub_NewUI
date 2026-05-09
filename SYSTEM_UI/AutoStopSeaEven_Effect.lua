local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = playerGui:FindFirstChild("AutoStopSEvenGui")
	or playerGui:WaitForChild("AutoStopSEvenGui", 10)

if not gui then
	return warn("AutoStopSEvenGui not found")
end

local main = gui:WaitForChild("Main")
local selectFrame = main:WaitForChild("SelectEvenFrame")
local titleFrame = main:WaitForChild("TitleFrame")
local closeBtn = titleFrame:WaitForChild("Close")

local isMobile = game:GetService("UserInputService").TouchEnabled
	and not game:GetService("UserInputService").KeyboardEnabled

main.Size = isMobile
	and UDim2.new(0.5, 0, 0.5, 0)
	or UDim2.new(0, 500, 0, 500)

local OPEN_POS = UDim2.new(0.5, 0, 0.5, 0)
local CLOSE_POS = UDim2.new(0.5, 0, 1.5, 0)

local MAIN_TWEEN_INFO = TweenInfo.new(
	0.25,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out
)

local HOVER_TWEEN_INFO = TweenInfo.new(
	0.15,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out
)

local isOpen = false
local isToggling = false
local hoverCache = {}

main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = CLOSE_POS
main.Visible = false

local function tween(obj, info, props)
	local oldTween = obj:FindFirstChild("__ActiveTween")

	if oldTween then
		oldTween:Destroy()
	end

	local marker = Instance.new("BoolValue")
	marker.Name = "__ActiveTween"
	marker.Parent = obj

	local tw = TweenService:Create(obj, info, props)

	tw.Completed:Once(function()
		if marker.Parent then
			marker:Destroy()
		end
	end)

	tw:Play()

	return tw
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

		local tw = tween(main, MAIN_TWEEN_INFO, {
			Position = OPEN_POS
		})

		tw.Completed:Once(function()
			isToggling = false
		end)

	else
		local tw = tween(main, MAIN_TWEEN_INFO, {
			Position = CLOSE_POS
		})

		tw.Completed:Once(function()
			main.Visible = false
			isToggling = false
		end)
	end
end

function _G.AutoStopSEvenGui()
	setMain(not isOpen)
end

closeBtn.Activated:Connect(function()
	_G.AutoStopSEvenGui()
end)

local function setupIconHover(button)
	if not button:IsA("GuiButton") then
		return
	end

	if hoverCache[button] then
		return
	end

	local icon = button:FindFirstChild("Icon")

	if not icon or not icon:IsA("ImageLabel") then
		return
	end

	hoverCache[button] = true

	local baseSize = icon.Size

	local hoverSize = UDim2.new(
		baseSize.X.Scale * 1.2,
		math.floor(baseSize.X.Offset * 1.2),

		baseSize.Y.Scale * 1.2,
		math.floor(baseSize.Y.Offset * 1.2)
	)

	local hovering = false

	local function setHover(state)
		if hovering == state then
			return
		end

		hovering = state

		tween(icon, HOVER_TWEEN_INFO, {
			Size = state and hoverSize or baseSize
		})
	end

	button.MouseEnter:Connect(function()
		setHover(true)
	end)

	button.MouseLeave:Connect(function()
		setHover(false)
	end)

	button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			setHover(true)
		end
	end)

	button.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			setHover(false)
		end
	end)
end

for _, obj in ipairs(selectFrame:GetDescendants()) do
	setupIconHover(obj)
end

selectFrame.DescendantAdded:Connect(setupIconHover)
