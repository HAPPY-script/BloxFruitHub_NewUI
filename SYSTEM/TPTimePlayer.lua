local TP = {}

function TP.Mode1()
        -- TP TIME ================================================================================================
			local Players = game:GetService("Players")
			local RunService = game:GetService("RunService")
			
			local lp = Players.LocalPlayer
			
			--================ UI CREATE ================--
			
			local gui = Instance.new("ScreenGui")
			gui.Name = "FollowTP_UI"
			gui.ResetOnSpawn = false
			gui.Parent = lp:WaitForChild("PlayerGui")
			
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(0, 200, 0, 150)
			frame.Position = UDim2.new(0.05, 0, 0.3, 0)
			frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			frame.Parent = gui
			
			Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
			
			local drag = Instance.new("UIDragDetector")
			drag.Parent = frame
			
			-- Title
			local title = Instance.new("TextLabel")
			title.Size = UDim2.new(1, 0, 0, 25)
			title.BackgroundTransparency = 1
			title.Text = "TP Follow"
			title.TextColor3 = Color3.new(1, 1, 1)
			title.Font = Enum.Font.GothamBold
			title.TextSize = 14
			title.Parent = frame
			
			-- Close Button (X)
			local closeBtn = Instance.new("TextButton")
			closeBtn.Size = UDim2.new(0, 25, 0, 25)
			closeBtn.Position = UDim2.new(1, -28, 0, 0)
			closeBtn.Text = "X"
			closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
			closeBtn.TextColor3 = Color3.new(1, 1, 1)
			closeBtn.Font = Enum.Font.GothamBold
			closeBtn.TextSize = 14
			closeBtn.Parent = frame
			Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
			
			-- TextBox nhập tên
			local box = Instance.new("TextBox")
			box.Size = UDim2.new(0.9, 0, 0, 28)
			box.Position = UDim2.new(0.05, 0, 0.25, 0)
			box.PlaceholderText = "Enter name (min 3 letters)"
			box.Text = ""
			box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			box.TextColor3 = Color3.new(1, 1, 1)
			box.Font = Enum.Font.Gotham
			box.TextSize = 13
			box.Parent = frame
			Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
			
			-- TextBox nhập time
			local timeBox = Instance.new("TextBox")
			timeBox.Size = UDim2.new(0.9, 0, 0, 28)
			timeBox.Position = UDim2.new(0.05, 0, 0.47, 0)
			timeBox.PlaceholderText = "Time (sec) blank = infinite"
			timeBox.Text = ""
			timeBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			timeBox.TextColor3 = Color3.new(1, 1, 1)
			timeBox.Font = Enum.Font.Gotham
			timeBox.TextSize = 13
			timeBox.Parent = frame
			Instance.new("UICorner", timeBox).CornerRadius = UDim.new(0, 8)
			
			-- Toggle Button
			local toggleBtn = Instance.new("TextButton")
			toggleBtn.Size = UDim2.new(0.9, 0, 0, 30)
			toggleBtn.Position = UDim2.new(0.05, 0, 0.72, 0)
			toggleBtn.Text = "OFF"
			toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			toggleBtn.TextColor3 = Color3.new(1, 1, 1)
			toggleBtn.Font = Enum.Font.GothamBold
			toggleBtn.TextSize = 14
			toggleBtn.Parent = frame
			Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)
			
			--================ LOGIC ================--
			
			local running = false
			local conn
			
			-- Hàm tìm player theo 3+ ký tự đầu
			local function findPlayer(partialName)
				if #partialName < 3 then return nil end
				partialName = partialName:lower()
			
				for _, plr in ipairs(Players:GetPlayers()) do
					if plr ~= lp and plr.Name:lower():sub(1, #partialName) == partialName then
						return plr
					end
				end
				return nil
			end
			
			-- Stop teleport
			local function stopTP()
				running = false
				toggleBtn.Text = "OFF"
				toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			
				if conn then
					conn:Disconnect()
					conn = nil
				end
			end
			
			-- Start teleport
			local function startTP()
				local target = findPlayer(box.Text)
			
				if not target then
					toggleBtn.Text = "NOT FOUND"
					task.wait(0.7)
					toggleBtn.Text = "OFF"
					return
				end
			
				running = true
				toggleBtn.Text = "ON"
				toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 80)
			
				-- Nếu có nhập time thì auto stop sau X giây
				local t = tonumber(timeBox.Text)
				if t and t > 0 then
					task.delay(t, function()
						if running then
							stopTP()
						end
					end)
				end
			
				-- Teleport 60 lần/s
				conn = RunService.RenderStepped:Connect(function()
					if not running then return end
			
					local char = lp.Character
					local tChar = target.Character
					if not (char and tChar) then return end
			
					local hrp = char:FindFirstChild("HumanoidRootPart")
					local tHrp = tChar:FindFirstChild("HumanoidRootPart")
					if hrp and tHrp then
						hrp.CFrame = tHrp.CFrame * CFrame.new(0, 0, 2)
					end
				end)
			end
			
			-- Toggle click
			toggleBtn.MouseButton1Click:Connect(function()
				if running then
					stopTP()
				else
					startTP()
				end
			end)
			
			-- Close button
			closeBtn.MouseButton1Click:Connect(function()
				stopTP()
				gui:Destroy()
			end)
end

function TP.Mode2()
            -- TP SKY TIME ============================================================================================
			local Players = game:GetService("Players")
			local RunService = game:GetService("RunService")
			local lp = Players.LocalPlayer
			
			-- ====== CONFIG ======
			local LUNGE_SPEED = 300            -- tốc độ ngang khi lunge
			local DROP_HEIGHT = 3000           -- offset Y khi lunge (target.Y + DROP_HEIGHT)
			local TELEPORT_DISTANCE = 200      -- khi cách <= giá trị này (horiz) => bật teleport 60/s
			local DROP_DURATION = 0.5          -- thời gian giữ Y ở target (giây)
			-- ====================
			
			--================ UI CREATE ================--
			local gui = Instance.new("ScreenGui")
			gui.Name = "FollowTP_UI"
			gui.ResetOnSpawn = false
			gui.Parent = lp:WaitForChild("PlayerGui")
			
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(0, 200, 0, 150)
			frame.Position = UDim2.new(0.05, 0, 0.3, 0)
			frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			frame.Parent = gui
			Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
			
			local drag = Instance.new("UIDragDetector")
			drag.Parent = frame
			
			local title = Instance.new("TextLabel")
			title.Size = UDim2.new(1, 0, 0, 25)
			title.BackgroundTransparency = 1
			title.Text = "Lunge Follow"
			title.TextColor3 = Color3.new(1, 1, 1)
			title.Font = Enum.Font.GothamBold
			title.TextSize = 14
			title.Parent = frame
			
			local closeBtn = Instance.new("TextButton")
			closeBtn.Size = UDim2.new(0, 25, 0, 25)
			closeBtn.Position = UDim2.new(1, -28, 0, 0)
			closeBtn.Text = "X"
			closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
			closeBtn.TextColor3 = Color3.new(1, 1, 1)
			closeBtn.Font = Enum.Font.GothamBold
			closeBtn.TextSize = 14
			closeBtn.Parent = frame
			Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
			
			local box = Instance.new("TextBox")
			box.Size = UDim2.new(0.9, 0, 0, 28)
			box.Position = UDim2.new(0.05, 0, 0.25, 0)
			box.PlaceholderText = "Enter name (min 3 letters)"
			box.Text = ""
			box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			box.TextColor3 = Color3.new(1, 1, 1)
			box.Font = Enum.Font.Gotham
			box.TextSize = 13
			box.Parent = frame
			Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
			
			local timeBox = Instance.new("TextBox")
			timeBox.Size = UDim2.new(0.9, 0, 0, 28)
			timeBox.Position = UDim2.new(0.05, 0, 0.47, 0)
			timeBox.PlaceholderText = "Time (sec) min=1"
			timeBox.Text = ""
			timeBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			timeBox.TextColor3 = Color3.new(1, 1, 1)
			timeBox.Font = Enum.Font.Gotham
			timeBox.TextSize = 13
			timeBox.Parent = frame
			Instance.new("UICorner", timeBox).CornerRadius = UDim.new(0, 8)
			
			local toggleBtn = Instance.new("TextButton")
			toggleBtn.Size = UDim2.new(0.9, 0, 0, 30)
			toggleBtn.Position = UDim2.new(0.05, 0, 0.72, 0)
			toggleBtn.Text = "OFF"
			toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			toggleBtn.TextColor3 = Color3.new(1, 1, 1)
			toggleBtn.Font = Enum.Font.GothamBold
			toggleBtn.TextSize = 14
			toggleBtn.Parent = frame
			Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)
			
			--================ LOGIC ================--
			
			local movementToken = 0        -- token để hủy mọi chuyển động cũ
			local running = false
			local mainConn = nil
			local teleportConn = nil
			local dropThread = nil
			local teleporting = false
			
			local function getHRP()
			    local char = lp.Character or lp.CharacterAdded:Wait()
			    return char:WaitForChild("HumanoidRootPart")
			end
			
			-- Hàm tìm player theo 3+ ký tự đầu
			local function findPlayer(partialName)
				if type(partialName) ~= "string" or #partialName < 3 then return nil end
				partialName = partialName:lower()
			
				for _, plr in ipairs(Players:GetPlayers()) do
					if plr ~= lp and plr.Name:lower():sub(1, #partialName) == partialName then
						return plr
					end
				end
				return nil
			end
			
			-- Hủy mọi chuyển động / connections hiện có
			local function stopMovement()
				movementToken = movementToken + 1
				running = false
				if mainConn then
					mainConn:Disconnect()
					mainConn = nil
				end
				if teleportConn then
					teleportConn:Disconnect()
					teleportConn = nil
				end
				teleporting = false
				-- dropThread sẽ tự dừng vì check teleporting and token
			end
			
			-- nội bộ: an toàn lấy số time (>=1)
			local function getValidTime()
				local t = tonumber(timeBox.Text)
				if not t or t < 1 then
					timeBox.Text = "1"
					return 1
				end
				return t
			end
			
			-- Bắt đầu lunge tới targetPlayer (player instance)
			local function startLungeTo(targetPlayer)
				if not targetPlayer then
					toggleBtn.Text = "NOT FOUND"
					task.wait(0.7)
					toggleBtn.Text = "OFF"
					toggleBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
					return
				end
			
				-- đảm bảo minimum time
				local timeInterval = getValidTime()
			
				-- tăng token để hủy mọi chuyển động cũ
				movementToken = movementToken + 1
				local myToken = movementToken
			
				running = true
				toggleBtn.Text = "ON"
				toggleBtn.BackgroundColor3 = Color3.fromRGB(50,200,80)
			
				-- trạng thái drop control
				local currentDesiredY = nil
				local inDrop = false
				local firstDropDone = false
			
				-- start drop loop (runs while teleporting)
				local function startDropLoop()
					dropThread = coroutine.create(function()
						local localToken = myToken
						-- firstDelay: lần đầu tiên chờ max(1.5, 50% time) (không dưới 1.5s)
						local firstDelay = math.max(1.5, timeInterval * 0.5)
			
						-- loop: for first iteration wait firstDelay, then on subsequent wait full timeInterval
						while teleporting and movementToken == localToken do
							local waitDuration = firstDropDone and timeInterval or firstDelay
			
							-- wait waitDuration but break early if teleporting turned off or token changed
							local waited = 0
							while waited < waitDuration and teleporting and movementToken == localToken do
								local dt = RunService.Heartbeat:Wait()
								waited = waited + dt
							end
							if not teleporting or movementToken ~= localToken then break end
			
							-- perform drop: set inDrop true and set currentDesiredY instantly to targetY
							local tChar = targetPlayer.Character
							if not tChar then break end
							local tHrp = tChar:FindFirstChild("HumanoidRootPart")
							if not tHrp then break end
			
							inDrop = true
							-- set Y immediately to current target Y (and follow target Y while holding)
							currentDesiredY = tHrp.Position.Y
			
							-- hold for DROP_DURATION, during which we update currentDesiredY to follow targetY each frame
							local held = 0
							while held < DROP_DURATION and teleporting and movementToken == localToken do
								local dt = RunService.Heartbeat:Wait()
								held = held + dt
								local okTChar = targetPlayer.Character
								if okTChar then
									local okTHrp = okTChar:FindFirstChild("HumanoidRootPart")
									if okTHrp then
										currentDesiredY = okTHrp.Position.Y
									end
								end
							end
			
							-- end drop: set inDrop false and set Y immediately back to targetY + DROP_HEIGHT (follow that each frame)
							inDrop = false
							local okTChar = targetPlayer.Character
							if not okTChar then break end
							local okTHrp = okTChar:FindFirstChild("HumanoidRootPart")
							if not okTHrp then break end
							currentDesiredY = okTHrp.Position.Y + DROP_HEIGHT
			
							-- mark that first drop has happened (so next loop uses full timeInterval)
							firstDropDone = true
						end
					end)
					coroutine.resume(dropThread)
				end
			
				-- main loop: di chuyển (lunge) hoặc teleport tuỳ distance
				mainConn = RunService.Heartbeat:Connect(function(dt)
					-- hủy nếu token thay đổi
					if movementToken ~= myToken then
						mainConn:Disconnect()
						return
					end
			
					-- validate character & target
					local char = lp.Character
					local tChar = targetPlayer.Character
					if not (char and tChar) then return end
			
					local hrp = char:FindFirstChild("HumanoidRootPart")
					local tHrp = tChar:FindFirstChild("HumanoidRootPart")
					if not (hrp and tHrp) then return end
			
					-- baseY follow target each frame when not in drop (so no jitter)
					local baseY = tHrp.Position.Y + DROP_HEIGHT
					if currentDesiredY == nil then currentDesiredY = baseY end
			
					-- khoảng cách ngang (XZ)
					local dx = tHrp.Position.X - hrp.Position.X
					local dz = tHrp.Position.Z - hrp.Position.Z
					local horizDist = Vector3.new(dx, 0, dz).Magnitude
			
					-- nếu gần đích -> teleport mode
					if horizDist <= TELEPORT_DISTANCE then
						if not teleporting then
							teleporting = true
							-- ensure start at baseY
							currentDesiredY = baseY
							firstDropDone = false
							-- start drop loop
							startDropLoop()
			
							-- create RenderStepped connection để teleport 60/s theo cả XYZ (với Y được lấy từ currentDesiredY)
							teleportConn = RunService.RenderStepped:Connect(function()
								-- hủy khi token thay đổi
								if movementToken ~= myToken then
									if teleportConn then teleportConn:Disconnect() teleportConn = nil end
									teleporting = false
									return
								end
								-- update tHrp ref
								local okTChar = targetPlayer.Character
								if not okTChar then return end
								local okTHrp = okTChar:FindFirstChild("HumanoidRootPart")
								if not okTHrp then return end
			
								-- if not inDrop, keep currentDesiredY following targetY+DROP_HEIGHT each frame to avoid drift
								if not inDrop then
									currentDesiredY = okTHrp.Position.Y + DROP_HEIGHT
								end
			
								-- Follow target XZ and use currentDesiredY for Y -> this makes XYZ follow but with Y offset when not dropping
								local destPos = Vector3.new(okTHrp.Position.X, currentDesiredY, okTHrp.Position.Z)
								local offset = Vector3.new(0,0,2)
								local finalPos = destPos + offset
								hrp.CFrame = CFrame.new(finalPos)
							end)
						end
					else
						-- rời vùng -> tắt teleport và tiếp tục lunge ngang
						if teleporting then
							teleporting = false
							if teleportConn then
								teleportConn:Disconnect()
								teleportConn = nil
							end
							-- dropThread sẽ tự dừng vì teleporting = false
							currentDesiredY = baseY
						end
			
						-- Lunge ngang: di chuyển theo hướng ngang tới target, giữ Y = baseY
						local horizVec = Vector3.new(dx, 0, dz)
						local dist = horizVec.Magnitude
						if dist > 0.1 then
							local dir = horizVec.Unit
							local move = dir * (LUNGE_SPEED * dt)
							-- không overshoot
							if move.Magnitude > dist then
								move = dir * dist
							end
							local newPosXZ = Vector3.new(hrp.Position.X + move.X, baseY, hrp.Position.Z + move.Z)
							hrp.CFrame = CFrame.new(newPosXZ)
						else
							-- nếu đã rất gần (theo XZ) thì set thẳng đến baseY tại vị trí target XZ
							local snapPos = Vector3.new(tHrp.Position.X, baseY, tHrp.Position.Z)
							hrp.CFrame = CFrame.new(snapPos)
						end
					end
				end)
			end
			
			-- Toggle click
			toggleBtn.MouseButton1Click:Connect(function()
				if running then
					-- off
					stopMovement()
					toggleBtn.Text = "OFF"
					toggleBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
				else
					-- on: tìm target hiện tại trong textbox
					local target = findPlayer(box.Text)
					if not target then
						toggleBtn.Text = "NOT FOUND"
						task.wait(0.7)
						toggleBtn.Text = "OFF"
						toggleBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
						return
					end
					-- bắt đầu behavior
					startLungeTo(target)
				end
			end)
			
			-- Close button
			closeBtn.MouseButton1Click:Connect(function()
				stopMovement()
				gui:Destroy()
			end)
end

return function(mode)
    mode = tonumber(mode)

    if mode == 1 then
        TP.Mode1()
    elseif mode == 2 then
        TP.Mode2()
    end
end
