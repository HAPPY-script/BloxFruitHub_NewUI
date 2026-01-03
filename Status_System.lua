-- MOON ================================================================================================================
do
    local Players = game:GetService("Players")
    local Lighting = game:GetService("Lighting")

    -- ===== UI PATH (theo UI mới) =====
    local ScrollingTab = Players.LocalPlayer
        .PlayerGui
        :WaitForChild("BloxFruitHubGui")
        :WaitForChild("Main")
        :WaitForChild("ScrollingTab")

    local StatusFrame = ScrollingTab:WaitForChild("Status")
    local MoonImage = StatusFrame:WaitForChild("MoonStatus") -- ImageLabel có sẵn

    -- ===== CONFIG Moon Image =====
    MoonImage.ScaleType = Enum.ScaleType.Stretch
    MoonImage.Rotation = 180

    -- ===== Utils =====
    local function extractIdFromUrl(url)
        return url and string.match(url, "%d+")
    end

    -- ===== Update Moon Image =====
    local currentSky

    local function updateMoonImage()
        if not currentSky then
            MoonImage.Image = ""
            return
        end

        local id = extractIdFromUrl(currentSky.MoonTextureId)
        if id then
            MoonImage.Image = "rbxthumb://type=Asset&id=" .. id .. "&w=150&h=150"
        else
            MoonImage.Image = ""
        end
    end

    -- ===== Init Sky =====
    currentSky = Lighting:FindFirstChildOfClass("Sky")
    if currentSky then
        currentSky:GetPropertyChangedSignal("MoonTextureId"):Connect(updateMoonImage)
    end

    -- ===== Listen Sky changes =====
    Lighting.ChildAdded:Connect(function(child)
        if child:IsA("Sky") then
            currentSky = child
            child:GetPropertyChangedSignal("MoonTextureId"):Connect(updateMoonImage)
            updateMoonImage()
        end
    end)

    Lighting.ChildRemoved:Connect(function(child)
        if child == currentSky then
            currentSky = nil
            MoonImage.Image = ""
        end
    end)

    -- ===== First update =====
    updateMoonImage()
end

-- COUNT PLAYER ===============================================================================================================
