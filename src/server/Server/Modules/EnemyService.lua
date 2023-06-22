local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local DataFolder = ReplicatedStorage.Data

local zonesData = require(DataFolder.zonesData)
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

-- Helper function to create a health bar GUI for an enemy model
local function createHealthBarGUI(model)
    local healthBarGUI = Instance.new("BillboardGui")
    healthBarGUI.Name = "HealthBarGUI"
    healthBarGUI.AlwaysOnTop = true
    healthBarGUI.Size = UDim2.new(4, 0, 0.2, 0)
    healthBarGUI.StudsOffsetWorldSpace = Vector3.new(0, 2, 0)
    healthBarGUI.Adornee = model

    local healthBarBackground = Instance.new("Frame")
    healthBarBackground.Name = "Background"
    healthBarBackground.BackgroundTransparency = 0.5
    healthBarBackground.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    healthBarBackground.BorderSizePixel = 0
    healthBarBackground.Size = UDim2.new(1, 0, 1, 0)
    healthBarBackground.Parent = healthBarGUI

    local healthBarFill = Instance.new("Frame")
    healthBarFill.Name = "Fill"
    healthBarFill.BackgroundTransparency = 0
    healthBarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthBarFill.BorderSizePixel = 0
    healthBarFill.Size = UDim2.new(1, 0, 1, 0)
    healthBarFill.Parent = healthBarBackground

    healthBarGUI.Parent = model
end

-- Helper function to update the health bar GUI for an enemy model
local function updateHealthBarGUI(model, healthPercent)
    local healthBarGUI = getHealthBarGUI(model)
    if healthBarGUI then
        local healthBarFill = healthBarGUI:FindFirstChild("Background"):FindFirstChild("Fill")
        if healthBarFill then
            healthBarFill.Size = UDim2.new(healthPercent, 0, 1, 0)
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

-- Helper function to spawn an enemy with a given CFrame
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
