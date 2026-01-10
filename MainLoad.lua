if _G.BloxFruit_Hub then
    warn("Script đã chạy! Không thể chạy lại.")
    return
end
_G.BloxFruit_Hub = true

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/MainUI.lua"))()

print("Main UI 1/10✅")

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Status.lua"))()

print("Status 2/10✅")

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Main.lua"))()

print("Main 3/10✅")

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Raid.lua"))()

print("Raid 4/10✅")

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Fruit.lua"))()

print("Fruit 5/10✅")

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Visual.lua"))()

print("Visual 6/10✅")

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Player%20Setting.lua"))()

print("Player Setting 7/10✅")

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Combat.lua"))()

print("Combat 8/10✅")

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Island.lua"))()

print("Island 9/10✅")

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Order.lua"))()

print("Order 10/10✅")

print(">================================================================================================<")
--=== UI SYSTEM ============================================================================================================================--

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM_UI/SystemUI.lua"))()

print("UI System 1/2✅")

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM_UI/ToggleUIEffect.lua"))()

print("Toggle UI Effect 2/2✅")

print(">================================================================================================<")
--=== TAB SYSTEM ============================================================================================================================--

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM/Status_System.lua"))()

print("Status tab System 1/7✅")

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM/Main_System.lua"))()

print("Main tab System 2/7✅")

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM/Raid_System.lua"))()

print("Raid tab System 3/7✅")

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM/Combat_System.lua"))()

print("Combat tab System 4/7✅")

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM/Player%20Setting_System.lua"))()

print("Player Setting tab System 5/7✅")

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM/Island_System.lua"))()

print("Island tab System 6/7✅")

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM/Fruit_System.lua"))()

print("Fruit tab System 7/7✅")

print("✅COMPLETE✅")

-- se
local BLOX_FRUITS_GAME_ID = 85211729168715
local BLOX_FRUITS_GAME_ID2 = 2753915549

local SECOND_SEA_GAME_ID = 79091703265657
local SECOND_SEA_GAME_ID2 = 4442272183

local THIRD_SEA_GAME_ID = 7449423635
local THIRD_SEA_GAME_ID2 = 100117331123089

local currentGameId = game.PlaceId
if currentGameId == BLOX_FRUITS_GAME_ID or currentGameId == BLOX_FRUITS_GAME_ID2 or currentGameId == SECOND_SEA_GAME_ID or currentGameId == SECOND_SEA_GAME_ID2 or currentGameId == THIRD_SEA_GAME_ID or currentGameId == THIRD_SEA_GAME_ID2 then

    local RunService = game:GetService("RunService")
    local player = game.Players.LocalPlayer

    local blockMain = Instance.new("Part")
    blockMain.Size = Vector3.new(500, 2.1, 500)
    blockMain.Anchored = true
    blockMain.Position = Vector3.new(0, 0, 0)
    blockMain.Transparency = 1
    blockMain.CanCollide = true
    blockMain.Parent = workspace

    local function updateBlockPosition(character)
        local hrp = character:WaitForChild("HumanoidRootPart")
        local humanoid = character:WaitForChild("Humanoid")

        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not character or not hrp then return end

            local playerPos = hrp.Position

            blockMain.Position = Vector3.new(playerPos.X, -5, playerPos.Z)
            local mainSurfaceY = blockMain.Position.Y + (blockMain.Size.Y / 2)

            if hrp.Position.Y < mainSurfaceY and hrp.Position.Y > blockMain.Position.Y - 250 then
                hrp.CFrame = CFrame.new(hrp.Position.X, mainSurfaceY + 5, hrp.Position.Z)
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)

        player.CharacterRemoving:Connect(function()
            if connection then connection:Disconnect() end
        end)
    end

    player.CharacterAdded:Connect(updateBlockPosition)
    if player.Character then
        updateBlockPosition(player.Character)
    end
    
    print("✅✅ Sea Protection Active (Single Layer) ✅✅")

else
    warn("⚠️ Script Sea Protection chỉ hoạt động trong game Blox Fruits.")
end
