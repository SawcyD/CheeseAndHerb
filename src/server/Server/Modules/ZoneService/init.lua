-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local ServerScriptService = game:GetService("ServerScriptService")
local TweenService = game:GetService("TweenService")
local Player = game.Players:GetPlayers()[1] or game.Players.PlayerAdded:Wait()

local DataFolder = ReplicatedStorage.Data

local ingredientsData = require(DataFolder.ingredientsData)
local zonesData = require(DataFolder.zonesData)

local Manager = require(ServerScriptService.Server.PlayerData.Manager)
local BagService = require(ServerScriptService.Server.Modules.BagService)
local DataService = require(ServerScriptService.Server.Modules.DataService)


local module = {}
local ingredientInstances = {} 

-- Selects a random ingredient from a list of ingredients based on their spawn rates
local function selectRandomIngredient(ingredientList)
    local totalWeight = 0
    for _, ingredientData in ipairs(ingredientList) do
        totalWeight = totalWeight + ingredientData.SpawnRate
    end

    local randomWeight = math.random() * totalWeight
    local cumulativeWeight = 0

    for _, ingredientData in ipairs(ingredientList) do
        cumulativeWeight = cumulativeWeight + ingredientData.SpawnRate
        if cumulativeWeight >= randomWeight then
            return ingredientData.Name
        end
    end

    return nil
end

-- Spawns an ingredient at a given position with a fade-in animation
local function spawnIngredient(ingredientName, position, orientation, parent)
    -- print("Spawning ingredient: " .. ingredientName .. " at position: " .. tostring(position))

    local ingredientCount = ingredientInstances[ingredientName] or 0
    if ingredientCount >= 10 then
        print("Maximum limit reached for ingredient: " .. ingredientName)
        return
    end

    local ingredientData = ingredientsData[ingredientName]
    if not ingredientData then
        print("No data found for ingredient: " .. ingredientName)
        return
    end

    local spawnRate = ingredientData.SpawnRate or 1 -- Default spawn rate of 1 if not specified
    local respawnDelay = 1 / spawnRate -- Inverse of the spawn rate to determine the delay

    local ingredientModel = ReplicatedStorage.Assets.Ingredients:FindFirstChild(ingredientName)
    if not ingredientModel then
        print("No model found for ingredient: " .. ingredientName)
        return
    end

    local zonePart = parent.Parent -- Assuming the parent is the zone part
    local zoneSize = zonePart.Size

    local randomX = position.X + (math.random() - 0.5) * zoneSize.X
    local randomY = position.Y -- Adjust this if you have a height offset
    local randomZ = position.Z + (math.random() - 0.5) * zoneSize.Z

    local ingredientInstance = ingredientModel:Clone()
    ingredientInstance.Name = ingredientName
    ingredientInstance.Position = Vector3.new(randomX, randomY, randomZ)
    ingredientInstance.Orientation = orientation
    ingredientInstance.Transparency = 1 -- Set initial transparency to 1 (fully transparent)
    ingredientInstance.Parent = parent

    -- Create BillboardGui for ingredient name
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "IngredientNameGui"
    billboardGui.AlwaysOnTop = true
    billboardGui.Size = UDim2.new(0, 100, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.Parent = ingredientInstance

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "IngredientNameLabel"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = ingredientInstance.BrickColor.Color
    textLabel.TextStrokeTransparency = 0.75
    textLabel.Font = Enum.Font.FredokaOne
    textLabel.FontSize = Enum.FontSize.Size14
    textLabel.TextScaled = true
    textLabel.Text = ingredientName
    textLabel.Parent = billboardGui

    ingredientInstances[ingredientName] = ingredientCount + 1
    

    -- Perform fade-in animation
    local transparency = 1 -- Start with full transparency
    local fadeDuration = 1 -- Adjust the duration as needed

    local tweenInfo = TweenInfo.new(fadeDuration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(ingredientInstance, tweenInfo, {Transparency = 0})
    tween:Play()

        -- Check if adding the ingredient will exceed the max stack amount


    -- Check for collision with player
    ingredientInstance.Touched:Connect(function(part)
        local player = game.Players:GetPlayerFromCharacter(part.Parent)
        if player then
            BagService:AddIngredientToInventory(ingredientName, 1)
            if BagService:IsMaxStackAmountReached(Player, ingredientName) then
                print("Max stack amount reached for ingredient: " .. ingredientName)
                return
            end
            if BagService:IsBagSlotsFull(Player) then
                print("Player's bag slots are full. Cannot collect ingredient: " .. ingredientName)
                return
            end

            ingredientInstances[ingredientName] = ingredientInstances[ingredientName] - 1
            ingredientInstance:Destroy()

            -- Start the respawn timer
            local respawnDelay = 5 -- Adjust the delay as needed
            task.spawn(function()
                module:respawnIngredient(ingredientName, position, orientation, parent, respawnDelay)
            end)
        end
    end)
end


function module:respawnIngredient(ingredientName, position, orientation, parent, respawnDelay)
    task.wait(respawnDelay)

    local ingredientCount = ingredientInstances[ingredientName] or 0
    if ingredientCount >= 10 then
        print("Maximum limit reached for ingredient: " .. ingredientName)
        return
    end

    spawnIngredient(ingredientName, position, orientation, parent)
end

function module:spawnIngredientToZone(zoneTagName)
    local taggedZones = CollectionService:GetTagged(zoneTagName)
    if #taggedZones == 0 then
        print("No zones found with the tag: " .. zoneTagName)
        return
    end

    -- Spawn ingredients in all zones with a given tag
    for _, randomZone in ipairs(taggedZones) do
        local zoneName = randomZone.Name

        local ingredientList = {}
        for _, ingredientName in ipairs(zonesData[zoneName].IngredientNames) do
            local ingredientData = ingredientsData[ingredientName]
            if ingredientData then
                table.insert(ingredientList, {
                    Name = ingredientName,
                    SpawnRate = ingredientData.SpawnRate
                })
            end
        end

        for i = 1, 30 do
            local ingredientName = selectRandomIngredient(ingredientList)
            if not ingredientName then
                print("No ingredients found for zone: " .. zoneName)
                break
            end

            local ingredientCount = ingredientInstances[ingredientName] or 0
            if ingredientCount >= 10 then
                print("Maximum limit reached for ingredient: " .. ingredientName)
                break
            end

            local zonePosition = randomZone.Position + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))
            local zoneOrientation = randomZone.Orientation

            spawnIngredient(ingredientName, zonePosition, zoneOrientation, randomZone["Ingredients"])

        
            ingredientInstances[ingredientName] = ingredientCount + 1
        end
    end
end

function module:Init()
    print("From ZoneService:Init()")
    
    module:spawnIngredientToZone("Zone")
end

return module