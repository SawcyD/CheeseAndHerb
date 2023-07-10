local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local DataFolder = ReplicatedStorage.Data

local zonesData = require(DataFolder.zonesData)
local enemiesData = require(DataFolder.enemiesData)
local EnemyService = {}

local enemyModels = {} -- Stores the enemy models

-- Configuration
local enemyDetectionRadius = 20 -- Radius within which enemies can detect the player
local enemyAttackRadius = 10 -- Radius within which enemies can attack the player
local enemyRetreatThreshold = 0.25 -- Health threshold at which enemies retreat

local enemyWalkSpeed = 10 -- Speed at which enemies move
local enemyAttackCooldown = 3 -- Cooldown time between enemy attacks
local enemyBlockChance = 0.25 -- Chance of enemies blocking player attacks

-- Helper function to get the humanoid from a model
local function getHumanoid(model)
    return model:FindFirstChildOfClass("Humanoid")
end

-- Helper function to get the healthbar GUI for an enemy model
local function getHealthBarGUI(model)
    return model:FindFirstChild("HealthBarGUI")
end

local function getEnemyData(enemyName)
    return enemiesData[enemyName]
end

-- Helper function to create a health bar GUI for an enemy model
-- Helper function to create a health bar GUI for an enemy model
local function createHealthBarGUI(model)
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "HealthBarGUI"
    billboardGui.Adornee = model.PrimaryPart
    billboardGui.Size = UDim2.new(2, 0, 2, 0)
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.MaxDistance = 100

    local frame = Instance.new("Frame")
    frame.Name = "Container"
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 0.2, 0)
    frame.Position = UDim2.new(0, 0, 0, -30)
    frame.Parent = billboardGui

    local background = Instance.new("Frame")
    background.Name = "Background"
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0.8
    background.BorderSizePixel = 0
    background.Size = UDim2.new(1, 0, 1, 0)
    background.Parent = frame

    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.Parent = background

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 14
    nameLabel.TextWrapped = true
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Position = UDim2.new(0, 5, 0, 0)
    nameLabel.Parent = frame

    local healthLabel = Instance.new("TextLabel")
    healthLabel.Name = "HealthLabel"
    healthLabel.BackgroundTransparency = 1
    healthLabel.Font = Enum.Font.SourceSansBold
    healthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthLabel.TextSize = 14
    healthLabel.TextWrapped = true
    healthLabel.Size = UDim2.new(1, -10, 0.5, 0)
    healthLabel.Position = UDim2.new(0, 5, 0.5, 0)
    healthLabel.TextXAlignment = Enum.TextXAlignment.Right
    healthLabel.Parent = frame

    billboardGui.Parent = model
end

-- Helper function to update the health bar GUI for an enemy model
local function updateHealthBarGUI(model, healthPercent)
    local healthBarGUI = getHealthBarGUI(model)
    if healthBarGUI then
        local container = healthBarGUI:FindFirstChild("Container")
        local fill = container:FindFirstChild("Background"):FindFirstChild("Fill")
        local healthLabel = container:FindFirstChild("HealthLabel")
        if container and fill and healthLabel then
            fill.Size = UDim2.new(healthPercent, 0, 1, 0)
            healthLabel.Text = string.format("%.0f / %.0f", model.Humanoid.Health, model.Humanoid.MaxHealth)
        end
    end
end

-- Helper function to handle enemy attack logic
local function handleEnemyAttack(enemyModel)
    local humanoid = getHumanoid(enemyModel)
    if humanoid then
        local target = humanoid.Target
        if target then
            -- Perform the attack logic here
            print("Enemy is attacking:", target.Name)
        end
    end
end

-- Helper function to handle enemy retreat logic
local function handleEnemyRetreat(enemyModel)
    local humanoid = getHumanoid(enemyModel)
    if humanoid and humanoid.Health / humanoid.MaxHealth < enemyRetreatThreshold then
        -- Perform the retreat logic here
        print("Enemy is retreating")
    end
end

-- Helper function to handle enemy block logic
local function handleEnemyBlock(enemyModel)
    local humanoid = getHumanoid(enemyModel)
    if humanoid and CollectionService:HasTag(enemyModel, "BlockingDummy") and math.random() <= enemyBlockChance then
        -- Perform the block logic here
        print("Enemy is blocking")
    end
end


-- Helper function to handle enemy movement logic
local function handleEnemyMovement(enemyModel, playerCharacter)
    local humanoid = getHumanoid(enemyModel)
    if humanoid and playerCharacter then
        local enemyHumanoidRootPart = enemyModel:FindFirstChild("HumanoidRootPart")
        local playerHumanoidRootPart = playerCharacter:FindFirstChild("HumanoidRootPart")
        if enemyHumanoidRootPart and playerHumanoidRootPart then
            local distance = (enemyHumanoidRootPart.Position - playerHumanoidRootPart.Position).Magnitude
            if distance <= enemyAttackRadius then
                humanoid:MoveTo(playerHumanoidRootPart.Position)
                humanoid.WalkSpeed = enemyWalkSpeed
            elseif distance <= enemyDetectionRadius then
                humanoid:MoveTo(playerHumanoidRootPart.Position)
                humanoid.WalkSpeed = enemyWalkSpeed
                handleEnemyRetreat(enemyModel)
            else
                humanoid:MoveTo(enemyModel.PrimaryPart.Position)
                humanoid.WalkSpeed = enemyWalkSpeed
            end
        end
    end
end

-- Helper function to update enemy behavior
local function updateEnemyBehavior(enemyModel, playerCharacter)
    local humanoid = getHumanoid(enemyModel)
    if humanoid and playerCharacter then
        if humanoid.Health > 0 then
            handleEnemyBlock(enemyModel)
            handleEnemyMovement(enemyModel, playerCharacter)
            handleEnemyAttack(enemyModel)
        else
            humanoid:MoveTo(enemyModel.PrimaryPart.Position)
        end
    end
end

local function spawnEnemy(enemyName, cframe, parent)
    local enemyModel = ReplicatedStorage.Assets.Enemies:FindFirstChild(enemyName)
    if not enemyModel then
        print("No model found for enemy: " .. enemyName)
        return
    end

    local enemyInstance = enemyModel:Clone()
    enemyInstance.Name = enemyName
    enemyInstance:SetPrimaryPartCFrame(cframe)
    enemyInstance.Parent = parent

    -- Create health bar GUI for the enemy
    createHealthBarGUI(enemyInstance)

    -- Get enemy data and set health if available
    local enemyData = getEnemyData(enemyName)
    if enemyData and enemyData.Health then
        local humanoid = getHumanoid(enemyInstance)
        if humanoid then
            humanoid.MaxHealth = enemyData.Health
            humanoid.Health = enemyData.Health
        end
    end

    table.insert(enemyModels, enemyInstance)

    print("Enemy: " .. enemyName .. " spawned successfully.")
end

-- Function to spawn enemies in a given zone
function EnemyService:spawnEnemiesInZone(zoneTagName)
    local taggedZones = CollectionService:GetTagged(zoneTagName)
    if #taggedZones == 0 then
        print("No zones found with the tag: " .. zoneTagName)
        return
    end

    -- Spawn enemies in all zones with the given tag
    for _, zonePart in ipairs(taggedZones) do
        local zoneName = zonePart.Name

        local enemyList = zonesData[zoneName].Enemies
        if not enemyList then
            print("No enemy list found for zone: " .. zoneName)
            break
        end

        for _, enemyName in ipairs(enemyList) do
            local enemyCount = #CollectionService:GetTagged(enemyName)
            if enemyCount >= 10 then
                print("Maximum limit reached for enemy: " .. enemyName)
                break
            end

            local zonePosition = zonePart.Position + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))
            local zoneOrientation = zonePart.Orientation
            local cframe = CFrame.new(zonePosition) * CFrame.Angles(math.rad(zoneOrientation.X), math.rad(zoneOrientation.Y), math.rad(zoneOrientation.Z))

            spawnEnemy(enemyName, cframe, zonePart["Enemies"])
        end
    end
end

-- Event handler for enemy models being added
local function onEnemyModelAdded(enemyModel)
    local humanoid = getHumanoid(enemyModel)
    if humanoid then
        humanoid.HealthChanged:Connect(function()
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            updateHealthBarGUI(enemyModel, healthPercent)
        end)
    end
end

function EnemyService:SetUp()
    -- Initialize the enemy service
    self:Initialize()
    self:spawnEnemiesInZone("Zone")

end

function EnemyService:StartUpdating(playerCharacter)
    self:StopUpdating() -- Stop any previous updates

    self.updateConnection = game:GetService("RunService").Heartbeat:Connect(function()
        for _, enemyModel in ipairs(enemyModels) do
            updateEnemyBehavior(enemyModel, playerCharacter)
        end
    end)
end

function EnemyService:StopUpdating()
    if self.updateConnection then
        self.updateConnection:Disconnect()
        self.updateConnection = nil
    end
end



-- Initialize the enemy service
function EnemyService:Initialize()
    for _, enemyModel in ipairs(CollectionService:GetTagged("Enemies")) do
        table.insert(enemyModels, enemyModel)
        createHealthBarGUI(enemyModel)
        onEnemyModelAdded(enemyModel)
    end
end
return EnemyService
