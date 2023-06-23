local EasyNetwork = require(game:GetService("ReplicatedStorage").Libs.Network)
local DataService = require(game:GetService("ServerScriptService").Server.Modules.DataService)
local MarketplaceService = game:GetService("MarketplaceService")
local Player = game:GetService("Players").LocalPlayer or game:GetService("Players").PlayerAdded:Wait()

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local levelUpEffect = ReplicatedStorage.Assets.Prefabs.LevelUp

local LevelService = {}

-- CONSTANTS
local DOUBLE_EXP_PASS_ID = 194254402
local CURRENT_MAX_LEVEL = 100

local function hasDoubleExp(player, callback)
    DataService:GetReplica(player):andThen(function(replica)
        local gamepasses = replica.Data.Inventory.Gamepasses
        if gamepasses[DOUBLE_EXP_PASS_ID] then
            callback(true)
            return
        end

        local playerPasses = game:GetService("MarketplaceService"):GetPlayerPassesAsync(player.UserId)
        for _, pass in pairs(playerPasses) do
            if pass.PassId == DOUBLE_EXP_PASS_ID then
                callback(true)
                print(Player.Name .." has double exp pass")
                return
            end
        end

        callback(false)
        print(Player.Name .." does not have double exp pass")
    end)
end

local function calculateLevel(level)
    return math.ceil((level * (level / 12) * math.log((level + 1) ^ 2)) * 300)
end

function LevelService:showLevelUpEffect()
    local character = Player.Character
    if not character then
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return
    end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        return
    end

    -- Spawn the effect below the player's feet
    local effect = levelUpEffect:Clone()
    effect.CFrame = rootPart.CFrame * CFrame.new(0, -rootPart.Size.Y / 2, 0)
    effect.Parent = workspace

    -- Make the effect collide only with the player
    local touchPart = effect:FindFirstChild("TouchPart")
    if touchPart then
        touchPart.Touched:Connect(function(part)
            if part.Parent == character then
                effect.CanCollide = false
            end
        end)
    end

    -- Set a timeout to anchor the effect after a few seconds
    wait(3)  -- Adjust the duration as needed
    effect.Anchored = true

    -- Delete the effect after a certain time
    wait(5)  -- Adjust the duration as needed
    effect:Destroy()
end

function LevelService:levelUp()
    DataService:GetReplica(Player):andThen(function(replica)
        local currentLevel = replica.Data.Level
        local maxLevel = CURRENT_MAX_LEVEL

        if currentLevel >= maxLevel then
            print("Player is already max level, cannot level up, returning")
            return
        end

        local exp = replica.Data.Exp
        local requiredExp = calculateLevel(currentLevel + 1)

        if exp >= requiredExp then
            -- Level up logic
            replica:SetValue("Level", currentLevel + 1)
            replica:SetValue("Exp", exp - requiredExp)

            replica:SetValue("StatPoints", replica.Data.StatPoints + 5)

            -- Check for double exp
            hasDoubleExp(Player, function(hasDouble)
                local gainedExp = requiredExp
                if hasDouble then
                    gainedExp = gainedExp * 2
                end
                replica:SetValue("GainedExp", gainedExp)

                -- Show level up effect
                LevelService:showLevelUpEffect()
            end)
        end
    end)
end


--- conncetions

EasyNetwork:BindEvents({
    LevelUP = function(client)
        LevelService:levelUp()
    end
})

return LevelService
