local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Player = game.Players:GetPlayers()[1] or game.Players.PlayerAdded:Wait()

local DataFolder = ReplicatedStorage.Data

local ingredientsBagData = require(DataFolder.ingredientsBagData)
local marketplaceData = require(DataFolder.marketplaceData)
local Manager = require(ServerScriptService.Server.PlayerData.Manager)
local DataService = require(ServerScriptService.Server.Modules.DataService)

local module = {}



local function updateBagAttributes(replica, equippedBag)
    local bagData = nil

    for i, bag in ipairs(ingredientsBagData or {}) do
        if bag.Name == equippedBag then
            bagData = bag
            break
        end
    end

    if bagData then
        replica.Data.Inventory.Ingredients.BagStackAmountMax = bagData.MaxStackAmount
        replica.Data.Inventory.Ingredients.BagSlots = bagData.Slots
        warn("Bag slots: " .. bagData.Slots)
        warn("Bag stack amount limit: " .. bagData.MaxStackAmount)
    end
end

function module:IsBagSlotsFull(player)
    DataService:GetReplica(Player):andThen(
        function(replica)
            if replica then
                local bagSlots = replica.Data.Inventory.Ingredients.BagSlots or 0
                local usedSlots = 0

                local ingredientsBag = replica.Data.Inventory.Ingredients.IngredientsBag
                if ingredientsBag then
                    for _, ingredientEntry in pairs(ingredientsBag) do
                        usedSlots = usedSlots + 1
                    end
                end

                return usedSlots >= bagSlots
            else
                print("Player data not found for player: " .. player.Name)
                return true -- Assume bag slots are full if player data is not found
            end
        end
    )
end

-- Returns whether the player's bag stack amount is full or not
function module:IsMaxStackAmountReached(player, ingredientName, callback)
    DataService:GetReplica(player):andThen(
        function(replica)
            if replica then
                local ingredientEntry = replica.Data.Inventory.Ingredients.IngredientsBag[ingredientName]
                if ingredientEntry then
                    local maxStackAmount = replica.Data.Inventory.Ingredients.BagStackAmountMax or 0
                    local currentStackAmount = ingredientEntry.Amount or 0

                    local isMaxStackAmountReached = currentStackAmount >= maxStackAmount
                    return isMaxStackAmountReached
                end
            else
                print("Player data not found for player: " .. player.Name)
            return true -- Assume max stack amount is reached if player data is not found
            end
        end
    )
end


function module:AddIngredientToInventory(ingredientName, amountToAdd)
    DataService:GetReplica(Player):andThen(function(replica)
        local playerInventory = replica.Data.Inventory.Ingredients.IngredientsBag
        local ingredientEntry = playerInventory[ingredientName]

        if ingredientEntry then
            local maxStacks = replica.Data.Inventory.Ingredients.BagSlots
            local maxStackAmount = replica.Data.Inventory.Ingredients.BagStackAmountMax

            if ingredientEntry.Amount >= maxStackAmount then
                -- Maximum number of stacks reached, cannot add more
                print("Maximum number of stacks reached for ingredient: " .. ingredientName)
                return
            end

            local remainingAmount = (maxStackAmount) - ingredientEntry.Amount
            local stacksToAdd = math.ceil(amountToAdd / maxStackAmount)

            if stacksToAdd > remainingAmount then
                stacksToAdd = remainingAmount
            end

            ingredientEntry.Amount = ingredientEntry.Amount + stacksToAdd 
        else
            
            playerInventory[ingredientName] = {Amount = amountToAdd}
        end

        replica:SetValue({ "Inventory", "Ingredients", "IngredientsBag" }, playerInventory)

        -- Print ingredient added to inventory
        print("Added " .. amountToAdd .. " " .. ingredientName .. " to inventory")
    end)
end



function module:Init()
    print("BagService Initialized2")

    local replica = Manager.PlayerProfiles[Player]
    if not replica then
        return
    end

    print(" Checking if this works! -_-")
    print(replica.Data)

    local equippedBag = replica.Data.IngredientsBag.EquippedBag

    if ingredientsBagData then
        updateBagAttributes(replica, equippedBag)
    else
        print("Error: ingredientsBagData table is not defined")
    end

    DataService:GetReplica(Player):andThen(
        function(replica)
            replica:ListenToChange(
                "Data",
                function(data)
                    if data.Inventory.Ingredients.Bag then
                        print("BagService Initialized 1")
                        print(data.Inventory.Ingredients.Bag)
                        print(data.Inventory.Ingredients.BagStackAmountMax)
                        print(data.Inventory.Ingredients.BagSlots)
                    end
                end
            )
            local equippedBag = replica.Data.IngredientsBag.EquippedBag

            if ingredientsBagData then
                updateBagAttributes(replica, equippedBag)
            else
                print("Error: ingredientsBagData table is not defined")
            end
        end
    )

    print("BagService Initialized 2")
end
return module
